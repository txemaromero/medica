package es.saludmayores.salud_mayores

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.speech.RecognizerIntent
import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

/**
 * Además de la app Flutter, ofrece cuatro canales nativos: el de ficheros (ver
 * [CanalArchivos]), el del sistema (ver [CanalSistema]), el del widget de la
 * pantalla de inicio (ver [CanalWidget]) y el de voz, que usa `lib/voz`:
 * - "hablar" y "callar": leer en voz alta con el motor de voz del teléfono.
 * - "puedeDictar" y "dictar": abrir la pantalla de dictado del teléfono. Esa
 *   pantalla es la que escucha, así que la app no necesita el permiso del
 *   micrófono: solo recibe el texto.
 *
 * "hablar" y "dictar" reciben el idioma de los textos de la app ("es", "ca"…).
 */
class MainActivity : FlutterActivity() {
    private var voz: TextToSpeech? = null

    /** `null` mientras se prepara el motor de voz; después, si habla [idiomaVoz]. */
    private var vozDisponible: Boolean? = null

    private var idiomaVoz = IDIOMA_POR_DEFECTO

    /** Lo que se pidió leer mientras se preparaba la voz. */
    private val pendientes = mutableListOf<Pair<String, MethodChannel.Result>>()

    private var dictado: MethodChannel.Result? = null

    private val archivos = CanalArchivos(this)

    private val sistema = CanalSistema(this)

    private var widget: CanalWidget? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CANAL)
            .setMethodCallHandler { llamada, resultado ->
                when (llamada.method) {
                    "hablar" -> hablar(
                        llamada.argument<String>("texto").orEmpty(),
                        llamada.argument<String>("idioma") ?: IDIOMA_POR_DEFECTO,
                        resultado,
                    )
                    "callar" -> {
                        voz?.stop()
                        resultado.success(null)
                    }
                    "puedeDictar" -> resultado.success(
                        intentDictado(null).resolveActivity(packageManager) != null,
                    )
                    "dictar" -> dictar(
                        llamada.argument<String>("indicacion"),
                        llamada.argument<String>("idioma") ?: IDIOMA_POR_DEFECTO,
                        resultado,
                    )
                    else -> resultado.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CanalArchivos.CANAL)
            .setMethodCallHandler(archivos::atender)
        archivos.vaciarCompartidos()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CanalSistema.CANAL)
            .setMethodCallHandler(sistema::atender)
        widget = CanalWidget(this, flutterEngine.dartExecutor.binaryMessenger)
            .also { it.recibir(intent, alArrancar = true) }
    }

    /** Con la app ya abierta, lo que se pulsa en el widget llega aquí. */
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        widget?.recibir(intent, alArrancar = false)
    }

    private fun hablar(texto: String, idioma: String, resultado: MethodChannel.Result) {
        val motor = voz
        // Si el idioma de la app ha cambiado, la voz cambia con él.
        if (vozDisponible != null && motor != null && idioma != idiomaVoz) {
            idiomaVoz = idioma
            vozDisponible = elegirIdioma(motor, idioma)
        }
        when (vozDisponible) {
            true -> resultado.success(decir(texto))
            false -> resultado.success(false)
            null -> {
                idiomaVoz = idioma
                pendientes.add(texto to resultado)
                if (voz == null) {
                    voz = TextToSpeech(applicationContext) { estado -> alPrepararVoz(estado) }
                }
            }
        }
    }

    private fun alPrepararVoz(estado: Int) {
        val motor = voz
        val disponible =
            estado == TextToSpeech.SUCCESS && motor != null && elegirIdioma(motor, idiomaVoz)
        vozDisponible = disponible
        if (disponible) {
            // Un poco más despacio de lo normal, para entenderlo bien.
            motor!!.setSpeechRate(0.9f)
        }
        // Como al hablar se corta lo anterior, solo se lee el último texto.
        val ultimo = pendientes.lastOrNull()
        val leido = disponible && ultimo != null && decir(ultimo.first)
        for ((_, pendiente) in pendientes) {
            pendiente.success(if (pendiente === ultimo?.second) leido else disponible)
        }
        pendientes.clear()
    }

    /** El de España si está instalado ("es-ES", "ca-ES"…); si no, cualquiera del idioma. */
    private fun elegirIdioma(motor: TextToSpeech, idioma: String): Boolean =
        listOf(etiquetaIdioma(idioma), idioma).distinct().any { etiqueta ->
            val resultado = motor.setLanguage(Locale.forLanguageTag(etiqueta))
            resultado != TextToSpeech.LANG_MISSING_DATA &&
                resultado != TextToSpeech.LANG_NOT_SUPPORTED
        }

    private fun etiquetaIdioma(idioma: String) =
        if (idioma in IDIOMAS_DE_ESPANA) "$idioma-ES" else idioma

    private fun decir(texto: String): Boolean =
        voz?.speak(texto, TextToSpeech.QUEUE_FLUSH, null, "salud_mayores") == TextToSpeech.SUCCESS

    private fun intentDictado(indicacion: String?, idioma: String = IDIOMA_POR_DEFECTO) =
        Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, etiquetaIdioma(idioma))
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1)
            if (indicacion != null) putExtra(RecognizerIntent.EXTRA_PROMPT, indicacion)
        }

    private fun dictar(indicacion: String?, idioma: String, resultado: MethodChannel.Result) {
        val intent = intentDictado(indicacion, idioma)
        if (intent.resolveActivity(packageManager) == null) {
            resultado.success(mapOf("estado" to "no_disponible"))
            return
        }
        dictado?.success(mapOf("estado" to "cancelado"))
        dictado = resultado
        try {
            startActivityForResult(intent, CODIGO_DICTADO)
        } catch (error: ActivityNotFoundException) {
            dictado = null
            resultado.success(mapOf("estado" to "no_disponible"))
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (archivos.alVolver(requestCode, resultCode, data)) return
        if (requestCode != CODIGO_DICTADO) {
            super.onActivityResult(requestCode, resultCode, data)
            return
        }
        val texto = data?.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)?.firstOrNull()
        dictado?.success(
            if (resultCode == Activity.RESULT_OK && !texto.isNullOrBlank()) {
                mapOf("estado" to "reconocido", "texto" to texto)
            } else {
                mapOf("estado" to "cancelado")
            },
        )
        dictado = null
    }

    override fun onDestroy() {
        voz?.shutdown()
        voz = null
        vozDisponible = null
        super.onDestroy()
    }

    private companion object {
        const val CANAL = "es.saludmayores.salud_mayores/voz"
        const val IDIOMA_POR_DEFECTO = "es"
        val IDIOMAS_DE_ESPANA = setOf("es", "ca", "gl", "eu")
        const val CODIGO_DICTADO = 4721
    }
}
