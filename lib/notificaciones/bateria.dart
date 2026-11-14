import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../features/ajustes/domain/estado_avisos.dart';

/// Lo que el teléfono hace con la batería de la app, que puede retrasar o
/// impedir los avisos.
abstract interface class ServicioBateria {
  Future<EstadoBateria> estado();

  /// Abre la pantalla de la app en los ajustes del teléfono, donde se elige
  /// su uso de batería.
  Future<void> abrirAjustesDeLaApp();
}

/// Implementación con el canal de `CanalSistema.kt`.
class ServicioBateriaCanal implements ServicioBateria {
  const ServicioBateriaCanal();

  static const MethodChannel _canal = MethodChannel(
    'es.saludmayores.salud_mayores/sistema',
  );

  /// Sin implementación nativa (iOS) o si falla, se da por bueno: la
  /// comprobación solo sirve para avisar, no para impedir nada.
  @override
  Future<EstadoBateria> estado() async {
    try {
      final datos = await _canal.invokeMapMethod<String, Object?>('bateria');
      return EstadoBateria(
        optimizada: datos?['optimizada'] == true,
        restringida: datos?['restringida'] == true,
        fabricante: datos?['fabricante'] as String? ?? '',
      );
    } on MissingPluginException {
      return const EstadoBateria();
    } on PlatformException catch (error) {
      debugPrint('Batería: $error');
      return const EstadoBateria();
    }
  }

  @override
  Future<void> abrirAjustesDeLaApp() async {
    try {
      await _canal.invokeMethod<void>('abrirAjustesDeLaApp');
    } on MissingPluginException {
      // En iOS no hay nada que abrir: el botón no llega a aparecer.
    }
  }
}
