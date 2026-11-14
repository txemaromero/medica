import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';

/// Cálculo de las horas de toma de un medicamento a partir de la hora de
/// inicio, el número de tomas al día y la frecuencia en horas.
///
/// Las tomas se repiten cada día, así que todas deben caber en 24 horas:
/// `numTomas × frecuenciaHoras ≤ 24`.
abstract final class HorarioTomas {
  static const int minTomas = 1;
  static const int maxTomas = 12;

  /// Con una sola toma al día la frecuencia es, por definición, de 24 horas.
  static const int frecuenciaUnaToma = 24;

  /// Mayor frecuencia (en horas) posible para que [numTomas] quepan en un día.
  static int frecuenciaMaxima(int numTomas) =>
      numTomas <= 1 ? frecuenciaUnaToma : 24 ~/ numTomas;

  /// Frecuencia que se propone al elegir el número de tomas: repartirlas
  /// por igual a lo largo del día (2 tomas → cada 12 h, 3 → cada 8 h…).
  static int frecuenciaSugerida(int numTomas) => frecuenciaMaxima(numTomas);

  static bool esFrecuenciaValida(int numTomas, int frecuenciaHoras) {
    if (numTomas < minTomas || numTomas > maxTomas) return false;
    if (numTomas == 1) return frecuenciaHoras == frecuenciaUnaToma;
    return frecuenciaHoras >= 1 && numTomas * frecuenciaHoras <= 24;
  }

  /// Horas del día en las que hay que tomar el medicamento, en el orden
  /// en que se toman empezando por [horaInicio].
  static List<HoraDelDia> calcular({
    required HoraDelDia horaInicio,
    required int numTomas,
    required int frecuenciaHoras,
  }) {
    if (!esFrecuenciaValida(numTomas, frecuenciaHoras)) {
      throw ArgumentError(
        'Combinación no válida: $numTomas tomas cada $frecuenciaHoras horas',
      );
    }
    return [
      for (var i = 0; i < numTomas; i++)
        horaInicio.sumarMinutos(i * frecuenciaHoras * 60),
    ];
  }

  /// Descripción corta, por ejemplo `3 tomas al día, cada 8 horas`.
  static String describir(int numTomas, int frecuenciaHoras) =>
      textosApp.horarioDescripcion(numTomas, '$frecuenciaHoras');

  /// Con horas elegidas una a una no hay frecuencia: `3 tomas al día`.
  static String describirLibres(int numTomas) =>
      textosApp.horarioDescripcionLibre(numTomas);
}
