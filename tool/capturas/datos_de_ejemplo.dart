// Datos de ejemplo que comparten los generadores de imágenes: capturas del
// README, PDF de ejemplo y recursos de Google Play.
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/domain/existencias.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';

import '../../test/helpers/app_de_prueba.dart';
import '../../test/helpers/dobles.dart';

/// Lo que escribiría la persona en cada idioma (los nombres de los
/// medicamentos son los de las cajas, que en España vienen en castellano).
typedef TextosDeEjemplo = ({
  String viaOral,
  String contenidoCaja,
  String dosisCapsula,
  String conComida,
  String dosisPastilla,
  String dosisComprimido,
  String siHayDolor,
  String medicoDeCabecera,
  String centroDeSalud,
  String analisis,
  String enAyunas,
  String familiar,
});

const Map<String, TextosDeEjemplo> textosDeEjemplo = {
  'es': (
    viaOral: 'Vía oral',
    contenidoCaja: '20 mg · 28 cápsulas',
    dosisCapsula: '1 cápsula',
    conComida: 'Con comida',
    dosisPastilla: '1 pastilla',
    dosisComprimido: '1 comprimido de 1 g',
    siHayDolor: 'Si hay dolor o fiebre',
    medicoDeCabecera: 'Médico de cabecera',
    centroDeSalud: 'Centro de salud',
    analisis: 'Análisis de sangre',
    enAyunas: 'Ir en ayunas.',
    familiar: 'Mi hija Ana',
  ),
  'ca': (
    viaOral: 'Via oral',
    contenidoCaja: '20 mg · 28 càpsules',
    dosisCapsula: '1 càpsula',
    conComida: 'Amb menjar',
    dosisPastilla: '1 pastilla',
    dosisComprimido: "1 comprimit d'1 g",
    siHayDolor: 'Si hi ha dolor o febre',
    medicoDeCabecera: 'Metge de capçalera',
    centroDeSalud: 'Centre de salut',
    analisis: 'Anàlisi de sang',
    enAyunas: 'Anar-hi en dejú.',
    familiar: 'La meva filla Anna',
  ),
  'gl': (
    viaOral: 'Vía oral',
    contenidoCaja: '20 mg · 28 cápsulas',
    dosisCapsula: '1 cápsula',
    conComida: 'Con comida',
    dosisPastilla: '1 pastilla',
    dosisComprimido: '1 comprimido de 1 g',
    siHayDolor: 'Se hai dor ou febre',
    medicoDeCabecera: 'Médico de cabeceira',
    centroDeSalud: 'Centro de saúde',
    analisis: 'Análise de sangue',
    enAyunas: 'Ir en xaxún.',
    familiar: 'A miña filla Ana',
  ),
  'eu': (
    viaOral: 'Ahotik',
    contenidoCaja: '20 mg · 28 kapsula',
    dosisCapsula: 'kapsula 1',
    conComida: 'Janariarekin',
    dosisPastilla: 'pilula 1',
    dosisComprimido: 'konprimitu 1 (1 g)',
    siHayDolor: 'Mina edo sukarra badago',
    medicoDeCabecera: 'Familia-medikua',
    centroDeSalud: 'Osasun-zentroa',
    analisis: 'Odol-analisia',
    enAyunas: 'Barauik joan.',
    familiar: 'Nire alaba Ana',
  ),
};

/// Foto de ejemplo de una caja de medicamento (dibujada, no fotografiada),
/// con los textos en [idioma].
Future<Uint8List> dibujarCajaDeEjemplo({String idioma = 'es'}) async {
  final textos = textosDeEjemplo[idioma]!;
  const ancho = 640.0;
  const alto = 440.0;
  final grabador = ui.PictureRecorder();
  final lienzo = Canvas(grabador);
  lienzo.drawRect(
    const Rect.fromLTWH(0, 0, ancho, alto),
    Paint()..color = const Color(0xFFE8E2D6),
  );
  final caja = RRect.fromRectAndRadius(
    const Rect.fromLTWH(60, 70, 520, 300),
    const Radius.circular(10),
  );
  lienzo
    ..drawRRect(
      caja.shift(const Offset(8, 10)),
      Paint()..color = const Color(0x33000000),
    )
    ..drawRRect(caja, Paint()..color = Colors.white)
    ..save()
    ..clipRRect(caja)
    ..drawRect(
      const Rect.fromLTWH(60, 70, 520, 70),
      Paint()..color = const Color(0xFF1E6FB8),
    )
    ..drawRect(
      const Rect.fromLTWH(60, 330, 520, 40),
      Paint()..color = const Color(0xFFF2A900),
    )
    ..restore();
  void escribir(
    String texto,
    Offset posicion,
    double tamano,
    FontWeight peso,
    Color color,
  ) {
    (TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: tamano,
          fontWeight: peso,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout()).paint(lienzo, posicion);
  }

  escribir(
    textos.viaOral,
    const Offset(90, 88),
    28,
    FontWeight.w600,
    Colors.white,
  );
  escribir(
    'Omeprazol',
    const Offset(90, 165),
    66,
    FontWeight.w800,
    const Color(0xFF14365D),
  );
  escribir(
    textos.contenidoCaja,
    const Offset(92, 255),
    30,
    FontWeight.w500,
    const Color(0xFF333333),
  );
  final imagen = await grabador.endRecording().toImage(
    ancho.toInt(),
    alto.toInt(),
  );
  final datos = await imagen.toByteData(format: ui.ImageByteFormat.png);
  return datos!.buffer.asUint8List();
}

