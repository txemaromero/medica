import 'package:flutter/material.dart';

import '../../l10n/textos.dart';
import '../tema/paleta.dart';
import 'botones.dart';
import 'medida_texto.dart';

/// Control grande "−  valor  +" para elegir un número u otro valor de una
/// lista sin teclado ni ruedas giratorias.
///
/// Si el valor no cabe entre los dos botones sin partir palabras, el valor
/// pasa a una línea propia encima de los botones.
class SelectorNumerico extends StatelessWidget {
  const SelectorNumerico({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.onMenos,
    required this.onMas,
    required this.etiquetaMenos,
    required this.etiquetaMas,
    this.valorSemantico,
  });

  final String etiqueta;
  final String valor;

  /// Texto que leerá TalkBack para el valor si debe ser más explícito.
  final String? valorSemantico;

  final VoidCallback? onMenos;
  final VoidCallback? onMas;
  final String etiquetaMenos;
  final String etiquetaMas;

  static const double _tamanoBoton = 72;
  static const double _hueco = 12;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final textos = Theme.of(context).textTheme;
    final estiloValor = textos.headlineMedium!.copyWith(color: p.texto);

    final menos = BotonSimbolo(
      icono: Icons.remove,
      etiquetaSemantica: etiquetaMenos,
      onPressed: onMenos,
      tamano: _tamanoBoton,
    );
    final mas = BotonSimbolo(
      icono: Icons.add,
      etiquetaSemantica: etiquetaMas,
      onPressed: onMas,
      tamano: _tamanoBoton,
    );
    final textoValor = Semantics(
      container: true,
      liveRegion: true,
      label: TextosApp.of(context)
          .selectorValor(etiqueta, valorSemantico ?? valor),
      excludeSemantics: true,
      child: Text(valor, textAlign: TextAlign.center, style: estiloValor),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Text(
            etiqueta,
            style: textos.titleSmall!.copyWith(color: p.texto),
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final anchoValor =
                constraints.maxWidth - 2 * (_tamanoBoton + _hueco);
            final cabe =
                anchoValor > 0 &&
                MedidaTexto.cabeSinPartirPalabras(
                  context,
                  valor,
                  estiloValor,
                  anchoValor,
                );
            if (cabe) {
              return Row(
                children: [
                  menos,
                  const SizedBox(width: _hueco),
                  Expanded(child: textoValor),
                  const SizedBox(width: _hueco),
                  mas,
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textoValor,
                const SizedBox(height: 8),
                Row(children: [menos, const Spacer(), mas]),
              ],
            );
          },
        ),
      ],
    );
  }
}
