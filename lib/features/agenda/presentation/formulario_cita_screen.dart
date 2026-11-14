import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/campo_texto.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/mensaje_error.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/selectores_tiempo.dart';
import '../../../l10n/textos.dart';
import '../../../voz/boton_dictar.dart';
import '../../ajustes/application/ajustes_controller.dart';
import '../application/citas_controller.dart';
import '../domain/cita.dart';
import '../domain/recordatorios_cita.dart';
import '../domain/validador_cita.dart';

/// Pantalla 6: formulario para crear una cita o, si se le pasa [cita], para
/// modificar una ya guardada.
class FormularioCitaScreen extends ConsumerStatefulWidget {
  const FormularioCitaScreen({super.key, this.cita});

  final Cita? cita;

  /// Hasta cuántos años en el futuro se puede apuntar una cita.
  static const int aniosMaximos = 5;

  @override
  ConsumerState<FormularioCitaScreen> createState() =>
      _FormularioCitaScreenState();
}

class _FormularioCitaScreenState extends ConsumerState<FormularioCitaScreen> {
  final _titulo = TextEditingController();
  final _lugar = TextEditingController();
  final _notas = TextEditingController();
  final _claveTitulo = GlobalKey();
  final _claveFecha = GlobalKey();
  final _claveHora = GlobalKey();

  late DateTime _hoy;
  late DateTime _fecha;
  HoraDelDia _hora = const HoraDelDia(10, 0);
  ErroresCita _errores = const ErroresCita();
  bool _guardando = false;

  bool get _modificando => widget.cita != null;

  @override
  void initState() {
    super.initState();
    _hoy = FormatoFechas.soloFecha(ref.read(relojProvider)());
    _fecha = _hoy;
    final cita = widget.cita;
    if (cita != null) {
      _titulo.text = cita.titulo;
      _lugar.text = cita.lugar ?? '';
      _notas.text = cita.notas ?? '';
      _fecha = cita.fecha;
      _hora = cita.hora;
    }
  }

  @override
  void dispose() {
    _titulo.dispose();
    _lugar.dispose();
    _notas.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_guardando) return;
    FocusScope.of(context).unfocus();
    final errores = ValidadorCita.validar(
      titulo: _titulo.text,
      fecha: _fecha,
      hora: _hora,
      lugar: _lugar.text,
      notas: _notas.text,
      ahora: ref.read(relojProvider)(),
    );
    setState(() => _errores = errores);
    if (!errores.sinErrores) {
      // El error se muestra junto al campo (y TalkBack lo anuncia); se
      // desplaza la pantalla hasta él para que se vea.
      final clave = errores.titulo != null
          ? _claveTitulo
          : errores.fecha != null
          ? _claveFecha
          : _claveHora;
      final campo = clave.currentContext;
      if (campo != null) {
        await Scrollable.ensureVisible(
          campo,
          duration: const Duration(milliseconds: 300),
        );
      }
      return;
    }

    setState(() => _guardando = true);
    final datos = NuevaCita(
      titulo: _titulo.text.trim(),
      fecha: _fecha,
      hora: _hora,
      lugar: _lugar.text,
      notas: _notas.text,
    );
    final controlador = ref.read(citasProvider.notifier);
    final Cita cita;
    try {
      final original = widget.cita;
      if (original == null) {
        cita = await controlador.crear(datos);
      } else {
        cita = original.conDatos(datos);
        await controlador.actualizar(cita);
      }
    } on Object {
      if (mounted) {
        setState(() => _guardando = false);
        mostrarAviso(
          context,
          TextosApp.of(context).formularioCitaErrorGuardar,
          icono: Icons.error,
        );
      }
      return;
    }
    if (!mounted) return;

