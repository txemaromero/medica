import 'package:flutter/widgets.dart';

import 'textos_app.dart';

export 'textos_app.dart';

/// Idioma de los textos que se generan fuera de los widgets.
Locale _idioma = const Locale('es');

/// Textos de la app en el idioma actual, para el código que no tiene un
/// `BuildContext` a mano: avisos, lectura en voz alta, PDF, validaciones y
/// fechas. Es lo mismo que hace `Intl.defaultLocale` en el paquete `intl`.
///
/// En los widgets se usa `TextosApp.of(context)`.
TextosApp get textosApp => lookupTextosApp(_idioma);

/// La app lo llama con el idioma elegido para los widgets (el del teléfono si
/// está traducido; si no, castellano). Devuelve `true` si ha cambiado.
bool cambiarIdioma(Locale idioma) {
  final cambia = idioma != _idioma;
  _idioma = idioma;
  return cambia;
}

/// El idioma del teléfono si la app está traducida a él; si no, el primero
/// de la lista (castellano). Es lo mismo que elige `MaterialApp`.
Locale idiomaDelTelefono() => basicLocaleListResolution(
  WidgetsBinding.instance.platformDispatcher.locales,
  TextosApp.supportedLocales,
);
