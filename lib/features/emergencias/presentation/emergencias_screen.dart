import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../app/rutas.dart';
import '../../../core/tema/paleta.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/pictogramas.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../../ajustes/application/ajustes_controller.dart';

/// Pantalla 7: pantalla intermedia de emergencias.
///
/// Existe a propósito para evitar llamadas accidentales: entrar aquí desde el
/// menú no llama; hay que pulsar el botón "Llamar", que abre el marcador con
/// el número ya escrito. Si hay un familiar guardado en Ajustes, debajo hay
/// otro botón para llamarle.
class EmergenciasScreen extends ConsumerWidget {
  const EmergenciasScreen({super.key});

  /// [nombre] es el del familiar, si la llamada es para él; solo se usa en
  /// los mensajes.
  Future<void> _llamar(
    BuildContext context,
    WidgetRef ref,
    String numero, {
    String? nombre,
  }) async {
    final t = TextosApp.of(context);
    mostrarAviso(
      context,
      nombre == null
          ? t.emergenciasAbriendoNumero(numero)
          : t.emergenciasAbriendoNombre(nombre),
      icono: Icons.phone,
    );
    final abierto = await ref
        .read(marcadorTelefonoProvider)
        .abrirMarcador(numero);
    if (abierto || !context.mounted) return;
    await mostrarConfirmacion(
      context,
      titulo: t.emergenciasNoSeHaPodidoAbrir,
      mensaje: t.emergenciasMarcaAMano(numero),
      textoBoton: t.dialogoEntendido,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ajustes = ref.watch(ajustesProvider);
    final numero = ajustes.numeroEmergencia.trim();
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final irAAjustes = BotonGrande(
      etiqueta: t.emergenciasIrAAjustes,
      descripcion: t.emergenciasIrAAjustesDescripcion,
      icono: Icons.settings,
      onPressed: () => Navigator.of(context).pushNamed(Rutas.ajustes),
    );
    // La tarjeta se lee de una vez.
    final sinNumero = MergeSemantics(
      child: TarjetaInfo(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExcludeSemantics(child: Icon(Icons.info, size: 56)),
            const SizedBox(height: 12),
            Text(t.emergenciasSinNumero, style: textos.titleLarge),
            const SizedBox(height: 12),
            Text(t.emergenciasSinNumeroExplicacion, style: textos.bodyLarge),
          ],
        ),
      ),
    );

    if (numero.isEmpty && !ajustes.tieneFamiliar) {
      return PantallaBase(
        titulo: t.emergenciasTitulo,
        cuerpo: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [sinNumero, const Hueco(), irAAjustes],
        ),
      );
    }

    return PantallaBase(
      titulo: t.emergenciasTitulo,
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (numero.isNotEmpty) ...[
            Parrafo(
              t.emergenciasPulsaParaLlamar(numero),
              alineacion: TextAlign.center,
              estilo: textos.titleMedium,
            ),
            const Hueco(),
            Center(
              child: _BotonLlamar(
                numero: numero,
                onPressed: () => _llamar(context, ref, numero),
              ),
            ),
          ] else ...[
            sinNumero,
            const Hueco(),
            irAAjustes,
          ],
          if (ajustes.tieneFamiliar) ...[
            const Hueco(),
            BotonGrande(
              etiqueta: t.emergenciasLlamarA(ajustes.familiarNombre),
              descripcion: ajustes.familiarNumero,
              // TalkBack lee la etiqueta y, después, el número.
              etiquetaSemantica: t.emergenciasLlamarA(ajustes.familiarNombre),
              icono: Icons.person,
              onPressed: () => _llamar(
                context,
                ref,
                ajustes.familiarNumero,
                nombre: ajustes.familiarNombre,
              ),
            ),
          ],
          const Hueco(),
          Parrafo(t.emergenciasExplicacion, alineacion: TextAlign.center),
        ],
      ),
    );
  }
}

class _BotonLlamar extends StatelessWidget {
  const _BotonLlamar({required this.numero, required this.onPressed});

  final String numero;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final t = TextosApp.of(context);
    final tamano = math.min(
      MediaQuery.sizeOf(context).width - 2 * Medidas.margen,
      340.0,
    );
    return Semantics(
      container: true,
      button: true,
      label: t.emergenciasLlamarAlNumero(numero),
      onTap: onPressed,
      excludeSemantics: true,
      child: SizedBox(
        width: tamano,
        child: SuperficiePulsable(
          onPressed: onPressed,
          alturaMinima: tamano,
          relleno: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PictogramaEmergencia(tamano: tamano * 0.42),
              const SizedBox(height: 20),
              Text(
                t.emergenciasLlamar,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!
                    .copyWith(color: p.textoBoton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
