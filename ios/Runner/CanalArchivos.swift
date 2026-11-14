import Flutter
import UIKit
import UniformTypeIdentifiers

/// Canal de ficheros que usa `lib/archivos`, el mismo que `CanalArchivos.kt` en
/// Android. Todo pasa por pantallas del propio iPhone, así que la app no
/// necesita permisos:
/// - "compartir": la hoja de compartir (WhatsApp, Mail…) con un fichero.
/// - "guardar": elegir dónde guardarlo (En mi iPhone, iCloud Drive…).
/// - "abrir": elegir un fichero y leerlo.
final class CanalArchivos: NSObject, FlutterPlugin, UIDocumentPickerDelegate {
  /// El mismo tope que `CopiaDeSeguridad.tamanoMaximo`.
  static let limiteLectura = 50 * 1024 * 1024

  private var pendiente: FlutterResult?
  private var guardando = false

  static func register(with registrar: FlutterPluginRegistrar) {
    let canal = FlutterMethodChannel(
      name: "es.saludmayores.salud_mayores/archivos",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(CanalArchivos(), channel: canal)
    // Lo que se compartió la última vez (un PDF con la medicación, una
    // copia) ya lo han leído las otras apps: no se deja en el iPhone.
    try? FileManager.default.removeItem(at: carpetaCompartir)
  }

  private static var carpetaCompartir: URL {
    FileManager.default.temporaryDirectory.appendingPathComponent("compartir", isDirectory: true)
  }

  func handle(_ llamada: FlutterMethodCall, result resultado: @escaping FlutterResult) {
    let argumentos = llamada.arguments as? [String: Any]
    let nombre = argumentos?["nombre"] as? String
    let datos = (argumentos?["datos"] as? FlutterStandardTypedData)?.data
    switch llamada.method {
    case "compartir":
      guard let nombre, let datos else { return faltan(resultado) }
      compartir(nombre, datos, asunto: argumentos?["asunto"] as? String ?? nombre, resultado)
    case "guardar":
      guard let nombre, let datos else { return faltan(resultado) }
      guardar(nombre, datos, resultado)
    case "abrir":
      // Cualquier tipo: al enviar el fichero por WhatsApp o correo, su tipo
      // puede cambiar. La app comprueba después que sea una copia válida.
      presentar(
        UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true),
        guardando: false,
        resultado
      )
    default:
      resultado(FlutterMethodNotImplemented)
    }
  }

  private func faltan(_ resultado: FlutterResult) {
    resultado(FlutterError(code: "argumentos", message: "Faltan el nombre o los datos", details: nil))
  }

  private func compartir(
    _ nombre: String, _ datos: Data, asunto: String, _ resultado: @escaping FlutterResult
  ) {
    guard let pantalla = CanalArchivos.pantallaVisible() else {
      return resultado(FlutterError(code: "no_disponible", message: nil, details: nil))
    }
    do {
      let fichero = try ficheroTemporal(nombre, datos)
      let hoja = UIActivityViewController(
        activityItems: [FicheroParaCompartir(fichero, asunto: asunto)],
        applicationActivities: nil
      )
      // En el iPad sale como globo: desde el centro de la pantalla.
      if let globo = hoja.popoverPresentationController {
        globo.sourceView = pantalla.view
        globo.sourceRect = CGRect(
          x: pantalla.view.bounds.midX, y: pantalla.view.bounds.midY, width: 0, height: 0)
        globo.permittedArrowDirections = []
      }
      pantalla.present(hoja, animated: true)
      resultado(nil)
    } catch {
      resultado(FlutterError(code: "compartir", message: error.localizedDescription, details: nil))
    }
  }

  private func guardar(_ nombre: String, _ datos: Data, _ resultado: @escaping FlutterResult) {
    do {
      let fichero = try ficheroTemporal(nombre, datos)
      presentar(
        UIDocumentPickerViewController(forExporting: [fichero], asCopy: true),
        guardando: true,
        resultado
      )
    } catch {
      resultado(FlutterError(code: "fichero", message: error.localizedDescription, details: nil))
    }
  }

  /// Escribe el fichero con su nombre en una carpeta temporal. Solo se
  /// conserva el último.
  private func ficheroTemporal(_ nombre: String, _ datos: Data) throws -> URL {
    let carpeta = CanalArchivos.carpetaCompartir
    try? FileManager.default.removeItem(at: carpeta)
    try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
    // Solo el nombre, sin carpetas: así nunca se escribe fuera de esta.
    let soloNombre = (nombre as NSString).lastPathComponent
    let fichero = carpeta.appendingPathComponent(
      ["", ".", "..", "/"].contains(soloNombre) ? "fichero" : soloNombre)
    try datos.write(to: fichero)
    return fichero
  }

  private func presentar(
    _ selector: UIDocumentPickerViewController,
    guardando: Bool,
    _ resultado: @escaping FlutterResult
  ) {
    guard let pantalla = CanalArchivos.pantallaVisible() else {
      return resultado(FlutterError(code: "no_disponible", message: nil, details: nil))
    }
    pendiente?(FlutterError(code: "interrumpido", message: "Se ha abierto otra pantalla", details: nil))
    pendiente = resultado
    self.guardando = guardando
    selector.delegate = self
    selector.allowsMultipleSelection = false
    pantalla.present(selector, animated: true)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let resultado = pendiente else { return }
    pendiente = nil
    if guardando { return resultado(true) }
    guard let fichero = urls.first else { return resultado(nil) }
    do {
      // Como mucho el tope de una copia y un byte más: si es mayor, la app
      // lo ve más grande que una copia y lo explica, sin cargarlo entero.
      let lector = try FileHandle(forReadingFrom: fichero)
      defer { try? lector.close() }
      let datos = try lector.read(upToCount: CanalArchivos.limiteLectura + 1) ?? Data()
      resultado(FlutterStandardTypedData(bytes: datos))
    } catch {
      resultado(FlutterError(code: "fichero", message: error.localizedDescription, details: nil))
    }
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    guard let resultado = pendiente else { return }
    pendiente = nil
    resultado(guardando ? false : nil)
  }

  /// La pantalla que está encima de todo, para mostrar sobre ella.
  private static func pantallaVisible() -> UIViewController? {
    let ventana = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    var pantalla = ventana?.rootViewController
    while let encima = pantalla?.presentedViewController { pantalla = encima }
    return pantalla
  }
}

/// El fichero que se comparte, con el asunto que usan Mail y otras apps.
private final class FicheroParaCompartir: NSObject, UIActivityItemSource {
  private let fichero: URL
  private let asunto: String

  init(_ fichero: URL, asunto: String) {
    self.fichero = fichero
    self.asunto = asunto
  }

  func activityViewControllerPlaceholderItem(_ hoja: UIActivityViewController) -> Any { fichero }

  func activityViewController(
    _ hoja: UIActivityViewController, itemForActivityType tipo: UIActivity.ActivityType?
  ) -> Any? { fichero }

  func activityViewController(
    _ hoja: UIActivityViewController, subjectForActivityType tipo: UIActivity.ActivityType?
  ) -> String { asunto }
}
