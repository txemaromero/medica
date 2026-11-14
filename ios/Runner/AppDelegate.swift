import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // flutter_local_notifications: muestra los avisos también con la app
    // abierta y recibe los botones "Ya la he tomado" y "Recordar en 10 min".
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // Los canales propios de la app, los mismos que en Android: la voz
    // (CanalVoz.swift) y los ficheros (CanalArchivos.swift).
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "CanalVoz") {
      CanalVoz.register(with: registrar)
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "CanalArchivos") {
      CanalArchivos.register(with: registrar)
    }
  }
}
