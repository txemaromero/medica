import 'package:sqflite/sqflite.dart';

import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../data/base_datos.dart';
import '../domain/cita.dart';

abstract interface class CitaRepository {
  /// Todas las citas, ordenadas cronológicamente.
  Future<List<Cita>> obtenerTodas();

  Future<Cita> crear(NuevaCita nueva);

  /// Guarda los cambios de una cita existente (mismo `id`).
  Future<void> actualizar(Cita cita);

  Future<void> eliminar(int id);

  /// Vuelve a guardar una cita eliminada (acción "Deshacer") con su `id`.
  Future<void> restaurar(Cita cita);
}

class CitaRepositorySqlite implements CitaRepository {
  CitaRepositorySqlite(this._db);

  /// La base de datos o una transacción (ver `RestauracionDatosSqlite`).
  final DatabaseExecutor _db;

  static const String _tabla = BaseDatos.tablaCitas;

  @override
  Future<List<Cita>> obtenerTodas() async {
    final filas = await _db.query(
      _tabla,
      orderBy: 'fecha ASC, hora ASC, id ASC',
    );
    return filas.map(_desdeFila).toList();
  }

  @override
  Future<Cita> crear(NuevaCita nueva) async {
    final datos = _aFila(
      titulo: nueva.titulo,
      fecha: nueva.fecha,
      hora: nueva.hora,
      lugar: nueva.lugar,
      notas: nueva.notas,
    );
    final id = await _db.insert(_tabla, datos);
    return _desdeFila({...datos, 'id': id});
  }

  @override
  Future<void> actualizar(Cita cita) => _db.update(
    _tabla,
    _aFila(
      titulo: cita.titulo,
      fecha: cita.fecha,
      hora: cita.hora,
      lugar: cita.lugar,
      notas: cita.notas,
    ),
    where: 'id = ?',
    whereArgs: [cita.id],
  );

  @override
  Future<void> eliminar(int id) =>
      _db.delete(_tabla, where: 'id = ?', whereArgs: [id]);

  @override
  Future<void> restaurar(Cita cita) => _db.insert(_tabla, {
    'id': cita.id,
    ..._aFila(
      titulo: cita.titulo,
      fecha: cita.fecha,
      hora: cita.hora,
      lugar: cita.lugar,
      notas: cita.notas,
    ),
  }, conflictAlgorithm: ConflictAlgorithm.replace);

  static Map<String, Object?> _aFila({
    required String titulo,
    required DateTime fecha,
    required HoraDelDia hora,
    String? lugar,
    String? notas,
  }) => {
    'titulo': titulo.trim(),
    'fecha': FormatoFechas.isoFecha(fecha),
    'hora': hora.minutosDesdeMedianoche,
    'lugar': _opcional(lugar),
    'notas': _opcional(notas),
  };

  static String? _opcional(String? texto) {
    final limpio = texto?.trim() ?? '';
    return limpio.isEmpty ? null : limpio;
  }

  static Cita _desdeFila(Map<String, Object?> fila) => Cita(
    id: fila['id']! as int,
    titulo: fila['titulo']! as String,
    fecha: FormatoFechas.desdeIsoFecha(fila['fecha']! as String),
    hora: HoraDelDia.desdeMinutos(fila['hora']! as int),
    lugar: fila['lugar'] as String?,
    notas: fila['notas'] as String?,
  );
}
