import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../notificaciones/sincronizador_avisos.dart';
import '../../ajustes/application/ajustes_controller.dart';
import '../../medicamentos/domain/medicamento.dart';
import '../domain/registro_toma.dart';

/// Registros de tomas de los últimos [diasHistorial] días (y de mañana, por
/// si hay algún aplazamiento que cruza la medianoche). Tras cada cambio se
/// reprograman los avisos: una toma marcada ya no suena ni se repite.
class TomasController extends AsyncNotifier<List<RegistroToma>> {
  static const int diasHistorial = 7;

  @override
  Future<List<RegistroToma>> build() {
    final hoy = FormatoFechas.soloFecha(ref.watch(relojProvider)());
    return ref
        .watch(tomaRepositoryProvider)
        .obtenerEntre(_primerDia(hoy), _ultimoDia(hoy));
  }

  static DateTime _primerDia(DateTime hoy) =>
      DateTime(hoy.year, hoy.month, hoy.day - (diasHistorial - 1));

  static DateTime _ultimoDia(DateTime hoy) =>
      DateTime(hoy.year, hoy.month, hoy.day + 1);

  Future<RegistroToma?> _registroActual(
    int medicamentoId,
    DateTime fecha,
    HoraDelDia hora,
  ) async {
    final registros = await ref
        .read(tomaRepositoryProvider)
        .obtenerEntre(fecha, fecha);
    return buscarRegistro(registros, medicamentoId, fecha, hora);
  }

  /// Marca la toma como tomada. Devuelve el registro que había antes (o
  /// `null`), para poder deshacer.
  Future<RegistroToma?> marcarTomada(
    Medicamento medicamento,
    DateTime fecha,
    HoraDelDia hora,
  ) async {
    final anterior = await _registroActual(medicamento.id, fecha, hora);
    await ref
        .read(tomaRepositoryProvider)
        .guardar(
          RegistroToma(
            medicamentoId: medicamento.id,
            nombreMedicamento: medicamento.nombre,
            fecha: FormatoFechas.soloFecha(fecha),
            hora: hora,
            estado: EstadoToma.tomada,
            momento: ref.read(relojProvider)(),
          ),
        );
    await _recargarYSincronizar();
    return anterior;
  }

  /// Quita la marca de una toma (por si se marcó por error). Devuelve el
  /// registro eliminado, para poder deshacer.
  Future<RegistroToma?> desmarcar(
    int medicamentoId,
    DateTime fecha,
    HoraDelDia hora,
  ) async {
    final anterior = await _registroActual(medicamentoId, fecha, hora);
    await ref.read(tomaRepositoryProvider).borrar(medicamentoId, fecha, hora);
    await _recargarYSincronizar();
    return anterior;
  }

  /// Pide que se vuelva a avisar de esta toma dentro de los minutos elegidos
  /// en Ajustes (`Ajustes.minutosAplazamiento`). Devuelve cuándo.
  Future<DateTime> aplazar(
    Medicamento medicamento,
    DateTime fecha,
    HoraDelDia hora,
  ) async {
    final ahora = ref.read(relojProvider)();
    final cuando = ahora.add(
      Duration(minutes: ref.read(ajustesProvider).minutosAplazamiento),
    );
    await ref
        .read(tomaRepositoryProvider)
        .guardar(
          RegistroToma(
            medicamentoId: medicamento.id,
            nombreMedicamento: medicamento.nombre,
            fecha: FormatoFechas.soloFecha(fecha),
            hora: hora,
            estado: EstadoToma.aplazada,
            momento: ahora,
            recordarEn: cuando,
          ),
        );
    await _recargarYSincronizar();
    return cuando;
  }

  /// Deja la toma como estaba: con [registro], o sin registro si es `null`.
  Future<void> restaurar({
    required int medicamentoId,
    required DateTime fecha,
    required HoraDelDia hora,
    RegistroToma? registro,
  }) async {
    final repositorio = ref.read(tomaRepositoryProvider);
    if (registro == null) {
      await repositorio.borrar(medicamentoId, fecha, hora);
    } else {
      await repositorio.guardar(registro);
    }
    await _recargarYSincronizar();
  }

  Future<void> _recargarYSincronizar() async {
    final hoy = FormatoFechas.soloFecha(ref.read(relojProvider)());
    state = AsyncData(
      await ref
          .read(tomaRepositoryProvider)
          .obtenerEntre(_primerDia(hoy), _ultimoDia(hoy)),
    );
    // Los avisos se ponen al día detrás, sin hacer esperar a la pantalla.
    unawaited(ref.read(sincronizadorAvisosProvider).sincronizar());
  }
}

final tomasProvider =
    AsyncNotifierProvider<TomasController, List<RegistroToma>>(
      TomasController.new,
    );
