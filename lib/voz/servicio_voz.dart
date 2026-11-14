import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../l10n/textos.dart';

/// Resultado de pedir al teléfono que reconozca lo que dice la persona.
sealed class ResultadoDictado {
  const ResultadoDictado();
}

class DictadoReconocido extends ResultadoDictado {
  const DictadoReconocido(this.texto);

  final String texto;
}

/// La persona cerró el dictado o no se entendió nada.
class DictadoCancelado extends ResultadoDictado {
  const DictadoCancelado();
}

/// El teléfono no tiene dictado por voz.
class DictadoNoDisponible extends ResultadoDictado {
  const DictadoNoDisponible();
}

/// Voz del teléfono: leer textos en voz alta y dictar.
abstract interface class ServicioVoz {
  /// Lee [texto] en voz alta, cortando lo que se estuviera leyendo. Devuelve
  /// `false` si el teléfono no tiene voz en español.
  Future<bool> hablar(String texto);

  Future<void> callar();

  /// `true` si el teléfono tiene dictado por voz.
  Future<bool> puedeDictar();

  /// Abre la pantalla de dictado del propio teléfono ("Habla ahora"), que
  /// muestra [indicacion]. La app no graba nada ni necesita el permiso del
  /// micrófono: solo recibe el texto reconocido.
  Future<ResultadoDictado> dictar(String indicacion);
}

/// Implementación con el canal nativo de `MainActivity.kt`.
class ServicioVozCanal implements ServicioVoz {
  const ServicioVozCanal();

  static const MethodChannel _canal = MethodChannel(
    'es.saludmayores.salud_mayores/voz',
  );

  /// Sin implementación nativa (iOS, tests) o si falla, la voz se da por no
  /// disponible: la app sigue funcionando igual, solo que sin hablar.
  Future<T?> _invocar<T>(String metodo, [Map<String, Object?>? datos]) async {
    try {
      return await _canal.invokeMethod<T>(metodo, datos);
    } on MissingPluginException {
      return null;
    } on PlatformException catch (error) {
      debugPrint('Voz: $metodo ha fallado ($error)');
      return null;
    }
  }

  @override
  Future<bool> hablar(String texto) async =>
      await _invocar<bool>('hablar', {
        'texto': texto,
        'idioma': textosApp.localeName,
      }) ??
      false;

  @override
  Future<void> callar() => _invocar<void>('callar');

  @override
  Future<bool> puedeDictar() async =>
      await _invocar<bool>('puedeDictar') ?? false;

  @override
  Future<ResultadoDictado> dictar(String indicacion) async {
    final respuesta = await _invocar<Map<Object?, Object?>>('dictar', {
      'indicacion': indicacion,
      'idioma': textosApp.localeName,
    });
    return switch (respuesta?['estado']) {
      'reconocido' => DictadoReconocido(respuesta!['texto']! as String),
      'cancelado' => const DictadoCancelado(),
      _ => const DictadoNoDisponible(),
    };
  }
}
