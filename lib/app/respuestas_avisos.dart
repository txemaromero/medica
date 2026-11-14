import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/tiempo/hora_del_dia.dart';
import '../features/tomas/application/tomas_controller.dart';
import '../l10n/textos.dart';
import '../notificaciones/carga_aviso.dart';
import '../voz/textos_para_leer.dart';
import 'proveedores.dart';
import 'rutas.dart';

/// Qué hacer después de atender una respuesta a un aviso: a qué pantalla ir,
/// qué mensaje mostrar y qué leer en voz alta (si está activado).
class ResultadoRespuesta {
  const ResultadoRespuesta({required this.ruta, this.mensaje, this.lectura});

  final String ruta;
  final String? mensaje;
  final String? lectura;
}

/// Atiende lo que la persona hace con una notificación (o con el widget de
/// la pantalla de inicio, que llega igual):
/// - "Ya la he tomado": marca la toma y lleva a "Tomas de hoy".
/// - "Recordar en 10 min" (o los minutos elegidos en Ajustes): aplaza la
///   toma y lleva a "Tomas de hoy".
/// - Tocar un aviso de toma o de cita: abre "Tomas de hoy" o la agenda.
/// - Tocar el de que quedan pocas pastillas o el de renovar la receta: abre
///   la lista de medicamentos, donde están "He comprado más" y "Ya la he
///   renovado".
/// - Tocar el recordatorio del resumen: abre "Compartir".
///
/// Los avisos no llevan la fecha (los diarios son el mismo todos los días):
/// el día de la toma es el de la última vez que llegó su hora.
class ProcesadorRespuestas {
  ProcesadorRespuestas(this._ref);

  final Ref _ref;

  static String mensajeTomada(String nombre, HoraDelDia hora) =>
      textosApp.tomasAnotada(nombre, hora.texto);

  static String mensajeAplazada(DateTime cuando) =>
      textosApp.respuestaAplazada(HoraDelDia(cuando.hour, cuando.minute).texto);

  static String get mensajeSinMedicamento => textosApp.respuestaSinMedicamento;

  Future<ResultadoRespuesta?> procesar(RespuestaAviso respuesta) async {
    switch (CargaAviso.decodificar(respuesta.carga)) {
      case null:
        return null;
      case CargaExistencias() || CargaReceta():
        return const ResultadoRespuesta(ruta: Rutas.listaMedicamentos);
      case CargaResumen():
        return const ResultadoRespuesta(ruta: Rutas.compartir);
      case CargaCita(:final citaId):
        final citas = await _ref.read(citaRepositoryProvider).obtenerTodas();
        final cita = citas.where((c) => c.id == citaId).firstOrNull;
        return ResultadoRespuesta(
          ruta: Rutas.agenda,
          lectura: cita == null
              ? null
              : TextosParaLeer.cita(cita, _ref.read(relojProvider)()),
        );
      case CargaToma(:final medicamentoId, :final hora, fecha: final dia):
        final medicamentos = await _ref
            .read(medicamentoRepositoryProvider)
            .obtenerTodos();
        final medicamento = medicamentos
            .where((m) => m.id == medicamentoId)
            .firstOrNull;
        if (medicamento == null) {
          return ResultadoRespuesta(
            ruta: Rutas.tomasHoy,
            mensaje: mensajeSinMedicamento,
            lectura: mensajeSinMedicamento,
          );
        }
        final fecha = dia ?? hora.ultimoDiaHasta(_ref.read(relojProvider)());
        final tomas = _ref.read(tomasProvider.notifier);
        switch (respuesta.accion) {
          case AccionesAviso.tomada:
            await tomas.marcarTomada(medicamento, fecha, hora);
            final mensaje = mensajeTomada(medicamento.nombre, hora);
            return ResultadoRespuesta(
              ruta: Rutas.tomasHoy,
              mensaje: mensaje,
              lectura: mensaje,
            );
          case AccionesAviso.aplazar:
            final cuando = await tomas.aplazar(medicamento, fecha, hora);
            final mensaje = mensajeAplazada(cuando);
            return ResultadoRespuesta(
              ruta: Rutas.tomasHoy,
              mensaje: mensaje,
              lectura: mensaje,
            );
          default:
            return ResultadoRespuesta(
              ruta: Rutas.tomasHoy,
              lectura: TextosParaLeer.toma(medicamento, hora),
            );
        }
    }
  }
}

final procesadorRespuestasProvider = Provider<ProcesadorRespuestas>(
  ProcesadorRespuestas.new,
);
