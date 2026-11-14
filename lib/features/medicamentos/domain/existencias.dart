import 'dart:math' as math;

import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';
import '../../tomas/domain/registro_toma.dart';
import 'medicamento.dart';

/// Cuenta de las pastillas (o cápsulas, sobres…) de un medicamento: cuántas
/// había en el momento [contadas] y cuántas se toman cada vez, la misma
/// cantidad en todas las tomas ([porToma]) o una distinta en cada una
/// ([porTomas]). Se cuentan medias pastillas: todas las cantidades son
/// múltiplos de [paso].
///
/// Las que quedan no se guardan: se calculan cada vez (ver
/// [CalculoExistencias]), así que marcar, desmarcar o deshacer una toma
/// nunca descuadra la cuenta.
class Existencias {
  const Existencias({
    required this.cantidad,
    required this.contadas,
    this.porToma = 1,
    this.porTomas,
  });

  static const double maximo = 9999;
  static const double maximoPorToma = 10;
  static const double paso = 0.5;

  final double cantidad;
  final DateTime contadas;
  final double porToma;

  /// Si cambian según la hora, las de cada toma, en el orden de las horas de
  /// toma; `null` si en todas se toman [porToma].
  final List<double>? porTomas;

  /// Las que se toman en la toma [indice] (en el orden de las horas).
  double enLaToma(int indice) {
    final lista = porTomas;
    return lista != null && indice < lista.length ? lista[indice] : porToma;
  }

  /// La toma más pequeña: si quedan menos, ya no llegan para ninguna.
  double get menorPorToma => porTomas?.reduce(math.min) ?? porToma;

  /// Si [n] es una cantidad posible: entre [minimo] y [maximo], en medias.
  static bool esValida(
    double n, {
    double minimo = 0,
    double maximo = Existencias.maximo,
  }) => n >= minimo && n <= maximo && (n * 2) == (n * 2).roundToDouble();

  /// Para escribirla en un campo: "14" o "14,5".
  static String numero(double n) =>
      n == n.roundToDouble() ? '${n.toInt()}' : '${n.floor()},5';

  /// Lee lo escrito en un campo: "14", "14,5" o "14.5". `null` si no es un
  /// número de pastillas (con media como mucho).
  static double? leer(String texto) {
    final coincide = RegExp(r'^(\d{1,4})(?:[.,]([05]))?$')
        .firstMatch(texto.trim());
    if (coincide == null) return null;
    final enteras = double.parse(coincide.group(1)!);
    return coincide.group(2) == '5' ? enteras + paso : enteras;
  }

  /// Corto, para los botones + y −: "media", "1", "1 y media".
  static String corto(double n) {
    final t = textosApp;
    if (n == n.roundToDouble()) return '${n.toInt()}';
    return n < 1 ? t.existenciasMedia : t.existenciasYMedia('${n.floor()}');
  }

  /// "media pastilla", "1 pastilla", "14 pastillas y media".
  static String describir(double n) {
    final t = textosApp;
    return n == n.roundToDouble()
        ? t.existenciasPastillas(n.toInt())
        : t.existenciasPastillasYMedia(n.floor());
  }

  @override
  bool operator ==(Object other) =>
      other is Existencias &&
      other.cantidad == cantidad &&
      other.contadas == contadas &&
      other.porToma == porToma &&
      other.porTomas?.join(',') == porTomas?.join(',');

  @override
  int get hashCode =>
      Object.hash(cantidad, contadas, porToma, porTomas?.join(','));

  @override
  String toString() =>
      'Existencias($cantidad el $contadas, '
      '${porTomas == null ? '$porToma' : porTomas!.join(' / ')} por toma)';
}

/// Cómo van las existencias de un medicamento en un momento dado.
class EstadoExistencias {
  const EstadoExistencias({
    required this.quedan,
    this.dias,
    this.hastaElFinal = false,
    this.pocas = false,
  });

  final double quedan;

  /// Para cuántos días llegan, más o menos, si se sabe: no en los de
  /// "cuando haga falta", ni si llegan hasta el final del tratamiento o para
  /// más de [CalculoExistencias.diasMaximos].
  final int? dias;

  /// Llegan hasta el último día del tratamiento.
  final bool hastaElFinal;

  /// No llegan para [CalculoExistencias.diasDeAviso] días (o, en los de
  /// "cuando haga falta", quedan [CalculoExistencias.pocasADemanda] o menos).
  final bool pocas;

