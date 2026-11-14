import 'package:flutter/material.dart';

import '../../l10n/textos.dart';
import '../tema/paleta.dart';
import '../tema/tema_visual.dart';
import 'botones.dart';
import 'parrafo.dart';

/// Pregunta antes de eliminar algo. Devuelve `true` solo si el usuario pulsa
/// "Sí, eliminar". Los botones van uno debajo del otro para que quepan con
/// cualquier tamaño de texto.
Future<bool> confirmarEliminacion(
  BuildContext context, {
  required String pregunta,
  required String detalle,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _DialogoBase(
      icono: Icons.delete_forever,
      colorIcono: Paleta.of(context).peligro,
      titulo: pregunta,
      mensaje: detalle,
      botones: [
        BotonGrande(
          etiqueta: TextosApp.of(context).dialogoSiEliminar,
          icono: Icons.delete,
          estilo: EstiloBoton.peligro,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        BotonGrande(
          etiqueta: TextosApp.of(context).dialogoNoVolver,
          icono: Icons.undo,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  );
  return resultado ?? false;
}

/// Mensaje de confirmación tras una acción importante (por ejemplo, guardar).
/// Con [icono], es un mensaje informativo (sin la marca verde de éxito).
Future<void> mostrarConfirmacion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String? textoBoton,
  IconData? icono,
}) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => _DialogoBase(
    icono: icono ?? Icons.check_circle,
    colorIcono: icono == null
        ? Paleta.of(context).exito
        : Paleta.of(context).textoBoton,
    titulo: titulo,
    mensaje: mensaje,
    botones: [
      BotonGrande(
        etiqueta: textoBoton ?? TextosApp.of(context).dialogoAceptar,
        icono: Icons.check,
        centrado: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);

/// Pregunta con dos respuestas. Devuelve `true` si se elige [textoSi].
Future<bool> preguntar(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  required String textoSi,
  required String textoNo,
  IconData icono = Icons.help,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _DialogoBase(
      icono: icono,
      colorIcono: Paleta.of(context).textoBoton,
      titulo: titulo,
      mensaje: mensaje,
      botones: [
        BotonGrande(
          etiqueta: textoSi,
          icono: Icons.check,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        BotonGrande(
          etiqueta: textoNo,
          icono: Icons.close,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  );
  return resultado ?? false;
}

class _DialogoBase extends StatelessWidget {
  const _DialogoBase({
    required this.icono,
    required this.colorIcono,
    required this.titulo,
    required this.mensaje,
    required this.botones,
  });

  final IconData icono;
  final Color colorIcono;
  final String titulo;
  final String mensaje;
  final List<Widget> botones;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final textos = Theme.of(context).textTheme;
    return Dialog(
      insetPadding: const EdgeInsets.all(Medidas.margen),
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Medidas.margen + 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExcludeSemantics(child: Icon(icono, size: 64, color: colorIcono)),
              const SizedBox(height: 12),
              Semantics(
                container: true,
                header: true,
                child: Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: textos.headlineSmall!.copyWith(color: p.textoBoton),
                ),
              ),
              const SizedBox(height: 12),
              Parrafo(
                mensaje,
                alineacion: TextAlign.center,
                estilo: textos.bodyLarge!.copyWith(color: p.textoBoton),
              ),
              for (final boton in botones) ...[
                const SizedBox(height: Medidas.separacion),
                boton,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
