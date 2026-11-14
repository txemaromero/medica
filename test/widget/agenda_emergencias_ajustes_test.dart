import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/core/widgets/interruptor_grande.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/agenda/domain/recordatorios_cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';
import '../helpers/textos.dart';

void main() {
  group('Agenda', () {
    testWidgets('sin citas muestra un mensaje amable y el botón Crear cita', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba());
      await pulsarTexto(tester, 'Agenda');

      expect(find.text(es.agendaVacio), findsOneWidget);
      expect(find.text(es.agendaCrearCita), findsOneWidget);
    });

    testWidgets('muestra las citas ordenadas: próximas primero', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester, tamano: const Size(400, 1600));
      await arrancar(
        tester,
        EntornoDePrueba(
          citas: [
            Cita(
              id: 1,
              titulo: 'Dentista',
              fecha: DateTime(2026, 11, 3),
              hora: const HoraDelDia(10, 0),
            ),
            Cita(
              id: 2,
              titulo: 'Análisis',
              fecha: DateTime(2026, 10, 26),
              hora: const HoraDelDia(8, 30),
              lugar: 'Centro de salud',
            ),
            Cita(
              id: 3,
              titulo: 'Vacuna',
              fecha: DateTime(2026, 10, 20),
              hora: const HoraDelDia(12, 0),
            ),
          ],
        ),
      );
      await pulsarTexto(tester, 'Agenda');

      final y = {
        for (final t in ['Análisis', 'Dentista', 'Vacuna'])
          t: tester.getTopLeft(find.text(t)).dy,
      };
      expect(y['Análisis']!, lessThan(y['Dentista']!));
      expect(y['Dentista']!, lessThan(y['Vacuna']!));
      expect(find.text('Mañana, lunes, 26 de octubre de 2026'), findsOneWidget);
      expect(find.text('Centro de salud'), findsOneWidget);
      expect(find.text('Esta cita ya ha pasado.'), findsOneWidget);
    });

    testWidgets('crear cita: valida, confirma y aparece en la agenda', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        ajustes: const Ajustes(notificacionesActivadas: true),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Agenda');
      await pulsarTexto(tester, es.agendaCrearCita);
      expect(find.text(es.agendaCrearCita), findsWidgets);

      await pulsarTexto(tester, es.formularioCitaGuardar);
      expect(
        find.textContaining('Escribe el motivo de la cita'),
        findsOneWidget,
      );
      expect(entorno.citas.guardadas, isEmpty);

      await escribir(tester, find.byType(TextField).first, 'Cardiólogo');
      await pulsarEtiqueta(tester, 'Día siguiente');
      await pulsarEtiqueta(tester, 'Día siguiente');
      expect(
        find.text('Día elegido: Martes, 27 de octubre de 2026'),
        findsOneWidget,
      );

      await pulsarTexto(tester, es.formularioCitaGuardar);
      expect(find.text(es.formularioCitaGuardada), findsOneWidget);
      expect(
        find.textContaining(
          'Te avisaremos el día antes a las 18:00, ese día a las 08:00 y una '
          'hora antes.',
        ),
        findsOneWidget,
      );
      final cita = entorno.citas.guardadas.single;
      expect(cita.titulo, 'Cardiólogo');
      expect(cita.fechaHora, DateTime(2026, 10, 27, 10, 0));

      await pulsarTexto(tester, 'Aceptar');
      expect(find.text(es.menuAgenda), findsOneWidget);
      expect(find.text('Cardiólogo'), findsOneWidget);
    });

    testWidgets('no deja elegir un día anterior a hoy', (tester) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba());
      await pulsarTexto(tester, 'Agenda');
      await pulsarTexto(tester, es.agendaCrearCita);

      expect(
        tester.getSemantics(find.bySemanticsLabel('Día anterior')),
        isSemantics(hasEnabledState: true, isEnabled: false),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Día siguiente')),
        isSemantics(hasEnabledState: true, isEnabled: true),
      );
    });

    testWidgets('los atajos "Mañana" y "En una semana" eligen el día', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba());
      await pulsarTexto(tester, 'Agenda');
      await pulsarTexto(tester, es.agendaCrearCita);

      await pulsarTexto(tester, 'Mañana');
      expect(
        find.text('Día elegido: Mañana, lunes, 26 de octubre de 2026'),
        findsOneWidget,
      );
      await pulsarTexto(tester, 'En una semana');
      expect(
        find.text('Día elegido: Domingo, 1 de noviembre de 2026'),
        findsOneWidget,
      );
      await pulsarTexto(tester, 'Hoy');
      expect(
        find.text('Día elegido: Hoy, domingo, 25 de octubre de 2026'),
        findsOneWidget,
      );
    });

    testWidgets('modificar una cita próxima guarda los cambios', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final cita = Cita(
        id: 3,
        titulo: 'Dentista',
        fecha: DateTime(2026, 10, 28),
        hora: const HoraDelDia(10, 0),
        lugar: 'Clínica',
      );
      final entorno = EntornoDePrueba(
        citas: [cita],
        ajustes: const Ajustes(notificacionesActivadas: true),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Agenda');

      await pulsarTexto(tester, 'Modificar');
      expect(find.text(es.formularioCitaTituloModificar), findsOneWidget);
      expect(find.text('Dentista'), findsOneWidget);
      expect(find.text('Clínica'), findsOneWidget);

      await pulsarTexto(tester, 'Mañana');
      await pulsarTexto(tester, es.formularioGuardarCambios);
      expect(find.text(es.formularioCambiosGuardados), findsOneWidget);
      final guardada = entorno.citas.guardadas.single;
      expect(guardada.id, 3);
      expect(guardada.fechaHora, DateTime(2026, 10, 26, 10, 0));
      expect(guardada.lugar, 'Clínica');
      expect(
        entorno.notificaciones.idsProgramados,
        contains(PlanificadorAvisos.idAvisoCita(3, TipoAvisoCita.unaHoraAntes)),
      );

      await pulsarTexto(tester, 'Aceptar');
      expect(find.text(es.menuAgenda), findsOneWidget);
      expect(find.text('Mañana, lunes, 26 de octubre de 2026'), findsOneWidget);
    });

    testWidgets('las citas pasadas no se modifican, solo se eliminan', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(
          citas: [
            Cita(
              id: 1,
              titulo: 'Vacuna',
              fecha: DateTime(2026, 10, 20),
              hora: const HoraDelDia(12, 0),
            ),
          ],
        ),
      );
      await pulsarTexto(tester, 'Agenda');
      expect(find.text('Modificar'), findsNothing);
      expect(find.text('Eliminar'), findsOneWidget);
    });

    testWidgets('eliminar cita pide confirmación y se puede deshacer', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final cita = Cita(
        id: 5,
        titulo: 'Fisioterapia',
        fecha: DateTime(2026, 10, 29),
        hora: const HoraDelDia(17, 0),
      );
      final entorno = EntornoDePrueba(citas: [cita]);
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Agenda');

      await pulsarTexto(tester, 'Eliminar');
      expect(find.text(es.agendaPreguntaEliminar), findsOneWidget);
      await pulsarTexto(tester, 'Sí, eliminar');
      expect(entorno.citas.guardadas, isEmpty);
      expect(find.text('Cita eliminada: Fisioterapia'), findsOneWidget);

      await pulsarTexto(tester, 'Deshacer');
      expect(entorno.citas.guardadas, [cita]);
      expect(find.text('Fisioterapia'), findsOneWidget);
    });

    testWidgets('el mensaje de "Deshacer" no tapa el botón "Crear cita"', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(
          citas: [
            Cita(
              id: 5,
              titulo: 'Fisioterapia',
              fecha: DateTime(2026, 10, 29),
              hora: const HoraDelDia(17, 0),
            ),
          ],
        ),
      );
      await pulsarTexto(tester, 'Agenda');
      await pulsarTexto(tester, 'Eliminar');
      await pulsarTexto(tester, 'Sí, eliminar');
      expect(find.text('Deshacer'), findsOneWidget);

      // El mensaje sigue visible y aun así el botón responde: se abre el
      // formulario (el campo "Motivo" solo existe en él).
      await tester.tap(find.text(es.agendaCrearCita));
      await tester.pumpAndSettle();
      expect(find.text('Motivo de la cita'), findsOneWidget);
    });
  });

  group('Emergencias', () {
    testWidgets('sin número explica qué hacer y lleva a Ajustes', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Botón de emergencias');

      expect(find.text(es.emergenciasSinNumero), findsOneWidget);
      expect(find.text(es.emergenciasLlamar), findsNothing);
      await pulsarTexto(tester, 'Ir a Ajustes');
      expect(find.text('Activar notificaciones'), findsOneWidget);
      expect(entorno.marcador.numerosMarcados, isEmpty);
    });

    testWidgets('entrar no llama; pulsar "Llamar" abre el marcador con el '
        'número', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        ajustes: const Ajustes(numeroEmergencia: '112'),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Botón de emergencias');

      expect(find.text(es.emergenciasLlamar), findsOneWidget);
      expect(entorno.marcador.numerosMarcados, isEmpty);

      await pulsarTexto(tester, es.emergenciasLlamar);
      expect(entorno.marcador.numerosMarcados, ['112']);
    });

    testWidgets('si no se puede abrir el marcador lo explica', (tester) async {
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(
          ajustes: const Ajustes(numeroEmergencia: '112'),
          marcador: MarcadorTelefonoFalso(resultado: false),
        ),
      );
      await pulsarTexto(tester, 'Botón de emergencias');
      await pulsarTexto(tester, es.emergenciasLlamar);
      expect(find.text('No se ha podido abrir el teléfono'), findsOneWidget);
    });
  });

  group('Ajustes', () {
    testWidgets('los cinco interruptores empiezan desactivados y cambian con '
        'texto de estado', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');

      expect(find.byType(InterruptorGrande), findsNWidgets(5));
      expect(find.text(es.interruptorDesactivado), findsNWidgets(5));

      await pulsarTexto(tester, 'Activar sonidos');
      expect(entorno.ajustes.ajustes.sonidoActivado, isTrue);
      expect(find.text(es.interruptorActivado), findsOneWidget);
      expect(find.text('Sonidos activados'), findsOneWidget);

      await pulsarTexto(tester, 'Activar notificaciones');
      expect(entorno.ajustes.ajustes.notificacionesActivadas, isTrue);
      expect(entorno.notificaciones.solicitudesPermiso, 1);
      expect(find.text(es.interruptorActivado), findsNWidgets(2));
    });

    testWidgets('si se deniega el permiso, lo explica y sigue desactivado', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        notificaciones: ServicioNotificacionesFalso(permiso: false),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Activar notificaciones');

      expect(find.text('Falta el permiso del teléfono'), findsOneWidget);
      await pulsarTexto(tester, 'Ahora no');
      expect(entorno.ajustes.ajustes.notificacionesActivadas, isFalse);
      expect(find.text(es.interruptorDesactivado), findsNWidgets(5));
      expect(entorno.notificaciones.aperturasAjustesTelefono, 0);

      // La segunda vez se acepta abrir los ajustes del teléfono.
      await pulsarTexto(tester, 'Activar notificaciones');
      await pulsarTexto(tester, 'Abrir ajustes del teléfono');
      expect(entorno.notificaciones.aperturasAjustesTelefono, 1);
    });

    group('Probar aviso', () {
      testWidgets('envía un aviso con el sonido y la vibración elegidos', (
        tester,
      ) async {
        usarPantallaDeTelefono(tester);
        final entorno = EntornoDePrueba(
          ajustes: const Ajustes(
            notificacionesActivadas: true,
            sonidoActivado: true,
          ),
        );
        await arrancar(tester, entorno);
        await pulsarTexto(tester, 'Ajustes');
        await pulsarTexto(tester, 'Probar aviso');

        expect(entorno.notificaciones.avisosDePrueba, [
          const CanalAvisos(sonido: true, vibracion: false),
        ]);
        expect(find.textContaining('Aviso de prueba enviado'), findsOneWidget);
      });

      testWidgets('con las notificaciones apagadas explica qué hacer', (
        tester,
      ) async {
        usarPantallaDeTelefono(tester);
        final entorno = EntornoDePrueba();
        await arrancar(tester, entorno);
        await pulsarTexto(tester, 'Ajustes');
        await pulsarTexto(tester, 'Probar aviso');

        expect(
          find.text('Las notificaciones están desactivadas'),
          findsOneWidget,
        );
        expect(entorno.notificaciones.avisosDePrueba, isEmpty);
      });

      testWidgets('si el teléfono ha quitado el permiso ofrece sus ajustes', (
        tester,
      ) async {
        usarPantallaDeTelefono(tester);
        final entorno = EntornoDePrueba(
          ajustes: const Ajustes(notificacionesActivadas: true),
          notificaciones: ServicioNotificacionesFalso(permiso: false),
        );
        await arrancar(tester, entorno);
        await pulsarTexto(tester, 'Ajustes');
        await pulsarTexto(tester, 'Probar aviso');

        expect(find.text('Falta el permiso del teléfono'), findsOneWidget);
        await pulsarTexto(tester, 'Abrir ajustes del teléfono');
        expect(entorno.notificaciones.aperturasAjustesTelefono, 1);
        expect(entorno.notificaciones.avisosDePrueba, isEmpty);
      });
    });

    testWidgets('sin alarmas exactas ofrece dar el permiso', (tester) async {
      usarPantallaDeTelefono(tester);
      final servicio = ServicioNotificacionesFalso(alarmasExactas: false);
      await arrancar(tester, EntornoDePrueba(notificaciones: servicio));
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Activar notificaciones');

      expect(find.text('Avisos a la hora exacta'), findsOneWidget);
      await pulsarTexto(tester, 'Dar permiso');
      expect(servicio.solicitudesAlarmasExactas, 1);
    });

    group('comprobación de los avisos', () {
      const avisos = Ajustes(notificacionesActivadas: true);

      Future<EntornoDePrueba> abrirAjustes(
        WidgetTester tester, {
        Ajustes ajustes = avisos,
        ServicioNotificacionesFalso? notificaciones,
        ServicioBateriaFalso? bateria,
      }) async {
        usarPantallaDeTelefono(tester);
        final entorno = EntornoDePrueba(
          ajustes: ajustes,
          notificaciones: notificaciones,
          bateria: bateria,
        );
        await arrancar(tester, entorno);
        await pulsarTexto(tester, 'Ajustes');
        return entorno;
      }

      testWidgets('con todo bien dice que los avisos están listos', (
        tester,
      ) async {
        await abrirAjustes(tester);
        expect(find.text(es.estadoAvisosListos), findsOneWidget);
      });

      testWidgets('con los avisos desactivados no comprueba nada', (
        tester,
      ) async {
        await abrirAjustes(
          tester,
          ajustes: const Ajustes(),
          notificaciones: ServicioNotificacionesFalso(permiso: false),
        );
        expect(find.text(es.estadoAvisosListos), findsNothing);
        expect(find.text(es.estadoAvisosSinPermiso), findsNothing);
      });

      testWidgets('sin permiso del teléfono lo pide y, si no lo da, ofrece '
          'sus ajustes', (tester) async {
        final servicio = ServicioNotificacionesFalso(permiso: false);
        await abrirAjustes(tester, notificaciones: servicio);
        expect(find.text(es.estadoAvisosSinPermiso), findsOneWidget);

        await pulsarTexto(tester, es.estadoAvisosBotonPermiso);
        expect(servicio.solicitudesPermiso, 1);
        expect(find.text(es.permisosFaltaTitulo), findsOneWidget);
        await pulsarTexto(tester, es.permisosAbrirAjustes);
        expect(servicio.aperturasAjustesTelefono, 1);

        // Si esta vez el teléfono da el permiso, queda todo bien.
        servicio.permiso = true;
        await pulsarTexto(tester, es.estadoAvisosBotonPermiso);
        expect(find.text(es.estadoAvisosPermisoConcedido), findsOneWidget);
        expect(find.text(es.estadoAvisosSinPermiso), findsNothing);
        expect(find.text(es.estadoAvisosListos), findsOneWidget);
      });

      testWidgets('sin hora exacta ofrece el permiso', (tester) async {
        final servicio = ServicioNotificacionesFalso(alarmasExactas: false);
        await abrirAjustes(tester, notificaciones: servicio);
        expect(find.text(es.estadoAvisosSinHoraExacta), findsOneWidget);

        await pulsarTexto(tester, es.estadoAvisosBotonHoraExacta);
        expect(find.text(es.permisosHoraExactaTitulo), findsOneWidget);
        await pulsarTexto(tester, es.permisosDarPermiso);
        expect(servicio.solicitudesAlarmasExactas, 1);
        expect(find.text(es.permisosHoraExactaDenegado), findsOneWidget);
      });

      testWidgets('el ahorro de batería de un Samsung se señala y lleva a '
          'los ajustes de la app', (tester) async {
        final bateria = ServicioBateriaFalso(
          optimizada: true,
          fabricante: 'samsung',
        );
        await abrirAjustes(tester, bateria: bateria);
        expect(find.text(es.estadoAvisosAhorroBateria), findsOneWidget);

        await pulsarTexto(tester, es.estadoAvisosBotonBateria);
        expect(find.text(es.bateriaTitulo), findsOneWidget);
        await pulsarTexto(tester, es.bateriaAbrir);
        expect(bateria.aperturasAjustes, 1);
      });

      testWidgets('la optimización normal de un Pixel no se señala', (
        tester,
      ) async {
        await abrirAjustes(
          tester,
          bateria: ServicioBateriaFalso(optimizada: true),
        );
        expect(find.text(es.estadoAvisosAhorroBateria), findsNothing);
        expect(find.text(es.estadoAvisosListos), findsOneWidget);
      });

      testWidgets('con todos los problemas a la vista cumple las guías de '
          'accesibilidad', (tester) async {
        final semantica = tester.ensureSemantics();
        await abrirAjustes(
          tester,
          notificaciones: ServicioNotificacionesFalso(
            permiso: false,
            alarmasExactas: false,
          ),
          bateria: ServicioBateriaFalso(restringida: true),
        );
        await tester.ensureVisible(find.text(es.estadoAvisosBotonBateria));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        comprobarNodosSemanticos(tester);
        semantica.dispose();
      });

      testWidgets('el menú avisa si el teléfono no deja mostrar avisos y deja '
          'de hacerlo al dar el permiso', (tester) async {
        usarPantallaDeTelefono(tester);
        final servicio = ServicioNotificacionesFalso(permiso: false);
        await arrancar(
          tester,
          EntornoDePrueba(ajustes: avisos, notificaciones: servicio),
        );
        expect(find.text(es.menuAvisosSinPermiso), findsOneWidget);

        servicio.permiso = true;
        await pulsarTexto(tester, es.estadoAvisosBotonPermiso);
        expect(find.text(es.menuAvisosSinPermiso), findsNothing);
      });

      testWidgets('al volver a la app se comprueba de nuevo (el permiso se '
          'quita en los ajustes del teléfono)', (tester) async {
        usarPantallaDeTelefono(tester);
        final servicio = ServicioNotificacionesFalso();
        await arrancar(
          tester,
          EntornoDePrueba(ajustes: avisos, notificaciones: servicio),
        );
        expect(find.text(es.menuAvisosSinPermiso), findsNothing);

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
        servicio.permiso = false;
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pumpAndSettle();
        expect(find.text(es.menuAvisosSinPermiso), findsOneWidget);
      });
    });

    testWidgets('"Repetir los avisos" cambia cuándo se repite el aviso y los '
        'minutos de "Recordar en 10 min"', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [
          Medicamento(
            id: 4,
            nombre: 'Omeprazol',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: const HoraDelDia(10, 0),
            fechaCreacion: DateTime(2026, 10, 1),
          ),
        ],
        ajustes: const Ajustes(notificacionesActivadas: true),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      expect(find.textContaining('"Recordar en 10 min"'), findsOneWidget);
      await pulsarTexto(tester, es.ajustesRepetirAvisos);
      expect(
        find.text('Una toma de las 08:00 se repite a las 08:30.'),
        findsOneWidget,
      );

      await pulsarTexto(tester, 'A los 15 minutos');
      expect(find.text('Guardado: A los 15 minutos'), findsOneWidget);
      expect(entorno.ajustes.ajustes.minutosRepeticion, 15);
      expect(
        entorno.notificaciones.deTipo(TipoAviso.repeticion).first.momento,
        UnaVez(DateTime(2026, 10, 25, 10, 15)),
      );

      await pulsarTexto(tester, 'No repetir el aviso');
      expect(entorno.ajustes.ajustes.minutosRepeticion, 0);
      expect(entorno.notificaciones.deTipo(TipoAviso.repeticion), isEmpty);
      expect(entorno.notificaciones.deTipo(TipoAviso.toma), hasLength(1));

      await pulsarTexto(tester, 'Recordar en 5 min');
      expect(entorno.ajustes.ajustes.minutosAplazamiento, 5);
      expect(
        entorno.notificaciones
            .deTipo(TipoAviso.toma)
            .single
            .minutosAplazamiento,
        5,
      );

      await pulsarTexto(tester, 'Atrás');
      expect(find.textContaining('"Recordar en 5 min"'), findsOneWidget);
    });

    testWidgets('"Avisos discretos" quita de los avisos el nombre de la '
        'medicina, el motivo de la cita y la foto', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [
          Medicamento(
            id: 4,
            nombre: 'Omeprazol',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: const HoraDelDia(10, 0),
            fechaCreacion: DateTime(2026, 10, 1),
            foto: 'caja_4.jpg',
          ),
        ],
        citas: [
          Cita(
            id: 2,
            titulo: 'Oncología',
            fecha: DateTime(2026, 10, 27),
            hora: const HoraDelDia(11, 0),
            lugar: 'Hospital',
          ),
        ],
        ajustes: const Ajustes(notificacionesActivadas: true),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      AvisoProgramado primero(TipoAviso tipo) =>
          entorno.notificaciones.deTipo(tipo).first;

      await pulsarTexto(tester, es.ajustesAvisosDiscretos);
      expect(entorno.ajustes.ajustes.avisosDiscretos, isTrue);
      expect(find.text('Avisos discretos activados'), findsOneWidget);
      expect(
        primero(TipoAviso.toma).cuerpo,
        'La de las 10:00. Toca aquí para ver cuál es.',
      );
      expect(primero(TipoAviso.toma).foto, isNull);
      expect(
        primero(TipoAviso.cita).cuerpo,
        'A las 11:00. Toca aquí para ver cuál es.',
      );

      await pulsarTexto(tester, es.ajustesAvisosDiscretos);
      expect(entorno.ajustes.ajustes.avisosDiscretos, isFalse);
      expect(primero(TipoAviso.toma).cuerpo, 'Toma Omeprazol (10:00).');
      expect(primero(TipoAviso.toma).foto, 'caja_4.jpg');
      expect(
        primero(TipoAviso.cita).cuerpo,
        'Oncología a las 11:00 en Hospital.',
      );
    });

    testWidgets('valida y guarda el número de emergencia', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');

      // El primer campo de Ajustes es el del número de emergencia.
      final campo = find.byType(TextField).first;
      await tester.ensureVisible(campo);
      await tester.enterText(campo, '12');
      await pulsarTexto(tester, 'Guardar número');
      expect(find.textContaining('demasiado corto'), findsOneWidget);
      expect(entorno.ajustes.ajustes.numeroEmergencia, isEmpty);

      await tester.enterText(campo, '600 12 34 56');
      await pulsarTexto(tester, 'Guardar número');
      expect(find.textContaining('demasiado corto'), findsNothing);
      expect(entorno.ajustes.ajustes.numeroEmergencia, '600123456');
      expect(
        find.text('Número de emergencia guardado: 600123456'),
        findsOneWidget,
      );
    });
  });
}
