import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/medicamentos/domain/horario_tomas.dart';

void main() {
  group('HorarioTomas.calcular', () {
    test('1 toma al día: solo la hora de inicio', () {
      expect(
        HorarioTomas.calcular(
          horaInicio: const HoraDelDia(9, 30),
          numTomas: 1,
          frecuenciaHoras: 24,
        ),
        [const HoraDelDia(9, 30)],
      );
    });

    test('3 tomas cada 8 horas desde las 08:00', () {
      expect(
        HorarioTomas.calcular(
          horaInicio: const HoraDelDia(8, 0),
          numTomas: 3,
          frecuenciaHoras: 8,
        ),
        const [HoraDelDia(8, 0), HoraDelDia(16, 0), HoraDelDia(0, 0)],
      );
    });

    test('conserva los minutos y da la vuelta a medianoche', () {
      expect(
        HorarioTomas.calcular(
          horaInicio: const HoraDelDia(22, 15),
          numTomas: 2,
          frecuenciaHoras: 12,
        ),
        const [HoraDelDia(22, 15), HoraDelDia(10, 15)],
      );
    });

    test('las tomas no tienen por qué ocupar todo el día', () {
      // Por ejemplo, 3 tomas cada 4 horas durante el día.
      expect(
        HorarioTomas.calcular(
          horaInicio: const HoraDelDia(9, 0),
          numTomas: 3,
          frecuenciaHoras: 4,
        ).map((h) => h.texto),
        ['09:00', '13:00', '17:00'],
      );
    });

    test('12 tomas cada 2 horas', () {
      final horas = HorarioTomas.calcular(
        horaInicio: const HoraDelDia(0, 0),
        numTomas: 12,
        frecuenciaHoras: 2,
      );
      expect(horas, hasLength(12));
      expect(horas.last, const HoraDelDia(22, 0));
    });

    test('rechaza combinaciones que no caben en un día', () {
      expect(
        () => HorarioTomas.calcular(
          horaInicio: const HoraDelDia(8, 0),
          numTomas: 3,
          frecuenciaHoras: 10,
        ),
        throwsArgumentError,
      );
      expect(
        () => HorarioTomas.calcular(
          horaInicio: const HoraDelDia(8, 0),
          numTomas: 0,
          frecuenciaHoras: 24,
        ),
        throwsArgumentError,
      );
    });
  });

  group('frecuencias', () {
    test('la frecuencia sugerida reparte las tomas por igual', () {
      expect(HorarioTomas.frecuenciaSugerida(1), 24);
      expect(HorarioTomas.frecuenciaSugerida(2), 12);
      expect(HorarioTomas.frecuenciaSugerida(3), 8);
      expect(HorarioTomas.frecuenciaSugerida(4), 6);
      expect(HorarioTomas.frecuenciaSugerida(5), 4);
    });

    test('validez de numTomas × frecuencia ≤ 24', () {
      expect(HorarioTomas.esFrecuenciaValida(3, 8), isTrue);
      expect(HorarioTomas.esFrecuenciaValida(3, 9), isFalse);
      expect(HorarioTomas.esFrecuenciaValida(1, 24), isTrue);
      expect(HorarioTomas.esFrecuenciaValida(1, 12), isFalse);
      expect(HorarioTomas.esFrecuenciaValida(2, 0), isFalse);
      expect(HorarioTomas.esFrecuenciaValida(13, 1), isFalse);
    });

    test('descripción en castellano', () {
      expect(HorarioTomas.describir(1, 24), '1 toma al día');
      expect(HorarioTomas.describir(3, 8), '3 tomas al día, cada 8 horas');
    });
  });

  group('HoraDelDia', () {
    test('formato HH:MM y vuelta al reloj', () {
      expect(const HoraDelDia(8, 5).texto, '08:05');
      expect(HoraDelDia.desdeMinutos(24 * 60 + 30), const HoraDelDia(0, 30));
      expect(HoraDelDia.desdeMinutos(-30), const HoraDelDia(23, 30));
    });
  });
}
