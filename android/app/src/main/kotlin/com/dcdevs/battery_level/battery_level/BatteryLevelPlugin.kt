package com.dcdevs.battery_level.battery_level

import android.content.Context
import android.os.BatteryManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BatteryLevelPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var applicationContext: Context
    private lateinit var channel: MethodChannel
    private lateinit var batteryManager: BatteryManager

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        this.applicationContext = applicationContext
        channel = MethodChannel(messenger, "com.dcdevs.battery_level/channel")
        channel.setMethodCallHandler(this)
        batteryManager = applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getBatteryLevel" -> {
                val level = getBatteryLevel()
                if(level < 0){
                    result.error("UNAVAILABLE", "Battery level unavailable",null)
                }
                result.success(level)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
       return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}