import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../app/rutas.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../application/existencias_controller.dart';
import '../application/medicamentos_controller.dart';
import '../domain/receta.dart';

/// En el menú principal: de qué medicamentos quedan pocas pastillas y de
/// cuáles hay que renovar la receta, con un botón a la lista (donde están
/// "He comprado más" y "Ya la he renovado"). No ocupa nada si no hay nada
/// que avisar.
class AvisoMedicamentos extends ConsumerWidget {
  const AvisoMedicamentos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existencias = ref.watch(existenciasProvider).value ?? const {};
    final medicamentos = ref.watch(medicamentosProvider).value;
    if (medicamentos == null) return const SizedBox.shrink();
    final ahora = ref.watch(relojProvider)();
    final pocas = [
      for (final m in medicamentos)
        if (!m.terminado(ahora) && (existencias[m.id]?.pocas ?? false))
          m.nombre,
    ];
    final recetas = [
      for (final m in medicamentos)
        if (Receta.hayQueRenovar(m, ahora)) m.nombre,
    ];
    if (pocas.isEmpty && recetas.isEmpty) return const SizedBox.shrink();
    final t = TextosApp.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TarjetaInfo(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (pocas.isNotEmpty)
              Semantics(
                container: true,
                child: LineaDato(
                  icono: Icons.warning_amber,
                  texto: t.menuExistenciasPocas(FormatoFechas.lista(pocas)),
                ),
              ),
            if (recetas.isNotEmpty)
              Semantics(
                container: true,
                child: LineaDato(
                  icono: Icons.description,
                  texto: t.menuRecetas(FormatoFechas.lista(recetas)),
                ),
              ),
            const SizedBox(height: 12),
            BotonGrande(
              etiqueta: t.medicamentosMenuVer,
              icono: Icons.medication,
              onPressed: () =>
                  Navigator.of(context).pushNamed(Rutas.listaMedicamentos),
            ),
          ],
        ),
      ),
    );
  }
}
