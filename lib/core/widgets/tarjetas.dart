import 'package:flutter/material.dart';

import '../tema/paleta.dart';
import '../tema/tema_visual.dart';
import 'botones.dart';
import 'parrafo.dart';

/// Tarjeta informativa (no pulsable) con fondo de botón y borde visible.
class TarjetaInfo extends StatelessWidget {
  const TarjetaInfo({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Medidas.margen),
      decoration: BoxDecoration(
        color: p.boton,
        borderRadius: BorderRadius.circular(Medidas.radio),
        border: Border.all(color: p.borde, width: Medidas.grosorBorde),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: p.textoBoton),
        child: IconTheme.merge(
          data: IconThemeData(color: p.textoBoton),
          child: child,
        ),
      ),
    );
  }
}

/// Mensaje amable cuando una lista está vacía, con un acceso directo para
/// añadir el primer elemento.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.icono,
    required this.mensaje,
    required this.explicacion,
    this.accion,
  });

  final IconData icono;
  final String mensaje;
  final String explicacion;
  final BotonGrande? accion;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        ExcludeSemantics(child: Icon(icono, size: 96)),
        const SizedBox(height: 16),
        Parrafo(
          mensaje,
          alineacion: TextAlign.center,
          estilo: textos.titleLarge,
        ),
        const SizedBox(height: 12),
        Parrafo(explicacion, alineacion: TextAlign.center),
        if (accion != null) ...[const SizedBox(height: 28), accion!],
      ],
    );
  }
}

/// Fila "icono + texto" usada dentro de las tarjetas de la lista.
class LineaDato extends StatelessWidget {
  const LineaDato({super.key, required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 30, color: p.textoBoton),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodyLarge!
                  .copyWith(color: p.textoBoton),
            ),
          ),
        ],
      ),
    );
  }
}
