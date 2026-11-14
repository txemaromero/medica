package es.saludmayores.salud_mayores

import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Canal del sistema que usa `lib/notificaciones/bateria.dart`, para saber si
 * el ahorro de batería puede retrasar o impedir los avisos:
 * - "bateria": si Android optimiza la batería de la app, si la persona la ha
 *   restringido en segundo plano y el fabricante del teléfono.
 * - "abrirAjustesDeLaApp": la pantalla de la app en los ajustes del teléfono,
 *   donde se elige su uso de batería. No se pide quitar la optimización
 *   directamente (`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`): Google Play lo
 *   limita a muy pocos tipos de apps.
 */
class CanalSistema(private val actividad: Activity) {
    fun atender(llamada: MethodCall, resultado: MethodChannel.Result) {
        when (llamada.method) {
            "bateria" -> resultado.success(
                mapOf(
                    "optimizada" to optimizada(),
                    "restringida" to restringida(),
                    "fabricante" to Build.MANUFACTURER.lowercase(),
                ),
            )
            "abrirAjustesDeLaApp" -> {
                actividad.startActivity(
                    Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.fromParts("package", actividad.packageName, null),
                    ),
                )
                resultado.success(null)
            }
            else -> resultado.notImplemented()
        }
    }

    /** `true` si Android aplica a la app la optimización de batería (lo normal). */
    private fun optimizada(): Boolean {
        val energia = actividad.getSystemService(Context.POWER_SERVICE) as PowerManager
        return !energia.isIgnoringBatteryOptimizations(actividad.packageName)
    }

    /** `true` si la persona ha restringido la app en segundo plano (Android 9+). */
    private fun restringida(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) return false
        val actividades = actividad.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        return actividades.isBackgroundRestricted
    }

    companion object {
        const val CANAL = "es.saludmayores.salud_mayores/sistema"
    }
}
