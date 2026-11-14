import '../core/tiempo/formato_fechas.dart';
import '../core/tiempo/hora_del_dia.dart';
import '../features/agenda/domain/cita.dart';
import '../features/agenda/domain/recordatorios_cita.dart';
import '../features/ajustes/domain/ajustes.dart';
import '../features/medicamentos/domain/dias_de_toma.dart';
import '../features/medicamentos/domain/existencias.dart';
import '../features/medicamentos/domain/horario_tomas.dart';
import '../features/medicamentos/domain/medicamento.dart';
import '../features/medicamentos/domain/receta.dart';
import '../features/tomas/domain/registro_toma.dart';
import '../features/tomas/domain/tomas_del_dia.dart';
import '../l10n/textos.dart';
import 'carga_aviso.dart';

/// Cuándo debe sonar un aviso.
sealed class MomentoAviso {
  const MomentoAviso();
}

/// Aviso que se repite todos los días a la misma hora, empezando por la
/// próxima vez que llegue esa hora.
///
/// Android (con `flutter_local_notifications`) calcula él mismo la primera
/// vez a partir de "ahora": no se puede pedir que un aviso recurrente empiece
/// mañana. Por eso, cuando hay que saltarse el de hoy, el planificador usa
/// avisos [UnaVez] en su lugar.
class CadaDia extends MomentoAviso {
  const CadaDia(this.hora);

  final HoraDelDia hora;

  @override
  bool operator ==(Object other) => other is CadaDia && other.hora == hora;

  @override
  int get hashCode => hora.hashCode;

  @override
  String toString() => 'CadaDia($hora)';
}

/// Aviso que se repite cada semana el día [diaSemana] (1, lunes, a 7,
/// domingo) a la hora indicada, empezando por la próxima vez que llegue.
class CadaSemana extends MomentoAviso {
  const CadaSemana(this.diaSemana, this.hora);

  final int diaSemana;
  final HoraDelDia hora;

  /// La próxima vez que llega ese día a esa hora, después de [ahora].
  DateTime siguienteDesde(DateTime ahora) {
    var dia = DateTime(ahora.year, ahora.month, ahora.day);
    while (true) {
      final momento = DateTime(
        dia.year,
        dia.month,
        dia.day,
        hora.hora,
        hora.minuto,
      );
      if (dia.weekday == diaSemana && momento.isAfter(ahora)) return momento;
      dia = DateTime(dia.year, dia.month, dia.day + 1);
    }
  }

  @override
  bool operator ==(Object other) =>
      other is CadaSemana && other.diaSemana == diaSemana && other.hora == hora;

  @override
  int get hashCode => Object.hash(diaSemana, hora);

  @override
  String toString() => 'CadaSemana($diaSemana, $hora)';
}

/// Aviso único en una fecha y hora concretas.
class UnaVez extends MomentoAviso {
  const UnaVez(this.fechaHora);

  final DateTime fechaHora;

  @override
  bool operator ==(Object other) =>
      other is UnaVez && other.fechaHora == fechaHora;

  @override
  int get hashCode => fechaHora.hashCode;

  @override
  String toString() => 'UnaVez($fechaHora)';
}

enum TipoAviso {
  /// Hora de una toma.
  toma,

  /// Segundo aviso de una toma que no se ha marcado como tomada.
  repeticion,

  /// Recordatorio que la persona pidió con "Recordar en 10 min" (o los
  /// minutos elegidos en Ajustes).
  aplazado,

  cita,

  /// Quedan pocas pastillas de un medicamento.
  existencias,

  /// Hay que renovar la receta de un medicamento.
  receta,

  /// Recordatorio semanal de enviar el resumen a la familia.
  resumen,
}

class AvisoProgramado {
  const AvisoProgramado({
    required this.id,
    required this.titulo,
    required this.cuerpo,
    required this.momento,
    required this.tipo,
    this.carga,
    this.foto,
    this.minutosAplazamiento = Ajustes.aplazamientoPorDefecto,
  });

