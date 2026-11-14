import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../core/texto/ordenacion.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../data/base_datos.dart';
import '../domain/dias_de_toma.dart';
import '../domain/existencias.dart';
import '../domain/medicamento.dart';

abstract interface class MedicamentoRepository {
  /// Todos los medicamentos, ordenados alfabéticamente por nombre.
  Future<List<Medicamento>> obtenerTodos();

  Future<Medicamento> crear(NuevoMedicamento nuevo);

  /// Guarda los cambios de un medicamento existente (mismo `id`).
  Future<void> actualizar(Medicamento medicamento);

  Future<void> eliminar(int id);

  /// Vuelve a guardar un medicamento eliminado (acción "Deshacer")
  /// conservando su `id`, y con él los identificadores de sus avisos.
  Future<void> restaurar(Medicamento medicamento);
}

class MedicamentoRepositorySqlite implements MedicamentoRepository {
  MedicamentoRepositorySqlite(this._db, {DateTime Function()? reloj})
    : _reloj = reloj ?? DateTime.now;

  /// La base de datos o una transacción (ver `RestauracionDatosSqlite`).
  final DatabaseExecutor _db;
  final DateTime Function() _reloj;

  static const String _tabla = BaseDatos.tablaMedicamentos;

  @override
  Future<List<Medicamento>> obtenerTodos() async {
    final filas = await _db.query(_tabla);
    return filas.map(_desdeFila).toList()..sort((a, b) {
      final porNombre = compararTextos(a.nombre, b.nombre);
      return porNombre != 0 ? porNombre : a.id.compareTo(b.id);
    });
  }

  @override
  Future<Medicamento> crear(NuevoMedicamento nuevo) async {
    // La base de datos guarda milisegundos: se redondea antes para que el
    // objeto devuelto sea igual al que se leerá después.
    final fechaCreacion = DateTime.fromMillisecondsSinceEpoch(
      _reloj().millisecondsSinceEpoch,
    );
    final sinId = Medicamento.desdeDatos(
      id: 0,
      fechaCreacion: fechaCreacion,
      datos: nuevo,
    );
    final id = await _db.insert(_tabla, _aFila(sinId)..remove('id'));
    return Medicamento.desdeDatos(
      id: id,
      fechaCreacion: fechaCreacion,
      datos: nuevo,
    );
  }

  @override
  Future<void> actualizar(Medicamento medicamento) => _db.update(
    _tabla,
    _aFila(medicamento),
    where: 'id = ?',
    whereArgs: [medicamento.id],
  );

  @override
  Future<void> eliminar(int id) =>
      _db.delete(_tabla, where: 'id = ?', whereArgs: [id]);

  @override
  Future<void> restaurar(Medicamento medicamento) => _db.insert(
    _tabla,
    _aFila(medicamento),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  static Map<String, Object?> _aFila(Medicamento m) => {
    'id': m.id,
    'nombre': m.nombre,
    'num_tomas': m.numTomas,
    'frecuencia_horas': m.frecuenciaHoras,
    'hora_inicio': m.horaInicio.minutosDesdeMedianoche,
    'fecha_creacion': m.fechaCreacion.millisecondsSinceEpoch,
    'dosis': m.dosis,
    'instrucciones': m.instrucciones,
    'fecha_fin': m.fechaFin == null
        ? null
        : FormatoFechas.isoFecha(m.fechaFin!),
    'foto': m.foto,
    'horas': m.horasLibres?.map((h) => h.minutosDesdeMedianoche).join(','),
    'dias': m.dias.codificar(),
    'a_demanda': m.aDemanda ? 1 : 0,
    'existencias': m.existencias?.cantidad,
    'existencias_contadas': m.existencias?.contadas.millisecondsSinceEpoch,
    'existencias_por_toma': m.existencias?.porToma,
    'existencias_por_tomas': m.existencias?.porTomas?.join(','),
    'dosis_por_toma': m.dosisPorToma == null
        ? null
        : jsonEncode(m.dosisPorToma),
    'maximo_al_dia': m.maximoAlDia,
    'horas_entre_tomas': m.horasEntreTomas,
    'renovar_receta': m.renovarReceta == null
        ? null
        : FormatoFechas.isoFecha(m.renovarReceta!),
  };

  static Medicamento _desdeFila(Map<String, Object?> fila) => Medicamento(
    id: fila['id']! as int,
    nombre: fila['nombre']! as String,
    numTomas: fila['num_tomas']! as int,
    frecuenciaHoras: fila['frecuencia_horas']! as int,
    horaInicio: HoraDelDia.desdeMinutos(fila['hora_inicio']! as int),
    fechaCreacion: DateTime.fromMillisecondsSinceEpoch(
      fila['fecha_creacion']! as int,
    ),
    dosis: fila['dosis'] as String?,
    dosisPorToma: switch (fila['dosis_por_toma']) {
      final String json => List.unmodifiable([
        for (final d in jsonDecode(json) as List<Object?>) d! as String,
      ]),
      _ => null,
    },
    instrucciones: fila['instrucciones'] as String?,
    fechaFin: switch (fila['fecha_fin']) {
      final String fecha => FormatoFechas.desdeIsoFecha(fecha),
      _ => null,
    },
    foto: fila['foto'] as String?,
    horasLibres: switch (fila['horas']) {
      final String horas when horas.isNotEmpty => [
        for (final minutos in horas.split(','))
          HoraDelDia.desdeMinutos(int.parse(minutos)),
      ],
      _ => null,
    },
    dias: DiasDeToma.decodificar(fila['dias'] as String?),
    aDemanda: fila['a_demanda'] == 1,
    existencias: switch ((
      fila['existencias'],
      fila['existencias_contadas'],
      fila['existencias_por_toma'],
    )) {
      (final num cantidad, final int contadas, final num porToma) =>
        Existencias(
          cantidad: cantidad.toDouble(),
          contadas: DateTime.fromMillisecondsSinceEpoch(contadas),
          porToma: porToma.toDouble(),
          porTomas: switch (fila['existencias_por_tomas']) {
            final String lista when lista.isNotEmpty => List.unmodifiable([
              for (final n in lista.split(',')) double.parse(n),
            ]),
            _ => null,
          },
        ),
      _ => null,
    },
    maximoAlDia: fila['maximo_al_dia'] as int?,
    horasEntreTomas: fila['horas_entre_tomas'] as int?,
    renovarReceta: switch (fila['renovar_receta']) {
      final String fecha => FormatoFechas.desdeIsoFecha(fecha),
      _ => null,
    },
  );
}
