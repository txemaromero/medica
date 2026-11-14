import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tema/paleta.dart';
import '../tema/tema_visual.dart';
import 'mensaje_error.dart';

/// Campo de texto con etiqueta grande encima, descripción breve y mensaje de
/// error debajo cuando hace falta.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.controller,
    this.descripcion,
    this.error,
    this.teclado = TextInputType.text,
    this.accion = TextInputAction.next,
    this.formateadores,
    this.lineas = 1,
    this.capitalizacion = TextCapitalization.sentences,
    this.onSubmitted,
    this.focusNode,
  });

  final String etiqueta;
  final String? descripcion;
  final String? error;
  final TextEditingController controller;
  final TextInputType teclado;
  final TextInputAction accion;
  final List<TextInputFormatter>? formateadores;
  final int lineas;
  final TextCapitalization capitalizacion;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final textos = Theme.of(context).textTheme;
    final bordeError = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Medidas.radio),
      borderSide: BorderSide(color: p.bordeError, width: 4),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // La etiqueta visible se excluye de la semántica porque el propio
        // campo la anuncia a TalkBack.
        ExcludeSemantics(child: Text(etiqueta, style: textos.titleLarge)),
        if (descripcion != null) ...[
          const SizedBox(height: 4),
          ExcludeSemantics(child: Text(descripcion!, style: textos.bodyLarge)),
        ],
        const SizedBox(height: 10),
        // Nodo propio: si no, Flutter funde el campo con los textos y
        // encabezados de alrededor y TalkBack no lo puede enfocar bien.
        Semantics(
          container: true,
          label: etiqueta,
          hint: descripcion,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: teclado,
            textInputAction: accion,
            inputFormatters: formateadores,
            textCapitalization: capitalizacion,
            minLines: lineas,
            maxLines: lineas == 1 ? 1 : lineas + 2,
            onSubmitted: onSubmitted,
            // Tocar fuera del campo cierra el teclado, que si no tapa media
            // pantalla mientras se usan los demás controles.
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            style: textos.bodyLarge!.copyWith(
              color: p.textoBoton,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              enabledBorder: error != null ? bordeError : null,
              focusedBorder: error != null ? bordeError : null,
            ),
          ),
        ),
        if (error != null) MensajeError(error!),
      ],
    );
  }
}
