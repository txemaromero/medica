import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/formato_fechas.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/agenda/domain/recordatorios_cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/dias_de_toma.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/medicamentos/domain/validador_medicamento.dart';
import 'package:salud_mayores/features/menu_principal/proximos_eventos.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/features/tomas/domain/tomas_del_dia.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';

void main() {
  // Domingo, 25 de octubre de 2026, a las 9:00.
  final ahora = DateTime(2026, 10, 25, 9, 0);
  const activadas = Ajustes(notificacionesActivadas: true);

  Medicamento medicamento({
    int id = 1,
    String nombre = 'Amoxicilina',
    int numTomas = 1,
    int frecuencia = 24,
    HoraDelDia hora = const HoraDelDia(8, 0),
    DateTime? fechaFin,
    String? dosis,
    String? instrucciones,
  }) => Medicamento(
    id: id,
    nombre: nombre,
    numTomas: numTomas,
    frecuenciaHoras: frecuencia,
    horaInicio: hora,
    fechaCreacion: DateTime(2026, 10, 1),
    fechaFin: fechaFin,
    dosis: dosis,
    instrucciones: instrucciones,
  );

  List<AvisoProgramado> planificar(List<Medicamento> medicamentos) =>
      PlanificadorAvisos.planificar(
        medicamentos: medicamentos,
        citas: const [],
        ajustes: activadas,
        ahora: ahora,
      );

  group('Dosis distinta según la hora', () {
    // Una pastilla por la mañana y media por la noche.
    final enalapril = Medicamento(
      id: 4,
      nombre: 'Enalapril',
      numTomas: 2,
      frecuenciaHoras: 12,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      horasLibres: const [HoraDelDia(8, 0), HoraDelDia(21, 0)],
      dosisPorToma: const ['1 pastilla', 'media pastilla'],
    );

    test('cada toma tiene la suya, y la lista las describe todas', () {
      expect(enalapril.dosisDe(const HoraDelDia(8, 0)), '1 pastilla');
      expect(enalapril.dosisDe(const HoraDelDia(21, 0)), 'media pastilla');
      expect(enalapril.dosisDe(const HoraDelDia(12, 0)), isNull);
      expect(
        enalapril.describirDosis,
        '1 pastilla a las 08:00 y media pastilla a las 21:00',
      );
      expect(medicamento(dosis: '1 cápsula').describirDosis, '1 cápsula');
      expect(
        medicamento(dosis: '1 cápsula').dosisDe(const HoraDelDia(8, 0)),
        '1 cápsula',
      );
    });

    test('los avisos llevan la dosis de su toma', () {
      final tomas = planificar([enalapril])
          .where((a) => a.tipo == TipoAviso.toma)
          .map((a) => a.cuerpo);
      expect(tomas, [
        'Toma Enalapril: 1 pastilla (08:00).',
        'Toma Enalapril: media pastilla (21:00).',
      ]);
    });

    test('desde el formulario: sin la dosis de arriba y solo si tiene '
        'sentido', () {
      Medicamento desde(NuevoMedicamento datos) =>
          Medicamento.desdeDatos(id: 1, fechaCreacion: ahora, datos: datos);
      final conDosis = desde(
        const NuevoMedicamento(
          nombre: 'Enalapril',
          numTomas: 2,
          frecuenciaHoras: 12,
          horaInicio: HoraDelDia(8, 0),
          dosis: '1 pastilla',
          dosisPorToma: [' 1 pastilla ', 'media pastilla'],
        ),
      );
      expect(conDosis.dosis, isNull);
      expect(conDosis.dosisPorToma, ['1 pastilla', 'media pastilla']);
      // Todas vacías, con una sola toma o "cuando haga falta": la de arriba.
      for (final datos in [
        const NuevoMedicamento(
          nombre: 'Enalapril',
          numTomas: 2,
          frecuenciaHoras: 12,
          horaInicio: HoraDelDia(8, 0),
          dosis: '1 pastilla',
          dosisPorToma: ['', ' '],
        ),
        const NuevoMedicamento(
          nombre: 'Enalapril',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(8, 0),
          dosis: '1 pastilla',
          dosisPorToma: ['media pastilla'],
        ),
        const NuevoMedicamento(
          nombre: 'Enalapril',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(8, 0),
          dosis: '1 pastilla',
          aDemanda: true,
          dosisPorToma: ['media pastilla', 'una'],
        ),
      ]) {
        final m = desde(datos);
        expect(m.dosisPorToma, isNull);
        expect(m.dosis, '1 pastilla');
      }
    });

    test('una dosis de cada toma demasiado larga no se admite', () {
      final errores = ValidadorMedicamento.validar(
        nombre: 'Enalapril',
        numTomas: 2,
        frecuenciaHoras: 12,
        horaInicio: const HoraDelDia(8, 0),
        ahora: ahora,
        dosisPorToma: ['1 pastilla', 'x' * 41],
      );
      expect(errores.dosis, isNotNull);
    });
  });

  group('Medicamento con fecha de fin', () {
    test('terminado y seTomaEl', () {
      final m = medicamento(fechaFin: DateTime(2026, 10, 25));
      expect(m.terminado(ahora), isFalse);
      expect(m.terminado(DateTime(2026, 10, 26, 0, 1)), isTrue);
      expect(m.seTomaEl(DateTime(2026, 10, 25, 23, 59)), isTrue);
      expect(m.seTomaEl(DateTime(2026, 10, 26)), isFalse);
      expect(medicamento().terminado(DateTime(2099)), isFalse);
    });

    test('conDatos conserva id y fecha de creación y limpia los textos', () {
      final original = medicamento(id: 9, dosis: '1 pastilla');
      final cambiado = original.conDatos(
        NuevoMedicamento(
          nombre: '  Amoxicilina 500  ',
          numTomas: 3,
          frecuenciaHoras: 8,
          horaInicio: const HoraDelDia(7, 0),
          dosis: '   ',
          instrucciones: ' con comida ',
          fechaFin: DateTime(2026, 11, 1, 18, 30),
        ),
      );
      expect(cambiado.id, 9);
      expect(cambiado.fechaCreacion, original.fechaCreacion);
      expect(cambiado.nombre, 'Amoxicilina 500');
      expect(cambiado.dosis, isNull);
      expect(cambiado.instrucciones, 'con comida');
      expect(cambiado.fechaFin, DateTime(2026, 11, 1));
    });
  });

  group('Avisos de tratamientos con fecha de fin', () {
    Iterable<AvisoProgramado> deTipo(
      List<AvisoProgramado> avisos,
      TipoAviso tipo,
    ) => avisos.where((a) => a.tipo == tipo);

    test('un aviso único por toma y día hasta el último día, incluido, '
        'cada uno con su repetición', () {
      final avisos = planificar([
        medicamento(fechaFin: DateTime(2026, 10, 28)),
      ]);
      // Hoy a las 8:00 (y su repetición de las 8:30) ya han pasado.
      expect(deTipo(avisos, TipoAviso.toma).map((a) => a.momento), [
        UnaVez(DateTime(2026, 10, 26, 8)),
        UnaVez(DateTime(2026, 10, 27, 8)),
        UnaVez(DateTime(2026, 10, 28, 8)),
      ]);
      expect(deTipo(avisos, TipoAviso.repeticion).map((a) => a.momento), [
        UnaVez(DateTime(2026, 10, 26, 8, 30)),
        UnaVez(DateTime(2026, 10, 27, 8, 30)),
        UnaVez(DateTime(2026, 10, 28, 8, 30)),
      ]);
      expect(
        avisos.every((a) => !a.cuerpo.contains('Abre la aplicación')),
        isTrue,
      );
    });

    test('incluye las tomas de hoy que aún no han llegado', () {
      final avisos = planificar([
        medicamento(
          numTomas: 3,
          frecuencia: 8,
          fechaFin: DateTime(2026, 10, 25),
        ),
      ]);
      expect(avisos.map((a) => a.momento), [
        UnaVez(DateTime(2026, 10, 25, 16)),
        UnaVez(DateTime(2026, 10, 25, 16, 30)),
      ]);
    });

    test('una toma marcada no suena ni se repite; una aplazada suena a la '
        'hora pedida', () {
      final m = medicamento(fechaFin: DateTime(2026, 10, 28));
      RegistroToma registro(int dia, EstadoToma estado) => RegistroToma(
        medicamentoId: m.id,
        nombreMedicamento: m.nombre,
        fecha: DateTime(2026, 10, dia),
        hora: const HoraDelDia(8, 0),
        estado: estado,
        momento: ahora,
        recordarEn: estado == EstadoToma.aplazada
            ? DateTime(2026, 10, 25, 9, 10)
            : null,
      );
      final avisos = PlanificadorAvisos.planificar(
        medicamentos: [m],
        citas: const [],
        ajustes: activadas,
        ahora: ahora,
        registros: [
          registro(25, EstadoToma.aplazada),
          // Marcada por adelantado.
          registro(26, EstadoToma.tomada),
        ],
      );
      expect(deTipo(avisos, TipoAviso.toma).map((a) => a.momento), [
        UnaVez(DateTime(2026, 10, 27, 8)),
        UnaVez(DateTime(2026, 10, 28, 8)),
      ]);
      expect(
        deTipo(avisos, TipoAviso.aplazado).single.momento,
        UnaVez(DateTime(2026, 10, 25, 9, 10)),
      );
      expect(
        deTipo(avisos, TipoAviso.repeticion).map((a) => a.momento),
        isNot(contains(UnaVez(DateTime(2026, 10, 26, 8, 30)))),
      );
    });

    test('un tratamiento terminado no genera avisos', () {
      expect(
        planificar([medicamento(fechaFin: DateTime(2026, 10, 24))]),
        isEmpty,
      );
    });

    test('se programan como mucho 14 días y el último aviso recuerda '
        'abrir la app', () {
      final tomas = deTipo(
        planificar([medicamento(fechaFin: DateTime(2026, 12, 31))]),
        TipoAviso.toma,
      ).toList();
      expect(tomas, hasLength(PlanificadorAvisos.diasVentanaMaximos - 1));
      expect(
        (tomas.last.momento as UnaVez).fechaHora,
        DateTime(2026, 11, 7, 8),
      );
      expect(tomas.last.cuerpo, endsWith(PlanificadorAvisos.notaRenovar));
      expect(
        tomas
            .take(tomas.length - 1)
            .any((a) => a.cuerpo.contains(PlanificadorAvisos.notaRenovar)),
        isFalse,
      );
    });

    test('la ventana se acorta para no superar el tope de avisos', () {
      final muchos = [
        for (var id = 1; id <= 5; id++)
          medicamento(
            id: id,
            numTomas: 12,
            frecuencia: 2,
            fechaFin: DateTime(2027, 1, 1),
          ),
      ];
      // 60 tomas al día, cada una con su repetición: 400 / 120 = 3 días.
      expect(
        PlanificadorAvisos.diasVentana(avisosPorDia: 120, avisosFijos: 0),
        3,
      );
      final avisos = planificar(muchos);
      expect(
        avisos.length,
        lessThanOrEqualTo(PlanificadorAvisos.presupuestoAvisos),
      );
      expect(avisos.map((a) => a.id).toSet(), hasLength(avisos.length));
    });

    test('los tratamientos sin fin siguen usando avisos diarios', () {
      final avisos = planificar([
        medicamento(id: 1),
        medicamento(id: 2, fechaFin: DateTime(2026, 10, 27)),
      ]);
      expect(avisos.first.momento, const CadaDia(HoraDelDia(8, 0)));
      expect(
        deTipo(avisos, TipoAviso.toma).where((a) => a.momento is UnaVez),
        hasLength(2),
      );
    });

    test('identificadores estables, únicos y sin chocar con otros avisos', () {
      final dia = DateTime(2026, 10, 26);
      final id = PlanificadorAvisos.idTomaConFecha(3, dia, 2);
      expect(PlanificadorAvisos.idTomaConFecha(3, dia, 2), id);
      // 15 días (el anterior y 14 más), 12 tomas, cada una con su repetición.
      final ids = {
        for (var d = -1; d < 14; d++)
          for (var t = 0; t < 12; t++) ...[
            PlanificadorAvisos.idTomaConFecha(3, DateTime(2026, 10, 26 + d), t),
            PlanificadorAvisos.idRepeticionConFecha(
              3,
              DateTime(2026, 10, 26 + d),
              t,
            ),
          ],
      };
      expect(ids, hasLength(15 * 12 * 2));
      expect(id, greaterThan(PlanificadorAvisos.idAplazado(833332, 11)));
      expect(
        PlanificadorAvisos.idAplazado(833332, 11),
        greaterThan(
          PlanificadorAvisos.idAvisoCita(8999999, TipoAvisoCita.unaHoraAntes),
        ),
      );
      expect(
        PlanificadorAvisos.idRepeticionConFecha(2000000, dia, 11),
        lessThan(2147483647),
      );
      expect(
        PlanificadorAvisos.idToma(9999999, 11),
        lessThan(PlanificadorAvisos.idAvisoCita(0, TipoAvisoCita.mismoDia)),
      );
    });

    test('el texto incluye dosis e instrucciones con buena puntuación', () {
      final avisos = planificar([
        medicamento(
          dosis: '1 cápsula',
          instrucciones: 'con el desayuno.',
          fechaFin: DateTime(2026, 10, 26),
        ),
      ]);
      expect(
        deTipo(avisos, TipoAviso.toma).single.cuerpo,
        'Toma Amoxicilina: 1 cápsula (08:00). Con el desayuno.',
      );
      expect(
        deTipo(avisos, TipoAviso.repeticion).single.cuerpo,
        'Era a las 08:00: Amoxicilina: 1 cápsula. Si ya la has tomado, '
        'pulsa "Ya la he tomado".',
      );
    });
  });

  group('ProximosEventos', () {
    test('la próxima toma es la más cercana de todos los medicamentos', () {
      final toma = ProximosEventos.proximaToma([
        medicamento(id: 1, nombre: 'A', hora: const HoraDelDia(12, 0)),
        medicamento(id: 2, nombre: 'B', hora: const HoraDelDia(9, 30)),
      ], ahora);
      expect(toma?.medicamento.nombre, 'B');
      expect(toma?.fechaHora, DateTime(2026, 10, 25, 9, 30));
    });

    test('pasa al día siguiente si hoy ya no quedan tomas', () {
      final toma = ProximosEventos.proximaToma([
        medicamento(hora: const HoraDelDia(8, 0)),
      ], ahora);
      expect(toma?.fechaHora, DateTime(2026, 10, 26, 8, 0));
    });

    test('una medicina de algunos días o de cada varios días: el próximo día '
        'que toca', () {
      Medicamento conDias(DiasDeToma dias) => Medicamento(
        id: 1,
        nombre: 'Alendronato',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 1),
        dias: dias,
      );
      expect(
        ProximosEventos.proximaToma([
          conDias(const DiasDeLaSemana({DateTime.thursday})),
        ], ahora)?.fechaHora,
        DateTime(2026, 10, 29, 8, 0),
      );
      expect(
        ProximosEventos.proximaToma([
          conDias(CadaVariosDias(cada: 3, desde: DateTime(2026, 10, 24))),
        ], ahora)?.fechaHora,
        DateTime(2026, 10, 27, 8, 0),
      );
    });

    test('con horas concretas, la siguiente de hoy', () {
      final toma = ProximosEventos.proximaToma([
        Medicamento(
          id: 1,
          nombre: 'Metformina',
          numTomas: 2,
          frecuenciaHoras: 12,
          horaInicio: const HoraDelDia(8, 0),
          fechaCreacion: DateTime(2026, 10, 1),
          horasLibres: const [HoraDelDia(8, 0), HoraDelDia(21, 0)],
        ),
      ], ahora);
      expect(toma?.fechaHora, DateTime(2026, 10, 25, 21, 0));
    });

    test('las tomas del día solo cuentan los días que toca', () {
      final semanal = Medicamento(
        id: 1,
        nombre: 'Alendronato',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 1),
        dias: const DiasDeLaSemana({DateTime.monday}),
      );
      List<TomaDelDia> tomasDel(int dia) => TomasDelDia.calcular(
        medicamentos: [semanal],
        registros: const [],
        dia: DateTime(2026, 10, dia),
        ahora: ahora,
      );
      expect(tomasDel(25), isEmpty);
      expect(tomasDel(26), hasLength(1));
    });

    test('ignora los tratamientos terminados o sin más tomas', () {
      expect(
        ProximosEventos.proximaToma([
          medicamento(fechaFin: DateTime(2026, 10, 24)),
          // Termina hoy y la toma de hoy ya ha pasado.
          medicamento(id: 2, fechaFin: DateTime(2026, 10, 25)),
        ], ahora),
        isNull,
      );
    });

    test('la próxima cita es la primera que no ha pasado', () {
      Cita cita(int id, int dia) => Cita(
        id: id,
        titulo: 'Cita $id',
        fecha: DateTime(2026, 10, dia),
        hora: const HoraDelDia(10, 0),
      );
      expect(
        ProximosEventos.proximaCita([
          cita(1, 30),
          cita(2, 20),
          cita(3, 26),
        ], ahora)?.id,
        3,
      );
      expect(ProximosEventos.proximaCita([cita(1, 20)], ahora), isNull);
    });
  });

  group('Medicamentos "cuando haga falta"', () {
    Medicamento aDemanda({
      int id = 5,
      String nombre = 'Ibuprofeno',
      DateTime? creado,
      DateTime? fechaFin,
    }) => Medicamento(
      id: id,
      nombre: nombre,
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: creado ?? DateTime(2026, 10, 1),
      fechaFin: fechaFin,
      aDemanda: true,
    );
    RegistroToma tomada(Medicamento m, int dia, HoraDelDia hora) =>
        RegistroToma(
          medicamentoId: m.id,
          nombreMedicamento: m.nombre,
          fecha: DateTime(2026, 10, dia),
          hora: hora,
          estado: EstadoToma.tomada,
          momento: DateTime(2026, 10, dia, hora.hora, hora.minuto),
        );

    test('no tienen horas ni días de toma, ni avisos, ni próxima toma', () {
      final calmante = aDemanda();
      expect(calmante.horasDeToma, isEmpty);
      expect(calmante.seTomaEl(ahora), isFalse);
      expect(calmante.descripcionTomas, 'Cuando haga falta, sin avisos');
      expect(planificar([calmante]), isEmpty);
      expect(ProximosEventos.proximaToma([calmante], ahora), isNull);
      expect(
        TomasDelDia.calcular(
          medicamentos: [calmante],
          registros: const [],
          dia: ahora,
          ahora: ahora,
        ),
        isEmpty,
      );
    });

    test('se guarda como tal y cuenta al comparar', () {
      final calmante = medicamento(id: 5).conDatos(
        const NuevoMedicamento(
          nombre: 'Ibuprofeno',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(8, 0),
          aDemanda: true,
        ),
      );
      expect(calmante.aDemanda, isTrue);
      expect(calmante, aDemanda());
      expect(calmante == medicamento(id: 5, nombre: 'Ibuprofeno'), isFalse);
    });

    test('se pueden anotar mientras dura el tratamiento, por nombre', () {
      final lista = TomasDelDia.medicamentosADemanda([
        aDemanda(),
        aDemanda(id: 6, nombre: 'Almax'),
        aDemanda(id: 7, nombre: 'Dolalgial', fechaFin: DateTime(2026, 10, 24)),
        aDemanda(id: 8, nombre: 'Paracetamol', creado: DateTime(2026, 10, 26)),
        medicamento(),
      ], ahora);
      expect(lista.map((m) => m.nombre), ['Almax', 'Ibuprofeno']);
    });

    test('sus tomas del día van por hora y no son registros sueltos', () {
      final calmante = aDemanda();
      final registros = [
        tomada(calmante, 25, const HoraDelDia(14, 30)),
        tomada(calmante, 25, const HoraDelDia(8, 10)),
        tomada(calmante, 24, const HoraDelDia(20, 0)),
      ];
      expect(
        TomasDelDia.tomasADemanda(
          medicamentos: [calmante],
          registros: registros,
          dia: ahora,
        ).map((r) => r.hora),
        const [HoraDelDia(8, 10), HoraDelDia(14, 30)],
      );
      expect(
        TomasDelDia.registrosSueltos(
          tomas: const [],
          registros: registros,
          dia: ahora,
          medicamentos: [calmante],
        ),
        isEmpty,
      );
      // Si se elimina el medicamento, se ven como tomas sueltas.
      expect(
        TomasDelDia.registrosSueltos(
          tomas: const [],
          registros: registros,
          dia: ahora,
        ),
        hasLength(2),
      );
    });
  });

  group('Resumen de la semana', () {
    RegistroToma tomada(int id, String nombre, int dia, HoraDelDia hora) =>
        RegistroToma(
          medicamentoId: id,
          nombreMedicamento: nombre,
          fecha: DateTime(2026, 10, dia),
          hora: hora,
          estado: EstadoToma.tomada,
          momento: DateTime(2026, 10, dia, hora.hora, hora.minuto + 5),
        );

    test('cuenta las tomas que ya tocaban y las marcadas', () {
      // A las 08:00 y a las 20:00, desde el martes 20: hasta hoy a las 9:00
      // han tocado 11 (la de esta noche no cuenta todavía).
      final metformina = Medicamento(
        id: 1,
        nombre: 'Metformina',
        numTomas: 2,
        frecuenciaHoras: 12,
        horaInicio: const HoraDelDia(8, 0),
        fechaCreacion: DateTime(2026, 10, 20),
      );
      final registros = [
        for (final dia in [23, 24, 25])
          tomada(1, 'Metformina', dia, const HoraDelDia(8, 0)),
        tomada(1, 'Metformina', 24, const HoraDelDia(20, 0)),
        // De un medicamento que ya se ha eliminado.
        tomada(9, 'Aspirina', 22, const HoraDelDia(14, 0)),
      ];
      final resumen = TomasDelDia.resumen(
        medicamentos: [metformina],
        registros: registros,
        ahora: ahora,
      );
      expect(resumen, (tomadas: 5, total: 12));
      expect(TomasDelDia.porcentaje(5, 12), 42);
      expect(TomasDelDia.porcentaje(0, 0), 0);
    });

    test('el recordatorio de enviarlo, los domingos a las 18:00', () {
      List<AvisoProgramado> avisos(Ajustes ajustes) =>
          PlanificadorAvisos.planificar(
            medicamentos: const [],
            citas: const [],
            ajustes: ajustes,
            ahora: ahora,
          );
      final aviso = avisos(
        const Ajustes(notificacionesActivadas: true, recordarResumen: true),
      ).single;
      expect(aviso.id, PlanificadorAvisos.idRecordatorioResumen);
      expect(aviso.tipo, TipoAviso.resumen);
      expect(
        aviso.momento,
        const CadaSemana(DateTime.sunday, HoraDelDia(18, 0)),
      );
      expect(aviso.conBotonesDeToma, isFalse);
      expect(aviso.cuerpo, contains('"Enviar mi medicación y citas"'));
      expect(CargaAviso.decodificar(aviso.carga), const CargaResumen());
      expect(avisos(const Ajustes(notificacionesActivadas: true)), isEmpty);
      expect(avisos(const Ajustes(recordarResumen: true)), isEmpty);
    });
  });

  group('ValidadorMedicamento (campos nuevos)', () {
    ErroresMedicamento validar({
      String dosis = '',
      String instrucciones = '',
      DateTime? fechaFin,
    }) => ValidadorMedicamento.validar(
      nombre: 'Amoxicilina',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      ahora: ahora,
      dosis: dosis,
      instrucciones: instrucciones,
      fechaFin: fechaFin,
    );

    test('la fecha de fin puede ser hoy pero no un día pasado', () {
      expect(validar(fechaFin: DateTime(2026, 10, 25)).sinErrores, isTrue);
      expect(
        validar(fechaFin: DateTime(2026, 10, 24)).fechaFin,
        contains('ya ha pasado'),
      );
    });

    test('dosis e instrucciones opcionales con longitud máxima', () {
      expect(validar(dosis: '1 pastilla').sinErrores, isTrue);
      expect(validar(dosis: 'x' * 41).dosis, contains('demasiado larga'));
      expect(
        validar(instrucciones: 'x' * 101).instrucciones,
        contains('demasiado largas'),
      );
    });
  });

  group('FormatoFechas.cuando', () {
    test('hoy, mañana o el día de la semana', () {
      expect(
        FormatoFechas.cuando(DateTime(2026, 10, 25, 16), ahora),
        'hoy a las 16:00',
      );
      expect(
        FormatoFechas.cuando(DateTime(2026, 10, 26, 8), ahora),
        'mañana a las 08:00',
      );
      expect(
        FormatoFechas.cuando(DateTime(2026, 10, 27, 10, 30), ahora),
        'el martes, 27 de octubre, a las 10:30',
      );
    });
  });
}
