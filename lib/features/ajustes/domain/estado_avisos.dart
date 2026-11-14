/// Lo que el teléfono hace con la batería de la app.
class EstadoBateria {
  const EstadoBateria({
    this.optimizada = false,
    this.restringida = false,
    this.fabricante = '',
  });

  /// Android aplica a la app la optimización de batería (lo normal).
  final bool optimizada;

  /// La persona ha restringido la app en segundo plano (Android 9+).
  final bool restringida;

  /// Fabricante del teléfono en minúsculas, por ejemplo `samsung`.
  final String fabricante;
}

/// Lo que puede impedir o retrasar los avisos, de más a menos grave.
enum ProblemaAvisos {
  /// El teléfono no deja a la app mostrar avisos: no llega ninguno. Pasa si
  /// se quita el permiso en los ajustes del teléfono o al recuperar los datos
  /// en un móvil nuevo con la copia automática de Android, que no traspasa
  /// los permisos.
  sinPermiso,

  /// Falta el permiso de alarmas exactas: llegan con unos minutos de retraso.
  sinHoraExacta,

  /// El ahorro de batería puede retrasarlos o impedir que lleguen.
  ahorroBateria,
}

/// Si los avisos pueden llegar a su hora.
class EstadoAvisos {
  const EstadoAvisos({
    required this.activados,
    this.permiso = true,
    this.horaExacta = true,
    this.bateria = const EstadoBateria(),
  });

  /// "Activar notificaciones" está encendido en Ajustes.
  final bool activados;

  /// El teléfono deja a la app mostrar avisos.
  final bool permiso;

  /// El teléfono deja programarlos a la hora exacta.
  final bool horaExacta;

  final EstadoBateria bateria;

  /// Fabricantes que cierran las apps en segundo plano para ahorrar batería
  /// aunque Android no lo haga (ver dontkillmyapp.com). En el resto, la
  /// optimización normal de Android no retrasa los avisos a hora exacta.
  static const Set<String> fabricantesEstrictos = {
    'samsung',
    'xiaomi',
    'huawei',
    'honor',
    'oppo',
    'realme',
    'vivo',
    'oneplus',
    'meizu',
  };

  /// Lo que habría que arreglar. Con los avisos desactivados no hay nada que
  /// comprobar.
  List<ProblemaAvisos> get problemas => [
    if (activados && !permiso) ProblemaAvisos.sinPermiso,
    if (activados && !horaExacta) ProblemaAvisos.sinHoraExacta,
    if (activados &&
        (bateria.restringida ||
            bateria.optimizada &&
                fabricantesEstrictos.contains(bateria.fabricante)))
      ProblemaAvisos.ahorroBateria,
  ];
}
