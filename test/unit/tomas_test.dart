import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/app/respuestas_avisos.dart';
import 'package:salud_mayores/app/rutas.dart';
import 'package:salud_mayores/core/tiempo/formato_fechas.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/menu_principal/proximos_eventos.dart';
import 'package:salud_mayores/features/tomas/domain/limites_a_demanda.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/features/tomas/domain/tomas_del_dia.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';

import '../helpers/app_de_prueba.dart';

void main() {
  // Domingo, 25 de octubre de 2026, a las 9:00.
  final ahora = DateTime(2026, 10, 25, 9, 0);
  final hoy = DateTime(2026, 10, 25);

  Medicamento medicamento({
    int id = 1,
    String nombre = 'Paracetamol',
    int numTomas = 3,
    int frecuencia = 8,
    HoraDelDia hora = const HoraDelDia(8, 0),
    DateTime? fechaCreacion,
    DateTime? fechaFin,
  }) => Medicamento(
    id: id,
    nombre: nombre,
    numTomas: numTomas,
    frecuenciaHoras: frecuencia,
    horaInicio: hora,
    fechaCreacion: fechaCreacion ?? DateTime(2026, 10, 1),
    fechaFin: fechaFin,
  );

  RegistroToma registro(
    Medicamento m,
    DateTime fecha,
    HoraDelDia hora, {
    EstadoToma estado = EstadoToma.tomada,
    DateTime? momento,
    DateTime? recordarEn,
  }) => RegistroToma(
    medicamentoId: m.id,
    nombreMedicamento: m.nombre,
    fecha: fecha,
    hora: hora,
    estado: estado,
    momento: momento ?? ahora,
    recordarEn: recordarEn,
  );

  group('HoraDelDia.ultimoDiaHasta', () {
    test('hoy si la hora ya llegó, ayer si todavía no', () {
      expect(const HoraDelDia(8, 0).ultimoDiaHasta(ahora), hoy);
      expect(const HoraDelDia(9, 0).ultimoDiaHasta(ahora), hoy);
      expect(
        const HoraDelDia(23, 45).ultimoDiaHasta(ahora),
        DateTime(2026, 10, 24),
      );
    });
  });

  group('CargaAviso', () {
    test('ida y vuelta de tomas y citas', () {
      const toma = CargaToma(medicamentoId: 12, hora: HoraDelDia(20, 30));
      expect(toma.codificar(), 'toma|12|1230');
      expect(CargaAviso.decodificar(toma.codificar()), toma);
      expect(
        CargaAviso.decodificar(const CargaCita(4).codificar()),
        const CargaCita(4),
      );
    });

    test('cargas desconocidas o mal formadas se ignoran', () {
      expect(CargaAviso.decodificar(null), isNull);
      expect(CargaAviso.decodificar(''), isNull);
      expect(CargaAviso.decodificar('toma|x|1'), isNull);
      expect(CargaAviso.decodificar('toma|3|570|2026-10'), isNull);
      expect(CargaAviso.decodificar('toma|3|570|mañana'), isNull);
      expect(CargaAviso.decodificar('cita|'), isNull);
      expect(CargaAviso.decodificar('otra|1'), isNull);
    });
  });

  group('TomasDelDia', () {
    test('estado de cada toma y orden por hora', () {
      final m = medicamento();
      final tomas = TomasDelDia.calcular(
        medicamentos: [m],
        registros: [
          registro(m, hoy, const HoraDelDia(8, 0)),
          registro(
            m,
            hoy,
            const HoraDelDia(0, 0),
            estado: EstadoToma.aplazada,
            recordarEn: DateTime(2026, 10, 25, 0, 10),
          ),
        ],
        dia: hoy,
        ahora: ahora,
      );
      expect(tomas.map((t) => t.hora.texto), ['00:00', '08:00', '16:00']);
      expect(tomas.map((t) => t.estado), [
        EstadoTomaDelDia.aplazada,
        EstadoTomaDelDia.tomada,
        EstadoTomaDelDia.pendiente,
      ]);
    });

    test('sin registro y con la hora pasada, queda sin marcar', () {
      final m = medicamento(numTomas: 1, frecuencia: 24);
      final tomas = TomasDelDia.calcular(
        medicamentos: [m],
        registros: const [],
        dia: hoy,
        ahora: ahora,
      );
      expect(tomas.single.estado, EstadoTomaDelDia.sinMarcar);
    });

    test('no cuenta medicamentos que aún no existían o ya habían '
        'terminado', () {
      final tomas = TomasDelDia.calcular(
        medicamentos: [
          medicamento(id: 1, fechaCreacion: DateTime(2026, 10, 26)),
          medicamento(id: 2, fechaFin: DateTime(2026, 10, 24)),
          medicamento(id: 3, numTomas: 1, frecuencia: 24),
        ],
        registros: const [],
        dia: hoy,
        ahora: ahora,
      );
      expect(tomas.map((t) => t.medicamento.id), [3]);
    });

    test('los registros que ya no encajan con ninguna toma se muestran '
        'aparte', () {
      final m = medicamento(numTomas: 1, frecuencia: 24);
      final suelto = registro(
        m,
        hoy,
        const HoraDelDia(7, 0),
      ); // el horario cambió
      final tomas = TomasDelDia.calcular(
        medicamentos: [m],
        registros: [suelto],
        dia: hoy,
        ahora: ahora,
      );
      expect(
        TomasDelDia.registrosSueltos(
          tomas: tomas,
          registros: [suelto],
          dia: hoy,
        ),
        [suelto],
      );
    });
  });

  group('Repeticiones de tomas de última hora', () {
    final tardia = medicamento(
      id: 5,
      numTomas: 1,
      frecuencia: 24,
      hora: const HoraDelDia(23, 45),
    );
    List<AvisoProgramado> planificar(
      DateTime momento, [
      List<RegistroToma> registros = const [],
    ]) => PlanificadorAvisos.planificar(
      medicamentos: [tardia],
      citas: const [],
      ajustes: const Ajustes(notificacionesActivadas: true),
      ahora: momento,
      registros: registros,
    ).where((a) => a.tipo == TipoAviso.repeticion).toList();

    test('la repetición de las 23:45 cae a las 00:15 del día siguiente', () {
      expect(
        planificar(DateTime(2026, 10, 25, 23, 50)).first.momento,
        UnaVez(DateTime(2026, 10, 26, 0, 15)),
      );
    });

    test('pasada la medianoche, se salta si la toma de ayer ya está '
        'marcada', () {
      final ayer = DateTime(2026, 10, 25);
      final pasadaMedianoche = DateTime(2026, 10, 26, 0, 5);
      expect(
        planificar(pasadaMedianoche).first.momento,
        UnaVez(DateTime(2026, 10, 26, 0, 15)),
      );
      expect(
        planificar(pasadaMedianoche, [
          registro(tardia, ayer, const HoraDelDia(23, 45)),
        ]).first.momento,
        UnaVez(DateTime(2026, 10, 27, 0, 15)),
      );
    });
  });

  test('una toma diaria marcada antes de su hora no suena hoy: se avisa día '
      'a día desde mañana', () {
    // Paracetamol a las 08:00, 16:00 y 00:00; la de las 16:00 se toma ya.
    final m = medicamento();
    final avisos = PlanificadorAvisos.planificar(
      medicamentos: [m],
      citas: const [],
      ajustes: const Ajustes(notificacionesActivadas: true),
      ahora: ahora,
      registros: [registro(m, hoy, const HoraDelDia(16, 0))],
    );
    final tomas = avisos.where((a) => a.tipo == TipoAviso.toma).toList();
    // Las de las 08:00 y las 00:00 siguen siendo diarias.
    expect(
      tomas.where((a) => a.momento is CadaDia).map((a) => a.momento),
      const [CadaDia(HoraDelDia(8, 0)), CadaDia(HoraDelDia(0, 0))],
    );
    // La de las 16:00 no suena hoy, sí mañana y los días siguientes.
    final deLas16 = tomas.where((a) => a.momento is UnaVez).toList();
    expect(deLas16.first.momento, UnaVez(DateTime(2026, 10, 26, 16)));
    expect(
      deLas16.map((a) => (a.momento as UnaVez).fechaHora),
      isNot(contains(DateTime(2026, 10, 25, 16))),
    );
    expect(deLas16.last.cuerpo, endsWith(PlanificadorAvisos.notaRenovar));
    // Tampoco se repite hoy.
    expect(
      avisos.where((a) => a.tipo == TipoAviso.repeticion).map((a) => a.momento),
      isNot(contains(UnaVez(DateTime(2026, 10, 25, 16, 30)))),
    );
  });

  test('la próxima toma salta las ya marcadas por adelantado', () {
    final m = medicamento(
      numTomas: 1,
      frecuencia: 24,
      hora: const HoraDelDia(10, 0),
    );
    final siguiente = ProximosEventos.proximaToma(
      [m],
      ahora,
      registros: [registro(m, hoy, const HoraDelDia(10, 0))],
    );
    expect(siguiente?.fechaHora, DateTime(2026, 10, 26, 10));
  });

  test('"Ayer" en las fechas relativas', () {
    expect(
      FormatoFechas.fechaRelativa(DateTime(2026, 10, 24), ahora),
      'Ayer, sábado, 24 de octubre de 2026',
    );
  });

  group('ProcesadorRespuestas', () {
    late EntornoDePrueba entorno;
    late ProviderContainer contenedor;
    final paracetamol = medicamento(id: 3);

    void crear({DateTime? momento}) {
      entorno = EntornoDePrueba(
        medicamentos: [paracetamol],
        ajustes: const Ajustes(notificacionesActivadas: true),
        ahora: momento ?? DateTime(2026, 10, 25, 8, 5),
      );
      contenedor = ProviderContainer(overrides: entorno.overrides);
      addTearDown(contenedor.dispose);
    }

    Future<ResultadoRespuesta?> procesar(String? accion, CargaAviso carga) =>
        contenedor
            .read(procesadorRespuestasProvider)
            .procesar(RespuestaAviso(accion: accion, carga: carga.codificar()));

    const tomaDeLasOcho = CargaToma(medicamentoId: 3, hora: HoraDelDia(8, 0));

    test('"Ya la he tomado" marca la toma de hoy y lleva a "Tomas de '
        'hoy"', () async {
      crear();
      final resultado = await procesar(AccionesAviso.tomada, tomaDeLasOcho);
      expect(resultado?.ruta, Rutas.tomasHoy);
      expect(resultado?.mensaje, 'Anotado: has tomado Paracetamol (08:00).');
      final guardado = entorno.tomas.registros.single;
      expect(guardado.estado, EstadoToma.tomada);
      expect(guardado.fecha, hoy);
      expect(guardado.momento, DateTime(2026, 10, 25, 8, 5));
    });

    test('la toma de las 16:00 contestada pasada la medianoche es de '
        'ayer', () async {
      crear(momento: DateTime(2026, 10, 26, 0, 20));
      await procesar(
        AccionesAviso.tomada,
        const CargaToma(medicamentoId: 3, hora: HoraDelDia(16, 0)),
      );
      expect(entorno.tomas.registros.single.fecha, DateTime(2026, 10, 25));
    });

    test('"Recordar en 10 min" aplaza la toma', () async {
      crear();
      final resultado = await procesar(AccionesAviso.aplazar, tomaDeLasOcho);
      expect(resultado?.mensaje, 'Te lo recordaremos a las 08:15.');
      final guardado = entorno.tomas.registros.single;
      expect(guardado.estado, EstadoToma.aplazada);
      expect(guardado.recordarEn, DateTime(2026, 10, 25, 8, 15));
      await contenedor.read(sincronizadorAvisosProvider).esperar();
      expect(
        entorno.notificaciones.deTipo(TipoAviso.aplazado).single.momento,
        UnaVez(DateTime(2026, 10, 25, 8, 15)),
      );
    });

    test('tocar el aviso solo abre la pantalla, sin cambiar nada', () async {
      crear();
      final resultado = await procesar(null, tomaDeLasOcho);
      expect(resultado?.ruta, Rutas.tomasHoy);
      expect(resultado?.mensaje, isNull);
      expect(entorno.tomas.registros, isEmpty);

      final deCita = await procesar(null, const CargaCita(1));
      expect(deCita?.ruta, Rutas.agenda);
    });

    test('si el medicamento ya no existe lo explica', () async {
      crear();
      final resultado = await procesar(
        AccionesAviso.tomada,
        const CargaToma(medicamentoId: 99, hora: HoraDelDia(8, 0)),
      );
      expect(resultado?.mensaje, ProcesadorRespuestas.mensajeSinMedicamento);
      expect(entorno.tomas.registros, isEmpty);
    });

    test('una carga desconocida se ignora', () async {
      crear();
      expect(
        await contenedor
            .read(procesadorRespuestasProvider)
            .procesar(const RespuestaAviso(carga: 'otra cosa')),
        isNull,
      );
    });
  });

  group('límites de los "cuando haga falta"', () {
    Medicamento calmante({int? maximo, int? horas}) => Medicamento(
      id: 8,
      nombre: 'Ibuprofeno',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      aDemanda: true,
      maximoAlDia: maximo,
      horasEntreTomas: horas,
    );
    // Anotada a su hora, con unos segundos de más.
    RegistroToma tomadaA(DateTime momento) => RegistroToma(
      medicamentoId: 8,
      nombreMedicamento: 'Ibuprofeno',
      fecha: FormatoFechas.soloFecha(momento),
      hora: HoraDelDia(momento.hour, momento.minute),
      estado: EstadoToma.tomada,
      momento: momento.add(const Duration(seconds: 40)),
    );

    test('sin límites siempre se puede tomar', () {
      final estado = LimitesADemanda.estado(calmante(), [
        tomadaA(DateTime(2026, 10, 25, 8, 55)),
      ], ahora);
      expect(estado, const EstadoLimites(tomadasHoy: 1));
      expect(estado.dentroDeLosLimites, isTrue);
      expect(calmante().describirLimites, isNull);
    });

    test('el máximo cuenta solo las de hoy', () {
      final registros = [
        tomadaA(DateTime(2026, 10, 24, 20, 0)),
        tomadaA(DateTime(2026, 10, 25, 1, 0)),
        tomadaA(DateTime(2026, 10, 25, 7, 0)),
      ];
      expect(
        LimitesADemanda.estado(calmante(maximo: 3), registros, ahora),
        const EstadoLimites(tomadasHoy: 2),
      );
      expect(
        LimitesADemanda.estado(
          calmante(maximo: 2),
          registros,
          ahora,
        ).maximoAlcanzado,
        isTrue,
      );
    });

    test('el tiempo entre tomas cuenta desde la hora anotada, también la de '
        'ayer', () {
      expect(
        LimitesADemanda.estado(calmante(horas: 6), [
          tomadaA(DateTime(2026, 10, 25, 4, 30)),
        ], ahora).proximaDesde,
        DateTime(2026, 10, 25, 10, 30),
      );
      // A las 10:30 en punto ya se puede, aunque se anotara con segundos.
      expect(
        LimitesADemanda.estado(calmante(horas: 6), [
          tomadaA(DateTime(2026, 10, 25, 4, 30)),
        ], DateTime(2026, 10, 25, 10, 30)).dentroDeLosLimites,
        isTrue,
      );
      // Lejos del cambio de hora (el 25 de octubre), que cambia la hora del
      // reloj pero no las horas que pasan.
      expect(
        LimitesADemanda.estado(calmante(horas: 12), [
          tomadaA(DateTime(2026, 11, 9, 23, 0)),
        ], DateTime(2026, 11, 10, 9, 0)),
        EstadoLimites(
          tomadasHoy: 0,
          proximaDesde: DateTime(2026, 11, 10, 11, 0),
        ),
      );
    });

    test('se describen en una frase', () {
      expect(
        calmante(maximo: 3, horas: 6).describirLimites,
        'Como mucho 3 veces al día, con al menos 6 horas entre una y otra.',
      );
      expect(calmante(maximo: 1).describirLimites, 'Como mucho 1 vez al día.');
      expect(
        calmante(horas: 1).describirLimites,
        'Con al menos 1 hora entre una y otra.',
      );
    });

    test('un medicamento con horario no guarda límites', () {
      final m = Medicamento.desdeDatos(
        id: 1,
        fechaCreacion: hoy,
        datos: const NuevoMedicamento(
          nombre: 'Omeprazol',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(8, 0),
          maximoAlDia: 3,
          horasEntreTomas: 6,
        ),
      );
      expect(m.maximoAlDia, isNull);
      expect(m.horasEntreTomas, isNull);
    });
  });
}
