import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/core/widgets/botones.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';

import 'package:salud_mayores/notificaciones/planificador_avisos.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/textos.dart';

void main() {
  Future<void> abrirFormulario(WidgetTester tester) async {
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Registrar nuevo medicamento');
    expect(find.text(es.formularioMedicamentoTituloNuevo), findsOneWidget);
  }

  testWidgets('alta de medicamento: valida el nombre, confirma y lo muestra '
      'en la lista', (tester) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba();
    await arrancar(tester, entorno);
    await abrirFormulario(tester);

    // Sin nombre: mensaje de error claro junto al campo y nada guardado.
    await pulsarTexto(tester, es.formularioMedicamentoCrear);
    expect(
      find.text(
        'Escribe el nombre del medicamento. '
        'Por ejemplo: Paracetamol.',
      ),
      findsOneWidget,
    );
    expect(entorno.medicamentos.guardados, isEmpty);

    await escribir(tester, find.byType(TextField).first, 'Ibuprofeno');
    await pulsarEtiqueta(tester, 'Una toma más');
    await pulsarEtiqueta(tester, 'Una toma más');
    // Con 3 tomas se propone repartirlas cada 8 horas.
    expect(find.text('Cada 8 h'), findsOneWidget);
    expect(
      find.text('Te avisaremos cada día a las 08:00, 16:00 y 00:00.'),
      findsOneWidget,
    );

    await pulsarTexto(tester, es.formularioMedicamentoCrear);

    expect(find.text(es.formularioMedicamentoGuardado), findsOneWidget);
    expect(
      find.textContaining('Los avisos están desactivados'),
      findsOneWidget,
    );
    final guardado = entorno.medicamentos.guardados.single;
    expect(guardado.nombre, 'Ibuprofeno');
    expect(guardado.numTomas, 3);
    expect(guardado.frecuenciaHoras, 8);
    expect(guardado.horaInicio, const HoraDelDia(8, 0));

    await pulsarTexto(tester, 'Aceptar');
    expect(find.text(es.listaMedicamentosTitulo), findsOneWidget);
    expect(find.text('Ibuprofeno'), findsOneWidget);
    expect(find.text('Horas: 08:00, 16:00 y 00:00'), findsOneWidget);

    // "Atrás" desde la lista vuelve al submenú, no al formulario.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Ver medicamentos registrados'), findsOneWidget);
  });

  testWidgets('con notificaciones activas, guardar programa los avisos', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(
      ajustes: const Ajustes(notificacionesActivadas: true),
    );
    await arrancar(tester, entorno);
    await abrirFormulario(tester);

    await escribir(tester, find.byType(TextField).first, 'Enalapril');
    await pulsarEtiqueta(tester, 'Sumar una hora');
    await pulsarTexto(tester, es.formularioMedicamentoCrear);

    expect(find.textContaining('Los avisos están desactivados'), findsNothing);
    final tomas = entorno.notificaciones.deTipo(TipoAviso.toma);
    expect(tomas, hasLength(1));
    expect(tomas.single.cuerpo, 'Toma Enalapril (09:00).');
  });

  group('eliminar medicamento', () {
    final aspirina = Medicamento(
      id: 4,
      nombre: 'Aspirina',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(14, 0),
      fechaCreacion: DateTime(2026, 10, 1),
    );

    Future<EntornoDePrueba> abrirLista(WidgetTester tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(medicamentos: [aspirina]);
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Registro de medicamentos');
      await pulsarTexto(tester, 'Ver medicamentos registrados');
      expect(find.text('Aspirina'), findsOneWidget);
      return entorno;
    }

    testWidgets('pide confirmación y "No, volver" no borra nada', (
      tester,
    ) async {
      final entorno = await abrirLista(tester);

      await pulsarTexto(tester, 'Eliminar');
      expect(find.text(es.listaMedicamentosPreguntaEliminar), findsOneWidget);
      expect(find.text('Sí, eliminar'), findsOneWidget);

      await pulsarTexto(tester, 'No, volver');
      expect(find.text(es.listaMedicamentosPreguntaEliminar), findsNothing);
      expect(find.text('Aspirina'), findsOneWidget);
      expect(entorno.medicamentos.guardados, [aspirina]);
    });

    testWidgets('"Sí, eliminar" borra, confirma y permite deshacer', (
      tester,
    ) async {
      final entorno = await abrirLista(tester);

      await pulsarTexto(tester, 'Eliminar');
      await pulsarTexto(tester, 'Sí, eliminar');

      expect(entorno.medicamentos.guardados, isEmpty);
      expect(find.text('Medicamento eliminado: Aspirina'), findsOneWidget);
      expect(botonDeshacer(es.botonDeshacerPistaEliminar), findsOneWidget);
      expect(find.text(es.listaMedicamentosVacio), findsOneWidget);

      await pulsarTexto(tester, 'Deshacer');

      expect(entorno.medicamentos.guardados, [aspirina]);
      expect(find.text('Medicamento recuperado: Aspirina'), findsOneWidget);
      expect(find.text('Aspirina'), findsOneWidget);
    });
  });

  testWidgets('la lista vacía muestra un mensaje amable y acceso a registrar', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    await arrancar(tester, EntornoDePrueba());
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Ver medicamentos registrados');

    expect(find.text(es.listaMedicamentosVacio), findsOneWidget);
    await pulsarTexto(tester, 'Registrar nuevo medicamento');
    expect(find.text(es.formularioMedicamentoTituloNuevo), findsOneWidget);
  });

  Future<void> abrirLista(WidgetTester tester) async {
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Ver medicamentos registrados');
  }

  testWidgets('modificar: abre el formulario con los datos, guarda los '
      'cambios y reprograma los avisos', (tester) async {
    usarPantallaDeTelefono(tester);
    final omeprazol = Medicamento(
      id: 7,
      nombre: 'Omeprazol',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(9, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      dosis: '1 cápsula',
    );
    final entorno = EntornoDePrueba(
      medicamentos: [omeprazol],
      ajustes: const Ajustes(notificacionesActivadas: true),
      // Antes de la toma de las 09:00: así la app se abre en el menú.
      ahora: DateTime(2026, 10, 25, 8),
    );
    await arrancar(tester, entorno);
    await abrirLista(tester);
    expect(find.text('Dosis: 1 cápsula'), findsOneWidget);

    await pulsarTexto(tester, 'Modificar');
    expect(find.text(es.formularioMedicamentoTituloModificar), findsOneWidget);
    // Los campos vienen rellenos con lo guardado.
    expect(find.text('Omeprazol'), findsOneWidget);
    expect(find.text('1 cápsula'), findsOneWidget);

    await pulsarEtiqueta(tester, 'Una toma más');
    await pulsarTexto(tester, es.formularioGuardarCambios);
    expect(find.text(es.formularioCambiosGuardados), findsOneWidget);
    final guardado = entorno.medicamentos.guardados.single;
    expect(guardado.id, 7);
    expect(guardado.fechaCreacion, omeprazol.fechaCreacion);
    expect(guardado.numTomas, 2);
    expect(guardado.frecuenciaHoras, 12);
    expect(guardado.dosis, '1 cápsula');
    expect(entorno.notificaciones.idsDeTipo(TipoAviso.toma), {700, 701});

    // Al aceptar se vuelve a la lista, ya actualizada.
    await pulsarTexto(tester, 'Aceptar');
    expect(find.text(es.listaMedicamentosTitulo), findsOneWidget);
    expect(find.text('Horas: 09:00 y 21:00'), findsOneWidget);
  });

  testWidgets('dosis, instrucciones y duración se guardan, programan sus '
      'avisos y se muestran en la lista', (tester) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(
      ajustes: const Ajustes(notificacionesActivadas: true),
    );
    await arrancar(tester, entorno);
    await abrirFormulario(tester);

    final campos = find.byType(TextField);
    await escribir(tester, campos.at(0), 'Amoxicilina');
    await escribir(tester, campos.at(1), '1 cápsula');
    await escribir(tester, campos.at(2), 'con comida');
    await pulsarTexto(tester, 'Hasta un día concreto');
    // Se propone una semana: el último día es el domingo 1 de noviembre.
    expect(
      find.text('Día elegido: Domingo, 1 de noviembre de 2026'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Te avisaremos a las 08:00 hasta el domingo, 1 de noviembre de '
        '2026, incluido.',
      ),
      findsOneWidget,
    );

    await pulsarTexto(tester, es.formularioMedicamentoCrear);
    final guardado = entorno.medicamentos.guardados.single;
    expect(guardado.dosis, '1 cápsula');
    expect(guardado.instrucciones, 'con comida');
    expect(guardado.fechaFin, DateTime(2026, 11, 1));
    // Hoy a las 08:00 ya ha pasado (son las 9:00): quedan del 26 al 1.
    final avisos = entorno.notificaciones.deTipo(TipoAviso.toma);
    expect(avisos, hasLength(7));
    expect(
      avisos.first.cuerpo,
      'Toma Amoxicilina: 1 cápsula (08:00). Con comida.',
    );

    await pulsarTexto(tester, 'Aceptar');
    expect(find.text('Dosis: 1 cápsula'), findsOneWidget);
    expect(find.text('con comida'), findsOneWidget);
    expect(
      find.text('Hasta el domingo, 1 de noviembre de 2026, incluido'),
      findsOneWidget,
    );
  });

  testWidgets('una tarjeta que encoge con la lista desplazada no rompe el '
      'árbol de TalkBack', (tester) async {
    // Con un ListView en PantallaBase, Flutter fallaba en
    // _buildSemanticsSubtree ("Null check operator") al volver a la lista.
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba(
      medicamentos: [
        Medicamento(
          id: 2,
          nombre: 'Omeprazol de 20 miligramos en cápsulas duras',
          numTomas: 3,
          frecuenciaHoras: 8,
          horaInicio: const HoraDelDia(7, 0),
          fechaCreacion: DateTime(2026, 10, 1),
          dosis: '1 cápsula grande con un vaso de agua',
          instrucciones:
              'Con el desayuno, con un vaso de agua lleno y sin tumbarse '
              'después durante media hora por lo menos, mejor sentado',
        ),
      ],
    );
    await arrancar(tester, entorno);
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Ver medicamentos registrados');
    await pulsarTexto(tester, 'Modificar');
    await escribir(tester, find.byType(TextField).at(2), 'Con agua');
    await pulsarTexto(tester, es.formularioGuardarCambios);
    await pulsarTexto(tester, 'Aceptar');
    expect(find.text(es.listaMedicamentosTitulo), findsOneWidget);
    expect(find.text('Con agua'), findsOneWidget);
  });

  testWidgets('un tratamiento terminado lo indica en la lista', (tester) async {
    usarPantallaDeTelefono(tester);
    await arrancar(
      tester,
      EntornoDePrueba(
        medicamentos: [
          Medicamento(
            id: 2,
            nombre: 'Ibuprofeno',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: const HoraDelDia(9, 0),
            fechaCreacion: DateTime(2026, 10, 1),
            fechaFin: DateTime(2026, 10, 20),
          ),
        ],
      ),
    );
    await abrirLista(tester);
    expect(
      find.text('Tratamiento terminado el martes, 20 de octubre de 2026'),
      findsOneWidget,
    );
  });

  group('horas concretas y días de toma', () {
    const avisos = Ajustes(notificacionesActivadas: true);

    Future<EntornoDePrueba> empezar(WidgetTester tester, String nombre) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(ajustes: avisos);
      await arrancar(tester, entorno);
      await abrirFormulario(tester);
      await escribir(tester, find.byType(TextField).first, nombre);
      return entorno;
    }

    testWidgets('dosis distinta según la hora: una por la mañana y media por '
        'la noche, también en la cuenta', (tester) async {
      final entorno = await empezar(tester, 'Enalapril');
      await escribir(tester, find.byType(TextField).at(1), '1 pastilla');
      await pulsarEtiqueta(tester, 'Una toma más');
      await pulsarTexto(tester, es.formularioMedicamentoConcretas);
      await pulsarTexto(tester, es.formularioMedicamentoDosisDistinta);
      // La dosis de arriba se cambia por una explicación, y cada toma empieza
      // con ella.
      expect(
        find.text(
          'La dosis cambia según la hora: la de cada toma está más abajo, '
          'en "Dosis en cada toma".',
        ),
        findsOneWidget,
      );
      expect(find.text('Dosis de las 09:00'), findsOneWidget);
      expect(find.text('Dosis de las 21:00'), findsOneWidget);
      expect(find.widgetWithText(TextField, '1 pastilla'), findsNWidgets(2));
      // Nombre, instrucciones y las dos dosis.
      await escribir(tester, find.byType(TextField).at(3), 'media pastilla');

      await pulsarTexto(tester, es.formularioMedicamentoConCuenta);
      await escribir(tester, find.byType(TextField).last, '30');
      expect(find.text('Pastillas en la toma de las 21:00'), findsOneWidget);
      await pulsarEtiqueta(tester, 'Media pastilla menos a las 21:00');
      expect(find.text('media'), findsOneWidget);
      expect(
        find.text('Quedan 30 pastillas, para unos 20 días'),
        findsOneWidget,
      );

      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      final guardado = entorno.medicamentos.guardados.single;
      expect(guardado.dosis, isNull);
      expect(guardado.dosisPorToma, ['1 pastilla', 'media pastilla']);
      expect(guardado.existencias!.porTomas, [1, 0.5]);
      expect(
        entorno.notificaciones.deTipo(TipoAviso.toma).map((a) => a.cuerpo),
        [
          'Toma Enalapril: 1 pastilla (09:00).',
          'Toma Enalapril: media pastilla (21:00).',
        ],
      );

      await pulsarTexto(tester, 'Aceptar');
      expect(
        find.text('Dosis: 1 pastilla a las 09:00 y media pastilla a las 21:00'),
        findsOneWidget,
      );
      await pulsarTexto(tester, 'Atrás');
      await pulsarTexto(tester, 'Tomas de hoy');
      expect(find.text('Dosis: 1 pastilla'), findsOneWidget);
      expect(find.text('Dosis: media pastilla'), findsOneWidget);
    });

    testWidgets('a horas concretas: se proponen las de las comidas, se '
        'cambian y se guardan', (tester) async {
      final entorno = await empezar(tester, 'Metformina');
      await pulsarEtiqueta(tester, 'Una toma más');
      await pulsarEtiqueta(tester, 'Una toma más');
      await pulsarTexto(tester, es.formularioMedicamentoConcretas);
      expect(
        find.text('Te avisaremos cada día a las 08:00, 14:00 y 21:00.'),
        findsOneWidget,
      );
      expect(find.text('Toma 3'), findsOneWidget);

      // La primera toma, una hora antes.
      await pulsarEtiqueta(tester, 'Restar una hora', indice: 0);
      expect(
        find.text('Te avisaremos cada día a las 07:00, 14:00 y 21:00.'),
        findsOneWidget,
      );

      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      final guardado = entorno.medicamentos.guardados.single;
      expect(guardado.horasLibres, const [
        HoraDelDia(7, 0),
        HoraDelDia(14, 0),
        HoraDelDia(21, 0),
      ]);
      expect(
        entorno.notificaciones.deTipo(TipoAviso.toma).map((a) => a.momento),
        const [
          CadaDia(HoraDelDia(7, 0)),
          CadaDia(HoraDelDia(14, 0)),
          CadaDia(HoraDelDia(21, 0)),
        ],
      );

      await pulsarTexto(tester, 'Aceptar');
      expect(find.text('3 tomas al día'), findsOneWidget);
      expect(find.text('Horas: 07:00, 14:00 y 21:00'), findsOneWidget);
    });

    testWidgets('dos tomas a la misma hora no se pueden guardar', (
      tester,
    ) async {
      final entorno = await empezar(tester, 'Metformina');
      await pulsarEtiqueta(tester, 'Una toma más');
      await pulsarTexto(tester, es.formularioMedicamentoConcretas);
      // Se proponen las 09:00 y las 21:00: la primera, 12 horas después.
      for (var i = 0; i < 12; i++) {
        await pulsarEtiqueta(tester, 'Sumar una hora', indice: 0);
      }
      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      expect(find.text(es.validadorMedicamentoHorasRepetidas), findsOneWidget);
      expect(entorno.medicamentos.guardados, isEmpty);
    });

    testWidgets('algunos días de la semana: se eligen con botones grandes y '
        'el resumen lo dice', (tester) async {
      final semantica = tester.ensureSemantics();
      final entorno = await empezar(tester, 'Alendronato');
      await pulsarTexto(tester, es.formularioMedicamentoAlgunosDias);
      // Se propone el día de hoy, domingo.
      expect(
        find.text('Te avisaremos a las 08:00 los domingos.'),
        findsOneWidget,
      );
      await pulsarTexto(tester, 'Domingo');
      expect(find.text(es.validadorMedicamentoSinDias), findsOneWidget);
      await pulsarTexto(tester, 'Lunes');
      await pulsarTexto(tester, 'Jueves');
      expect(
        find.text('Te avisaremos a las 08:00 los lunes y jueves.'),
        findsOneWidget,
      );
      // Con los botones de los días enteros a la vista (al pulsar "Jueves" la
      // pantalla lo deja justo en el borde de arriba).
      await tester.ensureVisible(find.text(es.formularioMedicamentoDiasTitulo));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      expect(
        tester
            .getSemantics(find.text('Lunes'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      semantica.dispose();

      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      final guardado = entorno.medicamentos.guardados.single;
      expect(
        guardado.dias,
        const DiasDeLaSemana({DateTime.monday, DateTime.thursday}),
      );
      expect(
        entorno.notificaciones.deTipo(TipoAviso.toma).map((a) => a.momento),
        const [
          CadaSemana(DateTime.monday, HoraDelDia(8, 0)),
          CadaSemana(DateTime.thursday, HoraDelDia(8, 0)),
        ],
      );
      expect(find.textContaining('Los lunes y jueves.'), findsOneWidget);

      await pulsarTexto(tester, 'Aceptar');
      expect(find.text('Los lunes y jueves'), findsOneWidget);
      // No "Cada día, sin fecha de fin": no se toma cada día.
      expect(find.text('Sin fecha de fin'), findsOneWidget);
    });

    testWidgets('los días elegidos llevan una marca, no solo otro borde', (
      tester,
    ) async {
      await empezar(tester, 'Alendronato');
      await pulsarTexto(tester, es.formularioMedicamentoAlgunosDias);
      Finder marcaDe(String dia) => find.descendant(
        of: find.widgetWithText(TextoConMarca, dia),
        matching: find.byIcon(Icons.check),
      );
      expect(marcaDe('Domingo'), findsOneWidget);
      expect(marcaDe('Lunes'), findsNothing);
      await pulsarTexto(tester, 'Lunes');
      expect(marcaDe('Lunes'), findsOneWidget);
    });

    testWidgets('sin ningún día elegido no se puede guardar', (tester) async {
      final entorno = await empezar(tester, 'Alendronato');
      await pulsarTexto(tester, es.formularioMedicamentoAlgunosDias);
      await pulsarTexto(tester, 'Domingo');
      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      // En el resumen y junto a los días.
      expect(find.text(es.validadorMedicamentoSinDias), findsNWidgets(2));
      expect(entorno.medicamentos.guardados, isEmpty);
    });

    testWidgets('cada varios días, desde hoy', (tester) async {
      final entorno = await empezar(tester, 'Vitamina D');
      await pulsarTexto(tester, es.formularioMedicamentoCadaVariosDias);
      expect(
        find.text(
          'Te avisaremos a las 08:00 cada 2 días, empezando el domingo, 25 '
          'de octubre.',
        ),
        findsOneWidget,
      );
      await pulsarEtiqueta(tester, 'Un día más entre tomas');
      expect(find.text('Cada 3 días'), findsOneWidget);

      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      expect(
        entorno.medicamentos.guardados.single.dias,
        CadaVariosDias(cada: 3, desde: DateTime(2026, 10, 25)),
      );
    });

    testWidgets('al modificar, el formulario muestra las horas y los días', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final metformina = Medicamento(
        id: 4,
        nombre: 'Metformina',
        numTomas: 2,
        frecuenciaHoras: 12,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 1),
        horasLibres: const [HoraDelDia(8, 0), HoraDelDia(21, 0)],
        dias: const DiasDeLaSemana({DateTime.monday}),
      );
      final entorno = EntornoDePrueba(medicamentos: [metformina]);
      await arrancar(tester, entorno);
      await abrirLista(tester);
      await pulsarTexto(tester, 'Modificar');

      expect(find.text('Toma 1'), findsOneWidget);
      expect(find.text('Toma 2'), findsOneWidget);
      expect(
        find.text('Te avisaremos a las 08:00 y 21:00 los lunes.'),
        findsOneWidget,
      );

      await pulsarTexto(tester, es.formularioGuardarCambios);
      expect(entorno.medicamentos.guardados.single, metformina);
    });
  });

  testWidgets('la fecha de renovar la receta se guarda y sale en la lista', (
    tester,
  ) async {
    usarPantallaDeTelefono(tester);
    final entorno = EntornoDePrueba();
    await arrancar(tester, entorno);
    await abrirFormulario(tester);
    await escribir(tester, find.byType(TextField).first, 'Enalapril');
    expect(find.text(es.formularioMedicamentoRecetaFecha), findsNothing);
    await pulsarTexto(tester, es.formularioMedicamentoConReceta);
    expect(
      find.text('Día elegido: Miércoles, 25 de noviembre de 2026'),
      findsOneWidget,
    );
    await pulsarEtiqueta(tester, 'Mes siguiente');
    await pulsarTexto(tester, es.formularioMedicamentoCrear);
    expect(
      entorno.medicamentos.guardados.single.renovarReceta,
      DateTime(2026, 12, 25),
    );
    expect(
      find.textContaining('Receta: hasta el viernes, 25 de diciembre de 2026.'),
      findsOneWidget,
    );
    await pulsarTexto(tester, 'Aceptar');
    expect(
      find.text('Receta: hasta el viernes, 25 de diciembre de 2026'),
      findsOneWidget,
    );
  });

  group('cuando haga falta', () {
    const avisos = Ajustes(notificacionesActivadas: true);

    testWidgets('sin tomas, horas ni días: el resumen lo explica y se guarda '
        'sin avisos', (tester) async {
      final semantica = tester.ensureSemantics();
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(ajustes: avisos);
      await arrancar(tester, entorno);
      await abrirFormulario(tester);
      await escribir(tester, find.byType(TextField).first, 'Ibuprofeno');
      await pulsarTexto(tester, es.formularioMedicamentoADemanda);
      expect(find.text(es.formularioMedicamentoTomasAlDia), findsNothing);
      expect(find.text(es.formularioMedicamentoHoraUnaToma), findsNothing);
      expect(find.text(es.formularioMedicamentoDiasTitulo), findsNothing);
      expect(
        find.text('Sin avisos. Cuando lo tomes, anótalo en "Tomas de hoy".'),
        findsOneWidget,
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantica.dispose();

      // No crea ningún recordatorio: el botón lo dice de otra forma.
      expect(find.text(es.formularioMedicamentoCrear), findsNothing);
      expect(
        find.text('Rellena los datos y pulsa "Guardar medicamento".'),
        findsOneWidget,
      );
      await pulsarTexto(tester, es.formularioMedicamentoGuardar);
      expect(entorno.medicamentos.guardados.single.aDemanda, isTrue);
      expect(entorno.notificaciones.deTipo(TipoAviso.toma), isEmpty);
      expect(
        find.textContaining('Ibuprofeno: cuando haga falta, sin avisos.'),
        findsOneWidget,
      );

      await pulsarTexto(tester, 'Aceptar');
      expect(find.text('Cuando haga falta, sin avisos'), findsOneWidget);
      expect(find.textContaining('Horas:'), findsNothing);
      expect(find.text('Sin fecha de fin'), findsOneWidget);
    });

    testWidgets('con un máximo al día y horas entre tomas', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(ajustes: avisos);
      await arrancar(tester, entorno);
      await abrirFormulario(tester);
      await escribir(tester, find.byType(TextField).first, 'Paracetamol');
      expect(find.text(es.formularioMedicamentoLimitesTitulo), findsNothing);
      await pulsarTexto(tester, es.formularioMedicamentoADemanda);
      expect(find.text(es.formularioMedicamentoSinLimite), findsOneWidget);
      expect(find.text(es.formularioMedicamentoSinMinimo), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await pulsarEtiqueta(tester, es.formularioMedicamentoVezMas);
      }
      for (var i = 0; i < 8; i++) {
        await pulsarEtiqueta(tester, es.formularioMedicamentoHoraMas);
      }
      expect(find.text('3 veces'), findsOneWidget);
      expect(find.text('8 horas'), findsOneWidget);
      const frase =
          'Como mucho 3 veces al día, con al menos 8 horas entre una y otra.';
      expect(find.text(frase), findsOneWidget);

      await pulsarTexto(tester, es.formularioMedicamentoGuardar);
      final guardado = entorno.medicamentos.guardados.single;
      expect(guardado.maximoAlDia, 3);
      expect(guardado.horasEntreTomas, 8);
      expect(
        find.text('Paracetamol: cuando haga falta, sin avisos.\n$frase'),
        findsOneWidget,
      );

      await pulsarTexto(tester, 'Aceptar');
      expect(find.text(frase), findsOneWidget);
    });

    testWidgets('con fecha de fin, el resumen dice hasta cuándo', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba(ajustes: avisos));
      await abrirFormulario(tester);
      await pulsarTexto(tester, es.formularioMedicamentoADemanda);
      await pulsarTexto(tester, es.formularioMedicamentoHastaUnDia);
      expect(
        find.text(
          'Sin avisos. Podrás anotarlo en "Tomas de hoy" hasta el domingo, '
          '1 de noviembre de 2026, incluido.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('volver a "Con un horario" recupera lo que había', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(ajustes: avisos);
      await arrancar(tester, entorno);
      await abrirFormulario(tester);
      await escribir(tester, find.byType(TextField).first, 'Omeprazol');
      await pulsarEtiqueta(tester, 'Una toma más');
      await pulsarTexto(tester, es.formularioMedicamentoADemanda);
      await pulsarTexto(tester, es.formularioMedicamentoConHorario);
      expect(
        find.text('Te avisaremos cada día a las 08:00 y 20:00.'),
        findsOneWidget,
      );
      await pulsarTexto(tester, es.formularioMedicamentoCrear);
      final guardado = entorno.medicamentos.guardados.single;
      expect(guardado.aDemanda, isFalse);
      expect(guardado.numTomas, 2);
    });

    testWidgets('al modificar uno, sigue siendo "cuando haga falta"', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final calmante = Medicamento(
        id: 3,
        nombre: 'Ibuprofeno',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 1),
        aDemanda: true,
      );
      final entorno = EntornoDePrueba(medicamentos: [calmante]);
      await arrancar(tester, entorno);
      await abrirLista(tester);
      await pulsarTexto(tester, 'Modificar');
      expect(find.text(es.formularioMedicamentoTomasAlDia), findsNothing);
      await pulsarTexto(tester, es.formularioGuardarCambios);
      expect(entorno.medicamentos.guardados.single, calmante);
    });
  });
}
