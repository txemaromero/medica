import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';
import 'dias_de_toma.dart';
import 'existencias.dart';
import 'horario_tomas.dart';

/// Medicamento registrado por el usuario.
///
/// Las horas de toma salen de [horaInicio], [numTomas] y [frecuenciaHoras]
/// (repartidas por igual) o, si se eligieron una a una, de [horasLibres]. La
/// dosis es la misma en todas las tomas ([dosis]) o una en cada una
/// ([dosisPorToma]). Se
/// toma los [dias] indicados (todos, por defecto), hasta [fechaFin] si el
/// tratamiento tiene una duración concreta. Los de [aDemanda] ("cuando haga
/// falta") no tienen horario ni avisos: cada toma se anota al hacerla, y
/// pueden tener un máximo al día ([maximoAlDia]) y un tiempo mínimo entre una
/// toma y otra ([horasEntreTomas]). Con [existencias], la app lleva la cuenta
/// de las pastillas que quedan, y con [renovarReceta], avisa antes de que se
/// acabe la receta (ver `Receta`).
class Medicamento {
  const Medicamento({
    required this.id,
    required this.nombre,
    required this.numTomas,
    required this.frecuenciaHoras,
    required this.horaInicio,
    required this.fechaCreacion,
    this.dosis,
    this.instrucciones,
    this.fechaFin,
    this.foto,
    this.horasLibres,
    this.dias = const TodosLosDias(),
    this.aDemanda = false,
    this.existencias,
    this.maximoAlDia,
    this.horasEntreTomas,
    this.renovarReceta,
    this.dosisPorToma,
  });

  /// Límites de [maximoAlDia] y [horasEntreTomas].
  static const int maximoVecesAlDia = 12;
  static const int maximoHorasEntreTomas = 24;

  /// Construye el medicamento a partir de los datos del formulario: recorta
  /// los textos, deja en `null` los opcionales vacíos, guarda solo el día de
  /// la fecha de fin y de la receta, quita los límites si no es "cuando haga
  /// falta" y la dosis de cada toma si no tiene varias (o si están todas
  /// vacías).
  factory Medicamento.desdeDatos({
    required int id,
    required DateTime fechaCreacion,
    required NuevoMedicamento datos,
  }) {
    final porToma = datos.dosisPorToma;
    final distinta =
        porToma != null &&
        !datos.aDemanda &&
        datos.numTomas > 1 &&
        porToma.length == datos.numTomas &&
        porToma.any((d) => textoOpcional(d) != null);
    return Medicamento._desdeDatos(
      id: id,
      fechaCreacion: fechaCreacion,
      datos: datos,
      dosisPorToma: distinta
          ? List.unmodifiable([for (final d in porToma) d.trim()])
          : null,
    );
  }

  factory Medicamento._desdeDatos({
    required int id,
    required DateTime fechaCreacion,
    required NuevoMedicamento datos,
    required List<String>? dosisPorToma,
  }) => Medicamento(
    id: id,
    fechaCreacion: fechaCreacion,
    nombre: datos.nombre.trim(),
    numTomas: datos.numTomas,
    frecuenciaHoras: datos.frecuenciaHoras,
    horaInicio: datos.horaInicio,
    dosis: dosisPorToma == null ? textoOpcional(datos.dosis) : null,
    dosisPorToma: dosisPorToma,
    instrucciones: textoOpcional(datos.instrucciones),
    fechaFin: datos.fechaFin == null
        ? null
        : FormatoFechas.soloFecha(datos.fechaFin!),
    foto: datos.foto,
    horasLibres: datos.horasLibres == null
        ? null
        : List.unmodifiable([...datos.horasLibres!]..sort()),
    dias: datos.dias,
    aDemanda: datos.aDemanda,
    existencias: datos.existencias,
    maximoAlDia: datos.aDemanda ? datos.maximoAlDia : null,
    horasEntreTomas: datos.aDemanda ? datos.horasEntreTomas : null,
    renovarReceta: datos.renovarReceta == null
        ? null
        : FormatoFechas.soloFecha(datos.renovarReceta!),
  );

  final int id;
  final String nombre;

  /// Número de tomas al día (≥ 1). Con [horasLibres], cuántas son.
  final int numTomas;

  /// Horas entre una toma y la siguiente. Con una sola toma al día vale 24.
  /// Con [horasLibres] no se usa (se guarda la sugerida, para que siga
  /// siendo válida).
  final int frecuenciaHoras;

  /// Hora de la primera toma del día. Con [horasLibres], la primera.
  final HoraDelDia horaInicio;

  final DateTime fechaCreacion;

  /// Cantidad en cada toma, por ejemplo "1 pastilla" (opcional). `null` si
  /// cambia según la hora ([dosisPorToma]).
  final String? dosis;

