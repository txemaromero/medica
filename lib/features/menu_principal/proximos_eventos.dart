import '../../core/tiempo/formato_fechas.dart';
import '../../core/tiempo/hora_del_dia.dart';
import '../agenda/domain/cita.dart';
import '../medicamentos/domain/dias_de_toma.dart';
import '../medicamentos/domain/medicamento.dart';
import '../tomas/domain/registro_toma.dart';

class ProximaToma {
  const ProximaToma(this.medicamento, this.fechaHora);

  final Medicamento medicamento;
  final DateTime fechaHora;
}

/// Próxima toma y próxima cita, para el resumen del menú principal.
abstract final class ProximosEventos {
  /// Hasta cuántos días se busca: lo más que puede tardar en tocar una
  /// medicina de "cada varios días".
  static const int _diasABuscar = CadaVariosDias.maximo;

  /// La toma más cercana de los tratamientos que siguen activos, o `null` si
  /// no queda ninguna. Las tomas que ya se han marcado como tomadas (por
  /// ejemplo, por adelantado) no cuentan. Una medicina de algunos días de la
  /// semana o de cada varios días puede no tocar hasta dentro de unos días.
  static ProximaToma? proximaToma(
    List<Medicamento> medicamentos,
    DateTime ahora, {
    List<RegistroToma> registros = const [],
  }) {
    final hoy = FormatoFechas.soloFecha(ahora);
    ProximaToma? mejor;
    for (final medicamento in medicamentos) {
      if (medicamento.aDemanda) continue;
      for (var d = 0; d <= _diasABuscar; d++) {
        final dia = DateTime(hoy.year, hoy.month, hoy.day + d);
        if (medicamento.terminadoEl(dia)) break;
        if (!medicamento.dias.incluye(dia)) continue;
        bool tomada(HoraDelDia hora) =>
            buscarRegistro(registros, medicamento.id, dia, hora)?.tomada ??
            false;
        final pendientes = [
          for (final hora in medicamento.horasDeToma)
            if (!tomada(hora))
              DateTime(dia.year, dia.month, dia.day, hora.hora, hora.minuto),
        ].where((momento) => momento.isAfter(ahora)).toList()..sort();
        if (pendientes.isEmpty) continue;
        if (mejor == null || pendientes.first.isBefore(mejor.fechaHora)) {
          mejor = ProximaToma(medicamento, pendientes.first);
        }
        break;
      }
    }
    return mejor;
  }

  /// La primera cita que todavía no ha pasado, o `null`.
  static Cita? proximaCita(List<Cita> citas, DateTime ahora) {
    for (final cita in ordenarCronologicamente(citas)) {
      if (!cita.yaHaPasado(ahora)) return cita;
    }
    return null;
  }
}
