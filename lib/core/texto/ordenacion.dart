/// Comparación de textos sin distinguir mayúsculas ni tildes, para ordenar
/// alfabéticamente como espera una persona ("Ácido" junto a "Aspirina").
int compararTextos(String a, String b) =>
    _normalizar(a).compareTo(_normalizar(b));

String _normalizar(String texto) {
  const conTilde = 'áàäâéèëêíìïîóòöôúùüûñç';
  const sinTilde = 'aaaaeeeeiiiioooouuuunc';
  final buffer = StringBuffer();
  for (final caracter in texto.toLowerCase().split('')) {
    final i = conTilde.indexOf(caracter);
    buffer.write(i >= 0 ? sinTilde[i] : caracter);
  }
  return buffer.toString();
}
