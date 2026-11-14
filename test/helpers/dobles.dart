import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:salud_mayores/archivos/servicio_archivos.dart';
import 'package:salud_mayores/core/tiempo/formato_fechas.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/data/cita_repository.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/data/ajustes_repository.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/ajustes/domain/estado_avisos.dart';
import 'package:salud_mayores/features/compartir/data/restauracion_datos.dart';
import 'package:salud_mayores/features/emergencias/marcador_telefono.dart';
import 'package:salud_mayores/features/medicamentos/data/borrador_repository.dart';
import 'package:salud_mayores/features/medicamentos/data/fotos.dart';
import 'package:salud_mayores/features/medicamentos/data/medicamento_repository.dart';
import 'package:salud_mayores/features/medicamentos/domain/borrador_medicamento.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/data/toma_repository.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/bateria.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/servicio_notificaciones.dart';
import 'package:salud_mayores/voz/servicio_voz.dart';
import 'package:salud_mayores/widget_inicio/servicio_widget.dart';

/// Dobles de prueba en memoria para los tests de widgets: responden al
/// instante y permiten comprobar qué se ha guardado o programado.

class MedicamentoRepositoryEnMemoria implements MedicamentoRepository {
  MedicamentoRepositoryEnMemoria([List<Medicamento> iniciales = const []]) {
    for (final m in iniciales) {
      _datos[m.id] = m;
      if (m.id >= _siguienteId) _siguienteId = m.id + 1;
    }
  }

  final Map<int, Medicamento> _datos = {};
  int _siguienteId = 1;

  List<Medicamento> get guardados => _datos.values.toList();

  @override
  Future<List<Medicamento>> obtenerTodos() async =>
      _datos.values.toList()..sort((a, b) => a.nombre.compareTo(b.nombre));

  @override
  Future<Medicamento> crear(NuevoMedicamento nuevo) async {
    final m = Medicamento.desdeDatos(
      id: _siguienteId++,
      fechaCreacion: DateTime(2026, 10, 25),
      datos: nuevo,
    );
    _datos[m.id] = m;
    return m;
  }

  @override
  Future<void> actualizar(Medicamento medicamento) async =>
      _datos[medicamento.id] = medicamento;

  @override
  Future<void> eliminar(int id) async => _datos.remove(id);

  @override
  Future<void> restaurar(Medicamento medicamento) async =>
      _datos[medicamento.id] = medicamento;
}

/// Sustituye los datos de los repositorios en memoria. Con [fallar], lanza
/// un error sin tocar nada, como una transacción que no llega a guardarse.
class RestauracionDatosEnMemoria implements RestauracionDatos {
  RestauracionDatosEnMemoria(this._medicamentos, this._citas, this._tomas);

  final MedicamentoRepositoryEnMemoria _medicamentos;
  final CitaRepositoryEnMemoria _citas;
  final TomaRepositoryEnMemoria _tomas;
  bool fallar = false;

  @override
  Future<void> reemplazarTodo({
    required List<Medicamento> medicamentos,
    required List<Cita> citas,
    required List<RegistroToma> tomas,
  }) async {
    if (fallar) throw StateError('Sin espacio');
    for (final m in await _medicamentos.obtenerTodos()) {
      await _medicamentos.eliminar(m.id);
    }
    for (final c in await _citas.obtenerTodas()) {
      await _citas.eliminar(c.id);
    }
    _tomas.registros.clear();
    for (final m in medicamentos) {
      await _medicamentos.restaurar(m);
    }
    for (final c in citas) {
      await _citas.restaurar(c);
    }
    _tomas.registros.addAll(tomas);
  }
}

class CitaRepositoryEnMemoria implements CitaRepository {
  CitaRepositoryEnMemoria([List<Cita> iniciales = const []]) {
    for (final c in iniciales) {
      _datos[c.id] = c;
      if (c.id >= _siguienteId) _siguienteId = c.id + 1;
    }
  }

  final Map<int, Cita> _datos = {};
  int _siguienteId = 1;

  List<Cita> get guardadas => _datos.values.toList();

