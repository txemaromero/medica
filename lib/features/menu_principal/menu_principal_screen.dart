import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/proveedores.dart';
import '../../app/rutas.dart';
import '../../core/tema/tema_visual.dart';
import '../../core/tiempo/formato_fechas.dart';
import '../../core/widgets/botones.dart';
import '../../core/widgets/medida_texto.dart';
import '../../core/widgets/pictogramas.dart';
import '../../core/widgets/tarjetas.dart';
import '../../l10n/textos.dart';
import '../agenda/application/citas_controller.dart';
import '../ajustes/presentation/estado_avisos_tarjeta.dart';
import '../medicamentos/application/medicamentos_controller.dart';
import '../medicamentos/presentation/aviso_medicamentos.dart';
import '../tomas/application/tomas_controller.dart';
import '../tomas/domain/tomas_del_dia.dart';
import 'proximos_eventos.dart';

class _OpcionMenu {
  const _OpcionMenu(this.etiqueta, this.pictograma, this.ruta);

  final String etiqueta;
  final Widget pictograma;
  final String ruta;
}

/// Pantalla 1: menú principal con cuatro tarjetas grandes en cuadrícula 2×2
/// y, encima, un resumen con la próxima toma y la próxima cita.
///
/// Si alguna etiqueta no cabe en media pantalla sin partir palabras (texto
/// muy grande o pantalla estrecha), las tarjetas se colocan en una columna.
class MenuPrincipalScreen extends StatelessWidget {
  const MenuPrincipalScreen({super.key});

  // Medidas ajustadas para que la cuadrícula 2×2 quepa con el texto base en
  // móviles de 393 dp o más ("medicamentos" mide unos 160 dp en negrita).
  static const double _margen = 12;
  static const double _hueco = 10;
  static const double _rellenoTarjeta = 6;

  static List<_OpcionMenu> _opciones(TextosApp t) => [
    _OpcionMenu(
      t.menuMedicamentos,
      const Pictograma(Icons.medication),
      Rutas.medicamentos,
    ),
    _OpcionMenu(
      t.menuAgenda,
      const Pictograma(Icons.calendar_month),
      Rutas.agenda,
    ),
    _OpcionMenu(
      t.menuEmergencias,
      const PictogramaEmergencia(),
      Rutas.emergencias,
    ),
    _OpcionMenu(t.menuAjustes, const Pictograma(Icons.settings), Rutas.ajustes),
  ];

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final opciones = _opciones(t);
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(_margen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Semantics(
                  container: true,
                  header: true,
                  child: Text(
                    t.menuTitulo,
                    textAlign: TextAlign.center,
                    style: textos.displaySmall,
                  ),
                ),
                const AvisoSinPermiso(),
                const AvisoMedicamentos(),
                const _Resumen(),
                const SizedBox(height: 8),
                Text(
                  t.menuPregunta,
                  textAlign: TextAlign.center,
                  style: textos.bodyLarge,
                ),
                const SizedBox(height: Medidas.separacion),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final tarjetas = [
                      for (final opcion in opciones)
                        TarjetaMenu(
                          etiqueta: opcion.etiqueta,
                          icono: opcion.pictograma,
                          estiloEtiqueta: _estiloEtiqueta(context),
                          rellenoHorizontal: _rellenoTarjeta,
                          alturaMinima: 200,
                          onPressed: () =>
                              Navigator.of(context).pushNamed(opcion.ruta),
                        ),
                    ];
                    return _dosColumnas(context, opciones, constraints.maxWidth)
                        ? _Cuadricula(tarjetas: tarjetas, hueco: _hueco)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final tarjeta in tarjetas) ...[
                                tarjeta,
                                const SizedBox(height: _hueco),
                              ],
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Etiquetas en negrita al tamaño base (20 pt): nunca más pequeñas que el
  /// texto normal.
  static TextStyle _estiloEtiqueta(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!;

  bool _dosColumnas(
    BuildContext context,
    List<_OpcionMenu> opciones,
    double anchoTotal,
  ) {
    // Ancho útil del texto dentro de cada tarjeta: media pantalla menos el
    // relleno interior y el borde.
    final anchoTexto =
        (anchoTotal - _hueco) / 2 -
        2 * _rellenoTarjeta -
        2 * Medidas.grosorBorde;
    final estilo = _estiloEtiqueta(context);
    return opciones.every(
      (opcion) => MedidaTexto.cabeSinPartirPalabras(
        context,
        opcion.etiqueta,
        estilo,
        anchoTexto,
      ),
    );
  }
}

/// Próxima toma y próxima cita, para verlas de un vistazo al abrir la app.
/// No se muestra si no hay ninguna. Se recalcula cada minuto por si el menú
/// se queda abierto mientras pasa la hora de una toma.
class _Resumen extends ConsumerStatefulWidget {
  const _Resumen();

  @override
  ConsumerState<_Resumen> createState() => _ResumenState();
}

class _ResumenState extends ConsumerState<_Resumen> {
  late final Timer _refresco;

  @override
  void initState() {
    super.initState();
    _refresco = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _refresco.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final ahora = ref.watch(relojProvider)();
    final medicamentos = ref.watch(medicamentosProvider).value ?? const [];
    final registros = ref.watch(tomasProvider).value ?? const [];
    final tomasDeHoy = TomasDelDia.calcular(
      medicamentos: medicamentos,
      registros: registros,
      dia: ahora,
      ahora: ahora,
    );
    final tomadasHoy = tomasDeHoy
        .where((t) => t.estado == EstadoTomaDelDia.tomada)
        .length;
    final toma = ProximosEventos.proximaToma(
      medicamentos,
      ahora,
      registros: registros,
    );
    final cita = ProximosEventos.proximaCita(
      ref.watch(citasProvider).value ?? const [],
      ahora,
    );
    if (toma == null && cita == null && tomasDeHoy.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: MergeSemantics(
        child: TarjetaInfo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tomasDeHoy.isNotEmpty)
                LineaDato(
                  icono: Icons.task_alt,
                  texto: t.menuTomasDeHoy(
                    '$tomadasHoy',
                    '${tomasDeHoy.length}',
                  ),
                ),
              if (toma != null)
                LineaDato(
                  icono: Icons.medication,
                  texto: t.menuProximaToma(
                    toma.medicamento.nombre,
                    FormatoFechas.cuando(toma.fechaHora, ahora),
                  ),
                ),
              if (cita != null)
                LineaDato(
                  icono: Icons.calendar_month,
                  texto: t.menuProximaCita(
                    cita.titulo,
                    FormatoFechas.cuando(cita.fechaHora, ahora),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cuadricula extends StatelessWidget {
  const _Cuadricula({required this.tarjetas, required this.hueco});

  final List<Widget> tarjetas;
  final double hueco;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < tarjetas.length; i += 2) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: tarjetas[i]),
                SizedBox(width: hueco),
                Expanded(
                  child: i + 1 < tarjetas.length
                      ? tarjetas[i + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          SizedBox(height: hueco),
        ],
      ],
    );
  }
}
