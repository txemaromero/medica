import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../app/rutas.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/campo_texto.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/interruptor_grande.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../l10n/textos.dart';
import '../application/ajustes_controller.dart';
import '../domain/validador_familiar.dart';
import 'estado_avisos_tarjeta.dart';
import 'explicaciones_avisos.dart';

/// Pantalla 8: ajustes de sonido, vibración, notificaciones, repetición de
/// los avisos, avisos discretos, lectura en voz alta, número de emergencia,
/// contacto de un familiar, tamaño de texto y tema, y acceso a compartir y
/// copias de seguridad. Los cambios se guardan al momento.
class AjustesScreen extends ConsumerStatefulWidget {
  const AjustesScreen({super.key});

  @override
  ConsumerState<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends ConsumerState<AjustesScreen> {
  late final TextEditingController _numero;
  late final TextEditingController _familiarNombre;
  late final TextEditingController _familiarNumero;
  String? _errorNumero;
  ErroresFamiliar _erroresFamiliar = const ErroresFamiliar();

  @override
  void initState() {
    super.initState();
    final ajustes = ref.read(ajustesProvider);
    _numero = TextEditingController(text: ajustes.numeroEmergencia);
    _familiarNombre = TextEditingController(text: ajustes.familiarNombre);
    _familiarNumero = TextEditingController(text: ajustes.familiarNumero);
  }

  @override
  void dispose() {
    _numero.dispose();
    _familiarNombre.dispose();
    _familiarNumero.dispose();
    super.dispose();
  }

  AjustesController get _controlador => ref.read(ajustesProvider.notifier);

  Future<void> _cambiarSonido(bool valor) async {
    await _controlador.cambiarSonido(valor);
    if (mounted) {
      mostrarAviso(
        context,
        valor
            ? TextosApp.of(context).ajustesSonidosActivados
            : TextosApp.of(context).ajustesSonidosDesactivados,
      );
    }
  }

  Future<void> _cambiarVibracion(bool valor) async {
    await _controlador.cambiarVibracion(valor);
    if (mounted) {
      mostrarAviso(
        context,
        valor
            ? TextosApp.of(context).ajustesVibracionActivada
            : TextosApp.of(context).ajustesVibracionDesactivada,
      );
    }
  }

  Future<void> _cambiarAvisosDiscretos(bool valor) async {
    await _controlador.cambiarAvisosDiscretos(valor);
    if (mounted) {
      mostrarAviso(
        context,
        valor
            ? TextosApp.of(context).ajustesAvisosDiscretosActivados
            : TextosApp.of(context).ajustesAvisosDiscretosDesactivados,
      );
    }
  }

  Future<void> _cambiarNotificaciones(bool valor) async {
    final resultado = await _controlador.cambiarNotificaciones(valor);
    if (!mounted) return;
    await explicarResultadoNotificaciones(context, _controlador, resultado);
  }

  Future<void> _cambiarLectura(bool valor) async {
    final hecho = await _controlador.cambiarLecturaEnVozAlta(valor);
    if (!mounted) return;
    final t = TextosApp.of(context);
    if (hecho) {
      mostrarAviso(
        context,
        valor ? t.ajustesLecturaActivada : t.ajustesLecturaDesactivada,
      );
      return;
    }
    await mostrarConfirmacion(
      context,
      titulo: t.ajustesSinVozTitulo,
      mensaje: defaultTargetPlatform == TargetPlatform.iOS
          ? t.ajustesSinVozMensajeIphone
          : t.ajustesSinVozMensaje,
      textoBoton: t.dialogoEntendido,
      icono: Icons.volume_off,
    );
  }

  /// Pide al teléfono que ponga el widget; si no sabe, explica cómo
  /// ponerlo a mano.
  Future<void> _ponerWidget() async {
    final pedido = await ref.read(servicioWidgetProvider).pedirAnadir();
    if (pedido || !mounted) return;
    final t = TextosApp.of(context);
    await mostrarConfirmacion(
      context,
      titulo: t.ajustesWidget,
      mensaje: t.ajustesWidgetManual(t.appTitulo),
      textoBoton: t.dialogoEntendido,
      icono: Icons.widgets,
    );
  }

  Future<void> _guardarNumero() async {
    FocusScope.of(context).unfocus();
    final error = await _controlador.guardarNumeroEmergencia(_numero.text);
    if (!mounted) return;
    setState(() => _errorNumero = error);
    if (error == null) {
      _numero.text = ref.read(ajustesProvider).numeroEmergencia;
      mostrarAviso(
        context,
        TextosApp.of(context).ajustesNumeroGuardado(_numero.text),
      );
    }
  }

  Future<void> _guardarFamiliar() async {
    FocusScope.of(context).unfocus();
    final errores = await _controlador.guardarFamiliar(
      nombre: _familiarNombre.text,
      numero: _familiarNumero.text,
    );
    if (!mounted) return;
    setState(() => _erroresFamiliar = errores);
    if (!errores.sinErrores) return;
    final t = TextosApp.of(context);
    final ajustes = ref.read(ajustesProvider);
    _familiarNombre.text = ajustes.familiarNombre;
    _familiarNumero.text = ajustes.familiarNumero;
    mostrarAviso(
      context,
      ajustes.tieneFamiliar
          ? t.ajustesContactoGuardado(
              ajustes.familiarNombre,
              ajustes.familiarNumero,
            )
          : t.ajustesContactoBorrado,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ajustes = ref.watch(ajustesProvider);
    final t = TextosApp.of(context);

    return PantallaBase(
      titulo: t.menuAjustes,
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Parrafo(t.ajustesCambiosAlMomento),
          const Hueco(),
          InterruptorGrande(
            etiqueta: t.ajustesActivarSonidos,
            descripcion: t.ajustesActivarSonidosDescripcion,
            valor: ajustes.sonidoActivado,
            onChanged: _cambiarSonido,
          ),
          const Hueco(),
          InterruptorGrande(
            etiqueta: t.ajustesActivarVibracion,
            descripcion: t.ajustesActivarVibracionDescripcion,
            valor: ajustes.vibracionActivada,
            onChanged: _cambiarVibracion,
          ),
          const Hueco(),
          InterruptorGrande(
            etiqueta: t.ajustesActivarNotificaciones,
            descripcion: t.ajustesActivarNotificacionesDescripcion,
            valor: ajustes.notificacionesActivadas,
            onChanged: _cambiarNotificaciones,
          ),
          const EstadoAvisosTarjeta(),
          const Hueco(),
          BotonGrande(
            etiqueta: t.ajustesProbarAviso,
            descripcion: t.ajustesProbarAvisoDescripcion,
            icono: Icons.notifications_active,
            onPressed: () => probarAviso(context, _controlador),
          ),
          const Hueco(),
          BotonGrande(
            etiqueta: t.ajustesRepetirAvisos,
            descripcion: t.ajustesRepetirAvisosDescripcion(
              t.avisoAplazar(ajustes.minutosAplazamiento),
            ),
            icono: Icons.snooze,
            onPressed: () =>
                Navigator.of(context).pushNamed(Rutas.repetirAvisos),
          ),
          const Hueco(),
          InterruptorGrande(
            etiqueta: t.ajustesAvisosDiscretos,
            descripcion: t.ajustesAvisosDiscretosDescripcion,
            valor: ajustes.avisosDiscretos,
            onChanged: _cambiarAvisosDiscretos,
          ),
          const Hueco(),
          InterruptorGrande(
            etiqueta: t.ajustesLeerEnVozAlta,
            descripcion: t.ajustesLeerEnVozAltaDescripcion,
            valor: ajustes.leerEnVozAlta,
            onChanged: _cambiarLectura,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          CampoTexto(
            etiqueta: t.ajustesNumeroEmergencia,
            descripcion: t.ajustesNumeroEmergenciaDescripcion,
            controller: _numero,
            error: _errorNumero,
            teclado: TextInputType.phone,
            accion: TextInputAction.done,
            formateadores: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
            ],
            onSubmitted: (_) => _guardarNumero(),
          ),
          const SizedBox(height: 12),
          BotonGrande(
            etiqueta: t.ajustesGuardarNumero,
            icono: Icons.save,
            onPressed: _guardarNumero,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          CampoTexto(
            etiqueta: t.ajustesNombreFamiliar,
            descripcion: t.ajustesNombreFamiliarDescripcion,
            controller: _familiarNombre,
            error: _erroresFamiliar.nombre,
            capitalizacion: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          CampoTexto(
            etiqueta: t.ajustesTelefonoFamiliar,
            controller: _familiarNumero,
            error: _erroresFamiliar.numero,
            teclado: TextInputType.phone,
            accion: TextInputAction.done,
            formateadores: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
            ],
            onSubmitted: (_) => _guardarFamiliar(),
          ),
          const SizedBox(height: 12),
          BotonGrande(
            etiqueta: t.ajustesGuardarContacto,
            descripcion: t.ajustesGuardarContactoDescripcion,
            icono: Icons.person_add,
            onPressed: _guardarFamiliar,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          // El widget solo existe en Android.
          if (defaultTargetPlatform == TargetPlatform.android) ...[
            BotonGrande(
              etiqueta: t.ajustesWidget,
              descripcion: t.ajustesWidgetDescripcion(t.tomasMarcar),
              icono: Icons.widgets,
              onPressed: _ponerWidget,
            ),
            const Hueco(),
          ],
          BotonGrande(
            etiqueta: t.ajustesTamanoTexto,
            descripcion: t.ajustesTamanoTextoDescripcion,
            icono: Icons.format_size,
            onPressed: () => Navigator.of(context).pushNamed(Rutas.tamanoTexto),
          ),
          const Hueco(),
          BotonGrande(
            etiqueta: t.ajustesTema,
            descripcion: t.ajustesTemaDescripcion,
            icono: Icons.palette,
            onPressed: () => Navigator.of(context).pushNamed(Rutas.tema),
          ),
          const Hueco(),
          BotonGrande(
            etiqueta: t.compartirTitulo,
            descripcion: t.ajustesCompartirDescripcion,
            icono: Icons.share,
            onPressed: () => Navigator.of(context).pushNamed(Rutas.compartir),
          ),
        ],
      ),
    );
  }
}
