import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/widget_inicio/datos_widget.dart';

void main() {
  // Domingo, 25 de octubre de 2026, a las 9:00.
  final ahora = DateTime(2026, 10, 25, 9, 0);
  final metformina = Medicamento(
    id: 1,
    nombre: 'Metformina',
    numTomas: 2,
    frecuenciaHoras: 12,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
  );
  final calmante = Medicamento(
    id: 2,
    nombre: 'Ibuprofeno',
    numTomas: 1,
    frecuenciaHoras: 24,
    horaInicio: const HoraDelDia(8, 0),
    fechaCreacion: DateTime(2026, 10, 1),
    aDemanda: true,
  );

  test('las tomas de los próximos 7 días, con los textos preparados', () {
    final datos = DatosWidget.calcular(
      medicamentos: [metformina, calmante],
      registros: [
        RegistroToma(
          medicamentoId: 1,
          nombreMedicamento: 'Metformina',
          fecha: DateTime(2026, 10, 25),
          hora: const HoraDelDia(8, 0),
          estado: EstadoToma.tomada,
          momento: DateTime(2026, 10, 25, 8, 5),
        ),
      ],
      ahora: ahora,
    );
    expect(datos['titulo'], 'Próxima toma');
    expect(datos['boton'], 'Ya la he tomado');
    expect(datos['vacio'], 'No hay más tomas previstas.');

    final tomas = (datos['tomas']! as List<Object?>)
        .cast<Map<String, Object?>>();
    // Dos al día durante 7 días; el de "cuando haga falta" no sale.
    expect(tomas, hasLength(14));
    expect(tomas.map((t) => t['nombre']).toSet(), {'Metformina'});
    expect(tomas.first['tomada'], isTrue);

    final noche = tomas[1];
    expect(noche['momento'], DateTime(2026, 10, 25, 20).millisecondsSinceEpoch);
    expect(noche['fecha'], '2026-10-25');
    expect(noche['tomada'], isFalse);
    expect(noche['pasada'], 'Sin marcar. Era a las 20:00.');
    expect(noche['hoy'], 'Hoy a las 20:00');
    expect(noche['manana'], 'Mañana a las 20:00');
    expect(noche['otroDia'], 'El domingo, 25 de octubre, a las 20:00');
    expect(noche['semantica'], 'Ya he tomado Metformina de las 20:00');
    expect(
      CargaAviso.decodificar(noche['carga']! as String),
      CargaToma(
        medicamentoId: 1,
        hora: const HoraDelDia(20, 0),
        fecha: DateTime(2026, 10, 25),
      ),
    );
  });

  test('la carga de una toma con fecha va y vuelve; sin fecha, como antes', () {
    final conFecha = CargaToma(
      medicamentoId: 3,
      hora: const HoraDelDia(9, 30),
      fecha: DateTime(2026, 10, 26),
    );
    expect(conFecha.codificar(), 'toma|3|570|2026-10-26');
    expect(CargaAviso.decodificar(conFecha.codificar()), conFecha);
    const sinFecha = CargaToma(medicamentoId: 3, hora: HoraDelDia(9, 30));
    expect(sinFecha.codificar(), 'toma|3|570');
    expect(CargaAviso.decodificar('toma|3|570'), sinFecha);
  });
}
