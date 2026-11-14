import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../app/proveedores.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../l10n/textos.dart';
import '../../../notificaciones/sincronizador_avisos.dart';
import '../../agenda/application/citas_controller.dart';
import '../../agenda/domain/cita.dart';
import '../../ajustes/application/ajustes_controller.dart';
import '../../medicamentos/application/existencias_controller.dart';
import '../../medicamentos/application/medicamentos_controller.dart';
import '../../medicamentos/domain/existencias.dart';
import '../../medicamentos/domain/medicamento.dart';
import '../../tomas/application/tomas_controller.dart';
import '../data/informe_pdf.dart';
import '../domain/copia_de_seguridad.dart';
import '../domain/importacion.dart';

/// Montserrat para el PDF (la misma letra que la app).
class FuentesPdf {
  const FuentesPdf(this.normal, this.negrita);

  final pw.Font normal;
  final pw.Font negrita;

  static Future<FuentesPdf> desdeAssets() async => FuentesPdf(
    pw.Font.ttf(await rootBundle.load('assets/fonts/Montserrat-Regular.ttf')),
    pw.Font.ttf(await rootBundle.load('assets/fonts/Montserrat-Bold.ttf')),
  );
}

final fuentesPdfProvider = FutureProvider<FuentesPdf>(
  (ref) => FuentesPdf.desdeAssets(),
);

/// Compartir la medicación (PDF), hacer o recuperar copias de seguridad y
/// añadir los medicamentos de una copia hecha en otro móvil.
class ServicioCompartir {
  ServicioCompartir(this._ref);

  final Ref _ref;

  static String get asuntoCopia => textosApp.copiaAsunto(textosApp.appTitulo);

  /// Para leer todas las tomas anotadas, sean del día que sean.
  static final DateTime _siempreDesde = DateTime(1900);
  static final DateTime _siempreHasta = DateTime(2200);

  DateTime get _ahora => _ref.read(relojProvider)();

  Future<Map<String, Uint8List>> _fotosDe(
    List<Medicamento> medicamentos,
  ) async {
    final almacen = _ref.read(almacenFotosProvider);
    final fotos = <String, Uint8List>{};
    for (final m in medicamentos) {
      final nombre = m.foto;
      if (nombre == null) continue;
      final datos = await almacen.leer(nombre);
      if (datos != null) fotos[nombre] = datos;
    }
    return fotos;
  }

  Future<Uint8List> generarInforme() async {
    final fuentes = await _ref.read(fuentesPdfProvider.future);
    final ahora = _ahora;
    final hoy = FormatoFechas.soloFecha(ahora);
    final medicamentos = await _ref
        .read(medicamentoRepositoryProvider)
        .obtenerTodos();
    final tomas = _ref.read(tomaRepositoryProvider);
    return InformePdf.generar(
      medicamentos: medicamentos,
      citas: await _ref.read(citaRepositoryProvider).obtenerTodas(),
      registros: await tomas.obtenerEntre(
        DateTime(
          hoy.year,
          hoy.month,
          hoy.day - (TomasController.diasHistorial - 1),
        ),
        hoy,
      ),
      ajustes: _ref.read(ajustesProvider),
      ahora: ahora,
      normal: fuentes.normal,
      negrita: fuentes.negrita,
      fotos: await _fotosDe(medicamentos),
      existencias: await calcularExistencias(tomas, medicamentos, ahora),
    );
  }

  Future<void> compartirInforme() async {
    final datos = await generarInforme();
    await _ref
        .read(servicioArchivosProvider)
        .compartir(
          nombre: InformePdf.nombreFichero(_ahora),
          tipo: InformePdf.tipo,
          datos: datos,
          asunto: InformePdf.titulo,
        );
  }

  Future<void> imprimirInforme() async {
    final datos = await generarInforme();
    await _ref
        .read(servicioArchivosProvider)
        .imprimirPdf(nombre: InformePdf.titulo, datos: datos);
  }

  Future<CopiaDeSeguridad> crearCopia() async {
    final medicamentos = await _ref
        .read(medicamentoRepositoryProvider)
        .obtenerTodos();
    return CopiaDeSeguridad(
      creada: _ahora,
      medicamentos: medicamentos,
      citas: await _ref.read(citaRepositoryProvider).obtenerTodas(),
      tomas: await _ref
          .read(tomaRepositoryProvider)
          .obtenerEntre(_siempreDesde, _siempreHasta),
      ajustes: _ref.read(ajustesProvider),
      fotos: await _fotosDe(medicamentos),
    );
  }

  /// Devuelve `false` si la persona vuelve sin guardarla.
  Future<bool> guardarCopia() async {
    final copia = await crearCopia();
    return _ref
        .read(servicioArchivosProvider)
        .guardar(
          nombre: copia.nombreFichero,
          tipo: CopiaDeSeguridad.tipo,
          datos: copia.codificar(),
        );
  }

  Future<void> enviarCopia() async {
    final copia = await crearCopia();
    await _ref
        .read(servicioArchivosProvider)
        .compartir(
          nombre: copia.nombreFichero,
          tipo: CopiaDeSeguridad.tipo,
          datos: copia.codificar(),
          asunto: asuntoCopia,
        );
  }

  /// Pide elegir el fichero de la copia. Devuelve `null` si la persona
  /// vuelve sin elegir y lanza [CopiaNoValida] si no es una copia válida.
  Future<CopiaDeSeguridad?> elegirCopia() async {
    final datos = await _ref.read(servicioArchivosProvider).abrir();
    if (datos == null) return null;
    return CopiaDeSeguridad.decodificar(datos);
  }

