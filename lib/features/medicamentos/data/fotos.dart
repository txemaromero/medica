import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

/// Dónde se guardan las fotos de las cajas de los medicamentos.
///
/// En la base de datos solo se guarda el nombre del fichero: la ruta completa
/// de la carpeta de la app puede cambiar (por ejemplo, en iOS al actualizar).
abstract interface class AlmacenFotos {
  /// Copia la foto recién hecha o elegida (que el sistema deja en una carpeta
  /// temporal) y devuelve el nombre con el que se ha guardado.
  Future<String> guardar(String rutaOriginal);

  /// Imagen para mostrar en pantalla.
  ImageProvider imagen(String nombre);

  /// Ruta completa del fichero, para mostrar la foto en los avisos.
  String ruta(String nombre);

  /// Contenido de la foto, o `null` si no existe (copias de seguridad y PDF).
  Future<Uint8List?> leer(String nombre);

  /// Guarda una foto con ese nombre (al recuperar una copia de seguridad).
  Future<void> escribir(String nombre, Uint8List datos);

  /// Borra las fotos que ya no usa ningún medicamento (la de uno eliminado o
  /// la que se cambió por otra). Se llama al abrir la app, así "Deshacer"
  /// recupera también la foto mientras la app sigue abierta.
  Future<void> limpiar(Set<String> enUso);
}

class AlmacenFotosCarpeta implements AlmacenFotos {
  AlmacenFotosCarpeta(this.carpeta, {DateTime Function()? reloj})
    : _reloj = reloj ?? DateTime.now;

  final Directory carpeta;
  final DateTime Function() _reloj;

  @override
  String ruta(String nombre) => p.join(carpeta.path, nombre);

  @override
  ImageProvider imagen(String nombre) => FileImage(File(ruta(nombre)));

  @override
  Future<Uint8List?> leer(String nombre) async {
    final fichero = File(ruta(nombre));
    return await fichero.exists() ? fichero.readAsBytes() : null;
  }

  @override
  Future<void> escribir(String nombre, Uint8List datos) async {
    await carpeta.create(recursive: true);
    await File(ruta(nombre)).writeAsBytes(datos, flush: true);
  }

  @override
  Future<String> guardar(String rutaOriginal) async {
    await carpeta.create(recursive: true);
    final extension = p.extension(rutaOriginal).toLowerCase();
    final nombre =
        'caja_${_reloj().microsecondsSinceEpoch}'
        '${extension.isEmpty ? '.jpg' : extension}';
    await File(rutaOriginal).copy(ruta(nombre));
    return nombre;
  }

  @override
  Future<void> limpiar(Set<String> enUso) async {
    if (!await carpeta.exists()) return;
    await for (final entrada in carpeta.list()) {
      if (entrada is File && !enUso.contains(p.basename(entrada.path))) {
        await entrada.delete();
      }
    }
  }
}

enum OrigenFoto { camara, galeria }

abstract interface class SelectorFotos {
  /// Abre la cámara o la galería del teléfono. Devuelve la ruta de la foto, o
  /// `null` si la persona vuelve sin elegir ninguna.
  Future<String?> elegir(OrigenFoto origen);

  /// Si Android cerró la app mientras la cámara o la galería estaban
  /// abiertas, la foto que se hizo o eligió (el teléfono la guarda para este
  /// caso). `null` si no hay ninguna.
  Future<String?> recuperarPerdida();
}

class SelectorFotosSistema implements SelectorFotos {
  SelectorFotosSistema([ImagePicker? selector])
    : _selector = selector ?? ImagePicker();

  final ImagePicker _selector;

  @override
  Future<String?> elegir(OrigenFoto origen) async {
    final foto = await _selector.pickImage(
      source: switch (origen) {
        OrigenFoto.camara => ImageSource.camera,
        OrigenFoto.galeria => ImageSource.gallery,
      },
      // Basta para reconocer la caja y ocupa poco (unos 200 KB).
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
      requestFullMetadata: false,
    );
    return foto?.path;
  }

  @override
  Future<String?> recuperarPerdida() async {
    // Solo existe en Android.
    if (!Platform.isAndroid) return null;
    final perdida = await _selector.retrieveLostData();
    return perdida.isEmpty ? null : perdida.file?.path;
  }
}
