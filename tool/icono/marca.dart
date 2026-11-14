import 'package:flutter/material.dart';

/// Colores y símbolo de la marca, comunes al icono de la app y a los
/// recursos de Google Play.
///
/// Fondo del tema predeterminado y, encima, un azul marino con un contraste
/// de 11:1: el frasco se reconoce de un vistazo, también con poca vista.
abstract final class Marca {
  static const Color fondo = Color(0xFFB6D8FF);
  static const Color simbolo = Color(0xFF0A2540);
  static const IconData icono = Icons.medication;

  /// Tamaño del frasco respecto al lado del icono.
  static const double proporcionSimbolo = 880 / 1024;
}
