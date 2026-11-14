import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/ajustes/domain/tamano_texto.dart';

void main() {
  group('TamanoTexto', () {
    test('base 20, mínimo 10, máximo 35, pasos de 5', () {
      expect(TamanoTexto.base, 20);
      expect(TamanoTexto.minimo, 10);
      expect(TamanoTexto.maximo, 35);
      expect(TamanoTexto.paso, 5);
      expect(const Ajustes().tamanoTexto, 20);
    });

    test('aumentar sube de 5 en 5 hasta 35 y no pasa de ahí', () {
      final recorrido = <int>[];
      var tamano = TamanoTexto.base;
      for (var i = 0; i < 6; i++) {
        tamano = TamanoTexto.aumentar(tamano);
        recorrido.add(tamano);
      }
      expect(recorrido, [25, 30, 35, 35, 35, 35]);
      expect(TamanoTexto.puedeAumentar(35), isFalse);
      expect(TamanoTexto.puedeAumentar(30), isTrue);
    });

    test('reducir baja de 5 en 5 hasta 10 y no baja de ahí', () {
      final recorrido = <int>[];
      var tamano = TamanoTexto.base;
      for (var i = 0; i < 4; i++) {
        tamano = TamanoTexto.reducir(tamano);
        recorrido.add(tamano);
      }
      expect(recorrido, [15, 10, 10, 10]);
      expect(TamanoTexto.puedeReducir(10), isFalse);
      expect(TamanoTexto.puedeReducir(15), isTrue);
    });

    test('normalizar ajusta cualquier valor al permitido más cercano', () {
      expect(TamanoTexto.normalizar(0), 10);
      expect(TamanoTexto.normalizar(99), 35);
      expect(TamanoTexto.normalizar(22), 20);
      expect(TamanoTexto.normalizar(23), 25);
      for (final valor in TamanoTexto.valoresPermitidos) {
        expect(TamanoTexto.normalizar(valor), valor);
      }
    });

    test('factor de escala relativo a la base', () {
      expect(TamanoTexto.factorEscala(20), 1.0);
      expect(TamanoTexto.factorEscala(10), 0.5);
      expect(TamanoTexto.factorEscala(35), 1.75);
    });
  });

  group('Ajustes por defecto', () {
    test('sonido, vibración y notificaciones desactivados; tema y número', () {
      const ajustes = Ajustes();
      expect(ajustes.sonidoActivado, isFalse);
      expect(ajustes.vibracionActivada, isFalse);
      expect(ajustes.notificacionesActivadas, isFalse);
      expect(ajustes.numeroEmergencia, isEmpty);
      expect(ajustes.tema, TemaApp.predeterminado);
    });
  });
}
