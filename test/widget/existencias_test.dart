import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/existencias.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/textos.dart';

void main() {
  // Dos tomas al día (08:00 y 20:00). Contadas 28 el martes a las 7:00, el
  // domingo a las 9:00 quedan 17.
  Medicamento metformina({double cantidad = 28, DateTime? contadas}) =>
      Medicamento(
        id: 1,
        nombre: 'Metformina',
        numTomas: 2,
        frecuenciaHoras: 12,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 1),
        existencias: Existencias(
          cantidad: cantidad,
          contadas: contadas ?? DateTime(2026, 10, 20, 7, 0),
        ),
      );

  Future<void> abrirLista(WidgetTester tester) async {
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Ver medicamentos registrados');
  }

  testWidgets('la lista dice cuántas quedan; "He comprado más" las suma', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(medicamentos: [metformina()]);
    await arrancar(tester, entorno);
    await abrirLista(tester);
    expect(find.text('Quedan 17 pastillas, para unos 9 días'), findsOneWidget);
    expect(find.textContaining('Quedan pocas'), findsNothing);

    await pulsarEtiqueta(tester, 'He comprado más Metformina');
    expect(find.text('Quedan 17 pastillas, para unos 9 días'), findsOneWidget);
    // Sin escribir nada no se puede añadir.
    await pulsarTexto(tester, es.comprarAnadir);
    expect(
      find.text('Escribe cuántas has comprado: un número entre 1 y 9982.'),
      findsOneWidget,
    );
    await escribir(tester, find.byType(TextField), '28');
    expect(find.text('Tendrás 45 pastillas.'), findsOneWidget);
    await pulsarTexto(tester, es.comprarAnadir);
    expect(
      find.text('Ahora tienes 45 pastillas de Metformina.'),
      findsOneWidget,
    );
    expect(
      entorno.medicamentos.guardados.single.existencias,
      Existencias(cantidad: 45, contadas: ahoraDePrueba),
    );

    await pulsarTexto(tester, 'Aceptar');
    expect(find.text(es.listaMedicamentosTitulo), findsOneWidget);
    expect(find.textContaining('Quedan 45 pastillas'), findsOneWidget);
  });

  testWidgets('receta: el menú y la lista avisan; "Ya la he renovado" pone '
      'la fecha nueva o la quita', (tester) async {
    usarPantallaDeTelefono(tester);
    final omeprazol = Medicamento(
      id: 2,
      nombre: 'Omeprazol',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(21, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      renovarReceta: DateTime(2026, 10, 28),
    );
    final entorno = EntornoDePrueba(
      medicamentos: [omeprazol],
      ajustes: const Ajustes(notificacionesActivadas: true),
    );
    await arrancar(tester, entorno);
    expect(
      find.text('Hay que renovar la receta de Omeprazol.'),
      findsOneWidget,
    );
    // Al arrancar, la sincronización la lanza main.dart.
    await ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(sincronizadorAvisosProvider)
        .sincronizar();
    expect(
      entorno.notificaciones.deTipo(TipoAviso.receta).single.momento,
      UnaVez(DateTime(2026, 10, 25, 10, 0)),
    );

    await abrirLista(tester);
    expect(
      find.text(
        'La receta se acaba dentro de 3 días: pide cita con tu médico para '
        'renovarla',
      ),
      findsOneWidget,
    );
    await pulsarEtiqueta(tester, 'Ya he renovado la receta de Omeprazol');
    expect(find.text(es.recetaPregunta), findsOneWidget);
    // Se propone dentro de un mes.
    expect(
      find.text('Día elegido: Miércoles, 25 de noviembre de 2026'),
      findsOneWidget,
    );
    await pulsarTexto(tester, es.recetaGuardar);
    expect(
      find.text(
        'Receta de Omeprazol: hasta el miércoles, 25 de noviembre de '
        '2026.',
      ),
      findsOneWidget,
    );
    await pulsarTexto(tester, 'Aceptar');
    expect(
      entorno.medicamentos.guardados.single.renovarReceta,
      DateTime(2026, 11, 25),
    );
    expect(
      find.text('Receta: hasta el miércoles, 25 de noviembre de 2026'),
      findsOneWidget,
    );
    expect(find.text(es.medicamentoRecetaRenovada), findsNothing);
    expect(
      entorno.notificaciones.deTipo(TipoAviso.receta).single.momento,
      UnaVez(DateTime(2026, 11, 18, 10, 0)),
    );

    // Con la receta ya acabada, se puede quitar la fecha.
    entorno.ahora = DateTime(2026, 11, 26, 9, 0);
    await pulsarTexto(tester, 'Atrás');
    await abrirLista(tester);
    await pulsarEtiqueta(tester, 'Ya he renovado la receta de Omeprazol');
    await pulsarTexto(tester, es.recetaQuitar);
    expect(
      find.text('Ya no te avisaremos de la receta de Omeprazol.'),
      findsOneWidget,
    );
    await pulsarTexto(tester, 'Aceptar');
    expect(entorno.medicamentos.guardados.single.renovarReceta, isNull);
    expect(entorno.notificaciones.deTipo(TipoAviso.receta), isEmpty);
  });

  testWidgets('con media pastilla, "He comprado más" la conserva', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(medicamentos: [metformina(cantidad: 28.5)]);
    await arrancar(tester, entorno);
    await abrirLista(tester);
    expect(
      find.text('Quedan 17 pastillas y media, para unos 9 días'),
      findsOneWidget,
    );
    await pulsarEtiqueta(tester, 'He comprado más Metformina');
    await escribir(tester, find.byType(TextField), '28');
    expect(find.text('Tendrás 45 pastillas y media.'), findsOneWidget);
    await pulsarTexto(tester, es.comprarAnadir);
    expect(
      find.text('Ahora tienes 45 pastillas y media de Metformina.'),
      findsOneWidget,
    );
    expect(entorno.medicamentos.guardados.single.existencias!.cantidad, 45.5);
  });

  testWidgets('marcar una toma antes de su hora la descuenta enseguida', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba(medicamentos: [metformina()]));
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Tomas de hoy');
    await pulsarEtiqueta(tester, 'Ya he tomado Metformina de las 20:00');
    await pulsarTexto(tester, 'Atrás');
    await pulsarTexto(tester, 'Ver medicamentos registrados');
    expect(find.textContaining('Quedan 16 pastillas'), findsOneWidget);
  });

  testWidgets('si quedan pocas, lo dicen el menú, la lista y un aviso a las '
      '10:00', (tester) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(
      ajustes: const Ajustes(notificacionesActivadas: true),
      medicamentos: [metformina(cantidad: 13, contadas: ahoraDePrueba)],
      // La de las 08:00, marcada: si no, la app se abriría en "Tomas de hoy".
      tomas: [
        RegistroToma(
          medicamentoId: 1,
          nombreMedicamento: 'Metformina',
          fecha: DateTime(2026, 10, 25),
          hora: const HoraDelDia(8, 0),
          estado: EstadoToma.tomada,
          momento: DateTime(2026, 10, 25, 8, 5),
        ),
      ],
    );
    await arrancar(tester, entorno);
    expect(
      find.text('Te quedan pocas pastillas de Metformina.'),
      findsOneWidget,
    );
    // Al arrancar, la sincronización la lanza main.dart.
    await ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(sincronizadorAvisosProvider)
        .sincronizar();
    expect(
      entorno.notificaciones
          .deTipo(TipoAviso.existencias)
          .map((a) => a.momento),
      [UnaVez(DateTime(2026, 10, 25, 10, 0))],
    );

    await pulsarTexto(tester, es.medicamentosMenuVer);
    expect(find.text(es.listaMedicamentosTitulo), findsOneWidget);
    expect(
      find.text('Quedan pocas. Cuando compres más, pulsa "He comprado más".'),
      findsOneWidget,
    );
  });

  testWidgets('tocar el aviso de que quedan pocas abre la lista', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(medicamentos: [metformina()]);
    await arrancar(tester, entorno);
    entorno.notificaciones.responder(
      RespuestaAviso(carga: const CargaExistencias(1).codificar()),
    );
    await tester.pumpAndSettle();
    expect(find.text(es.listaMedicamentosTitulo), findsOneWidget);
  });

  group('en el formulario', () {
    testWidgets('llevar la cuenta: cuántas hay y cuántas en cada toma, con '
        'el resumen', (tester) async {
      final semantica = tester.ensureSemantics();
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Registro de medicamentos');
      await pulsarTexto(tester, 'Registrar nuevo medicamento');
      await escribir(tester, find.byType(TextField).first, 'Omeprazol');
      await pulsarTexto(tester, es.formularioMedicamentoConCuenta);
      // Sin el número no se puede guardar.
      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      expect(
        find.text(
          'Escribe cuántas pastillas tienes: un número entre 0 y 9999. Si '
          'hay media, con coma: 14,5.',
        ),
        findsOneWidget,
      );
      expect(entorno.medicamentos.guardados, isEmpty);

      await escribir(tester, find.byType(TextField).last, '30');
      // Una al día, a las 08:00: la de hoy ya ha pasado.
      expect(
        find.text('Quedan 30 pastillas, para unos 30 días'),
        findsOneWidget,
      );
      // De media en media.
      await pulsarEtiqueta(tester, 'Media pastilla más en cada toma');
      expect(find.text('1 y media'), findsOneWidget);
      expect(
        find.text('Quedan 30 pastillas, para unos 20 días'),
        findsOneWidget,
      );
      await pulsarEtiqueta(tester, 'Media pastilla más en cada toma');
      expect(
        find.text('Quedan 30 pastillas, para unos 15 días'),
        findsOneWidget,
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantica.dispose();

      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      expect(
        entorno.medicamentos.guardados.single.existencias,
        Existencias(cantidad: 30, contadas: ahoraDePrueba, porToma: 2),
      );
    });

    testWidgets('al modificarlo, muestra las que quedan; si no se cambian, '
        'la cuenta sigue igual', (tester) async {
      usarPantallaDeTelefono(tester);
      final original = metformina();
      final entorno = EntornoDePrueba(medicamentos: [original]);
      await arrancar(tester, entorno);
      await abrirLista(tester);
      await pulsarTexto(tester, 'Modificar');
      expect(find.widgetWithText(TextField, '17'), findsOneWidget);
      await pulsarTexto(tester, es.formularioGuardarCambios);
      expect(entorno.medicamentos.guardados.single, original);
      await pulsarTexto(tester, 'Aceptar');

      // Al cambiar el número, la cuenta empieza de nuevo.
      await pulsarTexto(tester, 'Modificar');
      await escribir(tester, find.widgetWithText(TextField, '17'), '40');
      await pulsarTexto(tester, es.formularioGuardarCambios);
      expect(
        entorno.medicamentos.guardados.single.existencias,
        Existencias(cantidad: 40, contadas: ahoraDePrueba),
      );
      await pulsarTexto(tester, 'Aceptar');

      // Y se puede dejar de llevar.
      await pulsarTexto(tester, 'Modificar');
      await pulsarTexto(tester, es.formularioMedicamentoSinCuenta);
      await pulsarTexto(tester, es.formularioGuardarCambios);
      expect(entorno.medicamentos.guardados.single.existencias, isNull);
    });

    testWidgets('si cambia la pauta, la cuenta empieza desde ahora con las '
        'que quedan', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(medicamentos: [metformina()]);
      await arrancar(tester, entorno);
      await abrirLista(tester);
      await pulsarTexto(tester, 'Modificar');
      await pulsarEtiqueta(tester, es.formularioMedicamentoTomaMas);
      await pulsarTexto(tester, es.formularioGuardarCambios);
      expect(
        entorno.medicamentos.guardados.single.existencias,
        Existencias(cantidad: 17, contadas: ahoraDePrueba),
      );
    });
  });
}