    final t = TextosApp.of(context);
    final avisosActivos = ref.read(ajustesProvider).notificacionesActivadas;
    final recordatorios = RecordatoriosCita.calcular(
      cita,
      ahora: ref.read(relojProvider)(),
    );
    final textoAvisos = !avisosActivos
        ? t.avisosDesactivadosEnAjustes
        : recordatorios.isEmpty
        ? t.formularioCitaMuyPronto
        : t.formularioCitaTeAvisaremos(_describirAvisos(t, recordatorios));
    await mostrarConfirmacion(
      context,
      titulo: _modificando
          ? t.formularioCambiosGuardados
          : t.formularioCitaGuardada,
      mensaje:
          '${t.formularioCitaResumenGuardada(cita.titulo, FormatoFechas.fechaRelativa(cita.fecha, _hoy), cita.hora.texto)}'
          '\n\n$textoAvisos',
    );
    if (mounted) Navigator.of(context).pop();
  }

  static String _describirAvisos(TextosApp t, List<AvisoCita> avisos) =>
      FormatoFechas.lista([
        for (final a in avisos)
          switch (a.tipo) {
            TipoAvisoCita.diaAntes => t.formularioCitaAvisoDiaAntes(
              RecordatoriosCita.horaAvisoDiaAntes.texto,
            ),
            TipoAvisoCita.mismoDia => t.formularioCitaAvisoMismoDia(
              RecordatoriosCita.horaAvisoMismoDia.texto,
            ),
            TipoAvisoCita.unaHoraAntes => t.formularioCitaAvisoUnaHoraAntes,
          },
      ]);

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final textoBoton = _modificando
        ? t.formularioGuardarCambios
        : t.formularioCitaGuardar;
    return PantallaBase(
      titulo: _modificando
          ? t.formularioCitaTituloModificar
          : t.agendaCrearCita,
      pie: BotonGrande(
        etiqueta: _guardando ? t.formularioGuardando : textoBoton,
        icono: Icons.save,
        centrado: true,
        onPressed: _guardando ? null : _guardar,
      ),
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Parrafo(t.formularioRellenaYPulsa(textoBoton)),
          const Hueco(),
          CampoTexto(
            key: _claveTitulo,
            etiqueta: t.formularioCitaMotivo,
            descripcion: t.formularioCitaMotivoDescripcion,
            controller: _titulo,
            error: _errores.titulo,
            accion: TextInputAction.done,
          ),
          BotonDictar(
            controller: _titulo,
            etiqueta: t.formularioCitaDictarMotivo,
            indicacion: t.formularioCitaDictarMotivoIndicacion,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          SelectorFecha(
            key: _claveFecha,
            etiqueta: t.formularioCitaFecha,
            descripcion: t.formularioCitaFechaDescripcion,
            fecha: _fecha,
            hoy: _hoy,
            primerDia: _hoy,
            ultimoDia: DateTime(
              _hoy.year + FormularioCitaScreen.aniosMaximos,
              _hoy.month,
              _hoy.day,
            ),
            conError: _errores.fecha != null,
            onChanged: (fecha) => setState(() => _fecha = fecha),
          ),
          if (_errores.fecha != null) MensajeError(_errores.fecha!),
          const Hueco(alto: Medidas.separacion * 1.5),
          SelectorHora(
            key: _claveHora,
            etiqueta: t.formularioCitaHora,
            descripcion: t.formularioCitaHoraDescripcion,
            hora: _hora,
            conError: _errores.hora != null,
            onChanged: (hora) => setState(() => _hora = hora),
          ),
          if (_errores.hora != null) MensajeError(_errores.hora!),
          const Hueco(alto: Medidas.separacion * 1.5),
          CampoTexto(
            etiqueta: t.formularioCitaLugar,
            descripcion: t.formularioCitaLugarDescripcion,
            controller: _lugar,
            error: _errores.lugar,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          CampoTexto(
            etiqueta: t.formularioCitaNotas,
            descripcion: t.formularioCitaNotasDescripcion,
            controller: _notas,
            error: _errores.notas,
            lineas: 3,
            accion: TextInputAction.newline,
            teclado: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}
