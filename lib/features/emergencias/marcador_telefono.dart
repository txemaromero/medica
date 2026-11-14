import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ajustes/domain/validador_telefono.dart';

/// Abre el marcador del teléfono con un número ya escrito. No llama
/// directamente: la persona confirma la llamada en el propio marcador.
abstract interface class MarcadorTelefono {
  /// Devuelve `false` si no se ha podido abrir el marcador.
  Future<bool> abrirMarcador(String numero);
}

class MarcadorTelefonoSistema implements MarcadorTelefono {
  const MarcadorTelefonoSistema();

  /// Solo con un número que admite Ajustes: así nunca se marca algo raro
  /// (como un código `*#…`), venga de donde venga.
  @override
  Future<bool> abrirMarcador(String numero) async {
    if (ValidadorTelefono.validar(numero) != null) return false;
    final uri = Uri(scheme: 'tel', path: ValidadorTelefono.limpiar(numero));
    try {
      return await launchUrl(uri);
    } on Object catch (error) {
      debugPrint('No se ha podido abrir el marcador: $error');
      return false;
    }
  }
}
