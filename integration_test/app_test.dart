// Tests de integración: se ejecutan en un móvil o emulador Android con la
// base de datos, las preferencias y el sistema de notificaciones reales.
//
// Comprueban lo que los tests de widgets no pueden: que los avisos quedan
// programados de verdad en Android, que los datos se guardan en SQLite y que
// el marcador de teléfono está disponible.
//
// Ejecución (ver README):
//   flutter test integration_test -d <dispositivo>
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:salud_mayores/data/base_datos.dart';
import 'package:salud_mayores/features/agenda/data/cita_repository.dart';
import 'package:salud_mayores/features/agenda/domain/recordatorios_cita.dart';
import 'package:salud_mayores/app/proveedores.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/data/ajustes_repository.dart';
import 'package:salud_mayores/features/compartir/application/servicio_compartir.dart';
import 'package:salud_mayores/features/compartir/domain/copia_de_seguridad.dart';
import 'package:salud_mayores/features/medicamentos/data/medicamento_repository.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/data/toma_repository.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/main.dart' as app;
import 'package:salud_mayores/notificaciones/bateria.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';
import 'package:salud_mayores/voz/servicio_voz.dart';
import 'package:salud_mayores/widget_inicio/datos_widget.dart';
import 'package:salud_mayores/widget_inicio/servicio_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

final _plugin = FlutterLocalNotificationsPlugin();

/// Las pantallas no esperan a que se reprogramen los avisos: antes de mirar
/// lo programado en Android se espera a que termine la sincronización.
Future<void> _avisosAlDia(WidgetTester tester) async {
  final contenedor = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  await contenedor.read(sincronizadorAvisosProvider).esperar();
}

Future<Set<int>> _idsPendientes(WidgetTester tester) async {
  await _avisosAlDia(tester);
  return {
    for (final aviso in await _plugin.pendingNotificationRequests()) aviso.id,
  };
}

/// Avisos pendientes agrupados por rango de identificador (ver
/// `PlanificadorAvisos`): diarios recurrentes, citas y avisos día a día
/// (repeticiones y tomas con fecha).
Future<({Set<int> diarios, Set<int> citas, Set<int> diaADia})>
_pendientesPorRango(WidgetTester tester) async {
  final ids = await _idsPendientes(tester);
  return (
    diarios: ids.where((id) => id < 1000000000).toSet(),
    citas: ids.where((id) => id >= 1000000000 && id < 1090000000).toSet(),
    diaADia: ids.where((id) => id >= 1100000000).toSet(),
  );
}

Future<void> _pulsar(WidgetTester tester, Finder buscador) async {
  await tester.ensureVisible(buscador.first);
  await tester.pumpAndSettle();
  await tester.tap(buscador.first);
  await tester.pumpAndSettle();
}

Future<void> _pulsarTexto(WidgetTester tester, String texto) =>
    _pulsar(tester, find.text(texto));