  @override
  Future<List<Cita>> obtenerTodas() async =>
      ordenarCronologicamente(_datos.values);

  @override
  Future<Cita> crear(NuevaCita nueva) async {
    final c = Cita(
      id: _siguienteId++,
      titulo: nueva.titulo,
      fecha: nueva.fecha,
      hora: nueva.hora,
      lugar: (nueva.lugar?.trim().isEmpty ?? true) ? null : nueva.lugar,
      notas: (nueva.notas?.trim().isEmpty ?? true) ? null : nueva.notas,
    );
    _datos[c.id] = c;
    return c;
  }

  @override
  Future<void> actualizar(Cita cita) async => _datos[cita.id] = cita;

  @override
  Future<void> eliminar(int id) async => _datos.remove(id);

  @override
  Future<void> restaurar(Cita cita) async => _datos[cita.id] = cita;
}

class AjustesRepositoryEnMemoria implements AjustesRepository {
  /// Por defecto el asistente de la primera vez ya está completado, para que
  /// los tests empiecen en el menú principal.
  AjustesRepositoryEnMemoria([
    this.ajustes = const Ajustes(),
    this.asistente = true,
  ]);

  Ajustes ajustes;
  bool asistente;

  @override
  Ajustes cargar() => ajustes;

  @override
  Future<void> guardar(Ajustes nuevos) async => ajustes = nuevos;

  @override
  bool asistenteCompletado() => asistente;

  @override
  Future<void> marcarAsistenteEmpezado() async {}

  @override
  Future<void> marcarAsistenteCompletado() async => asistente = true;
}

class TomaRepositoryEnMemoria implements TomaRepository {
  TomaRepositoryEnMemoria([List<RegistroToma> iniciales = const []]) {
    registros.addAll(iniciales);
  }

  final List<RegistroToma> registros = [];

  @override
  Future<List<RegistroToma>> obtenerEntre(
    DateTime desde,
    DateTime hasta,
  ) async {
    final inicio = FormatoFechas.soloFecha(desde);
    final fin = FormatoFechas.soloFecha(hasta);
    return [
      for (final r in registros)
        if (!r.fecha.isBefore(inicio) && !r.fecha.isAfter(fin)) r,
    ]..sort((a, b) {
      final porFecha = a.fecha.compareTo(b.fecha);
      return porFecha != 0 ? porFecha : a.hora.compareTo(b.hora);
    });
  }

  @override
  Future<void> guardar(RegistroToma registro) async {
    registros
      ..removeWhere(
        (r) => r.esDe(registro.medicamentoId, registro.fecha, registro.hora),
      )
      ..add(registro);
  }

  @override
  Future<void> borrar(
    int medicamentoId,
    DateTime fecha,
    HoraDelDia hora,
  ) async => registros.removeWhere((r) => r.esDe(medicamentoId, fecha, hora));
}

class ServicioNotificacionesFalso implements ServicioNotificaciones {
  ServicioNotificacionesFalso({
    this.permiso = true,
    this.alarmasExactas = true,
    this.inicial,
  });

  final _respuestas = StreamController<RespuestaAviso>.broadcast();

  /// Respuesta con la que "se abre" la app (como si se tocara un aviso con
  /// la app cerrada).
  RespuestaAviso? inicial;

  /// Simula que la persona toca un aviso o pulsa uno de sus botones con la
  /// app abierta.
  void responder(RespuestaAviso respuesta) => _respuestas.add(respuesta);

  @override
  Stream<RespuestaAviso> get respuestas => _respuestas.stream;

  @override
  Future<RespuestaAviso?> respuestaInicial() async => inicial;

  /// Si el teléfono da (o mantiene) el permiso de notificaciones.
  bool permiso;
  bool alarmasExactas;
  int solicitudesPermiso = 0;
  int solicitudesAlarmasExactas = 0;
  int aperturasAjustesTelefono = 0;

  /// Canales con los que se han enviado avisos de prueba.
  final List<CanalAvisos> avisosDePrueba = [];

  /// Avisos programados en este momento (tras el último reemplazo).
  List<AvisoProgramado> programados = [];
  CanalAvisos? canal;

