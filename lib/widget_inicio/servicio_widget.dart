import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../notificaciones/carga_aviso.dart';

/// El widget de la pantalla de inicio ("Próxima toma"; ver `WidgetToma.kt`).
abstract interface class ServicioWidget {
  /// Pone al día lo que muestra (ver `DatosWidget`).
  Future<void> actualizar(Map<String, Object?> datos);

  /// Si la app se ha abierto desde el widget, lo que se pulsó.
  Future<RespuestaAviso?> accionInicial();

  /// Lo que se pulsa en el widget con la app ya abierta.
  Stream<RespuestaAviso> get acciones;

  /// Pide al teléfono que ponga el widget en la pantalla de inicio. `false`
  /// si el teléfono no sabe hacerlo (hay que ponerlo a mano).
  Future<bool> pedirAnadir();
}

/// Implementación con el canal de `CanalWidget.kt`. Lo que se pulsa en el
/// widget llega como la respuesta a un aviso: "Ya la he tomado" o tocarlo.
class ServicioWidgetCanal implements ServicioWidget {
  ServicioWidgetCanal() {
    _canal.setMethodCallHandler((llamada) async {
      if (llamada.method == 'accion') {
        _acciones.add(_respuesta(llamada.arguments));
      }
    });
  }

  static const MethodChannel _canal = MethodChannel(
    'es.saludmayores.salud_mayores/widget',
  );

  final _acciones = StreamController<RespuestaAviso>.broadcast();

  static RespuestaAviso _respuesta(Object? datos) {
    final mapa = datos is Map ? datos : const {};
    return RespuestaAviso(
      accion: mapa['accion'] as String?,
      carga: mapa['carga'] as String?,
    );
  }

  @override
  Stream<RespuestaAviso> get acciones => _acciones.stream;

  /// Sin implementación nativa (iOS) no hay widget: no se hace nada.
  @override
  Future<void> actualizar(Map<String, Object?> datos) async {
    try {
      await _canal.invokeMethod<void>('actualizar', {
        'datos': jsonEncode(datos),
      });
    } on MissingPluginException {
      // Sin widget.
    } on PlatformException catch (error) {
      debugPrint('Widget: $error');
    }
  }

  @override
  Future<RespuestaAviso?> accionInicial() async {
    try {
      final datos = await _canal.invokeMethod<Object?>('accionInicial');
      return datos == null ? null : _respuesta(datos);
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Future<bool> pedirAnadir() async {
    try {
      return await _canal.invokeMethod<bool>('pedirAnadir') ?? false;
    } on MissingPluginException {
      return false;
    }
  }
}
