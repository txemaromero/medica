import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/app/respuestas_avisos.dart';
import 'package:salud_mayores/app/rutas.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/application/ajustes_controller.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/data/fotos.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/features/tomas/domain/tomas_del_dia.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';
import 'package:salud_mayores/voz/lector.dart';
import 'package:salud_mayores/voz/servicio_voz.dart';
import 'package:salud_mayores/voz/textos_para_leer.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final omeprazol = Medicamento(
    id: 1,
    nombre: 'Omeprazol',
    numTomas: 1,
    frecuenciaHoras: 24,
    horaInicio: const HoraDelDia(9, 0),
    fechaCreacion: DateTime(2026, 10, 1),
    dosis: '1 pastilla',
    instrucciones: 'en ayunas',
    foto: 'caja_1.jpg',
  );
  final amoxicilina = Medicamento(
    id: 2,
    nombre: 'Amoxicilina',
    numTomas: 2,
    frecuenciaHoras: 8,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
  );

  group('TextosParaLeer', () {
    final hoy = DateTime(2026, 10, 25);

    TomaDelDia toma(Medicamento m, HoraDelDia hora, EstadoTomaDelDia estado) =>
        TomaDelDia(medicamento: m, fecha: hoy, hora: hora, estado: estado);

    test('al tocar el aviso de una toma lee la medicina y qué hacer', () {
      expect(
        TextosParaLeer.toma(omeprazol, const HoraDelDia(9, 0)),
        'Medicina de las 09:00 de la mañana: Omeprazol, 1 pastilla. En '
        'ayunas. Cuando la tomes, pulsa: Ya la he tomado.',
      );
    });

    test('al tocar el aviso de una cita lee cuándo y dónde es', () {
      final cita = Cita(
        id: 1,
        titulo: 'Médico de cabecera',
        fecha: hoy,
        hora: const HoraDelDia(10, 30),
        lugar: 'Centro de salud',
      );
      expect(
        TextosParaLeer.cita(cita, DateTime(2026, 10, 25, 8)),
        'Tienes una cita: Médico de cabecera, hoy a las 10:30, en Centro de '
        'salud.',
      );
    });

    test('resume las tomas de hoy y dice cuáles faltan', () {
      expect(TextosParaLeer.tomasDeHoy([]), 'Hoy no tienes ninguna toma.');
      expect(
        TextosParaLeer.tomasDeHoy([
          toma(amoxicilina, const HoraDelDia(8, 0), EstadoTomaDelDia.tomada),
        ]),
        'Hoy tienes una toma y ya las has tomado todas.',
      );
      expect(
        TextosParaLeer.tomasDeHoy([
          toma(amoxicilina, const HoraDelDia(8, 0), EstadoTomaDelDia.tomada),
          toma(omeprazol, const HoraDelDia(9, 0), EstadoTomaDelDia.sinMarcar),
          toma(
            amoxicilina,
            const HoraDelDia(16, 0),
            EstadoTomaDelDia.pendiente,
          ),
        ]),
        'Hoy tienes 3 tomas. Has tomado 1. Te faltan: Omeprazol, 1 pastilla, '
        'de las 09:00 de la mañana, sin marcar. Amoxicilina, a las 16:00 de '
        'la tarde.',
      );
    });
  });

  group('AlmacenFotosCarpeta', () {
    late Directory temporal;
    late AlmacenFotosCarpeta almacen;

    setUp(() {
      temporal = Directory.systemTemp.createTempSync('fotos_salud');
      addTearDown(() => temporal.deleteSync(recursive: true));
      var micro = 0;
      almacen = AlmacenFotosCarpeta(
        Directory('${temporal.path}/fotos'),
        reloj: () => DateTime.fromMicrosecondsSinceEpoch(++micro),
      );
    });

    File fotoTemporal(String nombre) =>
        File('${temporal.path}/$nombre')..writeAsBytesSync([1, 2, 3]);

    test('copia la foto a su carpeta con un nombre propio', () async {
      final nombre = await almacen.guardar(fotoTemporal('IMG_0001.JPG').path);
      expect(nombre, 'caja_1.jpg');
      expect(File(almacen.ruta(nombre)).readAsBytesSync(), [1, 2, 3]);
      final otra = await almacen.guardar(fotoTemporal('sin_extension').path);
      expect(otra, 'caja_2.jpg');
    });

    test('limpiar borra solo las fotos que ya no se usan', () async {
      final usada = await almacen.guardar(fotoTemporal('a.jpg').path);
      final sobrante = await almacen.guardar(fotoTemporal('b.jpg').path);
      await almacen.limpiar({usada});
      expect(File(almacen.ruta(usada)).existsSync(), isTrue);
      expect(File(almacen.ruta(sobrante)).existsSync(), isFalse);
    });

    test('limpiar sin carpeta todavía no falla', () async {
      await almacen.limpiar({});
      expect(Directory('${temporal.path}/fotos').existsSync(), isFalse);
    });
  });

  group('ServicioVozCanal', () {
    const canal = MethodChannel('es.saludmayores.salud_mayores/voz');
    final mensajero =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    tearDown(() => mensajero.setMockMethodCallHandler(canal, null));

    test('envía el texto que hay que leer y el idioma de la app', () async {
      final llamadas = <MethodCall>[];
      mensajero.setMockMethodCallHandler(canal, (llamada) async {
        llamadas.add(llamada);
        // El dictado responde sin datos: no disponible.
        return llamada.method == 'hablar' ? true : null;
      });
      expect(await const ServicioVozCanal().hablar('Hola'), isTrue);
      expect(
        await const ServicioVozCanal().dictar('Di el nombre'),
        isA<DictadoNoDisponible>(),
      );
      expect([for (final l in llamadas) l.method], ['hablar', 'dictar']);
      expect(llamadas.first.arguments, {'texto': 'Hola', 'idioma': 'es'});
      expect(llamadas.last.arguments, {
        'indicacion': 'Di el nombre',
        'idioma': 'es',
      });
    });

    test('traduce las respuestas del dictado', () async {
      Object? respuesta;
      mensajero.setMockMethodCallHandler(canal, (_) async => respuesta);
      const voz = ServicioVozCanal();

      respuesta = {'estado': 'reconocido', 'texto': 'paracetamol'};
      expect(
        await voz.dictar('Di el nombre'),
        isA<DictadoReconocido>().having((d) => d.texto, 'texto', 'paracetamol'),
      );
      respuesta = {'estado': 'cancelado'};
      expect(await voz.dictar('Di el nombre'), isA<DictadoCancelado>());
      respuesta = {'estado': 'no_disponible'};
      expect(await voz.dictar('Di el nombre'), isA<DictadoNoDisponible>());
    });

    test(
      'sin implementación nativa (por ejemplo, en iOS) no hay voz',
      () async {
        const voz = ServicioVozCanal();
        expect(await voz.hablar('Hola'), isFalse);
        expect(await voz.puedeDictar(), isFalse);
        expect(await voz.dictar('Di el nombre'), isA<DictadoNoDisponible>());
      },
    );
  });

  group('AjustesController', () {
    (EntornoDePrueba, ProviderContainer) crear({
      bool vozDisponible = true,
      bool permiso = true,
    }) {
      final entorno = EntornoDePrueba(
        voz: ServicioVozFalso(disponible: vozDisponible),
        notificaciones: ServicioNotificacionesFalso(permiso: permiso),
        asistenteCompletado: false,
      );
      final contenedor = ProviderContainer(overrides: entorno.overrides);
      addTearDown(contenedor.dispose);
      // Antes de liberar el contenedor, se espera a que terminen de
      // programarse los avisos.
      addTearDown(() => contenedor.read(sincronizadorAvisosProvider).esperar());
      return (entorno, contenedor);
    }

    test('activar la lectura en voz alta lee una frase de prueba', () async {
      final (entorno, contenedor) = crear();
      final controlador = contenedor.read(ajustesProvider.notifier);
      expect(await controlador.cambiarLecturaEnVozAlta(true), isTrue);
      expect(entorno.voz.leidos, [fraseDePruebaVoz]);
      expect(entorno.ajustes.ajustes.leerEnVozAlta, isTrue);

      expect(await controlador.cambiarLecturaEnVozAlta(false), isTrue);
      expect(entorno.voz.vecesCallado, 1);
      expect(entorno.ajustes.ajustes.leerEnVozAlta, isFalse);
    });

    test('sin voz en español la lectura sigue desactivada', () async {
      final (entorno, contenedor) = crear(vozDisponible: false);
      expect(
        await contenedor
            .read(ajustesProvider.notifier)
            .cambiarLecturaEnVozAlta(true),
        isFalse,
      );
      expect(entorno.ajustes.ajustes.leerEnVozAlta, isFalse);
    });

    test('el asistente activa los avisos con sonido y vibración', () async {
      final (entorno, contenedor) = crear();
      final resultado = await contenedor
          .read(ajustesProvider.notifier)
          .activarAvisosCompletos();
      expect(resultado, isNot(ResultadoNotificaciones.permisoDenegado));
      final ajustes = entorno.ajustes.ajustes;
      expect(ajustes.notificacionesActivadas, isTrue);
      expect(ajustes.sonidoActivado, isTrue);
      expect(ajustes.vibracionActivada, isTrue);
    });

    test('sin permiso del teléfono no activa nada', () async {
      final (entorno, contenedor) = crear(permiso: false);
      expect(
        await contenedor
            .read(ajustesProvider.notifier)
            .activarAvisosCompletos(),
        ResultadoNotificaciones.permisoDenegado,
      );
      expect(entorno.ajustes.ajustes, const Ajustes());
    });

    test('completar el asistente se recuerda', () async {
      final (entorno, contenedor) = crear();
      final controlador = contenedor.read(ajustesProvider.notifier);
      expect(controlador.asistenteCompletado, isFalse);
      await controlador.completarAsistente();
      expect(controlador.asistenteCompletado, isTrue);
      expect(entorno.ajustes.asistente, isTrue);
    });
  });

  group('Lectura en voz alta al responder un aviso', () {
    Future<(ResultadoRespuesta?, EntornoDePrueba)> procesar(
      String? accion,
      CargaAviso carga, {
      bool leer = true,
    }) async {
      final entorno = EntornoDePrueba(
        medicamentos: [omeprazol],
        citas: [
          Cita(
            id: 4,
            titulo: 'Dentista',
            fecha: DateTime(2026, 10, 25),
            hora: const HoraDelDia(12, 0),
          ),
        ],
        ajustes: Ajustes(notificacionesActivadas: true, leerEnVozAlta: leer),
        ahora: DateTime(2026, 10, 25, 9, 2),
      );
      final contenedor = ProviderContainer(overrides: entorno.overrides);
      addTearDown(contenedor.dispose);
      // Antes de liberar el contenedor, se espera a que terminen de
      // programarse los avisos.
      addTearDown(() => contenedor.read(sincronizadorAvisosProvider).esperar());
      final resultado = await contenedor
          .read(procesadorRespuestasProvider)
          .procesar(RespuestaAviso(accion: accion, carga: carga.codificar()));
      if (resultado?.lectura case final lectura?) {
        await contenedor.read(lectorProvider).leer(lectura);
      }
      return (resultado, entorno);
    }

    const toma = CargaToma(medicamentoId: 1, hora: HoraDelDia(9, 0));

    test('tocar el aviso de una toma la lee', () async {
      final (resultado, entorno) = await procesar(null, toma);
      expect(resultado?.ruta, Rutas.tomasHoy);
      expect(entorno.voz.leidos, [
        TextosParaLeer.toma(omeprazol, const HoraDelDia(9, 0)),
      ]);
    });

    test('"Ya la he tomado" lee la confirmación', () async {
      final (_, entorno) = await procesar(AccionesAviso.tomada, toma);
      expect(entorno.voz.leidos, ['Anotado: has tomado Omeprazol (09:00).']);
      expect(entorno.tomas.registros.single.estado, EstadoToma.tomada);
    });

    test('tocar el aviso de una cita la lee', () async {
      final (resultado, entorno) = await procesar(null, const CargaCita(4));
      expect(resultado?.ruta, Rutas.agenda);
      expect(entorno.voz.leidos, [
        'Tienes una cita: Dentista, hoy a las 12:00.',
      ]);
    });

    test('con la lectura desactivada no se lee nada', () async {
      final (resultado, entorno) = await procesar(null, toma, leer: false);
      expect(resultado?.lectura, isNotNull);
      expect(entorno.voz.leidos, isEmpty);
    });
  });

  test('los avisos de un medicamento con foto la llevan; los de citas, no', () {
    final avisos = PlanificadorAvisos.planificar(
      medicamentos: [omeprazol, amoxicilina],
      citas: [
        Cita(
          id: 1,
          titulo: 'Dentista',
          fecha: DateTime(2026, 10, 26),
          hora: const HoraDelDia(12, 0),
        ),
      ],
      ajustes: const Ajustes(notificacionesActivadas: true),
      ahora: DateTime(2026, 10, 25, 7),
    );
    bool deOmeprazol(AvisoProgramado aviso) =>
        switch (CargaAviso.decodificar(aviso.carga)) {
          CargaToma(medicamentoId: 1) => true,
          _ => false,
        };
    expect(avisos.where(deOmeprazol), isNotEmpty);
    expect(avisos.where(deOmeprazol).map((a) => a.foto).toSet(), {
      'caja_1.jpg',
    });
    expect(
      avisos.where((a) => !deOmeprazol(a)).map((a) => a.foto),
      everyElement(isNull),
    );
    expect(avisos.where((a) => a.tipo == TipoAviso.cita), isNotEmpty);
  });
}