  /// Lo que hay ahora en el teléfono, para explicar qué se sustituirá, o
  /// `null` si no hay medicamentos ni citas.
  Future<String?> resumenActual() async {
    final medicamentos =
        (await _ref.read(medicamentoRepositoryProvider).obtenerTodos()).length;
    final citas =
        (await _ref.read(citaRepositoryProvider).obtenerTodas()).length;
    if (medicamentos == 0 && citas == 0) return null;
    return FormatoFechas.lista([
      textosApp.copiaMedicamentos(medicamentos),
      textosApp.copiaCitas(citas),
    ]);
  }

  /// Qué se añadiría al traer [copia] (hecha en otro móvil) sin borrar nada.
  Future<Importacion> prepararImportacion(CopiaDeSeguridad copia) async =>
      Importacion.calcular(
        copia: copia,
        medicamentos: await _ref
            .read(medicamentoRepositoryProvider)
            .obtenerTodos(),
        citas: await _ref.read(citaRepositoryProvider).obtenerTodas(),
        ahora: _ahora,
      );

  /// Añade lo de [importacion] sin borrar nada. Las fotos de [copia] se
  /// guardan con un nombre nuevo, para no pisar ninguna de este teléfono.
  Future<void> importar(Importacion importacion, CopiaDeSeguridad copia) async {
    final medicamentos = _ref.read(medicamentoRepositoryProvider);
    final citas = _ref.read(citaRepositoryProvider);
    final nombresNuevos = <String, String>{};
    Future<String?> foto(String? nombre) async {
      final datos = copia.fotos[nombre];
      if (nombre == null || datos == null) return null;
      return nombresNuevos[nombre] ??= await _guardarFotoNueva(nombre, datos);
    }

    for (final m in importacion.nuevos) {
      await medicamentos.crear(
        _datosDe(m, foto: await foto(m.foto), existencias: m.existencias),
      );
    }
    for (final (:actual, :deLaCopia) in importacion.actualizados) {
      // Lo que no trae la copia (la foto, la cuenta de las pastillas) se
      // conserva.
      await medicamentos.actualizar(
        actual.conDatos(
          _datosDe(
            deLaCopia,
            foto: await foto(deLaCopia.foto) ?? actual.foto,
            existencias: deLaCopia.existencias ?? actual.existencias,
          ),
        ),
      );
    }
    for (final c in importacion.citas) {
      await citas.crear(
        NuevaCita(
          titulo: c.titulo,
          fecha: c.fecha,
          hora: c.hora,
          lugar: c.lugar,
          notas: c.notas,
        ),
      );
    }
    _ref
      ..invalidate(medicamentosProvider)
      ..invalidate(citasProvider);
    await _ref.read(sincronizadorAvisosProvider).sincronizar();
  }

  Future<String> _guardarFotoNueva(String nombre, Uint8List datos) async {
    final almacen = _ref.read(almacenFotosProvider);
    final punto = nombre.lastIndexOf('.');
    final extension = punto < 0 ? '.jpg' : nombre.substring(punto);
    final base = 'caja_${_ahora.microsecondsSinceEpoch}';
    var nuevo = '$base$extension';
    for (var i = 2; await almacen.leer(nuevo) != null; i++) {
      nuevo = '${base}_$i$extension';
    }
    await almacen.escribir(nuevo, datos);
    return nuevo;
  }

  static NuevoMedicamento _datosDe(
    Medicamento m, {
    required String? foto,
    required Existencias? existencias,
  }) => NuevoMedicamento(
    nombre: m.nombre,
    numTomas: m.numTomas,
    frecuenciaHoras: m.frecuenciaHoras,
    horaInicio: m.horaInicio,
    dosis: m.dosis,
    dosisPorToma: m.dosisPorToma,
    instrucciones: m.instrucciones,
    fechaFin: m.fechaFin,
    foto: foto,
    horasLibres: m.horasLibres,
    dias: m.dias,
    aDemanda: m.aDemanda,
    existencias: existencias,
    maximoAlDia: m.maximoAlDia,
    horasEntreTomas: m.horasEntreTomas,
    renovarReceta: m.renovarReceta,
  );

  /// Sustituye todos los datos por los de la copia. Se conserva si los avisos
  /// están activados en este teléfono: depende de sus permisos, no de la
  /// copia.
  Future<void> recuperar(CopiaDeSeguridad copia) async {
    // Las fotos van antes: si después falla la base de datos, las que sobren
    // las borra la limpieza de fotos sin usar al abrir la app.
    final fotos = _ref.read(almacenFotosProvider);
    for (final MapEntry(key: nombre, value: datos) in copia.fotos.entries) {
      await fotos.escribir(nombre, datos);
    }
    // Todo de una vez: o se recupera la copia entera o no cambia nada.
    await _ref
        .read(restauracionDatosProvider)
        .reemplazarTodo(
          medicamentos: copia.medicamentos,
          citas: copia.citas,
          tomas: copia.tomas,
        );

    _ref
      ..invalidate(medicamentosProvider)
      ..invalidate(citasProvider)
      ..invalidate(tomasProvider);
    // Guardar los ajustes reprograma también todos los avisos.
    final actuales = _ref.read(ajustesProvider);
    await _ref
        .read(ajustesProvider.notifier)
        .reemplazar(
          copia.ajustes.copyWith(
            notificacionesActivadas: actuales.notificacionesActivadas,
          ),
        );
  }
}

final servicioCompartirProvider = Provider<ServicioCompartir>(
  ServicioCompartir.new,
);
