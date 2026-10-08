import Flutter
import UIKit
import UserNotifications
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Lets flutter_local_notifications show jamat reminders while the app is open.
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    BoardOcr.register(with: engineBridge.pluginRegistry.registrar(forPlugin: "BoardOcr")!)
  }
}

/// On-device text recognition (Apple Vision) for photos of salat time
/// boards. `read` takes {bytes, down} and returns the lines it found as
/// [{text, x, y, w, h}], 0..1 with a top-left origin.
class BoardOcr: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "muslimin/board_ocr", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(BoardOcr(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "read",
      let args = call.arguments as? [String: Any],
      let data = args["bytes"] as? FlutterStandardTypedData,
      let image = UIImage(data: data.data), let cg = image.cgImage
    else {
      result(FlutterMethodNotImplemented)
      return
    }
    let down = args["down"] as? Bool ?? false
    DispatchQueue.global(qos: .userInitiated).async {
      let request = VNRecognizeTextRequest()
      request.recognitionLevel = .accurate
      // Times and labels are not words: no dictionary "corrections".
      request.usesLanguageCorrection = false
      request.recognitionLanguages = ["en-US"]
      let orientation: CGImagePropertyOrientation = down ? .down : BoardOcr.orientation(image)
      do {
        try VNImageRequestHandler(cgImage: cg, orientation: orientation).perform([request])
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(code: "ocr", message: error.localizedDescription, details: nil))
        }
        return
      }
      var lines: [[String: Any]] = []
      for o in request.results ?? [] {
        guard let c = o.topCandidates(1).first else { continue }
        let b = o.boundingBox
        // Vision reports boxes in the photo's own frame (origin bottom-left);
        // for a photo read upside down, turn them round to match the text.
        let x = down ? 1 - b.maxX : b.minX
        let y = down ? b.minY : 1 - b.maxY
        lines.append(["text": c.string, "x": x, "y": y, "w": b.width, "h": b.height])
      }
      DispatchQueue.main.async { result(lines) }
    }
  }

  static func orientation(_ i: UIImage) -> CGImagePropertyOrientation {
    switch i.imageOrientation {
    case .down: return .down
    case .left: return .left
    case .right: return .right
    case .upMirrored: return .upMirrored
    case .downMirrored: return .downMirrored
    case .leftMirrored: return .leftMirrored
    case .rightMirrored: return .rightMirrored
    default: return .up
    }
  }
}
