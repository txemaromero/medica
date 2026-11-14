import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tema/tema_visual.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/opcion_seleccionable.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../l10n/textos.dart';
import '../application/ajustes_controller.dart';
import '../domain/ajustes.dart';

/// Cuándo se repite el aviso de una toma sin marcar y cuántos minutos
/// espera el botón "Recordar en 10 min". Los cambios se guardan al tocar
/// cada opción.
class RepetirAvisosScreen extends ConsumerWidget {
  const RepetirAvisosScreen({super.key});

  /// La hora de los ejemplos: "Una toma de las 08:00 se repite a las 08:30".
  static const HoraDelDia horaEjemplo = HoraDelDia(8, 0);

  static String nombreRepeticion(TextosApp t, int minutos) => switch (minutos) {
    0 => t.repetirNunca,
    60 => t.repetirALaHora,
    _ => t.repetirALosMinutos(minutos),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ajustes = ref.watch(ajustesProvider);
    final controlador = ref.read(ajustesProvider.notifier);
    final t = TextosApp.of(context);

    Future<void> elegir(Future<void> cambio, String opcion) async {
      await cambio;
      if (context.mounted) mostrarAviso(context, t.repetirGuardado(opcion));
    }

    return PantallaBase(
      titulo: t.ajustesRepetirAvisos,
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Parrafo(t.ajustesCambiosAlMomento),
          const Hueco(),
          _Titulo(
            titulo: t.repetirSinMarcarTitulo,
            descripcion: t.repetirSinMarcarDescripcion,
          ),
          for (final minutos in Ajustes.opcionesRepeticion) ...[
            const Hueco(alto: 12),
            OpcionSeleccionable(
              etiqueta: nombreRepeticion(t, minutos),
              descripcion: minutos == 0
                  ? t.repetirNuncaDescripcion
                  : t.repetirEjemplo(
                      horaEjemplo.texto,
                      horaEjemplo.sumarMinutos(minutos).texto,
                    ),
              elegida: ajustes.minutosRepeticion == minutos,
              onPressed: () => elegir(
                controlador.cambiarRepeticion(minutos),
                nombreRepeticion(t, minutos),
              ),
            ),
          ],
          const Hueco(alto: Medidas.separacion * 1.5),
          _Titulo(
            titulo: t.repetirAplazarTitulo,
            descripcion: t.repetirAplazarDescripcion,
          ),
          for (final minutos in Ajustes.opcionesAplazamiento) ...[
            const Hueco(alto: 12),
            OpcionSeleccionable(
              etiqueta: t.avisoAplazar(minutos),
              descripcion: t.repetirAplazarEjemplo(
                horaEjemplo.texto,
                horaEjemplo.sumarMinutos(minutos).texto,
              ),
              elegida: ajustes.minutosAplazamiento == minutos,
              onPressed: () => elegir(
                controlador.cambiarAplazamiento(minutos),
                t.avisoAplazar(minutos),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo({required this.titulo, required this.descripcion});

  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(titulo, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 4),
        Parrafo(descripcion),
      ],
    );
  }
}
