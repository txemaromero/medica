import 'package:shared_preferences/shared_preferences.dart';

import '../domain/ajustes.dart';
import '../domain/tamano_texto.dart';

abstract interface class AjustesRepository {
  Ajustes cargar();

  Future<void> guardar(Ajustes ajustes);

  /// `true` si ya se ha pasado por el asistente de la primera vez (o se ha
  /// saltado).
  bool asistenteCompletado();

  /// Se llama al abrir el asistente: si la app se cierra a medias, la
  /// próxima vez vuelve a salir.
  Future<void> marcarAsistenteEmpezado();

  Future<void> marcarAsistenteCompletado();
}

/// Guarda los ajustes con `shared_preferences`. Las claves coinciden con los
/// nombres del modelo de datos.
class AjustesRepositoryPreferencias implements AjustesRepository {
  AjustesRepositoryPreferencias(this._prefs);

  final SharedPreferences _prefs;

  static const String claveSonido = 'sonidoActivado';
  static const String claveVibracion = 'vibracionActivada';
  static const String claveNotificaciones = 'notificacionesActivadas';
  static const String claveNumeroEmergencia = 'numeroEmergencia';
  static const String claveTamanoTexto = 'tamanoTexto';
  static const String claveTema = 'tema';
  static const String claveLeerEnVozAlta = 'leerEnVozAlta';
  static const String claveFamiliarNombre = 'familiarNombre';
  static const String claveFamiliarNumero = 'familiarNumero';
  static const String claveRecordarResumen = 'recordarResumen';
  static const String claveMinutosRepeticion = 'minutosRepeticion';
  static const String claveMinutosAplazamiento = 'minutosAplazamiento';
  static const String claveAvisosDiscretos = 'avisosDiscretos';
  static const String claveAsistenteCompletado = 'asistenteCompletado';

  @override
  Ajustes cargar() => Ajustes(
    sonidoActivado: _prefs.getBool(claveSonido) ?? false,
    vibracionActivada: _prefs.getBool(claveVibracion) ?? false,
    notificacionesActivadas: _prefs.getBool(claveNotificaciones) ?? false,
    numeroEmergencia: _prefs.getString(claveNumeroEmergencia) ?? '',
    tamanoTexto: TamanoTexto.normalizar(
      _prefs.getInt(claveTamanoTexto) ?? TamanoTexto.base,
    ),
    tema: TemaApp.desdeNombre(_prefs.getString(claveTema)),
    leerEnVozAlta: _prefs.getBool(claveLeerEnVozAlta) ?? false,
    familiarNombre: _prefs.getString(claveFamiliarNombre) ?? '',
    familiarNumero: _prefs.getString(claveFamiliarNumero) ?? '',
    recordarResumen: _prefs.getBool(claveRecordarResumen) ?? false,
    minutosRepeticion: Ajustes.repeticionValida(
      _prefs.getInt(claveMinutosRepeticion),
    ),
    minutosAplazamiento: Ajustes.aplazamientoValido(
      _prefs.getInt(claveMinutosAplazamiento),
    ),
    avisosDiscretos: _prefs.getBool(claveAvisosDiscretos) ?? false,
  );

  @override
  Future<void> guardar(Ajustes ajustes) async {
    await Future.wait([
      _prefs.setBool(claveSonido, ajustes.sonidoActivado),
      _prefs.setBool(claveVibracion, ajustes.vibracionActivada),
      _prefs.setBool(claveNotificaciones, ajustes.notificacionesActivadas),
      _prefs.setString(claveNumeroEmergencia, ajustes.numeroEmergencia),
      _prefs.setInt(claveTamanoTexto, ajustes.tamanoTexto),
      _prefs.setString(claveTema, ajustes.tema.name),
      _prefs.setBool(claveLeerEnVozAlta, ajustes.leerEnVozAlta),
      _prefs.setString(claveFamiliarNombre, ajustes.familiarNombre),
      _prefs.setString(claveFamiliarNumero, ajustes.familiarNumero),
      _prefs.setBool(claveRecordarResumen, ajustes.recordarResumen),
      _prefs.setInt(claveMinutosRepeticion, ajustes.minutosRepeticion),
      _prefs.setInt(claveMinutosAplazamiento, ajustes.minutosAplazamiento),
      _prefs.setBool(claveAvisosDiscretos, ajustes.avisosDiscretos),
    ]);
  }

  /// Quien ya usaba una versión anterior y había cambiado algún ajuste (se
  /// guardan todos a la vez) ya conoce la app: no se le muestra el asistente.
  @override
  bool asistenteCompletado() =>
      _prefs.getBool(claveAsistenteCompletado) ??
      _prefs.containsKey(claveTamanoTexto);

  @override
  Future<void> marcarAsistenteEmpezado() async {
    if (!_prefs.containsKey(claveAsistenteCompletado)) {
      await _prefs.setBool(claveAsistenteCompletado, false);
    }
  }

  @override
  Future<void> marcarAsistenteCompletado() =>
      _prefs.setBool(claveAsistenteCompletado, true);
}
