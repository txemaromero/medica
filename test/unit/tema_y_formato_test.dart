import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tema/contraste.dart';
import 'package:salud_mayores/core/tema/paleta.dart';
import 'package:salud_mayores/core/tiempo/formato_fechas.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';

void main() {
  group('Contraste WCAG', () {
    test('valores de referencia', () {
      expect(
        Contraste.ratio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
        closeTo(21, 0.01),
      );
      expect(
        Contraste.ratio(const Color(0xFF777777), const Color(0xFF777777)),
        closeTo(1, 0.001),
      );
    });

    test('el azul de la memoria (#B6D8FF) con negro supera 14:1', () {
      final ratio = Contraste.ratio(
        const Color(0xFFB6D8FF),
        const Color(0xFF000000),
      );
      expect(ratio, greaterThanOrEqualTo(14));
    });

    for (final tema in TemaApp.values) {
      test('${tema.nombre}: todos los textos cumplen AAA (≥ 7:1)', () {
        final p = Paleta.de(tema);
        final parejas = <String, (Color, Color)>{
          'texto sobre fondo': (p.texto, p.fondo),
          'texto de botón': (p.textoBoton, p.boton),
          'texto sobre rojo': (p.textoPeligro, p.peligro),
          'texto sobre verde': (p.textoExito, p.exito),
          'mensaje emergente': (p.avisoTexto, p.avisoFondo),
        };
        for (final MapEntry(key: nombre, value: (a, b)) in parejas.entries) {
          expect(
            Contraste.ratio(a, b),
            greaterThanOrEqualTo(Contraste.minimoAAA),
            reason: '${tema.nombre} – $nombre',
          );
        }
      });

      test(
        '${tema.nombre}: bordes, interruptores y marcas visibles (≥ 3:1)',
        () {
          final p = Paleta.de(tema);
          const blanco = Color(0xFFFFFFFF);
          final parejas = <String, (Color, Color)>{
            'borde de botones sobre fondo': (p.borde, p.fondo),
            'borde de botones sobre botón': (p.borde, p.boton),
            'selección sobre fondo': (p.seleccion, p.fondo),
            'selección sobre botón': (p.seleccion, p.boton),
            'marca de error sobre botón': (p.bordeError, p.boton),
            'marca de error sobre fondo': (p.bordeError, p.fondo),
            'mando del interruptor sobre rojo': (blanco, p.peligro),
            'mando del interruptor sobre verde': (blanco, p.exito),
          };
          for (final MapEntry(key: nombre, value: (a, b)) in parejas.entries) {
            expect(
              Contraste.ratio(a, b),
              greaterThanOrEqualTo(Contraste.minimoComponentes),
              reason: '${tema.nombre} – $nombre',
            );
          }
        },
      );
    }
  });

  group('FormatoFechas', () {
    final hoy = DateTime(2026, 10, 25, 9);

    test('fecha larga en castellano', () {
      expect(
        FormatoFechas.fechaLarga(DateTime(2026, 10, 25)),
        'domingo, 25 de octubre de 2026',
      );
    });

    test('hoy y mañana se indican expresamente', () {
      expect(
        FormatoFechas.fechaRelativa(DateTime(2026, 10, 25), hoy),
        'Hoy, domingo, 25 de octubre de 2026',
      );
      expect(
        FormatoFechas.fechaRelativa(DateTime(2026, 10, 26), hoy),
        'Mañana, lunes, 26 de octubre de 2026',
      );
      expect(
        FormatoFechas.fechaRelativa(DateTime(2026, 11, 3), hoy),
        'Martes, 3 de noviembre de 2026',
      );
    });

    test('parte del día', () {
      expect(
        FormatoFechas.horaConParteDelDia(const HoraDelDia(8, 30)),
        '08:30 de la mañana',
      );
      expect(
        FormatoFechas.parteDelDia(const HoraDelDia(13, 0)),
        'del mediodía',
      );
      expect(FormatoFechas.parteDelDia(const HoraDelDia(18, 0)), 'de la tarde');
      expect(FormatoFechas.parteDelDia(const HoraDelDia(23, 0)), 'de la noche');
      expect(
        FormatoFechas.parteDelDia(const HoraDelDia(3, 0)),
        'de la madrugada',
      );
    });

    test('lista de horas legible', () {
      expect(
        FormatoFechas.listaDeHoras(const [
          HoraDelDia(8, 0),
          HoraDelDia(16, 0),
          HoraDelDia(0, 0),
        ]),
        '08:00, 16:00 y 00:00',
      );
      expect(FormatoFechas.listaDeHoras(const [HoraDelDia(9, 0)]), '09:00');
    });

    test('ISO ida y vuelta', () {
      final fecha = DateTime(2027, 2, 3);
      expect(FormatoFechas.isoFecha(fecha), '2027-02-03');
      expect(FormatoFechas.desdeIsoFecha('2027-02-03'), fecha);
    });
  });
}