RegistroToma tomada(
  int id,
  String nombre,
  int dia,
  HoraDelDia hora,
  HoraDelDia aLas,
) => RegistroToma(
  medicamentoId: id,
  nombreMedicamento: nombre,
  fecha: DateTime(2026, 10, dia),
  hora: hora,
  estado: EstadoToma.tomada,
  momento: DateTime(2026, 10, dia, aLas.hora, aLas.minuto),
);

/// Entorno de la app con los datos de ejemplo: tres medicamentos (uno con la
/// foto de la caja [caja] y la cuenta de las pastillas, y otro "cuando haga
/// falta"), dos citas, tomas de los tres últimos días y un familiar como
/// segundo contacto. Lo escrito, en [idioma] (ver [textosDeEjemplo]).
EntornoDePrueba entornoDeEjemplo({
  required Uint8List caja,
  Ajustes ajustes = const Ajustes(),
  DateTime? ahora,
  bool asistenteCompletado = true,
  String idioma = 'es',
}) => _entorno(
  textosDeEjemplo[idioma]!,
  caja: caja,
  ajustes: ajustes,
  ahora: ahora,
  asistenteCompletado: asistenteCompletado,
);

EntornoDePrueba _entorno(
  TextosDeEjemplo textos, {
  required Uint8List caja,
  required Ajustes ajustes,
  required DateTime? ahora,
  required bool asistenteCompletado,
}) => EntornoDePrueba(
  ahora: ahora,
  asistenteCompletado: asistenteCompletado,
  fotos: AlmacenFotosEnMemoria({'caja_omeprazol.png': caja}),
  ajustes: ajustes.copyWith(
    numeroEmergencia: '112',
    familiarNombre: textos.familiar,
    familiarNumero: '600123456',
  ),
  medicamentos: [
    Medicamento(
      id: 1,
      nombre: 'Amoxicilina',
      numTomas: 3,
      frecuenciaHoras: 8,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      dosis: textos.dosisCapsula,
      instrucciones: textos.conComida,
      fechaFin: DateTime(2026, 11, 1),
    ),
    Medicamento(
      id: 2,
      nombre: 'Omeprazol',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(9, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      dosis: textos.dosisPastilla,
      foto: 'caja_omeprazol.png',
      // Contadas el martes por la mañana: el domingo quedan 15.
      existencias: Existencias(
        cantidad: 20,
        contadas: DateTime(2026, 10, 20, 10, 0),
      ),
    ),
    Medicamento(
      id: 3,
      nombre: 'Paracetamol',
      numTomas: 1,
      frecuenciaHoras: 24,
      horaInicio: const HoraDelDia(8, 0),
      fechaCreacion: DateTime(2026, 10, 1),
      dosis: textos.dosisComprimido,
      instrucciones: textos.siHayDolor,
      aDemanda: true,
    ),
  ],
  citas: [
    Cita(
      id: 1,
      titulo: textos.medicoDeCabecera,
      fecha: DateTime(2026, 10, 27),
      hora: const HoraDelDia(10, 30),
      lugar: textos.centroDeSalud,
    ),
    Cita(
      id: 2,
      titulo: textos.analisis,
      fecha: DateTime(2026, 11, 3),
      hora: const HoraDelDia(8, 15),
      notas: textos.enAyunas,
    ),
  ],
  tomas: [
    // Hoy, a las 12:30: dos tomadas, una sin marcar y otra pendiente.
    tomada(
      1,
      'Amoxicilina',
      25,
      const HoraDelDia(0, 0),
      const HoraDelDia(0, 10),
    ),
    tomada(
      1,
      'Amoxicilina',
      25,
      const HoraDelDia(8, 0),
      const HoraDelDia(8, 5),
    ),
    // El Paracetamol, hoy a media mañana y ayer por la tarde.
    tomada(
      3,
      'Paracetamol',
      25,
      const HoraDelDia(11, 40),
      const HoraDelDia(11, 40),
    ),
    tomada(
      3,
      'Paracetamol',
      24,
      const HoraDelDia(19, 5),
      const HoraDelDia(19, 5),
    ),
    // Ayer, todas; anteayer, todas menos el Omeprazol.
    tomada(
      1,
      'Amoxicilina',
      24,
      const HoraDelDia(0, 0),
      const HoraDelDia(0, 5),
    ),
    tomada(
      1,
      'Amoxicilina',
      24,
      const HoraDelDia(8, 0),
      const HoraDelDia(8, 10),
    ),
    tomada(2, 'Omeprazol', 24, const HoraDelDia(9, 0), const HoraDelDia(9, 15)),
    tomada(
      1,
      'Amoxicilina',
      24,
      const HoraDelDia(16, 0),
      const HoraDelDia(16, 20),
    ),
    tomada(
      1,
      'Amoxicilina',
      23,
      const HoraDelDia(0, 0),
      const HoraDelDia(0, 15),
    ),
    tomada(
      1,
      'Amoxicilina',
      23,
      const HoraDelDia(8, 0),
      const HoraDelDia(8, 0),
    ),
    tomada(
      1,
      'Amoxicilina',
      23,
      const HoraDelDia(16, 0),
      const HoraDelDia(16, 5),
    ),
  ],
);

/// Mediodía del día de las capturas, para que "Tomas de hoy" tenga de todo.
final DateTime mediodia = DateTime(2026, 10, 25, 12, 30);
