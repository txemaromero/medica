import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';

class ErroresCita {
  const ErroresCita({
    this.titulo,
    this.fecha,
    this.hora,
    this.lugar,
    this.notas,
  });

  final String? titulo;
  final String? fecha;
  final String? hora;
  final String? lugar;
  final String? notas;

  bool get sinErrores =>
      titulo == null &&
      fecha == null &&
      hora == null &&
      lugar == null &&
      notas == null;
}

abstract final class ValidadorCita {
  static const int longitudMaximaTitulo = 80;
  static const int longitudMaximaLugar = 100;
  static const int longitudMaximaNotas = 300;

  static ErroresCita validar({
    required String titulo,
    required DateTime? fecha,
    required HoraDelDia? hora,
    required String lugar,
    required String notas,
    required DateTime ahora,
  }) {
    final t = textosApp;
    final tituloLimpio = titulo.trim();
    String? errorTitulo;
    if (tituloLimpio.isEmpty) {
      errorTitulo = t.validadorCitaMotivoVacio;
    } else if (tituloLimpio.length > longitudMaximaTitulo) {
      errorTitulo = t.validadorCitaMotivoLargo('$longitudMaximaTitulo');
    }

    String? errorFecha;
    String? errorHora;
    if (fecha == null) {
      errorFecha = t.validadorCitaDia;
    }
    if (hora == null) {
      errorHora = t.validadorCitaHora;
    }
    if (fecha != null && hora != null) {
      final momento = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hora,
        hora.minuto,
      );
      if (!momento.isAfter(ahora)) {
        final hoy = DateTime(ahora.year, ahora.month, ahora.day);
        final dia = DateTime(fecha.year, fecha.month, fecha.day);
        if (dia.isBefore(hoy)) {
          errorFecha = t.validadorCitaDiaPasado;
        } else {
          errorHora = t.validadorCitaHoraPasada;
        }
      }
    }

    return ErroresCita(
      titulo: errorTitulo,
      fecha: errorFecha,
      hora: errorHora,
      lugar: lugar.trim().length > longitudMaximaLugar
          ? t.validadorCitaLugarLargo('$longitudMaximaLugar')
          : null,
      notas: notas.trim().length > longitudMaximaNotas
          ? t.validadorCitaNotasLargas('$longitudMaximaNotas')
          : null,
    );
  }
}
