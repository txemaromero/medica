import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/application/tomas_controller.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';
import '../helpers/textos.dart';

void main() {
  // Paracetamol a las 08:00, 16:00 y 00:00, con una cápsula cada vez.
  final paracetamol = Medicamento(
    id: 3,
    nombre: 'Paracetamol',
    numTomas: 3,
    frecuenciaHoras: 8,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
    dosis: '1 comprimido',
  );
  final hoy = DateTime(2026, 10, 25);

  RegistroToma tomada(DateTime fecha, HoraDelDia hora, DateTime momento) =>
      RegistroToma(
        medicamentoId: paracetamol.id,
        nombreMedicamento: paracetamol.nombre,
        fecha: fecha,
        hora: hora,
        estado: EstadoToma.tomada,
        momento: momento,
      );

  Future<void> abrirTomasDeHoy(WidgetTester tester) async {
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Tomas de hoy');
    expect(find.text(es.tomasTitulo), findsWidgets);
  }

  testWidgets('el submenú ofrece "Tomas de hoy" e "Historial de tomas"', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());
    await pulsarTexto(tester, 'Registro de medicamentos');
    for (final opcion in [
      'Tomas de hoy',
      'Registrar nuevo medicamento',
      'Ver medicamentos registrados',
      'Historial de tomas',
    ]) {
      expect(find.text(opcion), findsOneWidget);
    }
  });

  testWidgets('"Tomas de hoy" muestra cada toma con su estado', (tester) async {
    usarPantallaDeTelefono(tester, tamano: const Size(400, 1800));
    await arrancar(
      tester,
      EntornoDePrueba(
        medicamentos: [paracetamol],
        tomas: [
          tomada(hoy, const HoraDelDia(0, 0), DateTime(2026, 10, 25, 0, 5)),
        ],
      ),
    );
    await abrirTomasDeHoy(tester);

    expect(find.text('Has tomado 1 de 3.'), findsOneWidget);
    expect(find.text('Tomada a las 00:05'), findsOneWidget);
    expect(find.text('Sin marcar. Era a las 08:00.'), findsOneWidget);
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.text('Dosis: 1 comprimido'), findsNWidgets(3));
    // Ordenadas por hora.
    final y = [
      for (final h in ['00:00', '08:00', '16:00'])
        tester.getTopLeft(find.textContaining('$h de la')).dy,
    ];
    expect(y[0], lessThan(y[1]));
    expect(y[1], lessThan(y[2]));
  });

  testWidgets('marcar una toma la anota, confirma y permite deshacer', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(medicamentos: [paracetamol]);
    await arrancar(tester, entorno);
    await abrirTomasDeHoy(tester);

    await pulsarEtiqueta(tester, 'Ya he tomado Paracetamol de las 08:00');
    expect(
      find.text(
        es.tomasAnotada(paracetamol.nombre, const HoraDelDia(8, 0).texto),
      ),
      findsOneWidget,
    );
    expect(find.text('Tomada a las 09:00'), findsOneWidget);
    expect(find.text('Has tomado 1 de 3.'), findsOneWidget);
    expect(entorno.tomas.registros.single.estado, EstadoToma.tomada);
    expect(botonDeshacer(es.tomasDeshacerMarcarPista), findsOneWidget);

    await pulsarTexto(tester, 'Deshacer');
    expect(entorno.tomas.registros, isEmpty);
    expect(find.text('Has tomado 0 de 3.'), findsOneWidget);
  });

  testWidgets('"Desmarcar" quita la marca de una toma marcada por error', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(
      medicamentos: [paracetamol],
      tomas: [
        tomada(hoy, const HoraDelDia(8, 0), DateTime(2026, 10, 25, 8, 2)),
      ],
    );
    await arrancar(tester, entorno);
    await abrirTomasDeHoy(tester);

    await pulsarEtiqueta(tester, 'Desmarcar Paracetamol de las 08:00');
    expect(entorno.tomas.registros, isEmpty);
    expect(find.text('Toma desmarcada: Paracetamol (08:00).'), findsOneWidget);
    expect(botonDeshacer(es.tomasDeshacerDesmarcarPista), findsOneWidget);

    // "Deshacer" la vuelve a dejar marcada como estaba.
    await pulsarTexto(tester, 'Deshacer');
    expect(
      entorno.tomas.registros.single.momento,
      DateTime(2026, 10, 25, 8, 2),
    );
  });

  testWidgets('sin medicamentos muestra un mensaje amable', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());
    await abrirTomasDeHoy(tester);
    expect(find.text(es.tomasVacio), findsOneWidget);
  });

  testWidgets('el historial muestra hoy y los días anteriores', (tester) async {
    usarPantallaDeTelefono(tester, tamano: const Size(400, 2400));
    await arrancar(
      tester,
      EntornoDePrueba(
        medicamentos: [
          Medicamento(
            id: 3,
            nombre: 'Paracetamol',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: const HoraDelDia(8, 0),
            fechaCreacion: DateTime(2026, 10, 23),
          ),
        ],
        tomas: [
          tomada(
            DateTime(2026, 10, 24),
            const HoraDelDia(8, 0),
            DateTime(2026, 10, 24, 8, 10),
          ),
        ],
      ),
    );
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Historial de tomas');

    expect(find.text(es.historialTitulo), findsWidgets);
    // Desde el viernes han tocado tres tomas y se ha marcado una.
    expect(
      find.text('En los últimos 7 días has marcado 1 de 3 tomas (33 %).'),
      findsOneWidget,
    );
    expect(find.text('Hoy, domingo, 25 de octubre de 2026'), findsOneWidget);
    expect(find.text('Ayer, sábado, 24 de octubre de 2026'), findsOneWidget);
    expect(find.text('Viernes, 23 de octubre de 2026'), findsOneWidget);
    // El medicamento no existía antes del día 23.
    expect(find.textContaining('22 de octubre'), findsNothing);
    expect(
      find.text('08:00 · Paracetamol: tomada a las 08:10'),
      findsOneWidget,
    );
    expect(find.text('08:00 · Paracetamol: sin marcar'), findsNWidgets(2));
  });

  group('cuando haga falta', () {
    final ibuprofeno = Medicamento(
      id: 8,
      nombre: 'Ibuprofeno',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      dosis: '1 sobre',
      aDemanda: true,
    );

    Future<void> cerrarMensaje(WidgetTester tester) async {
      tester
          .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger).first)
          .removeCurrentSnackBar();
      await tester.pumpAndSettle();
    }

    testWidgets('se anota al tomarlo, con su hora, y se puede deshacer o '
        'quitar', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(medicamentos: [ibuprofeno]);
      await arrancar(tester, entorno);
      await abrirTomasDeHoy(tester);
      // Sin tomas previstas: ni "ninguna toma" ni el recuento.
      expect(find.text(es.tomasVacio), findsNothing);
      expect(find.textContaining('Has tomado'), findsNothing);
      expect(find.text(es.tomasADemandaTitulo), findsOneWidget);
      expect(find.text('Hoy no lo has tomado'), findsOneWidget);

      await pulsarEtiqueta(tester, 'He tomado Ibuprofeno ahora');
      expect(
        find.text('Anotado: has tomado Ibuprofeno (09:00).'),
        findsOneWidget,
      );
      expect(find.text('Hoy lo has tomado a las 09:00'), findsOneWidget);
      final registro = entorno.tomas.registros.single;
      expect(registro.medicamentoId, ibuprofeno.id);
      expect(registro.hora, const HoraDelDia(9, 0));
      expect(registro.estado, EstadoToma.tomada);

      await pulsarTexto(tester, 'Deshacer');
      expect(entorno.tomas.registros, isEmpty);
      expect(find.text('Hoy no lo has tomado'), findsOneWidget);
      await cerrarMensaje(tester);

      // Dos veces más tarde; "Quitar la última" quita la de las 14:30.
      entorno.ahora = DateTime(2026, 10, 25, 11, 15);
      await pulsarEtiqueta(tester, 'He tomado Ibuprofeno ahora');
      await cerrarMensaje(tester);
      entorno.ahora = DateTime(2026, 10, 25, 14, 30);
      await pulsarEtiqueta(tester, 'He tomado Ibuprofeno ahora');
      await cerrarMensaje(tester);
      expect(
        find.text('Hoy lo has tomado 2 veces: a las 11:15 y 14:30'),
        findsOneWidget,
      );
      await pulsarEtiqueta(tester, 'Quitar la toma de Ibuprofeno de las 14:30');
      expect(entorno.tomas.registros.map((r) => r.hora), const [
        HoraDelDia(11, 15),
      ]);
      expect(find.text('Toma desmarcada: Ibuprofeno (14:30).'), findsOneWidget);
    });

    testWidgets('con sus límites, avisa antes de anotar una de más', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final calmante = Medicamento(
        id: 8,
        nombre: 'Ibuprofeno',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 1),
        aDemanda: true,
        maximoAlDia: 2,
        horasEntreTomas: 6,
      );
      RegistroToma anotada(int hora) => RegistroToma(
        medicamentoId: 8,
        nombreMedicamento: 'Ibuprofeno',
        fecha: hoy,
        hora: HoraDelDia(hora, 0),
        estado: EstadoToma.tomada,
        momento: DateTime(2026, 10, 25, hora),
      );
      final entorno = EntornoDePrueba(
        medicamentos: [calmante],
        tomas: [anotada(7)],
      );
      await arrancar(tester, entorno);
      await abrirTomasDeHoy(tester);
      expect(
        find.text(
          'Como mucho 2 veces al día, con al menos 6 horas entre una y otra.',
        ),
        findsOneWidget,
      );
      expect(find.text('La próxima, a partir de las 13:00'), findsOneWidget);

      // Antes de tiempo: lo explica y, si no se ha tomado, no lo anota.
      await pulsarEtiqueta(tester, 'He tomado Ibuprofeno ahora');
      expect(find.text(es.tomasADemandaAvisoTitulo), findsOneWidget);
      expect(
        find.textContaining(
          'Entre una toma de Ibuprofeno y otra tienen que pasar al menos 6 '
          'horas.\nLa próxima, a partir de las 13:00.',
        ),
        findsOneWidget,
      );
      await pulsarTexto(tester, es.tomasADemandaAvisoNo);
      expect(entorno.tomas.registros, hasLength(1));

      // Si se ha tomado, se anota igualmente.
      await pulsarEtiqueta(tester, 'He tomado Ibuprofeno ahora');
      await pulsarTexto(tester, es.tomasADemandaAvisoSi);
      expect(entorno.tomas.registros, hasLength(2));
      expect(
        find.text('Hoy ya lo has tomado las 2 veces que se puede'),
        findsOneWidget,
      );

      // Pasado el tiempo, el máximo de hoy también se avisa.
      entorno.ahora = DateTime(2026, 10, 25, 16, 0);
      await pulsarEtiqueta(tester, 'He tomado Ibuprofeno ahora');
      expect(
        find.textContaining(
          'Hoy ya has tomado Ibuprofeno 2 veces, que es el máximo al día.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('tienen que pasar'), findsNothing);
      await pulsarTexto(tester, es.tomasADemandaAvisoNo);
      expect(entorno.tomas.registros, hasLength(2));
    });

    testWidgets('va después de las tomas previstas y, en el historial, '
        'aparte', (tester) async {
      usarPantallaDeTelefono(tester, tamano: const Size(400, 2400));
      await arrancar(
        tester,
        EntornoDePrueba(
          medicamentos: [paracetamol, ibuprofeno],
          tomas: [
            RegistroToma(
              medicamentoId: ibuprofeno.id,
              nombreMedicamento: ibuprofeno.nombre,
              fecha: hoy,
              hora: const HoraDelDia(8, 40),
              estado: EstadoToma.tomada,
              momento: DateTime(2026, 10, 25, 8, 40),
            ),
          ],
        ),
      );
      await abrirTomasDeHoy(tester);
      expect(find.text('Has tomado 0 de 3.'), findsOneWidget);
      expect(find.text('Hoy lo has tomado a las 08:40'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text(es.tomasADemandaTitulo)).dy,
        greaterThan(tester.getTopLeft(find.textContaining('16:00 de la')).dy),
      );

      await pulsarTexto(tester, 'Atrás');
      await pulsarTexto(tester, 'Historial de tomas');
      expect(
        find.text('08:40 · Ibuprofeno: tomada cuando hacía falta'),
        findsOneWidget,
      );
      // No cuenta entre las tomas previstas de ningún día.
      expect(
        find.text('Marcadas: 0 de 3.'),
        findsNWidgets(TomasController.diasHistorial),
      );
    });
  });

  group('respuestas a los avisos', () {
    testWidgets('"Ya la he tomado" con la app abierta: anota la toma y abre '
        '"Tomas de hoy"', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [paracetamol],
        ahora: DateTime(2026, 10, 25, 8, 3),
      );
      await arrancar(tester, entorno);

      entorno.notificaciones.responder(
        RespuestaAviso(
          accion: AccionesAviso.tomada,
          carga: const CargaToma(
            medicamentoId: 3,
            hora: HoraDelDia(8, 0),
          ).codificar(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(es.tomasTitulo), findsWidgets);
      expect(
        find.text('Anotado: has tomado Paracetamol (08:00).'),
        findsOneWidget,
      );
      expect(find.text('Tomada a las 08:03'), findsOneWidget);
      expect(entorno.tomas.registros.single.fecha, hoy);
    });

    testWidgets('"Recordar en 10 min" aplaza la toma y lo muestra', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [paracetamol],
        ahora: DateTime(2026, 10, 25, 8, 3),
      );
      await arrancar(tester, entorno);

      entorno.notificaciones.responder(
        RespuestaAviso(
          accion: AccionesAviso.aplazar,
          carga: const CargaToma(
            medicamentoId: 3,
            hora: HoraDelDia(8, 0),
          ).codificar(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Te lo recordaremos a las 08:13.'), findsOneWidget);
      expect(
        find.text('Aplazada: te lo recordaremos a las 08:13'),
        findsOneWidget,
      );
    });

    testWidgets('"Recordar en 10 min" usa los minutos elegidos en Ajustes', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [paracetamol],
        ajustes: const Ajustes(minutosAplazamiento: 30),
        ahora: DateTime(2026, 10, 25, 8, 3),
      );
      await arrancar(tester, entorno);

      entorno.notificaciones.responder(
        RespuestaAviso(
          accion: AccionesAviso.aplazar,
          carga: const CargaToma(
            medicamentoId: 3,
            hora: HoraDelDia(8, 0),
          ).codificar(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Te lo recordaremos a las 08:33.'), findsOneWidget);
      expect(
        entorno.tomas.registros.single.recordarEn,
        DateTime(2026, 10, 25, 8, 33),
      );
    });

    testWidgets('si la app se abre tocando un aviso, va a "Tomas de hoy"', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(
          medicamentos: [paracetamol],
          notificaciones: ServicioNotificacionesFalso(
            inicial: RespuestaAviso(
              carga: const CargaToma(
                medicamentoId: 3,
                hora: HoraDelDia(8, 0),
              ).codificar(),
            ),
          ),
        ),
      );
      expect(find.text(es.tomasTitulo), findsWidgets);

      // "Atrás" vuelve al menú principal.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Menú principal'), findsOneWidget);
    });

    testWidgets('tocar un aviso de cita abre la agenda', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      entorno.notificaciones.responder(
        RespuestaAviso(carga: const CargaCita(1).codificar()),
      );
      await tester.pumpAndSettle();
      // "Crear cita" solo existe en la agenda (el menú también dice "Agenda").
      expect(find.text('Crear cita'), findsOneWidget);
    });
  });

  // Android junta varios avisos de la app en un grupo; al tocar el grupo abre
  // la app sin decir de qué aviso se trata (como el icono de la app).
  group('abrir la app sin tocar el aviso', () {
    // Con los avisos activados, el de las 08:00 llega a su hora y su
    // repetición, a las 08:30.
    const avisos = Ajustes(notificacionesActivadas: true);
    const sinMarcar = 'Sin marcar. Era a las 08:00.';

    testWidgets('si en la última hora llegó el aviso de una toma sin marcar, '
        'abre "Tomas de hoy"', (tester) async {
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(
          medicamentos: [paracetamol],
          ajustes: avisos,
          ahora: DateTime(2026, 10, 25, 8, 40),
        ),
      );
      expect(find.text(sinMarcar), findsOneWidget);

      // "Atrás" vuelve al menú principal.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Menú principal'), findsOneWidget);
    });

    testWidgets('si el aviso es de hace más de una hora, abre el menú', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(
          medicamentos: [paracetamol],
          ajustes: avisos,
          ahora: DateTime(2026, 10, 25, 9, 31),
        ),
      );
      expect(find.text('Menú principal'), findsOneWidget);
    });

    testWidgets('con los avisos desactivados, abre el menú', (tester) async {
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(
          medicamentos: [paracetamol],
          ahora: DateTime(2026, 10, 25, 8, 40),
        ),
      );
      expect(find.text('Menú principal'), findsOneWidget);
    });

    testWidgets('al volver del segundo plano, si mientras tanto llegó el '
        'aviso, abre "Tomas de hoy" encima de lo que había', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [paracetamol],
        ajustes: avisos,
        ahora: DateTime(2026, 10, 25, 7, 50),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Agenda');

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      entorno.ahora = DateTime(2026, 10, 25, 8, 5);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text(sinMarcar), findsOneWidget);

      // "Atrás" vuelve a la agenda, que sigue como estaba.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Crear cita'), findsOneWidget);
    });

    testWidgets('al volver del segundo plano no cambia de pantalla si el '
        'aviso había llegado antes (por ejemplo, al volver de la cámara)', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [paracetamol],
        ajustes: avisos,
        ahora: DateTime(2026, 10, 25, 8, 10),
      );
      await arrancar(tester, entorno);
      expect(find.text(sinMarcar), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await pulsarTexto(tester, 'Agenda');

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      entorno.ahora = DateTime(2026, 10, 25, 8, 20);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('Crear cita'), findsOneWidget);
      expect(find.text(sinMarcar), findsNothing);
    });
  });

  testWidgets('el menú resume las tomas de hoy marcadas', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(
      tester,
      EntornoDePrueba(
        medicamentos: [paracetamol],
        tomas: [
          tomada(hoy, const HoraDelDia(8, 0), DateTime(2026, 10, 25, 8, 2)),
        ],
      ),
    );
    expect(find.text('Tomas de hoy: 1 de 3 marcadas.'), findsOneWidget);
    expect(
      find.text('Próxima toma: Paracetamol, hoy a las 16:00.'),
      findsOneWidget,
    );
  });
}
