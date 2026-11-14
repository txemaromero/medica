import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../archivos/servicio_archivos.dart';
import '../features/agenda/data/cita_repository.dart';
import '../features/ajustes/data/ajustes_repository.dart';
import '../features/compartir/data/restauracion_datos.dart';
import '../features/emergencias/marcador_telefono.dart';
import '../features/medicamentos/data/borrador_repository.dart';
import '../features/medicamentos/data/fotos.dart';
import '../features/medicamentos/data/medicamento_repository.dart';
import '../features/tomas/data/toma_repository.dart';
import '../notificaciones/bateria.dart';
import '../notificaciones/servicio_notificaciones.dart';
import '../voz/servicio_voz.dart';
import '../widget_inicio/servicio_widget.dart';

/// Dependencias de infraestructura. Las que necesitan inicializarse de forma
/// asíncrona (preferencias, base de datos, notificaciones, carpeta de fotos)
/// se sobrescriben en `main.dart`; en los tests se sustituyen por versiones
/// en memoria.

final preferenciasProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Se inicializa en main()'),
);

final baseDatosProvider = Provider<Database>(
  (ref) => throw UnimplementedError('Se inicializa en main()'),
);

final servicioNotificacionesProvider = Provider<ServicioNotificaciones>(
  (ref) => throw UnimplementedError('Se inicializa en main()'),
);

/// Hora actual; se sustituye en los tests para que sean deterministas.
final relojProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final marcadorTelefonoProvider = Provider<MarcadorTelefono>(
  (ref) => const MarcadorTelefonoSistema(),
);

final medicamentoRepositoryProvider = Provider<MedicamentoRepository>(
  (ref) => MedicamentoRepositorySqlite(
    ref.watch(baseDatosProvider),
    reloj: ref.watch(relojProvider),
  ),
);

final citaRepositoryProvider = Provider<CitaRepository>(
  (ref) => CitaRepositorySqlite(ref.watch(baseDatosProvider)),
);

final restauracionDatosProvider = Provider<RestauracionDatos>(
  (ref) => RestauracionDatosSqlite(ref.watch(baseDatosProvider)),
);

final ajustesRepositoryProvider = Provider<AjustesRepository>(
  (ref) => AjustesRepositoryPreferencias(ref.watch(preferenciasProvider)),
);

final tomaRepositoryProvider = Provider<TomaRepository>(
  (ref) => TomaRepositorySqlite(ref.watch(baseDatosProvider)),
);

final almacenFotosProvider = Provider<AlmacenFotos>(
  (ref) => throw UnimplementedError('Se inicializa en main()'),
);

final selectorFotosProvider = Provider<SelectorFotos>(
  (ref) => SelectorFotosSistema(),
);

final borradorRepositoryProvider = Provider<BorradorRepository>(
  (ref) => BorradorRepositoryPreferencias(ref.watch(preferenciasProvider)),
);

final servicioVozProvider = Provider<ServicioVoz>(
  (ref) => const ServicioVozCanal(),
);

final servicioArchivosProvider = Provider<ServicioArchivos>(
  (ref) => const ServicioArchivosSistema(),
);

final servicioBateriaProvider = Provider<ServicioBateria>(
  (ref) => const ServicioBateriaCanal(),
);

final servicioWidgetProvider = Provider<ServicioWidget>(
  (ref) => ServicioWidgetCanal(),
);
