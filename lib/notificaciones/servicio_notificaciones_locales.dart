import 'dart:async';
import 'dart:io';
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_datos;
import 'package:timezone/timezone.dart' as tz;

import '../features/ajustes/domain/ajustes.dart';
import '../features/medicamentos/data/fotos.dart';
import '../l10n/textos.dart';
import 'carga_aviso.dart';
import 'planificador_avisos.dart';
import 'servicio_notificaciones.dart';

/// Implementación con `flutter_local_notifications`.
///
/// - Los avisos de medicación se programan como diarios
///   (`DateTimeComponents.time`).
/// - Tras reiniciar el teléfono, el `ScheduledNotificationBootReceiver` del
///   plugin (declarado en el `AndroidManifest.xml`) vuelve a programarlos, y
///   además la app los resincroniza cada vez que se abre.
/// - Si no hay permiso de alarmas exactas se usan alarmas inexactas, que
///   pueden llegar unos minutos tarde pero siguen llegando.
/// - Los avisos de tomas llevan los botones "Ya la he tomado" y "Recordar en
///   10 min" (con los minutos elegidos en Ajustes). Ambos abren la app: la
///   persona ve al momento qué ha pasado y la respuesta se atiende en el
///   mismo sitio que el resto de la app.
/// - Si el medicamento tiene foto de la caja, el aviso la muestra.
class ServicioNotificacionesLocales implements ServicioNotificaciones {
  ServicioNotificacionesLocales({
    FlutterLocalNotificationsPlugin? plugin,
    this._fotos,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final AlmacenFotos? _fotos;
  final _respuestas = StreamController<RespuestaAviso>.broadcast();

  @override
  Stream<RespuestaAviso> get respuestas => _respuestas.stream;

  @override
  Future<RespuestaAviso?> respuestaInicial() async {
    final detalles = await _plugin.getNotificationAppLaunchDetails();
    final respuesta = detalles?.notificationResponse;
    if (!(detalles?.didNotificationLaunchApp ?? false) || respuesta == null) {
      return null;
    }
    return RespuestaAviso(accion: respuesta.actionId, carga: respuesta.payload);
  }

  static const String zonaHorariaPorDefecto = 'Europe/Madrid';

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> inicializar() async {
    tz_datos.initializeTimeZones();
    try {
      final zona = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zona.identifier));
    } on Object catch (error) {
      debugPrint(
        'Zona horaria desconocida ($error); se usa '
        '$zonaHorariaPorDefecto.',
      );
      tz.setLocalLocation(tz.getLocation(zonaHorariaPorDefecto));
    }

    await _plugin.initialize(
      settings: InitializationSettings(
        // Silueta blanca del frasco: Android solo usa la forma del icono en
        // la barra de estado (ver tool/icono/icono_test.dart).
        android: const AndroidInitializationSettings(
          '@drawable/ic_notificacion',
        ),
        // Los permisos se piden solo cuando la persona activa los avisos.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [
            for (final minutos in Ajustes.opcionesAplazamiento)
              _categoriaBotonesDeToma(minutos),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: (respuesta) => _respuestas.add(
        RespuestaAviso(accion: respuesta.actionId, carga: respuesta.payload),
      ),
    );
  }

  @override
  Future<bool> solicitarPermiso() async {
    final android = _android;
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _ios;
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  @override
  Future<bool> permisoConcedido() async {
    final android = _android;
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    final ios = _ios;
    if (ios != null) {
      final permisos = await ios.checkPermissions();
      return permisos?.isEnabled ?? false;
    }
    return false;
  }

  @override
  Future<void> abrirAjustesDelTelefono() async {
    await (_android?.openAppNotificationSettings() ??
        _ios?.openAppNotificationSettings());
  }

  @override
  Future<bool> puedeUsarAlarmasExactas() async =>
      await _android?.canScheduleExactNotifications() ?? true;

  @override
  Future<void> solicitarAlarmasExactas() async {
    await _android?.requestExactAlarmsPermission();
  }

  @override
  Future<void> mostrarAvisoDePrueba(CanalAvisos canal) async {
    await _crearCanal(canal);
    await _plugin.show(
      id: PlanificadorAvisos.idAvisoDePrueba,
      title: textosApp.avisoPruebaTitulo,
      body: textosApp.avisoPruebaCuerpo,
      notificationDetails: _detalles(canal),
    );
  }

  Future<void> _crearCanal(CanalAvisos canal) async {
    await _android?.createNotificationChannel(
      AndroidNotificationChannel(
        canal.id,
        canal.nombre,
        description: _descripcionCanal,
        importance: Importance.high,
        playSound: canal.sonido,
        enableVibration: canal.vibracion,
      ),
    );
  }

  static String get _descripcionCanal => textosApp.canalDescripcion;

  static String get _textoTomada => textosApp.tomasMarcar;
  static String _textoAplazar(int minutos) => textosApp.avisoAplazar(minutos);

  static List<AndroidNotificationAction> _botonesDeToma(int minutos) => [
    AndroidNotificationAction(
      AccionesAviso.tomada,
      _textoTomada,
      showsUserInterface: true,
    ),
    AndroidNotificationAction(
      AccionesAviso.aplazar,
      _textoAplazar(minutos),
      showsUserInterface: true,
    ),
  ];

  /// En iOS los botones se definen como categorías de notificación al
  /// empezar, así que hay una por cada opción de minutos de Ajustes. Con
  /// `foreground` abren la app, igual que en Android, y la respuesta llega por
  /// el mismo camino. (Configurado, pero sin probar en un iPhone.)
  static String _categoriaToma(int minutos) => 'toma_$minutos';
  static DarwinNotificationCategory _categoriaBotonesDeToma(int minutos) =>
      DarwinNotificationCategory(
        _categoriaToma(minutos),
        actions: [
          DarwinNotificationAction.plain(
            AccionesAviso.tomada,
            _textoTomada,
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            AccionesAviso.aplazar,
            _textoAplazar(minutos),
            options: {DarwinNotificationActionOption.foreground},
          ),
        ],
      );

  /// Azul marino del icono de la app: Android lo usa de fondo del icono
  /// pequeño en la cabecera del aviso.
  static const Color _colorAvisos = Color(0xFF0A2540);

  /// Con [minutosAplazamiento], el aviso lleva los botones de las tomas.
  static NotificationDetails _detalles(
    CanalAvisos canal, {
    int? minutosAplazamiento,
    String? rutaFoto,
  }) => NotificationDetails(
    android: AndroidNotificationDetails(
      canal.id,
      canal.nombre,
      channelDescription: _descripcionCanal,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      color: _colorAvisos,
      largeIcon: rutaFoto == null ? null : FilePathAndroidBitmap(rutaFoto),
      playSound: canal.sonido,
      enableVibration: canal.vibracion,
      styleInformation: const BigTextStyleInformation(''),
      actions: minutosAplazamiento == null
          ? null
          : _botonesDeToma(minutosAplazamiento),
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: canal.sonido,
      categoryIdentifier: minutosAplazamiento == null
          ? null
          : _categoriaToma(minutosAplazamiento),
    ),
  );

  /// Lo programado en esta ejecución de la app: identificador → firma (todo
  /// lo que define el aviso) y, si es único, cuándo suena.
  final Map<int, ({String firma, DateTime? unaVez})> _programados = {};
  bool _todoReprogramado = false;

  /// La primera vez en cada ejecución de la app se reprograma todo desde
  /// cero (así se recupera cualquier aviso que Android haya descartado, por
  /// ejemplo tras "Forzar detención"). Después solo se cancela lo que sobra y
  /// se programa lo nuevo o lo que ha cambiado: es mucho más rápido.
  @override
  Future<void> reemplazarTodos(
    List<AvisoProgramado> avisos,
    CanalAvisos canal,
  ) async {
    final modo = await puedeUsarAlarmasExactas()
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    final ahoraZona = tz.TZDateTime.now(tz.local);
    final ahora = DateTime(
      ahoraZona.year,
      ahoraZona.month,
      ahoraZona.day,
      ahoraZona.hour,
      ahoraZona.minute,
      ahoraZona.second,
    );

    final nuevos =
        <
          int,
          ({
            AvisoProgramado aviso,
            String firma,
            DateTime fecha,
            DateTimeComponents? repetir,
          })
        >{};
    for (final aviso in avisos) {
      final (fecha, repetir) = switch (aviso.momento) {
        // Para los diarios Android solo usa la hora: la fecha la recalcula él.
        CadaDia(:final hora) => (
          hora.siguienteDesde(ahora),
          DateTimeComponents.time,
        ),
        // Igual para los semanales: Android usa el día de la semana y la hora.
        final CadaSemana semanal => (
          semanal.siguienteDesde(ahora),
          DateTimeComponents.dayOfWeekAndTime,
        ),
        UnaVez(:final fechaHora) => (fechaHora, null),
      };
      if (!fecha.isAfter(ahora)) continue;
      nuevos[aviso.id] = (
        aviso: aviso,
        firma: [
          modo.name,
          canal.id,
          aviso.momento,
          aviso.titulo,
          aviso.cuerpo,
          aviso.carga,
          aviso.conBotonesDeToma,
          aviso.minutosAplazamiento,
          aviso.foto,
        ].join('|'),
        fecha: fecha,
        repetir: repetir,
      );
    }

    try {
      if (!_todoReprogramado) {
        // Solo se cancelan los avisos pendientes: las notificaciones que ya
        // están en la bandeja se conservan para no borrar un aviso sin leer.
        await _plugin.cancelAllPendingNotifications();
        _programados.clear();
      } else {
        for (final MapEntry(key: id, value: anterior) in _programados.entries) {
          if (nuevos.containsKey(id)) continue;
          // Un aviso único que ya sonó no se cancela: borraría de la bandeja
          // una notificación quizá sin leer.
          final yaSono =
              anterior.unaVez != null && !anterior.unaVez!.isAfter(ahora);
          if (!yaSono) await _plugin.cancel(id: id);
        }
      }

      if (nuevos.isNotEmpty) await _crearCanal(canal);
      for (final MapEntry(key: id, value: n) in nuevos.entries) {
        if (_programados[id]?.firma == n.firma) continue;
        await _plugin.zonedSchedule(
          id: id,
          title: n.aviso.titulo,
          body: n.aviso.cuerpo,
          payload: n.aviso.carga,
          scheduledDate: _enZonaLocal(n.fecha),
          notificationDetails: _detalles(
            canal,
            minutosAplazamiento: n.aviso.conBotonesDeToma
                ? n.aviso.minutosAplazamiento
                : null,
            rutaFoto: await _rutaFoto(n.aviso.foto),
          ),
          androidScheduleMode: modo,
          matchDateTimeComponents: n.repetir,
        );
      }
      _programados
        ..clear()
        ..addAll({
          for (final MapEntry(key: id, value: n) in nuevos.entries)
            id: (firma: n.firma, unaVez: n.repetir == null ? n.fecha : null),
        });
      _todoReprogramado = true;
    } on Object {
      // Si algo falla a medias, la próxima vez se reprograma todo.
      _todoReprogramado = false;
      rethrow;
    }
  }

  /// Ruta de la foto si existe el fichero (si no, el aviso sale sin foto).
  Future<String?> _rutaFoto(String? nombre) async {
    final fotos = _fotos;
    if (nombre == null || fotos == null) return null;
    final ruta = fotos.ruta(nombre);
    return await File(ruta).exists() ? ruta : null;
  }

  /// Interpreta la fecha como hora local de la zona del teléfono (así un aviso
  /// a las 8:00 sigue siendo a las 8:00 tras un cambio de horario).
  static tz.TZDateTime _enZonaLocal(DateTime fecha) => tz.TZDateTime(
    tz.local,
    fecha.year,
    fecha.month,
    fecha.day,
    fecha.hour,
    fecha.minute,
  );
}
