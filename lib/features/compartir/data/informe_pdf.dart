import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../l10n/textos.dart';
import '../../agenda/domain/cita.dart';
import '../../ajustes/domain/ajustes.dart';
import '../../medicamentos/domain/dias_de_toma.dart';
import '../../medicamentos/domain/existencias.dart';
import '../../medicamentos/domain/medicamento.dart';
import '../../tomas/application/tomas_controller.dart';
import '../../tomas/domain/registro_toma.dart';
import '../../tomas/domain/tomas_del_dia.dart';

/// Documento PDF para el médico o la familia: medicamentos (con la foto de la
/// caja), tomas de la última semana, próximas citas y contactos de
/// emergencia. Con letra grande, para que también lo lea la propia persona.
abstract final class InformePdf {
  static String get titulo => textosApp.informeTitulo;
  static const String tipo = 'application/pdf';

  static String nombreFichero(DateTime ahora) =>
      '${textosApp.informeNombreFichero('${ahora.day}-${ahora.month}-${ahora.year}')}.pdf';

  static const PdfColor _gris = PdfColor.fromInt(0xFF444444);
  static const PdfColor _borde = PdfColor.fromInt(0xFF0A2540);

  static Future<Uint8List> generar({
    required List<Medicamento> medicamentos,
    required List<Cita> citas,
    required List<RegistroToma> registros,
    required Ajustes ajustes,
    required DateTime ahora,
    required pw.Font normal,
    required pw.Font negrita,
    Map<String, Uint8List> fotos = const {},
    Map<int, EstadoExistencias> existencias = const {},
  }) async {
    final t = textosApp;
    final activos = [
      for (final m in medicamentos)
        if (!m.terminado(ahora)) m,
    ];
    final proximas = [
      for (final c in ordenarCronologicamente(citas))
        if (!c.yaHaPasado(ahora)) c,
    ];

    final documento = pw.Document(
      title: titulo,
      author: t.appTitulo,
      creator: t.appTitulo,
    );
    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: normal,
          bold: negrita,
        ).copyWith(defaultTextStyle: pw.TextStyle(font: normal, fontSize: 13)),
        footer: (contexto) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            t.informePagina('${contexto.pageNumber}', '${contexto.pagesCount}'),
            style: const pw.TextStyle(fontSize: 10, color: _gris),
          ),
        ),
        build: (contexto) => [
          pw.Text(titulo, style: pw.TextStyle(font: negrita, fontSize: 26)),
          pw.SizedBox(height: 4),
          pw.Text(
            t.informeActualizado(
              FormatoFechas.fechaLarga(ahora),
              HoraDelDia(ahora.hour, ahora.minute).texto,
            ),
            style: const pw.TextStyle(color: _gris),
          ),
          ..._contactos(t, ajustes),
          ..._seccion(t.informeMedicamentos, negrita, [
            if (activos.isEmpty)
              pw.Text(t.informeSinMedicamentos)
            else
              for (final m in activos)
                _medicamento(t, m, fotos[m.foto], existencias[m.id], negrita),
          ]),
          ..._seccion(
            t.informeTomasUltimosDias('${TomasController.diasHistorial}'),
            negrita,
            _tomas(t, medicamentos, registros, ahora, negrita),
          ),
          ..._seccion(t.informeProximasCitas, negrita, [
            if (proximas.isEmpty)
              pw.Text(t.informeSinCitas)
            else
              for (final c in proximas) _cita(t, c, ahora, negrita),
          ]),
        ],
      ),
    );
    return documento.save();
  }

  static List<pw.Widget> _contactos(TextosApp t, Ajustes ajustes) {
    final contactos = [
      if (ajustes.tieneNumeroEmergencia) ajustes.numeroEmergencia,
      if (ajustes.tieneFamiliar)
        t.informeContactoFamiliar(
          ajustes.familiarNombre,
          ajustes.familiarNumero,
        ),
    ];
    if (contactos.isEmpty) return const [];
    return [
      pw.SizedBox(height: 8),
      pw.Text(
        t.informeTelefonosEmergencia(
          contactos.join(t.informeSeparadorTelefonos),
        ),
      ),
    ];
  }

  /// Título de una sección y su contenido. Si queda poco sitio en la página,
  /// la sección empieza en la siguiente: así el título nunca se queda solo
  /// al final de una página. El contenido (la tabla de tomas, por ejemplo)
  /// sí se puede repartir entre varias.
  static List<pw.Widget> _seccion(
    String texto,
    pw.Font negrita,
    List<pw.Widget> contenido,
  ) => [
    pw.NewPage(freeSpace: 180),
    pw.Padding(
      padding: const pw.EdgeInsets.only(top: 22, bottom: 10),
      child: pw.Text(texto, style: pw.TextStyle(font: negrita, fontSize: 19)),
    ),
    ...contenido,
  ];

  static pw.Widget _medicamento(
    TextosApp t,
    Medicamento m,
    Uint8List? foto,
    EstadoExistencias? existencias,
    pw.Font negrita,
  ) {
    final fin = m.fechaFin;
    final lineas = [
      if (m.describirDosis case final dosis?) t.medicamentoDosis(dosis),
      if (m.aDemanda) ...[
        m.descripcionTomas,
        ?m.describirLimites,
      ] else
        t.informeTomasYHoras(
          m.descripcionTomas,
          FormatoFechas.listaDeHoras(m.horasDeToma),
        ),
      if (m.dias.describir() case final dias?) FormatoFechas.conMayuscula(dias),
      fin == null
          ? (m.dias is TodosLosDias && !m.aDemanda
                ? t.medicamentoSinFechaDeFin
                : t.medicamentoSinFechaDeFinSolo)
          : t.medicamentoHastaEl(FormatoFechas.fechaLarga(fin)),
      if (existencias != null) existencias.describir(),
      if (m.renovarReceta case final receta?)
        t.medicamentoRecetaHasta(FormatoFechas.fechaLarga(receta)),
      if (m.instrucciones != null) t.informeInstrucciones(m.instrucciones!),
    ];
    pw.Widget? imagen;
    if (foto != null) {
      try {
        imagen = pw.Image(pw.MemoryImage(foto), width: 80, height: 80);
      } on Object {
        imagen = null;
      }
    }
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _borde, width: 1.5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (imagen != null) ...[imagen, pw.SizedBox(width: 12)],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  m.nombre,
                  style: pw.TextStyle(font: negrita, fontSize: 16),
                ),
                for (final linea in lineas)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 3),
                    child: pw.Text(linea),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _dia(TextosApp t, DateTime dia, int haceDias) =>
      t.informeDiaFecha(
        haceDias == 0 ? t.informeHoy : FormatoFechas.nombreDiaSemana(dia),
        '${dia.day}',
        '${dia.month}',
      );

  /// Las filas de la tabla de tomas: una por día (de hoy hacia atrás) con
  /// el día, cuántas tomas se anotaron y cuáles quedaron sin marcar. Las
  /// anotadas que ya no corresponden a ninguna toma prevista (de un
  /// medicamento borrado o de una hora que se cambió) cuentan como anotadas,
  /// igual que en el historial y en el resumen de la semana.
  static List<List<String>> filasTomas({
    required List<Medicamento> medicamentos,
    required List<RegistroToma> registros,
    required DateTime ahora,
  }) {
    final t = textosApp;
    final hoy = FormatoFechas.soloFecha(ahora);
    final filas = <List<String>>[];
    for (var d = 0; d < TomasController.diasHistorial; d++) {
      final dia = DateTime(hoy.year, hoy.month, hoy.day - d);
      final tomas = TomasDelDia.calcular(
        medicamentos: medicamentos,
        registros: registros,
        dia: dia,
        ahora: ahora,
      );
      final sueltos = TomasDelDia.registrosSueltos(
        tomas: tomas,
        registros: registros,
        dia: dia,
        medicamentos: medicamentos,
      ).length;
      if (tomas.isEmpty && sueltos == 0) continue;
      int contar(EstadoTomaDelDia estado) =>
          tomas.where((toma) => toma.estado == estado).length;
      final pendientes = contar(EstadoTomaDelDia.pendiente);
      final sinMarcar = [
        for (final toma in tomas)
          if (toma.estado == EstadoTomaDelDia.sinMarcar ||
              toma.estado == EstadoTomaDelDia.aplazada)
            t.informeTomaSinMarcar(toma.hora.texto, toma.medicamento.nombre),
      ];
      final tomadas = '${contar(EstadoTomaDelDia.tomada) + sueltos}';
      final total = '${tomas.length + sueltos}';
      filas.add([
        _dia(t, dia, d),
        pendientes == 0
            ? t.informeTomadas(tomadas, total)
            : t.informeTomadasConPendientes(tomadas, total, '$pendientes'),
        _resumir(t, sinMarcar),
      ]);
    }
    return filas;
  }

  /// La tabla de tomas (ver [filasTomas]) y, debajo, lo que se tomó de los
  /// medicamentos "cuando haga falta".
  static List<pw.Widget> _tomas(
    TextosApp t,
    List<Medicamento> medicamentos,
    List<RegistroToma> registros,
    DateTime ahora,
    pw.Font negrita,
  ) {
    final hoy = FormatoFechas.soloFecha(ahora);
    final filas = filasTomas(
      medicamentos: medicamentos,
      registros: registros,
      ahora: ahora,
    );
    final aDemanda = <String>[];
    for (var d = 0; d < TomasController.diasHistorial; d++) {
      final dia = DateTime(hoy.year, hoy.month, hoy.day - d);
      final cuandoHaceFalta = _resumirADemanda(
        t,
        TomasDelDia.tomasADemanda(
          medicamentos: medicamentos,
          registros: registros,
          dia: dia,
        ),
      );
      if (cuandoHaceFalta != null) {
        aDemanda.add(t.informeADemandaDia(_dia(t, dia, d), cuandoHaceFalta));
      }
    }
    final (:tomadas, :total) = TomasDelDia.resumen(
      medicamentos: medicamentos,
      registros: registros,
      ahora: ahora,
      dias: TomasController.diasHistorial,
    );
    final listaADemanda = [
      if (aDemanda.isNotEmpty) ...[
        pw.SizedBox(height: 10),
        pw.Text(t.informeADemanda, style: pw.TextStyle(font: negrita)),
        for (final linea in aDemanda)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 3),
            child: pw.Text(linea),
          ),
      ],
    ];
    if (filas.isEmpty) {
      return aDemanda.isEmpty
          ? [pw.Text(t.informeSinTomas)]
          : listaADemanda.sublist(1);
    }
    return [
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Text(
          t.informeResumenSemana(
            '$tomadas',
            '$total',
            '${TomasDelDia.porcentaje(tomadas, total)}',
          ),
        ),
      ),
      _tablaTomas(t, filas, negrita),
      ...listaADemanda,
    ];
  }

  /// "Paracetamol a las 08:10 y 14:30, Ibuprofeno a las 20:00", o `null` si
  /// no hay ninguna.
  static String? _resumirADemanda(TextosApp t, List<RegistroToma> tomas) {
    if (tomas.isEmpty) return null;
    final porMedicamento = <String, List<HoraDelDia>>{};
    for (final toma in tomas) {
      (porMedicamento[toma.nombreMedicamento] ??= []).add(toma.hora);
    }
    return FormatoFechas.lista([
      for (final MapEntry(key: nombre, value: horas) in porMedicamento.entries)
        t.informeADemandaTomas(nombre, FormatoFechas.listaDeHoras(horas)),
    ]);
  }

  static pw.Widget _tablaTomas(
    TextosApp t,
    List<List<String>> filas,
    pw.Font negrita,
  ) {
    return pw.TableHelper.fromTextArray(
      headers: [
        t.informeColumnaDia,
        t.informeColumnaTomadas,
        t.informeColumnaSinMarcar,
      ],
      data: filas,
      headerStyle: pw.TextStyle(font: negrita, fontSize: 13),
      cellStyle: const pw.TextStyle(fontSize: 12),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFB6D8FF),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.3),
        1: pw.FlexColumnWidth(1.3),
        2: pw.FlexColumnWidth(3),
      },
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  /// Como mucho [_maxSinMarcar] tomas por día y "y N más": así cada fila
  /// es corta y la tabla cabe en una página aunque haya muchas medicinas.
  static String _resumir(TextosApp t, List<String> sinMarcar) {
    if (sinMarcar.isEmpty) return '—';
    final separador = t.fechaSeparadorLista;
    if (sinMarcar.length <= _maxSinMarcar) return sinMarcar.join(separador);
    return t.informeYMas(
      sinMarcar.take(_maxSinMarcar).join(separador),
      '${sinMarcar.length - _maxSinMarcar}',
    );
  }

  static const int _maxSinMarcar = 6;

  static pw.Widget _cita(TextosApp t, Cita c, DateTime ahora, pw.Font negrita) {
    final lugar = (c.lugar ?? '').trim();
    final notas = (c.notas ?? '').trim();
    // Cada cita, entera en la misma página.
    return pw.Inseparable(
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              t.informeCitaCuando(
                FormatoFechas.fechaRelativa(c.fecha, ahora),
                c.hora.texto,
              ),
              style: pw.TextStyle(font: negrita),
            ),
            pw.Text(c.titulo),
            if (lugar.isNotEmpty) pw.Text(t.informeLugar(lugar)),
            if (notas.isNotEmpty) pw.Text(t.informeNotas(notas)),
          ],
        ),
      ),
    );
  }
}
