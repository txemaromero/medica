import 'package:sqflite/sqflite.dart';

import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../data/base_datos.dart';
import '../domain/registro_toma.dart';

abstract interface class TomaRepository {
  /// Registros cuyos días están entre [desde] y [hasta], ambos incluidos.
  Future<List<RegistroToma>> obtenerEntre(DateTime desde, DateTime hasta);

  /// Guarda el registro de una toma; si ya había uno para esa toma, lo
  /// sustituye (por ejemplo, una aplazada que después se toma).
  Future<void> guardar(RegistroToma registro);

  Future<void> borrar(int medicamentoId, DateTime fecha, HoraDelDia hora);
}

class TomaRepositorySqlite implements TomaRepository {
  TomaRepositorySqlite(this._db);

  /// La base de datos o una transacción (ver `RestauracionDatosSqlite`).
  final DatabaseExecutor _db;

  static const String _tabla = BaseDatos.tablaTomas;

  @override
  Future<List<RegistroToma>> obtenerEntre(
    DateTime desde,
    DateTime hasta,
  ) async {
    final filas = await _db.query(
      _tabla,
      where: 'fecha >= ? AND fecha <= ?',
      whereArgs: [FormatoFechas.isoFecha(desde), FormatoFechas.isoFecha(hasta)],
      orderBy: 'fecha ASC, hora ASC',
    );
    return filas.map(_desdeFila).toList();
  }

  @override
  Future<void> guardar(RegistroToma registro) => _db.insert(_tabla, {
    'medicamento_id': registro.medicamentoId,
    'nombre_medicamento': registro.nombreMedicamento,
    'fecha': FormatoFechas.isoFecha(registro.fecha),
    'hora': registro.hora.minutosDesdeMedianoche,
    'estado': registro.estado.name,
    'momento': registro.momento.millisecondsSinceEpoch,
    'recordar_en': registro.recordarEn?.millisecondsSinceEpoch,
  }, conflictAlgorithm: ConflictAlgorithm.replace);

  @override
  Future<void> borrar(int medicamentoId, DateTime fecha, HoraDelDia hora) =>
      _db.delete(
        _tabla,
        where: 'medicamento_id = ? AND fecha = ? AND hora = ?',
        whereArgs: [
          medicamentoId,
          FormatoFechas.isoFecha(fecha),
          hora.minutosDesdeMedianoche,
        ],
      );

  static RegistroToma _desdeFila(Map<String, Object?> fila) => RegistroToma(
    medicamentoId: fila['medicamento_id']! as int,
    nombreMedicamento: fila['nombre_medicamento']! as String,
    fecha: FormatoFechas.desdeIsoFecha(fila['fecha']! as String),
    hora: HoraDelDia.desdeMinutos(fila['hora']! as int),
    estado: EstadoToma.values.byName(fila['estado']! as String),
    momento: DateTime.fromMillisecondsSinceEpoch(fila['momento']! as int),
    recordarEn: switch (fila['recordar_en']) {
      final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
      _ => null,
    },
  );
}
