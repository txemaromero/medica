import '../../../l10n/textos.dart';

/// Validación básica del número de emergencia.
///
/// Acepta números cortos de emergencia (112, 061…) y números completos,
/// con prefijo internacional opcional. Se ignoran espacios, guiones y puntos.
abstract final class ValidadorTelefono {
  static const int minCifras = 3;
  static const int maxCifras = 15;

  static String limpiar(String entrada) =>
      entrada.replaceAll(RegExp(r'[\s\-.()]'), '');

  /// Devuelve `null` si el número es válido o un mensaje que explica cómo
  /// corregirlo.
  static String? validar(String entrada) {
    final numero = limpiar(entrada);
    if (numero.isEmpty) {
      return textosApp.validadorTelefonoVacio;
    }
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(numero)) {
      return textosApp.validadorTelefonoSoloNumeros;
    }
    final cifras = numero.replaceAll('+', '').length;
    if (cifras < minCifras) {
      return textosApp.validadorTelefonoCorto('$minCifras');
    }
    if (cifras > maxCifras) {
      return textosApp.validadorTelefonoLargo;
    }
    return null;
  }
}
