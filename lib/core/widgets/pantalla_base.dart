import 'package:flutter/material.dart';

import '../tema/tema_visual.dart';
import 'barra_superior.dart';

/// Estructura común de las pantallas secundarias: barra superior, contenido
/// con desplazamiento vertical simple y, opcionalmente, un botón principal
/// fijo en la parte inferior ([pie]).
///
/// El contenido va en un `SingleChildScrollView`, no en un `ListView`: con un
/// `ListView`, si el contenido encogía con la pantalla desplazada (al volver
/// a la lista con una tarjeta más corta), Flutter fallaba al rehacer el árbol
/// de TalkBack ("Null check operator" en `_buildSemanticsSubtree`).
///
/// Con texto muy grande o pantallas bajas (modo compacto) la barra y el
/// botón no caben fijos sin dejar casi sin sitio al contenido, así que pasan
/// a desplazarse junto con él: la barra arriba del todo y el botón al
/// principio o al final del contenido según [pieArribaEnModoCompacto].
class PantallaBase extends StatelessWidget {
  const PantallaBase({
    super.key,
    required this.titulo,
    required this.cuerpo,
    this.pie,
    this.pieArribaEnModoCompacto = false,
  });

  final String titulo;
  final Widget cuerpo;
  final Widget? pie;

  /// En listas (agenda, medicamentos) el botón de crear se coloca antes de
  /// la lista para no quedar al final de una lista larga.
  final bool pieArribaEnModoCompacto;

  /// A partir de este factor de escalado del texto (tamaño 30 de 35) se usa
  /// el modo compacto.
  static const double factorModoCompacto = 1.5;

  /// Por debajo de esta altura disponible también se usa el modo compacto.
  static const double alturaModoCompacto = 560;

  static bool esCompacto(BuildContext context, double alturaDisponible) {
    final factor =
        MediaQuery.textScalerOf(context).scale(TemaVisual.tamanoBase) /
        TemaVisual.tamanoBase;
    return factor >= factorModoCompacto ||
        alturaDisponible < alturaModoCompacto;
  }

  static const EdgeInsets _rellenoContenido = EdgeInsets.fromLTRB(
    Medidas.margen,
    8,
    Medidas.margen,
    Medidas.margen * 2,
  );

  @override
  Widget build(BuildContext context) {
    final barra = BarraSuperior(titulo: titulo);
    final datos = MediaQuery.of(context);
    final altoDisponible = datos.size.height - datos.padding.vertical;

    if (esCompacto(context, altoDisponible)) {
      return Scaffold(
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                Medidas.margen,
                Medidas.margen,
                Medidas.margen,
                Medidas.margen * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  barra,
                  const Hueco(),
                  if (pie != null && pieArribaEnModoCompacto) ...[
                    pie!,
                    const Hueco(),
                  ],
                  cuerpo,
                  if (pie != null && !pieArribaEnModoCompacto) ...[
                    const Hueco(),
                    pie!,
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // El botón fijo va en la zona inferior del Scaffold: así los mensajes
      // emergentes (por ejemplo, "Deshacer") aparecen encima del botón en
      // lugar de taparlo.
      bottomNavigationBar: pie == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Medidas.margen,
                  8,
                  Medidas.margen,
                  Medidas.margen,
                ),
                child: pie,
              ),
            ),
      body: SafeArea(
        bottom: pie == null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Medidas.margen,
                Medidas.margen,
                Medidas.margen,
                12,
              ),
              child: barra,
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: _rellenoContenido,
                  child: cuerpo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Separación vertical estándar entre elementos.
class Hueco extends StatelessWidget {
  const Hueco({super.key, this.alto = Medidas.separacion});

  final double alto;

  @override
  Widget build(BuildContext context) => SizedBox(height: alto);
}
