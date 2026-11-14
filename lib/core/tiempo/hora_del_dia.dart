/// Hora del día (sin fecha) en formato de 24 horas.
///
/// Se usa en lugar de `TimeOfDay` para que el dominio no dependa de Flutter.
class HoraDelDia implements Comparable<HoraDelDia> {
  const HoraDelDia(this.hora, this.minuto)
    : assert(hora >= 0 && hora < 24),
      assert(minuto >= 0 && minuto < 60);

  /// Crea una hora a partir de los minutos transcurridos desde medianoche.
  /// Los valores fuera de 0–1439 dan la vuelta al reloj.
  factory HoraDelDia.desdeMinutos(int minutosDesdeMedianoche) {
    final minutos = minutosDesdeMedianoche % minutosPorDia;
    return HoraDelDia(minutos ~/ 60, minutos % 60);
  }

  static const int minutosPorDia = 24 * 60;

  final int hora;
  final int minuto;

  int get minutosDesdeMedianoche => hora * 60 + minuto;

  /// Próxima vez que llega esta hora a partir de [ahora]: hoy si aún no ha
  /// llegado, o mañana.
  DateTime siguienteDesde(DateTime ahora) {
    final hoy = DateTime(ahora.year, ahora.month, ahora.day, hora, minuto);
    if (hoy.isAfter(ahora)) return hoy;
    return DateTime(ahora.year, ahora.month, ahora.day + 1, hora, minuto);
  }

  /// Día de la última vez que llegó esta hora, como muy tarde [ahora]: hoy si
  /// ya ha pasado, o ayer. Sirve para saber a qué día pertenece una toma
  /// cuando se responde a su aviso (un aviso de las 23:45 contestado a las
  /// 00:10 es del día anterior).
  DateTime ultimoDiaHasta(DateTime ahora) {
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final hoyALaHora = DateTime(hoy.year, hoy.month, hoy.day, hora, minuto);
    return hoyALaHora.isAfter(ahora)
        ? DateTime(hoy.year, hoy.month, hoy.day - 1)
        : hoy;
  }

  HoraDelDia sumarMinutos(int minutos) =>
      HoraDelDia.desdeMinutos(minutosDesdeMedianoche + minutos);

  /// Texto en formato `HH:MM`, por ejemplo `08:05`.
  String get texto =>
      '${hora.toString().padLeft(2, '0')}:${minuto.toString().padLeft(2, '0')}';

  @override
  int compareTo(HoraDelDia other) =>
      minutosDesdeMedianoche.compareTo(other.minutosDesdeMedianoche);

  @override
  bool operator ==(Object other) =>
      other is HoraDelDia && other.hora == hora && other.minuto == minuto;

  @override
  int get hashCode => Object.hash(hora, minuto);

  @override
  String toString() => texto;
}
