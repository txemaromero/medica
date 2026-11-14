import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';
import 'medicamento.dart';

/// Cuándo hay que renovar la receta de un medicamento
/// (`Medicamento.renovarReceta`, su último día):
/// - se avisa a las [horaDelAviso] [diasDeAviso] días antes, para que dé
///   tiempo a pedir cita con el médico;
/// - si ya ha llegado ese día (o la receta se ha acabado), cada vez que se
///   abre la app el aviso se programa para las [horaDelAviso] siguientes,
///   como el de las pastillas que quedan, hasta que se ponga la fecha nueva;
/// - si el tratamiento termina antes que la receta (o ese mismo día), no hace
///   falta renovarla.
abstract final class Receta {
  static const int diasDeAviso = 7;
  static const HoraDelDia horaDelAviso = HoraDelDia(10, 0);

  /// Si hay que tener en cuenta la receta de [m]: tiene fecha y el
  /// tratamiento sigue después de ella.
  static bool cuenta(Medicamento m, DateTime ahora) {
    final receta = m.renovarReceta;
    if (receta == null || m.terminado(ahora)) return false;
    final fin = m.fechaFin;
    return fin == null || fin.isAfter(receta);
  }

  /// Días que quedan hasta el último día de la receta (0 si es hoy;
  /// negativo si ya se acabó).
  static int diasQuedan(Medicamento m, DateTime ahora) =>
      _diasEntre(ahora, m.renovarReceta!);

  /// Se acaba dentro de [diasDeAviso] días o menos, o ya se acabó.
  static bool hayQueRenovar(Medicamento m, DateTime ahora) =>
      cuenta(m, ahora) && diasQuedan(m, ahora) <= diasDeAviso;

  /// Cuándo avisar, o `null` si no hay que avisar.
  static DateTime? momentoDelAviso(Medicamento m, DateTime ahora) {
    if (!cuenta(m, ahora)) return null;
    final receta = m.renovarReceta!;
    final aviso = _aLaHoraDelAviso(
      DateTime(receta.year, receta.month, receta.day - diasDeAviso),
    );
    if (aviso.isAfter(ahora)) return aviso;
    // Ya es hora de renovarla: la próxima vez que lleguen las 10:00.
    final hoy = _aLaHoraDelAviso(ahora);
    return hoy.isAfter(ahora)
        ? hoy
        : _aLaHoraDelAviso(DateTime(ahora.year, ahora.month, ahora.day + 1));
  }

  /// Lo que dice la tarjeta del medicamento: "Receta: hasta el…" o, si hay
  /// que renovarla, cuándo se acaba.
  static String describir(Medicamento m, DateTime ahora) {
    final t = textosApp;
    final fecha = FormatoFechas.fechaLarga(m.renovarReceta!);
    if (!hayQueRenovar(m, ahora)) return t.medicamentoRecetaHasta(fecha);
    final dias = diasQuedan(m, ahora);
    return dias < 0
        ? t.medicamentoRecetaAcabada(fecha)
        : t.medicamentoRecetaPronto(dias);
  }

  /// El texto del aviso que llega el día [dia].
  static String cuerpoDelAviso(Medicamento m, DateTime dia) {
    final t = textosApp;
    final receta = m.renovarReceta!;
    final fecha = FormatoFechas.fechaLarga(receta);
    final dias = _diasEntre(dia, receta);
    if (dias > 0) return t.avisoRecetaCuerpo(m.nombre, fecha);
    if (dias == 0) return t.avisoRecetaCuerpoHoy(m.nombre);
    return t.avisoRecetaCuerpoAcabada(m.nombre, fecha);
  }

  static DateTime _aLaHoraDelAviso(DateTime dia) => DateTime(
    dia.year,
    dia.month,
    dia.day,
    horaDelAviso.hora,
    horaDelAviso.minuto,
  );

  static int _diasEntre(DateTime desde, DateTime hasta) => DateTime.utc(
    hasta.year,
    hasta.month,
    hasta.day,
  ).difference(DateTime.utc(desde.year, desde.month, desde.day)).inDays;
}
