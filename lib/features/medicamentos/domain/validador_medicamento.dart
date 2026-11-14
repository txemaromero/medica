import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';
import 'dias_de_toma.dart';
import 'existencias.dart';
import 'horario_tomas.dart';

/// Errores del formulario de medicamento, uno por campo. Cada mensaje explica
/// el problema y cómo resolverlo.
class ErroresMedicamento {
  const ErroresMedicamento({
    this.nombre,
    this.dosis,
    this.instrucciones,
    this.numTomas,
    this.frecuencia,
    this.horaInicio,
    this.horas,
    this.dias,
    this.fechaFin,
    this.existencias,
  });

  final String? nombre;
  final String? dosis;
  final String? instrucciones;
  final String? numTomas;
  final String? frecuencia;
  final String? horaInicio;

  /// Las horas elegidas una a una.
  final String? horas;

  /// Los días de toma.
  final String? dias;

  final String? fechaFin;

  /// Las pastillas que se tienen, si se lleva la cuenta.
  final String? existencias;

  bool get sinErrores =>
      nombre == null &&
      dosis == null &&
      instrucciones == null &&
      numTomas == null &&
      frecuencia == null &&
      horaInicio == null &&
      horas == null &&
      dias == null &&
      fechaFin == null &&
      existencias == null;
}

abstract final class ValidadorMedicamento {
  static const int longitudMaximaNombre = 60;
  static const int longitudMaximaDosis = 40;
  static const int longitudMaximaInstrucciones = 100;

  static ErroresMedicamento validar({
    required String nombre,
    required int? numTomas,
    required int? frecuenciaHoras,
    required HoraDelDia? horaInicio,
    required DateTime ahora,
    String dosis = '',
    List<String>? dosisPorToma,
    String instrucciones = '',
    DateTime? fechaFin,
    List<HoraDelDia>? horasLibres,
    DiasDeToma dias = const TodosLosDias(),
    String? existencias,
  }) {
    final t = textosApp;
    final nombreLimpio = nombre.trim();
    String? errorNombre;
    if (nombreLimpio.isEmpty) {
      errorNombre = t.validadorMedicamentoNombreVacio;
    } else if (nombreLimpio.length > longitudMaximaNombre) {
      errorNombre = t.validadorMedicamentoNombreLargo('$longitudMaximaNombre');
    }

    String? errorTomas;
    String? errorFrecuencia;
    String? errorHoras;
    final cuantas = horasLibres?.length ?? numTomas;
    if (cuantas == null ||
        cuantas < HorarioTomas.minTomas ||
        cuantas > HorarioTomas.maxTomas) {
      errorTomas = t.validadorMedicamentoTomas(
        '${HorarioTomas.minTomas}',
        '${HorarioTomas.maxTomas}',
      );
    } else if (horasLibres != null) {
      if (horasLibres.toSet().length != horasLibres.length) {
        errorHoras = t.validadorMedicamentoHorasRepetidas;
      }
    } else if (frecuenciaHoras == null ||
        !HorarioTomas.esFrecuenciaValida(cuantas, frecuenciaHoras)) {
      errorFrecuencia = cuantas == 1
          ? t.validadorMedicamentoFrecuenciaUnaToma
          : t.validadorMedicamentoFrecuencia(
              '$cuantas',
              '${HorarioTomas.frecuenciaMaxima(cuantas)}',
            );
    }
    final errorDias = switch (dias) {
      DiasDeLaSemana(:final dias) when dias.isEmpty =>
        t.validadorMedicamentoSinDias,
      CadaVariosDias(:final cada)
          when cada < CadaVariosDias.minimo || cada > CadaVariosDias.maximo =>
        t.validadorMedicamentoCadaDias(
          '${CadaVariosDias.minimo}',
          '${CadaVariosDias.maximo}',
        ),
      _ => null,
    };

    final cantidad = existencias == null ? null : Existencias.leer(existencias);
    final errorExistencias =
        existencias != null &&
            (cantidad == null || !Existencias.esValida(cantidad))
        ? t.validadorMedicamentoExistencias(
            Existencias.numero(Existencias.maximo),
          )
        : null;

    final hoy = FormatoFechas.soloFecha(ahora);
    return ErroresMedicamento(
      nombre: errorNombre,
      dosis:
          [
            dosis,
            ...?dosisPorToma,
          ].any((d) => d.trim().length > longitudMaximaDosis)
          ? t.validadorMedicamentoDosisLarga('$longitudMaximaDosis')
          : null,
      instrucciones: instrucciones.trim().length > longitudMaximaInstrucciones
          ? t.validadorMedicamentoInstruccionesLargas(
              '$longitudMaximaInstrucciones',
            )
          : null,
      numTomas: errorTomas,
      frecuencia: errorFrecuencia,
      horaInicio: horaInicio == null ? t.validadorMedicamentoHoraInicio : null,
      horas: errorHoras,
      dias: errorDias,
      fechaFin:
          fechaFin != null && FormatoFechas.soloFecha(fechaFin).isBefore(hoy)
          ? t.validadorMedicamentoFechaFinPasada(t.formularioMedicamentoSiempre)
          : null,
      existencias: errorExistencias,
    );
  }
}
