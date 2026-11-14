import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../notificaciones/sincronizador_avisos.dart';
import '../domain/cita.dart';

/// Citas guardadas, en orden cronológico. Tras cada cambio se reprograman
/// los avisos.
class CitasController extends AsyncNotifier<List<Cita>> {
  @override
  Future<List<Cita>> build() async => ordenarCronologicamente(
    await ref.watch(citaRepositoryProvider).obtenerTodas(),
  );

  Future<Cita> crear(NuevaCita nueva) async {
    final creada = await ref.read(citaRepositoryProvider).crear(nueva);
    await _recargarYSincronizar();
    return creada;
  }

  Future<void> actualizar(Cita cita) async {
    await ref.read(citaRepositoryProvider).actualizar(cita);
    await _recargarYSincronizar();
  }

  Future<void> eliminar(Cita cita) async {
    await ref.read(citaRepositoryProvider).eliminar(cita.id);
    await _recargarYSincronizar();
  }

  Future<void> restaurar(Cita cita) async {
    await ref.read(citaRepositoryProvider).restaurar(cita);
    await _recargarYSincronizar();
  }

  Future<void> _recargarYSincronizar() async {
    state = AsyncData(
      ordenarCronologicamente(
        await ref.read(citaRepositoryProvider).obtenerTodas(),
      ),
    );
    // Los avisos se ponen al día detrás, sin hacer esperar a la pantalla.
    unawaited(ref.read(sincronizadorAvisosProvider).sincronizar());
  }
}

final citasProvider = AsyncNotifierProvider<CitasController, List<Cita>>(
  CitasController.new,
);
