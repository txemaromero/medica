import 'dart:io';

import 'package:flutter/services.dart';

/// Carga Montserrat y los iconos Material reales en los tests que generan
/// imágenes (capturas del README e icono de la app). Sin esto, el motor de
/// tests dibuja cajas en lugar de letras.
Future<void> cargarFuentesReales() async {
  await _cargarFuente('Montserrat', [
    for (final peso in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold'])
      'assets/fonts/Montserrat-$peso.ttf',
  ]);
  final flutter =
      Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable)
          .parent
          .parent
          .parent
          .parent
          .parent
          .parent
          .path;
  await _cargarFuente('MaterialIcons', [
    '$flutter/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  ]);
}

Future<void> _cargarFuente(String familia, List<String> rutas) async {
  final cargador = FontLoader(familia);
  for (final ruta in rutas) {
    cargador.addFont(
      Future.value(ByteData.sublistView(File(ruta).readAsBytesSync())),
    );
  }
  await cargador.load();
}
