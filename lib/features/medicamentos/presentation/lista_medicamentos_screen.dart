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
import '../application/existencias_controller.dart';
import '../application/medicamentos_controller.dart';
import '../domain/dias_de_toma.dart';
import '../domain/existencias.dart';
import '../domain/medicamento.dart';
import '../domain/receta.dart';
import 'foto_caja.dart';

/// Pantalla 4: lista de medicamentos registrados con opciones para
/// modificarlos o eliminarlos.
class ListaMedicamentosScreen extends ConsumerWidget {
  const ListaMedicamentosScreen({super.key});

  Future<void> _eliminar(
    BuildContext context,
    WidgetRef ref,
    Medicamento medicamento,
  ) async {
    final t = TextosApp.of(context);
    final controlador = ref.read(medicamentosProvider.notifier);
    final confirmado = await confirmarEliminacion(
      context,
      pregunta: t.listaMedicamentosPreguntaEliminar,
      detalle: t.listaMedicamentosDetalleEliminar(medicamento.nombre),
    );
    if (!confirmado || !context.mounted) return;
    try {
      await controlador.eliminar(medicamento);
    } on Object {
      if (context.mounted) {
        mostrarAviso(
          context,
          t.listaMedicamentosErrorEliminar,
          icono: Icons.error,
        );
      }
      return;
    }
    if (!context.mounted) return;
    mostrarAviso(
      context,
      t.listaMedicamentosEliminado(medicamento.nombre),
      alDeshacer: () => controlador.restaurar(medicamento),
      mensajeTrasDeshacer: t.listaMedicamentosRecuperado(medicamento.nombre),
      pistaDeshacer: t.botonDeshacerPistaEliminar,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = TextosApp.of(context);
    final medicamentos = ref.watch(medicamentosProvider);
    final existencias = ref.watch(existenciasProvider).value ?? const {};
    final ahora = ref.watch(relojProvider)();
    final hayMedicamentos = medicamentos.value?.isNotEmpty ?? false;
    void registrar() => Navigator.of(context).pushNamed(Rutas.nuevoMedicamento);

    return PantallaBase(
      titulo: t.listaMedicamentosTitulo,
      pieArribaEnModoCompacto: true,
      pie: hayMedicamentos
          ? BotonGrande(
              etiqueta: t.medicamentosMenuNuevo,
              icono: Icons.add_circle,
              centrado: true,
              onPressed: registrar,
            )
          : null,
      cuerpo: EstadoCarga<List<Medicamento>>(
        valor: medicamentos,
        mensajeError: t.errorCargarMedicamentos,
        conDatos: (lista) {
          if (lista.isEmpty) {
            return EstadoVacio(
              icono: Icons.medication,
              mensaje: t.listaMedicamentosVacio,
              explicacion: t.listaMedicamentosVacioExplicacion,
              accion: BotonGrande(
                etiqueta: t.medicamentosMenuNuevo,
                icono: Icons.add_circle,
                onPressed: registrar,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Parrafo(t.listaMedicamentosCuantos(lista.length)),
              for (final medicamento in lista) ...[
                const Hueco(),
                _TarjetaMedicamento(
                  medicamento: medicamento,
                  existencias: existencias[medicamento.id],
                  ahora: ahora,
                  onComprar: () => Rutas.abrirComprarMas(context, medicamento),
                  onRenovar: () =>
                      Rutas.abrirRenovarReceta(context, medicamento),
                  onModificar: () =>
                      Rutas.abrirModificarMedicamento(context, medicamento),
                  onEliminar: () => _eliminar(context, ref, medicamento),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaMedicamento extends StatelessWidget {
  const _TarjetaMedicamento({
    required this.medicamento,
    required this.existencias,
    required this.ahora,
    required this.onComprar,
    required this.onRenovar,
    required this.onModificar,
    required this.onEliminar,
  });

  final Medicamento medicamento;

  /// Cómo va la cuenta de las pastillas (si se lleva y ya se ha calculado).
  final EstadoExistencias? existencias;

  final DateTime ahora;
  final VoidCallback onComprar;
  final VoidCallback onRenovar;
  final VoidCallback onModificar;
  final VoidCallback onEliminar;

  String _duracion(TextosApp t) {
    final fin = medicamento.fechaFin;
    if (fin == null) {
      return medicamento.dias is TodosLosDias && !medicamento.aDemanda
          ? t.medicamentoSinFechaDeFin
          : t.medicamentoSinFechaDeFinSolo;
    }
    if (medicamento.terminado(ahora)) {
      return t.medicamentoTerminadoEl(FormatoFechas.fechaLarga(fin));
    }
    return t.medicamentoHastaEl(FormatoFechas.fechaLarga(fin));
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final cuenta = !medicamento.terminado(ahora)
        ? medicamento.existencias
        : null;
    final existencias = cuenta == null ? null : this.existencias;
    final receta =
        medicamento.renovarReceta != null && !medicamento.terminado(ahora);
    final renovar = Receta.hayQueRenovar(medicamento, ahora);
    return TarjetaInfo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicamento.nombre, style: textos.titleLarge),
                if (medicamento.foto != null) ...[
                  const SizedBox(height: 8),
                  FotoCaja(
                    foto: medicamento.foto!,
                    nombreMedicamento: medicamento.nombre,
                    nodoPropio: false,
                  ),
                ],
                if (medicamento.describirDosis case final dosis?)
                  LineaDato(
                    icono: Icons.medication,
                    texto: t.medicamentoDosis(dosis),
                  ),
                LineaDato(
                  icono: Icons.repeat,
                  texto: medicamento.descripcionTomas,
                ),
                if (medicamento.describirLimites case final limites?)
                  LineaDato(icono: Icons.rule, texto: limites),
                if (medicamento.dias.describir() case final dias?)
                  LineaDato(
                    icono: Icons.event_repeat,
                    texto: FormatoFechas.conMayuscula(dias),
                  ),
                if (!medicamento.aDemanda)
                  LineaDato(
                    icono: Icons.alarm,
                    texto: t.medicamentoHoras(
                      FormatoFechas.listaDeHoras(medicamento.horasDeToma),
                    ),
                  ),
                LineaDato(icono: Icons.event, texto: _duracion(t)),
                if (receta)
                  LineaDato(
                    icono: renovar ? Icons.warning_amber : Icons.description,
                    texto: Receta.describir(medicamento, ahora),
                  ),
                if (existencias != null) ...[
                  LineaDato(
                    icono: Icons.inventory_2,
                    texto: existencias.describir(),
                  ),
                  if (existencias.pocas)
                    LineaDato(
                      icono: Icons.warning_amber,
                      texto: t.medicamentoExistenciasPocas(
                        t.medicamentoComprarMas,
                      ),
                    ),
                ],
                if (medicamento.instrucciones != null)
                  LineaDato(
                    icono: Icons.info_outline,
                    texto: medicamento.instrucciones!,
                  ),
              ],
            ),
          ),
          const SizedBox(height: Medidas.margen),
          if (renovar) ...[
            BotonGrande(
              etiqueta: t.medicamentoRecetaRenovada,
              etiquetaSemantica: t.medicamentoRecetaRenovadaSemantica(
                medicamento.nombre,
              ),
              icono: Icons.description,
              onPressed: onRenovar,
            ),
            const SizedBox(height: 12),
          ],
          if (cuenta != null) ...[
            BotonGrande(
              etiqueta: t.medicamentoComprarMas,
              etiquetaSemantica: t.medicamentoComprarMasSemantica(
                medicamento.nombre,
              ),
              icono: Icons.add_shopping_cart,
              onPressed: onComprar,
            ),
            const SizedBox(height: 12),
          ],
          BotonGrande(
            etiqueta: t.botonModificar,
            etiquetaSemantica: t.botonModificarSemantica(medicamento.nombre),
            icono: Icons.edit,
            onPressed: onModificar,
          ),
          const SizedBox(height: 12),
          BotonGrande(
            etiqueta: t.botonEliminar,
            etiquetaSemantica: t.botonEliminarSemantica(medicamento.nombre),
            icono: Icons.delete,
            estilo: EstiloBoton.peligro,
            onPressed: onEliminar,
          ),
        ],
      ),
    );
  }
}