  /// Identificador de la notificación en el sistema (único y estable).
  final int id;
  final String titulo;
  final String cuerpo;
  final MomentoAviso momento;
  final TipoAviso tipo;

  /// Ver [CargaAviso].
  final String? carga;

  /// Foto de la caja del medicamento (nombre del fichero), que se muestra
  /// en el aviso para reconocerlo de un vistazo.
  final String? foto;

  /// Los minutos del botón "Recordar en 10 min", en los avisos de tomas.
  final int minutosAplazamiento;

  /// Los avisos de tomas llevan los botones "Ya la he tomado" y "Recordar en
  /// 10 min".
  bool get conBotonesDeToma => switch (tipo) {
    TipoAviso.toma || TipoAviso.repeticion || TipoAviso.aplazado => true,
    TipoAviso.cita ||
    TipoAviso.existencias ||
    TipoAviso.receta ||
    TipoAviso.resumen => false,
  };

  /// El mismo aviso con otros minutos en "Recordar en 10 min".
  AvisoProgramado conAplazamiento(int minutos) => AvisoProgramado(
    id: id,
    titulo: titulo,
    cuerpo: cuerpo,
    momento: momento,
    tipo: tipo,
    carga: carga,
    foto: foto,
    minutosAplazamiento: minutos,
  );

  @override
  String toString() => 'AvisoProgramado($id, $tipo, $momento)';
}

/// Canal de notificación de Android. En Android 8+ el sonido y la vibración
/// se fijan al crear el canal, por eso hay un canal para cada combinación de
/// los interruptores de Ajustes.
class CanalAvisos {
  const CanalAvisos({required this.sonido, required this.vibracion});

  factory CanalAvisos.paraAjustes(Ajustes ajustes) => CanalAvisos(
    sonido: ajustes.sonidoActivado,
    vibracion: ajustes.vibracionActivada,
  );

  final bool sonido;
  final bool vibracion;

  String get id =>
      'avisos_${sonido ? 'con' : 'sin'}_sonido_${vibracion ? 'con' : 'sin'}_vibracion';

  String get nombre {
    final t = textosApp;
    if (sonido && vibracion) return t.canalConSonidoYVibracion;
    if (sonido) return t.canalConSonido;
    if (vibracion) return t.canalConVibracion;
    return t.canalSilencioso;
  }

  @override
  bool operator ==(Object other) =>
      other is CanalAvisos &&
      other.sonido == sonido &&
      other.vibracion == vibracion;

  @override
  int get hashCode => Object.hash(sonido, vibracion);
}

