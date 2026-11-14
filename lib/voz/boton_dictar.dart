import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/proveedores.dart';
import '../core/widgets/avisos.dart';
import '../core/widgets/botones.dart';
import '../l10n/textos.dart';
import 'lector.dart';
import 'servicio_voz.dart';

/// Botón "Dictar" bajo un campo de texto: abre el dictado del teléfono y
/// escribe en el campo lo que se ha entendido. No aparece si el teléfono no
/// tiene dictado.
class BotonDictar extends ConsumerWidget {
  const BotonDictar({
    super.key,
    required this.controller,
    required this.etiqueta,
    required this.indicacion,
  });

  final TextEditingController controller;

  /// Por ejemplo, "Dictar el nombre".
  final String etiqueta;

  /// Lo que muestra la pantalla de dictado, por ejemplo "Di el nombre del
  /// medicamento".
  final String indicacion;

  Future<void> _dictar(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    final resultado = await ref.read(servicioVozProvider).dictar(indicacion);
    if (!context.mounted) return;
    final t = TextosApp.of(context);
    switch (resultado) {
      case DictadoReconocido(:final texto):
        final limpio = texto.trim();
        controller.text = limpio.isEmpty
            ? limpio
            : '${limpio[0].toUpperCase()}${limpio.substring(1)}';
        mostrarAviso(
          context,
          t.vozHasDictado(controller.text),
          icono: Icons.mic,
        );
      case DictadoCancelado():
        break;
      case DictadoNoDisponible():
        mostrarAviso(context, t.vozNoPuedeDictar, icono: Icons.info);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!(ref.watch(puedeDictarProvider).value ?? false)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: BotonGrande(
        etiqueta: etiqueta,
        descripcion: TextosApp.of(context).vozDictarDescripcion,
        icono: Icons.mic,
        onPressed: () => _dictar(context, ref),
      ),
    );
  }
}
