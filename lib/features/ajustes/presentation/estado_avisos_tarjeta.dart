import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/botones.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../application/ajustes_controller.dart';
import '../domain/estado_avisos.dart';
import 'explicaciones_avisos.dart';

/// Comprobación de los avisos en Ajustes: "listos para llegar a su hora" o,
/// si algo puede impedirlos o retrasarlos, qué es y un botón para
/// arreglarlo. Con los avisos desactivados no se muestra.
class EstadoAvisosTarjeta extends ConsumerWidget {
  const EstadoAvisosTarjeta({super.key});

  static String texto(TextosApp t, ProblemaAvisos problema) =>
      switch (problema) {
        ProblemaAvisos.sinPermiso => t.estadoAvisosSinPermiso,
        ProblemaAvisos.sinHoraExacta => t.estadoAvisosSinHoraExacta,
        ProblemaAvisos.ahorroBateria => t.estadoAvisosAhorroBateria,
      };

  static String boton(TextosApp t, ProblemaAvisos problema) =>
      switch (problema) {
        ProblemaAvisos.sinPermiso => t.estadoAvisosBotonPermiso,
        ProblemaAvisos.sinHoraExacta => t.estadoAvisosBotonHoraExacta,
        ProblemaAvisos.ahorroBateria => t.estadoAvisosBotonBateria,
      };

  static IconData icono(ProblemaAvisos problema) => switch (problema) {
    ProblemaAvisos.sinPermiso => Icons.notifications_off,
    ProblemaAvisos.sinHoraExacta => Icons.alarm,
    ProblemaAvisos.ahorroBateria => Icons.battery_alert,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Al volver a comprobarlo se sigue viendo el resultado anterior.
    final estado = ref.watch(estadoAvisosProvider).value;
    if (estado == null || !estado.activados) return const SizedBox.shrink();
    final t = TextosApp.of(context);
    final problemas = estado.problemas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Hueco(),
        TarjetaInfo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (problemas.isEmpty)
                Semantics(
                  container: true,
                  child: LineaDato(
                    icono: Icons.check_circle,
                    texto: t.estadoAvisosListos,
                  ),
                ),
              for (final (i, problema) in problemas.indexed) ...[
                if (i > 0) const Hueco(),
                Semantics(
                  container: true,
                  child: LineaDato(
                    icono: icono(problema),
                    texto: texto(t, problema),
                  ),
                ),
                const SizedBox(height: 12),
                BotonGrande(
                  etiqueta: boton(t, problema),
                  icono: icono(problema),
                  onPressed: () => arreglarProblemaAvisos(
                    context,
                    ref.read(ajustesProvider.notifier),
                    problema,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Aviso del menú principal cuando los avisos están activados pero el
/// teléfono no deja mostrarlos: sin él, la persona no se enteraría hasta que
/// echara de menos un aviso.
class AvisoSinPermiso extends ConsumerWidget {
  const AvisoSinPermiso({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(estadoAvisosProvider).value;
    if (estado == null ||
        !estado.problemas.contains(ProblemaAvisos.sinPermiso)) {
      return const SizedBox.shrink();
    }
    final t = TextosApp.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TarjetaInfo(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              container: true,
              child: LineaDato(
                icono: Icons.notifications_off,
                texto: t.menuAvisosSinPermiso,
              ),
            ),
            const SizedBox(height: 12),
            BotonGrande(
              etiqueta: t.estadoAvisosBotonPermiso,
              icono: Icons.notifications_active,
              onPressed: () => arreglarProblemaAvisos(
                context,
                ref.read(ajustesProvider.notifier),
                ProblemaAvisos.sinPermiso,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
