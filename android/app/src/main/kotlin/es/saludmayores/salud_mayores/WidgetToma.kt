package es.saludmayores.salud_mayores

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.security.MessageDigest
import java.security.SecureRandom
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

/**
 * Widget de la pantalla de inicio: la próxima toma y, si su hora ya ha
 * llegado y está sin marcar, el botón "Ya la he tomado".
 *
 * La app le da las tomas de los próximos días con los textos ya preparados
 * (ver `DatosWidget` y [CanalWidget]); el widget elige la que toca según la
 * hora, así que sigue bien aunque la app no esté abierta. Se redibuja solo a
 * la hora de la siguiente toma y a medianoche.
 *
 * Tocarlo abre "Tomas de hoy"; el botón la marca como tomada, igual que el
 * botón del aviso (la app se abre y lo explica).
 *
 * El botón abre la app con un código secreto (ver [tokenValido]): la
 * actividad principal está abierta a otras apps, porque es la del icono, y
 * así ninguna puede marcar tomas haciéndose pasar por el widget.
 */
class WidgetToma : AppWidgetProvider() {
    override fun onUpdate(contexto: Context, gestor: AppWidgetManager, ids: IntArray) {
        dibujar(contexto, gestor, ids)
    }

    override fun onReceive(contexto: Context, intent: Intent) {
        super.onReceive(contexto, intent)
        if (intent.action == ACCION_REDIBUJAR) actualizarTodos(contexto)
    }

    private data class Toma(
        val momento: Long,
        val fecha: String,
        val nombre: String,
        val tomada: Boolean,
        val carga: String,
        val pasada: String,
        val hoy: String,
        val manana: String,
        val otroDia: String,
        val semantica: String,
    )

