import '../../../core/tiempo/formato_fechas.dart';
import '../../medicamentos/domain/medicamento.dart';
import 'registro_toma.dart';

/// Cómo va un medicamento "cuando haga falta" respecto a sus límites
/// (`Medicamento.maximoAlDia` y `Medicamento.horasEntreTomas`).
class EstadoLimites {
  const EstadoLimites({
    required this.tomadasHoy,
    this.maximoAlcanzado = false,
    this.proximaDesde,
  });

  /// Veces que se ha tomado hoy.
  final int tomadasHoy;

  /// Hoy ya se ha tomado las veces que se puede, o más.
  final bool maximoAlcanzado;

  /// Si aún no han pasado las horas mínimas desde la última toma, cuándo se
  /// cumplen (puede ser mañana).
  final DateTime? proximaDesde;

  /// Si se puede tomar ahora sin pasarse de los límites.
  bool get dentroDeLosLimites => !maximoAlcanzado && proximaDesde == null;

  @override
  bool operator ==(Object other) =>
      other is EstadoLimites &&
      other.tomadasHoy == tomadasHoy &&
      other.maximoAlcanzado == maximoAlcanzado &&
      other.proximaDesde == proximaDesde;

  @override
  int get hashCode => Object.hash(tomadasHoy, maximoAlcanzado, proximaDesde);

  @override
  String toString() =>
      'EstadoLimites($tomadasHoy hoy${maximoAlcanzado ? ', máximo' : ''}'
      '${proximaDesde == null ? '' : ', desde $proximaDesde'})';
}

/// Los límites cuentan días del calendario (como "Hoy lo has tomado 2
/// veces") y, para el tiempo entre tomas, la última anotada aunque fuera
/// ayer por la noche. La app no impide anotar una toma de más: avisa antes,
/// porque lo anotado tiene que ser lo que de verdad se ha tomado.
abstract final class LimitesADemanda {
  /// [registros] deben incluir los de ayer, por si la última toma fue antes
  /// de la medianoche.
  static EstadoLimites estado(
    Medicamento m,
    List<RegistroToma> registros,
    DateTime ahora,
  ) {
    final hoy = FormatoFechas.soloFecha(ahora);
    final tomadas = [
      for (final r in registros)
        if (r.medicamentoId == m.id && r.tomada && !r.momento.isAfter(ahora)) r,
    ];
    final tomadasHoy = tomadas
        .where((r) => FormatoFechas.soloFecha(r.fecha) == hoy)
        .length;
    DateTime? proximaDesde;
    final horas = m.horasEntreTomas;
    if (horas != null && tomadas.isNotEmpty) {
      // Desde la hora anotada (la que se ve en "Tomas de hoy"), sin segundos.
      final ultima = tomadas
          .map(
            (r) => DateTime(
              r.fecha.year,
              r.fecha.month,
              r.fecha.day,
              r.hora.hora,
              r.hora.minuto,
            ),
          )
          .reduce((a, b) => a.isAfter(b) ? a : b);
      final siguiente = ultima.add(Duration(hours: horas));
      if (siguiente.isAfter(ahora)) proximaDesde = siguiente;
    }
    final maximo = m.maximoAlDia;
    return EstadoLimites(
      tomadasHoy: tomadasHoy,
      maximoAlcanzado: maximo != null && tomadasHoy >= maximo,
      proximaDesde: proximaDesde,
    );
  }
}
