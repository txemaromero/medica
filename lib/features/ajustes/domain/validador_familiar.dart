import '../../../l10n/textos.dart';
import 'validador_telefono.dart';

class ErroresFamiliar {
  const ErroresFamiliar({this.nombre, this.numero});

  final String? nombre;
  final String? numero;

  bool get sinErrores => nombre == null && numero == null;
}

/// Validación del contacto de un familiar. Con los dos campos vacíos el
/// contacto se borra; si se rellena uno, hace falta el otro.
abstract final class ValidadorFamiliar {
  static const int maxNombre = 40;

  static ErroresFamiliar validar({
    required String nombre,
    required String numero,
  }) {
    final n = nombre.trim();
    final t = numero.trim();
    if (n.isEmpty && t.isEmpty) return const ErroresFamiliar();
    return ErroresFamiliar(
      nombre: n.isEmpty
          ? textosApp.validadorFamiliarNombreVacio
          : n.length > maxNombre
          ? textosApp.validadorFamiliarNombreLargo('$maxNombre')
          : null,
      numero: t.isEmpty
          ? textosApp.validadorFamiliarNumeroVacio
          : ValidadorTelefono.validar(t),
    );
  }
}
