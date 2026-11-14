package es.saludmayores.salud_mayores

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.InputStream

/**
 * Canal de ficheros que usa `lib/archivos`. Todo pasa por pantallas del
 * propio teléfono, así que la app no necesita permisos de almacenamiento:
 * - "compartir": menú "Compartir" (WhatsApp, correo…) con un fichero.
 * - "guardar": elegir dónde guardarlo (Descargas, Google Drive…).
 * - "abrir": elegir un fichero y leerlo.
 */
class CanalArchivos(private val actividad: Activity) {
    private var pendiente: MethodChannel.Result? = null
    private var datosPorGuardar: ByteArray? = null

    fun atender(llamada: MethodCall, resultado: MethodChannel.Result) {
        when (llamada.method) {
            "compartir" -> compartir(
                llamada.argument<String>("nombre")!!,
                llamada.argument<String>("tipo")!!,
                llamada.argument<ByteArray>("datos")!!,
                llamada.argument<String>("asunto")!!,
                resultado,
            )
            "guardar" -> guardar(
                llamada.argument<String>("nombre")!!,
                llamada.argument<String>("tipo")!!,
                llamada.argument<ByteArray>("datos")!!,
                resultado,
            )
            "abrir" -> abrir(resultado)
            else -> resultado.notImplemented()
        }
    }

    private fun compartir(
        nombre: String,
        tipo: String,
        datos: ByteArray,
        asunto: String,
        resultado: MethodChannel.Result,
    ) {
        try {
            // Solo se conserva el último fichero compartido.
            vaciarCompartidos()
            val carpeta = File(actividad.cacheDir, CARPETA_COMPARTIR).apply { mkdirs() }
            val fichero = File(carpeta, nombreSeguro(nombre)).apply { writeBytes(datos) }
            val uri = FileProvider.getUriForFile(
                actividad,
                "${actividad.packageName}.archivos",
                fichero,
            )
            val intent = Intent(Intent.ACTION_SEND).apply {
                type = tipo
                putExtra(Intent.EXTRA_STREAM, uri)
                putExtra(Intent.EXTRA_SUBJECT, asunto)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            actividad.startActivity(Intent.createChooser(intent, asunto))
            resultado.success(null)
        } catch (error: Exception) {
            resultado.error("compartir", error.message, null)
        }
    }

    /**
     * Borra lo que se compartió la última vez (un PDF con la medicación, una
     * copia): las otras apps ya lo han leído. Se hace también al abrir la
     * app, para que no se quede en el teléfono hasta el siguiente envío.
     */
    fun vaciarCompartidos() {
        File(actividad.cacheDir, CARPETA_COMPARTIR).listFiles()?.forEach { it.delete() }
    }

    /** Solo el nombre, sin carpetas: así nunca se escribe fuera de la de compartir. */
    private fun nombreSeguro(nombre: String): String =
        File(nombre).name.takeUnless { it.isBlank() || it == "." || it == ".." } ?: "fichero"

    private fun guardar(
        nombre: String,
        tipo: String,
        datos: ByteArray,
        resultado: MethodChannel.Result,
    ) {
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = tipo
            putExtra(Intent.EXTRA_TITLE, nombre)
        }
        datosPorGuardar = datos
        lanzar(intent, CODIGO_GUARDAR, resultado)
    }

    private fun abrir(resultado: MethodChannel.Result) {
        // Cualquier tipo: al enviar el fichero por WhatsApp o correo, su tipo
        // puede cambiar. La app comprueba después que sea una copia válida.
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
        }
        lanzar(intent, CODIGO_ABRIR, resultado)
    }

    private fun lanzar(intent: Intent, codigo: Int, resultado: MethodChannel.Result) {
        pendiente?.error("interrumpido", "Se ha abierto otra pantalla", null)
        pendiente = resultado
        try {
            actividad.startActivityForResult(intent, codigo)
        } catch (error: ActivityNotFoundException) {
            pendiente = null
            datosPorGuardar = null
            resultado.error("no_disponible", error.message, null)
        }
    }

    /** Devuelve `true` si el resultado era de este canal. */
    fun alVolver(codigo: Int, resultadoActividad: Int, datos: Intent?): Boolean {
        if (codigo != CODIGO_GUARDAR && codigo != CODIGO_ABRIR) return false
        val resultado = pendiente ?: return true
        pendiente = null
        val porGuardar = datosPorGuardar
        datosPorGuardar = null
        val uri = datos?.data
        if (resultadoActividad != Activity.RESULT_OK || uri == null) {
            resultado.success(if (codigo == CODIGO_GUARDAR) false else null)
            return true
        }
        try {
            val resolver = actividad.contentResolver
            if (codigo == CODIGO_GUARDAR) {
                resolver.openOutputStream(uri)!!.use { it.write(porGuardar!!) }
                resultado.success(true)
            } else {
                resultado.success(resolver.openInputStream(uri)!!.use(::leerConLimite))
            }
        } catch (error: Exception) {
            resultado.error("fichero", error.message, null)
        }
        return true
    }

    /**
     * Lee como mucho [LIMITE_LECTURA] bytes (y un trozo más): si el fichero
     * es mayor, la app lo ve más grande que una copia y lo explica, sin
     * cargarlo entero en memoria.
     */
    private fun leerConLimite(entrada: InputStream): ByteArray {
        val salida = ByteArrayOutputStream()
        val trozo = ByteArray(64 * 1024)
        while (salida.size() <= LIMITE_LECTURA) {
            val leidos = entrada.read(trozo)
            if (leidos < 0) break
            salida.write(trozo, 0, leidos)
        }
        return salida.toByteArray()
    }

    companion object {
        const val CANAL = "es.saludmayores.salud_mayores/archivos"
        private const val CODIGO_GUARDAR = 4722
        private const val CODIGO_ABRIR = 4723

        /** La de `res/xml/archivos_compartidos.xml`. */
        private const val CARPETA_COMPARTIR = "compartir"

        /** El mismo tope que `CopiaDeSeguridad.tamanoMaximo`. */
        private const val LIMITE_LECTURA = 50 * 1024 * 1024
    }
}
