import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/application/ajustes_controller.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/data/fotos.dart';
import 'package:salud_mayores/features/medicamentos/domain/borrador_medicamento.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/medicamentos/presentation/foto_caja.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/voz/servicio_voz.dart';
import 'package:salud_mayores/voz/textos_para_leer.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';
import '../helpers/textos.dart';

void main() {
  final omeprazol = Medicamento(
    id: 1,
    nombre: 'Omeprazol',
    numTomas: 1,
    frecuenciaHoras: 24,
    horaInicio: const HoraDelDia(9, 0),
    fechaCreacion: DateTime(2026, 10, 1),
    dosis: '1 pastilla',
    foto: 'caja_omeprazol.jpg',
  );

  Future<void> abrirFormularioNuevo(WidgetTester tester) async {
    await pulsarTexto(tester, 'Registro de medicamentos');
    await pulsarTexto(tester, 'Registrar nuevo medicamento');
  }

  group('Foto de la caja', () {
    testWidgets('se hace con la cámara, se ve en el formulario y se guarda '
        'con el medicamento', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await abrirFormularioNuevo(tester);
      await escribir(tester, find.byType(TextField).first, 'Omeprazol');

      await pulsarTexto(tester, 'Hacer una foto');
      expect(entorno.selectorFotos.origenes, [OrigenFoto.camara]);
      expect(entorno.fotos.originales, ['/tmp/foto_de_la_camara.jpg']);
      expect(
        find.bySemanticsLabel('Foto de la caja de Omeprazol'),
        findsOneWidget,
      );
      expect(find.textContaining('Foto añadida'), findsOneWidget);
      expect(find.text('Hacer otra foto'), findsOneWidget);

      await pulsarTexto(tester, 'Crear recordatorio');
      await pulsarTexto(tester, 'Aceptar');
      final guardado = (await entorno.medicamentos.obtenerTodos()).single;
      expect(guardado.foto, 'caja_1.jpg');
      // La lista de medicamentos también la muestra.
      expect(find.byType(FotoCaja), findsOneWidget);
    });

    testWidgets('volver de la galería sin elegir no cambia nada', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      entorno.selectorFotos.siguiente = null;
      await arrancar(tester, entorno);
      await abrirFormularioNuevo(tester);
      await pulsarTexto(tester, 'Elegir de la galería');
      expect(entorno.selectorFotos.origenes, [OrigenFoto.galeria]);
      expect(find.byType(FotoCaja), findsNothing);
      expect(entorno.fotos.originales, isEmpty);
    });

    testWidgets('si la cámara no se puede abrir, lo explica', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      entorno.selectorFotos.fallar = true;
      await arrancar(tester, entorno);
      await abrirFormularioNuevo(tester);
      await pulsarTexto(tester, 'Hacer una foto');
      expect(
        find.text('No se ha podido hacer la foto. Inténtalo otra vez.'),
        findsOneWidget,
      );
      expect(find.byType(FotoCaja), findsNothing);
    });

    testWidgets('al modificar se puede quitar la foto', (tester) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(medicamentos: [omeprazol]);
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Registro de medicamentos');
      await pulsarTexto(tester, 'Ver medicamentos registrados');
      expect(find.byType(FotoCaja), findsOneWidget);
      await pulsarTexto(tester, 'Modificar');
      expect(find.byType(FotoCaja), findsOneWidget);

      await pulsarTexto(tester, 'Quitar la foto');
      expect(find.byType(FotoCaja), findsNothing);
      await pulsarTexto(tester, 'Guardar cambios');
      await pulsarTexto(tester, 'Aceptar');
      expect((await entorno.medicamentos.obtenerTodos()).single.foto, isNull);
      expect(find.byType(FotoCaja), findsNothing);
    });

    group('si Android cierra la app con la cámara abierta', () {
      // Lo que había en el formulario al abrir la cámara.
      final borrador = BorradorMedicamento(
        nombre: 'Omeprazol',
        dosis: '1 cápsula',
        numTomas: 2,
        frecuenciaHoras: 12,
        horaInicio: const HoraDelDia(9, 0),
        conFechaFin: false,
        fechaFin: DateTime(2026, 11, 1),
      );

      testWidgets('mientras la cámara está abierta hay un borrador, y al '
          'volver con normalidad se borra', (tester) async {
        usarPantallaDeTelefono(tester);
        final entorno = EntornoDePrueba();
        BorradorMedicamento? conLaCamaraAbierta;
        entorno.selectorFotos.alElegir = () =>
            conLaCamaraAbierta = entorno.borradores.borrador;
        await arrancar(tester, entorno);
        await abrirFormularioNuevo(tester);
        await escribir(tester, find.byType(TextField).first, 'Omeprazol');

        await pulsarTexto(tester, 'Hacer una foto');
        expect(conLaCamaraAbierta?.nombre, 'Omeprazol');
        expect(conLaCamaraAbierta?.medicamentoId, isNull);
        expect(entorno.borradores.borrador, isNull);
      });

      testWidgets('al volver a abrirla se recupera el formulario con la foto', (
        tester,
      ) async {
        usarPantallaDeTelefono(tester);
        final entorno = EntornoDePrueba(borrador: borrador);
        entorno.selectorFotos.perdida = '/tmp/foto_perdida.jpg';
        await arrancar(tester, entorno);

        expect(find.text(es.formularioMedicamentoTituloNuevo), findsOneWidget);
        expect(find.text('Omeprazol'), findsOneWidget);
        expect(find.text('1 cápsula'), findsOneWidget);
        expect(
          find.text(
            es.formularioRecuperadoConFoto(es.formularioMedicamentoCrear),
          ),
          findsOneWidget,
        );
        expect(entorno.fotos.originales, ['/tmp/foto_perdida.jpg']);
        expect(entorno.borradores.borrador, isNull);

        await pulsarTexto(tester, 'Crear recordatorio');
        final guardado = (await entorno.medicamentos.obtenerTodos()).single;
        expect(guardado.nombre, 'Omeprazol');
        expect(guardado.numTomas, 2);
        expect(guardado.frecuenciaHoras, 12);
        expect(guardado.foto, 'caja_1.jpg');
      });

      testWidgets('si se estaba modificando, se recupera sobre el mismo '
          'medicamento; "Atrás" lleva a la lista', (tester) async {
        usarPantallaDeTelefono(tester);
        final entorno = EntornoDePrueba(
          medicamentos: [omeprazol],
          borrador: BorradorMedicamento(
            medicamentoId: omeprazol.id,
            nombre: 'Omeprazol 20 mg',
            dosis: '1 pastilla',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: const HoraDelDia(9, 0),
            conFechaFin: false,
            fechaFin: DateTime(2026, 11, 1),
            foto: omeprazol.foto,
          ),
        );
        await arrancar(tester, entorno);

        expect(
          find.text(es.formularioMedicamentoTituloModificar),
          findsOneWidget,
        );
        expect(find.text('Omeprazol 20 mg'), findsOneWidget);
        expect(find.text(es.formularioRecuperado), findsOneWidget);

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text(es.listaMedicamentosTitulo), findsOneWidget);
      });
    });

    testWidgets('"Tomas de hoy" muestra la foto para reconocer la medicina', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba(medicamentos: [omeprazol]));
      await pulsarTexto(tester, 'Registro de medicamentos');
      await pulsarTexto(tester, es.tomasTitulo);
      expect(find.byType(FotoCaja), findsOneWidget);
    });
  });

  group('Leer en voz alta', () {
    testWidgets('al activarlo en Ajustes se oye una frase de prueba', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba();
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Leer en voz alta');
      expect(entorno.voz.leidos, [fraseDePruebaVoz]);
      expect(entorno.ajustes.ajustes.leerEnVozAlta, isTrue);
      expect(find.text('Lectura en voz alta activada'), findsOneWidget);
    });

    testWidgets('si el teléfono no tiene voz en español, lo explica', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(voz: ServicioVozFalso(disponible: false));
      await arrancar(tester, entorno);
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Leer en voz alta');
      expect(
        find.text('Este teléfono no puede leer en voz alta'),
        findsOneWidget,
      );
      expect(find.text(es.ajustesSinVozMensaje), findsOneWidget);
      await pulsarTexto(tester, 'Entendido');
      expect(entorno.ajustes.ajustes.leerEnVozAlta, isFalse);
    });

    testWidgets('en un iPhone sin esa voz, explica dónde se descarga', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      usarPantallaDeTelefono(tester);
      await arrancar(
        tester,
        EntornoDePrueba(voz: ServicioVozFalso(disponible: false)),
      );
      await pulsarTexto(tester, 'Ajustes');
      await pulsarTexto(tester, 'Leer en voz alta');
      expect(find.text(es.ajustesSinVozMensajeIphone), findsOneWidget);
      // En iOS no hay widget de la pantalla de inicio.
      expect(find.text(es.ajustesWidget), findsNothing);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('sin activarlo, "Tomas de hoy" no ofrece escucharlas', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba(medicamentos: [omeprazol]));
      await pulsarTexto(tester, 'Registro de medicamentos');
      await pulsarTexto(tester, es.tomasTitulo);
      expect(find.text(es.tomasEscuchar), findsNothing);
    });

    testWidgets('activado, "Tomas de hoy" lee cuáles faltan', (tester) async {
      usarPantallaDeTelefono(tester);
      final encendido = EntornoDePrueba(
        medicamentos: [omeprazol],
        ajustes: const Ajustes(leerEnVozAlta: true),
        ahora: DateTime(2026, 10, 25, 8),
      );
      await arrancar(tester, encendido);
      await pulsarTexto(tester, 'Registro de medicamentos');
      await pulsarTexto(tester, es.tomasTitulo);
      await pulsarTexto(tester, es.tomasEscuchar);
      expect(encendido.voz.leidos, [
        'Hoy tienes una toma. Has tomado 0. Te falta: Omeprazol, 1 pastilla, '
            'a las 09:00 de la mañana.',
      ]);
    });

    testWidgets('al tocar el aviso de una toma se lee en voz alta', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final entorno = EntornoDePrueba(
        medicamentos: [omeprazol],
        ajustes: const Ajustes(
          notificacionesActivadas: true,
          leerEnVozAlta: true,
        ),
      );
      await arrancar(tester, entorno);
      entorno.notificaciones.responder(
        RespuestaAviso(
          carga: const CargaToma(
            medicamentoId: 1,
            hora: HoraDelDia(9, 0),
          ).codificar(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(es.tomasTitulo), findsOneWidget);
      expect(entorno.voz.leidos, [
        TextosParaLeer.toma(omeprazol, const HoraDelDia(9, 0)),
      ]);
    });
  });

  group('Dictar', () {
    testWidgets('sin dictado en el teléfono no aparece el botón', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      await arrancar(tester, EntornoDePrueba());
      await abrirFormularioNuevo(tester);
      expect(find.text('Dictar el nombre'), findsNothing);
    });

    testWidgets('el nombre dictado se escribe en el campo', (tester) async {
      usarPantallaDeTelefono(tester);
      final voz = ServicioVozFalso(dictado: true)
        ..respuestaDictado = const DictadoReconocido('paracetamol');
      final entorno = EntornoDePrueba(voz: voz);
      await arrancar(tester, entorno);
      await abrirFormularioNuevo(tester);

      await pulsarTexto(tester, 'Dictar el nombre');
      expect(voz.indicaciones, ['Di el nombre del medicamento']);
      final campo = tester.widget<TextField>(find.byType(TextField).first);
      expect(campo.controller!.text, 'Paracetamol');
      expect(find.textContaining('Has dictado: Paracetamol'), findsOneWidget);
    });

    testWidgets('si el dictado deja de estar disponible, lo explica', (
      tester,
    ) async {
      usarPantallaDeTelefono(tester);
      final voz = ServicioVozFalso(dictado: true)
        ..respuestaDictado = const DictadoNoDisponible();
      await arrancar(tester, EntornoDePrueba(voz: voz));
      await abrirFormularioNuevo(tester);
      await pulsarTexto(tester, 'Dictar el nombre');
      expect(
        find.text('Este teléfono no permite dictar. Escríbelo con el teclado.'),
        findsOneWidget,
      );
    });

    testWidgets('en una cita se puede dictar el motivo', (tester) async {
      usarPantallaDeTelefono(tester);
      final voz = ServicioVozFalso(dictado: true)
        ..respuestaDictado = const DictadoReconocido('dentista');
      await arrancar(tester, EntornoDePrueba(voz: voz));
      await pulsarTexto(tester, 'Agenda');
      await pulsarTexto(tester, 'Crear cita');
      await pulsarTexto(tester, 'Dictar el motivo');
      expect(voz.indicaciones, ['Di el motivo de la cita']);
      final campo = tester.widget<TextField>(find.byType(TextField).first);
      expect(campo.controller!.text, 'Dentista');
    });
  });
}
