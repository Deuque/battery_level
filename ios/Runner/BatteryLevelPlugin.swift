import Flutter
import UIKit

public class BatteryLevelPlugin: NSObject, FlutterPlugin {
  let manager = BatteryLevelManager()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.dcdevs.battery_level/channel", binaryMessenger: registrar.messenger())
    let instance = BatteryLevelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   if call.method == "getBatteryLevel"{
    let batteryLevel = manager.getBatteryLevel()
    
      if(batteryLevel < 0){
        result(FlutterError(
          code: "UNAVAILABLE",
          message: "Battery level unavailable",
          details: nil))
      }
    
    result(batteryLevel)

      }

          result(FlutterMethodNotImplemented)
  }
}

struct BatteryLevelManager{
    let device: UIDevice

    init(){
      device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
    }

    func getBatteryLevel() -> Int {
      Int(device.batteryLevel * 100)
    }
}
