import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import 'dias_de_toma.dart';

/// Lo escrito en el formulario de medicamento al abrir la cámara o la
/// galería. Si Android cierra la app mientras tanto (pasa en móviles con poca
/// memoria), al volver a abrirla se recupera el formulario tal como estaba.
class BorradorMedicamento {
  const BorradorMedicamento({
    this.medicamentoId,
    this.nombre = '',
    this.dosis = '',
    this.instrucciones = '',
    required this.numTomas,
    required this.frecuenciaHoras,
    required this.horaInicio,
    required this.conFechaFin,
    required this.fechaFin,
    this.foto,
    this.horas,
    this.dias = const TodosLosDias(),
    this.aDemanda = false,
    this.llevarCuenta = false,
    this.existencias = '',
    this.porToma = 1,
    this.porTomas = const [],
    this.dosisDistinta = false,
    this.dosisTomas = const [],
    this.maximoAlDia = 0,
    this.horasEntreTomas = 0,
    this.conReceta = false,
    this.receta,
  });

  /// El medicamento que se estaba modificando, o `null` si era uno nuevo.
  final int? medicamentoId;

  /// Los campos de texto, tal como se habían escrito.
  final String nombre;
  final String dosis;
  final String instrucciones;

  final int numTomas;
  final int frecuenciaHoras;
  final HoraDelDia horaInicio;
  final bool conFechaFin;

  /// El último día elegido (o el que se proponía), aunque esté elegido
  /// "Siempre".
  final DateTime fechaFin;

  /// La foto que ya tenía el formulario, si tenía.
  final String? foto;

  /// Las horas elegidas una a una, o `null` si se reparten por igual.
  final List<HoraDelDia>? horas;

  final DiasDeToma dias;

  /// Si se había elegido "Solo cuando haga falta" (las tomas y los días se
  /// guardan igual, por si se vuelve a elegir un horario).
  final bool aDemanda;

  /// La cuenta de las pastillas: si se lleva, lo escrito en "Pastillas que
  /// tienes ahora" y cuántas en cada toma.
  final bool llevarCuenta;
  final String existencias;
  final double porToma;

  /// Si la dosis cambia según la hora: lo escrito en la de cada toma y las
  /// pastillas de cada una (en el orden de las tomas del formulario).
  final bool dosisDistinta;
  final List<String> dosisTomas;
  final List<double> porTomas;

  /// Los límites de un "cuando haga falta"; 0 es sin límite.
  final int maximoAlDia;
  final int horasEntreTomas;

  /// Si se había elegido una fecha para la receta, y cuál (aunque se haya
  /// vuelto a "Sin fecha").
  final bool conReceta;
  final DateTime? receta;

  Map<String, Object?> toJson() => {
    'medicamentoId': medicamentoId,
    'nombre': nombre,
    'dosis': dosis,
    'instrucciones': instrucciones,
    'numTomas': numTomas,
    'frecuenciaHoras': frecuenciaHoras,
    'horaInicio': horaInicio.minutosDesdeMedianoche,
    'conFechaFin': conFechaFin,
    'fechaFin': FormatoFechas.isoFecha(fechaFin),
    'foto': foto,
    'horas': horas?.map((h) => h.minutosDesdeMedianoche).toList(),
    'dias': dias.codificar(),
    'aDemanda': aDemanda,
    'llevarCuenta': llevarCuenta,
    'existencias': existencias,
    'porToma': porToma,
    'porTomas': porTomas,
    'dosisDistinta': dosisDistinta,
    'dosisTomas': dosisTomas,
    'maximoAlDia': maximoAlDia,
    'horasEntreTomas': horasEntreTomas,
    'conReceta': conReceta,
    'receta': receta == null ? null : FormatoFechas.isoFecha(receta!),
  };

  /// `null` si los datos no son un borrador válido (por ejemplo, de una
  /// versión con otro formato): en ese caso, simplemente no se recupera.
  static BorradorMedicamento? desdeJson(Object? json) {
    if (json is! Map<String, Object?>) return null;
    try {
      return BorradorMedicamento(
        medicamentoId: json['medicamentoId'] as int?,
        nombre: json['nombre']! as String,
        dosis: json['dosis']! as String,
        instrucciones: json['instrucciones']! as String,
        numTomas: json['numTomas']! as int,
        frecuenciaHoras: json['frecuenciaHoras']! as int,
        horaInicio: HoraDelDia.desdeMinutos(json['horaInicio']! as int),
        conFechaFin: json['conFechaFin']! as bool,
        fechaFin: FormatoFechas.desdeIsoFecha(json['fechaFin']! as String),
        foto: json['foto'] as String?,
        horas: switch (json['horas']) {
          final List<Object?> lista => [
            for (final h in lista) HoraDelDia.desdeMinutos(h! as int),
          ],
          _ => null,
        },
        dias: DiasDeToma.decodificar(json['dias'] as String?),
        aDemanda: json['aDemanda'] as bool? ?? false,
        llevarCuenta: json['llevarCuenta'] as bool? ?? false,
        existencias: json['existencias'] as String? ?? '',
        porToma: (json['porToma'] as num? ?? 1).toDouble(),
        porTomas: [
          for (final n in json['porTomas'] as List<Object?>? ?? const [])
            (n! as num).toDouble(),
        ],
        dosisDistinta: json['dosisDistinta'] as bool? ?? false,
        dosisTomas: [
          for (final d in json['dosisTomas'] as List<Object?>? ?? const [])
            d! as String,
        ],
        maximoAlDia: json['maximoAlDia'] as int? ?? 0,
        horasEntreTomas: json['horasEntreTomas'] as int? ?? 0,
        conReceta: json['conReceta'] as bool? ?? false,
        receta: switch (json['receta']) {
          final String fecha => FormatoFechas.desdeIsoFecha(fecha),
          _ => null,
        },
      );
    } on Object {
      return null;
    }
  }
}
