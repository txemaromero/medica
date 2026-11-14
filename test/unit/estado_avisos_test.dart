import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/features/ajustes/domain/estado_avisos.dart';

void main() {
  EstadoAvisos conBateria(EstadoBateria bateria) =>
      EstadoAvisos(activados: true, bateria: bateria);

  test('con los avisos desactivados no hay nada que comprobar', () {
    const estado = EstadoAvisos(
      activados: false,
      permiso: false,
      horaExacta: false,
      bateria: EstadoBateria(restringida: true),
    );
    expect(estado.problemas, isEmpty);
  });

  test('los problemas van de más a menos grave', () {
    const estado = EstadoAvisos(
      activados: true,
      permiso: false,
      horaExacta: false,
      bateria: EstadoBateria(restringida: true),
    );
    expect(estado.problemas, [
      ProblemaAvisos.sinPermiso,
      ProblemaAvisos.sinHoraExacta,
      ProblemaAvisos.ahorroBateria,
    ]);
  });

  test('la optimización normal de Android solo cuenta en los fabricantes '
      'que cierran apps', () {
    for (final fabricante in ['google', 'motorola', '']) {
      expect(
        conBateria(EstadoBateria(optimizada: true, fabricante: fabricante))
            .problemas,
        isEmpty,
        reason: fabricante,
      );
    }
    for (final fabricante in ['samsung', 'xiaomi', 'huawei', 'oppo']) {
      expect(
        conBateria(EstadoBateria(optimizada: true, fabricante: fabricante))
            .problemas,
        [ProblemaAvisos.ahorroBateria],
        reason: fabricante,
      );
    }
  });

  test('sin optimización, un Samsung no tiene problema', () {
    expect(
      conBateria(const EstadoBateria(fabricante: 'samsung')).problemas,
      isEmpty,
    );
  });

  test('una app restringida en segundo plano cuenta en cualquier teléfono', () {
    expect(
      conBateria(const EstadoBateria(restringida: true, fabricante: 'google'))
          .problemas,
      [ProblemaAvisos.ahorroBateria],
    );
  });
}
