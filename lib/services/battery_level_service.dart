import 'dart:math';

import 'package:flutter/services.dart';

class BatteryLevelService {
  static const _batteryLevelChannel =
      MethodChannel('com.dcdevs.battery_level/channel');

  static Future<BatteryLevelResponse> getBatteryLevel() async {
    try {
      final response =
          await _batteryLevelChannel.invokeMethod('getBatteryLevel');

      if (response is! int) {
        return BatteryLevelResponse.withError("Invalid response");
      }

      return BatteryLevelResponse.withValue(max(0, min(response, 100)));
    } catch (e) {
      if (e is PlatformException) {
        return BatteryLevelResponse.withError(e.message ?? 'An error occurred');
      }
      return BatteryLevelResponse.withError('$e');
    }
  }
}

class BatteryLevelResponse {
  int? value;
  String? error;

  BatteryLevelResponse({this.value, this.error});

  static BatteryLevelResponse withValue(int v) =>
      BatteryLevelResponse(value: v);

  static BatteryLevelResponse withError(String e) =>
      BatteryLevelResponse(error: e);
}
