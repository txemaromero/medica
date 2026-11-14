import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/core/tiempo/hora_del_dia.dart';
import 'package:salud_mayores/features/agenda/application/citas_controller.dart';
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/application/ajustes_controller.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/medicamentos/application/medicamentos_controller.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/application/tomas_controller.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';
import 'package:salud_mayores/notificaciones/carga_aviso.dart';
import 'package:salud_mayores/notificaciones/planificador_avisos.dart';
import 'package:salud_mayores/notificaciones/sincronizador_avisos.dart';

import '../helpers/app_de_prueba.dart';
import '../helpers/dobles.dart';

/// Comprueba, a través de los controladores, que los avisos del sistema se
/// mantienen al día: se programan al guardar, se cancelan al eliminar, dejan
/// de sonar al marcar la toma y respetan los interruptores de Ajustes.
void main() {
  late EntornoDePrueba entorno;
  late ProviderContainer contenedor;

  void crear({
    Ajustes ajustes = const Ajustes(notificacionesActivadas: true),
    ServicioNotificacionesFalso? servicio,
    DateTime? ahora,
  }) {
    entorno = EntornoDePrueba(
      ajustes: ajustes,
      notificaciones: servicio,
      ahora: ahora,
    );
    contenedor = ProviderContainer(overrides: entorno.overrides);
    addTearDown(contenedor.dispose);
  }

  /// Los controladores no esperan a la sincronización de los avisos: antes de
  /// mirarlos hay que esperar a que termine.
  Future<ServicioNotificacionesFalso> avisos() async {
    await contenedor.read(sincronizadorAvisosProvider).esperar();
    return entorno.notificaciones;
  }

  const omeprazol = NuevoMedicamento(
    nombre: 'Omeprazol',
    numTomas: 2,
    frecuenciaHoras: 12,
    horaInicio: HoraDelDia(9, 0),
  );

  test('al guardar un medicamento se programan sus tomas y sus '
      'repeticiones', () async {
    crear();
    await contenedor.read(medicamentosProvider.future);
    final m = await contenedor
        .read(medicamentosProvider.notifier)
        .crear(omeprazol);

    expect((await avisos()).idsDeTipo(TipoAviso.toma), {
      PlanificadorAvisos.idToma(m.id, 0),
      PlanificadorAvisos.idToma(m.id, 1),
    });
    // Las repeticiones de hoy (09:30 y 21:30) y de los días siguientes.
    final hoy = DateTime(2026, 10, 25);
    expect(
      (await avisos()).idsDeTipo(TipoAviso.repeticion),
      containsAll({
        PlanificadorAvisos.idRepeticionConFecha(m.id, hoy, 0),
        PlanificadorAvisos.idRepeticionConFecha(m.id, hoy, 1),
      }),
    );
  });

  test('al eliminar un medicamento se cancelan sus avisos y al deshacer '
      'vuelven', () async {
    crear();
    await contenedor.read(medicamentosProvider.future);
    final controlador = contenedor.read(medicamentosProvider.notifier);
    final m = await controlador.crear(omeprazol);
    final otro = await controlador.crear(
      const NuevoMedicamento(
        nombre: 'Aspirina',
        numTomas: 1,
        frecuenciaHoras: 24,
        horaInicio: HoraDelDia(14, 0),
      ),
    );

    await controlador.eliminar(m);
    expect((await avisos()).idsDeTipo(TipoAviso.toma), {
      PlanificadorAvisos.idToma(otro.id, 0),
    });
    // Las repeticiones que quedan son todas del otro medicamento.
    expect(
      entorno.notificaciones
          .deTipo(TipoAviso.repeticion)
          .map(
            (a) =>
                (CargaAviso.decodificar(a.carga)! as CargaToma).medicamentoId,
          )
          .toSet(),
      {otro.id},
    );

    await controlador.restaurar(m);
    expect((await avisos()).deTipo(TipoAviso.toma), hasLength(3));
  });

  test(
    'las citas programan sus recordatorios y se cancelan al eliminar',
    () async {
      crear();
      await contenedor.read(citasProvider.future);
      final controlador = contenedor.read(citasProvider.notifier);
      final cita = await controlador.crear(
        NuevaCita(
          titulo: 'Dentista',
          fecha: DateTime(2026, 10, 27),
          hora: const HoraDelDia(12, 0),
        ),
      );
      // La tarde antes, ese día por la mañana y una hora antes.
      expect((await avisos()).programados, hasLength(3));

      await controlador.eliminar(cita);
      expect((await avisos()).programados, isEmpty);
    },
  );

  test('al modificar un medicamento se reprograman sus tomas', () async {
    crear();
    await contenedor.read(medicamentosProvider.future);
    final controlador = contenedor.read(medicamentosProvider.notifier);
    final m = await controlador.crear(omeprazol);

    await controlador.actualizar(
      m.conDatos(
        const NuevoMedicamento(
          nombre: 'Omeprazol',
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: HoraDelDia(20, 0),
        ),
      ),
    );
    final tomas = (await avisos()).deTipo(TipoAviso.toma);
    expect(tomas.map((a) => a.id), [PlanificadorAvisos.idToma(m.id, 0)]);
    expect(tomas.single.momento, const CadaDia(HoraDelDia(20, 0)));
  });

  test('al modificar una cita se mueven sus recordatorios', () async {
    crear();
    await contenedor.read(citasProvider.future);
    final controlador = contenedor.read(citasProvider.notifier);
    final cita = await controlador.crear(
      NuevaCita(
        titulo: 'Dentista',
        fecha: DateTime(2026, 10, 27),
        hora: const HoraDelDia(12, 0),
      ),
    );
    await controlador.actualizar(
      cita.conDatos(
        NuevaCita(
          titulo: 'Dentista',
          fecha: DateTime(2026, 10, 28),
          hora: const HoraDelDia(12, 0),
        ),
      ),
    );
    expect(
      (await avisos()).programados.map((a) => a.momento),
      contains(UnaVez(DateTime(2026, 10, 28, 11, 0))),
    );
    expect(
      (await avisos()).programados.map((a) => a.momento),
      isNot(contains(UnaVez(DateTime(2026, 10, 27, 11, 0)))),
    );
  });

  test('con las notificaciones desactivadas no se programa nada', () async {
    crear(ajustes: const Ajustes());
    await contenedor.read(medicamentosProvider.future);
    await contenedor.read(medicamentosProvider.notifier).crear(omeprazol);
    expect((await avisos()).programados, isEmpty);
  });

  test('desactivar las notificaciones cancela los avisos y activarlas los '
      'vuelve a programar', () async {
    crear();
    await contenedor.read(medicamentosProvider.future);
    await contenedor.read(medicamentosProvider.notifier).crear(omeprazol);
    final ajustes = contenedor.read(ajustesProvider.notifier);

    expect(
      await ajustes.cambiarNotificaciones(false),
      ResultadoNotificaciones.desactivadas,
    );
    expect((await avisos()).programados, isEmpty);

    expect(
      await ajustes.cambiarNotificaciones(true),
      ResultadoNotificaciones.activadas,
    );
    expect((await avisos()).deTipo(TipoAviso.toma), hasLength(2));
    expect(entorno.ajustes.ajustes.notificacionesActivadas, isTrue);
  });

  test(
    'si el teléfono no da permiso, las notificaciones siguen apagadas',
    () async {
      crear(
        ajustes: const Ajustes(),
        servicio: ServicioNotificacionesFalso(permiso: false),
      );
      final resultado = await contenedor
          .read(ajustesProvider.notifier)
          .cambiarNotificaciones(true);
      expect(resultado, ResultadoNotificaciones.permisoDenegado);
      expect(contenedor.read(ajustesProvider).notificacionesActivadas, isFalse);
      expect((await avisos()).solicitudesPermiso, 1);
    },
  );

  test('avisa si faltan las alarmas exactas', () async {
    crear(
      ajustes: const Ajustes(),
      servicio: ServicioNotificacionesFalso(alarmasExactas: false),
    );
    final resultado = await contenedor
        .read(ajustesProvider.notifier)
        .cambiarNotificaciones(true);
    expect(resultado, ResultadoNotificaciones.activadasSinHoraExacta);
    expect(contenedor.read(ajustesProvider).notificacionesActivadas, isTrue);
  });

  test('sonido y vibración eligen el canal de los avisos', () async {
    crear();
    await contenedor.read(medicamentosProvider.future);
    await contenedor.read(medicamentosProvider.notifier).crear(omeprazol);
    expect(
      (await avisos()).canal,
      const CanalAvisos(sonido: false, vibracion: false),
    );

    final ajustes = contenedor.read(ajustesProvider.notifier);
    await ajustes.cambiarSonido(true);
    expect(
      (await avisos()).canal,
      const CanalAvisos(sonido: true, vibracion: false),
    );
    await ajustes.cambiarVibracion(true);
    expect(
      (await avisos()).canal,
      const CanalAvisos(sonido: true, vibracion: true),
    );
    // Al cambiar de canal se reprograman las mismas tomas.
    expect((await avisos()).deTipo(TipoAviso.toma), hasLength(2));
  });

  group('marcar y aplazar tomas', () {
    // Las 9:10: acaba de pasar la toma de las 9:00.
    final ahora = DateTime(2026, 10, 25, 9, 10);
    final hoy = DateTime(2026, 10, 25);
    final manana = DateTime(2026, 10, 26);
    const nueve = HoraDelDia(9, 0);

    Future<Medicamento> preparar() async {
      crear(ahora: ahora);
      await contenedor.read(medicamentosProvider.future);
      await contenedor.read(tomasProvider.future);
      return contenedor.read(medicamentosProvider.notifier).crear(omeprazol);
    }

    Future<MomentoAviso?> momento(int id) async => (await avisos()).programados
        .where((a) => a.id == id)
        .firstOrNull
        ?.momento;

    test('marcar la toma de hoy quita su repetición de hoy', () async {
      final m = await preparar();
      final repeticionDeHoy = PlanificadorAvisos.idRepeticionConFecha(
        m.id,
        hoy,
        0,
      );
      expect(
        await momento(repeticionDeHoy),
        UnaVez(DateTime(2026, 10, 25, 9, 30)),
      );

      await contenedor.read(tomasProvider.notifier).marcarTomada(m, hoy, nueve);

      expect(await momento(repeticionDeHoy), isNull);
      // La de mañana y el aviso diario de la toma siguen.
      expect(
        await momento(PlanificadorAvisos.idRepeticionConFecha(m.id, manana, 0)),
        UnaVez(DateTime(2026, 10, 26, 9, 30)),
      );
      expect(
        await momento(PlanificadorAvisos.idToma(m.id, 0)),
        const CadaDia(nueve),
      );
      expect(entorno.tomas.registros.single.estado, EstadoToma.tomada);
    });

    test(
      'marcar por adelantado (antes de su hora) evita el aviso de hoy',
      () async {
        final m = await preparar();
        const nueveDeLaNoche = HoraDelDia(21, 0);
        expect(
          await momento(PlanificadorAvisos.idToma(m.id, 1)),
          const CadaDia(nueveDeLaNoche),
        );

        await contenedor
            .read(tomasProvider.notifier)
            .marcarTomada(m, hoy, nueveDeLaNoche);

        // El aviso diario se cambia por avisos únicos desde mañana.
        expect(await momento(PlanificadorAvisos.idToma(m.id, 1)), isNull);
        expect(
          await momento(PlanificadorAvisos.idTomaConFecha(m.id, manana, 1)),
          UnaVez(DateTime(2026, 10, 26, 21)),
        );
        expect(
          await momento(PlanificadorAvisos.idTomaConFecha(m.id, hoy, 1)),
          isNull,
        );
        expect(
          await momento(PlanificadorAvisos.idRepeticionConFecha(m.id, hoy, 1)),
          isNull,
        );
      },
    );

    test('aplazar programa el recordatorio en lugar de la repetición, y '
        'marcarla después lo quita', () async {
      final m = await preparar();
      final controlador = contenedor.read(tomasProvider.notifier);

      final cuando = await controlador.aplazar(m, hoy, nueve);
      expect(cuando, DateTime(2026, 10, 25, 9, 20));
      final idAplazado = PlanificadorAvisos.idAplazado(m.id, 0);
      expect(await momento(idAplazado), UnaVez(cuando));
      expect(
        await momento(PlanificadorAvisos.idRepeticionConFecha(m.id, hoy, 0)),
        isNull,
      );

      await controlador.marcarTomada(m, hoy, nueve);
      expect(await momento(idAplazado), isNull);
      expect(entorno.tomas.registros.single.estado, EstadoToma.tomada);
    });

    test('desmarcar (o deshacer) devuelve los avisos de hoy', () async {
      final m = await preparar();
      final controlador = contenedor.read(tomasProvider.notifier);
      final anterior = await controlador.marcarTomada(m, hoy, nueve);
      expect(anterior, isNull);

      await controlador.restaurar(
        medicamentoId: m.id,
        fecha: hoy,
        hora: nueve,
        registro: anterior,
      );
      expect(entorno.tomas.registros, isEmpty);
      expect(
        await momento(PlanificadorAvisos.idRepeticionConFecha(m.id, hoy, 0)),
        UnaVez(DateTime(2026, 10, 25, 9, 30)),
      );
    });
  });
}
