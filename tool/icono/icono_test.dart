// Genera el icono de la app (assets/icono) y el de la barra de
// notificaciones de Android (res/drawable-*/ic_notificacion.png).
//
// No forma parte de la batería de tests normal. Para regenerarlos:
//   flutter test tool/icono/icono_test.dart --update-goldens
//   dart run flutter_launcher_icons
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fuentes_reales.dart';
import 'marca.dart';

/// Densidades de Android y tamaño en píxeles del icono de notificación
/// (24 dp).
const Map<String, double> densidades = {
  'mdpi': 24,
  'hdpi': 36,
  'xhdpi': 48,
  'xxhdpi': 72,
  'xxxhdpi': 96,
};

void main() {
  setUpAll(cargarFuentesReales);

  Future<void> dibujar(
    WidgetTester tester,
    String destino, {
    required double lado,
    required double tamanoSimbolo,
    Color fondo = Colors.transparent,
    Color color = Marca.simbolo,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size.square(lado);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      RepaintBoundary(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ColoredBox(
            color: fondo,
            child: Center(
              child: Icon(Marca.icono, size: tamanoSimbolo, color: color),
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(RepaintBoundary).first,
      matchesGoldenFile(destino),
    );
  }

  testWidgets('icono completo (Android antiguo e iOS)', (tester) async {
    await dibujar(
      tester,
      '../../assets/icono/icono.png',
      lado: 1024,
      tamanoSimbolo: 1024 * Marca.proporcionSimbolo,
      fondo: Marca.fondo,
    );
  });

  // En el icono adaptable de Android el launcher recorta la imagen con su
  // forma (círculo, gota…). flutter_launcher_icons ya deja un margen del
  // 16 %, así que basta con que la diagonal del símbolo (unas 0,95 veces su
  // tamaño) quepa en el 92 % de la imagen.
  testWidgets('primer plano del icono adaptable', (tester) async {
    await dibujar(
      tester,
      '../../assets/icono/primer_plano.png',
      lado: 1024,
      tamanoSimbolo: 1024 * Marca.proporcionSimbolo,
    );
  });

  // Android solo usa la silueta (el canal alfa) de los iconos de la barra de
  // notificaciones: un icono a todo color se vería como un cuadrado blanco.
  for (final MapEntry(key: densidad, value: lado) in densidades.entries) {
    testWidgets('icono de notificación $densidad', (tester) async {
      await dibujar(
        tester,
        '../../android/app/src/main/res/drawable-$densidad/ic_notificacion.png',
        lado: lado,
        tamanoSimbolo: lado,
        color: Colors.white,
      );
    });
  }
}
