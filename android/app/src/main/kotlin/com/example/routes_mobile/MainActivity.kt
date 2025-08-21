package com.example.routes_mobile

import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.example.routes_mobile.services.LocationService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.routes_mobile/location"

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d("MainActivity", "Creado")
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        LocationService.methodChannel = channel

        channel.setMethodCallHandler{ call, result ->
            when(call.method) {
                "startService" -> {
                    val intent = Intent(this, LocationService::class.java)
                    startForegroundService(intent)
                    result.success(null)
                }
                "stopService" -> {
                    val intent = Intent(this, LocationService::class.java)
                    stopService(intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