/// Espera a que aparezca [buscador]. En un dispositivo real, guardar puede
/// tardar un poco (se reprograman todos los avisos con el sistema) y
/// `pumpAndSettle` no espera a las llamadas al sistema operativo.
Future<Duration> _esperar(WidgetTester tester, Finder buscador) async {
  final inicio = DateTime.now();
  while (buscador.evaluate().isEmpty &&
      DateTime.now().difference(inicio) < const Duration(seconds: 20)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
  expect(buscador, findsWidgets);
  return DateTime.now().difference(inicio);
}

Future<void> _escribir(WidgetTester tester, Finder campo, String texto) async {
  await tester.enterText(campo, texto);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  // En un dispositivo real el teclado tarda en cerrarse y mientras tanto la
  // pantalla cambia de tamaño: se espera a que desaparezca.
  for (var i = 0; i < 30 && tester.view.viewInsets.bottom > 0; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Se empieza siempre desde cero, con las notificaciones ya activadas en
    // Ajustes (el permiso del sistema se puede conceder antes con adb).
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool(
      AjustesRepositoryPreferencias.claveNotificaciones,
      true,
    );
    // El asistente de la primera vez tiene su propio test.
    await prefs.setBool(
      AjustesRepositoryPreferencias.claveAsistenteCompletado,
      true,
    );
    await deleteDatabase(
      p.join(await getDatabasesPath(), BaseDatos.nombreFichero),
    );
    await _plugin.cancelAll();
  });

  testWidgets('la primera vez se abre el asistente y se recuerda al '
      'terminarlo', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AjustesRepositoryPreferencias.claveAsistenteCompletado);

    await app.main();
    await tester.pumpAndSettle();
    expect(find.text('Primeros pasos'), findsOneWidget);
    await _pulsarTexto(tester, 'Empezar');
    await _pulsarTexto(tester, 'Siguiente');
    await _pulsarTexto(tester, 'Siguiente');
    await _escribir(tester, find.byType(TextField).first, '112');
    expect(find.text('Todo listo'), findsOneWidget);
    await _pulsarTexto(tester, 'Empezar a usar la aplicación');

    expect(find.text('Menú principal'), findsOneWidget);
    expect(
      prefs.getBool(AjustesRepositoryPreferencias.claveAsistenteCompletado),
      isTrue,
    );
    expect(
      prefs.getString(AjustesRepositoryPreferencias.claveNumeroEmergencia),
      '112',
    );
  });

  testWidgets('crear, modificar, eliminar y deshacer programa y cancela '
      'avisos reales', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    expect(find.text('Menú principal'), findsOneWidget);
    expect(await _idsPendientes(tester), isEmpty);

    // Alta de un medicamento con dos tomas al día.
    await _pulsarTexto(tester, 'Registro de medicamentos');
    await _pulsarTexto(tester, 'Registrar nuevo medicamento');
    await _escribir(tester, find.byType(TextField).first, 'Prueba en móvil');
    await _pulsar(tester, find.bySemanticsLabel('Una toma más'));
    await _pulsarTexto(tester, 'Crear recordatorio');
    final espera = await _esperar(
      tester,
      find.text('Medicamento guardado correctamente'),
    );
    debugPrint('Guardar y programar los avisos tardó $espera');
    await _pulsarTexto(tester, 'Aceptar');

    final db = await BaseDatos.abrir();
    final guardados = await MedicamentoRepositorySqlite(db).obtenerTodos();
    expect(guardados.single.nombre, 'Prueba en móvil');
    final id = guardados.single.id;
    // Cada toma tiene su aviso diario y, día a día, su repetición por si no
    // se marca.
    final antes = await _pendientesPorRango(tester);
    expect(antes.diarios, {
      PlanificadorAvisos.idToma(id, 0),
      PlanificadorAvisos.idToma(id, 1),
    });
    expect(antes.diaADia.length, greaterThanOrEqualTo(2 * 13));
    // La carga de la notificación identifica la toma para sus botones.
    await _avisosAlDia(tester);
    final pendientes = await _plugin.pendingNotificationRequests();
    final primera = pendientes.firstWhere(
      (p) => p.id == PlanificadorAvisos.idToma(id, 0),
    );
    expect(
      CargaAviso.decodificar(primera.payload),
      CargaToma(medicamentoId: id, hora: guardados.single.horaInicio),
    );

    // Eliminar cancela sus avisos en el sistema; "Deshacer" los recupera.
    await _pulsarTexto(tester, 'Eliminar');
    await _pulsarTexto(tester, 'Sí, eliminar');
    expect(await _idsPendientes(tester), isEmpty);
    await _pulsarTexto(tester, 'Deshacer');
    expect(await _idsPendientes(tester), {...antes.diarios, ...antes.diaADia});

    // Modificar (una toma menos) se guarda en SQLite y deja un solo aviso.
    await _pulsarTexto(tester, 'Modificar');
    await _pulsar(tester, find.bySemanticsLabel('Una toma menos'));
    await _pulsarTexto(tester, 'Guardar cambios');
    expect(find.text('Cambios guardados correctamente'), findsOneWidget);
    await _pulsarTexto(tester, 'Aceptar');
    final modificado = (await MedicamentoRepositorySqlite(
      db,
    ).obtenerTodos()).single;
    expect(modificado.id, id);
    expect(modificado.numTomas, 1);
    final modificados = await _pendientesPorRango(tester);
    expect(modificados.diarios, {PlanificadorAvisos.idToma(id, 0)});
    expect(modificados.diaADia.length, greaterThanOrEqualTo(13));

    // Marcar la toma en "Tomas de hoy" se guarda en SQLite y cancela la
    // repetición de hoy.
    await _pulsarTexto(tester, 'Inicio');
    await _pulsarTexto(tester, 'Registro de medicamentos');
    await _pulsarTexto(tester, 'Tomas de hoy');
    await _pulsarTexto(tester, 'Ya la he tomado');
    // Con el emulador recién arrancado, el mensaje puede tardar un poco.
    await _esperar(tester, find.textContaining('Anotado: has tomado'));
    // El mensaje con "Deshacer" sigue visible unos segundos aunque se cambie
    // de pantalla, y taparía los botones de abajo: se cierra ya.
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger).first)
        .removeCurrentSnackBar();
    await tester.pumpAndSettle();
    final ahora = DateTime.now();
    final registros = await TomaRepositorySqlite(db).obtenerEntre(ahora, ahora);
    expect(registros.single.medicamentoId, id);
    expect(registros.single.estado, EstadoToma.tomada);
    final trasMarcar = await _pendientesPorRango(tester);
    expect(
      trasMarcar.diaADia,
      isNot(contains(PlanificadorAvisos.idRepeticionConFecha(id, ahora, 0))),
    );
    // Si se ha marcado antes de su hora, el aviso diario se cambia por
    // avisos únicos desde mañana; si no, sigue siendo diario.
    final hora = modificado.horaInicio;
    final antesDeSuHora = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
      hora.hora,
      hora.minuto,
    ).isAfter(ahora);
    expect(
      trasMarcar.diarios.contains(PlanificadorAvisos.idToma(id, 0)),
      !antesDeSuHora,
    );

    // Una cita para mañana a las 10:00 programa sus recordatorios (el de esta
    // tarde a las 18:00, si aún no ha pasado).
    await _pulsarTexto(tester, 'Inicio');
    await _pulsarTexto(tester, 'Agenda');
    await _pulsarTexto(tester, 'Crear cita');
    await _escribir(tester, find.byType(TextField).first, 'Cita de prueba');
    await _pulsarTexto(tester, 'Mañana');
    await _pulsarTexto(tester, 'Guardar cita');
    await _pulsarTexto(tester, 'Aceptar');
    final cita = (await CitaRepositorySqlite(db).obtenerTodas()).single;
    expect((await _pendientesPorRango(tester)).citas, {
      for (final aviso in RecordatoriosCita.calcular(
        cita,
        ahora: DateTime.now(),
      ))
        PlanificadorAvisos.idAvisoCita(cita.id, aviso.tipo),
    });

    // Desactivar las notificaciones cancela todo.
    await _pulsarTexto(tester, 'Inicio');
    await _pulsarTexto(tester, 'Ajustes');
    await _pulsarTexto(tester, 'Activar notificaciones');
    expect(await _idsPendientes(tester), isEmpty);
  });

  testWidgets('"Probar aviso" muestra una notificación si hay permiso', (
    tester,
  ) async {
    // El test anterior dejó las notificaciones desactivadas: se reactivan en
    // las preferencias para no depender del diálogo de permiso del sistema.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      AjustesRepositoryPreferencias.claveNotificaciones,
      true,
    );
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final conPermiso = await android?.areNotificationsEnabled() ?? false;

    await app.main();
    await tester.pumpAndSettle();
    await _pulsarTexto(tester, 'Ajustes');
    await _pulsarTexto(tester, 'Probar aviso');

    if (conPermiso) {
      expect(find.textContaining('Aviso de prueba enviado'), findsOneWidget);
      final activas = await _plugin.getActiveNotifications();
      expect(
        activas.map((n) => n.id),
        contains(PlanificadorAvisos.idAvisoDePrueba),
      );
    } else {
      expect(find.text('Falta el permiso del teléfono'), findsOneWidget);
      await _pulsarTexto(tester, 'Ahora no');
    }
  });

  testWidgets('una medicina de algunos días a horas concretas deja avisos '
      'semanales en Android', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    await _pulsarTexto(tester, 'Registro de medicamentos');
    await _pulsarTexto(tester, 'Registrar nuevo medicamento');
    await _escribir(tester, find.byType(TextField).first, 'Semanal en móvil');
    await _pulsar(tester, find.bySemanticsLabel('Una toma más'));
    await _pulsarTexto(tester, 'A horas concretas');
    // Se propone el día de hoy; se añade el de mañana.
    await _pulsarTexto(tester, 'Algunos días de la semana');
    final hoy = DateTime.now();
    final manana = DateTime(hoy.year, hoy.month, hoy.day + 1);
    const nombres = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    await _pulsarTexto(tester, nombres[manana.weekday - 1]);
    await _pulsarTexto(tester, 'Crear recordatorio');
    await _esperar(tester, find.text('Medicamento guardado correctamente'));
    await _pulsarTexto(tester, 'Aceptar');

    final db = await BaseDatos.abrir();
    final guardado = (await MedicamentoRepositorySqlite(
      db,
    ).obtenerTodos()).singleWhere((m) => m.nombre == 'Semanal en móvil');
    expect(guardado.horasLibres, const [HoraDelDia(9, 0), HoraDelDia(21, 0)]);
    expect(guardado.dias, DiasDeLaSemana({hoy.weekday, manana.weekday}));

    // Un aviso semanal por día y hora, en vez de los diarios, y las
    // repeticiones solo en los días que toca.
    final id = guardado.id;
    final pendientes = await _pendientesPorRango(tester);
    expect(
      pendientes.diarios,
      containsAll({
        for (final dia in [hoy.weekday, manana.weekday])
          for (var i = 0; i < 2; i++)
            PlanificadorAvisos.idTomaSemanal(id, dia, i),
      }),
    );
    expect(
      pendientes.diarios,
      isNot(contains(PlanificadorAvisos.idToma(id, 0))),
    );
    for (var d = 2; d < 7; d++) {
      final dia = DateTime(hoy.year, hoy.month, hoy.day + d);
      expect(
        pendientes.diaADia,
        isNot(contains(PlanificadorAvisos.idRepeticionConFecha(id, dia, 0))),
      );
    }
    expect(
      pendientes.diaADia,
      contains(
        PlanificadorAvisos.idRepeticionConFecha(
          id,
          DateTime(hoy.year, hoy.month, hoy.day + 7),
          0,
        ),
      ),
    );
  });

  testWidgets('una medicina "cuando haga falta" no deja avisos y se anota '
      'en "Tomas de hoy"', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    final antes = await _idsPendientes(tester);
    await _pulsarTexto(tester, 'Registro de medicamentos');
    await _pulsarTexto(tester, 'Registrar nuevo medicamento');
    await _escribir(tester, find.byType(TextField).first, 'Calmante en móvil');
    await _pulsarTexto(tester, 'Solo cuando haga falta');
    await _pulsarTexto(tester, 'Guardar medicamento');
    await _esperar(tester, find.text('Medicamento guardado correctamente'));
    await _pulsarTexto(tester, 'Aceptar');

    final db = await BaseDatos.abrir();
    final guardado = (await MedicamentoRepositorySqlite(
      db,
    ).obtenerTodos()).singleWhere((m) => m.nombre == 'Calmante en móvil');
    expect(guardado.aDemanda, isTrue);
    expect(await _idsPendientes(tester), antes);

    await _pulsarTexto(tester, 'Inicio');
    await _pulsarTexto(tester, 'Registro de medicamentos');
    await _pulsarTexto(tester, 'Tomas de hoy');
    await _pulsarTexto(tester, 'Lo he tomado ahora');
    expect(find.textContaining('Anotado: has tomado Calmante'), findsOneWidget);
    final hoy = DateTime.now();
    final anotada = (await TomaRepositorySqlite(db).obtenerEntre(
      hoy,
      hoy,
    )).singleWhere((r) => r.medicamentoId == guardado.id);
    expect(anotada.estado, EstadoToma.tomada);
    expect(await _idsPendientes(tester), antes);
  });

  testWidgets('con pocas pastillas se programa en Android el aviso, y "He '
      'comprado más" las suma', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    await _pulsarTexto(tester, 'Registro de medicamentos');
    await _pulsarTexto(tester, 'Registrar nuevo medicamento');
    await _escribir(tester, find.byType(TextField).first, 'Cuenta en móvil');
    await _pulsarTexto(tester, 'Llevar la cuenta');
    await _escribir(tester, find.byType(TextField).last, '3');
    await _pulsarTexto(tester, 'Crear recordatorio');
    await _esperar(tester, find.text('Medicamento guardado correctamente'));
    await _pulsarTexto(tester, 'Aceptar');

    final db = await BaseDatos.abrir();
    Future<Medicamento> guardado() async => (await MedicamentoRepositorySqlite(
      db,
    ).obtenerTodos()).singleWhere((m) => m.nombre == 'Cuenta en móvil');
    final medicamento = await guardado();
    expect(medicamento.existencias?.cantidad, 3);
    expect(
      await _idsPendientes(tester),
      contains(PlanificadorAvisos.idExistencias(medicamento.id)),
    );

    await _pulsar(
      tester,
      find.bySemanticsLabel('He comprado más Cuenta en móvil'),
    );
    await _escribir(tester, find.byType(TextField), '60');
    await _pulsarTexto(tester, 'Añadir a las que tengo');
    await _esperar(tester, find.text('Pastillas añadidas'));
    await _pulsarTexto(tester, 'Aceptar');
    expect((await guardado()).existencias?.cantidad, 63);
  });

  testWidgets('el marcador de teléfono está disponible para tel:', (
    tester,
  ) async {
    // Confirma que la consulta <queries> del AndroidManifest funciona; abrir
    // el marcador de verdad sacaría la app de primer plano.
    expect(await canLaunchUrl(Uri(scheme: 'tel', path: '112')), isTrue);
  });

  testWidgets('el permiso de alarmas exactas se consulta sin errores', (
    tester,
  ) async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    // En Android 14 recién instalada suele ser `false`: entonces la app usa
    // alarmas inexactas, y los tests anteriores demuestran que funcionan.
    final exactas = await android?.canScheduleExactNotifications();
    expect(exactas, isNotNull);
    debugPrint('Alarmas exactas permitidas: $exactas');
  });

  testWidgets('el PDF y la copia de seguridad funcionan con los datos '
      'reales', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    final contenedor = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    final medicamentos = contenedor.read(medicamentoRepositoryProvider);
    await medicamentos.crear(
      const NuevoMedicamento(
        nombre: 'Metformina',
        numTomas: 2,
        frecuenciaHoras: 12,
        horaInicio: HoraDelDia(9, 0),
        dosis: '1 comprimido',
      ),
    );
    final servicio = contenedor.read(servicioCompartirProvider);

    // El PDF usa Montserrat desde los assets de la app.
    final pdf = await servicio.generarInforme();
    expect(ascii.decode(pdf.sublist(0, 5)), '%PDF-');

    final copia = await servicio.crearCopia();
    final antes = await medicamentos.obtenerTodos();
    expect(antes.map((m) => m.nombre), contains('Metformina'));

    // Se vacía todo con una copia vacía y se recupera la buena.
    await servicio.recuperar(
      CopiaDeSeguridad(
        creada: DateTime.now(),
        medicamentos: const [],
        citas: const [],
        tomas: const [],
        ajustes: copia.ajustes,
      ),
    );
    expect(await medicamentos.obtenerTodos(), isEmpty);
    await servicio.recuperar(CopiaDeSeguridad.decodificar(copia.codificar()));
    expect(await medicamentos.obtenerTodos(), antes);
    await _avisosAlDia(tester);
  });
  testWidgets('el canal de voz nativo responde', (tester) async {
    // Que haya voz en español o dictado depende del teléfono: aquí se
    // comprueba que el canal de MainActivity.kt contesta sin errores.
    const voz = ServicioVozCanal();
    final habla = await voz.hablar('Prueba de voz.');
    final dicta = await voz.puedeDictar();
    debugPrint('Voz en español: $habla. Dictado: $dicta.');
    await voz.callar();
  });

  testWidgets('el canal del widget de la pantalla de inicio responde', (
    tester,
  ) async {
    // Que esté puesto en la pantalla de inicio depende de la persona: aquí
    // se comprueba que CanalWidget.kt guarda los datos y contesta.
    final widget = ServicioWidgetCanal();
    await widget.actualizar(
      DatosWidget.calcular(
        medicamentos: const [],
        registros: const [],
        ahora: DateTime.now(),
      ),
    );
    expect(await widget.accionInicial(), isNull);
  });

  testWidgets('el canal del sistema dice cómo trata Android la batería', (
    tester,
  ) async {
    // Lo que contesta depende del teléfono; aquí se comprueba que el canal
    // de CanalSistema.kt responde con el fabricante.
    final bateria = await const ServicioBateriaCanal().estado();
    debugPrint(
      'Batería: optimizada ${bateria.optimizada}, restringida '
      '${bateria.restringida}, fabricante "${bateria.fabricante}".',
    );
    expect(bateria.fabricante, isNotEmpty);
  });
}
