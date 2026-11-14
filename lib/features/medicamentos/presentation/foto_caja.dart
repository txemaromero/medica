import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../core/tema/paleta.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../l10n/textos.dart';

/// Foto de la caja de un medicamento, entera (sin recortar) y con borde. Si
/// el fichero no se puede leer, lo dice con texto en lugar de dejar un hueco.
class FotoCaja extends ConsumerWidget {
  const FotoCaja({
    super.key,
    required this.foto,
    required this.nombreMedicamento,
    this.alto = 180,
    this.nodoPropio = true,
  });

  /// Nombre del fichero (ver `AlmacenFotos`).
  final String foto;
  final String nombreMedicamento;
  final double alto;

  /// `false` dentro de una tarjeta que TalkBack ya lee de una vez
  /// (`MergeSemantics`): así la foto no se lee dos veces.
  final bool nodoPropio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Paleta.of(context);
    final t = TextosApp.of(context);
    final descripcion = nombreMedicamento.trim().isEmpty
        ? t.fotoCaja
        : t.fotoCajaDe(nombreMedicamento.trim());
    return Semantics(
      container: nodoPropio,
      image: true,
      label: descripcion,
      excludeSemantics: true,
      child: Container(
        height: alto,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: p.fondo,
          borderRadius: BorderRadius.circular(Medidas.radio),
          border: Border.all(color: p.borde, width: Medidas.grosorBorde),
        ),
        child: Image(
          image: ref.watch(almacenFotosProvider).imagen(foto),
          fit: BoxFit.contain,
          errorBuilder: (context, _, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                t.fotoNoSePuedeMostrar,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
