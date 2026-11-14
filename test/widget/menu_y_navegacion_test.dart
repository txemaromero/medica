import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/widgets/barra_superior.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/core/widgets/botones.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/l10n/textos.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/textos.dart';

void main() {
  const opciones = [
    'Registro de medicamentos',
    'Agenda',
    'Botón de emergencias',
    'Ajustes',
  ];

  testWidgets('el menú principal muestra su título y las cuatro opciones, '
      'sin barra superior', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());

    expect(find.text('Menú principal'), findsOneWidget);
    for (final opcion in opciones) {
      expect(find.text(opcion), findsOneWidget);
    }
    expect(find.byType(TarjetaMenu), findsNWidgets(4));
    expect(find.byType(BarraSuperior), findsNothing);
  });

  testWidgets('con el teléfono en un idioma sin traducción, la app sale en '
      'castellano', (tester) async {
    usarPantallaDeTelefono(tester);
    tester.platformDispatcher.localesTestValue = const [Locale('fr', 'FR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await arrancar(tester, EntornoDePrueba());

    expect(find.text('Menú principal'), findsOneWidget);
    expect(textosApp.localeName, 'es');
  });

  testWidgets('resume la próxima toma y la próxima cita', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(
      tester,
      EntornoDePrueba(
        medicamentos: [
          Medicamento(
            id: 1,
            nombre: 'Paracetamol',
            numTomas: 3,
            frecuenciaHoras: 8,
            horaInicio: const HoraDelDia(8, 0),
            fechaCreacion: DateTime(2026, 10, 1),
          ),
        ],
        citas: [
          Cita(
            id: 1,
            titulo: 'Dentista',
            fecha: DateTime(2026, 10, 27),
            hora: const HoraDelDia(10, 30),
          ),
        ],
      ),
    );

    expect(
      find.text('Próxima toma: Paracetamol, hoy a las 16:00.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Próxima cita: Dentista, el martes, 27 de octubre, a las 10:30.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('sin medicamentos ni citas no muestra resumen', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());
    expect(find.textContaining('Próxima'), findsNothing);
  });

  testWidgets('en una pantalla ancha las tarjetas forman una cuadrícula 2×2', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester, tamano: const Size(800, 1100));
    await arrancar(tester, EntornoDePrueba());

    final centros = [
      for (final opcion in opciones) tester.getCenter(find.text(opcion)),
    ];
    // Dos filas de dos: misma altura en cada fila y columnas distintas.
    expect(centros[0].dy, closeTo(centros[1].dy, 1));
    expect(centros[2].dy, closeTo(centros[3].dy, 1));
    expect(centros[2].dy, greaterThan(centros[0].dy));
    expect(centros[1].dx, greaterThan(centros[0].dx));
  });

  testWidgets('con el texto al máximo en un móvil las tarjetas pasan a una '
      'columna sin desbordarse', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(
      tester,
      EntornoDePrueba(ajustes: const Ajustes(tamanoTexto: 35)),
    );

    final centros = [
      for (final opcion in opciones) tester.getCenter(find.text(opcion)),
    ];
    for (var i = 1; i < centros.length; i++) {
      expect(centros[i].dy, greaterThan(centros[i - 1].dy));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('cada sección tiene barra superior con casa, título y atrás', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());

    const titulos = {
      'Registro de medicamentos': 'Registro de medicamentos',
      'Agenda': 'Agenda',
      'Botón de emergencias': 'Emergencias',
      'Ajustes': 'Ajustes',
    };
    for (final MapEntry(key: opcion, value: titulo) in titulos.entries) {
      await pulsarTexto(tester, opcion);
      expect(find.byType(BarraSuperior), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BarraSuperior),
          matching: find.text(titulo),
        ),
        findsOneWidget,
      );
      expect(find.text(es.barraInicio), findsOneWidget);
      expect(find.text(es.barraAtras), findsOneWidget);

      await pulsarTexto(tester, es.barraAtras);
      expect(find.text('Menú principal'), findsOneWidget);
    }
  });

  testWidgets('el botón casa vuelve al menú desde el segundo nivel', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());

    await pulsarTexto(tester, 'Ajustes');
    await pulsarTexto(tester, 'Ajustar tema');
    expect(find.text('Tema'), findsOneWidget);

    await pulsarTexto(tester, es.barraInicio);
    expect(find.text('Menú principal'), findsOneWidget);
    expect(find.byType(BarraSuperior), findsNothing);
  });

  testWidgets('el botón atrás de Android también vuelve atrás', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());

    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Ver medicamentos registrados');
    expect(find.text('Medicamentos registrados'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Ver medicamentos registrados'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Menú principal'), findsOneWidget);
  });
}
