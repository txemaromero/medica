import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/campo_texto.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../application/existencias_controller.dart';
import '../application/medicamentos_controller.dart';
import '../domain/existencias.dart';
import '../domain/medicamento.dart';
import 'foto_caja.dart';

/// "He comprado más": suma a la cuenta de [medicamento] las pastillas que se
/// acaban de comprar.
class ComprarMasScreen extends ConsumerStatefulWidget {
  const ComprarMasScreen({super.key, required this.medicamento});

  final Medicamento medicamento;

  @override
  ConsumerState<ComprarMasScreen> createState() => _ComprarMasScreenState();
}

class _ComprarMasScreenState extends ConsumerState<ComprarMasScreen> {
  final _compradas = TextEditingController();
  String? _error;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    // El resumen ("Tendrás 31 pastillas.") cambia mientras se escribe.
    _compradas.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _compradas.dispose();
    super.dispose();
  }

  int? get _numero => int.tryParse(_compradas.text.trim());

  Future<void> _guardar(EstadoExistencias estado) async {
    final t = TextosApp.of(context);
    // Se compran cajas enteras: un número entero.
    final maximo = (Existencias.maximo - estado.quedan).floor();
    final compradas = _numero;
    if (compradas == null || compradas < 1 || compradas > maximo) {
      setState(() => _error = t.comprarError('$maximo'));
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _guardando = true;
    });
    final m = widget.medicamento;
    final total = estado.quedan + compradas;
    try {
      await ref
          .read(medicamentosProvider.notifier)
          .actualizar(
            m.conExistencias(
              Existencias(
                cantidad: total,
                contadas: ref.read(relojProvider)(),
                porToma: m.existencias!.porToma,
                porTomas: m.existencias!.porTomas,
              ),
            ),
          );
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
      titulo: t.comprarHechoTitulo,
      mensaje: t.comprarHecho(Existencias.describir(total), m.nombre),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final textos = Theme.of(context).textTheme;
    final m = widget.medicamento;
    final estado = ref.watch(existenciasProvider).value?[m.id];
    final numero = _numero;

    return PantallaBase(
      titulo: t.medicamentoComprarMas,
      pie: BotonGrande(
        etiqueta: _guardando ? t.formularioGuardando : t.comprarAnadir,
        icono: Icons.add_shopping_cart,
        centrado: true,
        onPressed: estado == null || _guardando ? null : () => _guardar(estado),
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
                if (estado != null)
                  LineaDato(
                    icono: Icons.inventory_2,
                    texto: estado.describir(),
                  ),
              ],
            ),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          CampoTexto(
            etiqueta: t.comprarCampo,
            descripcion: t.comprarCampoDescripcion,
            controller: _compradas,
            error: _error,
            teclado: TextInputType.number,
            formateadores: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            accion: TextInputAction.done,
          ),
          if (estado != null && numero != null && numero > 0) ...[
            const Hueco(),
            Semantics(
              container: true,
              liveRegion: true,
              child: TarjetaInfo(
                child: LineaDato(
                  icono: Icons.inventory_2,
                  texto: t.comprarTendras(
                    Existencias.describir(estado.quedan + numero),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