/// Calcula todos los avisos que deben estar programados a partir de los
/// datos guardados. Es lógica pura: no habla con el sistema operativo.
///
/// - **Tomas de tratamientos sin fin**: un aviso diario recurrente por toma,
///   que sigue sonando aunque no se abra la app en días. Si la toma de hoy ya
///   se marcó antes de su hora, esa toma se avisa día a día (avisos únicos)
///   empezando mañana, porque un aviso recurrente no puede empezar mañana.
/// - **Tomas de algunos días de la semana**: igual, pero con un aviso
///   semanal recurrente por día y toma.
/// - **Tomas de tratamientos con fecha de fin, o cada varios días**: un
///   aviso único por toma y día, porque un aviso recurrente no se detendría
///   solo (ni se puede repetir cada 2 o 3 días).
/// - **Repeticiones**: cada toma que no se marca se repite los minutos
///   elegidos en Ajustes después (`Ajustes.minutosRepeticion`; si se ha
///   elegido no repetirlas, no hay), con avisos únicos día a día para poder
///   saltarse los de las tomas ya marcadas o aplazadas.
/// - **Aplazados**: el recordatorio pedido con "Recordar en 10 min" (o los
///   minutos elegidos en Ajustes).
/// - **Citas**: avisos únicos (ver `RecordatoriosCita`).
/// - **Resumen**: si se pide en "Compartir", un aviso semanal
///   ([diaRecordatorioResumen] a las [horaRecordatorioResumen]) para enviar
///   el PDF a la familia.
/// - **Existencias**: si se lleva la cuenta de las pastillas, un aviso único
///   el día en que dejan de llegar para una semana (ver
///   `CalculoExistencias.momentoDelAviso`). Mientras queden pocas, cada
///   sincronización lo vuelve a programar para el día siguiente.
/// - **Recetas**: igual, una semana antes de que se acabe la receta (ver
///   `Receta`).
///
/// Los avisos día a día se programan para los próximos [diasVentanaMaximos]
/// días como mucho (la app los renueva cada vez que se abre) y la ventana se
/// acorta si hiciera falta para no superar [presupuestoAvisos], ya que
/// Android limita las alarmas por aplicación. Si la ventana no llega al
/// final, el último aviso de toma recuerda abrir la app.
///
/// Rangos de identificadores (todos caben en 32 bits):
/// - aviso de prueba: [idAvisoDePrueba];
/// - recordatorio del resumen: [idRecordatorioResumen];
/// - tomas diarias: `idMedicamento × 100 + toma`;
/// - tomas semanales: `idMedicamento × 100 + 12 + (díaSemana − 1) × 12 +
///   toma` (hasta 95: caben en el mismo rango que las diarias);
/// - citas: `1 000 000 000 + idCita × 10 + tipo`;
/// - existencias: `1 080 000 000 + idMedicamento`;
/// - recetas: `1 085 000 000 + idMedicamento` (los identificadores de los
///   medicamentos no pasan de unos 2 millones: los limitan los de las
///   tomas día a día);
/// - aplazados: `1 090 000 000 + idMedicamento × 12 + toma`;
/// - tomas y repeticiones día a día: `1 100 000 000 + idMedicamento × 512 +
///   (día % 16) × 32 + toma`, y las repeticiones `+ 16`.
abstract final class PlanificadorAvisos {
  static const int idAvisoDePrueba = 1;
  static const int idRecordatorioResumen = 2;

  static const int diaRecordatorioResumen = DateTime.sunday;
  static const HoraDelDia horaRecordatorioResumen = HoraDelDia(18, 0);

  static const int _tomasPorMedicamento = 100;
  static const int _baseCitas = 1000000000;
  static const int _baseExistencias = 1080000000;
  static const int _baseRecetas = 1085000000;
  static const int _baseAplazados = 1090000000;
  static const int _baseTomasConFecha = 1100000000;

  static const int diasVentanaMaximos = 14;
  static const int presupuestoAvisos = 400;

  static String get notaRenovar => textosApp.avisoNotaRenovar;

  static int idToma(int idMedicamento, int indiceToma) =>
      idMedicamento * _tomasPorMedicamento + indiceToma;

  static int idTomaSemanal(int idMedicamento, int diaSemana, int indiceToma) =>
      idToma(idMedicamento, HorarioTomas.maxTomas * diaSemana + indiceToma);

  static int idAvisoCita(int idCita, TipoAvisoCita tipo) =>
      _baseCitas + idCita * 10 + tipo.index;

  static int idExistencias(int idMedicamento) =>
      _baseExistencias + idMedicamento;

  static int idReceta(int idMedicamento) => _baseRecetas + idMedicamento;

  static int idAplazado(int idMedicamento, int indiceToma) =>
      _baseAplazados + idMedicamento * HorarioTomas.maxTomas + indiceToma;

  /// El día se reduce módulo 16 (la ventana, contando el día anterior, nunca
  /// pasa de 15 días), así el mismo aviso conserva su identificador entre
  /// sincronizaciones.
  static int idTomaConFecha(int idMedicamento, DateTime dia, int indiceToma) {
    final diaAbsoluto =
        DateTime.utc(dia.year, dia.month, dia.day).millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
    return _baseTomasConFecha +
        idMedicamento * 512 +
        (diaAbsoluto % 16) * 32 +
        indiceToma;
  }

  static int idRepeticionConFecha(
    int idMedicamento,
    DateTime dia,
    int indiceToma,
  ) => idTomaConFecha(idMedicamento, dia, indiceToma) + 16;

