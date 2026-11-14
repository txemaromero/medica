package es.saludmayores.salud_mayores

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Canal del widget de la pantalla de inicio (ver [WidgetToma]), que usa
 * `lib/widget_inicio/servicio_widget.dart`:
 * - "actualizar": guarda lo que debe mostrar (un JSON que prepara
 *   `DatosWidget`) y lo redibuja.
 * - "accionInicial": si la app se ha abierto desde el widget, lo que se pulsó.
 *   Lo que se pulsa con la app ya abierta llega con "accion".
 * - "pedirAnadir": pide al teléfono que ponga el widget en la pantalla de
 *   inicio (Android 8+, si el lanzador sabe hacerlo).
 */
class CanalWidget(private val actividad: Activity, mensajero: BinaryMessenger) {
    private val canal = MethodChannel(mensajero, CANAL)

    /** Lo que se pulsó para abrir la app, hasta que Flutter lo pide. */
    private var pendiente: Map<String, String?>? = null

    init {
        canal.setMethodCallHandler { llamada, resultado ->
            when (llamada.method) {
                "actualizar" -> {
                    actividad.getSharedPreferences(WidgetToma.PREFERENCIAS, Activity.MODE_PRIVATE)
                        .edit()
                        .putString(WidgetToma.CLAVE_DATOS, llamada.argument<String>("datos"))
                        .apply()
                    WidgetToma.actualizarTodos(actividad)
                    resultado.success(null)
                }
                "accionInicial" -> {
                    resultado.success(pendiente)
                    pendiente = null
                }
                "pedirAnadir" -> resultado.success(pedirAnadir())
                else -> resultado.notImplemented()
            }
        }
    }

    /**
     * Si [intent] viene del widget, lo pasa a Flutter: al arrancar se guarda
     * hasta que lo pida; con la app abierta, se manda al momento. Después se
     * olvida, para no atenderlo otra vez si Android vuelve a crear la
     * actividad.
     *
     * Sin el código secreto del widget no se hace caso: otra app podría
     * mandar la misma acción para marcar una toma que no se ha tomado. La
     * app se abre como desde su icono.
     */
    fun recibir(intent: Intent?, alArrancar: Boolean) {
        val accion = intent?.action
        if (accion != WidgetToma.ACCION_TOMADA && accion != WidgetToma.ACCION_ABRIR) return
        val valido = WidgetToma.tokenValido(actividad, intent)
        val datos = mapOf(
            "accion" to if (accion == WidgetToma.ACCION_TOMADA) "tomada" else null,
            "carga" to intent.getStringExtra(WidgetToma.EXTRA_CARGA),
        )
        intent.action = null
        intent.removeExtra(WidgetToma.EXTRA_CARGA)
        intent.removeExtra(WidgetToma.EXTRA_TOKEN)
        if (!valido) return
        if (alArrancar) pendiente = datos else canal.invokeMethod("accion", datos)
    }

    private fun pedirAnadir(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false
        val gestor = AppWidgetManager.getInstance(actividad)
        if (!gestor.isRequestPinAppWidgetSupported) return false
        return gestor.requestPinAppWidget(
            ComponentName(actividad, WidgetToma::class.java),
            null,
            null,
        )
    }

    companion object {
        const val CANAL = "es.saludmayores.salud_mayores/widget"
    }
}
