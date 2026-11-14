import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../core/widgets/estado_carga.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../../medicamentos/application/medicamentos_controller.dart';
import '../../medicamentos/domain/medicamento.dart';
import '../application/tomas_controller.dart';
import '../domain/registro_toma.dart';
import '../domain/tomas_del_dia.dart';
import 'tomas_hoy_screen.dart';

/// "Historial de tomas": qué se marcó cada día de los últimos 7, empezando
/// por hoy. Útil también para enseñárselo al médico o a la familia.
class HistorialTomasScreen extends ConsumerWidget {
  const HistorialTomasScreen({super.key});

  static String _hora(DateTime momento) =>
      HoraDelDia(momento.hour, momento.minute).texto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = TextosApp.of(context);
    final ahora = ref.watch(relojProvider)();
    final hoy = FormatoFechas.soloFecha(ahora);

    return PantallaBase(
      titulo: t.historialTitulo,
      cuerpo: EstadoCarga<List<Medicamento>>(
        valor: ref.watch(medicamentosProvider),
        mensajeError: t.errorCargarMedicamentos,
        conDatos: (medicamentos) => EstadoCarga<List<RegistroToma>>(
          valor: ref.watch(tomasProvider),
          mensajeError: t.historialErrorCarga,
          conDatos: (registros) {
            final dias = <Widget>[];
            for (var d = 0; d < TomasController.diasHistorial; d++) {
              final dia = DateTime(hoy.year, hoy.month, hoy.day - d);
              final tomas = TomasDelDia.calcular(
                medicamentos: medicamentos,
                registros: registros,
                dia: dia,
                ahora: ahora,
              );
              final sueltos = TomasDelDia.registrosSueltos(
                tomas: tomas,
                registros: registros,
                dia: dia,
                medicamentos: medicamentos,
              );
              final aDemanda = TomasDelDia.tomasADemanda(
                medicamentos: medicamentos,
                registros: registros,
                dia: dia,
              );
              if (tomas.isEmpty && sueltos.isEmpty && aDemanda.isEmpty) {
                continue;
              }
              dias.add(
                _Dia(
                  dia: dia,
                  ahora: ahora,
                  tomas: tomas,
                  sueltos: sueltos,
                  aDemanda: aDemanda,
                ),
              );
            }
            if (dias.isEmpty) {
              return EstadoVacio(
                icono: Icons.history,
                mensaje: t.historialVacio,
                explicacion: t.historialVacioExplicacion,
              );
            }
            final (:tomadas, :total) = TomasDelDia.resumen(
              medicamentos: medicamentos,
              registros: registros,
              ahora: ahora,
              dias: TomasController.diasHistorial,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Parrafo(
                  total == 0
                      ? t.historialUltimosDias(
                          '${TomasController.diasHistorial}',
                        )
                      : t.historialResumenSemana(
                          '$tomadas',
                          '$total',
                          '${TomasDelDia.porcentaje(tomadas, total)}',
                        ),
                ),
                for (final dia in dias) ...[const Hueco(), dia],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Dia extends StatelessWidget {
  const _Dia({
    required this.dia,
    required this.ahora,
    required this.tomas,
    required this.sueltos,
    required this.aDemanda,
  });

  final DateTime dia;
  final DateTime ahora;
  final List<TomaDelDia> tomas;
  final List<RegistroToma> sueltos;

  /// Tomas de los medicamentos "cuando haga falta": no cuentan en "Marcadas:
  /// 2 de 3", porque no estaban previstas.
  final List<RegistroToma> aDemanda;

  String _texto(TextosApp t, TomaDelDia toma) {
    final hora = toma.hora.texto;
    final nombre = toma.medicamento.nombre;
    return switch (toma.estado) {
      EstadoTomaDelDia.tomada => t.historialTomada(
        hora,
        nombre,
        HistorialTomasScreen._hora(toma.registro!.momento),
      ),
      EstadoTomaDelDia.aplazada => t.historialAplazada(hora, nombre),
      EstadoTomaDelDia.pendiente => t.historialPendiente(hora, nombre),
      EstadoTomaDelDia.sinMarcar => t.historialSinMarcar(hora, nombre),
    };
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final tomadas =
        tomas.where((toma) => toma.estado == EstadoTomaDelDia.tomada).length +
        sueltos.length;
    final total = tomas.length + sueltos.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(
            FormatoFechas.fechaRelativa(dia, ahora),
            style: textos.titleLarge,
          ),
        ),
        if (total > 0) ...[
          const SizedBox(height: 4),
          Parrafo(t.historialMarcadas('$tomadas', '$total')),
        ],
        const SizedBox(height: 8),
        TarjetaInfo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cada línea es un nodo propio para TalkBack.
              for (final toma in tomas)
                Semantics(
                  container: true,
                  child: LineaDato(
                    icono: TarjetaToma.iconoEstado(toma.estado),
                    texto: _texto(t, toma),
                  ),
                ),
              for (final registro in sueltos)
                LineaDato(
                  icono: Icons.check_circle,
                  texto: t.historialTomada(
                    registro.hora.texto,
                    registro.nombreMedicamento,
                    HistorialTomasScreen._hora(registro.momento),
                  ),
                ),
              for (final registro in aDemanda)
                Semantics(
                  container: true,
                  child: LineaDato(
                    icono: Icons.check_circle,
                    texto: t.historialADemanda(
                      registro.hora.texto,
                      registro.nombreMedicamento,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
