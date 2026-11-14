// Prueba lenta (unos 3 minutos): programa avisos reales para dentro de un
// minuto y espera a que Android los muestre. Solo se ejecuta si se pide
// expresamente, con el permiso de notificaciones concedido (ver README):
//
//   flutter test integration_test/entrega_avisos_test.dart -d <dispositivo> \
//     --no-uninstall --dart-define=PRUEBA_ENTREGA=true
//
// Deja además programado un aviso para dentro de una hora, que sirve para
// comprobar que sobrevive a un reinicio del teléfono:
//   adb reboot && adb shell dumpsys alarm | grep saludmayores
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/servicio_notificaciones_locales.dart';

const int idDiario = 4141;
const int idUnico = 4242;
const int idParaReinicio = 4343;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'los avisos diarios y únicos llegan a su hora',
    (tester) async {
      final plugin = FlutterLocalNotificationsPlugin();
      final servicio = ServicioNotificacionesLocales(plugin: plugin);
      await servicio.inicializar();
      final android = plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      expect(
        await servicio.permisoConcedido(),
        isTrue,
        reason: 'Concede antes el permiso de notificaciones con adb',
      );
      final exactas = await servicio.puedeUsarAlarmasExactas();
      debugPrint('Alarmas exactas permitidas: $exactas');

      // El aviso diario se programa al principio del minuto siguiente + 1,
      // para dejar margen; el único, 70 segundos después de ahora.
      final ahora = DateTime.now();
      final dentroDeUnMinuto = ahora.add(const Duration(minutes: 2));
      final horaDiaria = HoraDelDia(
        dentroDeUnMinuto.hour,
        dentroDeUnMinuto.minute,
      );
      final momentoUnico = ahora.add(const Duration(seconds: 70));
      await plugin.cancelAll();
      await servicio.reemplazarTodos([
        // De tipo "toma", para comprobar también que llegan con sus botones.
        AvisoProgramado(
          id: idDiario,
          tipo: TipoAviso.toma,
          titulo: 'Prueba diaria',
          cuerpo: 'Aviso diario de prueba (${horaDiaria.texto}).',
          momento: CadaDia(horaDiaria),
        ),
        AvisoProgramado(
          id: idUnico,
          tipo: TipoAviso.toma,
          titulo: 'Prueba única',
          cuerpo: 'Aviso único de prueba.',
          momento: UnaVez(momentoUnico),
        ),
        AvisoProgramado(
          id: idParaReinicio,
          tipo: TipoAviso.cita,
          titulo: 'Prueba tras reinicio',
          cuerpo: 'Si ves esto tras reiniciar, el reinicio no borró el aviso.',
          momento: UnaVez(ahora.add(const Duration(hours: 1))),
        ),
      ], const CanalAvisos(sonido: true, vibracion: true));

      final pendientes = {
        for (final p in await plugin.pendingNotificationRequests()) p.id,
      };
      expect(pendientes, {idDiario, idUnico, idParaReinicio});

      // Se espera, en tiempo real, a que lleguen los dos primeros.
      final limite = ahora.add(const Duration(minutes: 4));
      var activas = <int>{};
      while (DateTime.now().isBefore(limite) &&
          !activas.containsAll({idDiario, idUnico})) {
        await Future<void>.delayed(const Duration(seconds: 5));
        activas = {
          for (final n in await plugin.getActiveNotifications()) n.id ?? -1,
        };
      }
      debugPrint(
        'Activas a las ${DateTime.now()}: $activas '
        '(diario programado a las ${horaDiaria.texto}, '
        'único a las $momentoUnico)',
      );
      expect(activas, containsAll({idUnico, idDiario}));

      // El diario sigue pendiente para mañana; el de una hora, también.
      final siguenPendientes = {
        for (final p in await plugin.pendingNotificationRequests()) p.id,
      };
      expect(siguenPendientes, containsAll({idDiario, idParaReinicio}));
      expect(siguenPendientes, isNot(contains(idUnico)));
      expect(android, isNotNull);
    },
    timeout: const Timeout(Duration(minutes: 6)),
    skip: !_pedida,
  );
}

const bool _pedida = bool.fromEnvironment('PRUEBA_ENTREGA');
