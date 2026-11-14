import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/selectores_tiempo.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../application/medicamentos_controller.dart';
import '../domain/medicamento.dart';
import '../domain/receta.dart';
import 'foto_caja.dart';
import 'formulario_medicamento_screen.dart';

/// "Ya la he renovado": el último día de la receta nueva de [medicamento]
/// o, si ya no hace falta renovarla, quitar la fecha.
class RenovarRecetaScreen extends ConsumerStatefulWidget {
  const RenovarRecetaScreen({super.key, required this.medicamento});

  final Medicamento medicamento;

  @override
  ConsumerState<RenovarRecetaScreen> createState() =>
      _RenovarRecetaScreenState();
}

class _RenovarRecetaScreenState extends ConsumerState<RenovarRecetaScreen> {
  late final DateTime _hoy;
  late DateTime _fecha;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _hoy = FormatoFechas.soloFecha(ref.read(relojProvider)());
    _fecha = FormularioMedicamentoScreen.recetaPropuesta(_hoy);
  }

  Future<void> _guardar(DateTime? fecha) async {
    if (_guardando) return;
    final t = TextosApp.of(context);
    final m = widget.medicamento;
    setState(() => _guardando = true);
    try {
      await ref
          .read(medicamentosProvider.notifier)
          .actualizar(m.conReceta(fecha));
    } on Object {
      if (mounted) {
        setState(() => _guardando = false);
        mostrarAviso(
          context,
          t.formularioMedicamentoErrorGuardar,
          icono: Icons.error,
        );
      }
      return;
    }
    if (!mounted) return;
    await mostrarConfirmacion(
      context,
      titulo: t.recetaTitulo,
      mensaje: fecha == null
          ? t.recetaQuitada(m.nombre)
          : t.recetaGuardada(m.nombre, FormatoFechas.fechaLarga(fecha)),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final textos = Theme.of(context).textTheme;
    final m = widget.medicamento;
    final ahora = ref.watch(relojProvider)();

    return PantallaBase(
      titulo: t.recetaTitulo,
      pie: BotonGrande(
        etiqueta: _guardando ? t.formularioGuardando : t.recetaGuardar,
        icono: Icons.save,
        centrado: true,
        onPressed: _guardando ? null : () => _guardar(_fecha),
      ),
      cuerpo: Column(
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
                if (m.renovarReceta != null)
                  LineaDato(
                    icono: Icons.description,
                    texto: Receta.describir(m, ahora),
                  ),
              ],
            ),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          Parrafo(t.recetaPregunta, estilo: textos.titleLarge),
          const Hueco(),
          SelectorFecha(
            etiqueta: t.formularioMedicamentoRecetaFecha,
            descripcion: t.formularioMedicamentoRecetaFechaDescripcion,
            fecha: _fecha,
            hoy: _hoy,
            primerDia: _hoy,
            ultimoDia: DateTime(_hoy.year + 2, _hoy.month, _hoy.day),
            onChanged: (fecha) => setState(() => _fecha = fecha),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          BotonGrande(
            etiqueta: t.recetaQuitar,
            descripcion: t.recetaQuitarDescripcion,
            icono: Icons.event_busy,
            onPressed: _guardando ? null : () => _guardar(null),
          ),
        ],
      ),
    );
  }
}
