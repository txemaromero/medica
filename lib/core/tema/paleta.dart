import 'package:flutter/material.dart';

import '../../features/ajustes/domain/ajustes.dart';

/// Colores de un tema. Todas las combinaciones de texto sobre fondo de cada
/// paleta tienen contraste AAA (≥ 7:1); se comprueba en
/// `test/core/tema/paleta_test.dart`.
@immutable
class Paleta extends ThemeExtension<Paleta> {
  const Paleta({
    required this.fondo,
    required this.texto,
    required this.boton,
    required this.textoBoton,
    required this.borde,
    required this.peligro,
    required this.textoPeligro,
    required this.exito,
    required this.textoExito,
    required this.bordeError,
    required this.seleccion,
    required this.avisoFondo,
    required this.avisoTexto,
  });

  /// Fondo de las pantallas.
  final Color fondo;

  /// Texto e iconos sobre [fondo].
  final Color texto;

  /// Fondo de botones y tarjetas pulsables.
  final Color boton;

  /// Texto e iconos sobre [boton].
  final Color textoBoton;

  /// Borde visible de botones, campos y tarjetas.
  final Color borde;

  /// Acciones destructivas (eliminar) e interruptor desactivado.
  final Color peligro;
  final Color textoPeligro;

  /// Interruptor activado y confirmaciones.
  final Color exito;
  final Color textoExito;

  /// Borde e icono de los mensajes de error (el texto usa [texto] para
  /// mantener el contraste AAA).
  final Color bordeError;

  /// Marco de la opción seleccionada y del foco.
  final Color seleccion;

  /// Mensajes emergentes (confirmaciones con "Deshacer").
  final Color avisoFondo;
  final Color avisoTexto;

  static Paleta de(TemaApp tema) => switch (tema) {
    TemaApp.predeterminado => predeterminada,
    TemaApp.oscuro => oscura,
    TemaApp.alternativo => alternativa,
  };

  static Paleta of(BuildContext context) =>
      Theme.of(context).extension<Paleta>() ?? predeterminada;

  static const Color _rojo = Color(0xFFB00020);
  static const Color _verde = Color(0xFF1B5E20);
  static const Color _blanco = Color(0xFFFFFFFF);
  static const Color _negro = Color(0xFF000000);

  /// Azul claro validado en la memoria del proyecto.
  static const Paleta predeterminada = Paleta(
    fondo: Color(0xFFB6D8FF),
    texto: _negro,
    boton: _blanco,
    textoBoton: _negro,
    borde: _negro,
    peligro: _rojo,
    textoPeligro: _blanco,
    exito: _verde,
    textoExito: _blanco,
    bordeError: _rojo,
    seleccion: Color(0xFF00337A),
    avisoFondo: _negro,
    avisoTexto: _blanco,
  );

  /// Gris muy oscuro en lugar de negro puro para reducir el deslumbramiento
  /// del texto blanco.
  static const Paleta oscura = Paleta(
    fondo: Color(0xFF121212),
    texto: _blanco,
    boton: Color(0xFF262626),
    textoBoton: _blanco,
    borde: _blanco,
    peligro: _rojo,
    textoPeligro: _blanco,
    exito: _verde,
    textoExito: _blanco,
    bordeError: Color(0xFFFF8A80),
    seleccion: Color(0xFFFFD54F),
    avisoFondo: _blanco,
    avisoTexto: _negro,
  );

  /// Amarillo suave tipo crema con texto negro.
  static const Paleta alternativa = Paleta(
    fondo: Color(0xFFFFF3C4),
    texto: _negro,
    boton: _blanco,
    textoBoton: _negro,
    borde: _negro,
    peligro: _rojo,
    textoPeligro: _blanco,
    exito: _verde,
    textoExito: _blanco,
    bordeError: _rojo,
    seleccion: Color(0xFF5D3A00),
    avisoFondo: _negro,
    avisoTexto: _blanco,
  );

  @override
  Paleta copyWith({
    Color? fondo,
    Color? texto,
    Color? boton,
    Color? textoBoton,
    Color? borde,
    Color? peligro,
    Color? textoPeligro,
    Color? exito,
    Color? textoExito,
    Color? bordeError,
    Color? seleccion,
    Color? avisoFondo,
    Color? avisoTexto,
  }) => Paleta(
    fondo: fondo ?? this.fondo,
    texto: texto ?? this.texto,
    boton: boton ?? this.boton,
    textoBoton: textoBoton ?? this.textoBoton,
    borde: borde ?? this.borde,
    peligro: peligro ?? this.peligro,
    textoPeligro: textoPeligro ?? this.textoPeligro,
    exito: exito ?? this.exito,
    textoExito: textoExito ?? this.textoExito,
    bordeError: bordeError ?? this.bordeError,
    seleccion: seleccion ?? this.seleccion,
    avisoFondo: avisoFondo ?? this.avisoFondo,
    avisoTexto: avisoTexto ?? this.avisoTexto,
  );

  /// Sin transiciones de color intermedias: un color a medio camino podría
  /// no cumplir el contraste mínimo.
  @override
  Paleta lerp(Paleta? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
