import 'dart:io';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart' show Scaffold, TextField;
import 'package:flutter/rendering.dart' show SemanticsNode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/app/app.dart';
import 'package:salud_mayores/app/proveedores.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:salud_mayores/features/agenda/domain/cita.dart';
import 'package:salud_mayores/features/ajustes/domain/ajustes.dart';
import 'package:salud_mayores/features/compartir/application/servicio_compartir.dart';
import 'package:salud_mayores/features/medicamentos/domain/borrador_medicamento.dart';
import 'package:salud_mayores/features/medicamentos/domain/medicamento.dart';
import 'package:salud_mayores/features/tomas/domain/registro_toma.dart';

import 'dobles.dart';
import 'textos.dart';

/// Montserrat leída directamente de los ficheros (en los tests, cargarla desde
/// los assets no termina).
final FuentesPdf fuentesPdfDePrueba = FuentesPdf(
  pw.Font.ttf(_fuente('Regular')),
  pw.Font.ttf(_fuente('Bold')),
);

ByteData _fuente(String peso) => ByteData.sublistView(
  File('assets/fonts/Montserrat-$peso.ttf').readAsBytesSync(),
);

/// Momento fijo para que los tests no dependan del día en que se ejecutan:
/// domingo, 25 de octubre de 2026, a las 9:00.
final DateTime ahoraDePrueba = DateTime(2026, 10, 25, 9);

/// Entorno completo de la app con dobles en memoria.
class EntornoDePrueba {
  EntornoDePrueba({
    List<Medicamento> medicamentos = const [],
    List<Cita> citas = const [],
    List<RegistroToma> tomas = const [],
    Ajustes ajustes = const Ajustes(),
    ServicioNotificacionesFalso? notificaciones,
    MarcadorTelefonoFalso? marcador,
    ServicioVozFalso? voz,
    AlmacenFotosEnMemoria? fotos,
    SelectorFotosFalso? selectorFotos,
    ServicioArchivosFalso? archivos,
    ServicioBateriaFalso? bateria,
    ServicioWidgetFalso? widget,
    BorradorMedicamento? borrador,
    DateTime? ahora,
    bool asistenteCompletado = true,
  }) : medicamentos = MedicamentoRepositoryEnMemoria(medicamentos),
       citas = CitaRepositoryEnMemoria(citas),
       tomas = TomaRepositoryEnMemoria(tomas),
       ajustes = AjustesRepositoryEnMemoria(ajustes, asistenteCompletado),
       notificaciones = notificaciones ?? ServicioNotificacionesFalso(),
       marcador = marcador ?? MarcadorTelefonoFalso(),
       voz = voz ?? ServicioVozFalso(),
       fotos = fotos ?? AlmacenFotosEnMemoria(),
       selectorFotos = selectorFotos ?? SelectorFotosFalso(),
       archivos = archivos ?? ServicioArchivosFalso(),
       bateria = bateria ?? ServicioBateriaFalso(),
       widget = widget ?? ServicioWidgetFalso(),
       borradores = BorradorRepositoryEnMemoria(borrador),
       ahora = ahora ?? ahoraDePrueba;

  final MedicamentoRepositoryEnMemoria medicamentos;
  final CitaRepositoryEnMemoria citas;
  final TomaRepositoryEnMemoria tomas;
  final AjustesRepositoryEnMemoria ajustes;
  final ServicioNotificacionesFalso notificaciones;
  final MarcadorTelefonoFalso marcador;
  final ServicioVozFalso voz;
  final AlmacenFotosEnMemoria fotos;
  final SelectorFotosFalso selectorFotos;
  final ServicioArchivosFalso archivos;
  final ServicioBateriaFalso bateria;
  final ServicioWidgetFalso widget;
  final BorradorRepositoryEnMemoria borradores;

  /// Sustituye los datos de los tres repositorios en memoria (al recuperar
  /// una copia).
  late final RestauracionDatosEnMemoria restauracion =
      RestauracionDatosEnMemoria(medicamentos, citas, tomas);

  /// Hora que ve la app; se puede cambiar durante el test para simular que
  /// pasa el tiempo.
  DateTime ahora;

  List<Override> get overrides => [
    medicamentoRepositoryProvider.overrideWithValue(medicamentos),
    citaRepositoryProvider.overrideWithValue(citas),
    tomaRepositoryProvider.overrideWithValue(tomas),
    restauracionDatosProvider.overrideWithValue(restauracion),
    ajustesRepositoryProvider.overrideWithValue(ajustes),
    servicioNotificacionesProvider.overrideWithValue(notificaciones),
    marcadorTelefonoProvider.overrideWithValue(marcador),
    servicioVozProvider.overrideWithValue(voz),
    almacenFotosProvider.overrideWithValue(fotos),
    selectorFotosProvider.overrideWithValue(selectorFotos),
    servicioArchivosProvider.overrideWithValue(archivos),
    servicioBateriaProvider.overrideWithValue(bateria),
    servicioWidgetProvider.overrideWithValue(widget),
    borradorRepositoryProvider.overrideWithValue(borradores),
    fuentesPdfProvider.overrideWith((ref) async => fuentesPdfDePrueba),
    relojProvider.overrideWithValue(() => ahora),
  ];

