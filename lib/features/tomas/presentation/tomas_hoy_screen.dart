import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../app/rutas.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/estado_carga.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../../../voz/lector.dart';
import '../../../voz/textos_para_leer.dart';
import '../../ajustes/application/ajustes_controller.dart';
import '../../medicamentos/application/medicamentos_controller.dart';
import '../../medicamentos/domain/medicamento.dart';
import '../../medicamentos/presentation/foto_caja.dart';
import '../application/tomas_controller.dart';
import '../domain/limites_a_demanda.dart';
import '../domain/registro_toma.dart';
import '../domain/tomas_del_dia.dart';

/// "Tomas de hoy": las tomas previstas para hoy, con un botón grande para
/// marcar cada una como tomada (o desmarcarla si fue un error). Debajo, los
/// medicamentos "cuando haga falta", con un botón para anotar que se acaba
/// de tomar uno.
class TomasHoyScreen extends ConsumerWidget {
  const TomasHoyScreen({super.key});

  Future<void> _marcar(
    BuildContext context,
    WidgetRef ref,
    Medicamento medicamento,
    DateTime fecha,
    HoraDelDia hora,
  ) async {
    final t = TextosApp.of(context);
    final nombre = medicamento.nombre;
    final controlador = ref.read(tomasProvider.notifier);
    final anterior = await controlador.marcarTomada(medicamento, fecha, hora);
    if (!context.mounted) return;
    mostrarAviso(
      context,
      t.tomasAnotada(nombre, hora.texto),
      alDeshacer: () => controlador.restaurar(
        medicamentoId: medicamento.id,
        fecha: fecha,
        hora: hora,
        registro: anterior,
      ),
      mensajeTrasDeshacer: t.tomasDesmarcada(nombre, hora.texto),
      pistaDeshacer: t.tomasDeshacerMarcarPista,
    );
  }

  Future<void> _desmarcar(
    BuildContext context,
    WidgetRef ref,
    Medicamento medicamento,
    DateTime fecha,
    HoraDelDia hora,
  ) async {
    final t = TextosApp.of(context);
    final nombre = medicamento.nombre;
    final controlador = ref.read(tomasProvider.notifier);
    final anterior = await controlador.desmarcar(medicamento.id, fecha, hora);
    if (!context.mounted) return;
    mostrarAviso(
      context,
      t.tomasDesmarcada(nombre, hora.texto),
      icono: Icons.undo,
      alDeshacer: () => controlador.restaurar(
        medicamentoId: medicamento.id,
        fecha: fecha,
        hora: hora,
        registro: anterior,
      ),
      mensajeTrasDeshacer: t.tomasAnotada(nombre, hora.texto),
      pistaDeshacer: t.tomasDeshacerDesmarcarPista,
    );
  }

