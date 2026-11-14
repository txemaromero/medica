import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/medicamentos/domain/validador_medicamento.dart';

void main() {
  // El domingo 25 de octubre de 2026; el lunes es el 26.
  final domingo = DateTime(2026, 10, 25);
  DateTime dia(int d) => DateTime(2026, 10, d);
  const lunesYJueves = DiasDeLaSemana({DateTime.monday, DateTime.thursday});
  final cadaDos = CadaVariosDias(cada: 2, desde: dia(26));

  group('DiasDeToma', () {
    test('qué días incluye cada uno', () {
      expect(const TodosLosDias().incluye(domingo), isTrue);
      expect(
        [for (var d = 25; d <= 31; d++) lunesYJueves.incluye(dia(d))],
        [false, true, false, false, true, false, false],
      );
      // Cada 2 días desde el lunes 26: el 26, el 28 y el 30; antes, ninguno.
      expect(
        [for (var d = 24; d <= 30; d++) cadaDos.incluye(dia(d))],
        [false, false, true, false, true, false, true],
      );
    });

    test('cada varios días cuenta bien al cambiar la hora (octubre)', () {
      // En España, la hora cambia la madrugada del 25 de octubre de 2026.
      final desdeElSabado = CadaVariosDias(cada: 7, desde: dia(24));
      expect(desdeElSabado.incluye(dia(31)), isTrue);
    });

    test('se guardan como texto y se leen igual', () {
      for (final dias in [const TodosLosDias(), lunesYJueves, cadaDos]) {
        expect(DiasDeToma.decodificar(dias.codificar()), dias);
      }
      expect(lunesYJueves.codificar(), 'semana:1,4');
      expect(cadaDos.codificar(), 'cada:2:2026-10-26');
      expect(const TodosLosDias().codificar(), isNull);
    });

    test('un texto que no es válido se rechaza', () {
      for (final texto in [
        'semana:',
        'semana:0',
        'semana:8',
        'cada:1:2026-10-26',
        'cada:31:2026-10-26',
        'cada:2',
        'cuando:quiera',
      ]) {
        expect(
          () => DiasDeToma.decodificar(texto),
          throwsA(anything),
          reason: texto,
        );
      }
    });

    test('se describen con palabras', () {
      expect(const TodosLosDias().describir(), isNull);
      expect(lunesYJueves.describir(), 'los lunes y jueves');
      expect(
        const DiasDeLaSemana({
          DateTime.sunday,
          DateTime.saturday,
          DateTime.wednesday,
        }).describir(),
        'los miércoles, sábados y domingos',
      );
      expect(
        cadaDos.describir(),
        'cada 2 días, empezando el lunes, 26 de octubre',
      );
    });
  });

  group('Medicamento con horas concretas y días de toma', () {
    final metformina = Medicamento(
      id: 1,
      nombre: 'Metformina',
      numTomas: 3,
      frecuenciaHoras: 8,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      horasLibres: const [
        HoraDelDia(8, 0),
        HoraDelDia(14, 0),
        HoraDelDia(21, 0),
      ],
      dias: lunesYJueves,
      fechaFin: dia(29),
    );

    test('las horas son las elegidas y se describen sin frecuencia', () {
      expect(metformina.horasDeToma, const [
        HoraDelDia(8, 0),
        HoraDelDia(14, 0),
        HoraDelDia(21, 0),
      ]);
      expect(metformina.descripcionTomas, '3 tomas al día');
    });

    test('desde los datos del formulario, las horas quedan ordenadas', () {
      final m = Medicamento.desdeDatos(
        id: 1,
        fechaCreacion: DateTime(2026, 10, 1),
        datos: const NuevoMedicamento(
          nombre: 'Metformina',
          numTomas: 3,
          frecuenciaHoras: 8,
          horaInicio: HoraDelDia(8, 0),
          horasLibres: [HoraDelDia(21, 0), HoraDelDia(8, 0), HoraDelDia(14, 0)],
        ),
      );
      expect(m.horasLibres, const [
        HoraDelDia(8, 0),
        HoraDelDia(14, 0),
        HoraDelDia(21, 0),
      ]);
    });

    test('solo se toma los días elegidos y hasta el último día', () {
      expect(
        [for (var d = 25; d <= 31; d++) metformina.seTomaEl(dia(d))],
        // Lunes 26 y jueves 29 (el último día); el lunes 2 ya no.
        [false, true, false, false, true, false, false],
      );
      expect(metformina.seTomaEl(DateTime(2026, 11, 2)), isFalse);
      expect(metformina.terminadoEl(dia(30)), isTrue);
    });
  });

  group('ValidadorMedicamento', () {
    ErroresMedicamento validar({
      List<HoraDelDia>? horasLibres,
      DiasDeToma dias = const TodosLosDias(),
    }) => ValidadorMedicamento.validar(
      nombre: 'Metformina',
      numTomas: horasLibres?.length ?? 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      ahora: domingo,
      horasLibres: horasLibres,
      dias: dias,
    );

    test('horas concretas distintas y días bien elegidos no dan error', () {
      final errores = validar(
        horasLibres: const [HoraDelDia(8, 0), HoraDelDia(21, 0)],
        dias: lunesYJueves,
      );
      expect(errores.sinErrores, isTrue);
    });

    test('dos tomas a la misma hora', () {
      final errores = validar(
        horasLibres: const [HoraDelDia(8, 0), HoraDelDia(8, 0)],
      );
      expect(
        errores.horas,
        'Hay dos tomas a la misma hora. Cambia una de ellas.',
      );
    });

    test('ningún día de la semana elegido', () {
      expect(
        validar(dias: const DiasDeLaSemana({})).dias,
        'Elige al menos un día de la semana.',
      );
    });

    test('cada cuántos días, fuera de lo permitido', () {
      expect(
        validar(dias: CadaVariosDias(cada: 1, desde: domingo)).dias,
        'Elige cada cuántos días lo tomas: entre 2 y 30.',
      );
    });
  });
}
