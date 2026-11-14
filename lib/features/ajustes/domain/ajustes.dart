import '../../../l10n/textos.dart';
import 'tamano_texto.dart';

enum TemaApp {
  predeterminado,
  oscuro,
  alternativo;

  String get nombre => switch (this) {
    predeterminado => textosApp.temaPredeterminado,
    oscuro => textosApp.temaOscuro,
    alternativo => textosApp.temaAlternativo,
  };

  String get descripcion => switch (this) {
    predeterminado => textosApp.temaPredeterminadoDescripcion,
    oscuro => textosApp.temaOscuroDescripcion,
    alternativo => textosApp.temaAlternativoDescripcion,
  };

  static TemaApp desdeNombre(String? nombre) => TemaApp.values.firstWhere(
    (t) => t.name == nombre,
    orElse: () => TemaApp.predeterminado,
  );
}

/// Preferencias del usuario. Sonido, vibración, notificaciones y lectura en
/// voz alta están desactivados por defecto.
class Ajustes {
  /// Cuándo se repite el aviso de una toma que no se ha marcado, en minutos
  /// después de su hora. 0 es no repetirlo.
  static const List<int> opcionesRepeticion = [15, 30, 60, 0];
  static const int repeticionPorDefecto = 30;

  /// Minutos del botón "Recordar en 10 min" de los avisos de tomas.
  static const List<int> opcionesAplazamiento = [5, 10, 15, 30];
  static const int aplazamientoPorDefecto = 10;

  const Ajustes({
    this.sonidoActivado = false,
    this.vibracionActivada = false,
    this.notificacionesActivadas = false,
    this.numeroEmergencia = '',
    this.tamanoTexto = TamanoTexto.base,
    this.tema = TemaApp.predeterminado,
    this.leerEnVozAlta = false,
    this.familiarNombre = '',
    this.familiarNumero = '',
    this.recordarResumen = false,
    this.minutosRepeticion = repeticionPorDefecto,
    this.minutosAplazamiento = aplazamientoPorDefecto,
    this.avisosDiscretos = false,
  });

  /// Un valor guardado que no es una de las opciones (de una copia
  /// manipulada, por ejemplo) pasa a ser el de por defecto.
  static int repeticionValida(int? minutos) =>
      opcionesRepeticion.contains(minutos) ? minutos! : repeticionPorDefecto;

  static int aplazamientoValido(int? minutos) =>
      opcionesAplazamiento.contains(minutos)
      ? minutos!
      : aplazamientoPorDefecto;

  final bool sonidoActivado;
  final bool vibracionActivada;
  final bool notificacionesActivadas;
  final String numeroEmergencia;

  /// Tamaño del texto normal en puntos (10–35, pasos de 5, base 20).
  final int tamanoTexto;

  final TemaApp tema;

  /// Leer en voz alta los avisos al abrirlos y las tomas de hoy.
  final bool leerEnVozAlta;

  /// Segundo contacto de emergencia: un familiar o una persona de confianza
  /// (por ejemplo, "Mi hija Ana"). Vacíos si no hay.
  final String familiarNombre;
  final String familiarNumero;

  /// Un aviso cada semana para enviar el resumen (el PDF) a la familia.
  final bool recordarResumen;

  /// Ver [opcionesRepeticion].
  final int minutosRepeticion;

  /// Ver [opcionesAplazamiento].
  final int minutosAplazamiento;

  /// Avisos sin el nombre de la medicina ni el motivo de la cita, y sin la
  /// foto, para que no se vean en la pantalla de bloqueo.
  final bool avisosDiscretos;

  bool get repetirAvisos => minutosRepeticion > 0;

  bool get tieneNumeroEmergencia => numeroEmergencia.trim().isNotEmpty;

  bool get tieneFamiliar => familiarNumero.trim().isNotEmpty;

  Ajustes copyWith({
    bool? sonidoActivado,
    bool? vibracionActivada,
    bool? notificacionesActivadas,
    String? numeroEmergencia,
    int? tamanoTexto,
    TemaApp? tema,
    bool? leerEnVozAlta,
    String? familiarNombre,
    String? familiarNumero,
    bool? recordarResumen,
    int? minutosRepeticion,
    int? minutosAplazamiento,
    bool? avisosDiscretos,
  }) => Ajustes(
    sonidoActivado: sonidoActivado ?? this.sonidoActivado,
    vibracionActivada: vibracionActivada ?? this.vibracionActivada,
    notificacionesActivadas:
        notificacionesActivadas ?? this.notificacionesActivadas,
    numeroEmergencia: numeroEmergencia ?? this.numeroEmergencia,
    tamanoTexto: tamanoTexto ?? this.tamanoTexto,
    tema: tema ?? this.tema,
    leerEnVozAlta: leerEnVozAlta ?? this.leerEnVozAlta,
    familiarNombre: familiarNombre ?? this.familiarNombre,
    familiarNumero: familiarNumero ?? this.familiarNumero,
    recordarResumen: recordarResumen ?? this.recordarResumen,
    minutosRepeticion: minutosRepeticion ?? this.minutosRepeticion,
    minutosAplazamiento: minutosAplazamiento ?? this.minutosAplazamiento,
    avisosDiscretos: avisosDiscretos ?? this.avisosDiscretos,
  );

  @override
  bool operator ==(Object other) =>
      other is Ajustes &&
      other.sonidoActivado == sonidoActivado &&
      other.vibracionActivada == vibracionActivada &&
      other.notificacionesActivadas == notificacionesActivadas &&
      other.numeroEmergencia == numeroEmergencia &&
      other.tamanoTexto == tamanoTexto &&
      other.tema == tema &&
      other.leerEnVozAlta == leerEnVozAlta &&
      other.familiarNombre == familiarNombre &&
      other.familiarNumero == familiarNumero &&
      other.recordarResumen == recordarResumen &&
      other.minutosRepeticion == minutosRepeticion &&
      other.minutosAplazamiento == minutosAplazamiento &&
      other.avisosDiscretos == avisosDiscretos;

  @override
  int get hashCode => Object.hash(
    sonidoActivado,
    vibracionActivada,
    notificacionesActivadas,
    numeroEmergencia,
    tamanoTexto,
    tema,
    leerEnVozAlta,
    familiarNombre,
    familiarNumero,
    recordarResumen,
    minutosRepeticion,
    minutosAplazamiento,
    avisosDiscretos,
  );
}
