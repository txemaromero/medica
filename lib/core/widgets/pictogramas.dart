import 'package:flutter/material.dart';

import '../tema/paleta.dart';

/// Teléfono con cruz roja: pictograma del botón de emergencias.
///
/// La cruz va sobre un círculo blanco con borde para que se distinga bien
/// en los tres temas, también en el oscuro.
class PictogramaEmergencia extends StatelessWidget {
  const PictogramaEmergencia({super.key, this.tamano = 72, this.color});

  final double tamano;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final cruz = tamano * 0.5;
    return SizedBox(
      width: tamano * 1.25,
      height: tamano,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(
              Icons.phone_in_talk,
              size: tamano * 0.9,
              color: color ?? p.textoBoton,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: cruz,
              height: cruz,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                shape: BoxShape.circle,
                border: Border.all(color: p.peligro, width: 2),
              ),
              child: CustomPaint(painter: _Cruz(p.peligro)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cruz extends CustomPainter {
  const _Cruz(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final pintura = Paint()..color = color;
    final grosor = size.width * 0.22;
    final largo = size.width * 0.62;
    final centro = size.center(Offset.zero);
    canvas
      ..drawRect(
        Rect.fromCenter(center: centro, width: grosor, height: largo),
        pintura,
      )
      ..drawRect(
        Rect.fromCenter(center: centro, width: largo, height: grosor),
        pintura,
      );
  }

  @override
  bool shouldRepaint(_Cruz oldDelegate) => oldDelegate.color != color;
}

/// Icono grande normal para las tarjetas de menú.
class Pictograma extends StatelessWidget {
  const Pictograma(this.icono, {super.key, this.tamano = 72});

  final IconData icono;
  final double tamano;

  @override
  Widget build(BuildContext context) =>
      Icon(icono, size: tamano, color: Paleta.of(context).textoBoton);
}
