import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';
import '../helpers/textos.dart';

void main() {
  EntornoDePrueba primeraVez({bool permiso = true}) => EntornoDePrueba(
    asistenteCompletado: false,
    notificaciones: ServicioNotificacionesFalso(permiso: permiso),
  );

  Finder paso(int numero) => find.textContaining('Paso $numero de 3');

  testWidgets('la primera vez se abre el asistente; saltarlo lleva al menú y '
      'no vuelve a salir', (tester) async {
    usarPantallaDeTelefono(tester);
    final entorno = primeraVez();
    await arrancar(tester, entorno);
    expect(find.text(es.asistenteTitulo), findsOneWidget);
    expect(find.text('Hola'), findsOneWidget);

    await pulsarTexto(tester, es.asistenteSaltar);
    expect(find.text('Menú principal'), findsOneWidget);
    expect(entorno.ajustes.asistente, isTrue);

    // Al volver a abrir la app empieza en el menú principal.
    await tester.pumpWidget(const SizedBox());
    await arrancar(tester, entorno);
    expect(find.text('Menú principal'), findsOneWidget);
    expect(find.text(es.asistenteTitulo), findsNothing);
  });

  testWidgets('recorrido completo: letra, avisos y número de emergencia', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = primeraVez();
    await arrancar(tester, entorno);

    await pulsarTexto(tester, es.asistenteEmpezar);
    expect(paso(1), findsOneWidget);
    await pulsarTexto(tester, es.tamanoAumentar);
    expect(entorno.ajustes.ajustes.tamanoTexto, 25);
    await pulsarTexto(tester, es.asistenteSiguiente);

    expect(paso(2), findsOneWidget);
    await pulsarTexto(tester, es.asistenteActivarAvisos);
    expect(entorno.notificaciones.solicitudesPermiso, 1);
    final ajustes = entorno.ajustes.ajustes;
    expect(ajustes.notificacionesActivadas, isTrue);
    expect(ajustes.sonidoActivado, isTrue);
    expect(ajustes.vibracionActivada, isTrue);
    expect(
      find.text('Los avisos están activados, con sonido y con vibración.'),
      findsOneWidget,
    );
    expect(find.text('Probar aviso'), findsOneWidget);
    await pulsarTexto(tester, es.asistenteSiguiente);

    // "Hecho" en el teclado guarda el número y pasa al final, igual que
    // "Siguiente".
    expect(paso(3), findsOneWidget);
    await escribir(tester, find.byType(TextField), '112');
    expect(entorno.ajustes.ajustes.numeroEmergencia, '112');

    expect(find.text('Todo listo'), findsOneWidget);
    expect(find.text('Tamaño de la letra: 25.'), findsOneWidget);
    expect(find.text('Avisos activados.'), findsOneWidget);
    expect(find.text('Número de emergencia: 112.'), findsOneWidget);
    expect(entorno.ajustes.asistente, isFalse);

    await pulsarTexto(tester, es.asistenteTerminar);
    expect(find.text('Menú principal'), findsOneWidget);
    expect(entorno.ajustes.asistente, isTrue);
  });

  testWidgets('"Atrás" vuelve al paso anterior y desde el primero sale al '
      'menú', (tester) async {
    usarPantallaDeTelefono(tester);
    final entorno = primeraVez();
    await arrancar(tester, entorno);
    await pulsarTexto(tester, es.asistenteEmpezar);
    await pulsarTexto(tester, es.asistenteSiguiente);
    expect(paso(2), findsOneWidget);

    // Botón "Atrás" de la barra y botón atrás de Android.
    await pulsarTexto(tester, 'Atrás');
    expect(paso(1), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Hola'), findsOneWidget);
    expect(entorno.ajustes.asistente, isFalse);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Menú principal'), findsOneWidget);
    expect(entorno.ajustes.asistente, isTrue);
  });

  testWidgets('"Inicio" sale del asistente desde cualquier paso', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = primeraVez();
    await arrancar(tester, entorno);
    await pulsarTexto(tester, es.asistenteEmpezar);
    await pulsarTexto(tester, 'Inicio');
    expect(find.text('Menú principal'), findsOneWidget);
    expect(entorno.ajustes.asistente, isTrue);
  });

  testWidgets('sin permiso lo explica y se puede seguir sin avisos', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = primeraVez(permiso: false);
    await arrancar(tester, entorno);
    await pulsarTexto(tester, es.asistenteEmpezar);
    await pulsarTexto(tester, es.asistenteSiguiente);
    await pulsarTexto(tester, es.asistenteActivarAvisos);

    expect(find.text('Falta el permiso del teléfono'), findsOneWidget);
    await pulsarTexto(tester, 'Ahora no');
    expect(entorno.ajustes.ajustes.notificacionesActivadas, isFalse);
    expect(entorno.ajustes.ajustes.sonidoActivado, isFalse);
    expect(find.text(es.asistenteActivarAvisos), findsOneWidget);

    await pulsarTexto(tester, es.asistenteSiguiente);
    await pulsarTexto(tester, es.asistenteSiguiente);
    expect(
      find.text('Avisos desactivados. Puedes activarlos en Ajustes.'),
      findsOneWidget,
    );
    expect(
      find.text('Sin número de emergencia. Puedes ponerlo en Ajustes.'),
      findsOneWidget,
    );
  });

  group('accesibilidad de todos los pasos', () {
    Future<void> recorrer(
      WidgetTester tester,
      Future<void> Function() comprobar,
    ) async {
      await comprobar();
      await pulsarTexto(tester, es.asistenteEmpezar);
      for (var i = 0; i < 3; i++) {
        await comprobar();
        await pulsarTexto(tester, es.asistenteSiguiente);
      }
      await comprobar();
      expect(find.text('Todo listo'), findsOneWidget);
    }

    testWidgets('áreas táctiles, etiquetas y contraste', (tester) async {
      usarPantallaDeTelefono(tester);
      final semantica = tester.ensureSemantics();
      await arrancar(tester, primeraVez());
      await recorrer(tester, () async {
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        comprobarNodosSemanticos(tester, motivo: 'asistente');
      });
      semantica.dispose();
    });

    testWidgets('sin desbordes con texto 35 en una pantalla de 320 dp', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester, tamano: const Size(320, 640));
      final entorno = EntornoDePrueba(
        asistenteCompletado: false,
        ajustes: const Ajustes(tamanoTexto: 35),
      );
      await arrancar(tester, entorno);
      await recorrer(tester, () async {
        await tester.drag(
          find.byType(Scrollable).first,
          const Offset(0, -5000),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });
  });

  testWidgets('un número de emergencia incorrecto se explica junto al campo', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = primeraVez();
    await arrancar(tester, entorno);
    await pulsarTexto(tester, es.asistenteEmpezar);
    await pulsarTexto(tester, es.asistenteSiguiente);
    await pulsarTexto(tester, es.asistenteSiguiente);

    await escribir(tester, find.byType(TextField), '11');
    await pulsarTexto(tester, es.asistenteSiguiente);
    expect(find.textContaining('demasiado corto'), findsOneWidget);
    expect(paso(3), findsOneWidget);
    expect(entorno.ajustes.ajustes.numeroEmergencia, '');
  });
}
