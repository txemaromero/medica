import '../../../core/tiempo/formato_fechas.dart';
import '../../../l10n/textos.dart';

/// Qué días se toma un medicamento: todos, algunos días de la semana (por
/// ejemplo, las pastillas semanales para los huesos) o cada varios días.
sealed class DiasDeToma {
  const DiasDeToma();

  /// `true` si [dia] es día de toma.
  bool incluye(DateTime dia);

  /// Texto para la base de datos y las copias de seguridad: `null` (todos
  /// los días), `semana:1,4` (lunes y jueves) o `cada:2:2026-10-26` (cada 2
  /// días desde esa fecha).
  String? codificar();

  /// Lo contrario de [codificar]. Lanza [FormatException] si el texto no es
  /// válido.
  static DiasDeToma decodificar(String? texto) {
    if (texto == null || texto.isEmpty) return const TodosLosDias();
    final partes = texto.split(':');
    switch (partes) {
      case ['semana', final dias]:
        final numeros = {for (final d in dias.split(',')) int.parse(d)};
        if (numeros.isEmpty ||
            numeros.any((d) => d < DateTime.monday || d > DateTime.sunday)) {
          throw FormatException('Días de la semana no válidos', texto);
        }
        return DiasDeLaSemana(numeros);
      case ['cada', final cada, final desde]:
        final n = int.parse(cada);
        if (n < CadaVariosDias.minimo || n > CadaVariosDias.maximo) {
          throw FormatException('Cada cuántos días no válido', texto);
        }
        return CadaVariosDias(
          cada: n,
          desde: FormatoFechas.desdeIsoFecha(desde),
        );
      default:
        throw FormatException('Días de toma no válidos', texto);
    }
  }

  /// En palabras, para meterlo en una frase ("Te avisaremos a las 08:00 …"):
  /// `los lunes y jueves` o `cada 2 días, empezando el domingo, 25 de
  /// octubre`. `null` si es todos los días.
  String? describir();
}

final class TodosLosDias extends DiasDeToma {
  const TodosLosDias();

  @override
  bool incluye(DateTime dia) => true;

  @override
  String? codificar() => null;

  @override
  String? describir() => null;

  @override
  bool operator ==(Object other) => other is TodosLosDias;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'TodosLosDias';
}

final class DiasDeLaSemana extends DiasDeToma {
  /// [dias] con los números de `DateTime`: 1 (lunes) a 7 (domingo).
  const DiasDeLaSemana(this.dias);

  final Set<int> dias;

  List<int> get _ordenados => [...dias]..sort();

  @override
  bool incluye(DateTime dia) => dias.contains(dia.weekday);

  @override
  String codificar() => 'semana:${_ordenados.join(',')}';

  @override
  String describir() {
    final t = textosApp;
    final nombres = [
      t.semanaLunes,
      t.semanaMartes,
      t.semanaMiercoles,
      t.semanaJueves,
      t.semanaViernes,
      t.semanaSabado,
      t.semanaDomingo,
    ];
    return t.diasSemanaFrase(
      FormatoFechas.lista([for (final d in _ordenados) nombres[d - 1]]),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DiasDeLaSemana && codificar() == other.codificar();

  @override
  int get hashCode => codificar().hashCode;

  @override
  String toString() => 'DiasDeLaSemana(${_ordenados.join(',')})';
}

final class CadaVariosDias extends DiasDeToma {
  const CadaVariosDias({required this.cada, required this.desde});

  static const int minimo = 2;
  static const int maximo = 30;

  final int cada;

  /// Primer día de toma (solo cuenta el día).
  final DateTime desde;

  @override
  bool incluye(DateTime dia) {
    final inicio = DateTime.utc(desde.year, desde.month, desde.day);
    final fecha = DateTime.utc(dia.year, dia.month, dia.day);
    if (fecha.isBefore(inicio)) return false;
    return fecha.difference(inicio).inDays % cada == 0;
  }

  @override
  String codificar() => 'cada:$cada:${FormatoFechas.isoFecha(desde)}';

  @override
  String describir() =>
      textosApp.diasCadaFrase('$cada', FormatoFechas.fechaCorta(desde));

  @override
  bool operator ==(Object other) =>
      other is CadaVariosDias && codificar() == other.codificar();

  @override
  int get hashCode => codificar().hashCode;

  @override
  String toString() => 'CadaVariosDias($cada, desde ${desde.toString()})';
}