  Widget get app =>
      ProviderScope(overrides: overrides, child: const AppSaludMayores());
}

/// Simula un teléfono de 360 × 760 dp (tamaño habitual de Android).
void usarPantallaDeTelefono(
  WidgetTester tester, {
  Size tamano = const Size(360, 760),
}) {
  tester.view.devicePixelRatio = 3;
  tester.view.physicalSize = tamano * 3;
  addTearDown(tester.view.reset);
}

/// Arranca la app y espera a que se dibuje el menú principal.
Future<void> arrancar(WidgetTester tester, EntornoDePrueba entorno) async {
  await tester.pumpWidget(entorno.app);
  await tester.pumpAndSettle();
}

/// Pulsa el elemento con el texto indicado, desplazándose hasta él si está
/// fuera de la pantalla.
Future<void> pulsarTexto(WidgetTester tester, String texto) =>
    _pulsar(tester, find.text(texto).first);

/// Pulsa el control cuya etiqueta para TalkBack es [etiqueta] (por ejemplo,
/// los botones "+" y "−", que no tienen texto visible). Si hay varios (las
/// horas de varias tomas), [indice] dice cuál.
Future<void> pulsarEtiqueta(
  WidgetTester tester,
  String etiqueta, {
  int? indice,
}) {
  final buscador = find.bySemanticsLabel(etiqueta);
  return _pulsar(tester, indice == null ? buscador : buscador.at(indice));
}

/// El botón "Deshacer" del mensaje inferior, con la explicación [pista] que
/// lee TalkBack.
Finder botonDeshacer(String pista) => find.byWidgetPredicate(
  (w) =>
      w is Semantics &&
      w.properties.label == es.botonDeshacer &&
      w.properties.hint == pista,
);

Future<void> _pulsar(WidgetTester tester, Finder buscador) async {
  await tester.ensureVisible(buscador);
  await tester.pumpAndSettle();
  await tester.tap(buscador);
  await tester.pumpAndSettle();
}

/// Escribe en un campo y cierra el teclado con la tecla "Hecho", como haría
/// la persona usuaria antes de seguir con el formulario.
Future<void> escribir(WidgetTester tester, Finder campo, String texto) async {
  await tester.enterText(campo, texto);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

/// Comprueba que TalkBack puede usar bien los campos de texto y los
/// encabezados de la pantalla: cada uno en su propio nodo, con su etiqueta y
/// sin mezclarse con los textos de alrededor (Flutter funde los `Semantics`
/// que no son `container` con sus vecinos).
void comprobarNodosSemanticos(WidgetTester tester, {String motivo = ''}) {
  for (final campo in find.byType(TextField).evaluate()) {
    final datos = tester
        .getSemantics(find.byWidget(campo.widget))
        .getSemanticsData();
    expect(
      datos.flagsCollection.isTextField,
      isTrue,
      reason: '$motivo: campo sin nodo propio',
    );
    expect(
      datos.flagsCollection.isFocused,
      isNot(Tristate.none),
      reason: '$motivo: el campo "${datos.label}" no se puede enfocar',
    );
    expect(datos.label, isNotEmpty, reason: '$motivo: campo sin etiqueta');
    expect(
      datos.label,
      isNot(contains('\n')),
      reason: '$motivo: la etiqueta del campo se mezcla con otros textos',
    );
  }

  var raiz = tester.getSemantics(find.byType(Scaffold).last);
  while (raiz.parent != null) {
    raiz = raiz.parent!;
  }
  void visitar(SemanticsNode nodo) {
    final datos = nodo.getSemanticsData();
    // Un nodo con texto y con controles dentro es señal de que Flutter ha
    // juntado textos sueltos de la pantalla: TalkBack los leería de golpe,
    // antes que los controles que hay entre ellos.
    if (datos.label.isNotEmpty && nodo.hasChildren) {
      final hijos = <String>[];
      nodo.visitChildren((hijo) {
        hijos.add(hijo.getSemanticsData().label);
        return true;
      });
      fail('$motivo: el texto "${datos.label}" contiene otros nodos ($hijos)');
    }
    if (datos.flagsCollection.isHeader) {
      expect(
        datos.label,
        isNot(contains('\n')),
        reason:
            '$motivo: el encabezado "${datos.label}" se mezcla con otros textos',
      );
    }
    nodo.visitChildren((hijo) {
      visitar(hijo);
      return true;
    });
  }

  visitar(raiz);
}
