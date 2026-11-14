import '../../../core/tiempo/hora_del_dia.dart';
import 'cita.dart';

enum TipoAvisoCita {
  /// Aviso por la mañana del mismo día de la cita.
  mismoDia,

  /// Aviso una hora antes de la cita.
  unaHoraAntes,

  /// Aviso la tarde del día anterior, para prepararla con tiempo (va el
  /// último para no cambiar los identificadores de los otros dos).
  diaAntes,
}

class AvisoCita {
  const AvisoCita(this.tipo, this.fechaHora);

  final TipoAvisoCita tipo;
  final DateTime fechaHora;

  @override
  bool operator ==(Object other) =>
      other is AvisoCita && other.tipo == tipo && other.fechaHora == fechaHora;

  @override
  int get hashCode => Object.hash(tipo, fechaHora);

  @override
  String toString() => 'AvisoCita($tipo, $fechaHora)';
}

/// Recordatorios previos de una cita: la tarde del día anterior, el mismo
/// día por la mañana y una hora antes. Solo se generan los que todavía no
/// han pasado, y el de la mañana se omite si coincidiría con el de una hora
/// antes o sería posterior a él. El del día anterior siempre va antes que
/// los otros dos (una cita a las 00:00 avisa una hora antes a las 23:00).
abstract final class RecordatoriosCita {
  static const HoraDelDia horaAvisoDiaAntes = HoraDelDia(18, 0);
  static const HoraDelDia horaAvisoMismoDia = HoraDelDia(8, 0);
  static const Duration antelacion = Duration(hours: 1);

  static List<AvisoCita> calcular(Cita cita, {required DateTime ahora}) {
    final unaHoraAntes = cita.fechaHora.subtract(antelacion);
    final mismoDia = DateTime(
      cita.fecha.year,
      cita.fecha.month,
      cita.fecha.day,
      horaAvisoMismoDia.hora,
      horaAvisoMismoDia.minuto,
    );
    final diaAntes = DateTime(
      cita.fecha.year,
      cita.fecha.month,
      cita.fecha.day - 1,
      horaAvisoDiaAntes.hora,
      horaAvisoDiaAntes.minuto,
    );

    return [
      if (diaAntes.isAfter(ahora)) AvisoCita(TipoAvisoCita.diaAntes, diaAntes),
      if (mismoDia.isBefore(unaHoraAntes) && mismoDia.isAfter(ahora))
        AvisoCita(TipoAvisoCita.mismoDia, mismoDia),
      if (unaHoraAntes.isAfter(ahora))
        AvisoCita(TipoAvisoCita.unaHoraAntes, unaHoraAntes),
    ];
  }
}
