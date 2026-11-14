import 'package:flutter/material.dart';

import '../../l10n/textos.dart';
import '../tema/paleta.dart';
import '../tema/tema_visual.dart';
import 'botones.dart';

/// Interruptor grande de ajustes: verde = activado, rojo = desactivado.
///
/// El estado nunca se comunica solo con color: el mando lleva un icono
/// (✓ / ✕) y al lado se escribe "Activado" o "Desactivado". Toda la tarjeta
/// es pulsable.
class InterruptorGrande extends StatelessWidget {
  const InterruptorGrande({
    super.key,
    required this.etiqueta,
    required this.descripcion,
    required this.valor,
    required this.onChanged,
  });

  final String etiqueta;
  final String descripcion;
  final bool valor;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final textos = Theme.of(context).textTheme;
    final alPulsar = onChanged == null ? null : () => onChanged!(!valor);
    final t = TextosApp.of(context);
    final estado = valor ? t.interruptorActivado : t.interruptorDesactivado;

    return Semantics(
      container: true,
      toggled: valor,
      enabled: onChanged != null,
      label: etiqueta,
      value: estado,
      hint: descripcion,
      onTap: alPulsar,
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        child: SuperficiePulsable(
          onPressed: alPulsar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: textos.titleMedium!.copyWith(color: p.textoBoton),
              ),
              const SizedBox(height: 6),
              Text(
                descripcion,
                style: textos.bodyLarge!.copyWith(color: p.textoBoton),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _Mando(valor: valor),
                  Text(
                    estado,
                    style: textos.titleMedium!.copyWith(
                      color: p.textoBoton,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Mando extends StatelessWidget {
  const _Mando({required this.valor});

  final bool valor;

  static const double _ancho = 104;
  static const double _alto = 56;
  static const double _bola = 44;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final color = valor ? p.exito : p.peligro;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _ancho,
      height: _alto,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_alto / 2),
        border: Border.all(color: p.borde, width: Medidas.grosorBorde),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 150),
        alignment: valor ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: _bola,
          height: _bola,
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            valor ? Icons.check : Icons.close,
            size: 30,
            color: color,
          ),
        ),
      ),
    );
  }
}
