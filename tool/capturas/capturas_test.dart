// Genera las capturas de pantalla del README (docs/capturas/*.png).
//
// No forma parte de la batería de tests normal. Para regenerarlas:
//   flutter test tool/capturas/capturas_test.dart --update-goldens
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/app/rutas.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/compartir/application/servicio_compartir.dart';
import 'package:salud_mayores/features/medicamentos/application/medicamentos_controller.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';

import '../../test/helpers/app_de_prueba.dart';
import '../fuentes_reales.dart';
import 'datos_de_ejemplo.dart';

void main() {
  late Uint8List cajaOmeprazol;
  setUpAll(() async {
    await cargarFuentesReales();
    cajaOmeprazol = await dibujarCajaDeEjemplo();
  });

  Future<void> abrir(
    WidgetTester tester,
    String ruta, {
    Ajustes ajustes = const Ajustes(),
    DateTime? ahora,
    bool asistenteCompletado = true,
  }) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(393, 852) * 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      entornoDeEjemplo(
        caja: cajaOmeprazol,
        ajustes: ajustes,
        ahora: ahora,
        asistenteCompletado: asistenteCompletado,
      ).app,
    );
    await tester.pumpAndSettle();
    if (ruta != Rutas.menuPrincipal) {
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed(ruta);
      await tester.pumpAndSettle();
    }
  }

  /// Las imágenes se decodifican de verdad (fuera del reloj simulado de los
  /// tests) antes de hacer la captura.
  Future<void> foto(WidgetTester tester, String nombre) async {
    await tester.runAsync(
      () => precacheImage(
        MemoryImage(cajaOmeprazol),
        tester.element(find.byType(Navigator)),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/capturas/$nombre.png'),
    );
  }

  Future<void> capturar(
    WidgetTester tester,
    String nombre,
    String ruta, {
    Ajustes ajustes = const Ajustes(),
    DateTime? ahora,
  }) async {
    await abrir(tester, ruta, ajustes: ajustes, ahora: ahora);
    await foto(tester, nombre);
  }

  /// Cambia el medicamento llamado [nombre] de los datos de ejemplo (para
  /// enseñar algo que los demás no tienen, sin cambiar las otras capturas).
  Future<void> cambiar(
    WidgetTester tester,
    String nombre,
    Medicamento Function(Medicamento) cambio,
  ) async {
    final controlador = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    ).read(medicamentosProvider.notifier);
    final medicamentos = await tester.runAsync(
      () =>
          ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
              .read(medicamentosProvider.future),
    );
    final m = medicamentos!.firstWhere((m) => m.nombre == nombre);
    await tester.runAsync(() => controlador.actualizar(cambio(m)));
    await tester.pumpAndSettle();
  }

  const capturas = {
    '01_menu_principal': Rutas.menuPrincipal,
    '02_registro_medicamentos': Rutas.medicamentos,
    '03_nuevo_medicamento': Rutas.nuevoMedicamento,
    '04_medicamentos_registrados': Rutas.listaMedicamentos,
    '05_agenda': Rutas.agenda,
    '06_crear_cita': Rutas.nuevaCita,
    '07_emergencias': Rutas.emergencias,
    '08_ajustes': Rutas.ajustes,
    '09_tamano_texto': Rutas.tamanoTexto,
    '10_tema': Rutas.tema,
    '21_compartir': Rutas.compartir,
    '27_repetir_avisos': Rutas.repetirAvisos,
  };
  for (final MapEntry(key: nombre, value: ruta) in capturas.entries) {
    testWidgets(nombre, (tester) => capturar(tester, nombre, ruta));
  }

  testWidgets(
    '11_menu_tema_oscuro',
    (tester) => capturar(
      tester,
      '11_menu_tema_oscuro',
      Rutas.menuPrincipal,
      ajustes: const Ajustes(tema: TemaApp.oscuro),
    ),
  );
  testWidgets(
    '12_menu_tema_alternativo',
    (tester) => capturar(
      tester,
      '12_menu_tema_alternativo',
      Rutas.menuPrincipal,
      ajustes: const Ajustes(tema: TemaApp.alternativo),
    ),
  );
  testWidgets(
    '13_agenda_texto_35',
    (tester) => capturar(
      tester,
      '13_agenda_texto_35',
      Rutas.agenda,
      ajustes: const Ajustes(tamanoTexto: 35),
    ),
  );

  testWidgets('14_confirmar_eliminar', (tester) async {
    await abrir(tester, Rutas.listaMedicamentos);
    await pulsarTexto(tester, 'Eliminar');
    await foto(tester, '14_confirmar_eliminar');
  });

  testWidgets('15_modificar_medicamento', (tester) async {
    await abrir(tester, Rutas.listaMedicamentos);
    await pulsarTexto(tester, 'Modificar');
    // Se desplaza hasta la duración del tratamiento, la parte nueva.
    await tester.ensureVisible(find.text('Duración del tratamiento'));
    await tester.pumpAndSettle();
    await foto(tester, '15_modificar_medicamento');
  });

  testWidgets('16_tomas_de_hoy', (tester) async {
    await abrir(tester, Rutas.tomasHoy, ahora: mediodia);
    // Se desplaza hasta la primera toma sin marcar, con su botón.
    await tester.ensureVisible(find.textContaining('09:00').first);
    await tester.pumpAndSettle();
    await foto(tester, '16_tomas_de_hoy');
  });
  testWidgets(
    '17_historial_tomas',
    (tester) => capturar(
      tester,
      '17_historial_tomas',
      Rutas.historialTomas,
      ahora: mediodia,
    ),
  );

  testWidgets('18_asistente_bienvenida', (tester) async {
    await abrir(tester, Rutas.menuPrincipal, asistenteCompletado: false);
    await foto(tester, '18_asistente_bienvenida');
  });

  testWidgets('19_asistente_avisos', (tester) async {
    await abrir(tester, Rutas.menuPrincipal, asistenteCompletado: false);
    await pulsarTexto(tester, 'Empezar');
    await pulsarTexto(tester, 'Siguiente');
    await foto(tester, '19_asistente_avisos');
  });

  testWidgets('20_foto_de_la_caja', (tester) async {
    await abrir(tester, Rutas.listaMedicamentos);
    await pulsarEtiqueta(tester, 'Modificar Omeprazol');
    await tester.ensureVisible(find.text('Foto de la caja (opcional)'));
    await tester.pumpAndSettle();
    await foto(tester, '20_foto_de_la_caja');
  });

  testWidgets('22_dias_de_toma', (tester) async {
    await abrir(tester, Rutas.nuevoMedicamento);
    // Una pastilla semanal para los huesos: solo los lunes.
    await pulsarTexto(tester, 'Algunos días de la semana');
    await pulsarTexto(tester, 'Domingo');
    await pulsarTexto(tester, 'Lunes');
    await tester.ensureVisible(find.text('Algunos días de la semana'));
    await tester.pumpAndSettle();
    await foto(tester, '22_dias_de_toma');
  });

  testWidgets('23_horas_concretas', (tester) async {
    await abrir(tester, Rutas.nuevoMedicamento);
    // Tres tomas con el desayuno, la comida y la cena.
    await pulsarEtiqueta(tester, 'Una toma más');
    await pulsarEtiqueta(tester, 'Una toma más');
    await pulsarTexto(tester, 'A horas concretas');
    await tester.ensureVisible(find.text('¿A qué horas lo tomas?'));
    await tester.pumpAndSettle();
    await foto(tester, '23_horas_concretas');
  });

  testWidgets('24_cuando_haga_falta', (tester) async {
    await abrir(tester, Rutas.tomasHoy, ahora: mediodia);
    await tester.ensureVisible(find.text('Cuando haga falta'));
    await tester.pumpAndSettle();
    await foto(tester, '24_cuando_haga_falta');
  });

  testWidgets('25_he_comprado_mas', (tester) async {
    await abrir(tester, Rutas.listaMedicamentos, ahora: mediodia);
    await pulsarEtiqueta(tester, 'He comprado más Omeprazol');
    await escribir(tester, find.byType(TextField), '28');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await foto(tester, '25_he_comprado_mas');
  });

  testWidgets('28_dosis_distinta', (tester) async {
    await abrir(tester, Rutas.nuevoMedicamento);
    // Una pastilla por la mañana y media por la noche.
    await escribir(tester, find.byType(TextField).first, 'Enalapril');
    await escribir(tester, find.byType(TextField).at(1), '1 pastilla');
    await pulsarEtiqueta(tester, 'Una toma más');
    await pulsarTexto(tester, 'A horas concretas');
    await pulsarTexto(tester, 'Distinta según la hora');
    await escribir(tester, find.byType(TextField).at(3), 'media pastilla');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.ensureVisible(find.text('Dosis en cada toma'));
    await tester.pumpAndSettle();
    await foto(tester, '28_dosis_distinta');
  });

  testWidgets('29_receta', (tester) async {
    await abrir(tester, Rutas.listaMedicamentos, ahora: mediodia);
    await cambiar(
      tester,
      'Omeprazol',
      (m) => m.conReceta(DateTime(2026, 10, 28)),
    );
    // La tarjeta desde la dosis: se ven el aviso y "Ya la he renovado".
    await tester.ensureVisible(find.text('Dosis: 1 pastilla'));
    await tester.pumpAndSettle();
    await foto(tester, '29_receta');
  });

  Future<void> paracetamolConLimites(WidgetTester tester) async {
    await abrir(tester, Rutas.tomasHoy, ahora: mediodia);
    await cambiar(
      tester,
      'Paracetamol',
      (m) => m.conDatos(
        NuevoMedicamento(
          nombre: m.nombre,
          numTomas: 1,
          frecuenciaHoras: 24,
          horaInicio: m.horaInicio,
          dosis: m.dosis,
          instrucciones: m.instrucciones,
          aDemanda: true,
          maximoAlDia: 3,
          horasEntreTomas: 6,
        ),
      ),
    );
  }

  testWidgets('30_limites', (tester) async {
    await paracetamolConLimites(tester);
    await tester.ensureVisible(find.text('Cuando haga falta'));
    await tester.pumpAndSettle();
    await foto(tester, '30_limites');
  });

  testWidgets('31_aviso_de_mas', (tester) async {
    await paracetamolConLimites(tester);
    await pulsarTexto(tester, 'Lo he tomado ahora');
    await foto(tester, '31_aviso_de_mas');
  });

  // Ejemplo del PDF para el médico o la familia, con los mismos datos.
  testWidgets('informe_ejemplo.pdf', (tester) async {
    await abrir(tester, Rutas.menuPrincipal, ahora: mediodia);
    final contenedor = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    final pdf = await contenedor
        .read(servicioCompartirProvider)
        .generarInforme();
    await tester.runAsync(
      () => File('docs/informe_ejemplo.pdf').writeAsBytes(pdf),
    );
  });
}
