import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/proveedores.dart';
import '../features/ajustes/application/ajustes_controller.dart';

/// Lee textos en voz alta solo si la persona ha activado "Leer en voz alta"
/// en Ajustes.
class Lector {
  Lector(this._ref);

  final Ref _ref;

  bool get activado => _ref.read(ajustesProvider).leerEnVozAlta;

  Future<void> leer(String texto) async {
    if (!activado) return;
    await _ref.read(servicioVozProvider).hablar(texto);
  }

  Future<void> callar() => _ref.read(servicioVozProvider).callar();
}

final lectorProvider = Provider<Lector>(Lector.new);

/// `true` si el teléfono tiene dictado por voz (se consulta una vez).
final puedeDictarProvider = FutureProvider<bool>(
  (ref) => ref.watch(servicioVozProvider).puedeDictar(),
);
