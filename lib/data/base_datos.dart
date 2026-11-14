import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Base de datos local (SQLite) con medicamentos, citas y registro de tomas.
///
/// Versiones:
/// 1. Tablas `medicamentos` y `citas`.
/// 2. Dosis, instrucciones y fecha de fin del tratamiento en `medicamentos`.
/// 3. Tabla `tomas`: tomas marcadas como tomadas o aplazadas.
/// 4. Foto de la caja en `medicamentos` (nombre del fichero).
/// 5. Horas elegidas una a una (`horas`) y días de toma (`dias`) en
///    `medicamentos`.
/// 6. Medicamentos "cuando haga falta" (`a_demanda`).
/// 7. Cuenta de las pastillas (`existencias`, `existencias_contadas` y
///    `existencias_por_toma`).
/// 8. Límites de los "cuando haga falta" (`maximo_al_dia` y
///    `horas_entre_tomas`).
/// 9. Último día de la receta (`renovar_receta`).
/// 10. Dosis distinta en cada toma (`dosis_por_toma`, una lista JSON) y
///    pastillas de cada toma (`existencias_por_tomas`, separadas por comas).
///    Desde esta versión `existencias` y `existencias_por_toma` admiten
///    medias pastillas (14.5): SQLite las guarda como número real.
abstract final class BaseDatos {
  static const String nombreFichero = 'salud_mayores.db';
  static const int version = 10;

  static const String tablaMedicamentos = 'medicamentos';
  static const String tablaCitas = 'citas';
  static const String tablaTomas = 'tomas';

  /// Abre (y crea o actualiza si hace falta) la base de datos. En los tests
  /// se pasa una factoría FFI y la ruta `inMemoryDatabasePath`.
  static Future<Database> abrir({
    DatabaseFactory? factoria,
    String? ruta,
  }) async {
    final f = factoria ?? databaseFactory;
    final destino = ruta ?? p.join(await f.getDatabasesPath(), nombreFichero);
    return f.openDatabase(
      destino,
      options: OpenDatabaseOptions(
        version: version,
        onCreate: _crear,
        onUpgrade: _actualizar,
      ),
    );
  }

  static Future<void> _crear(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablaMedicamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        num_tomas INTEGER NOT NULL CHECK (num_tomas >= 1),
        frecuencia_horas INTEGER NOT NULL CHECK (frecuencia_horas >= 1),
        hora_inicio INTEGER NOT NULL,
        fecha_creacion INTEGER NOT NULL,
        dosis TEXT,
        instrucciones TEXT,
        fecha_fin TEXT,
        foto TEXT,
        horas TEXT,
        dias TEXT,
        a_demanda INTEGER NOT NULL DEFAULT 0,
        existencias INTEGER,
        existencias_contadas INTEGER,
        existencias_por_toma INTEGER,
        maximo_al_dia INTEGER,
        horas_entre_tomas INTEGER,
        renovar_receta TEXT,
        dosis_por_toma TEXT,
        existencias_por_tomas TEXT
      )
    ''');
    // Las fechas se guardan como texto AAAA-MM-DD y las horas en minutos
    // desde medianoche: así no hay problemas de zona horaria y se ordena bien.
    await db.execute('''
      CREATE TABLE $tablaCitas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        fecha TEXT NOT NULL,
        hora INTEGER NOT NULL,
        lugar TEXT,
        notas TEXT
      )
    ''');
    await _crearTablaTomas(db);
  }

  /// Una fila por toma (medicamento, día y hora prevista). No tiene clave
  /// externa a `medicamentos` a propósito: el historial se conserva aunque se
  /// elimine el medicamento.
  static Future<void> _crearTablaTomas(Database db) => db.execute('''
    CREATE TABLE $tablaTomas (
      medicamento_id INTEGER NOT NULL,
      nombre_medicamento TEXT NOT NULL,
      fecha TEXT NOT NULL,
      hora INTEGER NOT NULL,
      estado TEXT NOT NULL,
      momento INTEGER NOT NULL,
      recordar_en INTEGER,
      PRIMARY KEY (medicamento_id, fecha, hora)
    )
  ''');

  static Future<void> _actualizar(
    Database db,
    int versionAnterior,
    int versionNueva,
  ) async {
    if (versionAnterior < 2) {
      for (final columna in ['dosis', 'instrucciones', 'fecha_fin']) {
        await db.execute(
          'ALTER TABLE $tablaMedicamentos ADD COLUMN $columna TEXT',
        );
      }
    }
    if (versionAnterior < 3) {
      await _crearTablaTomas(db);
    }
    if (versionAnterior < 4) {
      await db.execute('ALTER TABLE $tablaMedicamentos ADD COLUMN foto TEXT');
    }
    if (versionAnterior < 5) {
      // `horas`: minutos separados por comas ("480,840,1260"); `dias`: ver
      // `DiasDeToma.codificar`. Vacías en los medicamentos de antes.
      for (final columna in ['horas', 'dias']) {
        await db.execute(
          'ALTER TABLE $tablaMedicamentos ADD COLUMN $columna TEXT',
        );
      }
    }
    if (versionAnterior < 6) {
      await db.execute(
        'ALTER TABLE $tablaMedicamentos '
        'ADD COLUMN a_demanda INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (versionAnterior < 7) {
      // Vacías: los medicamentos de antes no llevan la cuenta.
      for (final columna in [
        'existencias',
        'existencias_contadas',
        'existencias_por_toma',
      ]) {
        await db.execute(
          'ALTER TABLE $tablaMedicamentos ADD COLUMN $columna INTEGER',
        );
      }
    }
    if (versionAnterior < 8) {
      // Vacías: sin límites.
      for (final columna in ['maximo_al_dia', 'horas_entre_tomas']) {
        await db.execute(
          'ALTER TABLE $tablaMedicamentos ADD COLUMN $columna INTEGER',
        );
      }
    }
    if (versionAnterior < 9) {
      // AAAA-MM-DD, como la fecha de fin; vacía: sin fecha.
      await db.execute(
        'ALTER TABLE $tablaMedicamentos ADD COLUMN renovar_receta TEXT',
      );
    }
    if (versionAnterior < 10) {
      // Vacías: la misma dosis y las mismas pastillas en todas las tomas.
      for (final columna in ['dosis_por_toma', 'existencias_por_tomas']) {
        await db.execute(
          'ALTER TABLE $tablaMedicamentos ADD COLUMN $columna TEXT',
        );
      }
    }
  }
}