  /// Si la dosis cambia según la hora, la de cada toma, en el orden de
  /// [horasDeToma] (vacía si esa toma no la tiene); si no, `null`.
  final List<String>? dosisPorToma;

  /// La dosis de la toma de las [hora].
  String? dosisDe(HoraDelDia hora) {
    final lista = dosisPorToma;
    if (lista == null) return dosis;
    final indice = horasDeToma.indexOf(hora);
    return indice < 0 || indice >= lista.length
        ? null
        : textoOpcional(lista[indice]);
  }

  /// Para la lista y el PDF: "1 pastilla" o, si cambia según la hora, "1
  /// pastilla a las 08:00 y media pastilla a las 21:00". `null` si no tiene.
  String? get describirDosis {
    final lista = dosisPorToma;
    if (lista == null) return dosis;
    final horas = horasDeToma;
    final partes = [
      for (final (i, hora) in horas.indexed)
        if (i < lista.length && textoOpcional(lista[i]) != null)
          textosApp.medicamentoDosisALas(lista[i].trim(), hora.texto),
    ];
    return partes.isEmpty ? null : FormatoFechas.lista(partes);
  }

  /// Indicaciones, por ejemplo "con el desayuno" (opcional).
  final String? instrucciones;

  /// Último día del tratamiento, incluido. `null` si no tiene fin.
  final DateTime? fechaFin;

  /// Nombre del fichero con la foto de la caja (ver `AlmacenFotos`), o
  /// `null` si no tiene.
  final String? foto;

  /// Horas elegidas una a una (por ejemplo, desayuno, comida y cena),
  /// ordenadas, o `null` si se reparten por igual.
  final List<HoraDelDia>? horasLibres;

  final DiasDeToma dias;

  /// Se toma solo cuando hace falta (por ejemplo, un calmante): sin horas de
  /// toma ni avisos. Se guardan igualmente una toma diaria y una hora, que no
  /// se usan.
  final bool aDemanda;

  /// Cuenta de las pastillas, o `null` si no se lleva.
  final Existencias? existencias;

  /// En los de [aDemanda], cuántas veces se puede tomar al día como mucho
  /// (1 a [maximoVecesAlDia]), o `null` si no hay máximo.
  final int? maximoAlDia;

  /// En los de [aDemanda], cuántas horas tienen que pasar como mínimo entre
  /// una toma y la siguiente (1 a [maximoHorasEntreTomas]), o `null`.
  final int? horasEntreTomas;

  bool get tieneLimites => maximoAlDia != null || horasEntreTomas != null;

  /// Último día de la receta, si hay que renovarla, o `null`.
  final DateTime? renovarReceta;

  /// Por ejemplo, "Como mucho 3 veces al día, con al menos 6 horas entre una
  /// y otra.", o `null` si no tiene límites.
  String? get describirLimites {
    final t = textosApp;
    final partes = [
      if (maximoAlDia case final veces?) t.limitesMaximo(veces),
      if (horasEntreTomas case final horas?) t.limitesHoras(horas),
    ];
    if (partes.isEmpty) return null;
    return '${FormatoFechas.conMayuscula(partes.join(', '))}.';
  }

  /// Horas previstas cada día de toma. Ninguna si es [aDemanda].
  List<HoraDelDia> get horasDeToma => aDemanda
      ? const []
      : horasLibres ??
            HorarioTomas.calcular(
              horaInicio: horaInicio,
              numTomas: numTomas,
              frecuenciaHoras: frecuenciaHoras,
            );

  String get descripcionTomas => aDemanda
      ? textosApp.medicamentoADemanda
      : horasLibres == null
      ? HorarioTomas.describir(numTomas, frecuenciaHoras)
      : HorarioTomas.describirLibres(numTomas);

  /// `true` si el tratamiento tenía fecha de fin y ya ha pasado.
  bool terminado(DateTime ahora) => terminadoEl(ahora);

  /// `true` si el tratamiento tiene fecha de fin y [dia] es posterior.
  bool terminadoEl(DateTime dia) {
    final fin = fechaFin;
    return fin != null &&
        FormatoFechas.soloFecha(dia).isAfter(FormatoFechas.soloFecha(fin));
  }

  /// `true` si [dia] es día de toma: entra en el tratamiento y es uno de los
  /// [dias]. Los de [aDemanda] no tienen días de toma.
  bool seTomaEl(DateTime dia) =>
      !aDemanda && !terminadoEl(dia) && dias.incluye(dia);

  /// Mismo medicamento (mismo `id` y fecha de creación) con otros datos; se
  /// usa al modificarlo.
  Medicamento conDatos(NuevoMedicamento datos) => Medicamento.desdeDatos(
    id: id,
    fechaCreacion: fechaCreacion,
    datos: datos,
  );