  static List<AvisoProgramado> planificar({
    required List<Medicamento> medicamentos,
    required List<Cita> citas,
    required Ajustes ajustes,
    required DateTime ahora,
    List<RegistroToma> registros = const [],
  }) {
    if (!ajustes.notificacionesActivadas) return const [];

    final hoy = FormatoFechas.soloFecha(ahora);
    final discretos = ajustes.avisosDiscretos;
    // Los de "cuando haga falta" no tienen avisos.
    final activos = [
      for (final m in medicamentos)
        if (!m.terminado(ahora) && !m.aDemanda) m,
    ];

    // Qué tomas llevan aviso recurrente (diario o semanal) y cuáles se avisan
    // día a día.
    final recurrentes = <AvisoProgramado>[];
    final diaADia = <(Medicamento, int)>{};
    for (final m in activos) {
      final horas = m.horasDeToma;
      for (var i = 0; i < horas.length; i++) {
        final hora = horas[i];
        final marcadaAntesDeHora =
            (buscarRegistro(registros, m.id, hoy, hora)?.tomada ?? false) &&
            _momento(hoy, hora).isAfter(ahora);
        if (m.fechaFin != null || marcadaAntesDeHora) {
          diaADia.add((m, i));
          continue;
        }
        switch (m.dias) {
          case TodosLosDias():
            recurrentes.add(
              _toma(
                idToma(m.id, i),
                m,
                hora,
                CadaDia(hora),
                discretos: discretos,
              ),
            );
          case DiasDeLaSemana(:final dias):
            for (final dia in dias) {
              recurrentes.add(
                _toma(
                  idTomaSemanal(m.id, dia, i),
                  m,
                  hora,
                  CadaSemana(dia, hora),
                  discretos: discretos,
                ),
              );
            }
          case CadaVariosDias():
            diaADia.add((m, i));
        }
      }
    }

    final avisosCitas = [
      for (final cita in citas)
        ..._avisosCita(cita, ahora, discretos: discretos),
    ];
    final repeticion = ajustes.minutosRepeticion;
    // También los de "cuando haga falta", que no tienen avisos de tomas.
    final avisosExistencias = [
      for (final m in medicamentos)
        if (!m.terminado(ahora))
          ?_avisoExistencias(m, registros, ahora, discretos: discretos),
    ];
    final avisosRecetas = [
      for (final m in medicamentos)
        ?_avisoReceta(m, ahora, discretos: discretos),
    ];
    final aplazados = [
      for (final m in activos)
        ..._avisosAplazados(m, registros, ahora, discretos: discretos),
    ];
    final dias = diasVentana(
      avisosPorDia:
          (repeticion > 0
              ? activos.fold(0, (total, m) => total + m.numTomas)
              : 0) +
          diaADia.length,
      avisosFijos:
          avisosCitas.length +
          aplazados.length +
          recurrentes.length +
          avisosExistencias.length +
          avisosRecetas.length,
    );

    final aplazamiento = ajustes.minutosAplazamiento;
    return [
          ...recurrentes,
          ..._avisosDiaADia(
            activos,
            diaADia,
            registros,
            ahora,
            dias,
            repeticion,
            discretos: discretos,
          ),
          ...aplazados,
          ...avisosCitas,
          ...avisosExistencias,
          ...avisosRecetas,
          if (ajustes.recordarResumen) _recordatorioResumen(),
        ]
        .map((a) => a.conBotonesDeToma ? a.conAplazamiento(aplazamiento) : a)
        .toList();
  }

  static AvisoProgramado _recordatorioResumen() {
    final t = textosApp;
    return AvisoProgramado(
      id: idRecordatorioResumen,
      tipo: TipoAviso.resumen,
      titulo: t.avisoResumenTitulo,
      cuerpo: t.avisoResumenCuerpo(t.compartirEnviarInforme),
      momento: const CadaSemana(
        diaRecordatorioResumen,
        horaRecordatorioResumen,
      ),
      carga: const CargaResumen().codificar(),
    );
  }

