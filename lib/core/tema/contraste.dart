import 'dart:math' as math;
import 'dart:ui' show Color;

/// Cálculo del ratio de contraste según WCAG 2.x.
///
/// AA exige ≥ 4,5:1 para texto normal y AAA ≥ 7:1.
abstract final class Contraste {
  static const double minimoAA = 4.5;
  static const double minimoAAA = 7.0;

  /// Contraste mínimo para componentes gráficos (bordes, iconos), WCAG 1.4.11.
  static const double minimoComponentes = 3.0;

  static double luminanciaRelativa(Color color) {
    double canal(double c) => c <= 0.03928
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * canal(color.r) +
        0.7152 * canal(color.g) +
        0.0722 * canal(color.b);
  }

  static double ratio(Color a, Color b) {
    final la = luminanciaRelativa(a);
    final lb = luminanciaRelativa(b);
    final claro = math.max(la, lb);
    final oscuro = math.min(la, lb);
    return (claro + 0.05) / (oscuro + 0.05);
  }
}
