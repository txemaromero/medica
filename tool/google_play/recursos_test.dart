// Genera los recursos gráficos de la ficha de Google Play en
// docs/google_play/:
// - capturas de teléfono de 1080 × 1920 (el lado largo no puede pasar del
//   doble del corto, así que no valen las del README): en castellano en
//   capturas/, y en catalán, gallego y euskera en capturas_ca/, capturas_gl/
//   y capturas_eu/, con la app y los datos de ejemplo en ese idioma;
// - icono de 512 × 512;
// - gráfico destacado de 1024 × 500, también en cada idioma.
// Las capturas y el gráfico se guardan sin transparencia, que Google Play no
// admite en ellos.
//
// No forma parte de la batería de tests normal. Para regenerarlos:
//   flutter test tool/google_play/recursos_test.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:salud_mayores/app/rutas.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/l10n/textos.dart';

import '../capturas/datos_de_ejemplo.dart';
import '../fuentes_reales.dart';
import '../icono/marca.dart';

const String carpeta = 'docs/google_play';

/// La frase del gráfico destacado en cada idioma. El nombre de la app no se
/// traduce.
const Map<String, String> lemas = {
  'es': 'Tus medicinas y tus citas, fáciles de recordar.',
  'ca': 'Les teves medicines i les teves cites, fàcils de recordar.',
  'gl': 'As túas medicinas e as túas citas, fáciles de lembrar.',
  'eu': 'Zure botikak eta hitzorduak, gogoratzeko errazak.',
};

/// El castellano sin sufijo; los demás idiomas, con él.
String conIdioma(String nombre, String idioma) =>
    idioma == 'es' ? nombre : '${nombre}_$idioma';

/// Guarda como PNG lo que dibuja [buscador]. Sin [conAlfa], el PNG no lleva
/// canal de transparencia.
Future<void> guardar(
  WidgetTester tester,
  Finder buscador,
  String nombre, {
  bool conAlfa = false,
}) async {
  await tester.runAsync(() async {
    final imagen = await captureImage(buscador.evaluate().single);
    final pixeles = await imagen.toByteData(format: ui.ImageByteFormat.rawRgba);
    var png = img.Image.fromBytes(
      width: imagen.width,
      height: imagen.height,
      bytes: pixeles!.buffer,
      numChannels: 4,
    );
    if (!conAlfa) png = png.convert(numChannels: 3);
    File('$carpeta/$nombre.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(img.encodePng(png));
  });
}

void main() {
  final cajas = <String, Uint8List>{};
  setUpAll(() async {
    await cargarFuentesReales();
    for (final idioma in lemas.keys) {
      cajas[idioma] = await dibujarCajaDeEjemplo(idioma: idioma);
    }
  });

  /// Abre [ruta] en un teléfono de 360 × 640 dp a 3× (1080 × 1920 px) puesto
  /// en [idioma].
  Future<void> abrir(
    WidgetTester tester,
    String ruta,
    String idioma, {
    Ajustes ajustes = const Ajustes(),
    bool asistenteCompletado = true,
  }) async {
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = const Size(1080, 1920);
    tester.platformDispatcher.localesTestValue = [Locale(idioma, 'ES')];
    addTearDown(() {
      tester.view.reset();
      tester.platformDispatcher.clearLocalesTestValue();
      cambiarIdioma(const Locale('es'));
    });
    final caja = cajas[idioma]!;
    await tester.pumpWidget(
      entornoDeEjemplo(
        caja: caja,
        ajustes: ajustes,
        ahora: mediodia,
        asistenteCompletado: asistenteCompletado,
        idioma: idioma,
      ).app,
    );
    await tester.pumpAndSettle();
    if (ruta != Rutas.menuPrincipal) {
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed(ruta);
      await tester.pumpAndSettle();
    }
    await tester.runAsync(
      () => precacheImage(
        MemoryImage(caja),
        tester.element(find.byType(Navigator)),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final idioma in lemas.keys) {
    Future<void> capturar(WidgetTester tester, String nombre) => guardar(
      tester,
      find.byType(MaterialApp),
      '${conIdioma('capturas', idioma)}/$nombre',
    );

    group(idioma, () {
      testWidgets('01_menu_principal', (tester) async {
        await abrir(tester, Rutas.menuPrincipal, idioma);
        await capturar(tester, '01_menu_principal');
      });

      testWidgets('02_tomas_de_hoy', (tester) async {
        await abrir(tester, Rutas.tomasHoy, idioma);
        await tester.ensureVisible(find.textContaining('09:00').first);
        await tester.pumpAndSettle();
        await capturar(tester, '02_tomas_de_hoy');
      });

      testWidgets('03_medicamentos', (tester) async {
        await abrir(tester, Rutas.listaMedicamentos, idioma);
        await tester.ensureVisible(find.text('Omeprazol').first);
        await tester.pumpAndSettle();
        await capturar(tester, '03_medicamentos');
      });

      testWidgets('04_agenda', (tester) async {
        await abrir(tester, Rutas.agenda, idioma);
        await capturar(tester, '04_agenda');
      });

      testWidgets('05_emergencias', (tester) async {
        await abrir(tester, Rutas.emergencias, idioma);
        await capturar(tester, '05_emergencias');
      });

      testWidgets('06_texto_grande', (tester) async {
        await abrir(
          tester,
          Rutas.menuPrincipal,
          idioma,
          ajustes: const Ajustes(tamanoTexto: 30),
        );
        await capturar(tester, '06_texto_grande');
      });

      testWidgets('07_asistente', (tester) async {
        await abrir(
          tester,
          Rutas.menuPrincipal,
          idioma,
          asistenteCompletado: false,
        );
        await capturar(tester, '07_asistente');
      });

      testWidgets('08_compartir', (tester) async {
        await abrir(tester, Rutas.compartir, idioma);
        await capturar(tester, '08_compartir');
      });

      testWidgets('grafico_destacado', (tester) async {
        await dibujarGraficoDestacado(
          tester,
          lemas[idioma]!,
          conIdioma('grafico_destacado', idioma),
        );
      });
    });
  }

  testWidgets('icono_512', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size.square(512);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const RepaintBoundary(
        child: ColoredBox(
          color: Marca.fondo,
          child: Center(
            child: Icon(
              Marca.icono,
              size: 512 * Marca.proporcionSimbolo,
              color: Marca.simbolo,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
    await guardar(
      tester,
      find.byType(RepaintBoundary).first,
      'icono_512',
      conAlfa: true,
    );
  });
}

/// El gráfico destacado: el icono, el nombre de la app y [lema].
Future<void> dibujarGraficoDestacado(
  WidgetTester tester,
  String lema,
  String nombre,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1024, 500);
  addTearDown(tester.view.reset);
  const estilo = TextStyle(fontFamily: 'Montserrat', color: Marca.simbolo);
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(
        child: ColoredBox(
          color: Marca.fondo,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child: Row(
              children: [
                const Icon(Marca.icono, size: 300, color: Marca.simbolo),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salud y Medicación',
                        style: estilo.copyWith(
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        lema,
                        style: estilo.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await guardar(tester, find.byType(RepaintBoundary).first, nombre);
}
