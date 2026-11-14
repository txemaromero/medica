import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../app/rutas.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/estado_carga.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../application/citas_controller.dart';
import '../domain/cita.dart';

/// Pantalla 5: agenda con todas las citas ordenadas por fecha.
class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  Future<void> _eliminar(BuildContext context, WidgetRef ref, Cita cita) async {
    final t = TextosApp.of(context);
    final controlador = ref.read(citasProvider.notifier);
    final confirmado = await confirmarEliminacion(
      context,
      pregunta: t.agendaPreguntaEliminar,
      detalle: t.agendaDetalleEliminar(
        cita.titulo,
        FormatoFechas.fechaLarga(cita.fecha),
        cita.hora.texto,
      ),
    );
    if (!confirmado || !context.mounted) return;
    try {
      await controlador.eliminar(cita);
    } on Object {
      if (context.mounted) {
        mostrarAviso(context, t.agendaErrorEliminar, icono: Icons.error);
      }
      return;
    }
    if (!context.mounted) return;
    mostrarAviso(
      context,
      t.agendaCitaEliminada(cita.titulo),
      alDeshacer: () => controlador.restaurar(cita),
      mensajeTrasDeshacer: t.agendaCitaRecuperada(cita.titulo),
      pistaDeshacer: t.botonDeshacerPistaEliminar,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citas = ref.watch(citasProvider);
    final ahora = ref.watch(relojProvider)();
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);

    return PantallaBase(
      titulo: t.menuAgenda,
      pieArribaEnModoCompacto: true,
      pie: BotonGrande(
        etiqueta: t.agendaCrearCita,
        descripcion: t.agendaCrearCitaDescripcion,
        icono: Icons.add_circle,
        onPressed: () => Navigator.of(context).pushNamed(Rutas.nuevaCita),
      ),
      cuerpo: EstadoCarga<List<Cita>>(
        valor: citas,
        mensajeError: t.agendaErrorCarga,
        conDatos: (lista) {
          if (lista.isEmpty) {
            return EstadoVacio(
              icono: Icons.calendar_month,
              mensaje: t.agendaVacio,
              explicacion: t.agendaVacioExplicacion(t.agendaCrearCita),
            );
          }
          final proximas = lista.where((c) => !c.yaHaPasado(ahora)).toList();
          // Las pasadas, de la más reciente a la más antigua.
          final pasadas = lista
              .where((c) => c.yaHaPasado(ahora))
              .toList()
              .reversed;

          Widget encabezado(String texto) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Semantics(
              container: true,
              header: true,
              child: Text(texto, style: textos.headlineSmall),
            ),
          );
          Widget tarjeta(Cita cita, {required bool pasada}) => _TarjetaCita(
            cita: cita,
            hoy: ahora,
            pasada: pasada,
            onModificar: () => Rutas.abrirModificarCita(context, cita),
            onEliminar: () => _eliminar(context, ref, cita),
          );

          final elementos = <Widget>[
            encabezado(t.agendaProximas),
            if (proximas.isEmpty) Parrafo(t.agendaSinProximas),
            for (final cita in proximas) tarjeta(cita, pasada: false),
            if (pasadas.isNotEmpty) ...[
              encabezado(t.agendaPasadas),
              for (final cita in pasadas) tarjeta(cita, pasada: true),
            ],
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < elementos.length; i++) ...[
                if (i > 0) const Hueco(),
                elementos[i],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaCita extends StatelessWidget {
  const _TarjetaCita({
    required this.cita,
    required this.hoy,
    required this.pasada,
    required this.onModificar,
    required this.onEliminar,
  });

  final VoidCallback onModificar;

  final Cita cita;
  final DateTime hoy;
  final bool pasada;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final lugar = cita.lugar?.trim() ?? '';
    final notas = cita.notas?.trim() ?? '';
    return TarjetaInfo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cita.titulo, style: textos.titleLarge),
                LineaDato(
                  icono: Icons.calendar_today,
                  texto: FormatoFechas.fechaRelativa(cita.fecha, hoy),
                ),
                LineaDato(
                  icono: Icons.schedule,
                  texto: FormatoFechas.horaConParteDelDia(cita.hora),
                ),
                if (lugar.isNotEmpty)
                  LineaDato(icono: Icons.place, texto: lugar),
                if (notas.isNotEmpty)
                  LineaDato(icono: Icons.notes, texto: notas),
                if (pasada)
                  LineaDato(icono: Icons.history, texto: t.agendaCitaPasada),
              ],
            ),
          ),
          const SizedBox(height: Medidas.margen),
          // Una cita pasada no se modifica: solo se puede eliminar.
          if (!pasada) ...[
            BotonGrande(
              etiqueta: t.botonModificar,
              etiquetaSemantica: t.agendaModificarSemantica(cita.titulo),
              icono: Icons.edit,
              onPressed: onModificar,
            ),
            const SizedBox(height: 12),
          ],
          BotonGrande(
            etiqueta: t.botonEliminar,
            etiquetaSemantica: t.agendaEliminarSemantica(cita.titulo),
            icono: Icons.delete,
            estilo: EstiloBoton.peligro,
            onPressed: onEliminar,
          ),
        ],
      ),
    );
  }
}
