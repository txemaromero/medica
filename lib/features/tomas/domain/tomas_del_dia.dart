import '../../../core/texto/ordenacion.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../medicamentos/domain/medicamento.dart';
import 'registro_toma.dart';

enum EstadoTomaDelDia {
  tomada,

  /// Aplazada y todavía sin tomar: se volverá a avisar.
  aplazada,

  /// Aún no ha llegado su hora.
  pendiente,

  /// Ya pasó su hora y no está marcada.
  sinMarcar,
}

/// Una toma prevista para un día, con lo que se sabe de ella.
class TomaDelDia {
  const TomaDelDia({
    required this.medicamento,
    required this.fecha,
    required this.hora,
    required this.estado,
    this.registro,
  });

  final Medicamento medicamento;
  final DateTime fecha;
  final HoraDelDia hora;
  final EstadoTomaDelDia estado;
  final RegistroToma? registro;

  DateTime get fechaHora =>
      DateTime(fecha.year, fecha.month, fecha.day, hora.hora, hora.minuto);
}

abstract final class TomasDelDia {
  /// Tomas previstas para [dia] según los medicamentos guardados, ordenadas
  /// por hora. Solo cuentan los medicamentos que ya existían ese día y cuyo
  /// tratamiento no había terminado; los de "cuando haga falta" no tienen
  /// tomas previstas.
  static List<TomaDelDia> calcular({
    required List<Medicamento> medicamentos,
    required List<RegistroToma> registros,
    required DateTime dia,
    required DateTime ahora,
  }) {
    final fecha = FormatoFechas.soloFecha(dia);
    final tomas = <TomaDelDia>[];
    for (final m in medicamentos) {
      if (FormatoFechas.soloFecha(m.fechaCreacion).isAfter(fecha)) continue;
      if (!m.seTomaEl(fecha)) continue;
      for (final hora in m.horasDeToma) {
        final registro = buscarRegistro(registros, m.id, fecha, hora);
        final momento = DateTime(
          fecha.year,
          fecha.month,
          fecha.day,
          hora.hora,
          hora.minuto,
        );
        tomas.add(
          TomaDelDia(
            medicamento: m,
            fecha: fecha,
            hora: hora,
            registro: registro,
            estado: switch (registro?.estado) {
              EstadoToma.tomada => EstadoTomaDelDia.tomada,
              EstadoToma.aplazada => EstadoTomaDelDia.aplazada,
              null =>
                momento.isAfter(ahora)
                    ? EstadoTomaDelDia.pendiente
                    : EstadoTomaDelDia.sinMarcar,
            },
          ),
        );
      }
    }
    tomas.sort((a, b) {
      final porHora = a.hora.compareTo(b.hora);
      return porHora != 0
          ? porHora
          : compararTextos(a.medicamento.nombre, b.medicamento.nombre);
    });
    return tomas;
  }

  /// Registros de [dia] que ya no corresponden a ninguna toma prevista (el
  /// medicamento se eliminó o cambió de horario): el historial los muestra
  /// aparte para no perderlos. No cuentan las tomas de los [medicamentos]
  /// "cuando haga falta", que nunca tienen toma prevista (ver
  /// [tomasADemanda]).
  static List<RegistroToma> registrosSueltos({
    required List<TomaDelDia> tomas,
    required List<RegistroToma> registros,
    required DateTime dia,
    List<Medicamento> medicamentos = const [],
  }) {
    final fecha = FormatoFechas.soloFecha(dia);
    final aDemanda = _idsADemanda(medicamentos);
    return [
      for (final r in registros)
        if (r.tomada &&
            FormatoFechas.soloFecha(r.fecha) == fecha &&
            !aDemanda.contains(r.medicamentoId) &&
            !tomas.any((t) => t.registro == r))
          r,
    ]..sort((a, b) => a.hora.compareTo(b.hora));
  }

  /// Cuántas tomas se han marcado en los últimos [dias] días (hoy incluido)
  /// de las que ya tocaban: las pendientes no cuentan, y las que no
  /// corresponden a ninguna toma prevista (ver [registrosSueltos]) cuentan
  /// como marcadas. Las de "cuando haga falta" no entran.
  static ({int tomadas, int total}) resumen({
    required List<Medicamento> medicamentos,
    required List<RegistroToma> registros,
    required DateTime ahora,
    int dias = 7,
  }) {
    final hoy = FormatoFechas.soloFecha(ahora);
    var tomadas = 0;
    var total = 0;
    for (var d = 0; d < dias; d++) {
      final dia = DateTime(hoy.year, hoy.month, hoy.day - d);
      final tomas = calcular(
        medicamentos: medicamentos,
        registros: registros,
        dia: dia,
        ahora: ahora,
      );
      final sueltos = registrosSueltos(
        tomas: tomas,
        registros: registros,
        dia: dia,
        medicamentos: medicamentos,
      ).length;
      tomadas +=
          tomas.where((t) => t.estado == EstadoTomaDelDia.tomada).length +
          sueltos;
      total +=
          tomas.where((t) => t.estado != EstadoTomaDelDia.pendiente).length +
          sueltos;
    }
    return (tomadas: tomadas, total: total);
  }

  /// Porcentaje redondeado de [tomadas] sobre [total].
  static int porcentaje(int tomadas, int total) =>
      total == 0 ? 0 : (tomadas * 100 / total).round();

  /// Medicamentos "cuando haga falta" que se pueden anotar en [dia] (ya
  /// existían y no había terminado el tratamiento), por nombre.
  static List<Medicamento> medicamentosADemanda(
    List<Medicamento> medicamentos,
    DateTime dia,
  ) {
    final fecha = FormatoFechas.soloFecha(dia);
    return [
      for (final m in medicamentos)
        if (m.aDemanda &&
            !FormatoFechas.soloFecha(m.fechaCreacion).isAfter(fecha) &&
            !m.terminadoEl(fecha))
          m,
    ]..sort((a, b) => compararTextos(a.nombre, b.nombre));
  }

  /// Lo que se anotó en [dia] de los medicamentos "cuando haga falta" (su
  /// hora es la de la toma), por hora.
  static List<RegistroToma> tomasADemanda({
    required List<Medicamento> medicamentos,
    required List<RegistroToma> registros,
    required DateTime dia,
  }) {
    final fecha = FormatoFechas.soloFecha(dia);
    final aDemanda = _idsADemanda(medicamentos);
    return [
      for (final r in registros)
        if (r.tomada &&
            aDemanda.contains(r.medicamentoId) &&
            FormatoFechas.soloFecha(r.fecha) == fecha)
          r,
    ]..sort((a, b) => a.hora.compareTo(b.hora));
  }

  static Set<int> _idsADemanda(List<Medicamento> medicamentos) => {
    for (final m in medicamentos)
      if (m.aDemanda) m.id,
  };
}
