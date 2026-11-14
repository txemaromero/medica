import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../l10n/textos.dart';
import '../../../notificaciones/planificador_avisos.dart';
import '../../../notificaciones/sincronizador_avisos.dart';
import '../domain/ajustes.dart';
import '../domain/estado_avisos.dart';
import '../domain/tamano_texto.dart';
import '../domain/validador_familiar.dart';
import '../domain/validador_telefono.dart';

enum ResultadoNotificaciones {
  activadas,

  /// Activadas, pero los avisos pueden llegar con unos minutos de retraso
  /// porque falta el permiso de alarmas exactas.
  activadasSinHoraExacta,

  /// El sistema no ha dado permiso: siguen desactivadas.
  permisoDenegado,

  desactivadas,
}

enum ResultadoPrueba {
  enviado,

  /// "Activar notificaciones" está apagado: no se envía nada.
  notificacionesDesactivadas,

  /// El teléfono no deja mostrar avisos (permiso quitado en sus ajustes).
  sinPermiso,
}

/// Frase con la que se prueba la voz al activar la lectura en voz alta.
String get fraseDePruebaVoz => textosApp.ajustesFraseDePruebaVoz;

/// Ajustes de la aplicación. Cada cambio se guarda y se aplica al momento.
class AjustesController extends Notifier<Ajustes> {
  @override
  Ajustes build() => ref.watch(ajustesRepositoryProvider).cargar();

  Future<void> _guardar(Ajustes nuevos, {bool afectaAvisos = false}) async {
    final cambianAvisos =
        nuevos.notificacionesActivadas != state.notificacionesActivadas;
    state = nuevos;
    if (cambianAvisos) ref.invalidate(estadoAvisosProvider);
    await ref.read(ajustesRepositoryProvider).guardar(nuevos);
    if (afectaAvisos) {
      // Los avisos se ponen al día detrás, sin hacer esperar a la pantalla.
      unawaited(ref.read(sincronizadorAvisosProvider).sincronizar());
    }
  }

  Future<void> cambiarSonido(bool activado) =>
      _guardar(state.copyWith(sonidoActivado: activado), afectaAvisos: true);

  Future<void> cambiarVibracion(bool activado) =>
      _guardar(state.copyWith(vibracionActivada: activado), afectaAvisos: true);

  Future<void> cambiarRecordatorioResumen(bool activado) =>
      _guardar(state.copyWith(recordarResumen: activado), afectaAvisos: true);

  /// Cambia el texto de los avisos ya programados.
  Future<void> cambiarAvisosDiscretos(bool activados) =>
      _guardar(state.copyWith(avisosDiscretos: activados), afectaAvisos: true);

  /// Ver [Ajustes.opcionesRepeticion].
  Future<void> cambiarRepeticion(int minutos) => _guardar(
    state.copyWith(minutosRepeticion: Ajustes.repeticionValida(minutos)),
    afectaAvisos: true,
  );

  /// Ver [Ajustes.opcionesAplazamiento]. Cambia el texto del botón de los
  /// avisos ya programados.
  Future<void> cambiarAplazamiento(int minutos) => _guardar(
    state.copyWith(minutosAplazamiento: Ajustes.aplazamientoValido(minutos)),
    afectaAvisos: true,
  );

  /// Al activarla se lee una frase de prueba. Si el teléfono no tiene voz en
  /// español, sigue desactivada y devuelve `false`.
  Future<bool> cambiarLecturaEnVozAlta(bool activar) async {
    final voz = ref.read(servicioVozProvider);
    if (!activar) {
      await voz.callar();
      await _guardar(state.copyWith(leerEnVozAlta: false));
      return true;
    }
    if (!await voz.hablar(fraseDePruebaVoz)) return false;
    await _guardar(state.copyWith(leerEnVozAlta: true));
    return true;
  }

  /// Activa los avisos y, si el teléfono da permiso, también el sonido y la
  /// vibración: es lo que se ofrece en el asistente de la primera vez.
  Future<ResultadoNotificaciones> activarAvisosCompletos() async {
    final resultado = await cambiarNotificaciones(true);
    if (resultado != ResultadoNotificaciones.permisoDenegado) {
      await _guardar(
        state.copyWith(sonidoActivado: true, vibracionActivada: true),
        afectaAvisos: true,
      );
    }
    return resultado;
  }

  Future<ResultadoNotificaciones> cambiarNotificaciones(bool activar) async {
    final servicio = ref.read(servicioNotificacionesProvider);
    if (!activar) {
      await _guardar(
        state.copyWith(notificacionesActivadas: false),
        afectaAvisos: true,
      );
      return ResultadoNotificaciones.desactivadas;
    }
    if (!await servicio.solicitarPermiso()) {
      return ResultadoNotificaciones.permisoDenegado;
    }
    await _guardar(
      state.copyWith(notificacionesActivadas: true),
      afectaAvisos: true,
    );
    return await servicio.puedeUsarAlarmasExactas()
        ? ResultadoNotificaciones.activadas
        : ResultadoNotificaciones.activadasSinHoraExacta;
  }

