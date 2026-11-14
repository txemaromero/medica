import 'package:flutter/material.dart';

import '../tema/paleta.dart';
import '../tema/tema_visual.dart';

enum EstiloBoton {
  /// Fondo blanco (o el del tema) con borde visible.
  normal,

  /// Fondo rojo para acciones destructivas (eliminar).
  peligro,
}

/// Superficie pulsable común a todos los botones grandes: fondo, borde
/// visible, área táctil mínima y respuesta visual al pulsar.
/// Texto de un botón pequeño que se puede elegir (un día de la semana, un
/// atajo de fecha). El elegido lleva delante una marca ✓, para que no se
/// distinga solo por el borde y el color.
class TextoConMarca extends StatelessWidget {
  const TextoConMarca({
    super.key,
    required this.texto,
    required this.elegido,
    this.activo = true,
  });

  final String texto;
  final bool elegido;
  final bool activo;

  @override
  Widget build(BuildContext context) {
    final color = SuperficiePulsable.colorPrimerPlano(
      context,
      EstiloBoton.normal,
      activo: activo,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (elegido) ...[
          Icon(Icons.check, size: 28, color: color),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.titleSmall!
                .copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class SuperficiePulsable extends StatelessWidget {
  const SuperficiePulsable({
    super.key,
    required this.child,
    required this.onPressed,
    this.estilo = EstiloBoton.normal,
    this.seleccionado = false,
    this.alturaMinima = Medidas.tactilPrincipal,
    this.relleno = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final EstiloBoton estilo;
  final bool seleccionado;
  final double alturaMinima;
  final EdgeInsets relleno;

  /// Un botón no disponible pierde el relleno (se ve el fondo de la
  /// pantalla) pero su texto mantiene el contraste completo, para que se
  /// pueda leer la explicación de por qué no está disponible.
  static Color colorFondo(
    BuildContext context,
    EstiloBoton estilo, {
    bool activo = true,
  }) {
    final p = Paleta.of(context);
    if (!activo) return p.fondo;
    return estilo == EstiloBoton.peligro ? p.peligro : p.boton;
  }

  static Color colorPrimerPlano(
    BuildContext context,
    EstiloBoton estilo, {
    bool activo = true,
  }) {
    final p = Paleta.of(context);
    if (!activo) return p.texto;
    return estilo == EstiloBoton.peligro ? p.textoPeligro : p.textoBoton;
  }

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final activo = onPressed != null;
    final primerPlano = colorPrimerPlano(context, estilo, activo: activo);
    final borde = seleccionado
        ? BorderSide(color: p.seleccion, width: Medidas.grosorSeleccion)
        : BorderSide(
            color: activo ? p.borde : p.texto.withValues(alpha: 0.6),
            width: activo ? Medidas.grosorBorde : 1.5,
          );

    return Material(
      color: colorFondo(context, estilo, activo: activo),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Medidas.radio),
        side: borde,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        splashColor: primerPlano.withValues(alpha: 0.25),
        highlightColor: primerPlano.withValues(alpha: 0.18),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: alturaMinima,
            minWidth: Medidas.tactilPrincipal,
          ),
          child: Padding(
            padding: relleno,
            child: IconTheme.merge(
              data: IconThemeData(color: primerPlano),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: primerPlano),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón grande a todo el ancho con icono opcional, etiqueta y una breve
/// descripción debajo de la etiqueta.
class BotonGrande extends StatelessWidget {
  const BotonGrande({
    super.key,
    required this.etiqueta,
    required this.onPressed,
    this.icono,
    this.descripcion,
    this.estilo = EstiloBoton.normal,
    this.etiquetaSemantica,
    this.centrado = false,
  });

  final String etiqueta;
  final String? descripcion;
  final IconData? icono;
  final VoidCallback? onPressed;
  final EstiloBoton estilo;
  final bool centrado;

  /// Texto que leerá TalkBack si debe ser distinto de la etiqueta visible
  /// (por ejemplo, para incluir el nombre del medicamento a eliminar).
  final String? etiquetaSemantica;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final color = SuperficiePulsable.colorPrimerPlano(
      context,
      estilo,
      activo: onPressed != null,
    );
    final alineacion = centrado
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final alineacionTexto = centrado ? TextAlign.center : TextAlign.start;

    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      label: etiquetaSemantica ?? etiqueta,
      hint: descripcion,
      onTap: onPressed,
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        child: SuperficiePulsable(
          onPressed: onPressed,
          estilo: estilo,
          child: Row(
            mainAxisAlignment: centrado
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (icono != null) ...[
                Icon(icono, size: Medidas.iconoBoton, color: color),
                const SizedBox(width: 16),
              ],
              Flexible(
                fit: centrado ? FlexFit.loose : FlexFit.tight,
                child: Column(
                  crossAxisAlignment: alineacion,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      etiqueta,
                      textAlign: alineacionTexto,
                      style: textos.titleMedium!.copyWith(color: color),
                    ),
                    if (descripcion != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        descripcion!,
                        textAlign: alineacionTexto,
                        style: textos.bodyLarge!.copyWith(color: color),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarjeta-botón con pictograma grande y etiqueta debajo (menú principal y
/// submenús).
class TarjetaMenu extends StatelessWidget {
  const TarjetaMenu({
    super.key,
    required this.etiqueta,
    required this.icono,
    required this.onPressed,
    this.descripcion,
    this.estiloEtiqueta,
    this.rellenoHorizontal = rellenoHorizontalNormal,
    this.alturaMinima = 140,
  });

  final double alturaMinima;

  final String etiqueta;
  final Widget icono;
  final String? descripcion;
  final VoidCallback onPressed;

  /// Por defecto `titleMedium`; la cuadrícula del menú usa el tamaño base
  /// para que quepan dos tarjetas por fila.
  final TextStyle? estiloEtiqueta;
  final double rellenoHorizontal;

  static const double rellenoHorizontalNormal = 12;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final color = SuperficiePulsable.colorPrimerPlano(
      context,
      EstiloBoton.normal,
    );
    return Semantics(
      container: true,
      button: true,
      label: etiqueta,
      hint: descripcion,
      onTap: onPressed,
      excludeSemantics: true,
      child: SuperficiePulsable(
        onPressed: onPressed,
        alturaMinima: alturaMinima,
        relleno: EdgeInsets.symmetric(
          horizontal: rellenoHorizontal,
          vertical: 18,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icono,
              const SizedBox(height: 12),
              Text(
                etiqueta,
                textAlign: TextAlign.center,
                style: (estiloEtiqueta ?? textos.titleMedium!).copyWith(
                  color: color,
                ),
              ),
              if (descripcion != null) ...[
                const SizedBox(height: 6),
                Text(
                  descripcion!,
                  textAlign: TextAlign.center,
                  style: textos.bodyLarge!.copyWith(color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón cuadrado con un símbolo grande (por ejemplo "+" o "−").
class BotonSimbolo extends StatelessWidget {
  const BotonSimbolo({
    super.key,
    required this.icono,
    required this.etiquetaSemantica,
    required this.onPressed,
    this.tamano = 72,
  });

  final IconData icono;
  final String etiquetaSemantica;
  final VoidCallback? onPressed;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      label: etiquetaSemantica,
      onTap: onPressed,
      excludeSemantics: true,
      child: SizedBox(
        width: tamano,
        height: tamano,
        child: SuperficiePulsable(
          onPressed: onPressed,
          alturaMinima: tamano,
          relleno: EdgeInsets.zero,
          child: Center(
            child: Icon(
              icono,
              size: tamano * 0.6,
              color: SuperficiePulsable.colorPrimerPlano(
                context,
                EstiloBoton.normal,
                activo: onPressed != null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