  Set<int> get idsProgramados => {for (final a in programados) a.id};

  List<AvisoProgramado> deTipo(TipoAviso tipo) => [
    for (final a in programados)
      if (a.tipo == tipo) a,
  ];

  Set<int> idsDeTipo(TipoAviso tipo) => {for (final a in deTipo(tipo)) a.id};

  @override
  Future<void> inicializar() async {}

  @override
  Future<bool> solicitarPermiso() async {
    solicitudesPermiso++;
    return permiso;
  }

  @override
  Future<bool> permisoConcedido() async => permiso;

  @override
  Future<void> abrirAjustesDelTelefono() async {
    aperturasAjustesTelefono++;
  }

  @override
  Future<void> mostrarAvisoDePrueba(CanalAvisos canal) async {
    avisosDePrueba.add(canal);
  }

  @override
  Future<bool> puedeUsarAlarmasExactas() async => alarmasExactas;

  @override
  Future<void> solicitarAlarmasExactas() async {
    solicitudesAlarmasExactas++;
  }

  @override
  Future<void> reemplazarTodos(
    List<AvisoProgramado> avisos,
    CanalAvisos canal,
  ) async {
    programados = List.of(avisos);
    this.canal = canal;
  }
}

class ServicioBateriaFalso implements ServicioBateria {
  ServicioBateriaFalso({
    this.optimizada = false,
    this.restringida = false,
    this.fabricante = 'google',
  });

  bool optimizada;
  bool restringida;
  String fabricante;
  int aperturasAjustes = 0;

  @override
  Future<EstadoBateria> estado() async => EstadoBateria(
    optimizada: optimizada,
    restringida: restringida,
    fabricante: fabricante,
  );

  @override
  Future<void> abrirAjustesDeLaApp() async {
    aperturasAjustes++;
  }
}

class ServicioWidgetFalso implements ServicioWidget {
  /// Lo último que se le ha mandado mostrar.
  Map<String, Object?>? datos;

  /// Lo que se pulsó en el widget para abrir la app.
  RespuestaAviso? inicial;

  /// Si el teléfono sabe ponerlo en la pantalla de inicio.
  bool sabeAnadir = true;
  int peticiones = 0;

  final _acciones = StreamController<RespuestaAviso>.broadcast();

  /// Simula que se pulsa el widget con la app abierta.
  void pulsar(RespuestaAviso respuesta) => _acciones.add(respuesta);

  @override
  Future<void> actualizar(Map<String, Object?> datos) async =>
      this.datos = datos;

  @override
  Future<RespuestaAviso?> accionInicial() async => inicial;

  @override
  Stream<RespuestaAviso> get acciones => _acciones.stream;

  @override
  Future<bool> pedirAnadir() async {
    peticiones++;
    return sabeAnadir;
  }
}

class MarcadorTelefonoFalso implements MarcadorTelefono {
  MarcadorTelefonoFalso({this.resultado = true});

  final bool resultado;
  final List<String> numerosMarcados = [];

  @override
  Future<bool> abrirMarcador(String numero) async {
    numerosMarcados.add(numero);
    return resultado;
  }
}

class ServicioVozFalso implements ServicioVoz {
  ServicioVozFalso({this.disponible = true, this.dictado = false});

  /// Si el teléfono tiene voz en español.
  bool disponible;

  /// Si el teléfono tiene dictado por voz.
  bool dictado;

  /// Lo que devolverá el próximo dictado.
  ResultadoDictado respuestaDictado = const DictadoCancelado();

  final List<String> leidos = [];
  final List<String> indicaciones = [];
  int vecesCallado = 0;

  @override
  Future<bool> hablar(String texto) async {
    if (!disponible) return false;
    leidos.add(texto);
    return true;
  }

  @override
  Future<void> callar() async => vecesCallado++;

  @override
  Future<bool> puedeDictar() async => dictado;

  @override
  Future<ResultadoDictado> dictar(String indicacion) async {
    indicaciones.add(indicacion);
    return respuestaDictado;
  }
}

