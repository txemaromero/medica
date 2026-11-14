import '../../l10n/textos.dart';
import 'hora_del_dia.dart';

/// Formateo de fechas y horas con palabras completas (sin abreviaturas), para
/// que resulten fáciles de leer. Las palabras salen de los textos de la app
/// (lib/l10n), en el idioma actual.
abstract final class FormatoFechas {
  static List<String> get diasSemana {
    final t = textosApp;
    return [
      t.fechaLunes,
      t.fechaMartes,
      t.fechaMiercoles,
      t.fechaJueves,
      t.fechaViernes,
      t.fechaSabado,
      t.fechaDomingo,
    ];
  }

  static List<String> get meses {
    final t = textosApp;
    return [
      t.fechaEnero,
      t.fechaFebrero,
      t.fechaMarzo,
      t.fechaAbril,
      t.fechaMayo,
      t.fechaJunio,
      t.fechaJulio,
      t.fechaAgosto,
      t.fechaSeptiembre,
      t.fechaOctubre,
      t.fechaNoviembre,
      t.fechaDiciembre,
    ];
  }

  static String nombreMes(int mes) => meses[mes - 1];

  static String nombreDiaSemana(DateTime fecha) =>
      diasSemana[fecha.weekday - 1];

  /// Por ejemplo: `domingo, 25 de octubre de 2026`.
  static String fechaLarga(DateTime fecha) => textosApp.fechaLarga(
    nombreDiaSemana(fecha),
    '${fecha.day}',
    nombreMes(fecha.month),
    '${fecha.year}',
  );

  /// Sin el año: `domingo, 25 de octubre`.
  static String fechaCorta(DateTime fecha) => textosApp.fechaCorta(
    nombreDiaSemana(fecha),
    '${fecha.day}',
    nombreMes(fecha.month),
  );

  /// Igual que [fechaLarga] pero antepone "Hoy", "Mañana" o "Ayer" cuando
  /// aplica.
  static String fechaRelativa(DateTime fecha, DateTime hoy) {
    final dia = soloFecha(fecha);
    final referencia = soloFecha(hoy);
    final diferencia = _diasEntre(referencia, dia);
    final larga = fechaLarga(dia);
    if (diferencia == 0) return textosApp.fechaHoy(larga);
    if (diferencia == 1) return textosApp.fechaManana(larga);
    if (diferencia == -1) return textosApp.fechaAyer(larga);
    return conMayuscula(larga);
  }

  /// Cuándo ocurre algo, en una frase corta: `hoy a las 16:00`,
  /// `mañana a las 08:00` o `el martes, 27 de octubre, a las 10:30`.
  static String cuando(DateTime fechaHora, DateTime ahora) {
    final hora = HoraDelDia(fechaHora.hour, fechaHora.minute).texto;
    final diferencia = _diasEntre(soloFecha(ahora), soloFecha(fechaHora));
    if (diferencia == 0) return textosApp.fechaCuandoHoy(hora);
    if (diferencia == 1) return textosApp.fechaCuandoManana(hora);
    return textosApp.fechaCuandoOtroDia(
      nombreDiaSemana(fechaHora),
      '${fechaHora.day}',
      nombreMes(fechaHora.month),
      hora,
    );
  }

  /// Parte del día en lenguaje cotidiano, por ejemplo `de la mañana`.
  static String parteDelDia(HoraDelDia hora) {
    final t = textosApp;
    final h = hora.hora;
    if (h < 6) return t.fechaDeLaMadrugada;
    if (h < 12) return t.fechaDeLaManana;
    if (h < 15) return t.fechaDelMediodia;
    if (h < 21) return t.fechaDeLaTarde;
    return t.fechaDeLaNoche;
  }

  /// Por ejemplo: `08:30 de la mañana`.
  static String horaConParteDelDia(HoraDelDia hora) =>
      textosApp.fechaHoraConParteDelDia(hora.texto, parteDelDia(hora));

  /// Lista legible de horas: `08:00, 16:00 y 00:00`.
  static String listaDeHoras(List<HoraDelDia> horas) =>
      lista([for (final h in horas) h.texto]);

  /// Une los elementos de una lista como se diría: `a, b y c`.
  static String lista(List<String> elementos) {
    if (elementos.isEmpty) return '';
    if (elementos.length == 1) return elementos.first;
    final t = textosApp;
    return t.fechaListaUltimo(
      elementos.sublist(0, elementos.length - 1).join(t.fechaSeparadorLista),
      elementos.last,
    );
  }

  static DateTime soloFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);

  /// Fecha en formato ISO `AAAA-MM-DD`, usada para guardar en la base de datos.
  static String isoFecha(DateTime fecha) =>
      '${fecha.year.toString().padLeft(4, '0')}-'
      '${fecha.month.toString().padLeft(2, '0')}-'
      '${fecha.day.toString().padLeft(2, '0')}';

  static DateTime desdeIsoFecha(String texto) {
    final partes = texto.split('-').map(int.parse).toList();
    return DateTime(partes[0], partes[1], partes[2]);
  }

  static int _diasEntre(DateTime desde, DateTime hasta) => DateTime.utc(
    hasta.year,
    hasta.month,
    hasta.day,
  ).difference(DateTime.utc(desde.year, desde.month, desde.day)).inDays;

  /// El texto con la primera letra en mayúscula: `los lunes` → `Los lunes`.
  static String conMayuscula(String texto) =>
      texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);
}