  /// Mismo medicamento con otra fecha de la receta (`null`, sin fecha), al
  /// renovarla.
  Medicamento conReceta(DateTime? fecha) => Medicamento(
    id: id,
    nombre: nombre,
    numTomas: numTomas,
    frecuenciaHoras: frecuenciaHoras,
    horaInicio: horaInicio,
    fechaCreacion: fechaCreacion,
    dosis: dosis,
    instrucciones: instrucciones,
    fechaFin: fechaFin,
    foto: foto,
    horasLibres: horasLibres,
    dias: dias,
    aDemanda: aDemanda,
    existencias: existencias,
    maximoAlDia: maximoAlDia,
    horasEntreTomas: horasEntreTomas,
    renovarReceta: fecha == null ? null : FormatoFechas.soloFecha(fecha),
    dosisPorToma: dosisPorToma,
  );

  /// Mismo medicamento con otra cuenta de pastillas (por ejemplo, después de
  /// comprar más).
  Medicamento conExistencias(Existencias? existencias) => Medicamento(
    id: id,
    nombre: nombre,
    numTomas: numTomas,
    frecuenciaHoras: frecuenciaHoras,
    horaInicio: horaInicio,
    fechaCreacion: fechaCreacion,
    dosis: dosis,
    instrucciones: instrucciones,
    fechaFin: fechaFin,
    foto: foto,
    horasLibres: horasLibres,
    dias: dias,
    aDemanda: aDemanda,
    existencias: existencias,
    maximoAlDia: maximoAlDia,
    horasEntreTomas: horasEntreTomas,
    renovarReceta: renovarReceta,
    dosisPorToma: dosisPorToma,
  );

  @override
  bool operator ==(Object other) =>
      other is Medicamento &&
      other.id == id &&
      other.nombre == nombre &&
      other.numTomas == numTomas &&
      other.frecuenciaHoras == frecuenciaHoras &&
      other.horaInicio == horaInicio &&
      other.fechaCreacion == fechaCreacion &&
      other.dosis == dosis &&
      other.instrucciones == instrucciones &&
      other.fechaFin == fechaFin &&
      other.foto == foto &&
      other.horasLibres?.join(',') == horasLibres?.join(',') &&
      other.dias == dias &&
      other.aDemanda == aDemanda &&
      other.existencias == existencias &&
      other.maximoAlDia == maximoAlDia &&
      other.horasEntreTomas == horasEntreTomas &&
      other.renovarReceta == renovarReceta &&
      other.dosisPorToma?.join('\u0000') == dosisPorToma?.join('\u0000');

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    numTomas,
    frecuenciaHoras,
    horaInicio,
    fechaCreacion,
    dosis,
    instrucciones,
    fechaFin,
    foto,
    horasLibres?.join(','),
    dias,
    aDemanda,
    existencias,
    maximoAlDia,
    horasEntreTomas,
    renovarReceta,
    dosisPorToma?.join('\u0000'),
  );

  @override
  String toString() =>
      'Medicamento($id, $nombre, '
      '${aDemanda
          ? 'a demanda'
          : horasLibres == null
          ? '$numTomas tomas, cada $frecuenciaHoras h, desde $horaInicio'
          : 'a las ${horasLibres!.join(', ')}'}'
      ', $dias${fechaFin == null ? '' : ', hasta $fechaFin'}'
      '${existencias == null ? '' : ', $existencias'}'
      '${maximoAlDia == null ? '' : ', como mucho $maximoAlDia al día'}'
      '${horasEntreTomas == null ? '' : ', cada $horasEntreTomas h o más'}'
      '${renovarReceta == null ? '' : ', receta hasta $renovarReceta'})';
}

/// Datos de un medicamento tal como se rellenan en el formulario (todavía
/// sin `id`).
class NuevoMedicamento {
  const NuevoMedicamento({
    required this.nombre,
    required this.numTomas,
    required this.frecuenciaHoras,
    required this.horaInicio,
    this.dosis,
    this.instrucciones,
    this.fechaFin,
    this.foto,
    this.horasLibres,
    this.dias = const TodosLosDias(),
    this.aDemanda = false,
    this.existencias,
    this.maximoAlDia,
    this.horasEntreTomas,
    this.renovarReceta,
    this.dosisPorToma,
  });

  final String nombre;
  final int numTomas;
  final int frecuenciaHoras;
  final HoraDelDia horaInicio;
  final String? dosis;
  final String? instrucciones;
  final DateTime? fechaFin;
  final String? foto;
  final List<HoraDelDia>? horasLibres;
  final DiasDeToma dias;
  final bool aDemanda;
  final Existencias? existencias;
  final int? maximoAlDia;
  final int? horasEntreTomas;
  final DateTime? renovarReceta;

  /// La dosis de cada toma, si cambia según la hora (una por toma).
  final List<String>? dosisPorToma;
}

/// Texto recortado, o `null` si queda vacío.
String? textoOpcional(String? texto) {
  final limpio = texto?.trim() ?? '';
  return limpio.isEmpty ? null : limpio;
}
