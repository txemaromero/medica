import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';
import '../helpers/textos.dart';

/// El widget de la pantalla de inicio: lo que pulsa la persona llega a la
/// app como la respuesta a un aviso, y la app le manda lo que debe mostrar.
void main() {
  // A las 08:00 y a las 20:00.
  final metformina = Medicamento(
    id: 1,
    nombre: 'Metformina',
    numTomas: 2,
    frecuenciaHoras: 12,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
  );
  final hoy = DateTime(2026, 10, 25);

  testWidgets('"Ya la he tomado" en el widget con la app cerrada: la abre, '
      'anota la toma de ese día y lo explica', (tester) async {
    usarPantallaDeTelefono(tester);
    final widget = ServicioWidgetFalso()
      ..inicial = RespuestaAviso(
        accion: AccionesAviso.tomada,
        carga: CargaToma(
          medicamentoId: 1,
          hora: const HoraDelDia(8, 0),
          fecha: hoy,
        ).codificar(),
      );
    final entorno = EntornoDePrueba(medicamentos: [metformina], widget: widget);
    await arrancar(tester, entorno);
    await tester.pumpAndSettle();

    expect(find.text(es.tomasTitulo), findsWidgets);
    expect(
      find.text('Anotado: has tomado Metformina (08:00).'),
      findsOneWidget,
    );
    final registro = entorno.tomas.registros.single;
    expect(registro.fecha, hoy);
    expect(registro.estado, EstadoToma.tomada);
  });

  testWidgets('con la app abierta también, aunque la hora no haya llegado: '
      'se anota el día que dice el widget', (tester) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(medicamentos: [metformina]);
    await arrancar(tester, entorno);
    // Son las 9:00: la de las 20:00 es la de hoy, no la de ayer.
    entorno.widget.pulsar(
      RespuestaAviso(
        accion: AccionesAviso.tomada,
        carga: CargaToma(
          medicamentoId: 1,
          hora: const HoraDelDia(20, 0),
          fecha: hoy,
        ).codificar(),
      ),
    );
    await tester.pumpAndSettle();
    expect(entorno.tomas.registros.single.fecha, hoy);
    expect(entorno.tomas.registros.single.hora, const HoraDelDia(20, 0));
  });

  testWidgets('tocar el widget abre "Tomas de hoy" sin marcar nada', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(medicamentos: [metformina]);
    await arrancar(tester, entorno);
    entorno.widget.pulsar(
      RespuestaAviso(
        carga: CargaToma(
          medicamentoId: 1,
          hora: const HoraDelDia(20, 0),
          fecha: hoy,
        ).codificar(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(es.tomasTitulo), findsWidgets);
    expect(entorno.tomas.registros, isEmpty);
  });

  testWidgets('al marcar una toma, el widget se pone al día', (tester) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(medicamentos: [metformina]);
    await arrancar(tester, entorno);
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Tomas de hoy');
    await pulsarEtiqueta(tester, 'Ya he tomado Metformina de las 08:00');
    final tomas = (entorno.widget.datos!['tomas']! as List<Object?>)
        .cast<Map<String, Object?>>();
    expect(tomas.first['tomada'], isTrue);
    expect(tomas[1]['tomada'], isFalse);
  });

  group('en Ajustes', () {
    Future<EntornoDePrueba> abrir(
      WidgetTester tester, {
      bool sabe = true,
    }) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        widget: ServicioWidgetFalso()..sabeAnadir = sabe,
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, es.ajustesWidget);
      return entorno;
    }

    testWidgets('pide al teléfono ponerlo en la pantalla de inicio', (
      tester,
    ) async {
      final entorno = await abrir(tester);
      expect(entorno.widget.peticiones, 1);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('si el teléfono no sabe, explica cómo ponerlo a mano', (
      tester,
    ) async {
      await abrir(tester, sabe: false);
      expect(
        find.text(
          'Mantén pulsado un hueco de la pantalla de inicio del teléfono, toca '
          '"Widgets" y busca "Salud y Medicación".',
        ),
        findsOneWidget,
      );
    });
  });
}
