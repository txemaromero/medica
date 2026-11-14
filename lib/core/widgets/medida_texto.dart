import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Utilidades para decidir la disposición de un widget según el ancho real
/// que ocupa el texto con el escalado actual (ajuste del usuario × sistema).
///
/// Permiten, por ejemplo, pasar de dos columnas a una cuando una palabra no
/// cabe entera, en lugar de partirla o cortarla.
abstract final class MedidaTexto {
  static double anchoLinea(
    BuildContext context,
    String texto,
    TextStyle estilo,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: texto, style: estilo),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final ancho = painter.width;
    painter.dispose();
    return ancho;
  }

  static double palabraMasLarga(
    BuildContext context,
    String texto,
    TextStyle estilo,
  ) {
    var maximo = 0.0;
    for (final palabra in texto.split(RegExp(r'\s+'))) {
      if (palabra.isEmpty) continue;
      maximo = math.max(maximo, anchoLinea(context, palabra, estilo));
    }
    return maximo;
  }

  /// `true` si ninguna palabra de [texto] necesita más de [anchoDisponible].
  static bool cabeSinPartirPalabras(
    BuildContext context,
    String texto,
    TextStyle estilo,
    double anchoDisponible,
  ) => palabraMasLarga(context, texto, estilo) <= anchoDisponible;
}
