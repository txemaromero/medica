import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/medicamentos/data/borrador_repository.dart';
import 'package:salud_mayores/features/medicamentos/domain/borrador_medicamento.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final borrador = BorradorMedicamento(
    medicamentoId: 7,
    nombre: 'Omeprazol',
    dosis: '1 cápsula',
    instrucciones: 'con el desayuno',
    numTomas: 2,
    frecuenciaHoras: 12,
    horaInicio: const HoraDelDia(9, 30),
    conFechaFin: true,
    fechaFin: DateTime(2026, 11, 1),
    foto: 'caja_1.jpg',
    aDemanda: true,
    llevarCuenta: true,
    existencias: '28,5',
    porToma: 1.5,
    porTomas: const [1, 0.5],
    dosisDistinta: true,
    dosisTomas: const ['1 pastilla', 'media pastilla'],
    maximoAlDia: 3,
    horasEntreTomas: 6,
    conReceta: true,
    receta: DateTime(2026, 12, 1),
  );

  Future<BorradorRepositoryPreferencias> repositorio([
    Map<String, Object> iniciales = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(iniciales);
    return BorradorRepositoryPreferencias(
      await SharedPreferences.getInstance(),
    );
  }

  test('se guarda, se lee igual y se borra', () async {
    final borradores = await repositorio();
    expect(borradores.leer(), isNull);

    await borradores.guardar(borrador);
    expect(borradores.leer()?.toJson(), borrador.toJson());

    await borradores.borrar();
    expect(borradores.leer(), isNull);
  });

  test('un borrador roto o con otro formato no se recupera', () async {
    for (final roto in ['no es JSON', '{"nombre": 3}', '[1, 2]']) {
      final borradores = await repositorio({
        BorradorRepositoryPreferencias.clave: roto,
      });
      expect(borradores.leer(), isNull, reason: roto);
    }
  });
}
