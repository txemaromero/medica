import '../core/tiempo/formato_fechas.dart';
import '../features/medicamentos/domain/medicamento.dart';
import '../features/tomas/domain/registro_toma.dart';
import '../features/tomas/domain/tomas_del_dia.dart';
import '../l10n/textos.dart';
import '../notificaciones/carga_aviso.dart';

/// Lo que necesita el widget de la pantalla de inicio ("Próxima toma"): las
/// tomas de los próximos [dias] días, con los textos ya preparados. Así el
/// widget elige la que toca según la hora aunque la app no esté abierta (ver
/// `WidgetToma.kt`):
/// - si hoy hay una sin marcar cuya hora ya ha llegado, esa, con el botón
///   "Ya la he tomado";
/// - si no, la siguiente sin marcar, sin botón.
abstract final class DatosWidget {
  static const int dias = 7;

  static Map<String, Object?> calcular({
    required List<Medicamento> medicamentos,
    required List<RegistroToma> registros,
    required DateTime ahora,
  }) {
    final t = textosApp;
    final hoy = FormatoFechas.soloFecha(ahora);
    return {
      'titulo': t.widgetTitulo,
      'boton': t.tomasMarcar,
      'vacio': t.widgetVacio,
      'tomas': [
        for (var d = 0; d < dias; d++)
          for (final toma in TomasDelDia.calcular(
            medicamentos: medicamentos,
            registros: registros,
            dia: DateTime(hoy.year, hoy.month, hoy.day + d),
            ahora: ahora,
          ))
            _toma(toma),
      ],
    };
  }

  static Map<String, Object?> _toma(TomaDelDia toma) {
    final t = textosApp;
    final momento = toma.fechaHora;
    final nombre = toma.medicamento.nombre;
    // "Hoy a las…", "Mañana a las…" o la fecha, según el día en que se vea.
    String cuando(int diasAntes) => FormatoFechas.conMayuscula(
      FormatoFechas.cuando(
        momento,
        DateTime(momento.year, momento.month, momento.day - diasAntes),
      ),
    );
    return {
      'momento': momento.millisecondsSinceEpoch,
      'fecha': FormatoFechas.isoFecha(toma.fecha),
      'nombre': nombre,
      'tomada': toma.estado == EstadoTomaDelDia.tomada,
      'carga': CargaToma(
        medicamentoId: toma.medicamento.id,
        hora: toma.hora,
        fecha: toma.fecha,
      ).codificar(),
      'pasada': t.tomasEstadoSinMarcar(toma.hora.texto),
      'hoy': cuando(0),
      'manana': cuando(1),
      'otroDia': cuando(2),
      'semantica': t.tomasMarcarSemantica(nombre, toma.hora.texto),
    };
  }
}
