import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/validador_cita.dart';
import 'package:salud_mayores/features/ajustes/domain/validador_telefono.dart';
import 'package:salud_mayores/features/emergencias/marcador_telefono.dart';
import 'package:salud_mayores/features/medicamentos/domain/validador_medicamento.dart';

void main() {
  group('ValidadorMedicamento', () {
    ErroresMedicamento validar({
      String nombre = 'Paracetamol',
      int? numTomas = 3,
      int? frecuencia = 8,
      HoraDelDia? hora = const HoraDelDia(8, 0),
    }) => ValidadorMedicamento.validar(
      nombre: nombre,
      numTomas: numTomas,
      frecuenciaHoras: frecuencia,
      horaInicio: hora,
      ahora: DateTime(2026, 10, 25, 9),
    );

    test('datos correctos no tienen errores', () {
      expect(validar().sinErrores, isTrue);
      expect(validar(numTomas: 1, frecuencia: 24).sinErrores, isTrue);
    });

    test('el nombre es obligatorio (también si solo hay espacios)', () {
      expect(validar(nombre: '').nombre, contains('Escribe el nombre'));
      expect(validar(nombre: '   ').nombre, isNotNull);
    });

    test('el nombre no puede ser demasiado largo', () {
      expect(validar(nombre: 'a' * 61).nombre, contains('demasiado largo'));
      expect(validar(nombre: 'a' * 60).nombre, isNull);
    });

    test('número de tomas entre 1 y 12', () {
      expect(validar(numTomas: 0).numTomas, isNotNull);
      expect(validar(numTomas: 13).numTomas, isNotNull);
      expect(validar(numTomas: null).numTomas, isNotNull);
    });

    test('la frecuencia debe caber en el día y explica el máximo', () {
      final errores = validar(numTomas: 3, frecuencia: 10);
      expect(errores.frecuencia, contains('8 horas o menos'));
      expect(errores.sinErrores, isFalse);
    });

    test('la hora de inicio es obligatoria', () {
      expect(validar(hora: null).horaInicio, isNotNull);
    });
  });

  group('ValidadorCita', () {
    final ahora = DateTime(2026, 10, 25, 9, 0);

    ErroresCita validar({
      String titulo = 'Médico de cabecera',
      DateTime? fecha,
      HoraDelDia? hora = const HoraDelDia(10, 30),
      String lugar = '',
      String notas = '',
      bool sinFecha = false,
    }) => ValidadorCita.validar(
      titulo: titulo,
      fecha: sinFecha ? null : (fecha ?? DateTime(2026, 10, 27)),
      hora: hora,
      lugar: lugar,
      notas: notas,
      ahora: ahora,
    );

    test('datos correctos no tienen errores', () {
      expect(validar().sinErrores, isTrue);
      // Hoy, más tarde que ahora.
      expect(validar(fecha: DateTime(2026, 10, 25)).sinErrores, isTrue);
    });

    test('título, fecha y hora son obligatorios', () {
      expect(validar(titulo: ' ').titulo, contains('motivo'));
      expect(validar(sinFecha: true).fecha, isNotNull);
      expect(validar(hora: null).hora, isNotNull);
    });

    test('no se puede crear una cita en el pasado', () {
      expect(
        validar(fecha: DateTime(2026, 10, 24)).fecha,
        contains('ya ha pasado'),
      );
      expect(
        validar(
          fecha: DateTime(2026, 10, 25),
          hora: const HoraDelDia(8, 0),
        ).hora,
        contains('ya ha pasado'),
      );
    });

    test('lugar y notas son opcionales pero con longitud máxima', () {
      expect(validar(lugar: 'Centro de salud').sinErrores, isTrue);
      expect(validar(lugar: 'x' * 101).lugar, isNotNull);
      expect(validar(notas: 'x' * 301).notas, isNotNull);
    });
  });

  group('ValidadorTelefono', () {
    test('acepta números de emergencia y completos', () {
      expect(ValidadorTelefono.validar('112'), isNull);
      expect(ValidadorTelefono.validar('600 123 456'), isNull);
      expect(ValidadorTelefono.validar('+34 600-123-456'), isNull);
    });

    test('rechaza vacío, letras, demasiado corto o largo', () {
      expect(ValidadorTelefono.validar(''), contains('Escribe un número'));
      expect(ValidadorTelefono.validar('11a'), contains('solo números'));
      expect(ValidadorTelefono.validar('12'), contains('corto'));
      expect(ValidadorTelefono.validar('1' * 16), contains('largo'));
      expect(ValidadorTelefono.validar('1+2'), isNotNull);
    });

    test('limpia espacios, guiones y paréntesis', () {
      expect(ValidadorTelefono.limpiar('(+34) 600-12.34 56'), '+34600123456');
    });

    test('el marcador solo abre números que admite Ajustes', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final abiertos = <Object?>[];
      const canal = MethodChannel('plugins.flutter.io/url_launcher');
      final mensajero =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      mensajero.setMockMethodCallHandler(canal, (llamada) async {
        abiertos.add((llamada.arguments as Map<Object?, Object?>)['url']);
        return true;
      });
      addTearDown(() => mensajero.setMockMethodCallHandler(canal, null));
      const marcador = MarcadorTelefonoSistema();

      expect(await marcador.abrirMarcador('**21*666#'), isFalse);
      expect(await marcador.abrirMarcador('112; borrar'), isFalse);
      expect(abiertos, isEmpty);
      expect(await marcador.abrirMarcador('600 123 456'), isTrue);
      expect(abiertos, ['tel:600123456']);
    });
  });
}
