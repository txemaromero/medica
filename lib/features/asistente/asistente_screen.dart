import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tema/tema_visual.dart';
import '../../core/widgets/botones.dart';
import '../../core/widgets/campo_texto.dart';
import '../../core/widgets/pantalla_base.dart';
import '../../core/widgets/parrafo.dart';
import '../../core/widgets/tarjetas.dart';
import '../../l10n/textos.dart';
import '../ajustes/application/ajustes_controller.dart';
import '../ajustes/presentation/explicaciones_avisos.dart';
import '../ajustes/presentation/tamano_texto_screen.dart';

/// Asistente de la primera vez: en tres pasos, el tamaño de la letra, los
/// avisos y el número de emergencia. Todo se puede cambiar después en
/// Ajustes.
///
/// "Atrás" vuelve al paso anterior. Desde el primero, o con el botón
/// "Inicio", se sale al menú principal; salir de cualquier forma cuenta como
/// completado, para no volver a mostrarlo.
class AsistenteScreen extends ConsumerStatefulWidget {
  const AsistenteScreen({super.key});

  @override
  ConsumerState<AsistenteScreen> createState() => _AsistenteScreenState();
}

enum _Paso { bienvenida, tamanoTexto, avisos, emergencia, listo }

class _AsistenteScreenState extends ConsumerState<AsistenteScreen> {
  _Paso _paso = _Paso.bienvenida;
  final _numero = TextEditingController();
  String? _errorNumero;

  @override
  void initState() {
    super.initState();
    _numero.text = ref.read(ajustesProvider).numeroEmergencia;
    unawaited(_controlador.empezarAsistente());
  }

  @override
  void dispose() {
    _numero.dispose();
    super.dispose();
  }

  AjustesController get _controlador => ref.read(ajustesProvider.notifier);

  void _irA(_Paso paso) => setState(() => _paso = paso);

  void _terminar() {
    Navigator.of(context).popUntil((ruta) => ruta.isFirst);
  }

  Future<void> _activarAvisos() async {
    final resultado = await _controlador.activarAvisosCompletos();
    if (!mounted) return;
    await explicarResultadoNotificaciones(
      context,
      _controlador,
      resultado,
      avisarSiActivadas: false,
    );
  }

  Future<void> _guardarNumeroYSeguir() async {
    FocusScope.of(context).unfocus();
    if (_numero.text.trim().isNotEmpty) {
      final error = await _controlador.guardarNumeroEmergencia(_numero.text);
      if (!mounted) return;
      setState(() => _errorNumero = error);
      if (error != null) return;
    }
    _irA(_Paso.listo);
  }

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final (cuerpo, pie) = switch (_paso) {
      _Paso.bienvenida => (
        _Bienvenida(onSaltar: _terminar),
        BotonGrande(
          etiqueta: t.asistenteEmpezar,
          icono: Icons.arrow_forward,
          centrado: true,
          onPressed: () => _irA(_Paso.tamanoTexto),
        ),
      ),
      _Paso.tamanoTexto => (
        _PasoConTitulo(
          numero: 1,
          titulo: t.asistenteTamanoTitulo,
          explicacion: t.asistenteTamanoExplicacion,
          child: const ControlesTamanoTexto(),
        ),
        _botonSiguiente(t, () => _irA(_Paso.avisos)),
      ),
      _Paso.avisos => (
        _PasoConTitulo(
          numero: 2,
          titulo: t.asistenteAvisosTitulo,
          explicacion: t.asistenteAvisosExplicacion,
          child: _Avisos(
            onActivar: _activarAvisos,
            onProbar: () => probarAviso(context, _controlador),
          ),
        ),
        _botonSiguiente(t, () => _irA(_Paso.emergencia)),
      ),
      _Paso.emergencia => (
        _PasoConTitulo(
          numero: 3,
          titulo: t.asistenteEmergenciaTitulo,
          explicacion: t.asistenteEmergenciaExplicacion,
          child: CampoTexto(
            etiqueta: t.ajustesNumeroEmergencia,
            descripcion: t.asistenteEmergenciaDescripcion,
            controller: _numero,
            error: _errorNumero,
            teclado: TextInputType.phone,
            accion: TextInputAction.done,
            formateadores: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
            ],
            onSubmitted: (_) => _guardarNumeroYSeguir(),
          ),
        ),
        _botonSiguiente(t, _guardarNumeroYSeguir),
      ),
      _Paso.listo => (
        const _Listo(),
        BotonGrande(
          etiqueta: t.asistenteTerminar,
          icono: Icons.check,
          centrado: true,
          onPressed: _terminar,
        ),
      ),
    };

    return PopScope(
      canPop: _paso == _Paso.bienvenida,
      onPopInvokedWithResult: (salio, _) {
        if (salio) {
          unawaited(_controlador.completarAsistente());
        } else {
          _irA(_Paso.values[_paso.index - 1]);
        }
      },
      // Cada paso es una pantalla nueva: empieza desde arriba.
      child: KeyedSubtree(
        key: ValueKey(_paso),
        child: PantallaBase(
          titulo: t.asistenteTitulo,
          cuerpo: cuerpo,
          pie: pie,
        ),
      ),
    );
  }

  Widget _botonSiguiente(TextosApp t, VoidCallback onPressed) => BotonGrande(
    etiqueta: t.asistenteSiguiente,
    icono: Icons.arrow_forward,
    centrado: true,
    onPressed: onPressed,
  );
}