    companion object {
        const val PREFERENCIAS = "widget_toma"
        const val CLAVE_DATOS = "datos"
        const val EXTRA_CARGA = "carga"
        const val EXTRA_TOKEN = "token"
        private const val CLAVE_TOKEN = "token"
        const val ACCION_TOMADA = "es.saludmayores.salud_mayores.WIDGET_TOMADA"
        const val ACCION_ABRIR = "es.saludmayores.salud_mayores.WIDGET_ABRIR"
        private const val ACCION_REDIBUJAR = "es.saludmayores.salud_mayores.WIDGET_REDIBUJAR"

        fun actualizarTodos(contexto: Context) {
            val gestor = AppWidgetManager.getInstance(contexto)
            val ids = gestor.getAppWidgetIds(ComponentName(contexto, WidgetToma::class.java))
            if (ids.isNotEmpty()) dibujar(contexto, gestor, ids)
        }

        private fun dibujar(contexto: Context, gestor: AppWidgetManager, ids: IntArray) {
            val datos = contexto.getSharedPreferences(PREFERENCIAS, Context.MODE_PRIVATE)
                .getString(CLAVE_DATOS, null)
                ?.let { runCatching { JSONObject(it) }.getOrNull() }
            val tomas = datos?.let(::leerTomas).orEmpty()
            val ahora = System.currentTimeMillis()
            val vistas = vistas(contexto, datos, tomas, ahora)
            for (id in ids) gestor.updateAppWidget(id, vistas)
            programarSiguiente(contexto, tomas, ahora)
        }

        private fun leerTomas(datos: JSONObject): List<Toma> {
            val lista = datos.optJSONArray("tomas") ?: return emptyList()
            return (0 until lista.length()).map { i ->
                val t = lista.getJSONObject(i)
                Toma(
                    momento = t.getLong("momento"),
                    fecha = t.getString("fecha"),
                    nombre = t.getString("nombre"),
                    tomada = t.getBoolean("tomada"),
                    carga = t.getString("carga"),
                    pasada = t.getString("pasada"),
                    hoy = t.getString("hoy"),
                    manana = t.getString("manana"),
                    otroDia = t.getString("otroDia"),
                    semantica = t.getString("semantica"),
                )
            }.sortedBy { it.momento }
        }

        private fun vistas(
            contexto: Context,
            datos: JSONObject?,
            tomas: List<Toma>,
            ahora: Long,
        ): RemoteViews {
            val vistas = RemoteViews(contexto.packageName, R.layout.widget_toma)
            // Sin datos todavía (la app no se ha abierto): lo que dice el
            // diseño ("Abre la aplicación…"), y tocarlo la abre.
            if (datos == null) {
                vistas.setOnClickPendingIntent(R.id.widget_fondo, abrir(contexto, ACCION_ABRIR, null))
                return vistas
            }
            vistas.setTextViewText(R.id.widget_titulo, datos.optString("titulo"))
            val hoy = dia(ahora, 0)
            // Primero, la de hoy cuya hora ya ha llegado y está sin marcar.
            val vencida = tomas.firstOrNull { !it.tomada && it.fecha == hoy && it.momento <= ahora }
            val toma = vencida ?: tomas.firstOrNull { !it.tomada && it.momento > ahora }
            if (toma == null) {
                // Si ya han pasado todas las tomas que mandó la app (no se
                // abre desde hace días), no es que no haya más: hay que
                // abrirla para que mande las siguientes.
                val caducado = tomas.isNotEmpty() && tomas.last().momento < ahora
                vistas.setTextViewText(
                    R.id.widget_nombre,
                    if (caducado) contexto.getString(R.string.widget_sin_datos) else datos.optString("vacio"),
                )
                vistas.setViewVisibility(R.id.widget_detalle, View.GONE)
                vistas.setViewVisibility(R.id.widget_boton, View.GONE)
                vistas.setOnClickPendingIntent(R.id.widget_fondo, abrir(contexto, ACCION_ABRIR, null))
                return vistas
            }
            vistas.setTextViewText(R.id.widget_nombre, toma.nombre)
            vistas.setViewVisibility(R.id.widget_detalle, View.VISIBLE)
            vistas.setTextViewText(
                R.id.widget_detalle,
                when {
                    vencida != null -> toma.pasada
                    toma.fecha == hoy -> toma.hoy
                    toma.fecha == dia(ahora, 1) -> toma.manana
                    else -> toma.otroDia
                },
            )
            vistas.setOnClickPendingIntent(R.id.widget_fondo, abrir(contexto, ACCION_ABRIR, toma.carga))
            if (vencida != null) {
                vistas.setViewVisibility(R.id.widget_boton, View.VISIBLE)
                vistas.setTextViewText(R.id.widget_boton, datos.optString("boton"))
                vistas.setContentDescription(R.id.widget_boton, toma.semantica)
                vistas.setOnClickPendingIntent(R.id.widget_boton, abrir(contexto, ACCION_TOMADA, toma.carga))
            } else {
                vistas.setViewVisibility(R.id.widget_boton, View.GONE)
            }
            return vistas
        }

        /** Abre la app con [accion] (ver [CanalWidget.recibir]). */
        private fun abrir(contexto: Context, accion: String, carga: String?): PendingIntent =
            PendingIntent.getActivity(
                contexto,
                if (accion == ACCION_TOMADA) 1 else 0,
                Intent(contexto, MainActivity::class.java)
                    .setAction(accion)
                    .putExtra(EXTRA_CARGA, carga)
                    .putExtra(EXTRA_TOKEN, token(contexto))
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
            )

        /**
         * Si [intent] lleva el código secreto del widget. Solo lo conocen
         * la app y el lanzador, que guarda los botones del widget sin poder
         * cambiarlos (`FLAG_IMMUTABLE`).
         */
        fun tokenValido(contexto: Context, intent: Intent): Boolean {
            val recibido = intent.getStringExtra(EXTRA_TOKEN) ?: return false
            return MessageDigest.isEqual(recibido.toByteArray(), token(contexto).toByteArray())
        }

        /** El código secreto de este teléfono; se crea la primera vez. */
        @Synchronized
        private fun token(contexto: Context): String {
            val preferencias = contexto.getSharedPreferences(PREFERENCIAS, Context.MODE_PRIVATE)
            preferencias.getString(CLAVE_TOKEN, null)?.let { return it }
            val bytes = ByteArray(32).also(SecureRandom()::nextBytes)
            val nuevo = bytes.joinToString("") { "%02x".format(it) }
            preferencias.edit().putString(CLAVE_TOKEN, nuevo).commit()
            return nuevo
        }

        /** Fecha `AAAA-MM-DD` de hoy (o [dias] después), como la de `DatosWidget`. */
        private fun dia(ahora: Long, dias: Int): String {
            val calendario = Calendar.getInstance().apply {
                timeInMillis = ahora
                add(Calendar.DAY_OF_MONTH, dias)
            }
            return SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date(calendario.timeInMillis))
        }

        /**
         * Pide redibujarlo a la hora de la siguiente toma (cuando aparece su
         * botón) o a medianoche, lo que llegue antes. Sin hora exacta: basta
         * con que esté al día cuando se mire.
         */
        private fun programarSiguiente(contexto: Context, tomas: List<Toma>, ahora: Long) {
            val medianoche = Calendar.getInstance().apply {
                timeInMillis = ahora
                add(Calendar.DAY_OF_MONTH, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 5)
                set(Calendar.MILLISECOND, 0)
            }.timeInMillis
            val siguiente = tomas.map { it.momento }.filter { it > ahora }.minOrNull()
            val cuando = minOf(siguiente ?: medianoche, medianoche)
            val alarmas = contexto.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarmas.set(
                AlarmManager.RTC,
                cuando,
                PendingIntent.getBroadcast(
                    contexto,
                    0,
                    Intent(contexto, WidgetToma::class.java).setAction(ACCION_REDIBUJAR),
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
                ),
            )
        }
    }
}
