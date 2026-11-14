import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/proveedores.dart';
import 'data/base_datos.dart';
import 'features/medicamentos/data/fotos.dart';
import 'l10n/textos.dart';
import 'notificaciones/servicio_notificaciones_locales.dart';
import 'notificaciones/sincronizador_avisos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Los avisos que se preparan antes de dibujar la primera pantalla también
  // van en el idioma del teléfono.
  cambiarIdioma(idiomaDelTelefono());

  final preferencias = await SharedPreferences.getInstance();
  final baseDatos = await BaseDatos.abrir();
  final fotos = AlmacenFotosCarpeta(
    Directory(p.join((await getApplicationDocumentsDirectory()).path, 'fotos')),
  );
  final notificaciones = ServicioNotificacionesLocales(fotos: fotos);
  try {
    await notificaciones.inicializar();
  } on Object catch (error) {
    // La app debe poder usarse aunque falle el sistema de avisos.
    debugPrint('No se han podido inicializar las notificaciones: $error');
  }

  final contenedor = ProviderContainer(
    overrides: [
      preferenciasProvider.overrideWithValue(preferencias),
      baseDatosProvider.overrideWithValue(baseDatos),
      servicioNotificacionesProvider.overrideWithValue(notificaciones),
      almacenFotosProvider.overrideWithValue(fotos),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: contenedor,
      child: const AppSaludMayores(),
    ),
  );

  // Al abrir la app se vuelven a programar todos los avisos, por si el
  // sistema los hubiera descartado (actualización, cambio de hora…).
  unawaited(contenedor.read(sincronizadorAvisosProvider).sincronizar());
  unawaited(_borrarFotosSinUso(contenedor, fotos));
}

Future<void> _borrarFotosSinUso(
  ProviderContainer contenedor,
  AlmacenFotos fotos,
) async {
  try {
    final medicamentos = await contenedor
        .read(medicamentoRepositoryProvider)
        .obtenerTodos();
    await fotos.limpiar({
      for (final m in medicamentos)
        if (m.foto != null) m.foto!,
    });
  } on Object catch (error) {
    debugPrint('No se han podido borrar las fotos sin uso: $error');
  }
}
