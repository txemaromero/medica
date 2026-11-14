import 'dart:convert';
import 'dart:typed_data';

import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';
import '../../agenda/domain/cita.dart';
import '../../agenda/domain/validador_cita.dart';
import '../../ajustes/domain/ajustes.dart';
import '../../ajustes/domain/tamano_texto.dart';
import '../../ajustes/domain/validador_familiar.dart';
import '../../ajustes/domain/validador_telefono.dart';
import '../../medicamentos/domain/dias_de_toma.dart';
import '../../medicamentos/domain/existencias.dart';
import '../../medicamentos/domain/horario_tomas.dart';
import '../../medicamentos/domain/medicamento.dart';
import '../../medicamentos/domain/validador_medicamento.dart';
import '../../tomas/domain/registro_toma.dart';

/// El fichero no se puede recuperar; [mensaje] explica por qué, en lenguaje
/// claro.
class CopiaNoValida implements Exception {
  const CopiaNoValida(this.mensaje);

  final String mensaje;

  @override
  String toString() => 'CopiaNoValida: $mensaje';
}

/// Todos los datos de la app en un solo fichero JSON: medicamentos (con sus
/// fotos), citas, tomas anotadas y ajustes.
class CopiaDeSeguridad {
  const CopiaDeSeguridad({
    required this.creada,
    required this.medicamentos,
    required this.citas,
    required this.tomas,
    required this.ajustes,
    this.fotos = const {},
  });

  static const String identificador = 'salud_mayores';

  /// 2: horas elegidas una a una, días de toma y medicamentos "cuando haga
  /// falta". 3: medias pastillas y dosis distinta en cada toma. Una versión
  /// anterior de la app rechaza estas copias en vez de leerlas mal (una
  /// medicina semanal pasaría a ser diaria, o no podría leer "14,5
  /// pastillas"); las copias de formatos anteriores se siguen leyendo. La cuenta de las pastillas, los límites
  /// de los "cuando haga falta" y la fecha de la receta son opcionales: una
  /// copia sin ellos se lee igual (y una versión anterior de la app, que no
  /// los conoce, los ignora).
  static const int formato = 3;
  static const String tipo = 'application/json';

  /// Una copia con muchas fotos ocupa unos pocos MB: más de esto no es una
  /// copia (y leerlo entero podría agotar la memoria del teléfono).
  static const int tamanoMaximo = 50 * 1024 * 1024;

  /// Las fotos de la app se reducen a unos 200 KB.
  static const int tamanoMaximoFoto = 5 * 1024 * 1024;

  static String get mensajeNoEsCopia =>
      textosApp.copiaNoEsCopia(textosApp.appTitulo);
  static String get mensajeDemasiadoGrande =>
      textosApp.copiaDemasiadoGrande(textosApp.appTitulo);
  static String get mensajeVersionNueva => textosApp.copiaVersionNueva;

  final DateTime creada;
  final List<Medicamento> medicamentos;
  final List<Cita> citas;
  final List<RegistroToma> tomas;
  final Ajustes ajustes;

  /// Nombre del fichero → contenido.
  final Map<String, Uint8List> fotos;

  /// Nombre del fichero que se propone al guardarla o enviarla.
  String get nombreFichero =>
      '${textosApp.copiaNombreFichero(textosApp.appTitulo, FormatoFechas.isoFecha(creada))}.json';

  /// Por ejemplo: "3 medicamentos, 2 citas y 40 tomas anotadas".
  String get resumen => FormatoFechas.lista([
    textosApp.copiaMedicamentos(medicamentos.length),
    textosApp.copiaCitas(citas.length),
    textosApp.copiaTomas(tomas.length),
  ]);

  Uint8List codificar() => utf8.encode(
    jsonEncode({
      'app': identificador,
      'formato': formato,
      'creada': creada.toIso8601String(),
      'medicamentos': [for (final m in medicamentos) _medicamento(m)],
      'citas': [for (final c in citas) _cita(c)],
      'tomas': [for (final t in tomas) _toma(t)],
      'ajustes': _ajustes(ajustes),
      'fotos': {
        for (final MapEntry(key: nombre, value: datos) in fotos.entries)
          nombre: base64Encode(datos),
      },
    }),
  );

