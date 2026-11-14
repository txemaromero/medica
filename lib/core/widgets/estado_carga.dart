import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/textos.dart';
import 'mensaje_error.dart';

/// Muestra un indicador mientras se cargan los datos, un mensaje claro si
/// fallan y el contenido cuando están listos.
class EstadoCarga<T> extends StatelessWidget {
  const EstadoCarga({
    super.key,
    required this.valor,
    required this.conDatos,
    required this.mensajeError,
  });

  final AsyncValue<T> valor;
  final Widget Function(T datos) conDatos;
  final String mensajeError;

  @override
  Widget build(BuildContext context) {
    final datos = valor.value;
    if (datos != null) return conDatos(datos);
    if (valor.hasError) return MensajeError(mensajeError);
    return Semantics(
      container: true,
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            const CircularProgressIndicator(strokeWidth: 6),
            const SizedBox(height: 16),
            Text(
              TextosApp.of(context).cargando,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
