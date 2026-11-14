import '../../../core/tiempo/hora_del_dia.dart';

/// Cita médica (u otra) apuntada en la agenda.
class Cita {
  const Cita({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.hora,
    this.lugar,
    this.notas,
  });

  final int id;

  /// Motivo de la cita, por ejemplo "Médico de cabecera".
  final String titulo;

  /// Día de la cita (la parte de la hora se ignora).
  final DateTime fecha;

  final HoraDelDia hora;
  final String? lugar;
  final String? notas;

  DateTime get fechaHora =>
      DateTime(fecha.year, fecha.month, fecha.day, hora.hora, hora.minuto);

  bool yaHaPasado(DateTime ahora) => !fechaHora.isAfter(ahora);

  /// Misma cita (mismo `id`) con otros datos; se usa al modificarla.
  Cita conDatos(NuevaCita datos) {
    String? opcional(String? texto) {
      final limpio = texto?.trim() ?? '';
      return limpio.isEmpty ? null : limpio;
    }

    return Cita(
      id: id,
      titulo: datos.titulo.trim(),
      fecha: DateTime(datos.fecha.year, datos.fecha.month, datos.fecha.day),
      hora: datos.hora,
      lugar: opcional(datos.lugar),
      notas: opcional(datos.notas),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Cita &&
      other.id == id &&
      other.titulo == titulo &&
      other.fechaHora == fechaHora &&
      other.lugar == lugar &&
      other.notas == notas;

  @override
  int get hashCode => Object.hash(id, titulo, fechaHora, lugar, notas);

  @override
  String toString() => 'Cita($id, $titulo, $fechaHora)';
}

/// Datos de una cita antes de guardarla (todavía sin `id`).
class NuevaCita {
  const NuevaCita({
    required this.titulo,
    required this.fecha,
    required this.hora,
    this.lugar,
    this.notas,
  });

  final String titulo;
  final DateTime fecha;
  final HoraDelDia hora;
  final String? lugar;
  final String? notas;
}

/// Ordena las citas de la más próxima a la más lejana.
List<Cita> ordenarCronologicamente(Iterable<Cita> citas) =>
    citas.toList()..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
