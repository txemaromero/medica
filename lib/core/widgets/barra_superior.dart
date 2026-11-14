import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../l10n/textos.dart';
import '../tema/paleta.dart';
import '../tema/tema_visual.dart';
import 'botones.dart';
import 'medida_texto.dart';

/// Barra superior común a todas las pantallas salvo el menú principal:
/// botón "casa" a la izquierda, título en el centro y "atrás" a la derecha.
///
/// Si el título no cabe entre los dos botones sin partir palabras (texto muy
/// grande o pantalla estrecha), el título pasa a una línea propia debajo.
class BarraSuperior extends StatelessWidget {
  const BarraSuperior({super.key, required this.titulo});

  final String titulo;

  static const double _hueco = 8;

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final textos = Theme.of(context).textTheme;
    final estiloTitulo = textos.titleLarge!;
    final estiloEtiqueta = textos.labelMedium!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final anchoEtiquetas = math.max(
          MedidaTexto.anchoLinea(context, t.barraInicio, estiloEtiqueta),
          MedidaTexto.anchoLinea(context, t.barraAtras, estiloEtiqueta),
        );
        // Nunca más de la mitad del ancho, para que los dos botones quepan
        // siempre en una fila; si hiciera falta, la etiqueta se reduce.
        final anchoBoton = math.min(
          math.max(Medidas.tactilPrincipal + 8, anchoEtiquetas + 16),
          (constraints.maxWidth - _hueco) / 2,
        );
        final anchoTitulo = constraints.maxWidth - 2 * (anchoBoton + _hueco);
        final enLinea =
            anchoTitulo > 0 &&
            MedidaTexto.cabeSinPartirPalabras(
              context,
              titulo,
              estiloTitulo,
              anchoTitulo,
            );

        final casa = _BotonBarra(
          icono: Icons.home,
          etiqueta: t.barraInicio,
          etiquetaSemantica: t.barraInicioSemantica,
          ancho: anchoBoton,
          onPressed: () =>
              Navigator.of(context).popUntil((ruta) => ruta.isFirst),
        );
        final atras = _BotonBarra(
          icono: Icons.arrow_back,
          etiqueta: t.barraAtras,
          etiquetaSemantica: t.barraAtrasSemantica,
          ancho: anchoBoton,
          onPressed: () => Navigator.of(context).maybePop(),
        );
        final textoTitulo = Semantics(
          container: true,
          header: true,
          child: Text(titulo, textAlign: TextAlign.center, style: estiloTitulo),
        );

        if (enLinea) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              casa,
              const SizedBox(width: _hueco),
              Expanded(child: textoTitulo),
              const SizedBox(width: _hueco),
              atras,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [casa, const Spacer(), atras]),
            const SizedBox(height: _hueco),
            textoTitulo,
          ],
        );
      },
    );
  }
}

class _BotonBarra extends StatelessWidget {
  const _BotonBarra({
    required this.icono,
    required this.etiqueta,
    required this.etiquetaSemantica,
    required this.ancho,
    required this.onPressed,
  });

  final IconData icono;
  final String etiqueta;
  final String etiquetaSemantica;
  final double ancho;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    return Semantics(
      container: true,
      button: true,
      label: etiquetaSemantica,
      onTap: onPressed,
      excludeSemantics: true,
      child: SizedBox(
        width: ancho,
        child: SuperficiePulsable(
          onPressed: onPressed,
          alturaMinima: Medidas.tactilPrincipal + 16,
          relleno: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: 40, color: p.textoBoton),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  etiqueta,
                  maxLines: 1,
                  softWrap: false,
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(color: p.textoBoton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