  /// Abre la pantalla del sistema para el permiso de alarmas exactas y, al
  /// volver, reprograma los avisos para que lo aprovechen.
  Future<bool> pedirAlarmasExactas() async {
    final servicio = ref.read(servicioNotificacionesProvider);
    await servicio.solicitarAlarmasExactas();
    await ref.read(sincronizadorAvisosProvider).sincronizar();
    ref.invalidate(estadoAvisosProvider);
    return servicio.puedeUsarAlarmasExactas();
  }

  /// Vuelve a pedir el permiso de mostrar avisos, que se puede haber quitado
  /// en los ajustes del teléfono (o no traspasarse al recuperar los datos en
  /// un móvil nuevo). Devuelve `true` si queda concedido.
  Future<bool> pedirPermisoAvisos() async {
    final concedido = await ref
        .read(servicioNotificacionesProvider)
        .solicitarPermiso();
    ref.invalidate(estadoAvisosProvider);
    return concedido;
  }

  /// Abre la pantalla de la app en los ajustes del teléfono, donde se quita
  /// el ahorro de batería. Al volver a la app se comprueba de nuevo.
  Future<void> abrirAjustesDeBateria() =>
      ref.read(servicioBateriaProvider).abrirAjustesDeLaApp();

  /// Envía un aviso al momento con el sonido y la vibración elegidos, para
  /// que la persona compruebe que los recordatorios le llegan.
  Future<ResultadoPrueba> probarAviso() async {
    if (!state.notificacionesActivadas) {
      return ResultadoPrueba.notificacionesDesactivadas;
    }
    final servicio = ref.read(servicioNotificacionesProvider);
    if (!await servicio.permisoConcedido()) return ResultadoPrueba.sinPermiso;
    await servicio.mostrarAvisoDePrueba(CanalAvisos.paraAjustes(state));
    return ResultadoPrueba.enviado;
  }

  Future<void> abrirAjustesDelTelefono() =>
      ref.read(servicioNotificacionesProvider).abrirAjustesDelTelefono();

  /// Guarda el número si es válido. Devuelve el mensaje de error o `null`.
  Future<String?> guardarNumeroEmergencia(String entrada) async {
    final error = ValidadorTelefono.validar(entrada);
    if (error != null) return error;
    await _guardar(
      state.copyWith(numeroEmergencia: ValidadorTelefono.limpiar(entrada)),
    );
    return null;
  }

  /// Guarda (o, con los dos campos vacíos, borra) el contacto del familiar.
  /// Devuelve los errores si no es válido.
  Future<ErroresFamiliar> guardarFamiliar({
    required String nombre,
    required String numero,
  }) async {
    final errores = ValidadorFamiliar.validar(nombre: nombre, numero: numero);
    if (!errores.sinErrores) return errores;
    final vacio = numero.trim().isEmpty;
    await _guardar(
      state.copyWith(
        familiarNombre: vacio ? '' : nombre.trim(),
        familiarNumero: vacio ? '' : ValidadorTelefono.limpiar(numero),
      ),
    );
    return errores;
  }

  /// Sustituye todos los ajustes (al recuperar una copia de seguridad).
  Future<void> reemplazar(Ajustes nuevos) =>
      _guardar(nuevos, afectaAvisos: true);

  Future<void> aumentarTexto() => _guardar(
    state.copyWith(tamanoTexto: TamanoTexto.aumentar(state.tamanoTexto)),
  );

  Future<void> reducirTexto() => _guardar(
    state.copyWith(tamanoTexto: TamanoTexto.reducir(state.tamanoTexto)),
  );

  Future<void> cambiarTema(TemaApp tema) =>
      _guardar(state.copyWith(tema: tema));

  bool get asistenteCompletado =>
      ref.read(ajustesRepositoryProvider).asistenteCompletado();

  Future<void> empezarAsistente() =>
      ref.read(ajustesRepositoryProvider).marcarAsistenteEmpezado();

  Future<void> completarAsistente() =>
      ref.read(ajustesRepositoryProvider).marcarAsistenteCompletado();
}

final ajustesProvider = NotifierProvider<AjustesController, Ajustes>(
  AjustesController.new,
);

/// Si los avisos pueden llegar a su hora. Se comprueba de nuevo al activar o
/// desactivar los avisos, al pedir un permiso y al volver a la app, porque
/// los permisos y el ahorro de batería se cambian en los ajustes del
/// teléfono. Lee los ajustes sin vigilarlos: así [AjustesController] puede
/// pedir que se compruebe de nuevo (Riverpod no deja invalidar un proveedor
/// que depende del que lo invalida).
final estadoAvisosProvider = FutureProvider<EstadoAvisos>((ref) async {
  if (!ref.read(ajustesProvider).notificacionesActivadas) {
    return const EstadoAvisos(activados: false);
  }
  final notificaciones = ref.read(servicioNotificacionesProvider);
  return EstadoAvisos(
    activados: true,
    permiso: await notificaciones.permisoConcedido(),
    horaExacta: await notificaciones.puedeUsarAlarmasExactas(),
    bateria: await ref.read(servicioBateriaProvider).estado(),
  );
});
