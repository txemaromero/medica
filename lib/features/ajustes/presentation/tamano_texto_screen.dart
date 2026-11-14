import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/botones.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../application/ajustes_controller.dart';
import '../domain/tamano_texto.dart';

/// Pantalla 9: ajustar el tamaño del texto de toda la aplicación.
///
/// El cambio se aplica al momento a toda la app, de modo que la propia
/// pantalla y la zona de muestra se redibujan con el nuevo tamaño.
class TamanoTextoScreen extends StatelessWidget {
  const TamanoTextoScreen({super.key});

  static String describirTamano(TextosApp t, int tamano) => switch (tamano) {
    TamanoTexto.base => t.tamanoActualNormal('$tamano'),
    TamanoTexto.minimo => t.tamanoActualMinimo('$tamano'),
    TamanoTexto.maximo => t.tamanoActualMaximo('$tamano'),
    _ => t.tamanoActual('$tamano'),
  };

  @override
  Widget build(BuildContext context) => PantallaBase(
    titulo: TextosApp.of(context).tamanoTitulo,
    cuerpo: const ControlesTamanoTexto(),
  );
}

/// Tamaño actual, botones "Aumentar" y "Reducir" y zona de muestra. Se usa
/// en esta pantalla y en el asistente de la primera vez.
class ControlesTamanoTexto extends ConsumerWidget {
  const ControlesTamanoTexto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tamano = ref.watch(ajustesProvider.select((a) => a.tamanoTexto));
    final controlador = ref.read(ajustesProvider.notifier);
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final puedeAumentar = TamanoTexto.puedeAumentar(tamano);
    final puedeReducir = TamanoTexto.puedeReducir(tamano);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          liveRegion: true,
          child: Text(
            TamanoTextoScreen.describirTamano(t, tamano),
            textAlign: TextAlign.center,
            style: textos.headlineSmall,
          ),
        ),
        const SizedBox(height: 8),
        Parrafo(
          t.tamanoPuedesElegir(
            '${TamanoTexto.minimo}',
            '${TamanoTexto.maximo}',
          ),
          alineacion: TextAlign.center,
        ),
        const Hueco(),
        BotonGrande(
          etiqueta: t.tamanoAumentar,
          descripcion: puedeAumentar ? t.tamanoMasGrandes : t.tamanoYaMaximo,
          icono: Icons.add,
          onPressed: puedeAumentar ? controlador.aumentarTexto : null,
        ),
        const Hueco(),
        BotonGrande(
          etiqueta: t.tamanoReducir,
          descripcion: puedeReducir ? t.tamanoMasPequenas : t.tamanoYaMinimo,
          icono: Icons.remove,
          onPressed: puedeReducir ? controlador.reducirTexto : null,
        ),
        const Hueco(),
        Semantics(
          container: true,
          header: true,
          child: Text(t.tamanoMuestra, style: textos.titleLarge),
        ),
        const SizedBox(height: 8),
        TarjetaInfo(
          key: const Key('muestra-texto'),
          child: Parrafo(t.tamanoMuestraTexto),
        ),
      ],
    );
  }
}
