import 'carga_aviso.dart';
import 'planificador_avisos.dart';

/// Acceso a las notificaciones locales del sistema operativo.
abstract interface class ServicioNotificaciones {
  Future<void> inicializar();

  /// Lo que la persona hace con los avisos (tocar la notificación o pulsar
  /// uno de sus botones) mientras la app está en marcha.
  Stream<RespuestaAviso> get respuestas;

  /// La respuesta que abrió la app, si se abrió desde un aviso.
  Future<RespuestaAviso?> respuestaInicial();

  /// Pide permiso para mostrar notificaciones (necesario en Android 13+).
  /// Devuelve `true` si el permiso está concedido.
  Future<bool> solicitarPermiso();

  /// `true` si ahora mismo el teléfono deja mostrar los avisos de la app (la
  /// persona puede haber quitado el permiso desde los ajustes del teléfono).
  Future<bool> permisoConcedido();

  /// Abre la pantalla de notificaciones de la app en los ajustes del teléfono.
  Future<void> abrirAjustesDelTelefono();

  /// `true` si el sistema permite programar avisos a la hora exacta
  /// (Android 12+ puede exigir un permiso especial).
  Future<bool> puedeUsarAlarmasExactas();

  /// Abre la pantalla del sistema donde se concede el permiso de alarmas
  /// exactas.
  Future<void> solicitarAlarmasExactas();

  /// Cancela todos los avisos programados y programa [avisos] en [canal].
  Future<void> reemplazarTodos(List<AvisoProgramado> avisos, CanalAvisos canal);

  /// Muestra un aviso al momento con el sonido y la vibración de [canal], para
  /// comprobar cómo llegarán los recordatorios.
  Future<void> mostrarAvisoDePrueba(CanalAvisos canal);
}
