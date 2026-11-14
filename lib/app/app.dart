import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/tema/tema_visual.dart';
import '../core/widgets/avisos.dart';
import '../features/ajustes/application/ajustes_controller.dart';
import '../features/ajustes/domain/ajustes.dart';
import '../features/ajustes/domain/tamano_texto.dart';
import '../features/medicamentos/application/medicamentos_controller.dart';
import '../features/medicamentos/domain/medicamento.dart';
import '../features/tomas/application/tomas_controller.dart';
import '../features/tomas/domain/tomas_del_dia.dart';
import '../l10n/textos.dart';
import '../notificaciones/carga_aviso.dart';
import '../notificaciones/planificador_avisos.dart';
import '../notificaciones/sincronizador_avisos.dart';
import '../voz/lector.dart';
import 'proveedores.dart';
import 'respuestas_avisos.dart';
import 'rutas.dart';

class AppSaludMayores extends ConsumerStatefulWidget {
  const AppSaludMayores({super.key});

  static final Map<TemaApp, ThemeData> _temas = {
    for (final tema in TemaApp.values) tema: TemaVisual.construir(tema),
  };

  @override
  ConsumerState<AppSaludMayores> createState() => _AppSaludMayoresState();
}

class _AppSaludMayoresState extends ConsumerState<AppSaludMayores>
    with WidgetsBindingObserver {
  final _navegador = GlobalKey<NavigatorState>();
  final _rutas = _ObservadorRutas();
  StreamSubscription<RespuestaAviso>? _respuestas;
  StreamSubscription<RespuestaAviso>? _respuestasWidget;
  late final String _rutaInicial;

  /// Desde cuándo está la app en segundo plano, o `null` si se está viendo.
  DateTime? _ocultaDesde;

  @override
  void initState() {
    super.initState();
    // La primera vez se abre el asistente (con el menú principal debajo).
    _rutaInicial = ref.read(ajustesProvider.notifier).asistenteCompletado
        ? Rutas.menuPrincipal
        : Rutas.asistente;
    WidgetsBinding.instance.addObserver(this);
    final servicio = ref.read(servicioNotificacionesProvider);
    final widget = ref.read(servicioWidgetProvider);
    _respuestas = servicio.respuestas.listen(_atender);
    // Lo que se pulsa en el widget de la pantalla de inicio se atiende igual
    // que la respuesta a un aviso.
    _respuestasWidget = widget.acciones.listen(_atender);
    // Si la app se ha abierto desde un aviso o desde el widget, se atiende en
    // cuanto esté dibujada la primera pantalla.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final inicial =
          await servicio.respuestaInicial() ?? await widget.accionInicial();
      if (inicial != null) {
        await _atender(inicial);
      } else if (!await _recuperarBorrador()) {
        await _abrirTomasSiHaySinAtender();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_respuestas?.cancel());
    unawaited(_respuestasWidget?.cancel());
    super.dispose();
  }

  /// Al volver a la app (por ejemplo, al día siguiente) se recargan las
  /// tomas y se renuevan los avisos.
  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    switch (estado) {
      case AppLifecycleState.hidden || AppLifecycleState.paused:
        _ocultaDesde ??= ref.read(relojProvider)();
      case AppLifecycleState.resumed:
        ref.invalidate(tomasProvider);
        ref.invalidate(estadoAvisosProvider);
        unawaited(ref.read(sincronizadorAvisosProvider).sincronizar());
        final desde = _ocultaDesde;
        _ocultaDesde = null;
        if (desde != null) unawaited(_abrirTomasSiHaySinAtender(desde: desde));
      case AppLifecycleState.inactive || AppLifecycleState.detached:
        break;
    }
  }

  /// Si Android cerró la app con la cámara o la galería abiertas desde el
  /// formulario de medicamento, lo vuelve a abrir tal como estaba, por el
  /// mismo camino que a mano (así "Atrás" lleva a donde se espera). Devuelve
  /// `true` si lo ha hecho.
  Future<bool> _recuperarBorrador() async {
    final borradores = ref.read(borradorRepositoryProvider);
    final borrador = borradores.leer();
    if (borrador == null || _rutaInicial == Rutas.asistente) return false;
    await borradores.borrar();
    Medicamento? medicamento;
    final id = borrador.medicamentoId;
    if (id != null) {
      try {
        final medicamentos = await ref.read(medicamentosProvider.future);
        medicamento = medicamentos.where((m) => m.id == id).firstOrNull;
      } on Object {
        // Se abre como medicamento nuevo, con lo escrito.
      }
    }
    final navegador = _navegador.currentState;
    if (!mounted || navegador == null) return true;
    unawaited(navegador.pushNamed(Rutas.medicamentos));
    if (medicamento != null) {
      unawaited(navegador.pushNamed(Rutas.listaMedicamentos));
    }
    unawaited(
      Rutas.abrirFormularioMedicamento(
        navegador,
        medicamento: medicamento,
        borrador: borrador,
      ),
    );
    return true;
  }

  /// Si se abre la app sin tocar un aviso (desde el icono, o tocando el grupo
  /// en que Android junta varios avisos, que abre la app sin decir de cuál se
  /// trata) y en la última hora ha llegado el aviso de una toma que sigue sin
  /// marcar, se abre "Tomas de hoy" encima de lo que hubiera: "Atrás" vuelve
  /// a donde estaba. Al volver del segundo plano solo cuentan los avisos que
  /// llegaron mientras tanto ([desde]), para no saltar al volver de la
  /// cámara, del marcador o de los ajustes del teléfono.
  Future<void> _abrirTomasSiHaySinAtender({DateTime? desde}) async {
    if (!ref.read(ajustesProvider).notificacionesActivadas) return;
    final List<TomaDelDia> tomas;
    final DateTime ahora;
    try {
      final medicamentos = await ref.read(medicamentosProvider.future);
      final registros = await ref.read(tomasProvider.future);
      ahora = ref.read(relojProvider)();
      tomas = TomasDelDia.calcular(
        medicamentos: medicamentos,
        registros: registros,
        dia: ahora,
        ahora: ahora,
      );
    } on Object {
      return; // La pantalla que se esté viendo ya explica el error.
    }
    final haceUnaHora = ahora.subtract(const Duration(hours: 1));
    final sinAtender = PlanificadorAvisos.avisoDeTomaSinAtender(
      tomas,
      desde: desde == null || desde.isBefore(haceUnaHora) ? haceUnaHora : desde,
      hasta: ahora,
      minutosRepeticion: ref.read(ajustesProvider).minutosRepeticion,
    );
    final navegador = _navegador.currentState;
    final arriba = _rutas.arriba;
    if (!sinAtender ||
        !mounted ||
        navegador == null ||
        // Con un diálogo abierto, en el asistente o ya en "Tomas de hoy", no
        // se cambia de pantalla.
        arriba is! PageRoute ||
        arriba.settings.name == Rutas.asistente ||
        arriba.settings.name == Rutas.tomasHoy) {
      return;
    }
    unawaited(navegador.pushNamed(Rutas.tomasHoy));
  }

  Future<void> _atender(RespuestaAviso respuesta) async {
    final resultado = await ref
        .read(procesadorRespuestasProvider)
        .procesar(respuesta);
    final navegador = _navegador.currentState;
    if (resultado == null || navegador == null || !mounted) return;
    navegador.popUntil((ruta) => ruta.isFirst);
    unawaited(navegador.pushNamed(resultado.ruta));
    final lectura = resultado.lectura;
    if (lectura != null) unawaited(ref.read(lectorProvider).leer(lectura));
    final mensaje = resultado.mensaje;
    if (mensaje == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contexto = _navegador.currentContext;
      if (contexto != null && contexto.mounted) mostrarAviso(contexto, mensaje);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = ref.watch(ajustesProvider.select((a) => a.tema));
    final tamanoTexto = ref.watch(ajustesProvider.select((a) => a.tamanoTexto));

    return MaterialApp(
      navigatorKey: _navegador,
      navigatorObservers: [_rutas],
      onGenerateTitle: (context) => TextosApp.of(context).appTitulo,
      debugShowCheckedModeBanner: false,
      theme: AppSaludMayores._temas[tema],
      // Cambio de tema inmediato: sin colores intermedios de bajo contraste.
      themeAnimationDuration: Duration.zero,
      // El idioma del teléfono si la app está traducida a él (lib/l10n); si
      // no, el primero de la lista: castellano.
      supportedLocales: TextosApp.supportedLocales,
      localizationsDelegates: TextosApp.localizationsDelegates,
      initialRoute: _rutaInicial,
      routes: Rutas.mapa,
      builder: (context, child) {
        // Los textos que se generan fuera de los widgets (avisos, voz, PDF…)
        // van en el mismo idioma. Si cambia con la app abierta (en los
        // ajustes del teléfono), los avisos y el widget se vuelven a escribir.
        if (cambiarIdioma(Localizations.localeOf(context))) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) =>
                unawaited(ref.read(sincronizadorAvisosProvider).sincronizar()),
          );
        }
        return EscaladoTexto(tamano: tamanoTexto, child: child!);
      },
    );
  }
}

