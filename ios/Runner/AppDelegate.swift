import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let languageChannel = FlutterMethodChannel(
        name: "com.livelingola.app/language",
        binaryMessenger: controller.binaryMessenger
      )

      languageChannel.setMethodCallHandler { call, result in
        if call.method == "setAppLanguage" {
          guard
            let args = call.arguments as? [String: Any],
            let languageCode = args["languageCode"] as? String
          else {
            result(
              FlutterError(
                code: "INVALID_ARGUMENT",
                message: "languageCode missing",
                details: nil
              )
            )
            return
          }

          UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
          UserDefaults.standard.set(languageCode, forKey: "AppleLocale")
          UserDefaults.standard.synchronize()

          result(true)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}