import 'package:flutter/material.dart';

import '../../l10n/textos.dart';
import '../tema/paleta.dart';
import '../tema/tema_visual.dart';

/// Mensaje de error junto a un campo. El texto usa el color normal de los
/// botones para mantener el contraste AAA; el rojo queda en el borde y el
/// icono, de modo que el error no se indica solo con color.
class MensajeError extends StatelessWidget {
  const MensajeError(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    return Semantics(
      liveRegion: true,
      container: true,
      label: TextosApp.of(context).mensajeError(texto),
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: p.boton,
          borderRadius: BorderRadius.circular(Medidas.radio),
          border: Border.all(color: p.bordeError, width: 4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error, color: p.bordeError, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(color: p.textoBoton, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
