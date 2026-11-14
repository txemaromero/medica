import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';

enum EstadoToma {
  /// La persona ha indicado que ya la ha tomado.
  tomada,

  /// Ha pedido que se le recuerde más tarde ([RegistroToma.recordarEn]).
  aplazada,
}

/// Lo que la persona ha hecho con una toma concreta: un medicamento, un día
/// y una hora prevista. Solo existe un registro por toma.
class RegistroToma {
  const RegistroToma({
    required this.medicamentoId,
    required this.nombreMedicamento,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.momento,
    this.recordarEn,
  });

  final int medicamentoId;

  /// Nombre en el momento de registrar la toma, para que el historial se
  /// siga entendiendo aunque el medicamento se renombre o se elimine.
  final String nombreMedicamento;

  /// Día de la toma (sin hora).
  final DateTime fecha;

  /// Hora prevista de la toma.
  final HoraDelDia hora;

  final EstadoToma estado;

  /// Cuándo se marcó como tomada o se aplazó.
  final DateTime momento;

  /// Solo en las aplazadas: cuándo hay que volver a avisar.
  final DateTime? recordarEn;

  bool get tomada => estado == EstadoToma.tomada;

  bool esDe(int idMedicamento, DateTime dia, HoraDelDia horaPrevista) =>
      medicamentoId == idMedicamento &&
      hora == horaPrevista &&
      FormatoFechas.soloFecha(fecha) == FormatoFechas.soloFecha(dia);

  @override
  bool operator ==(Object other) =>
      other is RegistroToma &&
      other.medicamentoId == medicamentoId &&
      other.nombreMedicamento == nombreMedicamento &&
      FormatoFechas.soloFecha(other.fecha) == FormatoFechas.soloFecha(fecha) &&
      other.hora == hora &&
      other.estado == estado &&
      other.momento == momento &&
      other.recordarEn == recordarEn;

  @override
  int get hashCode => Object.hash(
    medicamentoId,
    nombreMedicamento,
    FormatoFechas.soloFecha(fecha),
    hora,
    estado,
    momento,
    recordarEn,
  );

  @override
  String toString() =>
      'RegistroToma($medicamentoId, ${FormatoFechas.isoFecha(fecha)} '
      '$hora, $estado)';
}

/// Busca el registro de una toma concreta, si lo hay.
RegistroToma? buscarRegistro(
  Iterable<RegistroToma> registros,
  int medicamentoId,
  DateTime dia,
  HoraDelDia hora,
) {
  for (final r in registros) {
    if (r.esDe(medicamentoId, dia, hora)) return r;
  }
  return null;
}
