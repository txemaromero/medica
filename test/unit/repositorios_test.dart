import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/data/base_datos.dart';
import 'package:salud_mayores/features/agenda/data/cita_repository.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/data/ajustes_repository.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/compartir/data/restauracion_datos.dart';
import 'package:salud_mayores/features/medicamentos/data/medicamento_repository.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/existencias.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/data/toma_repository.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  late Database db;

  setUp(() async {
    // Cada test usa su propia base de datos SQLite en memoria.
    db = await BaseDatos.abrir(
      factoria: databaseFactoryFfiNoIsolate,
      ruta: inMemoryDatabasePath,
    );
  });

  tearDown(() => db.close());

  group('MedicamentoRepositorySqlite', () {
    final creacion = DateTime(2026, 10, 25, 9, 0);
    MedicamentoRepositorySqlite repo() =>
        MedicamentoRepositorySqlite(db, reloj: () => creacion);

    NuevoMedicamento nuevo(String nombre) => NuevoMedicamento(
      nombre: nombre,
      numTomas: 2,
      frecuenciaHoras: 12,
      horaInicio: const HoraDelDia(8, 30),
    );

    test('empieza vacío', () async {
      expect(await repo().obtenerTodos(), isEmpty);
    });

    test('crear guarda todos los campos y asigna id', () async {
      final creado = await repo().crear(nuevo('  Omeprazol  '));
      expect(creado.id, greaterThan(0));
      expect(creado.nombre, 'Omeprazol');

      final todos = await repo().obtenerTodos();
      expect(todos, [creado]);
      expect(todos.single.horaInicio, const HoraDelDia(8, 30));
      expect(todos.single.fechaCreacion, creacion);
      expect(todos.single.horasDeToma.map((h) => h.texto), ['08:30', '20:30']);
    });

    test(
      'ordena alfabéticamente sin distinguir tildes ni mayúsculas',
      () async {
        for (final nombre in ['paracetamol', 'Ácido fólico', 'Ibuprofeno']) {
          await repo().crear(nuevo(nombre));
        }
        expect((await repo().obtenerTodos()).map((m) => m.nombre), [
          'Ácido fólico',
          'Ibuprofeno',
          'paracetamol',
        ]);
      },
    );

    test('eliminar y restaurar (deshacer) conserva el id', () async {
      final a = await repo().crear(nuevo('Aspirina'));
      final b = await repo().crear(nuevo('Bisoprolol'));

      await repo().eliminar(a.id);
      expect(await repo().obtenerTodos(), [b]);

      await repo().restaurar(a);
      expect(await repo().obtenerTodos(), [a, b]);
    });

    test('los datos siguen ahí al reabrir con otro repositorio', () async {
      await repo().crear(nuevo('Metformina'));
      final otro = MedicamentoRepositorySqlite(db);
      expect((await otro.obtenerTodos()).single.nombre, 'Metformina');
    });

    test('guarda dosis, instrucciones y fecha de fin', () async {
      final creado = await repo().crear(
        NuevoMedicamento(
          nombre: 'Amoxicilina',
          numTomas: 3,
          frecuenciaHoras: 8,
          horaInicio: const HoraDelDia(8, 0),
          dosis: '1 cápsula',
          instrucciones: 'con comida',
          fechaFin: DateTime(2026, 11, 1),
        ),
      );
      final leido = (await repo().obtenerTodos()).single;
      expect(leido, creado);
      expect(leido.dosis, '1 cápsula');
      expect(leido.instrucciones, 'con comida');
      expect(leido.fechaFin, DateTime(2026, 11, 1));
    });

    test('guarda las horas concretas y los días de toma', () async {
      final semanal = await repo().crear(
        const NuevoMedicamento(
          nombre: 'Metformina',
          numTomas: 2,
          frecuenciaHoras: 12,
          horaInicio: HoraDelDia(9, 0),
          horasLibres: [HoraDelDia(21, 0), HoraDelDia(9, 0)],
          dias: DiasDeLaSemana({DateTime.monday, DateTime.thursday}),
        ),
      );
      final cadaTres = await repo().crear(
        NuevoMedicamento(
          nombre: 'Vitamina D',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: const HoraDelDia(9, 0),
          dias: CadaVariosDias(cada: 3, desde: DateTime(2026, 10, 26)),
        ),
      );
      final leidos = await repo().obtenerTodos();
      expect(leidos, unorderedEquals([semanal, cadaTres]));
      final metformina = leidos.firstWhere((m) => m.nombre == 'Metformina');
      expect(metformina.horasLibres, const [
        HoraDelDia(9, 0),
        HoraDelDia(21, 0),
      ]);
      expect(
        metformina.dias,
        const DiasDeLaSemana({DateTime.monday, DateTime.thursday}),
      );
    });

    test('guarda los de "cuando haga falta", con sus límites', () async {
      final calmante = await repo().crear(
        const NuevoMedicamento(
          nombre: 'Ibuprofeno',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(8, 0),
          aDemanda: true,
          maximoAlDia: 3,
          horasEntreTomas: 8,
        ),
      );
      expect(calmante.maximoAlDia, 3);
      expect(calmante.horasEntreTomas, 8);
      final conReceta = calmante.conReceta(DateTime(2026, 12, 1, 15, 30));
      await repo().actualizar(conReceta);
      expect(
        (await repo().obtenerTodos()).single.renovarReceta,
        DateTime(2026, 12, 1),
      );
      await repo().actualizar(calmante);
      final otro = await repo().crear(nuevo('Enalapril'));
      final leidos = await repo().obtenerTodos();
      expect(leidos, unorderedEquals([calmante, otro]));
      expect(leidos.firstWhere((m) => m.id == calmante.id).aDemanda, isTrue);
      expect(leidos.firstWhere((m) => m.id == otro.id).aDemanda, isFalse);
    });

    test('guarda la dosis y las pastillas de cada toma, con medias', () async {
      final existencias = Existencias(
        cantidad: 27.5,
        contadas: DateTime(2026, 10, 25, 9, 30),
        porToma: 1,
        porTomas: const [1, 0.5],
      );
      final creado = await repo().crear(
        NuevoMedicamento(
          nombre: 'Enalapril',
          numTomas: 2,
          frecuenciaHoras: 12,
          horaInicio: const HoraDelDia(8, 0),
          horasLibres: const [HoraDelDia(8, 0), HoraDelDia(21, 0)],
          dosisPorToma: const ['1 pastilla, con agua', 'media pastilla'],
          existencias: existencias,
        ),
      );
      final leido = (await repo().obtenerTodos()).single;
      expect(leido, creado);
      expect(leido.dosisPorToma, ['1 pastilla, con agua', 'media pastilla']);
      expect(leido.existencias, existencias);
    });

    test('guarda la cuenta de las pastillas y se puede quitar', () async {
      final existencias = Existencias(
        cantidad: 28,
        contadas: DateTime(2026, 10, 25, 9, 30),
        porToma: 2,
      );
      final creado = await repo().crear(
        NuevoMedicamento(
          nombre: 'Metformina',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: const HoraDelDia(9, 0),
          existencias: existencias,
        ),
      );
      expect((await repo().obtenerTodos()).single.existencias, existencias);

      await repo().actualizar(creado.conExistencias(null));
      expect((await repo().obtenerTodos()).single.existencias, isNull);
    });

    test('guarda la foto de la caja y se puede quitar', () async {
      final creado = await repo().crear(
        const NuevoMedicamento(
          nombre: 'Omeprazol',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(9, 0),
          foto: 'caja_1.jpg',
        ),
      );
      expect((await repo().obtenerTodos()).single.foto, 'caja_1.jpg');

      await repo().actualizar(
        creado.conDatos(
          const NuevoMedicamento(
            nombre: 'Omeprazol',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: HoraDelDia(9, 0),
          ),
        ),
      );
      expect((await repo().obtenerTodos()).single.foto, isNull);
    });

    test('actualizar modifica solo ese medicamento y conserva su id', () async {
      final a = await repo().crear(nuevo('Aspirina'));
      final b = await repo().crear(nuevo('Bisoprolol'));
      final cambiado = a.conDatos(
        const NuevoMedicamento(
          nombre: 'Aspirina 100',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(14, 0),
          dosis: '1 pastilla',
        ),
      );
      await repo().actualizar(cambiado);

      final todos = await repo().obtenerTodos();
      expect(todos, [cambiado, b]);
      expect(todos.first.id, a.id);
      expect(todos.first.fechaCreacion, a.fechaCreacion);
    });
  });

  test('migración: una base de datos de la versión 1 conserva sus datos y '
      'gana las columnas y tablas nuevas', () async {
    final ruta =
        '${Directory.systemTemp.createTempSync('salud_mayores').path}/v1.db';
    final antigua = await databaseFactoryFfiNoIsolate.openDatabase(
      ruta,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) async {
          await db.execute('''
            CREATE TABLE medicamentos (
              id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL,
              num_tomas INTEGER NOT NULL, frecuencia_horas INTEGER NOT NULL,
              hora_inicio INTEGER NOT NULL, fecha_creacion INTEGER NOT NULL)
          ''');
          await db.execute('''
            CREATE TABLE citas (
              id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT NOT NULL,
              fecha TEXT NOT NULL, hora INTEGER NOT NULL, lugar TEXT,
              notas TEXT)
          ''');
          await db.insert('medicamentos', {
            'nombre': 'Enalapril',
            'num_tomas': 1,
            'frecuencia_horas': 24,
            'hora_inicio': 9 * 60,
            'fecha_creacion': 0,
          });
        },
      ),
    );
    await antigua.close();

    final actualizada = await BaseDatos.abrir(
      factoria: databaseFactoryFfiNoIsolate,
      ruta: ruta,
    );
    addTearDown(actualizada.close);
    expect(await actualizada.getVersion(), BaseDatos.version);
    // La versión 3 añade la tabla de tomas, vacía.
    expect(
      await TomaRepositorySqlite(actualizada)
          .obtenerEntre(DateTime(2000), DateTime(2100)),
      isEmpty,
    );
    final leido = (await MedicamentoRepositorySqlite(
      actualizada,
    ).obtenerTodos()).single;
    expect(leido.nombre, 'Enalapril');
    expect(leido.horaInicio, const HoraDelDia(9, 0));
    expect(leido.fechaFin, isNull);
    // La versión 4 añade la foto de la caja.
    expect(leido.foto, isNull);
    // La versión 5, las horas concretas y los días de toma.
    expect(leido.horasLibres, isNull);
    expect(leido.dias, const TodosLosDias());
    // La 6, los medicamentos "cuando haga falta".
    expect(leido.aDemanda, isFalse);
    // La 7, la cuenta de las pastillas.
    expect(leido.existencias, isNull);
    // La 8, los límites de los "cuando haga falta".
    expect(leido.maximoAlDia, isNull);
    expect(leido.horasEntreTomas, isNull);
    // La 9, la fecha de la receta.
    expect(leido.renovarReceta, isNull);
    // La 10, la dosis y las pastillas de cada toma.
    expect(leido.dosisPorToma, isNull);

    await MedicamentoRepositorySqlite(actualizada).actualizar(
      leido.conDatos(
        const NuevoMedicamento(
          nombre: 'Enalapril',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(9, 0),
          dosis: '5 mg',
          foto: 'caja_1.jpg',
        ),
      ),
    );
    final modificado = (await MedicamentoRepositorySqlite(
      actualizada,
    ).obtenerTodos()).single;
    expect(modificado.dosis, '5 mg');
    expect(modificado.foto, 'caja_1.jpg');
  });

  group('CitaRepositorySqlite', () {
    NuevaCita nueva(
      String titulo,
      DateTime fecha,
      HoraDelDia hora, {
      String? lugar,
      String? notas,
    }) => NuevaCita(
      titulo: titulo,
      fecha: fecha,
      hora: hora,
      lugar: lugar,
      notas: notas,
    );

    test('ordena las citas cronológicamente (fecha y hora)', () async {
      final repo = CitaRepositorySqlite(db);
      await repo.crear(
        nueva('Dentista', DateTime(2026, 11, 3), const HoraDelDia(9, 0)),
      );
      await repo.crear(
        nueva('Análisis', DateTime(2026, 10, 28), const HoraDelDia(12, 0)),
      );
      await repo.crear(
        nueva('Cardiólogo', DateTime(2026, 10, 28), const HoraDelDia(8, 15)),
      );

      expect((await repo.obtenerTodas()).map((c) => c.titulo), [
        'Cardiólogo',
        'Análisis',
        'Dentista',
      ]);
    });

    test('lugar y notas vacíos se guardan como null', () async {
      final repo = CitaRepositorySqlite(db);
      final cita = await repo.crear(
        nueva(
          'Revisión',
          DateTime(2026, 10, 30),
          const HoraDelDia(10, 0),
          lugar: '  ',
          notas: 'Ir en ayunas',
        ),
      );
      final guardada = (await repo.obtenerTodas()).single;
      expect(guardada, cita);
      expect(guardada.lugar, isNull);
      expect(guardada.notas, 'Ir en ayunas');
      expect(guardada.fecha, DateTime(2026, 10, 30));
    });

    test('eliminar y restaurar (deshacer)', () async {
      final repo = CitaRepositorySqlite(db);
      final cita = await repo.crear(
        nueva('Oculista', DateTime(2026, 12, 1), const HoraDelDia(17, 45)),
      );
      await repo.eliminar(cita.id);
      expect(await repo.obtenerTodas(), isEmpty);
      await repo.restaurar(cita);
      expect(await repo.obtenerTodas(), [cita]);
    });

    test('actualizar cambia los datos y conserva el id', () async {
      final repo = CitaRepositorySqlite(db);
      final cita = await repo.crear(
        nueva(
          'Dentista',
          DateTime(2026, 11, 3),
          const HoraDelDia(9, 0),
          lugar: 'Clínica',
        ),
      );
      final cambiada = cita.conDatos(
        NuevaCita(
          titulo: 'Dentista (revisión)',
          fecha: DateTime(2026, 11, 4),
          hora: const HoraDelDia(11, 30),
          lugar: ' ',
          notas: 'Llevar radiografía',
        ),
      );
      await repo.actualizar(cambiada);

      final guardada = (await repo.obtenerTodas()).single;
      expect(guardada, cambiada);
      expect(guardada.id, cita.id);
      expect(guardada.lugar, isNull);
      expect(guardada.fechaHora, DateTime(2026, 11, 4, 11, 30));
    });
  });

  group('TomaRepositorySqlite', () {
    RegistroToma registro(
      DateTime fecha,
      HoraDelDia hora, {
      EstadoToma estado = EstadoToma.tomada,
      int medicamentoId = 1,
      DateTime? recordarEn,
    }) => RegistroToma(
      medicamentoId: medicamentoId,
      nombreMedicamento: 'Paracetamol',
      fecha: fecha,
      hora: hora,
      estado: estado,
      momento: DateTime(2026, 10, 25, 8, 5),
      recordarEn: recordarEn,
    );

    test('guarda y lee todos los campos', () async {
      final repo = TomaRepositorySqlite(db);
      final aplazada = registro(
        DateTime(2026, 10, 25),
        const HoraDelDia(8, 0),
        estado: EstadoToma.aplazada,
        recordarEn: DateTime(2026, 10, 25, 8, 15),
      );
      await repo.guardar(aplazada);
      expect(
        await repo.obtenerEntre(DateTime(2026, 10, 25), DateTime(2026, 10, 25)),
        [aplazada],
      );
    });

    test('una toma solo tiene un registro: guardar otra vez lo '
        'sustituye', () async {
      final repo = TomaRepositorySqlite(db);
      final dia = DateTime(2026, 10, 25);
      await repo.guardar(
        registro(dia, const HoraDelDia(8, 0), estado: EstadoToma.aplazada),
      );
      final tomada = registro(dia, const HoraDelDia(8, 0));
      await repo.guardar(tomada);
      expect(await repo.obtenerEntre(dia, dia), [tomada]);
    });

    test('obtenerEntre filtra por días (ambos incluidos) y ordena', () async {
      final repo = TomaRepositorySqlite(db);
      for (final dia in [24, 25, 26, 27]) {
        await repo.guardar(
          registro(DateTime(2026, 10, dia), const HoraDelDia(20, 0)),
        );
      }
      await repo.guardar(
        registro(DateTime(2026, 10, 25), const HoraDelDia(8, 0)),
      );
      final leidos = await repo.obtenerEntre(
        DateTime(2026, 10, 25),
        DateTime(2026, 10, 26),
      );
      expect(leidos.map((r) => '${r.fecha.day} ${r.hora.texto}'), [
        '25 08:00',
        '25 20:00',
        '26 20:00',
      ]);
    });

    test('borrar quita solo esa toma', () async {
      final repo = TomaRepositorySqlite(db);
      final dia = DateTime(2026, 10, 25);
      await repo.guardar(registro(dia, const HoraDelDia(8, 0)));
      final otra = registro(dia, const HoraDelDia(8, 0), medicamentoId: 2);
      await repo.guardar(otra);
      await repo.borrar(1, dia, const HoraDelDia(8, 0));
      expect(await repo.obtenerEntre(dia, dia), [otra]);
    });
  });

  group('RestauracionDatosSqlite', () {
    late Database db;
    setUp(() async {
      db = await BaseDatos.abrir(
        factoria: databaseFactoryFfiNoIsolate,
        ruta: inMemoryDatabasePath,
      );
      addTearDown(db.close);
    });
    Medicamento medicamento(int id, String nombre, {int numTomas = 1}) =>
        Medicamento(
          id: id,
          nombre: nombre,
          numTomas: numTomas,
          frecuenciaHoras: 24,
          horaInicio: const HoraDelDia(9, 0),
          fechaCreacion: DateTime(2026, 10, 1),
        );
    final cita = Cita(
      id: 3,
      titulo: 'Dentista',
      fecha: DateTime(2026, 11, 2),
      hora: const HoraDelDia(11, 0),
    );
    final toma = RegistroToma(
      medicamentoId: 2,
      nombreMedicamento: 'Omeprazol',
      fecha: DateTime(2026, 10, 24),
      hora: const HoraDelDia(9, 0),
      estado: EstadoToma.tomada,
      momento: DateTime(2026, 10, 24, 9, 5),
    );

    test('lo sustituye todo de una vez', () async {
      await MedicamentoRepositorySqlite(db)
          .restaurar(medicamento(1, 'Aspirina'));
      await RestauracionDatosSqlite(db).reemplazarTodo(
        medicamentos: [medicamento(2, 'Omeprazol')],
        citas: [cita],
        tomas: [toma],
      );
      expect(
        (await MedicamentoRepositorySqlite(
          db,
        ).obtenerTodos()).map((m) => m.nombre),
        ['Omeprazol'],
      );
      expect(await CitaRepositorySqlite(db).obtenerTodas(), [cita]);
      expect(
        await TomaRepositorySqlite(db)
            .obtenerEntre(DateTime(2026), DateTime(2027)),
        [toma],
      );
    });

    test('si algo falla a mitad, no cambia nada', () async {
      await MedicamentoRepositorySqlite(db)
          .restaurar(medicamento(1, 'Aspirina'));
      // La base de datos no admite un medicamento sin tomas: falla al
      // guardar el segundo, con el primero ya escrito y todo borrado.
      await expectLater(
        RestauracionDatosSqlite(db).reemplazarTodo(
          medicamentos: [
            medicamento(2, 'Omeprazol'),
            medicamento(3, 'Imposible', numTomas: 0),
          ],
          citas: [cita],
          tomas: const [],
        ),
        throwsA(isA<DatabaseException>()),
      );
      expect(
        (await MedicamentoRepositorySqlite(
          db,
        ).obtenerTodos()).map((m) => m.nombre),
        ['Aspirina'],
      );
      expect(await CitaRepositorySqlite(db).obtenerTodas(), isEmpty);
    });
  });

  group('AjustesRepositoryPreferencias', () {
    test('sin datos devuelve los valores por defecto', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = AjustesRepositoryPreferencias(
        await SharedPreferences.getInstance(),
      );
      expect(repo.cargar(), const Ajustes());
    });

    test('guarda y recupera todos los ajustes', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const ajustes = Ajustes(
        sonidoActivado: true,
        vibracionActivada: true,
        notificacionesActivadas: true,
        numeroEmergencia: '112',
        tamanoTexto: 30,
        tema: TemaApp.oscuro,
        leerEnVozAlta: true,
        familiarNombre: 'Mi hija Ana',
        familiarNumero: '600123456',
        recordarResumen: true,
        minutosRepeticion: 0,
        minutosAplazamiento: 30,
        avisosDiscretos: true,
      );
      await AjustesRepositoryPreferencias(prefs).guardar(ajustes);
      expect(AjustesRepositoryPreferencias(prefs).cargar(), ajustes);
    });

    test('corrige valores guardados fuera de rango', () async {
      SharedPreferences.setMockInitialValues({
        'tamanoTexto': 99,
        'tema': 'inexistente',
        'minutosRepeticion': 45,
        'minutosAplazamiento': -1,
      });
      final repo = AjustesRepositoryPreferencias(
        await SharedPreferences.getInstance(),
      );
      expect(repo.cargar().tamanoTexto, 35);
      expect(repo.cargar().tema, TemaApp.predeterminado);
      expect(repo.cargar().minutosRepeticion, 30);
      expect(repo.cargar().minutosAplazamiento, 10);
    });

    test('el asistente se muestra en una instalación nueva hasta que se '
        'completa', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(
        AjustesRepositoryPreferencias(prefs).asistenteCompletado(),
        isFalse,
      );
      await AjustesRepositoryPreferencias(prefs).marcarAsistenteCompletado();
      expect(
        AjustesRepositoryPreferencias(prefs).asistenteCompletado(),
        isTrue,
      );
    });

    test('si se cierra la app a mitad del asistente, vuelve a salir aunque '
        'ya se hayan guardado ajustes', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = AjustesRepositoryPreferencias(prefs);
      await repo.marcarAsistenteEmpezado();
      await repo.guardar(const Ajustes(tamanoTexto: 25));
      expect(repo.asistenteCompletado(), isFalse);

      // Una vez completado, volver a abrirlo no lo desmarca.
      await repo.marcarAsistenteCompletado();
      await repo.marcarAsistenteEmpezado();
      expect(repo.asistenteCompletado(), isTrue);
    });

    test(
      'quien ya usaba la app (con ajustes guardados) no ve el asistente',
      () async {
        SharedPreferences.setMockInitialValues({'tamanoTexto': 25});
        final repo = AjustesRepositoryPreferencias(
          await SharedPreferences.getInstance(),
        );
        expect(repo.asistenteCompletado(), isTrue);
      },
    );
  });
}
