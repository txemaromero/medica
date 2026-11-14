import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../tomas/application/tomas_controller.dart';
import '../../tomas/data/toma_repository.dart';
import '../../tomas/domain/registro_toma.dart';
import '../domain/existencias.dart';
import '../domain/medicamento.dart';
import 'medicamentos_controller.dart';

/// Los registros de tomas que hacen falta para calcular las existencias de
/// [medicamentos] (ninguno si ninguno lleva la cuenta).
Future<List<RegistroToma>> registrosParaExistencias(
  TomaRepository tomas,
  List<Medicamento> medicamentos,
  DateTime ahora,
) async {
  final desde = CalculoExistencias.registrosDesde(medicamentos);
  if (desde == null) return const [];
  final hoy = FormatoFechas.soloFecha(ahora);
  return tomas.obtenerEntre(desde, DateTime(hoy.year, hoy.month, hoy.day + 1));
}

/// Cómo van las existencias de cada medicamento que lleva la cuenta, por su
/// `id`.
Future<Map<int, EstadoExistencias>> calcularExistencias(
  TomaRepository tomas,
  List<Medicamento> medicamentos,
  DateTime ahora,
) async {
  final registros = await registrosParaExistencias(tomas, medicamentos, ahora);
  return {
    for (final m in medicamentos)
      m.id: ?CalculoExistencias.estado(m, registros, ahora),
  };
}

/// Existencias de los medicamentos, para las pantallas. Se recalculan al
/// cambiar los medicamentos o las tomas, y al volver a una pantalla que las
/// usa (con el paso del tiempo se van descontando tomas).
final existenciasProvider =
    FutureProvider.autoDispose<Map<int, EstadoExistencias>>((ref) async {
      final medicamentos = await ref.watch(medicamentosProvider.future);
      ref.watch(tomasProvider);
      return calcularExistencias(
        ref.watch(tomaRepositoryProvider),
        medicamentos,
        ref.watch(relojProvider)(),
      );
    });