  /// Días que se programan por adelantado con avisos únicos, sin pasar de
  /// [presupuestoAvisos] en total.
  static int diasVentana({
    required int avisosPorDia,
    required int avisosFijos,
  }) {
    if (avisosPorDia == 0) return 0;
    final disponibles = presupuestoAvisos - avisosFijos;
    return (disponibles ~/ avisosPorDia).clamp(1, diasVentanaMaximos);
  }

  /// Si entre [desde] (sin incluir) y [hasta] ha llegado algún aviso de una
  /// toma de [tomas] que sigue sin marcar: el de su hora, su repetición
  /// ([minutosRepeticion] después; 0 si no se repiten) o, si se aplazó, el
  /// del aplazamiento.
  static bool avisoDeTomaSinAtender(
    List<TomaDelDia> tomas, {
    required DateTime desde,
    required DateTime hasta,
    required int minutosRepeticion,
  }) {
    bool entre(DateTime? momento) =>
        momento != null && momento.isAfter(desde) && !momento.isAfter(hasta);
    return tomas.any(
      (t) => switch (t.estado) {
        EstadoTomaDelDia.sinMarcar =>
          entre(t.fechaHora) ||
              minutosRepeticion > 0 &&
                  entre(t.fechaHora.add(Duration(minutes: minutosRepeticion))),
        EstadoTomaDelDia.aplazada => entre(t.registro?.recordarEn),
        EstadoTomaDelDia.pendiente || EstadoTomaDelDia.tomada => false,
      },
    );
  }

  static DateTime _momento(DateTime dia, HoraDelDia hora) =>
      DateTime(dia.year, dia.month, dia.day, hora.hora, hora.minuto);

  /// Con avisos discretos (ver [Ajustes.avisosDiscretos]), los avisos no
  /// dicen el nombre de la medicina, la dosis ni las instrucciones, ni el
  /// motivo y el lugar de la cita, y no llevan la foto: solo la hora y que
  /// se toque el aviso para verlo. El título ya no dice nada ("Hora de tu
  /// medicina").
  static String? _foto(Medicamento m, {required bool discretos}) =>
      discretos ? null : m.foto;

  static String _cuerpoToma(
    Medicamento m,
    HoraDelDia hora, {
    required bool discretos,
  }) {
    final t = textosApp;
    if (discretos) return t.avisoTomaCuerpoDiscreto(hora.texto);
    final dosis = m.dosisDe(hora);
    final toma = dosis == null
        ? t.avisoTomaCuerpo(m.nombre, hora.texto)
        : t.avisoTomaCuerpoConDosis(m.nombre, dosis, hora.texto);
    final instrucciones = m.instrucciones == null
        ? ''
        : ' ${_frase(m.instrucciones!)}';
    return '$toma$instrucciones';
  }

  static String _cuerpoRepeticion(
    Medicamento m,
    HoraDelDia hora, {
    required bool discretos,
  }) {
    final t = textosApp;
    if (discretos) return t.avisoRepeticionCuerpoDiscreto(hora.texto);
    final dosis = m.dosisDe(hora);
    return dosis == null
        ? t.avisoRepeticionCuerpo(hora.texto, m.nombre, t.tomasMarcar)
        : t.avisoRepeticionCuerpoConDosis(
            hora.texto,
            m.nombre,
            dosis,
            t.tomasMarcar,
          );
  }

  static AvisoProgramado _toma(
    int id,
    Medicamento m,
    HoraDelDia hora,
    MomentoAviso momento, {
    required bool discretos,
  }) => AvisoProgramado(
    id: id,
    tipo: TipoAviso.toma,
    titulo: textosApp.avisoTomaTitulo,
    cuerpo: _cuerpoToma(m, hora, discretos: discretos),
    momento: momento,
    carga: CargaToma(medicamentoId: m.id, hora: hora).codificar(),
    foto: _foto(m, discretos: discretos),
  );