class _Bienvenida extends StatelessWidget {
  const _Bienvenida({required this.onSaltar});

  final VoidCallback onSaltar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ExcludeSemantics(child: Icon(Icons.waving_hand, size: 96)),
        const Hueco(),
        Semantics(
          container: true,
          header: true,
          child: Text(
            t.asistenteHola,
            textAlign: TextAlign.center,
            style: textos.headlineMedium,
          ),
        ),
        const SizedBox(height: 12),
        Parrafo(t.asistenteBienvenida),
        const SizedBox(height: 12),
        Parrafo(t.asistenteCambiarEnAjustes),
        const Hueco(alto: Medidas.separacion * 1.5),
        BotonGrande(
          etiqueta: t.asistenteSaltar,
          descripcion: t.asistenteSaltarDescripcion,
          icono: Icons.skip_next,
          onPressed: onSaltar,
        ),
      ],
    );
  }
}

/// Encabezado común de los pasos: "Paso 1 de 3", título y explicación.
class _PasoConTitulo extends StatelessWidget {
  const _PasoConTitulo({
    required this.numero,
    required this.titulo,
    required this.explicacion,
    required this.child,
  });

  static const int pasos = 3;

  final int numero;
  final String titulo;
  final String explicacion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Al cambiar de paso, TalkBack anuncia en cuál se está.
        Semantics(
          container: true,
          header: true,
          liveRegion: true,
          child: Text(
            TextosApp.of(context).asistentePaso('$numero', '$pasos', titulo),
            style: textos.headlineSmall,
          ),
        ),
        const SizedBox(height: 12),
        Parrafo(explicacion),
        const Hueco(),
        child,
      ],
    );
  }
}

class _Avisos extends ConsumerWidget {
  const _Avisos({required this.onActivar, required this.onProbar});

  final VoidCallback onActivar;
  final VoidCallback onProbar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ajustes = ref.watch(ajustesProvider);
    final t = TextosApp.of(context);
    if (!ajustes.notificacionesActivadas) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BotonGrande(
            etiqueta: t.asistenteActivarAvisos,
            descripcion: t.asistenteActivarAvisosDescripcion,
            icono: Icons.notifications_active,
            onPressed: onActivar,
          ),
          const Hueco(),
          Parrafo(t.asistenteSiPrefieresNo(t.asistenteSiguiente)),
        ],
      );
    }
    final sonido = ajustes.sonidoActivado
        ? t.asistenteConSonido
        : t.asistenteSinSonido;
    final vibracion = ajustes.vibracionActivada
        ? t.asistenteConVibracion
        : t.asistenteSinVibracion;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          liveRegion: true,
          child: TarjetaInfo(
            child: LineaDato(
              icono: Icons.check_circle,
              texto: t.asistenteAvisosActivados(sonido, vibracion),
            ),
          ),
        ),
        const Hueco(),
        BotonGrande(
          etiqueta: t.ajustesProbarAviso,
          descripcion: t.asistenteProbarAvisoDescripcion,
          icono: Icons.notifications_active,
          onPressed: onProbar,
        ),
      ],
    );
  }
}

class _Listo extends ConsumerWidget {
  const _Listo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ajustes = ref.watch(ajustesProvider);
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ExcludeSemantics(child: Icon(Icons.check_circle, size: 96)),
        const Hueco(),
        Semantics(
          container: true,
          header: true,
          liveRegion: true,
          child: Text(
            t.asistenteTodoListo,
            textAlign: TextAlign.center,
            style: textos.headlineMedium,
          ),
        ),
        const Hueco(),
        // El resumen se lee de una vez.
        MergeSemantics(
          child: TarjetaInfo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LineaDato(
                  icono: Icons.format_size,
                  texto: t.asistenteResumenTamano('${ajustes.tamanoTexto}'),
                ),
                LineaDato(
                  icono: ajustes.notificacionesActivadas
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  texto: ajustes.notificacionesActivadas
                      ? t.asistenteResumenAvisosActivados
                      : t.asistenteResumenAvisosDesactivados,
                ),
                LineaDato(
                  icono: Icons.phone,
                  texto: ajustes.tieneNumeroEmergencia
                      ? t.asistenteResumenNumero(ajustes.numeroEmergencia)
                      : t.asistenteResumenSinNumero,
                ),
              ],
            ),
          ),
        ),
        const Hueco(),
        Parrafo(t.asistenteTambienEnAjustes),
      ],
    );
  }
}
