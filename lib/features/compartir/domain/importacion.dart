import '../../../core/texto/ordenacion.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../l10n/textos.dart';
import '../../agenda/domain/cita.dart';
import '../../medicamentos/domain/medicamento.dart';
import 'copia_de_seguridad.dart';

/// Lo que se añade al traer los medicamentos y las citas de otro móvil (una
/// copia de seguridad que ha preparado un familiar), sin borrar nada:
/// - los medicamentos que no se tienen se añaden;
/// - los que ya se tienen (con el mismo nombre) se ponen como en la copia,
///   conservando sus tomas anotadas;
/// - las citas que no se tienen y no han pasado se añaden.
///
/// Las tomas anotadas y los ajustes de la copia no se usan.
class Importacion {
  const Importacion({
    required this.nuevos,
    required this.actualizados,
    required this.citas,
  });

  factory Importacion.calcular({
    required CopiaDeSeguridad copia,
    required List<Medicamento> medicamentos,
    required List<Cita> citas,
    required DateTime ahora,
  }) {
    final nuevos = <Medicamento>[];
    final actualizados = <({Medicamento actual, Medicamento deLaCopia})>[];
    for (final m in copia.medicamentos) {
      final actual = medicamentos
          .where((a) => _mismoTexto(a.nombre, m.nombre))
          .firstOrNull;
      if (actual == null) {
        nuevos.add(m);
      } else {
        actualizados.add((actual: actual, deLaCopia: m));
      }
    }
    return Importacion(
      nuevos: nuevos,
      actualizados: actualizados,
      citas: [
        for (final c in copia.citas)
          if (!c.yaHaPasado(ahora) && !citas.any((a) => _mismaCita(a, c))) c,
      ],
    );
  }

  final List<Medicamento> nuevos;

  /// Los de la copia que ya se tenían, con el que había en el teléfono.
  final List<({Medicamento actual, Medicamento deLaCopia})> actualizados;

  final List<Cita> citas;

  bool get vacia => nuevos.isEmpty && actualizados.isEmpty && citas.isEmpty;

  /// Qué se va a hacer, para preguntar antes: una frase por línea.
  List<String> describir() {
    final t = textosApp;
    return [
      if (nuevos.isNotEmpty)
        t.importarSeAnadiran(
          FormatoFechas.lista([for (final m in nuevos) m.nombre]),
        ),
      if (actualizados.isNotEmpty)
        t.importarSeActualizaran(
          actualizados.length,
          FormatoFechas.lista([
            for (final (:actual, deLaCopia: _) in actualizados) actual.nombre,
          ]),
        ),
      if (citas.isNotEmpty)
        t.importarCitas(FormatoFechas.lista([for (final c in citas) c.titulo])),
    ];
  }

  static bool _mismoTexto(String a, String b) =>
      compararTextos(a.trim(), b.trim()) == 0;

  static bool _mismaCita(Cita a, Cita b) =>
      _mismoTexto(a.titulo, b.titulo) &&
      FormatoFechas.soloFecha(a.fecha) == FormatoFechas.soloFecha(b.fecha) &&
      a.hora == b.hora;
}
