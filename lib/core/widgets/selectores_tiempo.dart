import 'package:flutter/material.dart';

import '../../l10n/textos.dart';
import '../tema/paleta.dart';
import '../tema/tema_visual.dart';
import '../tiempo/formato_fechas.dart';
import '../tiempo/hora_del_dia.dart';
import 'botones.dart';
import 'parrafo.dart';
import 'selector_numerico.dart';

/// Marco común de los selectores de hora y fecha: etiqueta grande, resumen
/// en palabras de lo elegido y los controles.
class _MarcoSelector extends StatelessWidget {
  const _MarcoSelector({
    required this.etiqueta,
    required this.resumen,
    required this.controles,
    this.descripcion,
    this.conError = false,
  });

  final String etiqueta;
  final String? descripcion;
  final String resumen;
  final List<Widget> controles;
  final bool conError;

  @override
  Widget build(BuildContext context) {
    final p = Paleta.of(context);
    final textos = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Medidas.margen),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Medidas.radio),
        border: Border.all(
          color: conError ? p.bordeError : p.texto,
          width: conError ? 4 : Medidas.grosorBorde,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            container: true,
            header: true,
            child: Text(etiqueta, style: textos.titleLarge),
          ),
          if (descripcion != null) ...[
            const SizedBox(height: 6),
            Parrafo(descripcion!),
          ],
          const SizedBox(height: 12),
          Semantics(
            container: true,
            liveRegion: true,
            child: Text(
              resumen,
              style: textos.titleMedium!.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          for (final control in controles) ...[
            const SizedBox(height: 16),
            control,
          ],
        ],
      ),
    );
  }
}

/// Selector de hora con botones grandes para horas y minutos.
class SelectorHora extends StatelessWidget {
  const SelectorHora({
    super.key,
    required this.etiqueta,
    required this.hora,
    required this.onChanged,
    this.descripcion,
    this.pasoMinutos = 5,
    this.conError = false,
  });

  final String etiqueta;
  final String? descripcion;
  final HoraDelDia hora;
  final ValueChanged<HoraDelDia> onChanged;
  final int pasoMinutos;
  final bool conError;

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final minutosRedondeados = hora.minuto - hora.minuto % pasoMinutos;
    return _MarcoSelector(
      etiqueta: etiqueta,
      descripcion: descripcion,
      conError: conError,
      resumen: t.selectorHoraElegida(FormatoFechas.horaConParteDelDia(hora)),
      controles: [
        SelectorNumerico(
          etiqueta: t.selectorHora,
          valor: hora.hora.toString().padLeft(2, '0'),
          valorSemantico: t.selectorHoraValor('${hora.hora}'),
          etiquetaMenos: t.selectorRestarHora,
          etiquetaMas: t.selectorSumarHora,
          onMenos: () =>
              onChanged(HoraDelDia((hora.hora + 23) % 24, hora.minuto)),
          onMas: () => onChanged(HoraDelDia((hora.hora + 1) % 24, hora.minuto)),
        ),
        SelectorNumerico(
          etiqueta: t.selectorMinutos,
          valor: hora.minuto.toString().padLeft(2, '0'),
          valorSemantico: t.selectorMinutosValor('${hora.minuto}'),
          etiquetaMenos: t.selectorRestarMinutos('$pasoMinutos'),
          etiquetaMas: t.selectorSumarMinutos('$pasoMinutos'),
          onMenos: () => onChanged(
            HoraDelDia(hora.hora, (minutosRedondeados - pasoMinutos) % 60),
          ),
          onMas: () => onChanged(
            HoraDelDia(hora.hora, (minutosRedondeados + pasoMinutos) % 60),
          ),
        ),
      ],
    );
  }
}

/// Selector de fecha con botones grandes para día, mes y año.
///
/// No permite elegir días anteriores a [primerDia] ni posteriores a
/// [ultimoDia]: los botones que llevarían fuera del rango se desactivan.
class SelectorFecha extends StatelessWidget {
  const SelectorFecha({
    super.key,
    required this.etiqueta,
    required this.fecha,
    required this.primerDia,
    required this.ultimoDia,
    required this.hoy,
    required this.onChanged,
    this.descripcion,
    this.conError = false,
  });

