import 'package:flutter/material.dart';

import '../../features/ajustes/domain/ajustes.dart';
import 'paleta.dart';

/// Medidas y estilos comunes del sistema de diseño.
abstract final class Medidas {
  /// Área táctil mínima exigida (48 dp) y recomendada para acciones
  /// principales (64 dp).
  static const double tactilMinimo = 48;
  static const double tactilPrincipal = 64;

  static const double margen = 16;
  static const double separacion = 20;
  static const double grosorBorde = 2.5;
  static const double grosorSeleccion = 5;
  static const double radio = 16;

  static const double iconoBoton = 40;
  static const double iconoTarjeta = 72;
}

/// Construye el `ThemeData` de cada tema con tipografía Montserrat.
///
/// Los tamaños de texto están pensados para el tamaño base de 20 pt; el
/// ajuste del usuario los escala todos a la vez mediante `TextScaler`.
abstract final class TemaVisual {
  static const String fuente = 'Montserrat';
  static const double tamanoBase = 20;
  static const double interlineado = 1.4;

  static TextTheme textos(Color color) {
    TextStyle estilo(double tamano, FontWeight peso, {double? altura}) =>
        TextStyle(
          fontFamily: fuente,
          fontSize: tamano,
          fontWeight: peso,
          height: altura ?? interlineado,
          color: color,
          letterSpacing: 0.2,
        );

    return TextTheme(
      displaySmall: estilo(32, FontWeight.w800, altura: 1.25),
      headlineMedium: estilo(28, FontWeight.w700, altura: 1.25),
      headlineSmall: estilo(26, FontWeight.w700, altura: 1.25),
      titleLarge: estilo(24, FontWeight.w700, altura: 1.3),
      titleMedium: estilo(22, FontWeight.w700, altura: 1.3),
      titleSmall: estilo(20, FontWeight.w700),
      bodyLarge: estilo(tamanoBase, FontWeight.w500),
      bodyMedium: estilo(tamanoBase, FontWeight.w500),
      // No hay "texto pequeño": los estilos pequeños de Material también
      // usan el tamaño base.
      bodySmall: estilo(tamanoBase, FontWeight.w500),
      labelLarge: estilo(22, FontWeight.w700, altura: 1.3),
      labelMedium: estilo(tamanoBase, FontWeight.w600),
      labelSmall: estilo(tamanoBase, FontWeight.w600),
    );
  }

  static ThemeData construir(TemaApp tema) {
    final p = Paleta.de(tema);
    final oscuro = tema == TemaApp.oscuro;
    final textTheme = textos(p.texto);
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Medidas.radio),
      side: BorderSide(color: p.borde, width: Medidas.grosorBorde),
    );

    final estiloBoton = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(p.boton),
      foregroundColor: WidgetStatePropertyAll(p.textoBoton),
      overlayColor: WidgetStatePropertyAll(p.texto.withValues(alpha: 0.12)),
      minimumSize: const WidgetStatePropertyAll(
        Size(Medidas.tactilPrincipal, Medidas.tactilPrincipal),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      shape: WidgetStatePropertyAll(forma),
      side: WidgetStatePropertyAll(
        BorderSide(color: p.borde, width: Medidas.grosorBorde),
      ),
      textStyle: WidgetStatePropertyAll(
        textTheme.labelLarge!.copyWith(color: p.textoBoton),
      ),
      elevation: const WidgetStatePropertyAll(0),
      tapTargetSize: MaterialTapTargetSize.padded,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: oscuro ? Brightness.dark : Brightness.light,
      fontFamily: fuente,
      colorScheme: ColorScheme(
        brightness: oscuro ? Brightness.dark : Brightness.light,
        primary: p.texto,
        onPrimary: p.fondo,
        secondary: p.seleccion,
        onSecondary: p.fondo,
        error: p.peligro,
        onError: p.textoPeligro,
        surface: p.boton,
        onSurface: p.textoBoton,
      ),
      scaffoldBackgroundColor: p.fondo,
      canvasColor: p.fondo,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: p.texto, size: Medidas.iconoBoton),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      elevatedButtonTheme: ElevatedButtonThemeData(style: estiloBoton),
      outlinedButtonTheme: OutlinedButtonThemeData(style: estiloBoton),
      textButtonTheme: TextButtonThemeData(style: estiloBoton),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.boton,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        hintStyle: textTheme.bodyLarge!.copyWith(color: p.textoBoton),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Medidas.radio),
          borderSide: BorderSide(color: p.borde, width: Medidas.grosorBorde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Medidas.radio),
          borderSide: BorderSide(color: p.borde, width: Medidas.grosorBorde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Medidas.radio),
          borderSide: BorderSide(
            color: p.seleccion,
            width: Medidas.grosorSeleccion,
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.textoBoton,
        selectionColor: p.seleccion.withValues(alpha: 0.35),
        selectionHandleColor: p.seleccion,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.boton,
        surfaceTintColor: Colors.transparent,
        shape: forma,
        titleTextStyle: textTheme.headlineSmall!.copyWith(color: p.textoBoton),
        contentTextStyle: textTheme.bodyLarge!.copyWith(color: p.textoBoton),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.avisoFondo,
        contentTextStyle: textTheme.bodyLarge!.copyWith(color: p.avisoTexto),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Medidas.radio),
          side: BorderSide(color: p.borde, width: Medidas.grosorBorde),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: const WidgetStatePropertyAll(true),
        thickness: const WidgetStatePropertyAll(8),
        radius: const Radius.circular(4),
        thumbColor: WidgetStatePropertyAll(p.texto.withValues(alpha: 0.7)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.texto),
      dividerTheme: DividerThemeData(color: p.texto, thickness: 2),
      extensions: [p],
    );
  }
}
