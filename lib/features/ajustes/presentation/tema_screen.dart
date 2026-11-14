import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tema/paleta.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/interruptor_grande.dart';
import '../../../core/widgets/opcion_seleccionable.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../l10n/textos.dart';
import '../application/ajustes_controller.dart';
import '../domain/ajustes.dart';

/// Pantalla 10: elegir el tema de colores.
///
/// Al tocar una opción se previsualiza en la zona de muestra; el tema se
/// aplica a toda la app al pulsar "Aplicar este tema".
class TemaScreen extends ConsumerStatefulWidget {
  const TemaScreen({super.key});

  @override
  ConsumerState<TemaScreen> createState() => _TemaScreenState();
}

class _TemaScreenState extends ConsumerState<TemaScreen> {
  late TemaApp _elegido;

  @override
  void initState() {
    super.initState();
    _elegido = ref.read(ajustesProvider).tema;
  }

  Future<void> _aplicar() async {
    await ref.read(ajustesProvider.notifier).cambiarTema(_elegido);
    if (!mounted) return;
    mostrarAviso(context, TextosApp.of(context).temaAplicado(_elegido.nombre));
  }

  @override
  Widget build(BuildContext context) {
    final actual = ref.watch(ajustesProvider.select((a) => a.tema));
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);

    return PantallaBase(
      titulo: t.temaTitulo,
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Parrafo(t.temaToca),
          const Hueco(),
          for (final tema in TemaApp.values) ...[
            _OpcionTema(
              tema: tema,
              elegido: tema == _elegido,
              enUso: tema == actual,
              onPressed: () => setState(() => _elegido = tema),
            ),
            const Hueco(),
          ],
          Semantics(
            container: true,
            header: true,
            child: Text(
              t.temaMuestra(_elegido.nombre),
              style: textos.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          _MuestraTema(tema: _elegido),
          const Hueco(),
          BotonGrande(
            etiqueta: t.temaAplicar,
            descripcion: _elegido == actual
                ? t.temaYaLoUsas
                : t.temaAhoraUsas(actual.nombre),
            icono: Icons.check,
            onPressed: _elegido == actual ? null : _aplicar,
          ),
        ],
      ),
    );
  }
}

class _OpcionTema extends StatelessWidget {
  const _OpcionTema({
    required this.tema,
    required this.elegido,
    required this.enUso,
    required this.onPressed,
  });

  final TemaApp tema;
  final bool elegido;
  final bool enUso;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final muestra = Paleta.de(tema);
    final t = TextosApp.of(context);
    return OpcionSeleccionable(
      etiqueta: tema.nombre,
      descripcion: tema.descripcion,
      elegida: elegido,
      estado: [
        if (elegido) t.temaElegido,
        if (enUso) t.temaEnUso,
      ].join(t.temaSeparadorEstado),
      onPressed: onPressed,
      muestra: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: muestra.fondo,
          shape: BoxShape.circle,
          border: Border.all(color: p.borde, width: Medidas.grosorBorde),
        ),
        child: Center(
          child: Text(
            'Aa',
            style: Theme.of(context).textTheme.labelMedium!
                .copyWith(color: muestra.texto, fontWeight: FontWeight.w800),
            textScaler: TextScaler.noScaling,
          ),
        ),
      ),
    );
  }
}

/// Vista previa de una pantalla con el tema elegido: fondo, texto, un botón
/// y un interruptor.
class _MuestraTema extends StatelessWidget {
  const _MuestraTema({required this.tema});

  final TemaApp tema;

  @override
  Widget build(BuildContext context) {
    final datos = TemaVisual.construir(tema);
    final p = Paleta.de(tema);
    final t = TextosApp.of(context);
    // Solo es una imagen de ejemplo: no se anuncia ni responde al toque.
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Theme(
          data: datos,
          child: Container(
            key: const Key('muestra-tema'),
            width: double.infinity,
            padding: const EdgeInsets.all(Medidas.margen),
            decoration: BoxDecoration(
              color: p.fondo,
              borderRadius: BorderRadius.circular(Medidas.radio),
              border: Border.all(color: Paleta.of(context).borde, width: 4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.menuTitulo,
                  textAlign: TextAlign.center,
                  style: datos.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(t.temaMuestraTexto, style: datos.textTheme.bodyLarge),
                const SizedBox(height: 12),
                BotonGrande(
                  etiqueta: t.temaMuestraBoton,
                  icono: Icons.touch_app,
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                InterruptorGrande(
                  etiqueta: t.temaMuestraInterruptor,
                  descripcion: t.temaMuestraInterruptorDescripcion,
                  valor: true,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
