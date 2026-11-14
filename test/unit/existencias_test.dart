import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/existencias.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/medicamentos/domain/receta.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';

void main() {
  // Domingo, 25 de octubre de 2026, a las 9:00.
  final ahora = DateTime(2026, 10, 25, 9, 0);

  // Dos tomas al día (08:00 y 20:00), con 28 pastillas contadas el martes a
  // las 7:00.
  Medicamento medicamento({
    int id = 1,
    double cantidad = 28,
    DateTime? contadas,
    double porToma = 1,
    List<double>? porTomas,
    int numTomas = 2,
    DiasDeToma dias = const TodosLosDias(),
    DateTime? fechaFin,
    bool aDemanda = false,
  }) => Medicamento(
    id: id,
    nombre: 'Metformina',
    numTomas: numTomas,
    frecuenciaHoras: 24 ~/ numTomas,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
    dias: dias,
    fechaFin: fechaFin,
    aDemanda: aDemanda,
    existencias: Existencias(
      cantidad: cantidad,
      contadas: contadas ?? DateTime(2026, 10, 20, 7, 0),
      porToma: porToma,
      porTomas: porTomas,
    ),
  );

  RegistroToma tomada(int dia, HoraDelDia hora, DateTime momento) =>
      RegistroToma(
        medicamentoId: 1,
        nombreMedicamento: 'Metformina',
        fecha: DateTime(2026, 10, dia),
        hora: hora,
        estado: EstadoToma.tomada,
        momento: momento,
      );

  EstadoExistencias estado(
    Medicamento m, [
    List<RegistroToma> registros = const [],
    DateTime? cuando,
  ]) => CalculoExistencias.estado(m, registros, cuando ?? ahora)!;

  group('pastillas que quedan', () {
    test('cada toma se descuenta al llegar su hora, aunque no se marque', () {
      // Del martes al sábado, 10 tomas; hoy, la de las 08:00.
      final e = estado(medicamento());
      expect(e.quedan, 17);
      // Las 16 siguientes llegan hasta el lunes 2 de noviembre por la noche.
      expect(e.dias, 9);
      expect(e.pocas, isFalse);
      expect(e.describir(), 'Quedan 17 pastillas, para unos 9 días');
    });

    test('marcar una toma antes de su hora la descuenta ya, una sola vez', () {
      final m = medicamento();
      final antes = tomada(25, const HoraDelDia(20, 0), ahora);
      expect(estado(m, [antes]).quedan, 16);
      // A las 21:00 sigue contando una vez.
      expect(estado(m, [antes], DateTime(2026, 10, 25, 21)).quedan, 16);
      // Marcar tarde no cambia nada.
      final tarde = tomada(25, const HoraDelDia(8, 0), ahora);
      expect(estado(m, [tarde]).quedan, 17);
    });

    test('las tomas de antes de contarlas no cuentan, ni las de otros '
        'medicamentos', () {
      final m = medicamento(contadas: DateTime(2026, 10, 25, 8, 30));
      final otro = RegistroToma(
        medicamentoId: 2,
        nombreMedicamento: 'Otro',
        fecha: DateTime(2026, 10, 25),
        hora: const HoraDelDia(20, 0),
        estado: EstadoToma.tomada,
        momento: ahora,
      );
      expect(estado(m, [otro]).quedan, 28);
    });

    test('nunca menos de cero, y varias pastillas en cada toma', () {
      expect(estado(medicamento(cantidad: 5)).quedan, 0);
      expect(
        estado(medicamento(cantidad: 5)).describir(),
        'No quedan pastillas',
      );
      // 2 por toma: 11 tomas son 22 pastillas.
      expect(estado(medicamento(cantidad: 30, porToma: 2)).quedan, 8);
    });

    test('algunos días de la semana: solo esos días', () {
      // Los lunes, una toma: 3 pastillas contadas hoy llegan para tres lunes.
      final semanal = medicamento(
        cantidad: 3,
        contadas: ahora,
        numTomas: 1,
        dias: const DiasDeLaSemana({DateTime.monday}),
      );
      final e = estado(semanal);
      expect(e.quedan, 3);
      // Del lunes 26 al cuarto lunes, 16 de noviembre, que ya no hay.
      expect(e.dias, 21);
      expect(e.pocas, isFalse);
      expect(estado(semanal, const [], DateTime(2026, 11, 9, 9)).pocas, isTrue);
    });

    test('si llegan hasta el final del tratamiento, no son pocas', () {
      final antibiotico = medicamento(
        cantidad: 6,
        contadas: ahora,
        fechaFin: DateTime(2026, 10, 27),
      );
      final e = estado(antibiotico);
      expect(e.hastaElFinal, isTrue);
      expect(e.pocas, isFalse);
      expect(
        e.describir(),
        'Quedan 6 pastillas, suficientes hasta el final del tratamiento',
      );
      expect(
        CalculoExistencias.momentoDelAviso(antibiotico, [], ahora),
        isNull,
      );
    });

    test('pocas: no llegan para una semana', () {
      // 14 pastillas desde hoy a las 9:00: llegan hasta el sábado 31 por la
      // noche (7 días); con 13, no.
      final justas = medicamento(cantidad: 14, contadas: ahora);
      expect(estado(justas).pocas, isFalse);
      final pocas = medicamento(cantidad: 13, contadas: ahora);
      expect(estado(pocas).pocas, isTrue);
      // La última llega para la toma de esta noche.
      expect(
        estado(medicamento(cantidad: 1, contadas: ahora)).describir(),
        'Queda 1 pastilla, para 1 día',
      );
    });

    test(
      '"cuando haga falta": se descuenta lo anotado; pocas con 5 o menos',
      () {
        final calmante = medicamento(cantidad: 7, aDemanda: true);
        final registros = [
          tomada(21, const HoraDelDia(10, 0), DateTime(2026, 10, 21, 10)),
          tomada(24, const HoraDelDia(19, 30), DateTime(2026, 10, 24, 19, 30)),
          // Antes de contarlas.
          tomada(19, const HoraDelDia(12, 0), DateTime(2026, 10, 19, 12)),
        ];
        final e = estado(calmante, registros);
        expect(e.quedan, 5);
        expect(e.dias, isNull);
        expect(e.pocas, isTrue);
        expect(e.describir(), 'Quedan 5 pastillas');
        expect(estado(calmante).pocas, isFalse);
      },
    );

    test('desde qué día hacen falta los registros', () {
      expect(CalculoExistencias.registrosDesde([]), isNull);
      expect(
        CalculoExistencias.registrosDesde([
          medicamento(contadas: DateTime(2026, 10, 22, 18)),
          medicamento(id: 2, contadas: DateTime(2026, 10, 20, 7)),
          Medicamento(
            id: 3,
            nombre: 'Sin cuenta',
            numTomas: 1,
            frecuenciaHoras: 24,
            horaInicio: const HoraDelDia(8, 0),
            fechaCreacion: DateTime(2026, 1, 1),
          ),
        ]),
        DateTime(2026, 10, 20),
      );
    });
  });

  group('aviso de que quedan pocas', () {
    test('a las 10:00 del día en que dejan de llegar para una semana', () {
      // Las 17 que quedan no llegan al martes 3 de noviembre a las 08:00: el
      // aviso, una semana antes.
      expect(
        CalculoExistencias.momentoDelAviso(medicamento(), [], ahora),
        DateTime(2026, 10, 27, 10, 0),
      );
    });

    test('si ya quedan pocas, la próxima vez que lleguen las 10:00', () {
      final pocas = medicamento(cantidad: 13);
      expect(
        CalculoExistencias.momentoDelAviso(pocas, [], ahora),
        DateTime(2026, 10, 25, 10, 0),
      );
      expect(
        CalculoExistencias.momentoDelAviso(
          pocas,
          [],
          DateTime(2026, 10, 25, 11),
        ),
        DateTime(2026, 10, 26, 10, 0),
      );
    });

    test('el planificador lo programa sin botones de toma y lo explica', () {
      List<AvisoProgramado> avisos(List<Medicamento> medicamentos) =>
          PlanificadorAvisos.planificar(
            medicamentos: medicamentos,
            citas: const [],
            ajustes: const Ajustes(notificacionesActivadas: true),
            ahora: ahora,
          ).where((a) => a.tipo == TipoAviso.existencias).toList();

      final aviso = avisos([medicamento()]).single;
      expect(aviso.id, PlanificadorAvisos.idExistencias(1));
      expect(aviso.momento, UnaVez(DateTime(2026, 10, 27, 10, 0)));
      expect(aviso.conBotonesDeToma, isFalse);
      expect(aviso.titulo, 'Te quedan pocas pastillas');
      expect(
        aviso.cuerpo,
        'Metformina: no llegan para una semana. Cuando compres más, pulsa '
        '"He comprado más" en tus medicamentos.',
      );
      expect(CargaAviso.decodificar(aviso.carga), const CargaExistencias(1));

      expect(
        avisos([medicamento(cantidad: 5)]).single.cuerpo,
        startsWith('Metformina: ya no quedan.'),
      );
      // "Cuando haga falta" también avisa, aunque no tenga avisos de tomas.
      expect(
        avisos([medicamento(cantidad: 3, contadas: ahora, aDemanda: true)])
            .single
            .cuerpo,
        startsWith('Metformina: quedan 3.'),
      );
      // Sin cuenta, terminado o con avisos desactivados, nada.
      expect(avisos([medicamento(fechaFin: DateTime(2026, 10, 24))]), isEmpty);
      expect(
        PlanificadorAvisos.planificar(
          medicamentos: [medicamento()],
          citas: const [],
          ajustes: const Ajustes(),
          ahora: ahora,
        ),
        isEmpty,
      );
    });
  });

  group('medias pastillas y pastillas distintas en cada toma', () {
    test('se leen, se escriben y se describen', () {
      expect(Existencias.leer('14'), 14);
      expect(Existencias.leer(' 14,5 '), 14.5);
      expect(Existencias.leer('14.5'), 14.5);
      expect(Existencias.leer('14,0'), 14);
      for (final mal in ['', '14,3', '14,55', '-1', 'catorce', '12345']) {
        expect(Existencias.leer(mal), isNull, reason: mal);
      }
      expect(Existencias.numero(14), '14');
      expect(Existencias.numero(14.5), '14,5');
      expect(Existencias.corto(0.5), 'media');
      expect(Existencias.corto(1.5), '1 y media');
      expect(Existencias.corto(2), '2');
      expect(Existencias.describir(0.5), 'media pastilla');
      expect(Existencias.describir(1), '1 pastilla');
      expect(Existencias.describir(14.5), '14 pastillas y media');
      expect(Existencias.esValida(14.5), isTrue);
      expect(Existencias.esValida(14.25), isFalse);
      expect(Existencias.esValida(10000), isFalse);
    });

    test('media en cada toma: quedan con media', () {
      // 28 desde el martes a las 7:00, media a las 08:00 y a las 20:00: hasta
      // el domingo a las 9:00 se han tomado 11 medias.
      final estado = CalculoExistencias.estado(
        medicamento(porToma: 0.5),
        const [],
        ahora,
      )!;
      expect(estado.quedan, 22.5);
      expect(
        estado.describir(),
        'Quedan 22 pastillas y media, para unos 23 días',
      );
    });

    test('una por la mañana y media por la noche', () {
      final m = medicamento(porTomas: [1, 0.5]);
      expect(m.existencias!.enLaToma(0), 1);
      expect(m.existencias!.enLaToma(1), 0.5);
      expect(m.existencias!.menorPorToma, 0.5);
      // Martes a sábado, 1,5 al día; el domingo, la de las 08:00.
      final estado = CalculoExistencias.estado(m, const [], ahora)!;
      expect(estado.quedan, 28 - 5 * 1.5 - 1);
      // Con media que no llega para la de las 08:00 de mañana, pero sí para
      // la de las 20:00 de hoy, ya no quedan para ningún día.
      final casiNada = CalculoExistencias.estado(
        medicamento(
          cantidad: 0.5,
          contadas: DateTime(2026, 10, 25, 8, 30),
          porTomas: [1, 0.5],
        ),
        const [],
        ahora,
      )!;
      expect(casiNada.quedan, 0.5);
      expect(casiNada.pocas, isTrue);
      expect(casiNada.describir(), 'Queda media pastilla, para 1 día');
    });
  });

  group('Receta', () {
    Medicamento conReceta(DateTime? receta, {DateTime? fechaFin}) =>
        Medicamento(
          id: 5,
          nombre: 'Omeprazol',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: const HoraDelDia(9, 0),
          fechaCreacion: DateTime(2026, 10, 1),
          fechaFin: fechaFin,
          renovarReceta: receta,
        );

    test('solo cuenta si tiene fecha y el tratamiento sigue después', () {
      expect(Receta.cuenta(conReceta(null), ahora), isFalse);
      expect(Receta.cuenta(conReceta(DateTime(2026, 11, 20)), ahora), isTrue);
      // El tratamiento termina antes o el mismo día: no hace falta.
      expect(
        Receta.cuenta(
          conReceta(DateTime(2026, 11, 20), fechaFin: DateTime(2026, 11, 20)),
          ahora,
        ),
        isFalse,
      );
      expect(
        Receta.cuenta(
          conReceta(DateTime(2026, 11, 20), fechaFin: DateTime(2026, 12, 1)),
          ahora,
        ),
        isTrue,
      );
      // Terminado: nada.
      expect(
        Receta.cuenta(
          conReceta(DateTime(2026, 10, 20), fechaFin: DateTime(2026, 10, 24)),
          ahora,
        ),
        isFalse,
      );
    });

    test('hay que renovarla desde una semana antes', () {
      expect(
        Receta.hayQueRenovar(conReceta(DateTime(2026, 11, 2)), ahora),
        isFalse,
      );
      expect(
        Receta.hayQueRenovar(conReceta(DateTime(2026, 11, 1)), ahora),
        isTrue,
      );
      expect(Receta.diasQuedan(conReceta(DateTime(2026, 11, 1)), ahora), 7);
      expect(
        Receta.hayQueRenovar(conReceta(DateTime(2026, 10, 20)), ahora),
        isTrue,
      );
    });

    test('avisa a las 10:00 una semana antes o, si ya toca, la próxima vez '
        'que lleguen las 10:00', () {
      expect(
        Receta.momentoDelAviso(conReceta(DateTime(2026, 11, 20)), ahora),
        DateTime(2026, 11, 13, 10, 0),
      );
      expect(
        Receta.momentoDelAviso(conReceta(DateTime(2026, 10, 28)), ahora),
        DateTime(2026, 10, 25, 10, 0),
      );
      expect(
        Receta.momentoDelAviso(
          conReceta(DateTime(2026, 10, 28)),
          DateTime(2026, 10, 25, 12, 0),
        ),
        DateTime(2026, 10, 26, 10, 0),
      );
      expect(Receta.momentoDelAviso(conReceta(null), ahora), isNull);
    });

    test('lo que dicen la tarjeta y el aviso', () {
      expect(
        Receta.describir(conReceta(DateTime(2026, 11, 20)), ahora),
        'Receta: hasta el viernes, 20 de noviembre de 2026',
      );
      expect(
        Receta.describir(conReceta(DateTime(2026, 10, 28)), ahora),
        'La receta se acaba dentro de 3 días: pide cita con tu médico para '
        'renovarla',
      );
      expect(
        Receta.describir(conReceta(DateTime(2026, 10, 26)), ahora),
        'La receta se acaba mañana: pide cita con tu médico para renovarla',
      );
      expect(
        Receta.describir(conReceta(DateTime(2026, 10, 20)), ahora),
        'La receta se acabó el martes, 20 de octubre de 2026: pide cita con '
        'tu médico para renovarla',
      );

      final aviso = PlanificadorAvisos.planificar(
        medicamentos: [conReceta(DateTime(2026, 11, 20))],
        citas: const [],
        ajustes: const Ajustes(notificacionesActivadas: true),
        ahora: ahora,
      ).singleWhere((a) => a.tipo == TipoAviso.receta);
      expect(aviso.id, PlanificadorAvisos.idReceta(5));
      expect(aviso.titulo, 'Renueva la receta');
      expect(
        aviso.cuerpo,
        'La receta de Omeprazol se acaba el viernes, 20 de noviembre de 2026. '
        'Pide cita con tu médico para renovarla.',
      );
      expect(aviso.conBotonesDeToma, isFalse);
      expect(CargaAviso.decodificar(aviso.carga), const CargaReceta(5));
      expect(
        Receta.cuerpoDelAviso(
          conReceta(DateTime(2026, 10, 25)),
          DateTime(2026, 10, 25, 10),
        ),
        'La receta de Omeprazol se acaba hoy. Pide cita con tu médico para '
        'renovarla.',
      );
      expect(
        Receta.cuerpoDelAviso(
          conReceta(DateTime(2026, 10, 20)),
          DateTime(2026, 10, 25, 10),
        ),
        startsWith('La receta de Omeprazol se acabó el martes, 20 de octubre'),
      );
    });

    test('los identificadores no chocan con los de existencias ni con los '
        'aplazados', () {
      expect(
        PlanificadorAvisos.idReceta(0),
        greaterThan(PlanificadorAvisos.idExistencias(2100000)),
      );
      expect(
        PlanificadorAvisos.idReceta(2100000),
        lessThan(PlanificadorAvisos.idAplazado(0, 0)),
      );
    });
  });
}
