import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tema/paleta.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/textos.dart';

void main() {
  group('Ajustar tamaño de texto', () {
    double escalaMuestra(WidgetTester tester) {
      final parrafo = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byKey(const Key('muestra-texto')),
          matching: find.text(es.tamanoMuestraTexto),
        ),
      );
      return parrafo.textScaler.scale(20);
    }

    Future<EntornoDePrueba> abrir(
      WidgetTester tester, {
      Ajustes ajustes = const Ajustes(),
    }) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(ajustes: ajustes);
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Ajustar tamaño de texto');
      return entorno;
    }

    testWidgets('"+" aumenta de 5 en 5 y la muestra se redibuja en vivo', (
      tester,
    ) async {
      final entorno = await abrir(tester);
      expect(find.text('Tamaño actual: 20 (normal)'), findsOneWidget);
      expect(escalaMuestra(tester), 20);
      final altoInicial = tester
          .getSize(find.byKey(const Key('muestra-texto')))
          .height;

      await pulsarTexto(tester, es.tamanoAumentar);
      expect(find.text('Tamaño actual: 25'), findsOneWidget);
      expect(escalaMuestra(tester), 25);
      expect(
        tester.getSize(find.byKey(const Key('muestra-texto'))).height,
        greaterThan(altoInicial),
      );
      expect(entorno.ajustes.ajustes.tamanoTexto, 25);

      await pulsarTexto(tester, es.tamanoAumentar);
      await pulsarTexto(tester, es.tamanoAumentar);
      expect(find.text('Tamaño actual: 35 (máximo)'), findsOneWidget);
      expect(find.text('Ya está en el tamaño máximo.'), findsOneWidget);

      // En el máximo el botón no hace nada.
      await pulsarTexto(tester, es.tamanoAumentar);
      expect(entorno.ajustes.ajustes.tamanoTexto, 35);
      expect(escalaMuestra(tester), 35);
      expect(tester.takeException(), isNull);
    });

    testWidgets('"−" reduce hasta 10 como mínimo', (tester) async {
      final entorno = await abrir(tester);
      await pulsarTexto(tester, es.tamanoReducir);
      expect(find.text('Tamaño actual: 15'), findsOneWidget);
      await pulsarTexto(tester, es.tamanoReducir);
      expect(find.text('Tamaño actual: 10 (mínimo)'), findsOneWidget);
      await pulsarTexto(tester, es.tamanoReducir);
      expect(entorno.ajustes.ajustes.tamanoTexto, 10);
      expect(escalaMuestra(tester), 10);
    });

    testWidgets('el tamaño se aplica a toda la app', (tester) async {
      await abrir(tester);
      await pulsarTexto(tester, es.tamanoAumentar);
      await pulsarTexto(tester, 'Inicio');

      final titulo = tester.renderObject<RenderParagraph>(
        find.text('Menú principal'),
      );
      expect(titulo.textScaler.scale(20), 25);
    });
  });

  group('Ajustar tema', () {
    Color fondoDeLaApp(WidgetTester tester) =>
        Theme.of(tester.element(find.text(es.temaAplicar)))
            .scaffoldBackgroundColor;

    Color fondoDeLaMuestra(WidgetTester tester) {
      final caja = tester.widget<Container>(
        find.byKey(const Key('muestra-tema')),
      );
      return (caja.decoration! as BoxDecoration).color!;
    }

    testWidgets('al elegir un tema se previsualiza; se aplica al confirmar', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Ajustar tema');

      expect(fondoDeLaApp(tester), const Color(0xFFB6D8FF));
      expect(fondoDeLaMuestra(tester), const Color(0xFFB6D8FF));

      await pulsarTexto(tester, 'Tema oscuro');
      // La muestra cambia, pero la app todavía no.
      expect(fondoDeLaMuestra(tester), Paleta.oscura.fondo);
      expect(fondoDeLaApp(tester), const Color(0xFFB6D8FF));
      expect(entorno.ajustes.ajustes.tema, TemaApp.predeterminado);

      await pulsarTexto(tester, es.temaAplicar);
      expect(fondoDeLaApp(tester), Paleta.oscura.fondo);
      expect(entorno.ajustes.ajustes.tema, TemaApp.oscuro);
      expect(find.text('Tema aplicado: Tema oscuro'), findsOneWidget);
    });

    testWidgets('el tema alternativo se aplica a toda la app', (tester) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba());
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Ajustar tema');
      await pulsarTexto(tester, 'Tema alternativo');
      await pulsarTexto(tester, es.temaAplicar);

      await pulsarTexto(tester, 'Inicio');
      final fondo = Theme.of(tester.element(find.text('Menú principal')))
          .scaffoldBackgroundColor;
      expect(fondo, Paleta.alternativa.fondo);
    });
  });
}