/// Recuerda qué ruta está arriba del todo: la pantalla o el diálogo que se
/// está viendo.
class _ObservadorRutas extends NavigatorObserver {
  Route<dynamic>? arriba;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    arriba = route;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    arriba = previousRoute;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route == arriba) arriba = previousRoute;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute == arriba) arriba = newRoute;
  }
}

/// Aplica el tamaño de texto elegido en Ajustes a toda la aplicación,
/// combinado con el tamaño de letra del sistema.
class EscaladoTexto extends StatelessWidget {
  const EscaladoTexto({super.key, required this.tamano, required this.child});

  final int tamano;
  final Widget child;

  /// Límite del escalado combinado para que los textos sigan cabiendo en
  /// pantallas pequeñas incluso con la letra del sistema al máximo.
  static const double factorMaximo = 2.5;

  @override
  Widget build(BuildContext context) {
    final datos = MediaQuery.of(context);
    final sistema =
        datos.textScaler.scale(TemaVisual.tamanoBase) / TemaVisual.tamanoBase;
    final factor = (TamanoTexto.factorEscala(tamano) * sistema).clamp(
      TamanoTexto.factorEscala(TamanoTexto.minimo),
      factorMaximo,
    );
    return MediaQuery(
      data: datos.copyWith(textScaler: TextScaler.linear(factor)),
      child: child,
    );
  }
}
