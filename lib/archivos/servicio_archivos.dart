import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

/// Ficheros que la persona comparte, guarda o abre: el PDF para el médico o
/// la familia y las copias de seguridad. Todo pasa por pantallas del propio
/// teléfono, así que la app no necesita permisos de almacenamiento.
abstract interface class ServicioArchivos {
  /// Abre el menú "Compartir" del teléfono (WhatsApp, correo…) con el
  /// fichero.
  Future<void> compartir({
    required String nombre,
    required String tipo,
    required Uint8List datos,
    required String asunto,
  });

  /// Pregunta dónde guardar el fichero (Descargas, Google Drive…). Devuelve
  /// `false` si la persona vuelve sin guardarlo.
  Future<bool> guardar({
    required String nombre,
    required String tipo,
    required Uint8List datos,
  });

  /// Pide elegir un fichero y devuelve su contenido, o `null` si la persona
  /// vuelve sin elegir.
  Future<Uint8List?> abrir();

  /// Abre la pantalla de imprimir del teléfono, que también permite
  /// guardarlo como PDF.
  Future<void> imprimirPdf({required String nombre, required Uint8List datos});
}

/// Implementación con el canal de `MainActivity.kt` y, para imprimir, el
/// paquete `printing`.
class ServicioArchivosSistema implements ServicioArchivos {
  const ServicioArchivosSistema();

  static const MethodChannel _canal = MethodChannel(
    'es.saludmayores.salud_mayores/archivos',
  );

  @override
  Future<void> compartir({
    required String nombre,
    required String tipo,
    required Uint8List datos,
    required String asunto,
  }) => _canal.invokeMethod<void>('compartir', {
    'nombre': nombre,
    'tipo': tipo,
    'datos': datos,
    'asunto': asunto,
  });

  @override
  Future<bool> guardar({
    required String nombre,
    required String tipo,
    required Uint8List datos,
  }) async =>
      await _canal.invokeMethod<bool>('guardar', {
        'nombre': nombre,
        'tipo': tipo,
        'datos': datos,
      }) ??
      false;

  @override
  Future<Uint8List?> abrir() => _canal.invokeMethod<Uint8List>('abrir');

  @override
  Future<void> imprimirPdf({
    required String nombre,
    required Uint8List datos,
  }) async {
    await Printing.layoutPdf(name: nombre, onLayout: (_) async => datos);
  }
}
