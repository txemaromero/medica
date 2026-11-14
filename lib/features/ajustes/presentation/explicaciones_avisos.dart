import 'package:flutter/material.dart';

import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../l10n/textos.dart';
import '../application/ajustes_controller.dart';
import '../domain/estado_avisos.dart';

/// Explica a la persona qué ha pasado al activar o desactivar los avisos y,
/// si falta algún permiso del teléfono, le ofrece darlo. Se usa en Ajustes y
/// en el asistente de la primera vez.
///
/// Con [avisarSiActivadas] a `false` no se muestra el mensaje de "activadas"
/// (el asistente ya lo enseña en la propia pantalla).
Future<void> explicarResultadoNotificaciones(
  BuildContext context,
  AjustesController controlador,
  ResultadoNotificaciones resultado, {
  bool avisarSiActivadas = true,
}) async {
  final t = TextosApp.of(context);
  switch (resultado) {
    case ResultadoNotificaciones.activadas:
      if (avisarSiActivadas) {
        mostrarAviso(context, t.permisosNotificacionesActivadas);
      }
    case ResultadoNotificaciones.desactivadas:
      mostrarAviso(context, t.permisosNotificacionesDesactivadas);
    case ResultadoNotificaciones.permisoDenegado:
      await ofrecerAjustesDelTelefono(context, controlador, t.permisosDenegado);
    case ResultadoNotificaciones.activadasSinHoraExacta:
      await _ofrecerHoraExacta(context, controlador);
  }
}

/// Explica que falta el permiso y ofrece abrir los ajustes del teléfono.
Future<void> ofrecerAjustesDelTelefono(
  BuildContext context,
  AjustesController controlador,
  String explicacion,
) async {
  final t = TextosApp.of(context);
  final abrir = await preguntar(
    context,
    titulo: t.permisosFaltaTitulo,
    mensaje: t.permisosFaltaMensaje(explicacion, t.permisosAbrirAjustes),
    textoSi: t.permisosAbrirAjustes,
    textoNo: t.dialogoAhoraNo,
    icono: Icons.notifications_off,
  );
  if (abrir) await controlador.abrirAjustesDelTelefono();
}

/// Explica para qué sirve el permiso de alarmas exactas y, si la persona
/// quiere, abre la pantalla del teléfono donde se concede.
Future<void> _ofrecerHoraExacta(
  BuildContext context,
  AjustesController controlador,
) async {
  final t = TextosApp.of(context);
  final dar = await preguntar(
    context,
    titulo: t.permisosHoraExactaTitulo,
    mensaje: t.permisosHoraExactaMensaje(t.permisosDarPermiso),
    textoSi: t.permisosDarPermiso,
    textoNo: t.dialogoAhoraNo,
    icono: Icons.alarm,
  );
  if (!dar || !context.mounted) return;
  final concedido = await controlador.pedirAlarmasExactas();
  if (!context.mounted) return;
  mostrarAviso(
    context,
    concedido ? t.permisosHoraExactaConcedido : t.permisosHoraExactaDenegado,
    icono: concedido ? Icons.check_circle : Icons.info,
  );
}

/// Lo que se hace al pulsar el botón de un problema de la comprobación de
/// los avisos.
Future<void> arreglarProblemaAvisos(
  BuildContext context,
  AjustesController controlador,
  ProblemaAvisos problema,
) async {
  final t = TextosApp.of(context);
  switch (problema) {
    case ProblemaAvisos.sinPermiso:
      // Si la persona ya lo denegó dos veces, Android no vuelve a preguntar:
      // queda abrir los ajustes del teléfono.
      final concedido = await controlador.pedirPermisoAvisos();
      if (!context.mounted) return;
      if (concedido) {
        mostrarAviso(context, t.estadoAvisosPermisoConcedido);
      } else {
        await ofrecerAjustesDelTelefono(
          context,
          controlador,
          t.estadoAvisosSinPermiso,
        );
      }
    case ProblemaAvisos.sinHoraExacta:
      await _ofrecerHoraExacta(context, controlador);
    case ProblemaAvisos.ahorroBateria:
      final abrir = await preguntar(
        context,
        titulo: t.bateriaTitulo,
        mensaje: t.bateriaMensaje(t.bateriaAbrir),
        textoSi: t.bateriaAbrir,
        textoNo: t.dialogoAhoraNo,
        icono: Icons.battery_alert,
      );
      if (abrir) await controlador.abrirAjustesDeBateria();
  }
}

/// Envía un aviso de prueba y explica el resultado.
Future<void> probarAviso(
  BuildContext context,
  AjustesController controlador,
) async {
  final resultado = await controlador.probarAviso();
  if (!context.mounted) return;
  final t = TextosApp.of(context);
  switch (resultado) {
    case ResultadoPrueba.enviado:
      mostrarAviso(
        context,
        t.permisosPruebaEnviada,
        icono: Icons.notifications_active,
      );
    case ResultadoPrueba.notificacionesDesactivadas:
      await mostrarConfirmacion(
        context,
        titulo: t.permisosPruebaDesactivadasTitulo,
        mensaje: t.permisosPruebaDesactivadasMensaje(
          t.ajustesActivarNotificaciones,
          t.ajustesProbarAviso,
        ),
        textoBoton: t.dialogoEntendido,
      );
    case ResultadoPrueba.sinPermiso:
      await ofrecerAjustesDelTelefono(
        context,
        controlador,
        t.permisosPruebaSinPermiso,
      );
  }
}
