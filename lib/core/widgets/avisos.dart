import 'package:flutter/material.dart';

import '../../l10n/textos.dart';
import '../tema/paleta.dart';
import '../tema/tema_visual.dart';

/// Duración del mensaje cuando ofrece "Deshacer": tiempo suficiente para
/// leerlo y reaccionar con calma.
const Duration duracionDeshacer = Duration(seconds: 8);
const Duration duracionAviso = Duration(seconds: 4);

/// Muestra un mensaje breve de confirmación en la parte inferior. Si se
/// indica [alDeshacer], incluye un botón grande "Deshacer"; al pulsarlo se
/// confirma con [mensajeTrasDeshacer] (por defecto, "Hecho. Se ha deshecho la
/// acción."). [pistaDeshacer] es lo que TalkBack explica del botón (por
/// defecto, "Deshace lo que acabas de hacer").
///
/// El mensaje sigue visible aunque se cambie de pantalla, por lo que no
/// depende de que [context] siga montado cuando se pulsa "Deshacer".
void mostrarAviso(
  BuildContext context,
  String mensaje, {
  Future<void> Function()? alDeshacer,
  String? mensajeTrasDeshacer,
  String? pistaDeshacer,
  IconData icono = Icons.check_circle,
}) {
  final t = TextosApp.of(context);
  _mostrar(
    ScaffoldMessenger.of(context),
    Paleta.of(context),
    Theme.of(context).textTheme,
    mensaje,
    icono: icono,
    alDeshacer: alDeshacer,
    mensajeTrasDeshacer: mensajeTrasDeshacer ?? t.avisoDeshecho,
    pistaDeshacer: pistaDeshacer ?? t.botonDeshacerPista,
    textoNoDeshecho: t.avisoNoSeHaPodidoDeshacer,
  );
}

void _mostrar(
  ScaffoldMessengerState mensajero,
  Paleta p,
  TextTheme textos,
  String mensaje, {
  required IconData icono,
  Future<void> Function()? alDeshacer,
  String mensajeTrasDeshacer = '',
  String pistaDeshacer = '',
  String textoNoDeshecho = '',
}) {
  mensajero
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: alDeshacer != null ? duracionDeshacer : duracionAviso,
        padding: const EdgeInsets.all(Medidas.margen),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(icono, color: p.avisoTexto, size: 36),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mensaje,
                    style: textos.titleMedium!.copyWith(color: p.avisoTexto),
                  ),
                ),
              ],
            ),
            if (alDeshacer != null) ...[
              const SizedBox(height: 12),
              _BotonDeshacer(
                pista: pistaDeshacer,
                onPressed: () async {
                  mensajero.hideCurrentSnackBar();
                  try {
                    await alDeshacer();
                    _mostrar(
                      mensajero,
                      p,
                      textos,
                      mensajeTrasDeshacer,
                      icono: Icons.undo,
                    );
                  } on Object {
                    _mostrar(
                      mensajero,
                      p,
                      textos,
                      textoNoDeshecho,
                      icono: Icons.error,
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
}

class _BotonDeshacer extends StatelessWidget {
  const _BotonDeshacer({required this.pista, required this.onPressed});

  final String pista;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final t = TextosApp.of(context);
    // Colores invertidos respecto al mensaje para que destaque.
    return Semantics(
      button: true,
      container: true,
      label: t.botonDeshacer,
      hint: pista,
      onTap: onPressed,
      excludeSemantics: true,
      child: Material(
        color: p.avisoTexto,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Medidas.radio),
          side: BorderSide(color: p.avisoTexto, width: Medidas.grosorBorde),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: Medidas.tactilPrincipal,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.undo, color: p.avisoFondo, size: 36),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      t.botonDeshacer,
                      style: Theme.of(context).textTheme.titleMedium!
                          .copyWith(color: p.avisoFondo),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
