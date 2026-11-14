import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/app/rutas.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/existencias.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/l10n/textos.dart';

import '../helpers/app_de_prueba.dart';

/// Recorre las 10 pantallas (y los formularios en modo "modificar") con datos
/// de ejemplo y comprueba las guías de accesibilidad de Flutter y que ningún
/// diseño se rompe con el texto en los extremos (10 y 35), en pantallas
/// estrechas y con la letra del sistema aumentada.
void main() {
  final rutas = [
    ...Rutas.mapa.keys,
    Rutas.modificarMedicamento,
    Rutas.modificarCita,
    Rutas.comprarMas,
    Rutas.renovarReceta,
  ];

  final medicamento = Medicamento(
    id: 1,
    nombre: 'Paracetamol',
    numTomas: 3,
    frecuenciaHoras: 8,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
    dosis: '1 comprimido de 1 gramo',
    instrucciones: 'Después de comer, con un vaso de agua.',
    fechaFin: DateTime(2026, 11, 3),
    foto: 'caja_paracetamol.jpg',
    // Pocas: se ven la cuenta, el aviso del menú y "He comprado más".
    existencias: Existencias(
      cantidad: 10,
      contadas: DateTime(2026, 10, 25, 8, 30),
    ),
    // Hay que renovarla: se ven el aviso y "Ya la he renovado".
    renovarReceta: DateTime(2026, 10, 30),
  );
  // Uno "cuando haga falta", con una toma anotada hoy.
  final calmante = Medicamento(
    id: 2,
    nombre: 'Ibuprofeno',
    numTomas: 1,
    frecuenciaHoras: 24,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
    dosis: '1 sobre de 600 miligramos',
    instrucciones: 'Si hay dolor.',
    aDemanda: true,
    // Con la toma de las 08:30, se ve desde cuándo se puede tomar otro.
    maximoAlDia: 3,
    horasEntreTomas: 6,
  );
  final cita = Cita(
    id: 1,
    titulo: 'Médico de cabecera',
    fecha: DateTime(2026, 10, 27),
    hora: const HoraDelDia(10, 30),
    lugar: 'Centro de salud de la plaza mayor',
    notas: 'Llevar la tarjeta sanitaria y los últimos análisis.',
  );

  EntornoDePrueba entornoConDatos(Ajustes ajustes) => EntornoDePrueba(
    ajustes: ajustes.copyWith(numeroEmergencia: '112'),
    medicamentos: [medicamento, calmante],
    citas: [cita],
    // Una toma marcada hoy y otra ayer, para ver todos los estados en
    // "Tomas de hoy" y en el historial.
    tomas: [
      for (final dia in [24, 25])
        RegistroToma(
          medicamentoId: medicamento.id,
          nombreMedicamento: medicamento.nombre,
          fecha: DateTime(2026, 10, dia),
          hora: const HoraDelDia(8, 0),
          estado: EstadoToma.tomada,
          momento: DateTime(2026, 10, dia, 8, 5),
        ),
      RegistroToma(
        medicamentoId: calmante.id,
        nombreMedicamento: calmante.nombre,
        fecha: DateTime(2026, 10, 25),
        hora: const HoraDelDia(8, 30),
        estado: EstadoToma.tomada,
        momento: DateTime(2026, 10, 25, 8, 30),
      ),
    ],
  );

  Future<void> abrir(WidgetTester tester, String ruta) async {
    final navegador = tester.state<NavigatorState>(find.byType(Navigator));
    navegador.popUntil((r) => r.isFirst);
    await tester.pumpAndSettle();
    final contexto = navegador.context;
    if (ruta == Rutas.modificarMedicamento) {
      unawaited(Rutas.abrirModificarMedicamento(contexto, medicamento));
    } else if (ruta == Rutas.modificarCita) {
      unawaited(Rutas.abrirModificarCita(contexto, cita));
    } else if (ruta == Rutas.comprarMas) {
      unawaited(Rutas.abrirComprarMas(contexto, medicamento));
    } else if (ruta == Rutas.renovarReceta) {
      unawaited(Rutas.abrirRenovarReceta(contexto, medicamento));
    } else if (ruta != Rutas.menuPrincipal) {
      unawaited(navegador.pushNamed(ruta));
    }
    await tester.pumpAndSettle();
  }

  /// Recorre la pantalla hasta abajo para dibujar todo.
  Future<void> bajarHastaElFinal(WidgetTester tester) async {
    final desplazables = find.byType(Scrollable);
    if (desplazables.evaluate().isNotEmpty) {
      await tester.drag(desplazables.first, const Offset(0, -5000));
      await tester.pumpAndSettle();
    }
  }

  group('guías de accesibilidad', () {
    for (final tema in TemaApp.values) {
      testWidgets('${tema.nombre}: áreas táctiles ≥ 48 dp, controles con '
          'etiqueta y contraste de texto en todas las pantallas', (
        tester,
      ) async {
        usarPantallaDeTelefono(tester);
        final semantica = tester.ensureSemantics();
        await arrancar(tester, entornoConDatos(Ajustes(tema: tema)));

        for (final ruta in rutas) {
          await abrir(tester, ruta);
          await expectLater(
            tester,
            meetsGuideline(androidTapTargetGuideline),
            reason: ruta,
          );
          await expectLater(
            tester,
            meetsGuideline(labeledTapTargetGuideline),
            reason: ruta,
          );
          await expectLater(
            tester,
            meetsGuideline(textContrastGuideline),
            reason: ruta,
          );
          comprobarNodosSemanticos(tester, motivo: ruta);
        }
        semantica.dispose();
      });
    }

    testWidgets('las acciones principales miden al menos 64 dp de alto', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, entornoConDatos(const Ajustes()));

      await abrir(tester, Rutas.agenda);
      expect(
        tester
            .getSize(
              find.ancestor(
                of: find.text('Crear cita'),
                matching: find.byType(InkWell),
              ),
            )
            .height,
        greaterThanOrEqualTo(64),
      );
      await abrir(tester, Rutas.emergencias);
      expect(
        tester
            .getSize(
              find.ancestor(
                of: find.text('Llamar'),
                matching: find.byType(InkWell),
              ),
            )
            .height,
        greaterThanOrEqualTo(64),
      );
      await abrir(tester, Rutas.listaMedicamentos);
      expect(
        tester
            .getSize(
              find.ancestor(
                of: find.text('Eliminar').first,
                matching: find.byType(InkWell),
              ),
            )
            .height,
        greaterThanOrEqualTo(64),
      );
    });
  });

  group('diseño adaptable sin desbordes', () {
    const pantallas = {
      'móvil pequeño': Size(320, 640),
      'móvil habitual': Size(411, 891),
      'horizontal': Size(760, 360),
    };
    for (final tamano in [10, 35]) {
      for (final MapEntry(key: nombre, value: pantalla) in pantallas.entries) {
        for (final escalaSistema in [1.0, 1.3]) {
          testWidgets('texto $tamano, $nombre, letra del sistema '
              '×$escalaSistema', (tester) async {
            usarPantallaDeTelefono(tester, tamano: pantalla);
            tester.platformDispatcher.textScaleFactorTestValue = escalaSistema;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );
            await arrancar(
              tester,
              entornoConDatos(Ajustes(tamanoTexto: tamano)),
            );

            for (final ruta in rutas) {
              await abrir(tester, ruta);
              await bajarHastaElFinal(tester);
              expect(tester.takeException(), isNull, reason: ruta);
            }
          });
        }
      }
    }
  });

  // Las traducciones tienen palabras más largas que el castellano (sobre todo
  // el euskera): se prueban los casos más justos, con texto 35 y la letra del
  // sistema al 130 %.
  group('en catalán, gallego y euskera', () {
    const pantallas = {
      'móvil pequeño': Size(320, 640),
      'horizontal': Size(760, 360),
    };
    for (final idioma in const ['ca', 'gl', 'eu']) {
      for (final MapEntry(key: nombre, value: pantalla) in pantallas.entries) {
        testWidgets('$idioma, $nombre: controles con etiqueta, un nodo por '
            'texto y sin desbordes', (tester) async {
          usarPantallaDeTelefono(tester, tamano: pantalla);
          tester.platformDispatcher.localesTestValue = [Locale(idioma, 'ES')];
          tester.platformDispatcher.textScaleFactorTestValue = 1.3;
          addTearDown(() {
            tester.platformDispatcher.clearLocalesTestValue();
            tester.platformDispatcher.clearTextScaleFactorTestValue();
            cambiarIdioma(const Locale('es'));
          });
          final semantica = tester.ensureSemantics();
          await arrancar(
            tester,
            entornoConDatos(const Ajustes(tamanoTexto: 35)),
          );
          expect(textosApp.localeName, idioma);

          for (final ruta in rutas) {
            await abrir(tester, ruta);
            await expectLater(
              tester,
              meetsGuideline(labeledTapTargetGuideline),
              reason: ruta,
            );
            comprobarNodosSemanticos(tester, motivo: ruta);
            await bajarHastaElFinal(tester);
            expect(tester.takeException(), isNull, reason: ruta);
          }
          semantica.dispose();
        });
      }
    }
  });
}
