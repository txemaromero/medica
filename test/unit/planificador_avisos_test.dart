import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/agenda/domain/recordatorios_cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/existencias.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/features/tomas/domain/tomas_del_dia.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';

void main() {
  final ahora = DateTime(2026, 10, 25, 9, 0);
  final ibuprofeno = Medicamento(
    id: 7,
    nombre: 'Ibuprofeno',
    numTomas: 3,
    frecuenciaHoras: 8,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
  );
  Cita cita(int id, DateTime fecha, HoraDelDia hora, {String? lugar}) => Cita(
    id: id,
    titulo: 'Médico de cabecera',
    fecha: fecha,
    hora: hora,
    lugar: lugar,
  );

  group('RecordatoriosCita', () {
    test('avisa la tarde antes, el mismo día por la mañana y una hora '
        'antes', () {
      final avisos = RecordatoriosCita.calcular(
        cita(1, DateTime(2026, 10, 27), const HoraDelDia(11, 30)),
        ahora: ahora,
      );
      expect(avisos, [
        AvisoCita(TipoAvisoCita.diaAntes, DateTime(2026, 10, 26, 18, 0)),
        AvisoCita(TipoAvisoCita.mismoDia, DateTime(2026, 10, 27, 8, 0)),
        AvisoCita(TipoAvisoCita.unaHoraAntes, DateTime(2026, 10, 27, 10, 30)),
      ]);
    });

    test('sin aviso de la mañana si coincide o va después del de 1 hora', () {
      final temprano = RecordatoriosCita.calcular(
        cita(1, DateTime(2026, 10, 27), const HoraDelDia(8, 30)),
        ahora: ahora,
      );
      expect(temprano.map((a) => a.tipo), [
        TipoAvisoCita.diaAntes,
        TipoAvisoCita.unaHoraAntes,
      ]);

      final justo = RecordatoriosCita.calcular(
        cita(1, DateTime(2026, 10, 27), const HoraDelDia(9, 0)),
        ahora: ahora,
      );
      expect(justo.map((a) => a.tipo), [
        TipoAvisoCita.diaAntes,
        TipoAvisoCita.unaHoraAntes,
      ]);
    });

    test('una cita a medianoche avisa la tarde antes y a las 23:00', () {
      expect(
        RecordatoriosCita.calcular(
          cita(1, DateTime(2026, 10, 27), const HoraDelDia(0, 0)),
          ahora: ahora,
        ),
        [
          AvisoCita(TipoAvisoCita.diaAntes, DateTime(2026, 10, 26, 18, 0)),
          AvisoCita(TipoAvisoCita.unaHoraAntes, DateTime(2026, 10, 26, 23, 0)),
        ],
      );
    });

    test('una cita para mañana guardada ya por la noche no avisa la tarde '
        'antes', () {
      expect(
        RecordatoriosCita.calcular(
          cita(1, DateTime(2026, 10, 26), const HoraDelDia(11, 0)),
          ahora: DateTime(2026, 10, 25, 20, 0),
        ).map((a) => a.tipo),
        [TipoAvisoCita.mismoDia, TipoAvisoCita.unaHoraAntes],
      );
    });

    test('no programa avisos que ya han pasado', () {
      // Cita hoy a las 9:30: ya pasó la mañana y falta menos de una hora.
      expect(
        RecordatoriosCita.calcular(
          cita(1, DateTime(2026, 10, 25), const HoraDelDia(9, 30)),
          ahora: ahora,
        ),
        isEmpty,
      );
      // Cita hoy a las 12:00: solo queda el aviso de una hora antes.
      expect(
        RecordatoriosCita.calcular(
          cita(1, DateTime(2026, 10, 25), const HoraDelDia(12, 0)),
          ahora: ahora,
        ).map((a) => a.tipo),
        [TipoAvisoCita.unaHoraAntes],
      );
    });
  });

  group('PlanificadorAvisos.planificar', () {
    test('sin notificaciones activadas no se programa nada', () {
      final avisos = PlanificadorAvisos.planificar(
        medicamentos: [ibuprofeno],
        citas: [cita(1, DateTime(2026, 10, 27), const HoraDelDia(11, 0))],
        ajustes: const Ajustes(),
        ahora: ahora,
      );
      expect(avisos, isEmpty);
    });

    test('un aviso diario por cada toma, con ids estables', () {
      final avisos = PlanificadorAvisos.planificar(
        medicamentos: [ibuprofeno],
        citas: const [],
        ajustes: const Ajustes(notificacionesActivadas: true),
        ahora: ahora,
      );
      final tomas = avisos.where((a) => a.tipo == TipoAviso.toma);
      expect(tomas.map((a) => a.id), [700, 701, 702]);
      expect(tomas.map((a) => a.momento), const [
        CadaDia(HoraDelDia(8, 0)),
        CadaDia(HoraDelDia(16, 0)),
        CadaDia(HoraDelDia(0, 0)),
      ]);
      expect(tomas.first.cuerpo, contains('Ibuprofeno'));
      expect(
        CargaAviso.decodificar(tomas.first.carga),
        const CargaToma(medicamentoId: 7, hora: HoraDelDia(8, 0)),
      );
    });

    test('cada toma se repite 30 minutos después, con avisos únicos día a '
        'día durante 14 días', () {
      final avisos = PlanificadorAvisos.planificar(
        medicamentos: [ibuprofeno],
        citas: const [],
        ajustes: const Ajustes(notificacionesActivadas: true),
        ahora: ahora,
      );
      final repeticiones = avisos
          .where((a) => a.tipo == TipoAviso.repeticion)
          .toList();
      // Hoy solo queda la de las 16:30 (son las 9:00); después, 3 al día
      // durante 13 días más.
      expect(repeticiones, hasLength(1 + 3 * 13));
      expect(repeticiones.take(4).map((a) => a.momento), [
        UnaVez(DateTime(2026, 10, 25, 16, 30)),
        UnaVez(DateTime(2026, 10, 26, 8, 30)),
        UnaVez(DateTime(2026, 10, 26, 16, 30)),
        UnaVez(DateTime(2026, 10, 26, 0, 30)),
      ]);
      expect(
        repeticiones.first.id,
        PlanificadorAvisos.idRepeticionConFecha(7, DateTime(2026, 10, 25), 1),
      );
      expect(repeticiones.first.titulo, '¿Has tomado tu medicina?');
      expect(repeticiones.first.conBotonesDeToma, isTrue);
    });

    test('avisos únicos para las citas futuras, con el lugar', () {
      final avisos = PlanificadorAvisos.planificar(
        medicamentos: const [],
        citas: [
          cita(
            3,
            DateTime(2026, 10, 27),
            const HoraDelDia(11, 0),
            lugar: 'Centro de salud',
          ),
          cita(4, DateTime(2026, 10, 20), const HoraDelDia(11, 0)),
        ],
        ajustes: const Ajustes(notificacionesActivadas: true),
        ahora: ahora,
      );
      expect(avisos.map((a) => a.id), [
        PlanificadorAvisos.idAvisoCita(3, TipoAvisoCita.diaAntes),
        PlanificadorAvisos.idAvisoCita(3, TipoAvisoCita.mismoDia),
        PlanificadorAvisos.idAvisoCita(3, TipoAvisoCita.unaHoraAntes),
      ]);
      expect(avisos.map((a) => a.titulo), [
        'Mañana tienes una cita',
        'Hoy tienes una cita',
        'Tu cita es dentro de 1 hora',
      ]);
      expect(avisos.first.momento, UnaVez(DateTime(2026, 10, 26, 18, 0)));
      expect(avisos.last.momento, UnaVez(DateTime(2026, 10, 27, 10, 0)));
      expect(avisos.last.cuerpo, contains('en Centro de salud'));
    });

    test('los ids de tomas y de citas no se solapan', () {
      final idToma = PlanificadorAvisos.idToma(9999999, 11);
      final idCita = PlanificadorAvisos.idAvisoCita(1, TipoAvisoCita.mismoDia);
      expect(idToma, lessThan(idCita));
      // Caben en un entero de 32 bits, como exige Android.
      expect(
        PlanificadorAvisos.idAvisoCita(100000000, TipoAvisoCita.diaAntes),
        lessThan(2147483647),
      );
    });
  });

  group('CanalAvisos', () {
    test('un canal distinto por cada combinación de sonido y vibración', () {
      final canales = {
        for (final sonido in [false, true])
          for (final vibracion in [false, true])
            CanalAvisos(sonido: sonido, vibracion: vibracion).id,
      };
      expect(canales, hasLength(4));
    });

    test('se elige según los interruptores de Ajustes', () {
      final canal = CanalAvisos.paraAjustes(
        const Ajustes(sonidoActivado: true, vibracionActivada: false),
      );
      expect(canal.sonido, isTrue);
      expect(canal.vibracion, isFalse);
      expect(
        CanalAvisos.paraAjustes(const Ajustes()).nombre,
        'Avisos silenciosos',
      );
    });
  });

  group('horas concretas y días de toma', () {
    // Son las 9:00 del domingo 25 de octubre; el lunes es el 26.
    const avisos = Ajustes(notificacionesActivadas: true);
    Medicamento con({
      List<HoraDelDia>? horasLibres,
      DiasDeToma dias = const TodosLosDias(),
      DateTime? fechaFin,
    }) => Medicamento(
      id: 9,
      nombre: 'Alendronato',
      numTomas: horasLibres?.length ?? 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      horasLibres: horasLibres,
      dias: dias,
      fechaFin: fechaFin,
    );
    List<AvisoProgramado> planificar(
      Medicamento m, {
      DateTime? cuando,
      List<RegistroToma> registros = const [],
    }) => PlanificadorAvisos.planificar(
      medicamentos: [m],
      citas: const [],
      ajustes: avisos,
      ahora: cuando ?? ahora,
      registros: registros,
    );
    const lunesYJueves = DiasDeLaSemana({DateTime.monday, DateTime.thursday});

    test('con horas concretas, un aviso diario por cada una', () {
      final tomas = planificar(
        con(
          horasLibres: const [
            HoraDelDia(8, 0),
            HoraDelDia(14, 0),
            HoraDelDia(21, 0),
          ],
        ),
      ).where((a) => a.tipo == TipoAviso.toma);
      expect(tomas.map((a) => a.id), [900, 901, 902]);
      expect(tomas.map((a) => a.momento), const [
        CadaDia(HoraDelDia(8, 0)),
        CadaDia(HoraDelDia(14, 0)),
        CadaDia(HoraDelDia(21, 0)),
      ]);
    });

    test('algunos días de la semana: un aviso semanal por día, y las '
        'repeticiones solo esos días', () {
      final todos = planificar(con(dias: lunesYJueves));
      final tomas = todos.where((a) => a.tipo == TipoAviso.toma);
      expect(tomas.map((a) => a.momento), const [
        CadaSemana(DateTime.monday, HoraDelDia(8, 0)),
        CadaSemana(DateTime.thursday, HoraDelDia(8, 0)),
      ]);
      expect(tomas.map((a) => a.id), [
        PlanificadorAvisos.idTomaSemanal(9, DateTime.monday, 0),
        PlanificadorAvisos.idTomaSemanal(9, DateTime.thursday, 0),
      ]);
      // En los 14 días de la ventana: los lunes 26 y 2 y los jueves 29 y 5.
      expect(
        todos
            .where((a) => a.tipo == TipoAviso.repeticion)
            .map((a) => a.momento),
        [
          UnaVez(DateTime(2026, 10, 26, 8, 30)),
          UnaVez(DateTime(2026, 10, 29, 8, 30)),
          UnaVez(DateTime(2026, 11, 2, 8, 30)),
          UnaVez(DateTime(2026, 11, 5, 8, 30)),
        ],
      );
    });

    test('si la toma de hoy se marca antes de su hora, esa toma se avisa día '
        'a día desde el siguiente día que toca', () {
      final lunes = DateTime(2026, 10, 26);
      final tomas = planificar(
        con(dias: lunesYJueves),
        cuando: DateTime(2026, 10, 26, 7, 0),
        registros: [
          RegistroToma(
            medicamentoId: 9,
            nombreMedicamento: 'Alendronato',
            fecha: lunes,
            hora: const HoraDelDia(8, 0),
            estado: EstadoToma.tomada,
            momento: DateTime(2026, 10, 26, 7, 0),
          ),
        ],
      ).where((a) => a.tipo == TipoAviso.toma).toList();
      expect(tomas.map((a) => a.momento), [
        UnaVez(DateTime(2026, 10, 29, 8, 0)),
        UnaVez(DateTime(2026, 11, 2, 8, 0)),
        UnaVez(DateTime(2026, 11, 5, 8, 0)),
      ]);
    });

    test('cada varios días: avisos únicos solo los días que toca, y el '
        'último recuerda abrir la app', () {
      final tomas = planificar(
        con(dias: CadaVariosDias(cada: 2, desde: DateTime(2026, 10, 26))),
      ).where((a) => a.tipo == TipoAviso.toma).toList();
      expect(tomas.map((a) => (a.momento as UnaVez).fechaHora.day), [
        26,
        28,
        30,
        1,
        3,
        5,
        7,
      ]);
      expect(tomas.last.cuerpo, endsWith(PlanificadorAvisos.notaRenovar));
      expect(
        tomas.first.cuerpo,
        isNot(endsWith(PlanificadorAvisos.notaRenovar)),
      );
    });

    test('algunos días de la semana con fecha de fin: avisos únicos hasta el '
        'último día', () {
      final tomas = planificar(
        con(dias: lunesYJueves, fechaFin: DateTime(2026, 10, 29)),
      ).where((a) => a.tipo == TipoAviso.toma).toList();
      expect(tomas.map((a) => a.momento), [
        UnaVez(DateTime(2026, 10, 26, 8, 0)),
        UnaVez(DateTime(2026, 10, 29, 8, 0)),
      ]);
      expect(
        tomas.last.cuerpo,
        isNot(endsWith(PlanificadorAvisos.notaRenovar)),
      );
    });

    test('CadaSemana: la próxima vez que llega ese día a esa hora', () {
      const lunes8 = CadaSemana(DateTime.monday, HoraDelDia(8, 0));
      expect(lunes8.siguienteDesde(ahora), DateTime(2026, 10, 26, 8, 0));
      expect(
        lunes8.siguienteDesde(DateTime(2026, 10, 26, 7, 0)),
        DateTime(2026, 10, 26, 8, 0),
      );
      expect(
        lunes8.siguienteDesde(DateTime(2026, 10, 26, 8, 0)),
        DateTime(2026, 11, 2, 8, 0),
      );
    });

    test('los avisos semanales caben en el rango de su medicamento', () {
      expect(
        PlanificadorAvisos.idTomaSemanal(7, DateTime.sunday, 11),
        lessThan(PlanificadorAvisos.idToma(8, 0)),
      );
      expect(
        PlanificadorAvisos.idTomaSemanal(7, DateTime.monday, 0),
        greaterThan(PlanificadorAvisos.idToma(7, 11)),
      );
    });
  });

  group('Repetición y aplazamiento elegidos en Ajustes', () {
    List<AvisoProgramado> planificar(Ajustes ajustes) =>
        PlanificadorAvisos.planificar(
          medicamentos: [ibuprofeno],
          citas: const [],
          ajustes: ajustes,
          ahora: ahora,
        );

    test('la repetición llega a los minutos elegidos', () {
      for (final (minutos, hora) in [
        (15, const HoraDelDia(16, 15)),
        (60, const HoraDelDia(17, 0)),
      ]) {
        final repeticiones = planificar(
          Ajustes(notificacionesActivadas: true, minutosRepeticion: minutos),
        ).where((a) => a.tipo == TipoAviso.repeticion);
        expect(
          repeticiones.first.momento,
          UnaVez(DateTime(2026, 10, 25, hora.hora, hora.minuto)),
          reason: '$minutos',
        );
        expect(repeticiones, hasLength(1 + 3 * 13), reason: '$minutos');
      }
    });

    test('sin repetición no hay avisos de repetición, pero sí los de la '
        'hora', () {
      final avisos = planificar(
        const Ajustes(notificacionesActivadas: true, minutosRepeticion: 0),
      );
      expect(avisos.where((a) => a.tipo == TipoAviso.repeticion), isEmpty);
      expect(avisos.where((a) => a.tipo == TipoAviso.toma), hasLength(3));
    });

    test('los avisos de tomas llevan los minutos del botón de aplazar', () {
      final avisos = planificar(
        const Ajustes(notificacionesActivadas: true, minutosAplazamiento: 5),
      );
      expect(avisos.where((a) => a.conBotonesDeToma), isNotEmpty);
      for (final aviso in avisos.where((a) => a.conBotonesDeToma)) {
        expect(aviso.minutosAplazamiento, 5);
      }
    });

    test('un valor que no es una opción pasa a ser el de por defecto', () {
      expect(Ajustes.repeticionValida(45), Ajustes.repeticionPorDefecto);
      expect(Ajustes.repeticionValida(null), Ajustes.repeticionPorDefecto);
      expect(Ajustes.repeticionValida(0), 0);
      expect(Ajustes.aplazamientoValido(7), Ajustes.aplazamientoPorDefecto);
      expect(Ajustes.aplazamientoValido(30), 30);
    });
  });

  group('Avisos discretos', () {
    // Con todo lo que puede salir en un aviso: dosis, instrucciones, foto,
    // pocas pastillas, receta por renovar, fecha de fin (avisos día a día, y
    // el último recuerda abrir la app) y una toma aplazada.
    final metformina = Medicamento(
      id: 3,
      nombre: 'Metformina',
      dosis: '850 mg',
      instrucciones: 'con el desayuno',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      fechaFin: DateTime(2026, 12, 31),
      foto: 'caja_3.jpg',
      renovarReceta: DateTime(2026, 10, 30),
      existencias: Existencias(
        cantidad: 3,
        contadas: DateTime(2026, 10, 24, 7, 0),
      ),
    );
    final aplazada = RegistroToma(
      medicamentoId: 3,
      nombreMedicamento: 'Metformina',
      fecha: DateTime(2026, 10, 25),
      hora: const HoraDelDia(8, 0),
      estado: EstadoToma.aplazada,
      momento: DateTime(2026, 10, 25, 8, 5),
      recordarEn: DateTime(2026, 10, 25, 9, 15),
    );
    List<AvisoProgramado> planificar({required bool discretos}) =>
        PlanificadorAvisos.planificar(
          medicamentos: [metformina],
          citas: [
            cita(
              1,
              DateTime(2026, 10, 27),
              const HoraDelDia(11, 30),
              lugar: 'Hospital del Mar',
            ),
          ],
          ajustes: Ajustes(
            notificacionesActivadas: true,
            avisosDiscretos: discretos,
          ),
          ahora: ahora,
          registros: [aplazada],
        );

    test('no dicen el nombre, la dosis, el motivo ni el lugar, ni llevan la '
        'foto', () {
      final avisos = planificar(discretos: true);
      String cuerpo(TipoAviso tipo) =>
          avisos.firstWhere((a) => a.tipo == tipo).cuerpo;
      const toca = 'Toca aquí para ver cuál es.';
      expect(cuerpo(TipoAviso.toma), 'La de las 08:00. $toca');
      expect(cuerpo(TipoAviso.repeticion), 'Era a las 08:00. $toca');
      expect(cuerpo(TipoAviso.aplazado), 'La de las 08:00. $toca');
      expect(cuerpo(TipoAviso.existencias), 'De una de tus medicinas. $toca');
      expect(cuerpo(TipoAviso.receta), 'La de una de tus medicinas. $toca');
      expect(cuerpo(TipoAviso.cita), 'A las 11:30. $toca');
      for (final aviso in avisos) {
        for (final dato in [
          'Metformina',
          '850',
          'desayuno',
          'Médico',
          'Hospital',
        ]) {
          expect('${aviso.titulo} ${aviso.cuerpo}', isNot(contains(dato)));
        }
        expect(aviso.foto, isNull, reason: '$aviso');
      }
      // El último aviso de toma sigue recordando que hay que abrir la app.
      expect(
        avisos.lastWhere((a) => a.tipo == TipoAviso.toma).cuerpo,
        endsWith(PlanificadorAvisos.notaRenovar),
      );
    });

    test('sin la opción, los mismos avisos lo dicen todo', () {
      final avisos = planificar(discretos: false);
      final toma = avisos.firstWhere((a) => a.tipo == TipoAviso.toma);
      expect(toma.cuerpo, 'Toma Metformina: 850 mg (08:00). Con el desayuno.');
      expect(toma.foto, 'caja_3.jpg');
      expect(
        avisos.firstWhere((a) => a.tipo == TipoAviso.cita).cuerpo,
        'Médico de cabecera a las 11:30 en Hospital del Mar.',
      );
      expect(
        [for (final a in avisos) a.id],
        [for (final a in planificar(discretos: true)) a.id],
      );
    });
  });

  group('PlanificadorAvisos.avisoDeTomaSinAtender', () {
    final hoy = DateTime(2026, 10, 25);
    // Una toma de las 08:00: su repetición llega a las 08:30.
    TomaDelDia toma(EstadoTomaDelDia estado, {DateTime? recordarEn}) =>
        TomaDelDia(
          medicamento: ibuprofeno,
          fecha: hoy,
          hora: const HoraDelDia(8, 0),
          estado: estado,
          registro: recordarEn == null
              ? null
              : RegistroToma(
                  medicamentoId: ibuprofeno.id,
                  nombreMedicamento: ibuprofeno.nombre,
                  fecha: hoy,
                  hora: const HoraDelDia(8, 0),
                  estado: EstadoToma.aplazada,
                  momento: DateTime(2026, 10, 25, 8, 3),
                  recordarEn: recordarEn,
                ),
        );
    bool sinAtender(
      TomaDelDia t,
      HoraDelDia desde,
      HoraDelDia hasta, {
      int minutosRepeticion = 30,
    }) => PlanificadorAvisos.avisoDeTomaSinAtender(
      [t],
      desde: DateTime(2026, 10, 25, desde.hora, desde.minuto),
      hasta: DateTime(2026, 10, 25, hasta.hora, hasta.minuto),
      minutosRepeticion: minutosRepeticion,
    );

    test('cuenta el aviso de su hora y el de la repetición', () {
      final t = toma(EstadoTomaDelDia.sinMarcar);
      expect(
        sinAtender(t, const HoraDelDia(7, 50), const HoraDelDia(8, 0)),
        isTrue,
      );
      // El de las 08:00 ya había llegado antes de "desde".
      expect(
        sinAtender(t, const HoraDelDia(8, 0), const HoraDelDia(8, 20)),
        isFalse,
      );
      expect(
        sinAtender(t, const HoraDelDia(8, 20), const HoraDelDia(8, 40)),
        isTrue,
      );
      expect(
        sinAtender(t, const HoraDelDia(8, 30), const HoraDelDia(9, 30)),
        isFalse,
      );
    });

    test('la repetición llega a los minutos elegidos, o no llega', () {
      final t = toma(EstadoTomaDelDia.sinMarcar);
      expect(
        sinAtender(
          t,
          const HoraDelDia(8, 20),
          const HoraDelDia(8, 40),
          minutosRepeticion: 15,
        ),
        isFalse,
      );
      expect(
        sinAtender(
          t,
          const HoraDelDia(8, 50),
          const HoraDelDia(9, 0),
          minutosRepeticion: 60,
        ),
        isTrue,
      );
      expect(
        sinAtender(
          t,
          const HoraDelDia(8, 0),
          const HoraDelDia(9, 30),
          minutosRepeticion: 0,
        ),
        isFalse,
      );
    });

    test('en una toma aplazada cuenta el aviso del aplazamiento', () {
      final t = toma(
        EstadoTomaDelDia.aplazada,
        recordarEn: DateTime(2026, 10, 25, 8, 13),
      );
      expect(
        sinAtender(t, const HoraDelDia(8, 5), const HoraDelDia(8, 15)),
        isTrue,
      );
      expect(
        sinAtender(t, const HoraDelDia(8, 5), const HoraDelDia(8, 12)),
        isFalse,
      );
      // Al aplazarla, su repetición deja de existir.
      expect(
        sinAtender(t, const HoraDelDia(8, 20), const HoraDelDia(8, 40)),
        isFalse,
      );
    });

    test('las tomas marcadas o que aún no han llegado no cuentan', () {
      for (final estado in [
        EstadoTomaDelDia.tomada,
        EstadoTomaDelDia.pendiente,
      ]) {
        expect(
          sinAtender(
            toma(estado),
            const HoraDelDia(7, 50),
            const HoraDelDia(8, 40),
          ),
          isFalse,
        );
      }
    });
  });

  test('HoraDelDia.siguienteDesde: hoy si aún no ha llegado, si no mañana', () {
    expect(
      const HoraDelDia(10, 0).siguienteDesde(ahora),
      DateTime(2026, 10, 25, 10, 0),
    );
    expect(
      const HoraDelDia(9, 0).siguienteDesde(ahora),
      DateTime(2026, 10, 26, 9, 0),
    );
  });
}