  final String etiqueta;
  final String? descripcion;
  final DateTime fecha;
  final DateTime primerDia;
  final DateTime ultimoDia;
  final DateTime hoy;
  final ValueChanged<DateTime> onChanged;
  final bool conError;

  static int _diasDelMes(int anio, int mes) => DateTime(anio, mes + 1, 0).day;

  /// Misma fecha desplazada [meses] meses; si el día no existe en el mes de
  /// destino (31 de abril), se usa el último día de ese mes.
  static DateTime sumarMeses(DateTime fecha, int meses) {
    final destino = DateTime(fecha.year, fecha.month + meses);
    final dia = fecha.day.clamp(1, _diasDelMes(destino.year, destino.month));
    return DateTime(destino.year, destino.month, dia);
  }

  VoidCallback? _si(DateTime candidata) {
    final dia = FormatoFechas.soloFecha(candidata);
    if (dia.isBefore(FormatoFechas.soloFecha(primerDia)) ||
        dia.isAfter(FormatoFechas.soloFecha(ultimoDia))) {
      return null;
    }
    return () => onChanged(dia);
  }

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    final f = FormatoFechas.soloFecha(fecha);
    final h = FormatoFechas.soloFecha(hoy);
    // Atajos para las fechas más habituales: evitan pulsar "+" muchas veces.
    final atajos = {
      t.selectorAtajoHoy: h,
      t.selectorAtajoManana: DateTime(h.year, h.month, h.day + 1),
      t.selectorAtajoEnUnaSemana: DateTime(h.year, h.month, h.day + 7),
    };
    return _MarcoSelector(
      etiqueta: etiqueta,
      descripcion: descripcion,
      conError: conError,
      resumen: t.selectorDiaElegido(FormatoFechas.fechaRelativa(f, hoy)),
      controles: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final MapEntry(key: texto, value: dia) in atajos.entries)
              _Atajo(texto: texto, elegido: dia == f, onPressed: _si(dia)),
          ],
        ),
        SelectorNumerico(
          etiqueta: t.selectorDia,
          valor: '${f.day}',
          etiquetaMenos: t.selectorDiaAnterior,
          etiquetaMas: t.selectorDiaSiguiente,
          onMenos: _si(DateTime(f.year, f.month, f.day - 1)),
          onMas: _si(DateTime(f.year, f.month, f.day + 1)),
        ),
        SelectorNumerico(
          etiqueta: t.selectorMes,
          valor: FormatoFechas.nombreMes(f.month),
          etiquetaMenos: t.selectorMesAnterior,
          etiquetaMas: t.selectorMesSiguiente,
          onMenos: _si(sumarMeses(f, -1)),
          onMas: _si(sumarMeses(f, 1)),
        ),
        SelectorNumerico(
          etiqueta: t.selectorAnio,
          valor: '${f.year}',
          etiquetaMenos: t.selectorAnioAnterior,
          etiquetaMas: t.selectorAnioSiguiente,
          onMenos: _si(sumarMeses(f, -12)),
          onMas: _si(sumarMeses(f, 12)),
        ),
      ],
    );
  }
}

class _Atajo extends StatelessWidget {
  const _Atajo({
    required this.texto,
    required this.elegido,
    required this.onPressed,
  });

  final String texto;
  final bool elegido;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      selected: elegido,
      enabled: onPressed != null,
      label: TextosApp.of(context).selectorElegir(texto),
      onTap: onPressed,
      excludeSemantics: true,
      child: SuperficiePulsable(
        onPressed: onPressed,
        seleccionado: elegido,
        relleno: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextoConMarca(
          texto: texto,
          elegido: elegido,
          activo: onPressed != null,
        ),
      ),
    );
  }
}
