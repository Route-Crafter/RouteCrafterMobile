package com.jhoncke.routecrafter.services

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.jhoncke.routecrafter.R
import io.flutter.plugin.common.MethodChannel

class LocationService : Service() {
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback

    companion object  {
        var methodChannel: MethodChannel? = null
    }

    override fun onBind(p0: Intent?): IBinder? = null

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()
        Log.d("LocationService", "Servicio creado")
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        // Configurar el callback de ubicación

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                Log.d("LocationService", "New Location")
                for(location: Location in result.locations) {
                    sendLocationToFlutter(
                        location.latitude,
                        location.longitude,
                        location.speed,
                        location.bearing
                    )
                }
            }
        }
        startForegroundService()
        startLocationUpdates()
    }

    private fun sendLocationToFlutter(lat: Double, lon: Double, speed: Float, bearing: Float) {
        Log.d("LocationService", "$bearing")
        methodChannel?.invokeMethod("locationUpdate", mapOf(
            "lat" to lat,
            "lon" to lon,
            "vel" to speed,
            "bearing" to bearing
        ))
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun startForegroundService() {
        val channelId = "location_channel";
        val channel = NotificationChannel(
            channelId,
            "Seguimiento de ubicación",
            NotificationManager.IMPORTANCE_LOW
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)

        val notification = Notification.Builder(this, channelId)
            .setContentTitle("Ubicación Activa")
            .setContentText("La aplicación está rastreando tu ubicación")
            .setSmallIcon(R.mipmap.ic_launcher)
            .build()

        startForeground(1, notification)
    }

    private fun startLocationUpdates() {
        val locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY, //Alta precisión
            4000 //Intervalo en milisegundos
        ).build()
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            Log.d("LocationService", "Servicio detenido por falta de permisos")
            stopSelf()
            return
        }
        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            Looper.getMainLooper()
        )
    }

    override fun onDestroy() {
        super.onDestroy()
        fusedLocationClient.removeLocationUpdates(locationCallback)
    }
}