/// PNG transparente de 1 × 1 píxeles.
final Uint8List pngVacio = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// Fotos en memoria: en los tests de widgets el acceso real a disco no
/// termina nunca, así que aquí no se leen ni se escriben ficheros.
class AlmacenFotosEnMemoria implements AlmacenFotos {
  AlmacenFotosEnMemoria([Map<String, Uint8List>? fotos]) : fotos = {...?fotos};

  /// Nombre del fichero → contenido.
  final Map<String, Uint8List> fotos;

  /// Rutas de las fotos que se han copiado.
  final List<String> originales = [];
  int _siguiente = 1;

  @override
  Future<String> guardar(String rutaOriginal) async {
    originales.add(rutaOriginal);
    final nombre = 'caja_${_siguiente++}.jpg';
    fotos[nombre] = pngVacio;
    return nombre;
  }

  @override
  ImageProvider imagen(String nombre) => MemoryImage(fotos[nombre] ?? pngVacio);

  @override
  String ruta(String nombre) => '/fotos/$nombre';

  @override
  Future<Uint8List?> leer(String nombre) async => fotos[nombre];

  @override
  Future<void> escribir(String nombre, Uint8List datos) async =>
      fotos[nombre] = datos;

  @override
  Future<void> limpiar(Set<String> enUso) async =>
      fotos.removeWhere((nombre, _) => !enUso.contains(nombre));
}

class SelectorFotosFalso implements SelectorFotos {
  /// Ruta que devolverá la cámara o la galería (`null`: la persona vuelve
  /// sin elegir).
  String? siguiente = '/tmp/foto_de_la_camara.jpg';

  /// Simula que la cámara no se puede abrir.
  bool fallar = false;

  /// Foto que el teléfono guardó porque Android cerró la app con la cámara
  /// abierta.
  String? perdida;

  /// Se llama con la cámara "abierta", para ver qué había guardado la app.
  void Function()? alElegir;

  final List<OrigenFoto> origenes = [];

  @override
  Future<String?> elegir(OrigenFoto origen) async {
    origenes.add(origen);
    alElegir?.call();
    if (fallar) throw PlatformException(code: 'camera_access_denied');
    return siguiente;
  }

  @override
  Future<String?> recuperarPerdida() async {
    final foto = perdida;
    perdida = null;
    return foto;
  }
}

class BorradorRepositoryEnMemoria implements BorradorRepository {
  BorradorRepositoryEnMemoria([this.borrador]);

  BorradorMedicamento? borrador;

  @override
  BorradorMedicamento? leer() => borrador;

  @override
  Future<void> guardar(BorradorMedicamento nuevo) async => borrador = nuevo;

  @override
  Future<void> borrar() async => borrador = null;
}

/// Fichero compartido, guardado o impreso.
typedef FicheroFalso = ({String nombre, String tipo, Uint8List datos});

class ServicioArchivosFalso implements ServicioArchivos {
  final List<FicheroFalso> compartidos = [];
  final List<String> asuntos = [];
  final List<FicheroFalso> guardados = [];
  final List<FicheroFalso> impresos = [];

  /// Lo que devolverá `abrir` (`null`: la persona vuelve sin elegir).
  Uint8List? alAbrir;

  /// `false`: la persona vuelve sin guardar.
  bool aceptarGuardado = true;

  @override
  Future<void> compartir({
    required String nombre,
    required String tipo,
    required Uint8List datos,
    required String asunto,
  }) async {
    compartidos.add((nombre: nombre, tipo: tipo, datos: datos));
    asuntos.add(asunto);
  }

  @override
  Future<bool> guardar({
    required String nombre,
    required String tipo,
    required Uint8List datos,
  }) async {
    if (!aceptarGuardado) return false;
    guardados.add((nombre: nombre, tipo: tipo, datos: datos));
    return true;
  }

  @override
  Future<Uint8List?> abrir() async => alAbrir;

  @override
  Future<void> imprimirPdf({
    required String nombre,
    required Uint8List datos,
  }) async =>
      impresos.add((nombre: nombre, tipo: 'application/pdf', datos: datos));
}
