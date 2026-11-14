import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/ajustes/domain/validador_familiar.dart';
import 'package:salud_mayores/features/compartir/application/servicio_compartir.dart';
import 'package:salud_mayores/features/compartir/data/informe_pdf.dart';
import 'package:salud_mayores/features/compartir/domain/copia_de_seguridad.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/existencias.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';

/// El primer elemento de la lista [clave] de una copia en JSON.
Map<String, Object?> _primero(Map<String, Object?> copia, String clave) =>
    (copia[clave]! as List<Object?>).first! as Map<String, Object?>;

void main() {
  final ahora = DateTime(2026, 10, 25, 12, 30);
  // Empieza como un JPEG: la copia solo admite imágenes.
  final fotoOmeprazol = Uint8List.fromList([
    0xFF,
    0xD8,
    0xFF,
    ...List.generate(61, (i) => i),
  ]);

  final omeprazol = Medicamento(
    id: 3,
    nombre: 'Omeprazol',
    numTomas: 1,
    frecuenciaHoras: 24,
    horaInicio: const HoraDelDia(9, 0),
    fechaCreacion: DateTime(2026, 10, 1, 10, 15),
    dosis: '1 pastilla',
    instrucciones: 'En ayunas',
    foto: 'caja_1.jpg',
  );
  final amoxicilina = Medicamento(
    id: 7,
    nombre: 'Amoxicilina',
    numTomas: 3,
    frecuenciaHoras: 8,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 20),
    fechaFin: DateTime(2026, 11, 1),
  );
  final cita = Cita(
    id: 2,
    titulo: 'Médico de cabecera',
    fecha: DateTime(2026, 10, 27),
    hora: const HoraDelDia(10, 30),
    lugar: 'Centro de salud',
    notas: 'Llevar los análisis.',
  );
  final tomada = RegistroToma(
    medicamentoId: 3,
    nombreMedicamento: 'Omeprazol',
    fecha: DateTime(2026, 10, 24),
    hora: const HoraDelDia(9, 0),
    estado: EstadoToma.tomada,
    momento: DateTime(2026, 10, 24, 9, 5),
  );
  final aplazada = RegistroToma(
    medicamentoId: 7,
    nombreMedicamento: 'Amoxicilina',
    fecha: DateTime(2026, 10, 25),
    hora: const HoraDelDia(8, 0),
    estado: EstadoToma.aplazada,
    momento: DateTime(2026, 10, 25, 8, 1),
    recordarEn: DateTime(2026, 10, 25, 8, 11),
  );
  const ajustes = Ajustes(
    sonidoActivado: true,
    vibracionActivada: true,
    notificacionesActivadas: true,
    numeroEmergencia: '112',
    tamanoTexto: 30,
    tema: TemaApp.oscuro,
    leerEnVozAlta: true,
    familiarNombre: 'Mi hija Ana',
    familiarNumero: '600123456',
    recordarResumen: true,
    minutosRepeticion: 60,
    minutosAplazamiento: 15,
    avisosDiscretos: true,
  );

  CopiaDeSeguridad copiaCompleta() => CopiaDeSeguridad(
    creada: ahora,
    medicamentos: [omeprazol, amoxicilina],
    citas: [cita],
    tomas: [tomada, aplazada],
    ajustes: ajustes,
    fotos: {'caja_1.jpg': fotoOmeprazol},
  );

  Uint8List json(Map<String, Object?> datos) => utf8.encode(jsonEncode(datos));

  Map<String, Object?> jsonDe(CopiaDeSeguridad copia) =>
      jsonDecode(utf8.decode(copia.codificar())) as Map<String, Object?>;

  group('CopiaDeSeguridad', () {
    test('ida y vuelta con todos los datos y las fotos', () {
      final leida = CopiaDeSeguridad.decodificar(copiaCompleta().codificar());
      expect(leida.creada, ahora);
      expect(leida.medicamentos, [omeprazol, amoxicilina]);
      expect(leida.citas, [cita]);
      expect(leida.tomas, [tomada, aplazada]);
      expect(leida.ajustes, ajustes);
      expect(leida.fotos.keys, ['caja_1.jpg']);
      expect(leida.fotos['caja_1.jpg'], fotoOmeprazol);
    });

    // Metformina con el desayuno, la comida y la cena, cada 2 días; una
    // pastilla semanal de los lunes, y un calmante "cuando haga falta".
    final metformina = Medicamento(
      id: 10,
      nombre: 'Metformina',
      numTomas: 3,
      frecuenciaHoras: 8,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 20),
      horasLibres: const [
        HoraDelDia(8, 0),
        HoraDelDia(14, 0),
        HoraDelDia(21, 0),
      ],
      dias: CadaVariosDias(cada: 2, desde: DateTime(2026, 10, 26)),
    );
    final alendronato = Medicamento(
      id: 11,
      nombre: 'Alendronato',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 20),
      dias: const DiasDeLaSemana({DateTime.monday}),
    );
    final ibuprofeno = Medicamento(
      id: 12,
      nombre: 'Ibuprofeno',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 20),
      aDemanda: true,
      existencias: Existencias(
        cantidad: 18,
        contadas: DateTime(2026, 10, 22, 12, 15),
        porToma: 2,
      ),
      maximoAlDia: 3,
      horasEntreTomas: 8,
      renovarReceta: DateTime(2026, 12, 1),
    );
    CopiaDeSeguridad copiaConHorario() => CopiaDeSeguridad(
      creada: ahora,
      medicamentos: [metformina, alendronato, ibuprofeno],
      citas: const [],
      tomas: const [],
      ajustes: ajustes,
      fotos: const {},
    );

    test('ida y vuelta con horas elegidas, días de toma y "cuando haga '
        'falta"', () {
      final leidos = CopiaDeSeguridad.decodificar(copiaConHorario().codificar())
          .medicamentos;
      expect(leidos, [metformina, alendronato, ibuprofeno]);
      expect(leidos.map((m) => m.aDemanda), [false, false, true]);
      expect(leidos.last.existencias, ibuprofeno.existencias);
      expect(leidos.last.maximoAlDia, 3);
      expect(leidos.last.horasEntreTomas, 8);
      expect(leidos.last.renovarReceta, DateTime(2026, 12, 1));
    });

    test('ida y vuelta con medias pastillas y dosis distinta en cada toma', () {
      final enalapril = Medicamento(
        id: 13,
        nombre: 'Enalapril',
        numTomas: 2,
        frecuenciaHoras: 12,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 20),
        horasLibres: const [HoraDelDia(8, 0), HoraDelDia(21, 0)],
        dosisPorToma: const ['1 pastilla', 'media pastilla'],
        existencias: Existencias(
          cantidad: 27.5,
          contadas: DateTime(2026, 10, 22, 12, 15),
          porTomas: const [1, 0.5],
        ),
      );
      final copia = CopiaDeSeguridad(
        creada: ahora,
        medicamentos: [enalapril],
        citas: const [],
        tomas: const [],
        ajustes: ajustes,
      );
      expect(CopiaDeSeguridad.decodificar(copia.codificar()).medicamentos, [
        enalapril,
      ]);

      for (final (campo, valor) in [
        ('dosisPorToma', ['1 pastilla']),
        ('existencias', {'cantidad': 27.3, 'contadas': 0, 'porToma': 1}),
        (
          'existencias',
          {
            'cantidad': 27.5,
            'contadas': 0,
            'porToma': 1,
            'porTomas': [1, 0.5, 1],
          },
        ),
        (
          'existencias',
          {
            'cantidad': 27.5,
            'contadas': 0,
            'porToma': 1,
            'porTomas': [1, 0],
          },
        ),
      ]) {
        final datos = jsonDe(copia);
        final medicamentos = datos['medicamentos']! as List<Object?>;
        (medicamentos.single! as Map<String, Object?>)[campo] = valor;
        expect(
          () => CopiaDeSeguridad.decodificar(json(datos)),
          throwsA(isA<CopiaNoValida>()),
          reason: '$campo: $valor',
        );
      }
    });

    test('no admite horas o días de toma imposibles', () {
      for (final (campo, valor) in [
        ('horas', [480, 480, 1260]),
        ('horas', [480]),
        ('dias', 'semana:9'),
        ('dias', 'cada:1:2026-10-26'),
        ('dias', 'cuando:quiera'),
        ('existencias', {'cantidad': -1, 'contadas': 0, 'porToma': 1}),
        ('existencias', {'cantidad': 10, 'contadas': 0, 'porToma': 0}),
        ('existencias', {'cantidad': 10, 'porToma': 1}),
        ('renovarReceta', 'el mes que viene'),
        ('maximoAlDia', 0),
        ('maximoAlDia', 13),
        ('horasEntreTomas', 25),
      ]) {
        final datos = jsonDe(copiaConHorario());
        final medicamentos = datos['medicamentos']! as List<Object?>;
        (medicamentos.first! as Map<String, Object?>)[campo] = valor;
        expect(
          () => CopiaDeSeguridad.decodificar(json(datos)),
          throwsA(isA<CopiaNoValida>()),
          reason: '$campo: $valor',
        );
      }
    });

    test('resumen y nombre del fichero', () {
      final copia = copiaCompleta();
      expect(copia.resumen, '2 medicamentos, 1 cita y 2 tomas anotadas');
      expect(
        copia.nombreFichero,
        'Copia de Salud y Medicación 2026-10-25.json',
      );
    });

    test('una copia que no podría haber guardado la app se rechaza', () {
      final grande = Uint8List(CopiaDeSeguridad.tamanoMaximoFoto + 1)
        ..setAll(0, const [0xFF, 0xD8, 0xFF]);
      for (final (nombre, cambio)
          in <(String, void Function(Map<String, Object?>))>[
            (
              'emergencias con un código',
              (j) =>
                  (j['ajustes']! as Map<String, Object?>)['numeroEmergencia'] =
                      '**21*666#',
            ),
            (
              'familiar con letras',
              (j) => (j['ajustes']! as Map<String, Object?>)['familiarNumero'] =
                  'llámame',
            ),
            (
              'nombre del familiar larguísimo',
              (j) => (j['ajustes']! as Map<String, Object?>)['familiarNombre'] =
                  'x' * 41,
            ),
            (
              'nombre de medicamento larguísimo',
              (j) => _primero(j, 'medicamentos')['nombre'] = 'x' * 61,
            ),
            (
              'dosis larguísima',
              (j) => _primero(j, 'medicamentos')['dosis'] = 'x' * 41,
            ),
            (
              'instrucciones larguísimas',
              (j) => _primero(j, 'medicamentos')['instrucciones'] = 'x' * 101,
            ),
            ('cita sin motivo', (j) => _primero(j, 'citas')['titulo'] = ' '),
            (
              'notas larguísimas',
              (j) => _primero(j, 'citas')['notas'] = 'x' * 301,
            ),
            (
              'foto que no es una imagen',
              (j) => (j['fotos']! as Map<String, Object?>)['caja_1.jpg'] =
                  base64Encode(utf8.encode('#!/bin/sh')),
            ),
            (
              'foto enorme',
              (j) => (j['fotos']! as Map<String, Object?>)['caja_1.jpg'] =
                  base64Encode(grande),
            ),
            (
              'dos medicamentos con el mismo id',
              (j) => (j['medicamentos']! as List<Object?>).add(
                _primero(j, 'medicamentos'),
              ),
            ),
            (
              'la misma toma dos veces',
              (j) => (j['tomas']! as List<Object?>).add(_primero(j, 'tomas')),
            ),
          ]) {
        final datos = jsonDe(copiaCompleta());
        cambio(datos);
        expect(
          () => CopiaDeSeguridad.decodificar(json(datos)),
          throwsA(isA<CopiaNoValida>()),
          reason: nombre,
        );
      }
      // Sin número de emergencia ni familiar es una copia normal.
      final sinTelefonos = jsonDe(copiaCompleta());
      (sinTelefonos['ajustes']! as Map<String, Object?>)
        ..['numeroEmergencia'] = ''
        ..['familiarNombre'] = ''
        ..['familiarNumero'] = '';
      expect(
        CopiaDeSeguridad.decodificar(json(sinTelefonos))
            .ajustes
            .numeroEmergencia,
        '',
      );
    });

    test('las fotos pueden ser JPEG, PNG, WebP o HEIC', () {
      for (final cabecera in [
        const [0xFF, 0xD8, 0xFF, 0xE0],
        const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A],
        [...ascii.encode('RIFF'), 0, 0, 0, 0, ...ascii.encode('WEBP')],
        [0, 0, 0, 24, ...ascii.encode('ftypheic')],
      ]) {
        final datos = jsonDe(copiaCompleta());
        (datos['fotos']! as Map<String, Object?>)['caja_1.jpg'] = base64Encode([
          ...cabecera,
          1,
          2,
          3,
        ]);
        expect(
          CopiaDeSeguridad.decodificar(json(datos)).fotos['caja_1.jpg'],
          hasLength(cabecera.length + 3),
        );
      }
      // Un vídeo empieza igual que un HEIC, pero con otra marca.
      final video = jsonDe(copiaCompleta());
      (video['fotos']! as Map<String, Object?>)['caja_1.jpg'] = base64Encode([
        0,
        0,
        0,
        24,
        ...ascii.encode('ftypisom'),
      ]);
      expect(
        () => CopiaDeSeguridad.decodificar(json(video)),
        throwsA(isA<CopiaNoValida>()),
      );
    });

    test('un fichero demasiado grande se explica sin leerlo', () {
      expect(
        () => CopiaDeSeguridad.decodificar(
          Uint8List(CopiaDeSeguridad.tamanoMaximo + 1),
        ),
        throwsA(
          isA<CopiaNoValida>().having(
            (e) => e.mensaje,
            'mensaje',
            'Este fichero es demasiado grande para ser una copia de Salud y '
                'Medicación.',
          ),
        ),
      );
    });

    test('un fichero que no es una copia se explica', () {
      for (final datos in [
        Uint8List.fromList([0xFF, 0x00, 0x12]),
        utf8.encode('esto no es json'),
        json({'app': 'otra_app', 'formato': 1}),
        json({'app': 'salud_mayores', 'formato': 1}),
      ]) {
        expect(
          () => CopiaDeSeguridad.decodificar(datos),
          throwsA(
            isA<CopiaNoValida>().having(
              (e) => e.mensaje,
              'mensaje',
              CopiaDeSeguridad.mensajeNoEsCopia,
            ),
          ),
        );
      }
    });

    test('una copia de formato 1 (sin horas ni días) se sigue leyendo', () {
      final datos = jsonDe(copiaCompleta())..['formato'] = 1;
      for (final m in datos['medicamentos']! as List<Object?>) {
        (m! as Map<String, Object?>)
          ..remove('horas')
          ..remove('dias')
          ..remove('aDemanda')
          ..remove('existencias');
      }
      final copia = CopiaDeSeguridad.decodificar(json(datos));
      expect(copia.medicamentos, isNotEmpty);
      for (final m in copia.medicamentos) {
        expect(m.horasLibres, isNull);
        expect(m.dias, const TodosLosDias());
        expect(m.aDemanda, isFalse);
        expect(m.existencias, isNull);
      }
    });

    test('una copia de una versión más nueva pide actualizar', () {
      final datos = jsonDe(copiaCompleta())
        ..['formato'] = CopiaDeSeguridad.formato + 1;
      expect(
        () => CopiaDeSeguridad.decodificar(json(datos)),
        throwsA(
          isA<CopiaNoValida>().having(
            (e) => e.mensaje,
            'mensaje',
            CopiaDeSeguridad.mensajeVersionNueva,
          ),
        ),
      );
    });

    test('no admite nombres de foto que salgan de su carpeta', () {
      for (final nombre in ['../salud_mayores.db', 'a/b.jpg', '.oculta', '']) {
        final datos = jsonDe(copiaCompleta())
          ..['fotos'] = {
            nombre: base64Encode([1, 2, 3]),
          };
        expect(
          () => CopiaDeSeguridad.decodificar(json(datos)),
          throwsA(isA<CopiaNoValida>()),
          reason: nombre,
        );
      }
    });

    test('no admite medicamentos imposibles', () {
      final datos = jsonDe(copiaCompleta());
      final medicamentos = datos['medicamentos']! as List<Object?>;
      (medicamentos.first! as Map<String, Object?>)
        ..['numTomas'] = 5
        ..['frecuenciaHoras'] = 8;
      expect(
        () => CopiaDeSeguridad.decodificar(json(datos)),
        throwsA(isA<CopiaNoValida>()),
      );
    });

    test('una foto que no viene en la copia se descarta', () {
      final datos = jsonDe(copiaCompleta())..['fotos'] = <String, Object?>{};
      final leida = CopiaDeSeguridad.decodificar(json(datos));
      expect(leida.medicamentos.first.foto, isNull);
    });
  });

  group('ValidadorFamiliar', () {
    test('con los dos campos vacíos se borra el contacto', () {
      expect(
        ValidadorFamiliar.validar(nombre: ' ', numero: '').sinErrores,
        isTrue,
      );
    });

    test('si se rellena uno, hace falta el otro', () {
      expect(
        ValidadorFamiliar.validar(nombre: 'Ana', numero: '').numero,
        isNotNull,
      );
      expect(
        ValidadorFamiliar.validar(nombre: '', numero: '600123456').nombre,
        isNotNull,
      );
    });

    test('el número se valida como el de emergencia y el nombre tiene un '
        'límite', () {
      expect(
        ValidadorFamiliar.validar(nombre: 'Ana', numero: '12').numero,
        contains('demasiado corto'),
      );
      expect(
        ValidadorFamiliar.validar(nombre: 'A' * 41, numero: '600123456').nombre,
        contains('demasiado largo'),
      );
      expect(
        ValidadorFamiliar.validar(
          nombre: 'Mi hija Ana',
          numero: '600 12 34 56',
        ).sinErrores,
        isTrue,
      );
    });
  });

  group('InformePdf', () {
    bool esPdf(Uint8List datos) =>
        datos.length > 1000 && ascii.decode(datos.sublist(0, 5)) == '%PDF-';

    test('se genera aunque no haya datos', () async {
      final pdf = await InformePdf.generar(
        medicamentos: const [],
        citas: const [],
        registros: const [],
        ajustes: const Ajustes(),
        ahora: ahora,
        normal: fuentesPdfDePrueba.normal,
        negrita: fuentesPdfDePrueba.negrita,
      );
      expect(esPdf(pdf), isTrue);
    });

    test('la tabla cuenta las tomas anotadas que ya no corresponden a '
        'ninguna toma prevista, como el historial', () {
      // Omeprazol se tomaba a las 09:00; se borró y se volvió a apuntar a
      // las 20:00. Las tomas de antes siguen anotadas.
      RegistroToma antes(int dia) => RegistroToma(
        medicamentoId: 1,
        nombreMedicamento: 'Omeprazol',
        fecha: DateTime(2026, 10, dia),
        hora: const HoraDelDia(9, 0),
        estado: EstadoToma.tomada,
        momento: DateTime(2026, 10, dia, 9, 5),
      );
      final filas = InformePdf.filasTomas(
        medicamentos: [
          Medicamento(
            id: 2,
            nombre: 'Omeprazol',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: const HoraDelDia(20, 0),
            fechaCreacion: DateTime(2026, 10, 25),
          ),
        ],
        registros: [antes(24), antes(25)],
        ahora: ahora,
      );
      // Ayer solo hay la toma de antes: el día sale igualmente.
      expect(filas, [
        ['Hoy 25/10', '1 de 2 (1 por llegar)', '—'],
        ['sábado 24/10', '1 de 1', '—'],
      ]);
    });

    test('con medicamentos, tomas, citas, contactos y una foto que no se '
        'puede leer', () async {
      final pdf = await InformePdf.generar(
        medicamentos: [omeprazol, amoxicilina],
        citas: [cita],
        registros: [tomada, aplazada],
        ajustes: ajustes,
        ahora: ahora,
        normal: fuentesPdfDePrueba.normal,
        negrita: fuentesPdfDePrueba.negrita,
        // No es una imagen de verdad: el medicamento sale sin foto.
        fotos: {'caja_1.jpg': fotoOmeprazol},
        existencias: {
          omeprazol.id: const EstadoExistencias(
            quedan: 5,
            dias: 5,
            pocas: true,
          ),
        },
      );
      expect(esPdf(pdf), isTrue);
      expect(
        InformePdf.nombreFichero(ahora),
        'Medicación y citas 25-10-2026.pdf',
      );
    });

    test('con un medicamento "cuando haga falta" y lo que se tomó, con y sin '
        'otras tomas', () async {
      final calmante = Medicamento(
        id: 20,
        nombre: 'Ibuprofeno',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 1),
        dosis: '1 sobre',
        aDemanda: true,
      );
      final registros = [
        for (final (dia, hora) in [
          (25, const HoraDelDia(8, 10)),
          (25, const HoraDelDia(14, 30)),
          (23, const HoraDelDia(20, 0)),
        ])
          RegistroToma(
            medicamentoId: calmante.id,
            nombreMedicamento: calmante.nombre,
            fecha: DateTime(2026, 10, dia),
            hora: hora,
            estado: EstadoToma.tomada,
            momento: DateTime(2026, 10, dia, hora.hora, hora.minuto),
          ),
      ];
      for (final medicamentos in [
        [calmante],
        [omeprazol, calmante],
      ]) {
        final pdf = await InformePdf.generar(
          medicamentos: medicamentos,
          citas: const [],
          registros: registros,
          ajustes: ajustes,
          ahora: ahora,
          normal: fuentesPdfDePrueba.normal,
          negrita: fuentesPdfDePrueba.negrita,
        );
        expect(esPdf(pdf), isTrue);
      }
    });

    test(
      'con muchos medicamentos y citas se reparte en varias páginas',
      () async {
        final muchos = [
          for (var i = 1; i <= 12; i++)
            Medicamento(
              id: i,
              nombre: 'Medicamento con un nombre bastante largo $i',
              numTomas: 4,
              frecuenciaHoras: 6,
              horaInicio: const HoraDelDia(6, 0),
              fechaCreacion: DateTime(2026, 9, 1),
              dosis: '1 comprimido',
              instrucciones: 'Con un vaso de agua, después de comer',
            ),
        ];
        final pdf = await InformePdf.generar(
          medicamentos: muchos,
          citas: [
            for (var i = 1; i <= 15; i++)
              Cita(
                id: i,
                titulo: 'Revisión $i',
                fecha: DateTime(2026, 11, i),
                hora: const HoraDelDia(10, 0),
                lugar: 'Hospital',
                notas: 'Llevar la tarjeta sanitaria.',
              ),
          ],
          registros: const [],
          ajustes: ajustes,
          ahora: ahora,
          normal: fuentesPdfDePrueba.normal,
          negrita: fuentesPdfDePrueba.negrita,
        );
        expect(esPdf(pdf), isTrue);
        // Varias páginas: hay más de un objeto de página en el documento.
        expect(
          RegExp(r'/Type\s*/Page[^s]').allMatches(latin1.decode(pdf)).length,
          greaterThan(2),
        );
      },
    );

    test('con la foto de la caja', () async {
      Future<Uint8List> generar(Map<String, Uint8List> fotos) =>
          InformePdf.generar(
            medicamentos: [omeprazol],
            citas: const [],
            registros: const [],
            ajustes: const Ajustes(),
            ahora: ahora,
            normal: fuentesPdfDePrueba.normal,
            negrita: fuentesPdfDePrueba.negrita,
            fotos: fotos,
          );
      final sinFoto = await generar(const {});
      final conFoto = await generar({'caja_1.jpg': pngVacio});
      expect(esPdf(conFoto), isTrue);
      // La imagen va dentro del documento.
      expect(conFoto.length, greaterThan(sinFoto.length));
    });
  });

  group('ServicioCompartir', () {
    (EntornoDePrueba, ProviderContainer) crear({
      List<Medicamento> medicamentos = const [],
      List<Cita> citas = const [],
      List<RegistroToma> tomas = const [],
      Ajustes ajustes = const Ajustes(),
      Map<String, Uint8List> fotos = const {},
    }) {
      final entorno = EntornoDePrueba(
        medicamentos: medicamentos,
        citas: citas,
        tomas: tomas,
        ajustes: ajustes,
        fotos: AlmacenFotosEnMemoria(fotos),
        ahora: ahora,
      );
      final contenedor = ProviderContainer(overrides: entorno.overrides);
      addTearDown(contenedor.dispose);
      // Antes de liberar el contenedor, se espera a que terminen de
      // programarse los avisos.
      addTearDown(() => contenedor.read(sincronizadorAvisosProvider).esperar());
      return (entorno, contenedor);
    }

    test('la copia lleva todos los datos y las fotos', () async {
      final (_, contenedor) = crear(
        medicamentos: [omeprazol, amoxicilina],
        citas: [cita],
        tomas: [tomada, aplazada],
        ajustes: ajustes,
        fotos: {'caja_1.jpg': fotoOmeprazol, 'sin_uso.jpg': fotoOmeprazol},
      );
      final copia = await contenedor
          .read(servicioCompartirProvider)
          .crearCopia();
      expect(copia.medicamentos, unorderedEquals([omeprazol, amoxicilina]));
      expect(copia.citas, [cita]);
      expect(copia.tomas, unorderedEquals([tomada, aplazada]));
      expect(copia.ajustes, ajustes);
      // Solo las fotos de los medicamentos.
      expect(copia.fotos.keys, ['caja_1.jpg']);
    });

    test('guardar y enviar la copia usan un fichero JSON', () async {
      final (entorno, contenedor) = crear(medicamentos: [amoxicilina]);
      final servicio = contenedor.read(servicioCompartirProvider);
      expect(await servicio.guardarCopia(), isTrue);
      await servicio.enviarCopia();

      final guardado = entorno.archivos.guardados.single;
      expect(guardado.tipo, 'application/json');
      expect(guardado.nombre, endsWith('.json'));
      expect(CopiaDeSeguridad.decodificar(guardado.datos).medicamentos, [
        amoxicilina,
      ]);
      expect(entorno.archivos.compartidos.single.tipo, 'application/json');
      expect(entorno.archivos.asuntos.single, ServicioCompartir.asuntoCopia);

      entorno.archivos.aceptarGuardado = false;
      expect(await servicio.guardarCopia(), isFalse);
    });

    test('enviar e imprimir el informe usan un PDF', () async {
      final (entorno, contenedor) = crear(
        medicamentos: [omeprazol],
        citas: [cita],
        fotos: {'caja_1.jpg': fotoOmeprazol},
      );
      final servicio = contenedor.read(servicioCompartirProvider);
      await servicio.compartirInforme();
      await servicio.imprimirInforme();

      final enviado = entorno.archivos.compartidos.single;
      expect(enviado.tipo, 'application/pdf');
      expect(enviado.nombre, 'Medicación y citas 25-10-2026.pdf');
      expect(ascii.decode(enviado.datos.sublist(0, 5)), '%PDF-');
      expect(entorno.archivos.asuntos.single, InformePdf.titulo);
      expect(entorno.archivos.impresos, hasLength(1));
    });

    test('elegir una copia: cancelar o un fichero que no vale', () async {
      final (entorno, contenedor) = crear();
      final servicio = contenedor.read(servicioCompartirProvider);
      // Sin datos en el teléfono no hay nada que avisar que se borrará.
      expect(await servicio.resumenActual(), isNull);
      expect(await servicio.elegirCopia(), isNull);

      entorno.archivos.alAbrir = utf8.encode('{"hola": 1}');
      expect(servicio.elegirCopia, throwsA(isA<CopiaNoValida>()));

      entorno.archivos.alAbrir = copiaCompleta().codificar();
      expect((await servicio.elegirCopia())!.citas, [cita]);
    });

    test(
      'si recuperar falla al guardar, el teléfono se queda como estaba',
      () async {
        final viejo = Medicamento(
          id: 1,
          nombre: 'Aspirina',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: const HoraDelDia(14, 0),
          fechaCreacion: DateTime(2026, 9, 1),
        );
        final (entorno, contenedor) = crear(
          medicamentos: [viejo],
          ajustes: const Ajustes(numeroEmergencia: '061'),
        );
        entorno.restauracion.fallar = true;
        await expectLater(
          contenedor.read(servicioCompartirProvider).recuperar(copiaCompleta()),
          throwsA(isA<StateError>()),
        );
        expect(await entorno.medicamentos.obtenerTodos(), [viejo]);
        expect(entorno.ajustes.ajustes.numeroEmergencia, '061');
      },
    );

    test('recuperar sustituye los datos, escribe las fotos y conserva si los '
        'avisos están activados en este teléfono', () async {
      final viejo = Medicamento(
        id: 1,
        nombre: 'Aspirina',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(14, 0),
        fechaCreacion: DateTime(2026, 9, 1),
      );
      final (entorno, contenedor) = crear(
        medicamentos: [viejo],
        citas: [
          Cita(
            id: 9,
            titulo: 'Dentista',
            fecha: DateTime(2026, 11, 5),
            hora: const HoraDelDia(17, 0),
          ),
        ],
        tomas: [
          RegistroToma(
            medicamentoId: 1,
            nombreMedicamento: 'Aspirina',
            fecha: DateTime(2026, 10, 24),
            hora: const HoraDelDia(14, 0),
            estado: EstadoToma.tomada,
            momento: DateTime(2026, 10, 24, 14),
          ),
        ],
      );
      final servicio = contenedor.read(servicioCompartirProvider);
      expect(await servicio.resumenActual(), '1 medicamento y 1 cita');

      await servicio.recuperar(copiaCompleta());
      await contenedor.read(sincronizadorAvisosProvider).esperar();

      expect(
        await entorno.medicamentos.obtenerTodos(),
        unorderedEquals([omeprazol, amoxicilina]),
      );
      expect(await entorno.citas.obtenerTodas(), [cita]);
      expect(entorno.tomas.registros, unorderedEquals([tomada, aplazada]));
      expect(entorno.fotos.fotos['caja_1.jpg'], fotoOmeprazol);
      // Todo lo de la copia salvo los avisos, que dependen del permiso de
      // este teléfono (aquí estaban desactivados).
      expect(
        entorno.ajustes.ajustes,
        ajustes.copyWith(notificacionesActivadas: false),
      );
      expect(await servicio.resumenActual(), '2 medicamentos y 1 cita');
    });

    test('añadir lo de otro móvil: no borra nada, pone como en la copia los '
        'que ya había y guarda las fotos con otro nombre', () async {
      // En este teléfono, "omeprazol" a otra hora, con una foto que se llama
      // igual que la de la copia, y una aspirina que la copia no trae.
      final fotoDeAqui = Uint8List.fromList([1, 2, 3]);
      final omeprazolDeAqui = Medicamento(
        id: 1,
        nombre: 'omeprazol ',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(21, 0),
        fechaCreacion: DateTime(2026, 9, 1),
        foto: 'caja_1.jpg',
        existencias: Existencias(cantidad: 10, contadas: DateTime(2026, 10, 1)),
      );
      final aspirina = Medicamento(
        id: 2,
        nombre: 'Aspirina',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(14, 0),
        fechaCreacion: DateTime(2026, 9, 1),
      );
      final tomaDeAqui = RegistroToma(
        medicamentoId: 1,
        nombreMedicamento: 'Omeprazol',
        fecha: DateTime(2026, 10, 24),
        hora: const HoraDelDia(21, 0),
        estado: EstadoToma.tomada,
        momento: DateTime(2026, 10, 24, 21, 5),
      );
      final (entorno, contenedor) = crear(
        medicamentos: [omeprazolDeAqui, aspirina],
        citas: [cita],
        tomas: [tomaDeAqui],
        fotos: {'caja_1.jpg': fotoDeAqui},
      );
      final servicio = contenedor.read(servicioCompartirProvider);
      // La copia trae además una cita que ya ha pasado.
      final copia = CopiaDeSeguridad(
        creada: ahora,
        medicamentos: [omeprazol, amoxicilina],
        citas: [
          cita,
          Cita(
            id: 5,
            titulo: 'Análisis',
            fecha: DateTime(2026, 10, 1),
            hora: const HoraDelDia(8, 0),
          ),
          Cita(
            id: 6,
            titulo: 'Oculista',
            fecha: DateTime(2026, 11, 10),
            hora: const HoraDelDia(9, 30),
          ),
        ],
        tomas: [tomada, aplazada],
        ajustes: ajustes,
        fotos: {'caja_1.jpg': fotoOmeprazol},
      );

      final importacion = await servicio.prepararImportacion(copia);
      expect(importacion.nuevos, [amoxicilina]);
      expect(importacion.actualizados.single.actual, omeprazolDeAqui);
      expect(importacion.citas.map((c) => c.titulo), ['Oculista']);
      expect(importacion.describir(), [
        'Se añadirán: Amoxicilina.',
        'Ya tenías omeprazol : se pondrá como en la copia, sin perder las '
            'tomas anotadas.',
        'Citas nuevas: Oculista.',
      ]);

      await servicio.importar(importacion, copia);
      final medicamentos = await entorno.medicamentos.obtenerTodos();
      expect(medicamentos, hasLength(3));
      expect(medicamentos, contains(aspirina));
      final actualizado = medicamentos.firstWhere((m) => m.id == 1);
      expect(actualizado.nombre, 'Omeprazol');
      expect(actualizado.horaInicio, const HoraDelDia(9, 0));
      expect(actualizado.dosis, '1 pastilla');
      expect(actualizado.fechaCreacion, omeprazolDeAqui.fechaCreacion);
      // La copia no lleva la cuenta: se conserva la de aquí.
      expect(actualizado.existencias, omeprazolDeAqui.existencias);
      // La foto de la copia, con otro nombre; la de aquí sigue igual.
      expect(actualizado.foto, isNot('caja_1.jpg'));
      expect(entorno.fotos.fotos[actualizado.foto], fotoOmeprazol);
      expect(entorno.fotos.fotos['caja_1.jpg'], fotoDeAqui);
      final nuevo = medicamentos.firstWhere((m) => m.nombre == 'Amoxicilina');
      expect(nuevo.id, isNot(anyOf(1, 2)));
      expect(nuevo.fechaFin, amoxicilina.fechaFin);

      expect((await entorno.citas.obtenerTodas()).map((c) => c.titulo), [
        'Médico de cabecera',
        'Oculista',
      ]);
      // Las tomas y los ajustes de la copia no se usan.
      expect(entorno.tomas.registros, [tomaDeAqui]);
      expect(entorno.ajustes.ajustes, const Ajustes());
    });

    test('una copia sin medicamentos ni citas nuevas no añade nada', () async {
      final (_, contenedor) = crear(citas: [cita]);
      final importacion = await contenedor
          .read(servicioCompartirProvider)
          .prepararImportacion(
            CopiaDeSeguridad(
              creada: ahora,
              medicamentos: const [],
              citas: [cita],
              tomas: const [],
              ajustes: ajustes,
            ),
          );
      expect(importacion.vacia, isTrue);
    });
  });
}