  /// Por ejemplo, "Quedan 20 pastillas, para unos 20 días".
  String describir() {
    final t = textosApp;
    final quedanTexto = quedan == quedan.roundToDouble()
        ? t.existenciasQuedan(quedan.toInt())
        : t.existenciasQuedanYMedia(quedan.floor());
    final detalle = hastaElFinal
        ? t.existenciasHastaElFinal
        : (dias ?? 0) > 0
        ? t.existenciasParaDias(dias!)
        : null;
    return detalle == null
        ? quedanTexto
        : t.existenciasConDetalle(quedanTexto, detalle);
  }

  @override
  bool operator ==(Object other) =>
      other is EstadoExistencias &&
      other.quedan == quedan &&
      other.dias == dias &&
      other.hastaElFinal == hastaElFinal &&
      other.pocas == pocas;

  @override
  int get hashCode => Object.hash(quedan, dias, hastaElFinal, pocas);

  @override
  String toString() =>
      'EstadoExistencias($quedan, $dias días${hastaElFinal ? ', hasta el final' : ''}${pocas ? ', pocas' : ''})';
}

/// Cálculo de las existencias a partir de la cuenta, la pauta y lo anotado:
/// - cada toma prevista se descuenta al llegar su hora, o al marcarla si se
///   marca antes (aunque no se marque: así, quien se olvida de marcar no se
///   queda sin pastillas sin aviso; si se salta tomas, el aviso llega antes);
/// - en los de "cuando haga falta", se descuenta cada toma anotada.
abstract final class CalculoExistencias {
  /// Se avisa cuando no llegan para una semana.
  static const int diasDeAviso = 7;

  /// En los de "cuando haga falta", cuando quedan estas o menos.
  static const int pocasADemanda = 5;

  /// Hasta dónde se mira hacia delante: unos tres años.
  static const int diasMaximos = 1100;

  /// Hora del aviso de "Te quedan pocas pastillas".
  static const HoraDelDia horaDelAviso = HoraDelDia(10, 0);

  /// Desde qué día hacen falta los registros de tomas para calcular las
  /// existencias de [medicamentos], o `null` si ninguno lleva la cuenta.
  static DateTime? registrosDesde(Iterable<Medicamento> medicamentos) {
    DateTime? desde;
    for (final m in medicamentos) {
      final contadas = m.existencias?.contadas;
      if (contadas == null) continue;
      final dia = FormatoFechas.soloFecha(contadas);
      if (desde == null || dia.isBefore(desde)) desde = dia;
    }
    return desde;
  }

  /// Cómo van las existencias de [m] en [ahora], o `null` si no lleva la
  /// cuenta. [registros] deben incluir los de [registrosDesde] en adelante.
  static EstadoExistencias? estado(
    Medicamento m,
    List<RegistroToma> registros,
    DateTime ahora,
  ) {
    final e = m.existencias;
    if (e == null) return null;
    final registrosDe = _registrosDe(m, registros);
    final quedan = _quedan(m, e, registrosDe, ahora);
    if (m.aDemanda) {
      return EstadoExistencias(quedan: quedan, pocas: quedan <= pocasADemanda);
    }
    final (:primera, :primeraCubierta) = _cobertura(
      m,
      e,
      quedan,
      registrosDe,
      ahora,
    );
    if (primera == null) {
      return EstadoExistencias(
        quedan: quedan,
        hastaElFinal: m.fechaFin != null,
      );
    }
    // Los días se cuentan desde el de la primera toma que se puede tomar:
    // por la noche, con la de hoy ya tomada, cuenta desde mañana.
    return EstadoExistencias(
      quedan: quedan,
      dias: primeraCubierta == null
          ? 0
          : _diasEntre(
              FormatoFechas.soloFecha(primeraCubierta),
              FormatoFechas.soloFecha(primera),
            ),
      pocas: primera.isBefore(_sumarDias(ahora, diasDeAviso)),
    );
  }

  /// Cuándo avisar de que quedan pocas: a las [horaDelAviso] del día en que
  /// dejan de llegar para [diasDeAviso] días, contando con que se toman
  /// todas las previstas, o la próxima vez que lleguen las [horaDelAviso] si
  /// ya quedan pocas. `null` si no hay que avisar.
  static DateTime? momentoDelAviso(
    Medicamento m,
    List<RegistroToma> registros,
    DateTime ahora,
  ) {
    final e = m.existencias;
    if (e == null) return null;
    final registrosDe = _registrosDe(m, registros);
    final quedan = _quedan(m, e, registrosDe, ahora);
    final DateTime desde;
    if (m.aDemanda) {
      if (quedan > pocasADemanda) return null;
      desde = ahora;
    } else {
      final primera = _cobertura(m, e, quedan, registrosDe, ahora).primera;
      if (primera == null) return null;
      desde = _sumarDias(primera, -diasDeAviso);
    }
    final aviso = _aLaHoraDelAviso(desde);
    if (aviso.isAfter(ahora)) return aviso;
    // Ya quedan pocas: la próxima vez que lleguen las [horaDelAviso].
    final hoy = _aLaHoraDelAviso(ahora);
    return hoy.isAfter(ahora) ? hoy : _sumarDias(hoy, 1);
  }

