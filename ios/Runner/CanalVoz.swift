import AVFoundation
import Flutter

/// Canal de voz que usa `lib/voz`, el mismo que `MainActivity.kt` en Android:
/// - "hablar" y "callar": leer en voz alta con las voces del iPhone
///   (`AVSpeechSynthesizer`). "hablar" recibe el idioma de los textos de la
///   app ("es", "ca"…) y devuelve `false` si el iPhone no tiene esa voz.
/// - "puedeDictar": siempre `false`. En iOS el teclado ya trae su propio botón
///   de dictado, así que la app no añade el suyo ni pide los permisos del
///   micrófono y del reconocimiento de voz.
final class CanalVoz: NSObject, FlutterPlugin, AVSpeechSynthesizerDelegate {
  private static let idiomasDeEspana: Set<String> = ["es", "ca", "gl", "eu"]

  private let sintetizador = AVSpeechSynthesizer()

  static func register(with registrar: FlutterPluginRegistrar) {
    let canal = FlutterMethodChannel(
      name: "es.saludmayores.salud_mayores/voz",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(CanalVoz(), channel: canal)
  }

  override init() {
    super.init()
    sintetizador.delegate = self
  }

  func handle(_ llamada: FlutterMethodCall, result resultado: @escaping FlutterResult) {
    let argumentos = llamada.arguments as? [String: Any]
    switch llamada.method {
    case "hablar":
      resultado(
        hablar(
          argumentos?["texto"] as? String ?? "",
          idioma: argumentos?["idioma"] as? String ?? "es"
        )
      )
    case "callar":
      sintetizador.stopSpeaking(at: .immediate)
      resultado(nil)
    case "puedeDictar":
      resultado(false)
    case "dictar":
      resultado(["estado": "no_disponible"])
    default:
      resultado(FlutterMethodNotImplemented)
    }
  }

  /// La voz de España si está instalada ("es-ES", "ca-ES"…); si no,
  /// cualquiera del idioma.
  private func vozPara(_ idioma: String) -> AVSpeechSynthesisVoice? {
    let etiquetas =
      CanalVoz.idiomasDeEspana.contains(idioma) ? ["\(idioma)-ES", idioma] : [idioma]
    for etiqueta in etiquetas {
      if let voz = AVSpeechSynthesisVoice(language: etiqueta),
        voz.language.hasPrefix(idioma)
      {
        return voz
      }
    }
    return AVSpeechSynthesisVoice.speechVoices().first { $0.language.hasPrefix("\(idioma)-") }
  }

  private func hablar(_ texto: String, idioma: String) -> Bool {
    guard let voz = vozPara(idioma) else { return false }
    // Como en Android: suena aunque el iPhone esté en silencio (la persona
    // ha pedido que se lea) y baja la música mientras habla.
    let sesion = AVAudioSession.sharedInstance()
    try? sesion.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
    try? sesion.setActive(true)
    sintetizador.stopSpeaking(at: .immediate)
    let frase = AVSpeechUtterance(string: texto)
    frase.voice = voz
    // Un poco más despacio de lo normal, para entenderlo bien.
    frase.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
    sintetizador.speak(frase)
    return true
  }

  func speechSynthesizer(_ sintetizador: AVSpeechSynthesizer, didFinish frase: AVSpeechUtterance) {
    // Devuelve el volumen a la música u otras apps.
    if !sintetizador.isSpeaking {
      try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
  }
}
