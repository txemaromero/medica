import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/proveedores.dart';
import '../core/tiempo/formato_fechas.dart';
import '../features/agenda/data/cita_repository.dart';
import '../features/ajustes/domain/ajustes.dart';
import '../features/medicamentos/data/medicamento_repository.dart';
import '../features/medicamentos/domain/existencias.dart';
import '../features/medicamentos/domain/medicamento.dart';
import '../features/tomas/domain/registro_toma.dart';
import '../widget_inicio/datos_widget.dart';
import '../widget_inicio/servicio_widget.dart';
import '../features/tomas/data/toma_repository.dart';
import 'planificador_avisos.dart';
import 'servicio_notificaciones.dart';

/// Mantiene los avisos del sistema al día con los datos guardados, y de paso
/// el widget de la pantalla de inicio.
///
/// Cada vez que cambia algo (se guarda, modifica o elimina un medicamento o
/// una cita, se marca o aplaza una toma, o cambian los interruptores de
/// Ajustes) se recalcula la lista completa y se reemplazan todos los avisos
/// programados. Lo que ya no está en la lista queda cancelado.
class SincronizadorAvisos {
  SincronizadorAvisos({
    required this._medicamentos,
    required this._citas,
    required this._tomas,
    required this._ajustes,
    required this._servicio,
    required this._widget,
    required this._reloj,
  });

  final MedicamentoRepository _medicamentos;
  final CitaRepository _citas;
  final TomaRepository _tomas;
  final Ajustes Function() _ajustes;
  final ServicioNotificaciones _servicio;
  final ServicioWidget _widget;
  final DateTime Function() _reloj;

  Future<void> _ultima = Future.value();

  /// Las sincronizaciones se encadenan para que dos cambios seguidos no se
  /// pisen. Un fallo se registra pero no interrumpe a la persona usuaria.
  ///
  /// Las pantallas no esperan a que termine (hablar con el sistema puede
  /// tardar algún segundo): los datos se guardan y se muestran al momento, y
  /// los avisos se ponen al día detrás.
  Future<void> sincronizar() {
    final siguiente = _ultima.then((_) => _sincronizarAhora());
    _ultima = siguiente;
    return siguiente;
  }

  /// Termina cuando se han aplicado todas las sincronizaciones pedidas hasta
  /// ahora.
  Future<void> esperar() => _ultima;

  Future<void> _sincronizarAhora() async {
    try {
      final ajustes = _ajustes();
      final ahora = _reloj();
      final hoy = FormatoFechas.soloFecha(ahora);
      final medicamentos = await _medicamentos.obtenerTodos();
      // Para las tomas basta de ayer a mañana: el planificador solo mira la
      // toma de hoy (y la de ayer, si su repetición cae pasada la
      // medianoche). Para las existencias, desde que se contaron.
      final ayer = DateTime(hoy.year, hoy.month, hoy.day - 1);
      final existencias = CalculoExistencias.registrosDesde(medicamentos);
      final registros = await _tomas.obtenerEntre(
        existencias != null && existencias.isBefore(ayer) ? existencias : ayer,
        DateTime(hoy.year, hoy.month, hoy.day + 1),
      );
      // El widget también cuando los avisos están desactivados.
      await _actualizarWidget(medicamentos, registros, ahora);
      final avisos = PlanificadorAvisos.planificar(
        medicamentos: medicamentos,
        citas: await _citas.obtenerTodas(),
        registros: registros,
        ajustes: ajustes,
        ahora: ahora,
      );
      await _servicio.reemplazarTodos(avisos, CanalAvisos.paraAjustes(ajustes));
    } on Object catch (error, pila) {
      debugPrint('No se han podido programar los avisos: $error\n$pila');
    }
  }

  Future<void> _actualizarWidget(
    List<Medicamento> medicamentos,
    List<RegistroToma> registros,
    DateTime ahora,
  ) async {
    try {
      await _widget.actualizar(
        DatosWidget.calcular(
          medicamentos: medicamentos,
          registros: registros,
          ahora: ahora,
        ),
      );
    } on Object catch (error) {
      debugPrint('No se ha podido poner al día el widget: $error');
    }
  }
}

final sincronizadorAvisosProvider = Provider<SincronizadorAvisos>(
  (ref) => SincronizadorAvisos(
    medicamentos: ref.watch(medicamentoRepositoryProvider),
    citas: ref.watch(citaRepositoryProvider),
    tomas: ref.watch(tomaRepositoryProvider),
    ajustes: () => ref.read(ajustesRepositoryProvider).cargar(),
    servicio: ref.watch(servicioNotificacionesProvider),
    widget: ref.watch(servicioWidgetProvider),
    reloj: ref.watch(relojProvider),
  ),
);
