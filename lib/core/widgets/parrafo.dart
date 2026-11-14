import 'package:flutter/material.dart';

/// Texto suelto de una pantalla (una explicación, un resumen) con su propio
/// nodo para TalkBack.
///
/// Flutter junta en un solo nodo todos los textos sueltos que no tienen el
/// suyo, y TalkBack los leería de golpe y fuera de orden: el de arriba y el
/// de abajo de la pantalla, antes que los botones que hay entre ellos.
class Parrafo extends StatelessWidget {
  const Parrafo(this.texto, {super.key, this.estilo, this.alineacion});

  final String texto;

  /// Por defecto, `bodyLarge`.
  final TextStyle? estilo;
  final TextAlign? alineacion;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Text(
      texto,
      style: estilo ?? Theme.of(context).textTheme.bodyLarge,
      textAlign: alineacion,
    ),
  );
}
