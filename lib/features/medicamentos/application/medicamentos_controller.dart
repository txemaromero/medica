import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../notificaciones/sincronizador_avisos.dart';
import '../domain/medicamento.dart';

/// Lista de medicamentos guardados y operaciones sobre ella. Tras cada cambio
/// se reprograman los avisos.
class MedicamentosController extends AsyncNotifier<List<Medicamento>> {
  @override
  Future<List<Medicamento>> build() =>
      ref.watch(medicamentoRepositoryProvider).obtenerTodos();

  Future<Medicamento> crear(NuevoMedicamento nuevo) async {
    final creado = await ref.read(medicamentoRepositoryProvider).crear(nuevo);
    await _recargarYSincronizar();
    return creado;
  }

  Future<void> actualizar(Medicamento medicamento) async {
    await ref.read(medicamentoRepositoryProvider).actualizar(medicamento);
    await _recargarYSincronizar();
  }

  Future<void> eliminar(Medicamento medicamento) async {
    await ref.read(medicamentoRepositoryProvider).eliminar(medicamento.id);
    await _recargarYSincronizar();
  }

  Future<void> restaurar(Medicamento medicamento) async {
    await ref.read(medicamentoRepositoryProvider).restaurar(medicamento);
    await _recargarYSincronizar();
  }

  Future<void> _recargarYSincronizar() async {
    state = AsyncData(
      await ref.read(medicamentoRepositoryProvider).obtenerTodos(),
    );
    // Los avisos se ponen al día detrás, sin hacer esperar a la pantalla.
    unawaited(ref.read(sincronizadorAvisosProvider).sincronizar());
  }
}

final medicamentosProvider =
    AsyncNotifierProvider<MedicamentosController, List<Medicamento>>(
      MedicamentosController.new,
    );