  /// Lee una copia. Lanza [CopiaNoValida] si el fichero no es una copia, es
  /// de una versión más nueva o tiene datos imposibles.
  ///
  /// La copia puede venir de otro móvil (por WhatsApp, por ejemplo), así que
  /// se comprueba como lo haría el formulario: textos de la longitud que
  /// admite, fotos que de verdad son imágenes, identificadores sin repetir y
  /// teléfonos que se pueden marcar. Un número que no pasa la validación de
  /// Ajustes nunca lo ha guardado la app: la copia está manipulada.
  static CopiaDeSeguridad decodificar(Uint8List datos) {
    if (datos.length > tamanoMaximo) {
      throw CopiaNoValida(mensajeDemasiadoGrande);
    }
    final Object? json;
    try {
      json = jsonDecode(utf8.decode(datos));
    } on FormatException {
      throw CopiaNoValida(mensajeNoEsCopia);
    }
    if (json is! Map<String, Object?> || json['app'] != identificador) {
      throw CopiaNoValida(mensajeNoEsCopia);
    }
    final version = json['formato'];
    if (version is! int) throw CopiaNoValida(mensajeNoEsCopia);
    if (version > formato) throw CopiaNoValida(mensajeVersionNueva);
    try {
      final fotos = {
        for (final MapEntry(key: nombre, value: contenido)
            in (json['fotos']! as Map<String, Object?>).entries)
          _nombreFotoSeguro(nombre): _foto(base64Decode(contenido! as String)),
      };
      final medicamentos = [
        for (final m in json['medicamentos']! as List<Object?>)
          _leerMedicamento(m! as Map<String, Object?>, fotos),
      ];
      final citas = [
        for (final c in json['citas']! as List<Object?>)
          _leerCita(c! as Map<String, Object?>),
      ];
      final tomas = [
        for (final t in json['tomas']! as List<Object?>)
          _leerToma(t! as Map<String, Object?>),
      ];
      // Sin repetir: un medicamento o una cita por identificador y un
      // registro por toma (medicamento, día y hora).
      _comprobar(
        _sinRepetir([for (final m in medicamentos) m.id]) &&
            _sinRepetir([for (final c in citas) c.id]) &&
            _sinRepetir([
              for (final t in tomas)
                (t.medicamentoId, FormatoFechas.isoFecha(t.fecha), t.hora),
            ]),
      );
      return CopiaDeSeguridad(
        creada: DateTime.parse(json['creada']! as String),
        medicamentos: medicamentos,
        citas: citas,
        tomas: tomas,
        ajustes: _leerAjustes(json['ajustes']! as Map<String, Object?>),
        fotos: fotos,
      );
    } on CopiaNoValida {
      rethrow;
    } on Object {
      // Falta un campo, sobra uno con otro tipo, una fecha mal escrita…
      throw CopiaNoValida(mensajeNoEsCopia);
    }
  }

  /// Las fotos se escriben con este nombre en la carpeta de la app: no se
  /// admite nada que pueda salir de ella ("../", rutas…).
  static String _nombreFotoSeguro(String nombre) {
    if (!RegExp(r'^[A-Za-z0-9_-][A-Za-z0-9_.-]{0,99}$').hasMatch(nombre)) {
      throw CopiaNoValida(mensajeNoEsCopia);
    }
    return nombre;
  }