  /// Anota una toma de un medicamento "cuando haga falta" a la hora actual.
  /// Si se pasa de sus límites (calculados ahora: la pantalla puede llevar
  /// rato abierta), antes lo explica y pregunta: lo anotado tiene que ser lo
  /// que de verdad se ha tomado.
  Future<void> _tomarAhora(
    BuildContext context,
    WidgetRef ref,
    Medicamento medicamento,
  ) async {
    final limites = LimitesADemanda.estado(
      medicamento,
      ref.read(tomasProvider).value ?? const [],
      ref.read(relojProvider)(),
    );
    if (!limites.dentroDeLosLimites) {
      final t = TextosApp.of(context);
      final anotar = await preguntar(
        context,
        titulo: t.tomasADemandaAvisoTitulo,
        mensaje: [
          if (limites.maximoAlcanzado)
            t.tomasADemandaAvisoMaximo(
              medicamento.maximoAlDia!,
              medicamento.nombre,
            ),
          if (limites.proximaDesde case final desde?) ...[
            t.tomasADemandaAvisoPronto(
              medicamento.horasEntreTomas!,
              medicamento.nombre,
            ),
            '${TarjetaADemanda.textoProxima(t, desde, ref.read(relojProvider)())}.',
          ],
          '',
          t.tomasADemandaAvisoConsejo,
        ].join('\n'),
        textoSi: t.tomasADemandaAvisoSi,
        textoNo: t.tomasADemandaAvisoNo,
        icono: Icons.warning_amber,
      );
      if (!anotar || !context.mounted) return;
    }
    final ahora = ref.read(relojProvider)();
    return _marcar(
      context,
      ref,
      medicamento,
      ahora,
      HoraDelDia(ahora.hour, ahora.minute),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ahora = ref.watch(relojProvider)();
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final leerEnVozAlta = ref.watch(
      ajustesProvider.select((a) => a.leerEnVozAlta),
    );

    return PantallaBase(
      titulo: t.tomasTitulo,
      cuerpo: EstadoCarga<List<Medicamento>>(
        valor: ref.watch(medicamentosProvider),
        mensajeError: t.errorCargarMedicamentos,
        conDatos: (medicamentos) => EstadoCarga<List<RegistroToma>>(
          valor: ref.watch(tomasProvider),
          mensajeError: t.tomasErrorCarga,
          conDatos: (registros) {
            final tomas = TomasDelDia.calcular(
              medicamentos: medicamentos,
              registros: registros,
              dia: ahora,
              ahora: ahora,
            );
            final aDemanda = TomasDelDia.medicamentosADemanda(
              medicamentos,
              ahora,
            );
            final tomadasADemanda = TomasDelDia.tomasADemanda(
              medicamentos: medicamentos,
              registros: registros,
              dia: ahora,
            );
            if (tomas.isEmpty && aDemanda.isEmpty) {
              return EstadoVacio(
                icono: Icons.task_alt,
                mensaje: t.tomasVacio,
                explicacion: t.tomasVacioExplicacion,
                accion: BotonGrande(
                  etiqueta: t.medicamentosMenuNuevo,
                  icono: Icons.add_circle,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Rutas.nuevoMedicamento),
                ),
              );
            }
            final tomadas = tomas
                .where((toma) => toma.estado == EstadoTomaDelDia.tomada)
                .length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Parrafo(
                  FormatoFechas.fechaRelativa(ahora, ahora),
                  estilo: textos.titleMedium,
                ),
                if (tomas.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Semantics(
                    container: true,
                    liveRegion: true,
                    child: Text(
                      t.tomasHasTomado('$tomadas', '${tomas.length}'),
                      style: textos.bodyLarge,
                    ),
                  ),
                  if (leerEnVozAlta) ...[
                    const Hueco(),
                    BotonGrande(
                      etiqueta: t.tomasEscuchar,
                      descripcion: t.tomasEscucharDescripcion,
                      icono: Icons.volume_up,
                      onPressed: () => ref
                          .read(lectorProvider)
                          .leer(TextosParaLeer.tomasDeHoy(tomas)),
                    ),
                  ],
                  for (final toma in tomas) ...[
                    const Hueco(),
                    TarjetaToma(
                      toma: toma,
                      onMarcar: () => _marcar(
                        context,
                        ref,
                        toma.medicamento,
                        toma.fecha,
                        toma.hora,
                      ),
                      onDesmarcar: () => _desmarcar(
                        context,
                        ref,
                        toma.medicamento,
                        toma.fecha,
                        toma.hora,
                      ),
                    ),
                  ],
                ],
                if (aDemanda.isNotEmpty) ...[
                  const Hueco(alto: Medidas.separacion * 1.5),
                  Semantics(
                    container: true,
                    header: true,
                    child: Text(
                      t.tomasADemandaTitulo,
                      style: textos.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Parrafo(t.tomasADemandaExplicacion(t.tomasADemandaMarcar)),
                  for (final m in aDemanda) ...[
                    const Hueco(),
                    TarjetaADemanda(
                      medicamento: m,
                      tomas: [
                        for (final r in tomadasADemanda)
                          if (r.medicamentoId == m.id) r,
                      ],
                      limites: LimitesADemanda.estado(m, registros, ahora),
                      ahora: ahora,
                      onTomar: () => _tomarAhora(context, ref, m),
                      onQuitar: (ultima) => _desmarcar(
                        context,
                        ref,
                        m,
                        ultima.fecha,
                        ultima.hora,
                      ),
                    ),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class TarjetaToma extends StatelessWidget {
  const TarjetaToma({
    super.key,
    required this.toma,
    required this.onMarcar,
    required this.onDesmarcar,
  });

  final TomaDelDia toma;
  final VoidCallback onMarcar;
  final VoidCallback onDesmarcar;

  static String textoEstado(TextosApp t, TomaDelDia toma) {
    String hora(DateTime momento) =>
        HoraDelDia(momento.hour, momento.minute).texto;
    final registro = toma.registro;
    return switch (toma.estado) {
      EstadoTomaDelDia.tomada => t.tomasEstadoTomada(hora(registro!.momento)),
      EstadoTomaDelDia.aplazada => t.tomasEstadoAplazada(
        hora(registro!.recordarEn!),
      ),
      EstadoTomaDelDia.pendiente => t.tomasEstadoPendiente,
      EstadoTomaDelDia.sinMarcar => t.tomasEstadoSinMarcar(toma.hora.texto),
    };
  }

  static IconData iconoEstado(EstadoTomaDelDia estado) => switch (estado) {
    EstadoTomaDelDia.tomada => Icons.check_circle,
    EstadoTomaDelDia.aplazada => Icons.alarm,
    EstadoTomaDelDia.pendiente => Icons.schedule,
    EstadoTomaDelDia.sinMarcar => Icons.error_outline,
  };

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final m = toma.medicamento;
    final tomada = toma.estado == EstadoTomaDelDia.tomada;
    return TarjetaInfo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FormatoFechas.horaConParteDelDia(toma.hora),
                  style: textos.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(m.nombre, style: textos.titleLarge),
                if (m.foto != null) ...[
                  const SizedBox(height: 8),
                  FotoCaja(
                    foto: m.foto!,
                    nombreMedicamento: m.nombre,
                    alto: 140,
                    nodoPropio: false,
                  ),
                ],
                if (m.dosisDe(toma.hora) case final dosis?)
                  LineaDato(
                    icono: Icons.medication,
                    texto: t.medicamentoDosis(dosis),
                  ),
                if (m.instrucciones != null)
                  LineaDato(icono: Icons.info_outline, texto: m.instrucciones!),
                LineaDato(
                  icono: iconoEstado(toma.estado),
                  texto: textoEstado(t, toma),
                ),
              ],
            ),
          ),
          const SizedBox(height: Medidas.margen),
          if (tomada)
            BotonGrande(
              etiqueta: t.tomasDesmarcar,
              descripcion: t.tomasDesmarcarDescripcion,
              etiquetaSemantica: t.tomasDesmarcarSemantica(
                m.nombre,
                toma.hora.texto,
              ),
              icono: Icons.undo,
              onPressed: onDesmarcar,
            )
          else
            BotonGrande(
              etiqueta: t.tomasMarcar,
              etiquetaSemantica: t.tomasMarcarSemantica(
                m.nombre,
                toma.hora.texto,
              ),
              icono: Icons.check,
              onPressed: onMarcar,
            ),
        ],
      ),
    );
  }
}

/// Un medicamento "cuando haga falta" en "Tomas de hoy": cuántas veces se ha
/// tomado hoy y a qué horas (para no pasarse), sus límites y si ya se han
/// alcanzado, un botón para anotar que se acaba de tomar y otro para quitar
/// la última si se anotó por error.
class TarjetaADemanda extends StatelessWidget {
  const TarjetaADemanda({
    super.key,
    required this.medicamento,
    required this.tomas,
    required this.limites,
    required this.ahora,
    required this.onTomar,
    required this.onQuitar,
  });

  final Medicamento medicamento;

  /// Lo anotado hoy, por hora.
  final List<RegistroToma> tomas;

  final EstadoLimites limites;
  final DateTime ahora;

  final VoidCallback onTomar;
  final ValueChanged<RegistroToma> onQuitar;

  /// "La próxima, a partir de las 14:30" (o "mañana a partir de…").
  static String textoProxima(TextosApp t, DateTime desde, DateTime ahora) {
    final hora = HoraDelDia(desde.hour, desde.minute).texto;
    return FormatoFechas.soloFecha(desde) == FormatoFechas.soloFecha(ahora)
        ? t.tomasADemandaProximaHoy(hora)
        : t.tomasADemandaProximaManana(hora);
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final m = medicamento;
    return TarjetaInfo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.nombre, style: textos.titleLarge),
                if (m.foto != null) ...[
                  const SizedBox(height: 8),
                  FotoCaja(
                    foto: m.foto!,
                    nombreMedicamento: m.nombre,
                    alto: 140,
                    nodoPropio: false,
                  ),
                ],
                if (m.dosis != null)
                  LineaDato(
                    icono: Icons.medication,
                    texto: t.medicamentoDosis(m.dosis!),
                  ),
                if (m.instrucciones != null)
                  LineaDato(icono: Icons.info_outline, texto: m.instrucciones!),
                if (m.describirLimites case final texto?)
                  LineaDato(icono: Icons.rule, texto: texto),
                LineaDato(
                  icono: tomas.isEmpty
                      ? Icons.radio_button_unchecked
                      : Icons.check_circle,
                  texto: tomas.isEmpty
                      ? t.tomasADemandaNingunaHoy
                      : t.tomasADemandaHoy(
                          tomas.length,
                          FormatoFechas.listaDeHoras([
                            for (final r in tomas) r.hora,
                          ]),
                        ),
                ),
                if (limites.maximoAlcanzado)
                  LineaDato(
                    icono: Icons.block,
                    texto: t.tomasADemandaMaximo(m.maximoAlDia!),
                  )
                else if (limites.proximaDesde case final desde?)
                  LineaDato(
                    icono: Icons.hourglass_top,
                    texto: textoProxima(t, desde, ahora),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Medidas.margen),
          BotonGrande(
            etiqueta: t.tomasADemandaMarcar,
            etiquetaSemantica: t.tomasADemandaMarcarSemantica(m.nombre),
            icono: Icons.check,
            onPressed: onTomar,
          ),
          if (tomas.isNotEmpty) ...[
            const SizedBox(height: 12),
            BotonGrande(
              etiqueta: t.tomasADemandaQuitar,
              descripcion: t.tomasDesmarcarDescripcion,
              etiquetaSemantica: t.tomasADemandaQuitarSemantica(
                m.nombre,
                tomas.last.hora.texto,
              ),
              icono: Icons.undo,
              onPressed: () => onQuitar(tomas.last),
            ),
          ],
        ],
      ),
    );
  }
}
