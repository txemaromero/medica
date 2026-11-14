import '../core/tiempo/formato_fechas.dart';
import '../core/tiempo/hora_del_dia.dart';
import '../features/agenda/domain/cita.dart';
import '../features/medicamentos/domain/medicamento.dart';
import '../features/tomas/domain/tomas_del_dia.dart';
import '../l10n/textos.dart';

/// Frases que se leen en voz alta. Están pensadas para oírse: frases cortas,
/// la hora con la parte del día y sin abreviaturas.
abstract final class TextosParaLeer {
  static String _detalle(Medicamento m, HoraDelDia hora) {
    final dosis = m.dosisDe(hora);
    final medicamento = dosis == null
        ? textosApp.vozMedicamento(m.nombre)
        : textosApp.vozMedicamentoConDosis(m.nombre, dosis);
    final instrucciones = m.instrucciones == null
        ? ''
        : ' ${_frase(m.instrucciones!)}';
    return '$medicamento$instrucciones';
  }

  /// Al abrir la app tocando el aviso de una toma.
  static String toma(Medicamento m, HoraDelDia hora) => textosApp.vozToma(
    FormatoFechas.horaConParteDelDia(hora),
    _detalle(m, hora),
    textosApp.tomasMarcar,
  );

  /// Al abrir la app tocando el aviso de una cita.
  static String cita(Cita cita, DateTime ahora) {
    final lugar = (cita.lugar ?? '').trim();
    final cuando = FormatoFechas.cuando(cita.fechaHora, ahora);
    return lugar.isEmpty
        ? textosApp.vozCita(cita.titulo, cuando)
        : textosApp.vozCitaConLugar(cita.titulo, cuando, lugar);
  }

  /// Resumen de "Tomas de hoy": cuántas hay, cuántas se han tomado y cuáles
  /// faltan.
  static String tomasDeHoy(List<TomaDelDia> tomas) {
    final t = textosApp;
    if (tomas.isEmpty) return t.vozSinTomas;
    final tomadas = tomas
        .where((toma) => toma.estado == EstadoTomaDelDia.tomada)
        .length;
    final total = t.vozTotalTomas(tomas.length);
    if (tomadas == tomas.length) return t.vozTodasTomadas(total);
    final faltan = [
      for (final toma in tomas)
        if (toma.estado != EstadoTomaDelDia.tomada) _faltante(t, toma),
    ];
    return '${t.vozHasTomado(total, '$tomadas')} '
        '${t.vozTeFaltan(faltan.length, faltan.join(' '))}';
  }

  static String _faltante(TextosApp t, TomaDelDia toma) {
    final hora = FormatoFechas.horaConParteDelDia(toma.hora);
    final dosis = toma.medicamento.dosisDe(toma.hora);
    final nombre = dosis == null
        ? toma.medicamento.nombre
        : t.vozNombreConDosis(toma.medicamento.nombre, dosis);
    return switch (toma.estado) {
      EstadoTomaDelDia.sinMarcar => t.vozFaltanteSinMarcar(nombre, hora),
      EstadoTomaDelDia.aplazada => t.vozFaltanteAplazada(nombre, hora),
      EstadoTomaDelDia.pendiente ||
      EstadoTomaDelDia.tomada => t.vozFaltantePendiente(nombre, hora),
    };
  }

  /// "con el desayuno" → "Con el desayuno." (con un solo punto final).
  static String _frase(String texto) {
    var limpio = texto.trim();
    while (limpio.endsWith('.')) {
      limpio = limpio.substring(0, limpio.length - 1).trimRight();
    }
    if (limpio.isEmpty) return '';
    return '${limpio[0].toUpperCase()}${limpio.substring(1)}.';
  }
}
