import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/l10n/textos.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';

import '../helpers/app_de_prueba.dart';

void main() {
  /// Pone el teléfono en [idioma] durante el test (y deja los textos de
  /// fuera de los widgets en castellano al terminar).
  void telefonoEn(WidgetTester tester, Locale idioma) {
    tester.platformDispatcher.localesTestValue = [idioma];
    addTearDown(() {
      tester.platformDispatcher.clearLocalesTestValue();
      cambiarIdioma(const Locale('es'));
    });
  }

  SincronizadorAvisos sincronizador(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
          .read(sincronizadorAvisosProvider);

  for (final idioma in const ['ca', 'gl', 'eu']) {
    testWidgets('con el teléfono en "$idioma", la app sale en ese idioma', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      telefonoEn(tester, Locale(idioma, 'ES'));
      await arrancar(tester, EntornoDePrueba());

      expect(
        find.text(lookupTextosApp(Locale(idioma)).menuTitulo),
        findsOneWidget,
      );
      expect(textosApp.localeName, idioma);
    });
  }

  testWidgets('si cambia el idioma del teléfono con la app abierta, los '
      'avisos y el widget pasan a ese idioma', (tester) async {
    usarPantallaDeTelefono(tester);
    telefonoEn(tester, const Locale('es', 'ES'));
    final entorno = EntornoDePrueba(
      ajustes: const Ajustes(notificacionesActivadas: true),
      medicamentos: [
        Medicamento(
          id: 1,
          nombre: 'Omeprazol',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: const HoraDelDia(20, 0),
          fechaCreacion: DateTime(2026, 10, 1),
        ),
      ],
    );
    await arrancar(tester, entorno);
    // Al arrancar, la sincronización la lanza main.dart.
    await sincronizador(tester).sincronizar();
    String tituloToma() =>
        entorno.notificaciones.deTipo(TipoAviso.toma).first.titulo;
    expect(tituloToma(), 'Hora de tu medicina');

    tester.platformDispatcher.localesTestValue = const [Locale('ca', 'ES')];
    await tester.pumpAndSettle();
    await sincronizador(tester).esperar();

    final ca = lookupTextosApp(const Locale('ca'));
    expect(find.text(ca.menuTitulo), findsOneWidget);
    expect(tituloToma(), ca.avisoTomaTitulo);
    expect(entorno.widget.datos?['titulo'], ca.widgetTitulo);
  });
}
