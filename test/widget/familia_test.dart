import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/compartir/domain/copia_de_seguridad.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/textos.dart';

void main() {
  final paracetamol = Medicamento(
    id: 1,
    nombre: 'Paracetamol',
    numTomas: 2,
    frecuenciaHoras: 12,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
  );

  /// El campo de texto cuya etiqueta para TalkBack es [etiqueta].
  Finder campo(String etiqueta) => find.byWidgetPredicate(
    (w) => w is Semantics && w.properties.label == etiqueta,
  );

  Future<void> abrirAjustes(WidgetTester tester) async {
    await pulsarTexto(tester, 'Ajustes');
  }

  group('Contacto de un familiar', () {
    testWidgets('se guarda desde Ajustes y se llama desde Emergencias', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        ajustes: const Ajustes(numeroEmergencia: '112'),
      );
      await arrancar(tester, entorno);
      await abrirAjustes(tester);

      await escribir(
        tester,
        find.descendant(
          of: campo('Nombre de un familiar'),
          matching: find.byType(TextField),
        ),
        'Mi hija Ana',
      );
      await escribir(
        tester,
        find.descendant(
          of: campo('Teléfono del familiar'),
          matching: find.byType(TextField),
        ),
        '600 12 34 56',
      );
      expect(entorno.ajustes.ajustes.familiarNombre, 'Mi hija Ana');
      expect(entorno.ajustes.ajustes.familiarNumero, '600123456');
      expect(
        find.text('Contacto guardado: Mi hija Ana, 600123456'),
        findsOneWidget,
      );

      await pulsarTexto(tester, 'Inicio');
      await pulsarTexto(tester, 'Botón de emergencias');
      expect(find.bySemanticsLabel('Llamar al 112'), findsOneWidget);
      await pulsarEtiqueta(tester, 'Llamar a Mi hija Ana');
      expect(entorno.marcador.numerosMarcados, ['600123456']);
      expect(
        find.text('Abriendo el teléfono para llamar a Mi hija Ana…'),
        findsOneWidget,
      );
    });

    testWidgets('si falta el nombre o el teléfono, lo explica', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await abrirAjustes(tester);
      await escribir(
        tester,
        find.descendant(
          of: campo('Teléfono del familiar'),
          matching: find.byType(TextField),
        ),
        '600123456',
      );
      expect(find.textContaining('Escribe cómo se llama'), findsOneWidget);
      expect(entorno.ajustes.ajustes.tieneFamiliar, isFalse);
    });

    testWidgets('con los dos campos vacíos se borra', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        ajustes: const Ajustes(
          familiarNombre: 'Ana',
          familiarNumero: '600123456',
        ),
      );
      await arrancar(tester, entorno);
      await abrirAjustes(tester);
      for (final etiqueta in [
        'Nombre de un familiar',
        'Teléfono del familiar',
      ]) {
        await tester.enterText(
          find.descendant(
            of: campo(etiqueta),
            matching: find.byType(TextField),
          ),
          '',
        );
      }
      await pulsarTexto(tester, 'Guardar contacto');
      expect(entorno.ajustes.ajustes.tieneFamiliar, isFalse);
      expect(find.text('Contacto del familiar borrado'), findsOneWidget);
    });

    testWidgets('sin número de emergencia, Emergencias ofrece al familiar y '
        'explica cómo guardar el número', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        ajustes: const Ajustes(
          familiarNombre: 'Ana',
          familiarNumero: '600123456',
        ),
      );
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Botón de emergencias');
      expect(find.text(es.emergenciasSinNumero), findsOneWidget);
      expect(find.text('Llamar a Ana'), findsOneWidget);
      await pulsarTexto(tester, 'Llamar a Ana');
      expect(entorno.marcador.numerosMarcados, ['600123456']);
    });
  });

  group('Compartir y copia de seguridad', () {
    Future<EntornoDePrueba> abrir(
      WidgetTester tester, {
      EntornoDePrueba? entorno,
    }) async {
      usarPantallaDeTelefono(tester);
      final e = entorno ?? EntornoDePrueba(medicamentos: [paracetamol]);
      await arrancar(tester, e);
      await abrirAjustes(tester);
      await pulsarTexto(tester, es.compartirTitulo);
      return e;
    }

    testWidgets('se llega también desde Registro de medicamentos', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba());
      await pulsarTexto(tester, 'Registro de medicamentos');
      await pulsarTexto(tester, 'Compartir con el médico o la familia');
      expect(find.text(es.compartirEnviarInforme), findsOneWidget);
    });

    testWidgets('enviar e imprimir la medicación preparan un PDF', (
      tester,
    ) async {
      final entorno = await abrir(tester);
      await pulsarTexto(tester, es.compartirEnviarInforme);
      await pulsarTexto(tester, es.compartirImprimir);
      final pdf = entorno.archivos.compartidos.single;
      expect(pdf.tipo, 'application/pdf');
      expect(ascii.decode(pdf.datos.sublist(0, 5)), '%PDF-');
      expect(entorno.archivos.impresos, hasLength(1));
    });

    testWidgets('guardar y enviar una copia', (tester) async {
      final entorno = await abrir(tester);
      await pulsarTexto(tester, es.compartirGuardarCopia);
      expect(find.text('Copia de seguridad guardada.'), findsOneWidget);
      await pulsarTexto(tester, es.compartirEnviarCopia);

      final guardada = CopiaDeSeguridad.decodificar(
        entorno.archivos.guardados.single.datos,
      );
      expect(guardada.medicamentos, [paracetamol]);
      expect(entorno.archivos.compartidos.single.tipo, 'application/json');
    });

    testWidgets('recuperar una copia pregunta antes y sustituye los datos', (
      tester,
    ) async {
      final entorno = await abrir(tester);
      final cita = Cita(
        id: 4,
        titulo: 'Dentista',
        fecha: DateTime(2026, 11, 2),
        hora: const HoraDelDia(11, 0),
      );
      entorno.archivos.alAbrir = CopiaDeSeguridad(
        creada: DateTime(2026, 10, 20, 18, 5),
        medicamentos: const [],
        citas: [cita],
        tomas: const [],
        ajustes: const Ajustes(tamanoTexto: 25, notificacionesActivadas: true),
      ).codificar();
      // Una copia con teléfonos los dice antes de recuperarla.
      final conTelefonos = CopiaDeSeguridad(
        creada: DateTime(2026, 10, 20, 18, 5),
        medicamentos: const [],
        citas: const [],
        tomas: const [],
        ajustes: const Ajustes(
          numeroEmergencia: '112',
          familiarNombre: 'Mi hija Ana',
          familiarNumero: '600123456',
        ),
      ).codificar();
      final sinTelefonos = entorno.archivos.alAbrir;
      entorno.archivos.alAbrir = conTelefonos;
      await pulsarTexto(tester, es.compartirRecuperar);
      expect(find.textContaining('Número de emergencia: 112.'), findsOneWidget);
      expect(
        find.textContaining('Familiar: Mi hija Ana, 600123456.'),
        findsOneWidget,
      );
      await pulsarTexto(tester, 'No, volver');
      entorno.archivos.alAbrir = sinTelefonos;

      // Primero se cancela: no cambia nada.
      await pulsarTexto(tester, es.compartirRecuperar);
      expect(find.text('¿Recuperar esta copia?'), findsOneWidget);
      expect(
        find.textContaining('martes, 20 de octubre de 2026, a las 18:05'),
        findsOneWidget,
      );
      expect(find.textContaining('(1 medicamento y 0 citas)'), findsOneWidget);
      // Los teléfonos que se pondrán en Emergencias, aunque no haya.
      expect(find.textContaining('Sin número de emergencia.'), findsOneWidget);
      expect(find.textContaining('Sin familiar.'), findsOneWidget);
      await pulsarTexto(tester, 'No, volver');
      expect(await entorno.medicamentos.obtenerTodos(), [paracetamol]);

      await pulsarTexto(tester, es.compartirRecuperar);
      await pulsarTexto(tester, es.compartirSiRecuperar);
      expect(find.text('Copia recuperada'), findsOneWidget);
      expect(find.textContaining('actívalos en Ajustes'), findsOneWidget);
      expect(await entorno.medicamentos.obtenerTodos(), isEmpty);
      expect(await entorno.citas.obtenerTodas(), [cita]);
      expect(entorno.ajustes.ajustes.tamanoTexto, 25);
      expect(entorno.ajustes.ajustes.notificacionesActivadas, isFalse);
    });

    testWidgets('añadir los medicamentos de otro móvil pregunta qué añade y '
        'no borra nada', (tester) async {
      final entorno = await abrir(tester);
      final omeprazol = Medicamento(
        id: 8,
        nombre: 'Omeprazol',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(9, 0),
        fechaCreacion: DateTime(2026, 10, 20),
      );
      entorno.archivos.alAbrir = CopiaDeSeguridad(
        creada: DateTime(2026, 10, 24, 19, 30),
        medicamentos: [
          omeprazol,
          Medicamento(
            id: 3,
            nombre: 'Paracetamol',
            numTomas: 3,
            frecuenciaHoras: 8,
            horaInicio: const HoraDelDia(7, 0),
            fechaCreacion: DateTime(2026, 10, 20),
          ),
        ],
        citas: [
          Cita(
            id: 4,
            titulo: 'Dentista',
            fecha: DateTime(2026, 11, 2),
            hora: const HoraDelDia(11, 0),
          ),
        ],
        tomas: const [],
        ajustes: const Ajustes(tamanoTexto: 35),
      ).codificar();

      await pulsarTexto(tester, es.compartirImportar);
      expect(find.text('¿Añadir lo que trae esta copia?'), findsOneWidget);
      expect(find.textContaining('Se añadirán: Omeprazol.'), findsOneWidget);
      expect(find.textContaining('Ya tenías Paracetamol'), findsOneWidget);
      expect(find.textContaining('Citas nuevas: Dentista.'), findsOneWidget);
      expect(find.textContaining('No se borra nada'), findsOneWidget);
      await pulsarTexto(tester, es.importarSi);

      expect(find.text('Medicamentos añadidos'), findsOneWidget);
      expect(
        find.textContaining(
          'Ya tienes en este teléfono 2 medicamentos y 1 cita.',
        ),
        findsOneWidget,
      );
      final medicamentos = await entorno.medicamentos.obtenerTodos();
      expect(medicamentos.map((m) => m.nombre), ['Omeprazol', 'Paracetamol']);
      final paracetamolNuevo = medicamentos.last;
      expect(paracetamolNuevo.id, paracetamol.id);
      expect(paracetamolNuevo.numTomas, 3);
      // Los ajustes de la copia no se tocan.
      expect(entorno.ajustes.ajustes.tamanoTexto, 20);
    });

    testWidgets('el recordatorio semanal de enviar el resumen', (tester) async {
      final entorno = await abrir(
        tester,
        entorno: EntornoDePrueba(
          ajustes: const Ajustes(notificacionesActivadas: true),
        ),
      );
      await pulsarTexto(tester, es.compartirRecordarResumen);
      expect(entorno.ajustes.ajustes.recordarResumen, isTrue);
      await ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
          .read(sincronizadorAvisosProvider)
          .esperar();
      expect(entorno.notificaciones.deTipo(TipoAviso.resumen), hasLength(1));

      await pulsarTexto(tester, es.compartirRecordarResumen);
      expect(entorno.ajustes.ajustes.recordarResumen, isFalse);
    });

    testWidgets('sin avisos activados, el recordatorio lo explica', (
      tester,
    ) async {
      await abrir(tester);
      await pulsarTexto(tester, es.compartirRecordarResumen);
      expect(find.text(es.compartirAvisosDesactivados), findsOneWidget);
    });

    testWidgets('tocar el recordatorio abre "Compartir"', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      entorno.notificaciones.responder(
        RespuestaAviso(carga: const CargaResumen().codificar()),
      );
      await tester.pumpAndSettle();
      expect(find.text(es.compartirEnviarInforme), findsOneWidget);
    });

    testWidgets('si la copia no trae nada nuevo, lo dice', (tester) async {
      final entorno = await abrir(tester);
      entorno.archivos.alAbrir = CopiaDeSeguridad(
        creada: DateTime(2026, 10, 24, 19, 30),
        medicamentos: const [],
        citas: const [],
        tomas: const [],
        ajustes: const Ajustes(),
      ).codificar();
      await pulsarTexto(tester, es.compartirImportar);
      expect(find.text(es.importarNadaNuevo), findsOneWidget);
      await pulsarTexto(tester, 'Entendido');
      expect(await entorno.medicamentos.obtenerTodos(), [paracetamol]);
    });

    testWidgets('un fichero que no es una copia se explica', (tester) async {
      final entorno = await abrir(tester);
      entorno.archivos.alAbrir = utf8.encode('una lista de la compra');
      await pulsarTexto(tester, es.compartirRecuperar);
      expect(find.text('No se puede recuperar este fichero'), findsOneWidget);
      expect(find.text(CopiaDeSeguridad.mensajeNoEsCopia), findsOneWidget);
      await pulsarTexto(tester, 'Entendido');
      expect(await entorno.medicamentos.obtenerTodos(), [paracetamol]);
    });
  });
}
