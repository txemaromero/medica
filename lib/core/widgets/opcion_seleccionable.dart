import 'package:flutter/material.dart';

import '../tema/paleta.dart';
import 'botones.dart';

/// Opción de un grupo en el que solo se puede elegir una (como un botón de
/// radio grande): marca circular, etiqueta, descripción y, si se indica, una
/// línea de estado. La elegida lleva además un marco grueso.
class OpcionSeleccionable extends StatelessWidget {
  const OpcionSeleccionable({
    super.key,
    required this.etiqueta,
    required this.descripcion,
    required this.elegida,
    required this.onPressed,
    this.estado,
    this.muestra,
  });

  final String etiqueta;
  final String descripcion;
  final bool elegida;
  final VoidCallback onPressed;

  /// Texto adicional, por ejemplo "Elegido · En uso".
  final String? estado;

  /// Pequeña imagen de ejemplo junto a la marca (por ejemplo, los colores de
  /// un tema).
  final Widget? muestra;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final textos = Theme.of(context).textTheme;
    final estadoVisible = estado?.isNotEmpty ?? false;

    return Semantics(
      container: true,
      button: true,
      inMutuallyExclusiveGroup: true,
      checked: elegida,
      label: etiqueta,
      value: estadoVisible ? estado : null,
      hint: descripcion,
      onTap: onPressed,
      excludeSemantics: true,
      child: SuperficiePulsable(
        onPressed: onPressed,
        seleccionado: elegida,
        child: Row(
          children: [
            Icon(
              elegida ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 40,
              color: p.textoBoton,
            ),
            const SizedBox(width: 12),
            if (muestra != null) ...[muestra!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    etiqueta,
                    style: textos.titleMedium!.copyWith(color: p.textoBoton),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: textos.bodyLarge!.copyWith(color: p.textoBoton),
                  ),
                  if (estadoVisible) ...[
                    const SizedBox(height: 6),
                    Text(
                      estado!,
                      style: textos.titleSmall!.copyWith(color: p.textoBoton),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