  /// Una foto que de verdad es una imagen (JPEG, PNG, WebP o HEIC, mirando
  /// cómo empieza el fichero) y de un tamaño razonable.
  static Uint8List _foto(Uint8List datos) {
    bool empieza(List<int> firma, [int desde = 0]) =>
        datos.length >= desde + firma.length &&
        [for (var i = 0; i < firma.length; i++) datos[desde + i] == firma[i]]
            .every((igual) => igual);
    final esImagen =
        empieza(const [0xFF, 0xD8, 0xFF]) ||
        empieza(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]) ||
        empieza(ascii.encode('RIFF')) && empieza(ascii.encode('WEBP'), 8) ||
        empieza(ascii.encode('ftyp'), 4) &&
            datos.length >= 12 &&
            _marcasHeic.contains(
              ascii.decode(datos.sublist(8, 12), allowInvalid: true),
            );
    _comprobar(esImagen && datos.length <= tamanoMaximoFoto);
    return datos;
  }

  /// Las marcas de los ficheros HEIC/HEIF (las fotos del iPhone).
  static const Set<String> _marcasHeic = {
    'heic',
    'heix',
    'hevc',
    'heif',
    'mif1',
    'msf1',
  };

  static bool _sinRepetir<T>(List<T> valores) =>
      valores.toSet().length == valores.length;

  /// Un texto opcional que no pasa de [maximo] letras.
  static bool _cabe(String? texto, int maximo) =>
      texto == null || texto.trim().length <= maximo;

  /// Vacío (sin número) o un número que admite Ajustes.
  static bool _telefonoValido(String numero) =>
      numero.isEmpty || ValidadorTelefono.validar(numero) == null;

  static void _comprobar(bool condicion) {
    if (!condicion) throw CopiaNoValida(mensajeNoEsCopia);
  }

  static Map<String, Object?> _medicamento(Medicamento m) => {
    'id': m.id,
    'nombre': m.nombre,
    'numTomas': m.numTomas,
    'frecuenciaHoras': m.frecuenciaHoras,
    'horaInicio': m.horaInicio.minutosDesdeMedianoche,
    'fechaCreacion': m.fechaCreacion.millisecondsSinceEpoch,
    'dosis': m.dosis,
    'dosisPorToma': m.dosisPorToma,
    'instrucciones': m.instrucciones,
    'fechaFin': m.fechaFin == null ? null : FormatoFechas.isoFecha(m.fechaFin!),
    'foto': m.foto,
    'horas': m.horasLibres?.map((h) => h.minutosDesdeMedianoche).toList(),
    'dias': m.dias.codificar(),
    'aDemanda': m.aDemanda,
    'existencias': switch (m.existencias) {
      null => null,
      final e => {
        'cantidad': e.cantidad,
        'contadas': e.contadas.millisecondsSinceEpoch,
        'porToma': e.porToma,
        'porTomas': e.porTomas,
      },
    },
    'maximoAlDia': m.maximoAlDia,
    'horasEntreTomas': m.horasEntreTomas,
    'renovarReceta': m.renovarReceta == null
        ? null
        : FormatoFechas.isoFecha(m.renovarReceta!),
  };

  static Medicamento _leerMedicamento(
    Map<String, Object?> j,
    Map<String, Uint8List> fotos,
  ) {
    final numTomas = j['numTomas']! as int;
    final frecuencia = j['frecuenciaHoras']! as int;
    final hora = j['horaInicio']! as int;
    final horas = switch (j['horas']) {
      final List<Object?> lista => [for (final h in lista) h! as int],
      _ => null,
    };
    _comprobar(
      HorarioTomas.esFrecuenciaValida(numTomas, frecuencia) &&
          hora >= 0 &&
          hora < HoraDelDia.minutosPorDia &&
          (j['nombre']! as String).trim().isNotEmpty &&
          (horas == null ||
              horas.length == numTomas &&
                  horas.toSet().length == horas.length &&
                  horas.every((h) => h >= 0 && h < HoraDelDia.minutosPorDia)),
    );
    final existencias = switch (j['existencias']) {
      final Map<String, Object?> e => Existencias(
        cantidad: (e['cantidad']! as num).toDouble(),
        contadas: DateTime.fromMillisecondsSinceEpoch(e['contadas']! as int),
        porToma: (e['porToma']! as num).toDouble(),
        porTomas: switch (e['porTomas']) {
          final List<Object?> lista => List.unmodifiable([
            for (final n in lista) (n! as num).toDouble(),
          ]),
          _ => null,
        },
      ),
      _ => null,
    };
    bool porTomaValida(double n) => Existencias.esValida(
      n,
      minimo: Existencias.paso,
      maximo: Existencias.maximoPorToma,
    );
    _comprobar(
      existencias == null ||
          Existencias.esValida(existencias.cantidad) &&
              porTomaValida(existencias.porToma) &&
              (existencias.porTomas == null ||
                  existencias.porTomas!.length == numTomas &&
                      existencias.porTomas!.every(porTomaValida)),
    );
    final dosisPorToma = switch (j['dosisPorToma']) {
      final List<Object?> lista => [for (final d in lista) d! as String],
      _ => null,
    };
    _comprobar(dosisPorToma == null || dosisPorToma.length == numTomas);
    final maximoAlDia = j['maximoAlDia'] as int?;
    final horasEntreTomas = j['horasEntreTomas'] as int?;
    _comprobar(
      (maximoAlDia == null ||
              maximoAlDia >= 1 &&
                  maximoAlDia <= Medicamento.maximoVecesAlDia) &&
          (horasEntreTomas == null ||
              horasEntreTomas >= 1 &&
                  horasEntreTomas <= Medicamento.maximoHorasEntreTomas),
    );
    final dosis = j['dosis'] as String?;
    final instrucciones = j['instrucciones'] as String?;
    _comprobar(
      (j['nombre']! as String).trim().length <=
              ValidadorMedicamento.longitudMaximaNombre &&
          _cabe(dosis, ValidadorMedicamento.longitudMaximaDosis) &&
          _cabe(
            instrucciones,
            ValidadorMedicamento.longitudMaximaInstrucciones,
          ) &&
          (dosisPorToma ?? const <String>[]).every(
            (d) => _cabe(d, ValidadorMedicamento.longitudMaximaDosis),
          ),
    );
    final foto = j['foto'] as String?;
    return Medicamento(
      id: j['id']! as int,
      nombre: j['nombre']! as String,
      numTomas: numTomas,
      frecuenciaHoras: frecuencia,
      horaInicio: HoraDelDia.desdeMinutos(hora),
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(
        j['fechaCreacion']! as int,
      ),
      dosis: dosis,
      dosisPorToma: dosisPorToma == null
          ? null
          : List.unmodifiable(dosisPorToma),
      instrucciones: instrucciones,
      fechaFin: switch (j['fechaFin']) {
        final String fecha => FormatoFechas.desdeIsoFecha(fecha),
        _ => null,
      },
      // Una foto que no viene en la copia se descarta.
      foto: fotos.containsKey(foto) ? foto : null,
      horasLibres: horas == null
          ? null
          : List.unmodifiable(
              [for (final h in horas) HoraDelDia.desdeMinutos(h)]..sort(),
            ),
      dias: DiasDeToma.decodificar(j['dias'] as String?),
      aDemanda: j['aDemanda'] as bool? ?? false,
      existencias: existencias,
      maximoAlDia: maximoAlDia,
      horasEntreTomas: horasEntreTomas,
      renovarReceta: switch (j['renovarReceta']) {
        final String fecha => FormatoFechas.desdeIsoFecha(fecha),
        _ => null,
      },
    );
  }

  static Map<String, Object?> _cita(Cita c) => {
    'id': c.id,
    'titulo': c.titulo,
    'fecha': FormatoFechas.isoFecha(c.fecha),
    'hora': c.hora.minutosDesdeMedianoche,
    'lugar': c.lugar,
    'notas': c.notas,
  };

  static Cita _leerCita(Map<String, Object?> j) {
    final hora = j['hora']! as int;
    final titulo = j['titulo']! as String;
    final lugar = j['lugar'] as String?;
    final notas = j['notas'] as String?;
    _comprobar(
      hora >= 0 &&
          hora < HoraDelDia.minutosPorDia &&
          titulo.trim().isNotEmpty &&
          _cabe(titulo, ValidadorCita.longitudMaximaTitulo) &&
          _cabe(lugar, ValidadorCita.longitudMaximaLugar) &&
          _cabe(notas, ValidadorCita.longitudMaximaNotas),
    );
    return Cita(
      id: j['id']! as int,
      titulo: titulo,
      fecha: FormatoFechas.desdeIsoFecha(j['fecha']! as String),
      hora: HoraDelDia.desdeMinutos(hora),
      lugar: lugar,
      notas: notas,
    );
  }

  static Map<String, Object?> _toma(RegistroToma t) => {
    'medicamentoId': t.medicamentoId,
    'nombreMedicamento': t.nombreMedicamento,
    'fecha': FormatoFechas.isoFecha(t.fecha),
    'hora': t.hora.minutosDesdeMedianoche,
    'estado': t.estado.name,
    'momento': t.momento.millisecondsSinceEpoch,
    'recordarEn': t.recordarEn?.millisecondsSinceEpoch,
  };

  static RegistroToma _leerToma(Map<String, Object?> j) {
    final hora = j['hora']! as int;
    _comprobar(hora >= 0 && hora < HoraDelDia.minutosPorDia);
    return RegistroToma(
      medicamentoId: j['medicamentoId']! as int,
      nombreMedicamento: j['nombreMedicamento']! as String,
      fecha: FormatoFechas.desdeIsoFecha(j['fecha']! as String),
      hora: HoraDelDia.desdeMinutos(hora),
      estado: EstadoToma.values.byName(j['estado']! as String),
      momento: DateTime.fromMillisecondsSinceEpoch(j['momento']! as int),
      recordarEn: switch (j['recordarEn']) {
        final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
        _ => null,
      },
    );
  }

  static Map<String, Object?> _ajustes(Ajustes a) => {
    'sonidoActivado': a.sonidoActivado,
    'vibracionActivada': a.vibracionActivada,
    'notificacionesActivadas': a.notificacionesActivadas,
    'numeroEmergencia': a.numeroEmergencia,
    'tamanoTexto': a.tamanoTexto,
    'tema': a.tema.name,
    'leerEnVozAlta': a.leerEnVozAlta,
    'familiarNombre': a.familiarNombre,
    'familiarNumero': a.familiarNumero,
    'recordarResumen': a.recordarResumen,
    'minutosRepeticion': a.minutosRepeticion,
    'minutosAplazamiento': a.minutosAplazamiento,
    'avisosDiscretos': a.avisosDiscretos,
  };

  static Ajustes _leerAjustes(Map<String, Object?> j) {
    final numeroEmergencia = j['numeroEmergencia'] as String? ?? '';
    final familiarNombre = j['familiarNombre'] as String? ?? '';
    final familiarNumero = j['familiarNumero'] as String? ?? '';
    _comprobar(
      _telefonoValido(numeroEmergencia) &&
          _telefonoValido(familiarNumero) &&
          _cabe(familiarNombre, ValidadorFamiliar.maxNombre),
    );
    return _ajustesDe(j, numeroEmergencia, familiarNombre, familiarNumero);
  }

  static Ajustes _ajustesDe(
    Map<String, Object?> j,
    String numeroEmergencia,
    String familiarNombre,
    String familiarNumero,
  ) => Ajustes(
    sonidoActivado: j['sonidoActivado'] as bool? ?? false,
    vibracionActivada: j['vibracionActivada'] as bool? ?? false,
    notificacionesActivadas: j['notificacionesActivadas'] as bool? ?? false,
    numeroEmergencia: numeroEmergencia,
    tamanoTexto: TamanoTexto.normalizar(
      j['tamanoTexto'] as int? ?? TamanoTexto.base,
    ),
    tema: TemaApp.desdeNombre(j['tema'] as String?),
    leerEnVozAlta: j['leerEnVozAlta'] as bool? ?? false,
    familiarNombre: familiarNombre,
    familiarNumero: familiarNumero,
    recordarResumen: j['recordarResumen'] as bool? ?? false,
    minutosRepeticion: Ajustes.repeticionValida(j['minutosRepeticion'] as int?),
    minutosAplazamiento: Ajustes.aplazamientoValido(
      j['minutosAplazamiento'] as int?,
    ),
    avisosDiscretos: j['avisosDiscretos'] as bool? ?? false,
  );
}
