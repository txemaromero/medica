/// Reglas del tamaño de texto ajustable: de 10 a 35 puntos en pasos de 5,
/// con 20 como tamaño base.
abstract final class TamanoTexto {
  static const int minimo = 10;
  static const int maximo = 35;
  static const int base = 20;
  static const int paso = 5;

  static const List<int> valoresPermitidos = [10, 15, 20, 25, 30, 35];

  static bool puedeAumentar(int actual) => actual < maximo;
  static bool puedeReducir(int actual) => actual > minimo;

  static int aumentar(int actual) => normalizar(actual + paso);
  static int reducir(int actual) => normalizar(actual - paso);

  /// Ajusta cualquier valor (por ejemplo, uno guardado por una versión
  /// anterior) al valor permitido más cercano.
  static int normalizar(int valor) {
    final pasos = ((valor - base) / paso).round();
    return (base + pasos * paso).clamp(minimo, maximo);
  }

  /// Factor por el que se multiplica todo el texto de la aplicación.
  static double factorEscala(int tamano) => normalizar(tamano) / base;
}
