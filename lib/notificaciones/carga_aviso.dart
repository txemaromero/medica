import '../core/tiempo/formato_fechas.dart';
import '../core/tiempo/hora_del_dia.dart';

/// Datos que viajan dentro de cada notificación para saber, cuando la
/// persona la toca o pulsa uno de sus botones, a qué se refiere.
///
/// Los avisos no incluyen la fecha: un aviso diario es el mismo todos los
/// días, y el día de la toma se deduce de la hora (ver
/// `HoraDelDia.ultimoDiaHasta`). El widget de la pantalla de inicio sí la
/// manda.
sealed class CargaAviso {
  const CargaAviso();

  static const String _separador = '|';

  String codificar();

  static CargaAviso? decodificar(String? texto) {
    final partes = texto?.split(_separador) ?? const <String>[];
    try {
      return switch (partes) {
        ['toma', final id, final minutos] => CargaToma(
          medicamentoId: int.parse(id),
          hora: HoraDelDia.desdeMinutos(int.parse(minutos)),
        ),
        ['toma', final id, final minutos, final fecha] => CargaToma(
          medicamentoId: int.parse(id),
          hora: HoraDelDia.desdeMinutos(int.parse(minutos)),
          fecha: FormatoFechas.desdeIsoFecha(fecha),
        ),
        ['cita', final id] => CargaCita(int.parse(id)),
        ['existencias', final id] => CargaExistencias(int.parse(id)),
        ['receta', final id] => CargaReceta(int.parse(id)),
        ['resumen'] => const CargaResumen(),
        _ => null,
      };
    } on Object {
      // Cualquier carga mal formada se ignora: un número que no lo es
      // (FormatException) o una fecha a medias como `2026-10` (RangeError).
      return null;
    }
  }
}

class CargaToma extends CargaAviso {
  const CargaToma({
    required this.medicamentoId,
    required this.hora,
    this.fecha,
  });

  final int medicamentoId;

  /// Hora prevista de la toma (no la del aviso, que puede ser una repetición
  /// o un recordatorio aplazado).
  final HoraDelDia hora;

  /// Día de la toma, si se sabe (solo lo manda el widget).
  final DateTime? fecha;

  @override
  String codificar() => [
    'toma',
    medicamentoId,
    hora.minutosDesdeMedianoche,
    if (fecha != null) FormatoFechas.isoFecha(fecha!),
  ].join(CargaAviso._separador);

  @override
  bool operator ==(Object other) =>
      other is CargaToma &&
      other.medicamentoId == medicamentoId &&
      other.hora == hora &&
      other.fecha == fecha;

  @override
  int get hashCode => Object.hash(medicamentoId, hora, fecha);
}

class CargaCita extends CargaAviso {
  const CargaCita(this.citaId);

  final int citaId;

  @override
  String codificar() => ['cita', citaId].join(CargaAviso._separador);

  @override
  bool operator ==(Object other) =>
      other is CargaCita && other.citaId == citaId;

  @override
  int get hashCode => citaId.hashCode;
}

/// Aviso de que quedan pocas pastillas de un medicamento.
class CargaExistencias extends CargaAviso {
  const CargaExistencias(this.medicamentoId);

  final int medicamentoId;

  @override
  String codificar() =>
      ['existencias', medicamentoId].join(CargaAviso._separador);

  @override
  bool operator ==(Object other) =>
      other is CargaExistencias && other.medicamentoId == medicamentoId;

  @override
  int get hashCode => medicamentoId.hashCode;
}

/// Aviso de que hay que renovar la receta de un medicamento.
class CargaReceta extends CargaAviso {
  const CargaReceta(this.medicamentoId);

  final int medicamentoId;

  @override
  String codificar() => ['receta', medicamentoId].join(CargaAviso._separador);

  @override
  bool operator ==(Object other) =>
      other is CargaReceta && other.medicamentoId == medicamentoId;

  @override
  int get hashCode => medicamentoId.hashCode;
}

/// Recordatorio semanal de enviar el resumen a la familia.
class CargaResumen extends CargaAviso {
  const CargaResumen();

  @override
  String codificar() => 'resumen';

  @override
  bool operator ==(Object other) => other is CargaResumen;

  @override
  int get hashCode => 0;
}

/// Botones de los avisos de tomas.
abstract final class AccionesAviso {
  static const String tomada = 'tomada';
  static const String aplazar = 'aplazar';
}

/// Lo que llega de la notificación: qué botón se pulsó (o `null` si se tocó
/// la notificación) y su carga.
class RespuestaAviso {
  const RespuestaAviso({this.accion, this.carga});

  final String? accion;
  final String? carga;
}
