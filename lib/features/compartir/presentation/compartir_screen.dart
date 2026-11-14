import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tema/tema_visual.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/interruptor_grande.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../l10n/textos.dart';
import '../../ajustes/application/ajustes_controller.dart';
import '../application/servicio_compartir.dart';
import '../domain/copia_de_seguridad.dart';

/// Compartir la medicación con el médico o la familia (PDF), hacer o
/// recuperar copias de seguridad y añadir los medicamentos que un familiar
/// ha preparado en su móvil.
class CompartirScreen extends ConsumerStatefulWidget {
  const CompartirScreen({super.key});

  @override
  ConsumerState<CompartirScreen> createState() => _CompartirScreenState();
}

class _CompartirScreenState extends ConsumerState<CompartirScreen> {
  /// Mientras se prepara un documento, los botones esperan.
  bool _ocupado = false;

  ServicioCompartir get _servicio => ref.read(servicioCompartirProvider);

  TextosApp get _t => TextosApp.of(context);

  /// Ejecuta [accion] con los botones bloqueados; si falla, lo explica.
  Future<void> _hacer(
    Future<void> Function() accion, {
    required String error,
  }) async {
    if (_ocupado) return;
    setState(() => _ocupado = true);
    try {
      await accion();
    } on Object {
      if (mounted) mostrarAviso(context, error, icono: Icons.error);
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _enviarInforme() =>
      _hacer(_servicio.compartirInforme, error: _t.compartirErrorDocumento);

  Future<void> _imprimir() =>
      _hacer(_servicio.imprimirInforme, error: _t.compartirErrorImprimir);

  Future<void> _guardarCopia() => _hacer(() async {
    final guardada = await _servicio.guardarCopia();
    if (guardada && mounted) {
      mostrarAviso(context, _t.compartirCopiaGuardada);
    }
  }, error: _t.compartirErrorGuardarCopia);

  Future<void> _enviarCopia() =>
      _hacer(_servicio.enviarCopia, error: _t.compartirErrorEnviarCopia);

  Future<void> _recuperar() => _hacer(() async {
    final CopiaDeSeguridad? copia;
    try {
      copia = await _servicio.elegirCopia();
    } on CopiaNoValida catch (error) {
      if (!mounted) return;
      await mostrarConfirmacion(
        context,
        titulo: _t.compartirNoSePuedeRecuperar,
        mensaje: error.mensaje,
        textoBoton: _t.dialogoEntendido,
        icono: Icons.error_outline,
      );
      return;
    }
    if (copia == null || !mounted) return;
    final actual = await _servicio.resumenActual();
    if (!mounted) return;
    final t = _t;
    final creada = copia.creada;
    final sustitucion = actual == null
        ? t.compartirSustitucionVacio
        : t.compartirSustitucion(actual);
    // Los teléfonos se dicen siempre: van a parar a los botones de
    // Emergencias, y la copia puede venir de otro móvil.
    final ajustes = copia.ajustes;
    final familiar = ajustes.tieneFamiliar
        ? [
            if (ajustes.familiarNombre.trim().isNotEmpty)
              ajustes.familiarNombre,
            ajustes.familiarNumero,
          ].join(', ')
        : null;
    final seguir = await preguntar(
      context,
      titulo: t.compartirPreguntaRecuperar,
      mensaje: [
        t.compartirCopiaDel(
          FormatoFechas.fechaLarga(creada),
          HoraDelDia(creada.hour, creada.minute).texto,
          copia.resumen,
        ),
        ajustes.tieneNumeroEmergencia
            ? t.compartirCopiaEmergencia(ajustes.numeroEmergencia)
            : t.compartirCopiaSinEmergencia,
        familiar == null
            ? t.compartirCopiaSinFamiliar
            : t.compartirCopiaFamiliar(familiar),
        '',
        sustitucion,
      ].join('\n'),
      textoSi: t.compartirSiRecuperar,
      textoNo: t.dialogoNoVolver,
      icono: Icons.restore,
    );
    if (!seguir || !mounted) return;
    await _servicio.recuperar(copia);
    if (!mounted) return;
    final avisos = ref.read(ajustesProvider).notificacionesActivadas;
    await mostrarConfirmacion(
      context,
      titulo: _t.compartirCopiaRecuperada,
      mensaje: [
        _t.compartirYaTienes(copia.resumen),
        if (!avisos) ...['', _t.compartirAvisosDesactivados],
      ].join('\n'),
    );
  }, error: _t.compartirErrorRecuperar);

  Future<void> _cambiarRecordatorio(bool activado) async {
    await ref
        .read(ajustesProvider.notifier)
        .cambiarRecordatorioResumen(activado);
    if (!mounted) return;
    // Sin los avisos activados no llegaría.
    if (activado && !ref.read(ajustesProvider).notificacionesActivadas) {
      mostrarAviso(context, _t.compartirAvisosDesactivados);
    }
  }

  Future<void> _importar() => _hacer(() async {
    final CopiaDeSeguridad? copia;
    try {
      copia = await _servicio.elegirCopia();
    } on CopiaNoValida catch (error) {
      if (!mounted) return;
      await mostrarConfirmacion(
        context,
        titulo: _t.importarNoSePuede,
        mensaje: error.mensaje,
        textoBoton: _t.dialogoEntendido,
        icono: Icons.error_outline,
      );
      return;
    }
    if (copia == null || !mounted) return;
    final importacion = await _servicio.prepararImportacion(copia);
    if (!mounted) return;
    final t = _t;
    if (importacion.vacia) {
      await mostrarConfirmacion(
        context,
        titulo: t.importarNadaNuevo,
        mensaje: t.importarNadaNuevoMensaje,
        textoBoton: t.dialogoEntendido,
      );
      return;
    }
    final creada = copia.creada;
    final seguir = await preguntar(
      context,
      titulo: t.importarPregunta,
      mensaje: [
        t.importarCopiaDel(
          FormatoFechas.fechaLarga(creada),
          HoraDelDia(creada.hour, creada.minute).texto,
        ),
        '',
        ...importacion.describir(),
        '',
        t.importarNoSeBorra,
      ].join('\n'),
      textoSi: t.importarSi,
      textoNo: t.dialogoNoVolver,
      icono: Icons.playlist_add,
    );
    if (!seguir || !mounted) return;
    await _servicio.importar(importacion, copia);
    final resumen = await _servicio.resumenActual();
    if (!mounted) return;
    final avisos = ref.read(ajustesProvider).notificacionesActivadas;
    await mostrarConfirmacion(
      context,
      titulo: _t.importarHecho,
      mensaje: [
        if (resumen != null) _t.compartirYaTienes(resumen),
        if (!avisos) ...['', _t.compartirAvisosDesactivados],
      ].join('\n'),
    );
  }, error: _t.importarError);

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = _t;
    final recordar = ref.watch(
      ajustesProvider.select((a) => a.recordarResumen),
    );
    VoidCallback? si(VoidCallback accion) => _ocupado ? null : accion;

    return PantallaBase(
      titulo: t.compartirTitulo,
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            container: true,
            header: true,
            child: Text(t.compartirParaElMedico, style: textos.titleLarge),
          ),
          const SizedBox(height: 8),
          Parrafo(t.compartirParaElMedicoExplicacion),
          const Hueco(),
          BotonGrande(
            etiqueta: t.compartirEnviarInforme,
            descripcion: t.compartirEnviarInformeDescripcion,
            icono: Icons.send,
            onPressed: si(_enviarInforme),
          ),
          const Hueco(),
          BotonGrande(
            etiqueta: t.compartirImprimir,
            descripcion: t.compartirImprimirDescripcion,
            icono: Icons.print,
            onPressed: si(_imprimir),
          ),
          const Hueco(),
          InterruptorGrande(
            etiqueta: t.compartirRecordarResumen,
            descripcion: t.compartirRecordarResumenDescripcion,
            valor: recordar,
            onChanged: _cambiarRecordatorio,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          Semantics(
            container: true,
            header: true,
            child: Text(t.compartirCopiaDeSeguridad, style: textos.titleLarge),
          ),
          const SizedBox(height: 8),
          Parrafo(t.compartirCopiaExplicacion(t.compartirRecuperar)),
          const Hueco(),
          BotonGrande(
            etiqueta: t.compartirGuardarCopia,
            descripcion: t.compartirGuardarCopiaDescripcion,
            icono: Icons.save,
            onPressed: si(_guardarCopia),
          ),
          const Hueco(),
          BotonGrande(
            etiqueta: t.compartirEnviarCopia,
            descripcion: t.compartirEnviarCopiaDescripcion,
            icono: Icons.forward_to_inbox,
            onPressed: si(_enviarCopia),
          ),
          const Hueco(),
          BotonGrande(
            etiqueta: t.compartirRecuperar,
            descripcion: t.compartirRecuperarDescripcion,
            icono: Icons.restore,
            onPressed: si(_recuperar),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          Semantics(
            container: true,
            header: true,
            child: Text(t.compartirDeOtroMovil, style: textos.titleLarge),
          ),
          const SizedBox(height: 8),
          Parrafo(t.compartirDeOtroMovilExplicacion(t.compartirEnviarCopia)),
          const Hueco(),
          BotonGrande(
            etiqueta: t.compartirImportar,
            descripcion: t.compartirImportarDescripcion,
            icono: Icons.playlist_add,
            onPressed: si(_importar),
          ),
          if (_ocupado) ...[
            const Hueco(),
            Semantics(
              container: true,
              liveRegion: true,
              child: Text(
                t.compartirUnMomento,
                textAlign: TextAlign.center,
                style: textos.titleMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