  static AvisoProgramado? _avisoExistencias(
    Medicamento m,
    List<RegistroToma> registros,
    DateTime ahora, {
    required bool discretos,
  }) {
    final cuando = CalculoExistencias.momentoDelAviso(m, registros, ahora);
    if (cuando == null) return null;
    final t = textosApp;
    final quedan = CalculoExistencias.estado(m, registros, ahora)!.quedan;
    final boton = t.medicamentoComprarMas;
    final entera = quedan == quedan.roundToDouble();
    return AvisoProgramado(
      id: idExistencias(m.id),
      tipo: TipoAviso.existencias,
      titulo: t.avisoExistenciasTitulo,
      cuerpo: discretos
          ? t.avisoExistenciasCuerpoDiscreto
          : quedan < m.existencias!.menorPorToma
          ? t.avisoExistenciasAcabadas(m.nombre, boton)
          : !m.aDemanda
          ? t.avisoExistenciasSemana(m.nombre, boton)
          : entera
          ? t.avisoExistenciasQuedan(quedan.toInt(), m.nombre, boton)
          : t.avisoExistenciasQuedanYMedia(quedan.floor(), m.nombre, boton),
      momento: UnaVez(cuando),
      carga: CargaExistencias(m.id).codificar(),
      foto: _foto(m, discretos: discretos),
    );
  }

  static AvisoProgramado? _avisoReceta(
    Medicamento m,
    DateTime ahora, {
    required bool discretos,
  }) {
    final cuando = Receta.momentoDelAviso(m, ahora);
    if (cuando == null) return null;
    return AvisoProgramado(
      id: idReceta(m.id),
      tipo: TipoAviso.receta,
      titulo: textosApp.avisoRecetaTitulo,
      cuerpo: discretos
          ? textosApp.avisoRecetaCuerpoDiscreto
          : Receta.cuerpoDelAviso(m, cuando),
      momento: UnaVez(cuando),
      carga: CargaReceta(m.id).codificar(),
      foto: _foto(m, discretos: discretos),
    );
  }

  static Iterable<AvisoProgramado> _avisosAplazados(
    Medicamento m,
    List<RegistroToma> registros,
    DateTime ahora, {
    required bool discretos,
  }) sync* {
    final horas = m.horasDeToma;
    for (final r in registros) {
      if (r.medicamentoId != m.id || r.estado != EstadoToma.aplazada) continue;
      final cuando = r.recordarEn;
      final indice = horas.indexOf(r.hora);
      if (cuando == null || !cuando.isAfter(ahora) || indice < 0) continue;
      yield AvisoProgramado(
        id: idAplazado(m.id, indice),
        tipo: TipoAviso.aplazado,
        titulo: textosApp.avisoAplazadoTitulo,
        cuerpo: _cuerpoToma(m, r.hora, discretos: discretos),
        momento: UnaVez(cuando),
        carga: CargaToma(medicamentoId: m.id, hora: r.hora).codificar(),
        foto: _foto(m, discretos: discretos),
      );
    }
  }

