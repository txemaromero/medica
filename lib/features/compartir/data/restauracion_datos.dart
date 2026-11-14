import 'package:sqflite/sqflite.dart';

import '../../../data/base_datos.dart';
import '../../agenda/data/cita_repository.dart';
import '../../agenda/domain/cita.dart';
import '../../medicamentos/data/medicamento_repository.dart';
import '../../medicamentos/domain/medicamento.dart';
import '../../tomas/data/toma_repository.dart';
import '../../tomas/domain/registro_toma.dart';

/// Sustituye de una vez todos los medicamentos, citas y tomas, al recuperar
/// una copia: o se guarda todo o no cambia nada. Si fallara a mitad (por
/// ejemplo, con el almacenamiento lleno), el teléfono se queda como estaba,
/// en vez de con los datos borrados y la copia a medias.
abstract interface class RestauracionDatos {
  Future<void> reemplazarTodo({
    required List<Medicamento> medicamentos,
    required List<Cita> citas,
    required List<RegistroToma> tomas,
  });
}

/// Con una transacción de SQLite y los mismos repositorios que el resto de
/// la app, trabajando sobre ella.
class RestauracionDatosSqlite implements RestauracionDatos {
  RestauracionDatosSqlite(this._db);

  final Database _db;

  @override
  Future<void> reemplazarTodo({
    required List<Medicamento> medicamentos,
    required List<Cita> citas,
    required List<RegistroToma> tomas,
  }) => _db.transaction((transaccion) async {
    for (final tabla in [
      BaseDatos.tablaMedicamentos,
      BaseDatos.tablaCitas,
      BaseDatos.tablaTomas,
    ]) {
      await transaccion.delete(tabla);
    }
    final repositorioMedicamentos = MedicamentoRepositorySqlite(transaccion);
    for (final m in medicamentos) {
      await repositorioMedicamentos.restaurar(m);
    }
    final repositorioCitas = CitaRepositorySqlite(transaccion);
    for (final c in citas) {
      await repositorioCitas.restaurar(c);
    }
    final repositorioTomas = TomaRepositorySqlite(transaccion);
    for (final t in tomas) {
      await repositorioTomas.guardar(t);
    }
  });
}
