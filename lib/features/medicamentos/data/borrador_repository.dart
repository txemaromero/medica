import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/borrador_medicamento.dart';

/// Dónde se guarda el borrador del formulario de medicamento mientras la
/// cámara o la galería están abiertas.
abstract interface class BorradorRepository {
  BorradorMedicamento? leer();

  Future<void> guardar(BorradorMedicamento borrador);

  Future<void> borrar();
}

class BorradorRepositoryPreferencias implements BorradorRepository {
  BorradorRepositoryPreferencias(this._prefs);

  final SharedPreferences _prefs;

  static const String clave = 'borradorMedicamento';

  @override
  BorradorMedicamento? leer() {
    final texto = _prefs.getString(clave);
    if (texto == null) return null;
    try {
      return BorradorMedicamento.desdeJson(jsonDecode(texto));
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> guardar(BorradorMedicamento borrador) =>
      _prefs.setString(clave, jsonEncode(borrador.toJson()));

  @override
  Future<void> borrar() => _prefs.remove(clave);
}