  /// Avisos únicos, día a día: las tomas de [diaADia] y las repeticiones de
  /// todas las tomas ([minutosRepeticion] después; ninguna si es 0),
  /// saltando las que ya tienen registro (tomadas o aplazadas).
  static List<AvisoProgramado> _avisosDiaADia(
    List<Medicamento> medicamentos,
    Set<(Medicamento, int)> diaADia,
    List<RegistroToma> registros,
    DateTime ahora,
    int dias,
    int minutosRepeticion, {
    required bool discretos,
  }) {
    final hoy = FormatoFechas.soloFecha(ahora);
    final avisos = <AvisoProgramado>[];
    for (final m in medicamentos) {
      final delMedicamento = <AvisoProgramado>[];
      final horas = m.horasDeToma;
      // Si el tratamiento sigue después de la ventana, el último aviso de
      // toma recuerda abrir la app para programar los siguientes.
      final alcanzaElFinal = m.terminadoEl(
        DateTime(hoy.year, hoy.month, hoy.day + dias),
      );
      // Se empieza en el día anterior para no perder la repetición de una
      // toma de última hora que cae pasada la medianoche.
      for (var d = -1; d < dias; d++) {
        final dia = DateTime(hoy.year, hoy.month, hoy.day + d);
        if (m.terminadoEl(dia)) break;
        // Un día que no toca (los martes de una medicina de los lunes) se
        // salta, pero la ventana sigue.
        if (!m.dias.incluye(dia)) continue;
        for (var i = 0; i < horas.length; i++) {
          final hora = horas[i];
          if (buscarRegistro(registros, m.id, dia, hora) != null) continue;
          final momento = _momento(dia, hora);
          if (diaADia.contains((m, i)) && momento.isAfter(ahora)) {
            delMedicamento.add(
              _toma(
                idTomaConFecha(m.id, dia, i),
                m,
                hora,
                UnaVez(momento),
                discretos: discretos,
              ),
            );
          }
          if (minutosRepeticion == 0) continue;
          final repeticion = momento.add(Duration(minutes: minutosRepeticion));
          if (repeticion.isAfter(ahora)) {
            delMedicamento.add(
              AvisoProgramado(
                id: idRepeticionConFecha(m.id, dia, i),
                tipo: TipoAviso.repeticion,
                titulo: textosApp.avisoRepeticionTitulo,
                cuerpo: _cuerpoRepeticion(m, hora, discretos: discretos),
                momento: UnaVez(repeticion),
                carga: CargaToma(medicamentoId: m.id, hora: hora).codificar(),
                foto: _foto(m, discretos: discretos),
              ),
            );
          }
        }
      }
      // Si la ventana no llega al último día con tomas avisadas día a día, el
      // último aviso de toma recuerda abrir la app para programar los
      // siguientes.
      final ultimo = delMedicamento.lastIndexWhere(
        (a) => a.tipo == TipoAviso.toma,
      );
      if (!alcanzaElFinal && ultimo >= 0) {
        final aviso = delMedicamento[ultimo];
        delMedicamento[ultimo] = AvisoProgramado(
          id: aviso.id,
          tipo: aviso.tipo,
          titulo: aviso.titulo,
          cuerpo: '${aviso.cuerpo} $notaRenovar',
          momento: aviso.momento,
          carga: aviso.carga,
          foto: aviso.foto,
        );
      }
      avisos.addAll(delMedicamento);
    }
    return avisos;
  }

  static Iterable<AvisoProgramado> _avisosCita(
    Cita cita,
    DateTime ahora, {
    required bool discretos,
  }) sync* {
    final t = textosApp;
    final lugar = (cita.lugar ?? '').trim();
    final detalle = discretos
        ? t.avisoCitaCuerpoDiscreto(cita.hora.texto)
        : lugar.isEmpty
        ? t.avisoCitaCuerpo(cita.titulo, cita.hora.texto)
        : t.avisoCitaCuerpoConLugar(cita.titulo, cita.hora.texto, lugar);
    for (final aviso in RecordatoriosCita.calcular(cita, ahora: ahora)) {
      yield AvisoProgramado(
        id: idAvisoCita(cita.id, aviso.tipo),
        tipo: TipoAviso.cita,
        titulo: switch (aviso.tipo) {
          TipoAvisoCita.diaAntes => t.avisoCitaManana,
          TipoAvisoCita.mismoDia => t.avisoCitaHoy,
          TipoAvisoCita.unaHoraAntes => t.avisoCitaUnaHora,
        },
        cuerpo: detalle,
        momento: UnaVez(aviso.fechaHora),
        carga: CargaCita(cita.id).codificar(),
      );
    }
  }

  /// "con el desayuno" → "Con el desayuno." (con un solo punto final).
  static String _frase(String texto) {
    var limpio = texto.trim();
    while (limpio.endsWith('.')) {
      limpio = limpio.substring(0, limpio.length - 1).trimRight();
    }
    if (limpio.isEmpty) return '';
    return '${limpio[0].toUpperCase()}${limpio.substring(1)}.';
  }
}