  static Map<(String, HoraDelDia), RegistroToma> _registrosDe(
    Medicamento m,
    List<RegistroToma> registros,
  ) => {
    for (final r in registros)
      if (r.medicamentoId == m.id) (FormatoFechas.isoFecha(r.fecha), r.hora): r,
  };

  /// Cuándo se tomó (o se tomará) una toma prevista: a su hora o, si se
  /// marcó antes, al marcarla.
  static DateTime _consumo(DateTime prevista, RegistroToma? registro) =>
      registro != null && registro.tomada && registro.momento.isBefore(prevista)
      ? registro.momento
      : prevista;

  static double _quedan(
    Medicamento m,
    Existencias e,
    Map<(String, HoraDelDia), RegistroToma> registros,
    DateTime ahora,
  ) {
    bool cuenta(DateTime consumo) =>
        consumo.isAfter(e.contadas) && !consumo.isAfter(ahora);
    var tomadas = 0.0;
    if (m.aDemanda) {
      tomadas =
          registros.values.where((r) => r.tomada && cuenta(r.momento)).length *
          e.porToma;
    } else {
      final hoy = FormatoFechas.soloFecha(ahora);
      final horas = m.horasDeToma;
      for (
        var dia = FormatoFechas.soloFecha(e.contadas);
        !dia.isAfter(hoy);
        dia = _sumarDias(dia, 1)
      ) {
        if (!m.seTomaEl(dia)) continue;
        for (final (i, hora) in horas.indexed) {
          final prevista = _momento(dia, hora);
          final registro = registros[(FormatoFechas.isoFecha(dia), hora)];
          if (cuenta(_consumo(prevista, registro))) tomadas += e.enLaToma(i);
        }
      }
    }
    return math.max(0, e.cantidad - tomadas);
  }

  /// Hasta dónde llegan las que quedan, si se toman todas las tomas
  /// previstas: la primera toma que ya no se podrá tomar ([primera]; `null`
  /// si llegan hasta el final del tratamiento o para más de [diasMaximos]
  /// días) y la primera que sí ([primeraCubierta]; `null` si no llegan ni
  /// para la siguiente).
  static ({DateTime? primera, DateTime? primeraCubierta}) _cobertura(
    Medicamento m,
    Existencias e,
    double quedan,
    Map<(String, HoraDelDia), RegistroToma> registros,
    DateTime ahora,
  ) {
    var restantes = quedan;
    DateTime? primeraCubierta;
    final hoy = FormatoFechas.soloFecha(ahora);
    for (var d = 0; d <= diasMaximos; d++) {
      final dia = _sumarDias(hoy, d);
      if (m.terminadoEl(dia)) break;
      if (!m.seTomaEl(dia)) continue;
      for (final (i, hora) in m.horasDeToma.indexed) {
        final prevista = _momento(dia, hora);
        final registro = registros[(FormatoFechas.isoFecha(dia), hora)];
        // Las ya descontadas no cuentan.
        if (!_consumo(prevista, registro).isAfter(ahora)) continue;
        final enEsta = e.enLaToma(i);
        if (restantes < enEsta) {
          return (primera: prevista, primeraCubierta: primeraCubierta);
        }
        primeraCubierta ??= prevista;
        restantes -= enEsta;
      }
    }
    return (primera: null, primeraCubierta: primeraCubierta);
  }

  static DateTime _momento(DateTime dia, HoraDelDia hora) =>
      DateTime(dia.year, dia.month, dia.day, hora.hora, hora.minuto);

  static DateTime _aLaHoraDelAviso(DateTime dia) => _momento(dia, horaDelAviso);

  /// Mismo momento, [dias] días después (cuenta días del calendario, no
  /// horas, por los cambios de hora).
  static DateTime _sumarDias(DateTime momento, int dias) => DateTime(
    momento.year,
    momento.month,
    momento.day + dias,
    momento.hour,
    momento.minute,
  );

  static int _diasEntre(DateTime desde, DateTime hasta) => DateTime.utc(
    hasta.year,
    hasta.month,
    hasta.day,
  ).difference(DateTime.utc(desde.year, desde.month, desde.day)).inDays;
}
