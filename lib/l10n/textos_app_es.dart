// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class TextosAppEs extends TextosApp {
  TextosAppEs([String locale = 'es']) : super(locale);

  @override
  String get fechaLunes => 'lunes';

  @override
  String get fechaMartes => 'martes';

  @override
  String get fechaMiercoles => 'miércoles';

  @override
  String get fechaJueves => 'jueves';

  @override
  String get fechaViernes => 'viernes';

  @override
  String get fechaSabado => 'sábado';

  @override
  String get fechaDomingo => 'domingo';

  @override
  String get fechaEnero => 'enero';

  @override
  String get fechaFebrero => 'febrero';

  @override
  String get fechaMarzo => 'marzo';

  @override
  String get fechaAbril => 'abril';

  @override
  String get fechaMayo => 'mayo';

  @override
  String get fechaJunio => 'junio';

  @override
  String get fechaJulio => 'julio';

  @override
  String get fechaAgosto => 'agosto';

  @override
  String get fechaSeptiembre => 'septiembre';

  @override
  String get fechaOctubre => 'octubre';

  @override
  String get fechaNoviembre => 'noviembre';

  @override
  String get fechaDiciembre => 'diciembre';

  @override
  String fechaLarga(String diaSemana, String dia, String mes, String anio) {
    return '$diaSemana, $dia de $mes de $anio';
  }

  @override
  String fechaHoy(String fecha) {
    return 'Hoy, $fecha';
  }

  @override
  String fechaManana(String fecha) {
    return 'Mañana, $fecha';
  }

  @override
  String fechaAyer(String fecha) {
    return 'Ayer, $fecha';
  }

  @override
  String fechaCuandoHoy(String hora) {
    return 'hoy a las $hora';
  }

  @override
  String fechaCuandoManana(String hora) {
    return 'mañana a las $hora';
  }

  @override
  String fechaCuandoOtroDia(
    String diaSemana,
    String dia,
    String mes,
    String hora,
  ) {
    return 'el $diaSemana, $dia de $mes, a las $hora';
  }

  @override
  String get fechaDeLaMadrugada => 'de la madrugada';

  @override
  String get fechaDeLaManana => 'de la mañana';

  @override
  String get fechaDelMediodia => 'del mediodía';

  @override
  String get fechaDeLaTarde => 'de la tarde';

  @override
  String get fechaDeLaNoche => 'de la noche';

  @override
  String fechaHoraConParteDelDia(String hora, String parteDelDia) {
    return '$hora $parteDelDia';
  }

  @override
  String fechaListaUltimo(String anteriores, String ultimo) {
    return '$anteriores y $ultimo';
  }

  @override
  String get fechaSeparadorLista => ', ';

  @override
  String get appTitulo => 'Salud y Medicación';

  @override
  String get avisoDeshecho => 'Hecho. Se ha deshecho la acción.';

  @override
  String get avisoNoSeHaPodidoDeshacer =>
      'No se ha podido deshacer. Inténtalo otra vez.';

  @override
  String get botonDeshacer => 'Deshacer';

  @override
  String get botonDeshacerPista => 'Deshace lo que acabas de hacer';

  @override
  String get botonDeshacerPistaEliminar => 'Recupera lo que acabas de eliminar';

  @override
  String get barraInicio => 'Inicio';

  @override
  String get barraAtras => 'Atrás';

  @override
  String get barraInicioSemantica => 'Inicio. Volver al menú principal';

  @override
  String get barraAtrasSemantica => 'Atrás. Volver a la pantalla anterior';

  @override
  String get interruptorActivado => 'Activado';

  @override
  String get interruptorDesactivado => 'Desactivado';

  @override
  String selectorValor(String etiqueta, String valor) {
    return '$etiqueta: $valor';
  }

  @override
  String get cargando => 'Cargando…';

  @override
  String mensajeError(String texto) {
    return 'Error: $texto';
  }

  @override
  String get dialogoSiEliminar => 'Sí, eliminar';

  @override
  String get dialogoNoVolver => 'No, volver';

  @override
  String get dialogoAceptar => 'Aceptar';

  @override
  String get dialogoEntendido => 'Entendido';

  @override
  String get dialogoAhoraNo => 'Ahora no';

  @override
  String selectorHoraElegida(String hora) {
    return 'Hora elegida: $hora';
  }

  @override
  String get selectorHora => 'Hora';

  @override
  String selectorHoraValor(String hora) {
    return '$hora horas';
  }

  @override
  String get selectorRestarHora => 'Restar una hora';

  @override
  String get selectorSumarHora => 'Sumar una hora';

  @override
  String get selectorMinutos => 'Minutos';

  @override
  String selectorMinutosValor(String minutos) {
    return '$minutos minutos';
  }

  @override
  String selectorRestarMinutos(String minutos) {
    return 'Restar $minutos minutos';
  }

  @override
  String selectorSumarMinutos(String minutos) {
    return 'Sumar $minutos minutos';
  }

  @override
  String get selectorAtajoHoy => 'Hoy';

  @override
  String get selectorAtajoManana => 'Mañana';

  @override
  String get selectorAtajoEnUnaSemana => 'En una semana';

  @override
  String selectorDiaElegido(String fecha) {
    return 'Día elegido: $fecha';
  }

  @override
  String get selectorDia => 'Día';

  @override
  String get selectorDiaAnterior => 'Día anterior';

  @override
  String get selectorDiaSiguiente => 'Día siguiente';

  @override
  String get selectorMes => 'Mes';

  @override
  String get selectorMesAnterior => 'Mes anterior';

  @override
  String get selectorMesSiguiente => 'Mes siguiente';

  @override
  String get selectorAnio => 'Año';

  @override
  String get selectorAnioAnterior => 'Año anterior';

  @override
  String get selectorAnioSiguiente => 'Año siguiente';

  @override
  String selectorElegir(String texto) {
    return 'Elegir: $texto';
  }

  @override
  String get menuTitulo => 'Menú principal';

  @override
  String get menuPregunta => '¿Qué quieres hacer?';

  @override
  String get menuMedicamentos => 'Registro de medicamentos';

  @override
  String get menuAgenda => 'Agenda';

  @override
  String get menuEmergencias => 'Botón de emergencias';

  @override
  String get menuAjustes => 'Ajustes';

  @override
  String menuTomasDeHoy(String tomadas, String total) {
    return 'Tomas de hoy: $tomadas de $total marcadas.';
  }

  @override
  String menuProximaToma(String medicamento, String cuando) {
    return 'Próxima toma: $medicamento, $cuando.';
  }

  @override
  String menuProximaCita(String cita, String cuando) {
    return 'Próxima cita: $cita, $cuando.';
  }

  @override
  String get tomasTitulo => 'Tomas de hoy';

  @override
  String get medicamentosMenuTomasDescripcion =>
      'Marca las medicinas que ya has tomado hoy.';

  @override
  String get medicamentosMenuNuevo => 'Registrar nuevo medicamento';

  @override
  String get medicamentosMenuNuevoDescripcion =>
      'Apunta una medicina y te avisaremos cuando tengas que tomarla.';

  @override
  String get medicamentosMenuVer => 'Ver medicamentos registrados';

  @override
  String get medicamentosMenuVerDescripcion =>
      'Consulta tus medicinas y sus horas, cámbialas o borra las que ya no tomes.';

  @override
  String get historialTitulo => 'Historial de tomas';

  @override
  String get medicamentosMenuHistorialDescripcion =>
      'Mira qué tomas marcaste en los últimos 7 días.';

  @override
  String get medicamentosMenuCompartir =>
      'Compartir con el médico o la familia';

  @override
  String get medicamentosMenuCompartirDescripcion =>
      'Envía o imprime tus medicinas, tus tomas y tus citas.';

  @override
  String get listaMedicamentosTitulo => 'Medicamentos registrados';

  @override
  String get listaMedicamentosPreguntaEliminar =>
      '¿Seguro que quieres eliminar este medicamento?';

  @override
  String listaMedicamentosDetalleEliminar(String medicamento) {
    return '$medicamento\n\nTambién se borrarán sus avisos.';
  }

  @override
  String get listaMedicamentosErrorEliminar =>
      'No se ha podido eliminar el medicamento. Inténtalo otra vez.';

  @override
  String listaMedicamentosEliminado(String medicamento) {
    return 'Medicamento eliminado: $medicamento';
  }

  @override
  String listaMedicamentosRecuperado(String medicamento) {
    return 'Medicamento recuperado: $medicamento';
  }

  @override
  String get listaMedicamentosVacio =>
      'Todavía no has registrado ningún medicamento';

  @override
  String get listaMedicamentosVacioExplicacion =>
      'Cuando registres uno, aparecerá aquí con sus horas de toma.';

  @override
  String listaMedicamentosCuantos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Tienes $cantidad medicamentos registrados.',
      one: 'Tienes 1 medicamento registrado.',
    );
    return '$_temp0';
  }

  @override
  String get medicamentoSinFechaDeFin => 'Cada día, sin fecha de fin';

  @override
  String medicamentoTerminadoEl(String fecha) {
    return 'Tratamiento terminado el $fecha';
  }

  @override
  String medicamentoRecetaHasta(String fecha) {
    return 'Receta: hasta el $fecha';
  }

  @override
  String medicamentoRecetaPronto(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other:
          'La receta se acaba dentro de $dias días: pide cita con tu médico para renovarla',
      one: 'La receta se acaba mañana: pide cita con tu médico para renovarla',
      zero: 'La receta se acaba hoy: pide cita con tu médico para renovarla',
    );
    return '$_temp0';
  }

  @override
  String medicamentoRecetaAcabada(String fecha) {
    return 'La receta se acabó el $fecha: pide cita con tu médico para renovarla';
  }

  @override
  String get medicamentoRecetaRenovada => 'Ya la he renovado';

  @override
  String medicamentoRecetaRenovadaSemantica(String medicamento) {
    return 'Ya he renovado la receta de $medicamento';
  }

  @override
  String medicamentoHastaEl(String fecha) {
    return 'Hasta el $fecha, incluido';
  }

  @override
  String medicamentoDosis(String dosis) {
    return 'Dosis: $dosis';
  }

  @override
  String medicamentoDosisALas(String dosis, String hora) {
    return '$dosis a las $hora';
  }

  @override
  String medicamentoHoras(String horas) {
    return 'Horas: $horas';
  }

  @override
  String get botonModificar => 'Modificar';

  @override
  String botonModificarSemantica(String nombre) {
    return 'Modificar $nombre';
  }

  @override
  String get botonEliminar => 'Eliminar';

  @override
  String botonEliminarSemantica(String nombre) {
    return 'Eliminar $nombre';
  }

  @override
  String get formularioMedicamentoTituloNuevo => 'Nuevo medicamento';

  @override
  String get formularioMedicamentoTituloModificar => 'Modificar medicamento';

  @override
  String get formularioMedicamentoCrear => 'Crear recordatorio';

  @override
  String get formularioGuardarCambios => 'Guardar cambios';

  @override
  String get formularioMedicamentoGuardado =>
      'Medicamento guardado correctamente';

  @override
  String get formularioCambiosGuardados => 'Cambios guardados correctamente';

  @override
  String formularioFotoAnadida(String boton) {
    return 'Foto añadida. Se guardará al pulsar \"$boton\".';
  }

  @override
  String get formularioErrorFotoCamara =>
      'No se ha podido hacer la foto. Inténtalo otra vez.';

  @override
  String get formularioErrorFotoGaleria =>
      'No se ha podido abrir la galería. Inténtalo otra vez.';

  @override
  String formularioFotoQuitada(String boton) {
    return 'Foto quitada. El cambio se guardará al pulsar \"$boton\".';
  }

  @override
  String get formularioMedicamentoErrorGuardar =>
      'No se ha podido guardar el medicamento. Inténtalo otra vez.';

  @override
  String formularioMedicamentoResumenGuardado(
    String medicamento,
    String tomas,
    String horas,
  ) {
    return '$medicamento: $tomas.\nHoras de toma: $horas.';
  }

  @override
  String formularioMedicamentoUltimoDia(String fecha) {
    return 'Último día: $fecha.';
  }

  @override
  String get avisosDesactivadosEnAjustes =>
      'Los avisos están desactivados. Puedes activarlos en Ajustes.';

  @override
  String formularioMedicamentoAvisoCadaDia(String horas) {
    return 'Te avisaremos cada día a las $horas.';
  }

  @override
  String formularioMedicamentoAvisoHasta(String horas, String fecha) {
    return 'Te avisaremos a las $horas hasta el $fecha, incluido.';
  }

  @override
  String get formularioGuardando => 'Guardando…';

  @override
  String formularioRellenaYPulsa(String boton) {
    return 'Rellena los datos y pulsa \"$boton\".';
  }

  @override
  String get formularioMedicamentoNombre => 'Nombre del medicamento';

  @override
  String get formularioMedicamentoNombreDescripcion =>
      'Por ejemplo: Paracetamol.';

  @override
  String get formularioMedicamentoDictarNombre => 'Dictar el nombre';

  @override
  String get formularioMedicamentoDictarNombreIndicacion =>
      'Di el nombre del medicamento';

  @override
  String get formularioMedicamentoDosis => 'Dosis (opcional)';

  @override
  String get formularioMedicamentoDosisDescripcion =>
      'Cuánto tomas cada vez. Por ejemplo: 1 pastilla.';

  @override
  String formularioMedicamentoDosisEnCadaToma(String seccion) {
    return 'La dosis cambia según la hora: la de cada toma está más abajo, en \"$seccion\".';
  }

  @override
  String get formularioMedicamentoDosisTomasTitulo => 'Dosis en cada toma';

  @override
  String get formularioMedicamentoDosisTomasDescripcion =>
      'Si cambia según la hora; por ejemplo, una pastilla por la mañana y media por la noche.';

  @override
  String get formularioMedicamentoDosisIgual => 'La misma en todas';

  @override
  String get formularioMedicamentoDosisIgualDescripcion =>
      'La de arriba, en el campo de la dosis.';

  @override
  String get formularioMedicamentoDosisDistinta => 'Distinta según la hora';

  @override
  String get formularioMedicamentoDosisDistintaDescripcion =>
      'Escribe abajo la de cada toma.';

  @override
  String formularioMedicamentoDosisDeLas(String hora) {
    return 'Dosis de las $hora';
  }

  @override
  String get formularioMedicamentoInstrucciones => 'Instrucciones (opcional)';

  @override
  String get formularioMedicamentoInstruccionesDescripcion =>
      'Por ejemplo: con el desayuno.';

  @override
  String get formularioMedicamentoFoto => 'Foto de la caja (opcional)';

  @override
  String get formularioMedicamentoFotoDescripcion =>
      'Así reconocerás el medicamento de un vistazo.';

  @override
  String get formularioMedicamentoHacerFoto => 'Hacer una foto';

  @override
  String get formularioMedicamentoHacerOtraFoto => 'Hacer otra foto';

  @override
  String get formularioMedicamentoHacerFotoDescripcion =>
      'Con la cámara del teléfono.';

  @override
  String get formularioMedicamentoElegirGaleria => 'Elegir de la galería';

  @override
  String get formularioMedicamentoElegirOtraGaleria =>
      'Elegir otra de la galería';

  @override
  String get formularioMedicamentoGaleriaDescripcion =>
      'Una foto que ya tengas en el teléfono.';

  @override
  String get formularioMedicamentoQuitarFoto => 'Quitar la foto';

  @override
  String get formularioMedicamentoNumeroTomas => 'Número de tomas al día';

  @override
  String get formularioMedicamentoNumeroTomasDescripcion =>
      '¿Cuántas veces al día lo tomas?';

  @override
  String get formularioMedicamentoTomasAlDia => 'Tomas al día';

  @override
  String formularioMedicamentoTomasValor(int tomas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas tomas',
      one: '1 toma',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoTomaMenos => 'Una toma menos';

  @override
  String get formularioMedicamentoTomaMas => 'Una toma más';

  @override
  String get formularioMedicamentoCadaCuantasHoras => 'Cada cuántas horas';

  @override
  String formularioMedicamentoCadaHorasCorto(String horas) {
    return 'Cada $horas h';
  }

  @override
  String formularioMedicamentoCadaHorasValor(String horas) {
    return 'Cada $horas horas';
  }

  @override
  String get formularioMedicamentoHoraMenos => 'Una hora menos entre tomas';

  @override
  String get formularioMedicamentoHoraMas => 'Una hora más entre tomas';

  @override
  String get formularioMedicamentoHoraInicio => 'Hora de inicio';

  @override
  String get formularioMedicamentoHoraInicioDescripcion =>
      '¿A qué hora es la primera toma del día?';

  @override
  String get formularioMedicamentoDuracion => 'Duración del tratamiento';

  @override
  String get formularioMedicamentoDuracionDescripcion =>
      '¿Lo tomas siempre o solo unos días?';

  @override
  String get formularioMedicamentoSiempre => 'Siempre';

  @override
  String get formularioMedicamentoSiempreDescripcion =>
      'Sin fecha de fin. Por ejemplo, una medicina para la tensión.';

  @override
  String get formularioMedicamentoHastaUnDia => 'Hasta un día concreto';

  @override
  String get formularioMedicamentoHastaUnDiaDescripcion =>
      'Por ejemplo, un antibiótico durante 7 días.';

  @override
  String get formularioMedicamentoUltimoDiaEtiqueta =>
      'Último día del tratamiento';

  @override
  String get formularioMedicamentoUltimoDiaDescripcion =>
      'Ese día todavía hay que tomarlo.';

  @override
  String get formularioMedicamentoRecetaTitulo => 'Receta (opcional)';

  @override
  String get formularioMedicamentoRecetaDescripcion =>
      'Si la receta se acaba un día, te avisamos una semana antes para que pidas cita con tu médico.';

  @override
  String get formularioMedicamentoSinReceta => 'Sin fecha';

  @override
  String get formularioMedicamentoSinRecetaDescripcion =>
      'No te avisamos de la receta.';

  @override
  String get formularioMedicamentoConReceta => 'Se acaba un día concreto';

  @override
  String get formularioMedicamentoConRecetaDescripcion =>
      'Te avisamos una semana antes y, hasta que la renueves, cada día que abras la aplicación.';

  @override
  String get formularioMedicamentoRecetaFecha => 'Último día de la receta';

  @override
  String get formularioMedicamentoRecetaFechaDescripcion =>
      'Lo pone en la hoja de la receta, o te lo dicen en la farmacia.';

  @override
  String get formularioResumen => 'Resumen';

  @override
  String get fotoCaja => 'Foto de la caja';

  @override
  String fotoCajaDe(String medicamento) {
    return 'Foto de la caja de $medicamento';
  }

  @override
  String get fotoNoSePuedeMostrar => 'No se puede mostrar la foto.';

  @override
  String horarioDescripcion(int tomas, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas tomas al día, cada $horas horas',
      one: '1 toma al día',
    );
    return '$_temp0';
  }

  @override
  String get validadorMedicamentoNombreVacio =>
      'Escribe el nombre del medicamento. Por ejemplo: Paracetamol.';

  @override
  String validadorMedicamentoNombreLargo(String maximo) {
    return 'El nombre es demasiado largo. Usa como máximo $maximo letras.';
  }

  @override
  String validadorMedicamentoTomas(String minimo, String maximo) {
    return 'Elige cuántas veces al día lo tomas: entre $minimo y $maximo.';
  }

  @override
  String get validadorMedicamentoFrecuenciaUnaToma =>
      'Con 1 toma al día no hace falta elegir la frecuencia.';

  @override
  String validadorMedicamentoFrecuencia(String tomas, String horas) {
    return 'Con $tomas tomas al día, elige una frecuencia de $horas horas o menos.';
  }

  @override
  String validadorMedicamentoDosisLarga(String maximo) {
    return 'La dosis es demasiado larga. Usa como máximo $maximo letras.';
  }

  @override
  String validadorMedicamentoInstruccionesLargas(String maximo) {
    return 'Las instrucciones son demasiado largas. Usa como máximo $maximo letras.';
  }

  @override
  String get validadorMedicamentoHoraInicio =>
      'Elige la hora de la primera toma.';

  @override
  String validadorMedicamentoFechaFinPasada(String opcion) {
    return 'Ese día ya ha pasado. Elige hoy o un día futuro, o marca \"$opcion\" si no tiene fin.';
  }

  @override
  String get errorCargarMedicamentos =>
      'No se han podido cargar tus medicamentos. Cierra la aplicación y vuelve a abrirla.';

  @override
  String get tomasMarcar => 'Ya la he tomado';

  @override
  String get tomasDesmarcar => 'Desmarcar';

  @override
  String get tomasVacio => 'Hoy no tienes ninguna toma';

  @override
  String get tomasVacioExplicacion =>
      'Cuando registres un medicamento, aquí podrás marcar cada toma.';

  @override
  String get tomasEscuchar => 'Escuchar las tomas de hoy';

  @override
  String get tomasEscucharDescripcion =>
      'Te leerá cuáles has tomado y cuáles faltan.';

  @override
  String tomasAnotada(String medicamento, String hora) {
    return 'Anotado: has tomado $medicamento ($hora).';
  }

  @override
  String tomasDesmarcada(String medicamento, String hora) {
    return 'Toma desmarcada: $medicamento ($hora).';
  }

  @override
  String get tomasDeshacerMarcarPista => 'Quita la marca de esta toma';

  @override
  String get tomasDeshacerDesmarcarPista => 'Vuelve a marcar esta toma';

  @override
  String get tomasErrorCarga =>
      'No se han podido cargar tus tomas. Cierra la aplicación y vuelve a abrirla.';

  @override
  String tomasHasTomado(String tomadas, String total) {
    return 'Has tomado $tomadas de $total.';
  }

  @override
  String tomasEstadoTomada(String hora) {
    return 'Tomada a las $hora';
  }

  @override
  String tomasEstadoAplazada(String hora) {
    return 'Aplazada: te lo recordaremos a las $hora';
  }

  @override
  String get tomasEstadoPendiente => 'Pendiente';

  @override
  String tomasEstadoSinMarcar(String hora) {
    return 'Sin marcar. Era a las $hora.';
  }

  @override
  String get tomasDesmarcarDescripcion => 'Si la marcaste por error.';

  @override
  String tomasDesmarcarSemantica(String medicamento, String hora) {
    return 'Desmarcar $medicamento de las $hora';
  }

  @override
  String tomasMarcarSemantica(String medicamento, String hora) {
    return 'Ya he tomado $medicamento de las $hora';
  }

  @override
  String get historialVacio => 'Todavía no hay tomas que mostrar';

  @override
  String get historialVacioExplicacion =>
      'Aquí verás las tomas de los últimos 7 días y cuáles marcaste como tomadas.';

  @override
  String get historialErrorCarga =>
      'No se ha podido cargar el historial. Cierra la aplicación y vuelve a abrirla.';

  @override
  String historialUltimosDias(String dias) {
    return 'Últimos $dias días.';
  }

  @override
  String historialMarcadas(String tomadas, String total) {
    return 'Marcadas: $tomadas de $total.';
  }

  @override
  String historialTomada(String hora, String medicamento, String momento) {
    return '$hora · $medicamento: tomada a las $momento';
  }

  @override
  String historialAplazada(String hora, String medicamento) {
    return '$hora · $medicamento: aplazada, sin marcar';
  }

  @override
  String historialPendiente(String hora, String medicamento) {
    return '$hora · $medicamento: pendiente';
  }

  @override
  String historialSinMarcar(String hora, String medicamento) {
    return '$hora · $medicamento: sin marcar';
  }

  @override
  String get agendaCrearCita => 'Crear cita';

  @override
  String get agendaCrearCitaDescripcion => 'Apunta una cita nueva.';

  @override
  String get agendaPreguntaEliminar =>
      '¿Seguro que quieres eliminar esta cita?';

  @override
  String agendaDetalleEliminar(String cita, String fecha, String hora) {
    return '$cita\n$fecha, a las $hora';
  }

  @override
  String get agendaErrorEliminar =>
      'No se ha podido eliminar la cita. Inténtalo otra vez.';

  @override
  String agendaCitaEliminada(String cita) {
    return 'Cita eliminada: $cita';
  }

  @override
  String agendaCitaRecuperada(String cita) {
    return 'Cita recuperada: $cita';
  }

  @override
  String get agendaErrorCarga =>
      'No se han podido cargar tus citas. Cierra la aplicación y vuelve a abrirla.';

  @override
  String get agendaVacio => 'Todavía no tienes ninguna cita';

  @override
  String agendaVacioExplicacion(String boton) {
    return 'Pulsa el botón \"$boton\" para apuntar tu primera cita.';
  }

  @override
  String get agendaProximas => 'Próximas citas';

  @override
  String get agendaSinProximas => 'No tienes citas próximas.';

  @override
  String get agendaPasadas => 'Citas pasadas';

  @override
  String get agendaCitaPasada => 'Esta cita ya ha pasado.';

  @override
  String agendaModificarSemantica(String cita) {
    return 'Modificar la cita $cita';
  }

  @override
  String agendaEliminarSemantica(String cita) {
    return 'Eliminar la cita $cita';
  }

  @override
  String get formularioCitaTituloModificar => 'Modificar cita';

  @override
  String get formularioCitaGuardar => 'Guardar cita';

  @override
  String get formularioCitaGuardada => 'Cita guardada correctamente';

  @override
  String get formularioCitaErrorGuardar =>
      'No se ha podido guardar la cita. Inténtalo otra vez.';

  @override
  String get formularioCitaMuyPronto =>
      'La cita es muy pronto: no da tiempo a avisarte antes.';

  @override
  String formularioCitaTeAvisaremos(String cuando) {
    return 'Te avisaremos $cuando.';
  }

  @override
  String formularioCitaAvisoDiaAntes(String hora) {
    return 'el día antes a las $hora';
  }

  @override
  String formularioCitaAvisoMismoDia(String hora) {
    return 'ese día a las $hora';
  }

  @override
  String get formularioCitaAvisoUnaHoraAntes => 'una hora antes';

  @override
  String formularioCitaResumenGuardada(String cita, String fecha, String hora) {
    return '$cita\n$fecha, a las $hora.';
  }

  @override
  String get formularioCitaMotivo => 'Motivo de la cita';

  @override
  String get formularioCitaMotivoDescripcion =>
      'Por ejemplo: Médico de cabecera.';

  @override
  String get formularioCitaDictarMotivo => 'Dictar el motivo';

  @override
  String get formularioCitaDictarMotivoIndicacion => 'Di el motivo de la cita';

  @override
  String get formularioCitaFecha => 'Fecha';

  @override
  String get formularioCitaFechaDescripcion => '¿Qué día es la cita?';

  @override
  String get formularioCitaHora => 'Hora';

  @override
  String get formularioCitaHoraDescripcion => '¿A qué hora es la cita?';

  @override
  String get formularioCitaLugar => 'Lugar (opcional)';

  @override
  String get formularioCitaLugarDescripcion => 'Por ejemplo: Centro de salud.';

  @override
  String get formularioCitaNotas => 'Notas (opcional)';

  @override
  String get formularioCitaNotasDescripcion =>
      'Por ejemplo: llevar los análisis.';

  @override
  String get validadorCitaMotivoVacio =>
      'Escribe el motivo de la cita. Por ejemplo: Médico de cabecera.';

  @override
  String validadorCitaMotivoLargo(String maximo) {
    return 'El motivo es demasiado largo. Usa como máximo $maximo letras.';
  }

  @override
  String get validadorCitaDia => 'Elige el día de la cita.';

  @override
  String get validadorCitaHora => 'Elige la hora de la cita.';

  @override
  String get validadorCitaDiaPasado =>
      'Ese día ya ha pasado. Elige hoy o un día futuro.';

  @override
  String get validadorCitaHoraPasada =>
      'Esa hora ya ha pasado. Elige una hora más tarde.';

  @override
  String validadorCitaLugarLargo(String maximo) {
    return 'El lugar es demasiado largo. Usa como máximo $maximo letras.';
  }

  @override
  String validadorCitaNotasLargas(String maximo) {
    return 'Las notas son demasiado largas. Usa como máximo $maximo letras.';
  }

  @override
  String get emergenciasTitulo => 'Emergencias';

  @override
  String get emergenciasLlamar => 'Llamar';

  @override
  String emergenciasLlamarAlNumero(String numero) {
    return 'Llamar al $numero';
  }

  @override
  String emergenciasLlamarA(String nombre) {
    return 'Llamar a $nombre';
  }

  @override
  String emergenciasAbriendoNumero(String numero) {
    return 'Abriendo el teléfono para llamar al $numero…';
  }

  @override
  String emergenciasAbriendoNombre(String nombre) {
    return 'Abriendo el teléfono para llamar a $nombre…';
  }

  @override
  String get emergenciasNoSeHaPodidoAbrir =>
      'No se ha podido abrir el teléfono';

  @override
  String emergenciasMarcaAMano(String numero) {
    return 'Marca el $numero a mano desde la aplicación de teléfono.';
  }

  @override
  String get emergenciasIrAAjustes => 'Ir a Ajustes';

  @override
  String get emergenciasIrAAjustesDescripcion =>
      'Allí puedes guardar el número de emergencia.';

  @override
  String get emergenciasSinNumero =>
      'Todavía no has guardado un número de emergencia';

  @override
  String get emergenciasSinNumeroExplicacion =>
      'Para poder llamar desde aquí, primero escribe el número en Ajustes. Por ejemplo, el 112.';

  @override
  String emergenciasPulsaParaLlamar(String numero) {
    return 'Pulsa el botón para llamar al $numero.';
  }

  @override
  String get emergenciasExplicacion =>
      'Se abrirá el teléfono con el número ya escrito. Para hablar, pulsa el botón de llamada del teléfono.';

  @override
  String get ajustesSonidosActivados => 'Sonidos activados';

  @override
  String get ajustesSonidosDesactivados => 'Sonidos desactivados';

  @override
  String get ajustesVibracionActivada => 'Vibración activada';

  @override
  String get ajustesVibracionDesactivada => 'Vibración desactivada';

  @override
  String get ajustesLecturaActivada => 'Lectura en voz alta activada';

  @override
  String get ajustesLecturaDesactivada => 'Lectura en voz alta desactivada';

  @override
  String get ajustesSinVozTitulo => 'Este teléfono no puede leer en voz alta';

  @override
  String get ajustesSinVozMensaje =>
      'Le falta la voz en español. Se puede instalar en los ajustes del teléfono, en Accesibilidad, opción \"Texto a voz\".';

  @override
  String get ajustesSinVozMensajeIphone =>
      'Le falta la voz en español. Se puede descargar en los ajustes del iPhone: Accesibilidad → Contenido leído → Voces.';

  @override
  String ajustesNumeroGuardado(String numero) {
    return 'Número de emergencia guardado: $numero';
  }

  @override
  String ajustesContactoGuardado(String nombre, String numero) {
    return 'Contacto guardado: $nombre, $numero';
  }

  @override
  String get ajustesContactoBorrado => 'Contacto del familiar borrado';

  @override
  String get ajustesCambiosAlMomento => 'Los cambios se guardan al momento.';

  @override
  String get ajustesActivarSonidos => 'Activar sonidos';

  @override
  String get ajustesActivarSonidosDescripcion => 'Los avisos sonarán.';

  @override
  String get ajustesActivarVibracion => 'Activar vibración';

  @override
  String get ajustesActivarVibracionDescripcion =>
      'El teléfono vibrará con cada aviso.';

  @override
  String get ajustesActivarNotificaciones => 'Activar notificaciones';

  @override
  String get ajustesActivarNotificacionesDescripcion =>
      'Recibirás avisos de tus medicinas y de tus citas.';

  @override
  String get ajustesProbarAviso => 'Probar aviso';

  @override
  String get ajustesProbarAvisoDescripcion =>
      'Envía un aviso ahora para comprobar cómo suena y se ve.';

  @override
  String get ajustesRepetirAvisos => 'Repetir los avisos';

  @override
  String ajustesRepetirAvisosDescripcion(String boton) {
    return 'Cuándo te avisamos otra vez si no marcas una toma, y cuánto espera el botón \"$boton\".';
  }

  @override
  String get ajustesAvisosDiscretos => 'Avisos discretos';

  @override
  String get ajustesAvisosDiscretosDescripcion =>
      'Los avisos no dirán qué medicina toca ni el motivo de la cita, ni llevarán la foto de la caja: así no se verán en la pantalla de bloqueo. Al tocar el aviso, la aplicación te lo dirá.';

  @override
  String get ajustesAvisosDiscretosActivados => 'Avisos discretos activados';

  @override
  String get ajustesAvisosDiscretosDesactivados =>
      'Avisos discretos desactivados';

  @override
  String get repetirSinMarcarTitulo => 'Si no marcas la toma';

  @override
  String get repetirSinMarcarDescripcion =>
      'Te avisamos una vez más, por si no oíste el primer aviso.';

  @override
  String repetirALosMinutos(int minutos) {
    return 'A los $minutos minutos';
  }

  @override
  String get repetirALaHora => 'A la hora';

  @override
  String get repetirNunca => 'No repetir el aviso';

  @override
  String repetirEjemplo(String hora, String repeticion) {
    return 'Una toma de las $hora se repite a las $repeticion.';
  }

  @override
  String get repetirNuncaDescripcion => 'Solo suena el aviso de su hora.';

  @override
  String get repetirAplazarTitulo => 'Recordar más tarde';

  @override
  String get repetirAplazarDescripcion =>
      'Los avisos de las tomas llevan un botón para que te lo recordemos un poco después.';

  @override
  String repetirAplazarEjemplo(String hora, String despues) {
    return 'Si lo pulsas a las $hora, te lo recordamos a las $despues.';
  }

  @override
  String repetirGuardado(String opcion) {
    return 'Guardado: $opcion';
  }

  @override
  String get ajustesLeerEnVozAlta => 'Leer en voz alta';

  @override
  String get ajustesLeerEnVozAltaDescripcion =>
      'Leerá los avisos al abrirlos y podrás escuchar las tomas de hoy.';

  @override
  String get ajustesNumeroEmergencia => 'Nº de emergencia';

  @override
  String get ajustesNumeroEmergenciaDescripcion =>
      'El número al que llamará el botón de emergencias. Por ejemplo: 112.';

  @override
  String get ajustesGuardarNumero => 'Guardar número';

  @override
  String get ajustesNombreFamiliar => 'Nombre de un familiar';

  @override
  String get ajustesNombreFamiliarDescripcion =>
      'Otra persona a la que podrás llamar desde Emergencias. Por ejemplo: Mi hija Ana.';

  @override
  String get ajustesTelefonoFamiliar => 'Teléfono del familiar';

  @override
  String get ajustesGuardarContacto => 'Guardar contacto';

  @override
  String get ajustesGuardarContactoDescripcion =>
      'Para borrarlo, deja los dos campos vacíos.';

  @override
  String get ajustesTamanoTexto => 'Ajustar tamaño de texto';

  @override
  String get ajustesTamanoTextoDescripcion =>
      'Haz las letras más grandes o más pequeñas.';

  @override
  String get ajustesTema => 'Ajustar tema';

  @override
  String get ajustesTemaDescripcion => 'Cambia los colores de la aplicación.';

  @override
  String get compartirTitulo => 'Compartir y copia de seguridad';

  @override
  String get ajustesCompartirDescripcion =>
      'Envía tu medicación al médico o a la familia y guarda tus datos para no perderlos.';

  @override
  String get permisosNotificacionesActivadas => 'Notificaciones activadas';

  @override
  String get permisosNotificacionesDesactivadas =>
      'Notificaciones desactivadas';

  @override
  String get permisosDenegado =>
      'El teléfono no ha dado permiso para mostrar avisos, así que siguen desactivados.';

  @override
  String get permisosHoraExactaTitulo => 'Avisos a la hora exacta';

  @override
  String permisosHoraExactaMensaje(String boton) {
    return 'Las notificaciones ya están activadas. Para que los avisos lleguen justo a su hora, el teléfono necesita un permiso más.\n\nSi pulsas \"$boton\" se abrirá una pantalla del teléfono: activa la opción y vuelve con el botón Atrás.';
  }

  @override
  String get permisosDarPermiso => 'Dar permiso';

  @override
  String get permisosHoraExactaConcedido =>
      'Listo: los avisos llegarán a su hora exacta.';

  @override
  String get permisosHoraExactaDenegado =>
      'Sin ese permiso, los avisos pueden llegar unos minutos tarde.';

  @override
  String get permisosFaltaTitulo => 'Falta el permiso del teléfono';

  @override
  String permisosFaltaMensaje(String explicacion, String boton) {
    return '$explicacion\n\nPulsa \"$boton\", activa las notificaciones y vuelve con el botón Atrás.';
  }

  @override
  String get permisosAbrirAjustes => 'Abrir ajustes del teléfono';

  @override
  String get permisosPruebaEnviada =>
      'Aviso de prueba enviado. Mira la parte de arriba de la pantalla.';

  @override
  String get permisosPruebaDesactivadasTitulo =>
      'Las notificaciones están desactivadas';

  @override
  String permisosPruebaDesactivadasMensaje(String interruptor, String boton) {
    return 'Activa primero \"$interruptor\" y después vuelve a pulsar \"$boton\".';
  }

  @override
  String get permisosPruebaSinPermiso =>
      'El teléfono no deja mostrar los avisos de esta aplicación.';

  @override
  String get temaPredeterminado => 'Tema predeterminado';

  @override
  String get temaPredeterminadoDescripcion =>
      'Fondo azul claro y letras negras.';

  @override
  String get temaOscuro => 'Tema oscuro';

  @override
  String get temaOscuroDescripcion =>
      'Fondo oscuro y letras blancas. Cansa menos la vista con poca luz.';

  @override
  String get temaAlternativo => 'Tema alternativo';

  @override
  String get temaAlternativoDescripcion =>
      'Fondo amarillo suave y letras negras. Reduce los reflejos.';

  @override
  String get temaTitulo => 'Tema';

  @override
  String get temaAplicar => 'Aplicar este tema';

  @override
  String temaAplicado(String tema) {
    return 'Tema aplicado: $tema';
  }

  @override
  String get temaToca => 'Toca un tema para verlo en la muestra.';

  @override
  String temaMuestra(String tema) {
    return 'Muestra: $tema';
  }

  @override
  String get temaYaLoUsas => 'Este es el tema que ya usas.';

  @override
  String temaAhoraUsas(String tema) {
    return 'Ahora usas: $tema.';
  }

  @override
  String get temaElegido => 'Elegido';

  @override
  String get temaEnUso => 'En uso';

  @override
  String get temaSeparadorEstado => ' · ';

  @override
  String get temaMuestraTexto => 'Así se verán las pantallas con este tema.';

  @override
  String get temaMuestraBoton => 'Botón de ejemplo';

  @override
  String get temaMuestraInterruptor => 'Interruptor de ejemplo';

  @override
  String get temaMuestraInterruptorDescripcion => 'Verde es activado.';

  @override
  String get tamanoTitulo => 'Tamaño de texto';

  @override
  String get tamanoAumentar => 'Aumentar (+)';

  @override
  String get tamanoReducir => 'Reducir (−)';

  @override
  String get tamanoMuestraTexto =>
      'Así se verán los textos de la aplicación. Por ejemplo: Paracetamol, 3 tomas al día, cada 8 horas.';

  @override
  String tamanoActual(String tamano) {
    return 'Tamaño actual: $tamano';
  }

  @override
  String tamanoActualNormal(String tamano) {
    return 'Tamaño actual: $tamano (normal)';
  }

  @override
  String tamanoActualMinimo(String tamano) {
    return 'Tamaño actual: $tamano (mínimo)';
  }

  @override
  String tamanoActualMaximo(String tamano) {
    return 'Tamaño actual: $tamano (máximo)';
  }

  @override
  String tamanoPuedesElegir(String minimo, String maximo) {
    return 'Puedes elegir entre $minimo y $maximo. El cambio se aplica a toda la aplicación.';
  }

  @override
  String get tamanoMasGrandes => 'Letras más grandes.';

  @override
  String get tamanoYaMaximo => 'Ya está en el tamaño máximo.';

  @override
  String get tamanoMasPequenas => 'Letras más pequeñas.';

  @override
  String get tamanoYaMinimo => 'Ya está en el tamaño mínimo.';

  @override
  String get tamanoMuestra => 'Muestra';

  @override
  String get ajustesFraseDePruebaVoz =>
      'Así sonará la voz. Leeré tus avisos y tus tomas de hoy.';

  @override
  String get validadorFamiliarNombreVacio =>
      'Escribe cómo se llama. Por ejemplo: Mi hija Ana.';

  @override
  String validadorFamiliarNombreLargo(String maximo) {
    return 'El nombre es demasiado largo: como mucho $maximo letras.';
  }

  @override
  String get validadorFamiliarNumeroVacio => 'Escribe su número de teléfono.';

  @override
  String get validadorTelefonoVacio =>
      'Escribe un número de teléfono. Por ejemplo: 112.';

  @override
  String get validadorTelefonoSoloNumeros =>
      'Escribe solo números. Por ejemplo: 112 o 600123456.';

  @override
  String validadorTelefonoCorto(String minimo) {
    return 'El número es demasiado corto. Debe tener al menos $minimo cifras.';
  }

  @override
  String get validadorTelefonoLargo =>
      'El número es demasiado largo. Revisa que esté bien escrito.';

  @override
  String get asistenteTitulo => 'Primeros pasos';

  @override
  String get asistenteEmpezar => 'Empezar';

  @override
  String get asistenteSaltar => 'Saltar estos pasos';

  @override
  String get asistenteSaltarDescripcion => 'Ir directamente al menú principal.';

  @override
  String get asistenteSiguiente => 'Siguiente';

  @override
  String get asistenteTerminar => 'Empezar a usar la aplicación';

  @override
  String get asistenteHola => 'Hola';

  @override
  String get asistenteBienvenida =>
      'Vamos a preparar la aplicación en 3 pasos: el tamaño de la letra, los avisos y el número de emergencia.';

  @override
  String get asistenteCambiarEnAjustes =>
      'Todo se puede cambiar más tarde en Ajustes.';

  @override
  String asistentePaso(String numero, String total, String titulo) {
    return 'Paso $numero de $total: $titulo';
  }

  @override
  String get asistenteTamanoTitulo => 'Tamaño de la letra';

  @override
  String get asistenteTamanoExplicacion =>
      '¿Lees bien este texto? Si te cuesta, haz las letras más grandes.';

  @override
  String get asistenteAvisosTitulo => 'Avisos de medicinas y citas';

  @override
  String get asistenteAvisosExplicacion =>
      'Te avisaremos a la hora de cada medicina y antes de cada cita, con sonido y vibración.';

  @override
  String get asistenteActivarAvisos => 'Activar los avisos';

  @override
  String get asistenteActivarAvisosDescripcion =>
      'El teléfono te pedirá permiso: pulsa \"Permitir\".';

  @override
  String asistenteSiPrefieresNo(String boton) {
    return 'Si prefieres no activarlos ahora, pulsa \"$boton\".';
  }

  @override
  String get asistenteConSonido => 'con sonido';

  @override
  String get asistenteSinSonido => 'sin sonido';

  @override
  String get asistenteConVibracion => 'con vibración';

  @override
  String get asistenteSinVibracion => 'sin vibración';

  @override
  String asistenteAvisosActivados(String sonido, String vibracion) {
    return 'Los avisos están activados, $sonido y $vibracion.';
  }

  @override
  String get asistenteProbarAvisoDescripcion =>
      'Envía un aviso ahora para ver cómo suena y se ve.';

  @override
  String get asistenteEmergenciaTitulo => 'Número de emergencia';

  @override
  String get asistenteEmergenciaExplicacion =>
      'El botón de emergencias llamará a este número. Puede ser el 112 o el de un familiar.';

  @override
  String get asistenteEmergenciaDescripcion =>
      'Si no quieres ponerlo ahora, déjalo vacío.';

  @override
  String get asistenteTodoListo => 'Todo listo';

  @override
  String asistenteResumenTamano(String tamano) {
    return 'Tamaño de la letra: $tamano.';
  }

  @override
  String get asistenteResumenAvisosActivados => 'Avisos activados.';

  @override
  String get asistenteResumenAvisosDesactivados =>
      'Avisos desactivados. Puedes activarlos en Ajustes.';

  @override
  String asistenteResumenNumero(String numero) {
    return 'Número de emergencia: $numero.';
  }

  @override
  String get asistenteResumenSinNumero =>
      'Sin número de emergencia. Puedes ponerlo en Ajustes.';

  @override
  String get asistenteTambienEnAjustes =>
      'En Ajustes también puedes elegir los colores y activar la lectura en voz alta.';

  @override
  String get compartirEnviarInforme => 'Enviar mi medicación y citas';

  @override
  String get compartirEnviarInformeDescripcion =>
      'Por WhatsApp, correo… En la pantalla siguiente eliges a quién.';

  @override
  String get compartirImprimir => 'Imprimir';

  @override
  String get compartirImprimirDescripcion =>
      'En una impresora conectada al teléfono, o guardarlo como PDF.';

  @override
  String get compartirGuardarCopia => 'Guardar una copia';

  @override
  String get compartirGuardarCopiaDescripcion =>
      'En Google Drive o en la carpeta de descargas.';

  @override
  String get compartirEnviarCopia => 'Enviar una copia';

  @override
  String get compartirEnviarCopiaDescripcion =>
      'Por correo o WhatsApp: a tu propio correo o a un familiar.';

  @override
  String get compartirRecuperar => 'Recuperar una copia';

  @override
  String get compartirRecuperarDescripcion =>
      'Cambia los datos de este teléfono por los de una copia. Antes te preguntará.';

  @override
  String get compartirSiRecuperar => 'Sí, recuperar la copia';

  @override
  String get compartirErrorDocumento =>
      'No se ha podido preparar el documento. Inténtalo otra vez.';

  @override
  String get compartirErrorImprimir =>
      'No se ha podido abrir la impresión. Inténtalo otra vez.';

  @override
  String get compartirCopiaGuardada => 'Copia de seguridad guardada.';

  @override
  String get compartirErrorGuardarCopia =>
      'No se ha podido guardar la copia. Inténtalo otra vez.';

  @override
  String get compartirErrorEnviarCopia =>
      'No se ha podido preparar la copia. Inténtalo otra vez.';

  @override
  String get compartirNoSePuedeRecuperar =>
      'No se puede recuperar este fichero';

  @override
  String get compartirSustitucionVacio =>
      'Se pondrá en este teléfono lo que hay en la copia.';

  @override
  String compartirSustitucion(String actual) {
    return 'Se borrará lo que hay ahora en este teléfono ($actual) y se pondrá lo de la copia.';
  }

  @override
  String get compartirPreguntaRecuperar => '¿Recuperar esta copia?';

  @override
  String compartirCopiaDel(String fecha, String hora, String resumen) {
    return 'Copia del $fecha, a las $hora: $resumen.';
  }

  @override
  String compartirCopiaEmergencia(String numero) {
    return 'Número de emergencia: $numero.';
  }

  @override
  String get compartirCopiaSinEmergencia => 'Sin número de emergencia.';

  @override
  String compartirCopiaFamiliar(String familiar) {
    return 'Familiar: $familiar.';
  }

  @override
  String get compartirCopiaSinFamiliar => 'Sin familiar.';

  @override
  String get compartirCopiaRecuperada => 'Copia recuperada';

  @override
  String compartirYaTienes(String resumen) {
    return 'Ya tienes en este teléfono $resumen.';
  }

  @override
  String get compartirAvisosDesactivados =>
      'Los avisos están desactivados en este teléfono: actívalos en Ajustes para recibirlos.';

  @override
  String get compartirErrorRecuperar =>
      'No se ha podido recuperar la copia. Inténtalo otra vez.';

  @override
  String get compartirParaElMedico => 'Para el médico o la familia';

  @override
  String get compartirParaElMedicoExplicacion =>
      'Un documento con tus medicinas, tus tomas de la última semana y tus próximas citas.';

  @override
  String get compartirCopiaDeSeguridad => 'Copia de seguridad';

  @override
  String compartirCopiaExplicacion(String boton) {
    return 'Guarda en un fichero todos tus datos: medicinas con sus fotos, tomas, citas y ajustes. En un móvil nuevo, instala la aplicación y pulsa \"$boton\".';
  }

  @override
  String get compartirUnMomento => 'Un momento, por favor…';

  @override
  String copiaNoEsCopia(String app) {
    return 'Este fichero no es una copia de $app, o está dañado.';
  }

  @override
  String copiaDemasiadoGrande(String app) {
    return 'Este fichero es demasiado grande para ser una copia de $app.';
  }

  @override
  String get copiaVersionNueva =>
      'Esta copia es de una versión más nueva de la aplicación. Actualiza la aplicación y vuelve a intentarlo.';

  @override
  String copiaNombreFichero(String app, String fecha) {
    return 'Copia de $app $fecha';
  }

  @override
  String copiaMedicamentos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad medicamentos',
      one: '1 medicamento',
    );
    return '$_temp0';
  }

  @override
  String copiaCitas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad citas',
      one: '1 cita',
    );
    return '$_temp0';
  }

  @override
  String copiaTomas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad tomas anotadas',
      one: '1 toma anotada',
    );
    return '$_temp0';
  }

  @override
  String copiaAsunto(String app) {
    return 'Copia de seguridad de $app';
  }

  @override
  String get informeTitulo => 'Mi medicación y mis citas';

  @override
  String informeNombreFichero(String fecha) {
    return 'Medicación y citas $fecha';
  }

  @override
  String informePagina(String pagina, String total) {
    return 'Página $pagina de $total';
  }

  @override
  String informeActualizado(String fecha, String hora) {
    return 'Actualizado el $fecha, a las $hora.';
  }

  @override
  String informeTelefonosEmergencia(String telefonos) {
    return 'Teléfonos de emergencia: $telefonos.';
  }

  @override
  String informeContactoFamiliar(String nombre, String numero) {
    return '$nombre: $numero';
  }

  @override
  String get informeSeparadorTelefonos => ' · ';

  @override
  String get informeMedicamentos => 'Medicamentos';

  @override
  String get informeSinMedicamentos => 'No hay medicamentos registrados.';

  @override
  String informeTomasYHoras(String tomas, String horas) {
    return '$tomas: $horas';
  }

  @override
  String informeInstrucciones(String instrucciones) {
    return 'Instrucciones: $instrucciones';
  }

  @override
  String informeTomasUltimosDias(String dias) {
    return 'Tomas de los últimos $dias días';
  }

  @override
  String get informeColumnaDia => 'Día';

  @override
  String get informeColumnaTomadas => 'Tomadas';

  @override
  String get informeColumnaSinMarcar => 'Sin marcar';

  @override
  String get informeHoy => 'Hoy';

  @override
  String informeDiaFecha(String dia, String numero, String mes) {
    return '$dia $numero/$mes';
  }

  @override
  String informeTomadas(String tomadas, String total) {
    return '$tomadas de $total';
  }

  @override
  String informeTomadasConPendientes(
    String tomadas,
    String total,
    String pendientes,
  ) {
    return '$tomadas de $total ($pendientes por llegar)';
  }

  @override
  String informeTomaSinMarcar(String hora, String medicamento) {
    return '$hora $medicamento';
  }

  @override
  String informeYMas(String lista, String mas) {
    return '$lista y $mas más';
  }

  @override
  String get informeSinTomas => 'No hay tomas en estos días.';

  @override
  String get informeProximasCitas => 'Próximas citas';

  @override
  String get informeSinCitas => 'No hay citas próximas.';

  @override
  String informeCitaCuando(String fecha, String hora) {
    return '$fecha, a las $hora';
  }

  @override
  String informeLugar(String lugar) {
    return 'Lugar: $lugar';
  }

  @override
  String informeNotas(String notas) {
    return 'Notas: $notas';
  }

  @override
  String get canalConSonidoYVibracion => 'Avisos con sonido y vibración';

  @override
  String get canalConSonido => 'Avisos con sonido';

  @override
  String get canalConVibracion => 'Avisos con vibración';

  @override
  String get canalSilencioso => 'Avisos silenciosos';

  @override
  String get canalDescripcion => 'Avisos de tomas de medicamentos y de citas.';

  @override
  String get avisoNotaRenovar =>
      'Abre la aplicación para seguir recibiendo estos avisos.';

  @override
  String get avisoTomaTitulo => 'Hora de tu medicina';

  @override
  String get avisoAplazadoTitulo => 'Recuerda tu medicina';

  @override
  String get avisoRepeticionTitulo => '¿Has tomado tu medicina?';

  @override
  String avisoTomaCuerpo(String medicamento, String hora) {
    return 'Toma $medicamento ($hora).';
  }

  @override
  String avisoTomaCuerpoConDosis(
    String medicamento,
    String dosis,
    String hora,
  ) {
    return 'Toma $medicamento: $dosis ($hora).';
  }

  @override
  String avisoRepeticionCuerpo(String hora, String medicamento, String boton) {
    return 'Era a las $hora: $medicamento. Si ya la has tomado, pulsa \"$boton\".';
  }

  @override
  String avisoRepeticionCuerpoConDosis(
    String hora,
    String medicamento,
    String dosis,
    String boton,
  ) {
    return 'Era a las $hora: $medicamento: $dosis. Si ya la has tomado, pulsa \"$boton\".';
  }

  @override
  String avisoTomaCuerpoDiscreto(String hora) {
    return 'La de las $hora. Toca aquí para ver cuál es.';
  }

  @override
  String avisoRepeticionCuerpoDiscreto(String hora) {
    return 'Era a las $hora. Toca aquí para ver cuál es.';
  }

  @override
  String get avisoExistenciasCuerpoDiscreto =>
      'De una de tus medicinas. Toca aquí para ver cuál es.';

  @override
  String get avisoRecetaCuerpoDiscreto =>
      'La de una de tus medicinas. Toca aquí para ver cuál es.';

  @override
  String avisoCitaCuerpoDiscreto(String hora) {
    return 'A las $hora. Toca aquí para ver cuál es.';
  }

  @override
  String get avisoCitaHoy => 'Hoy tienes una cita';

  @override
  String get avisoCitaManana => 'Mañana tienes una cita';

  @override
  String get avisoCitaUnaHora => 'Tu cita es dentro de 1 hora';

  @override
  String avisoCitaCuerpo(String cita, String hora) {
    return '$cita a las $hora.';
  }

  @override
  String avisoCitaCuerpoConLugar(String cita, String hora, String lugar) {
    return '$cita a las $hora en $lugar.';
  }

  @override
  String avisoAplazar(int minutos) {
    return 'Recordar en $minutos min';
  }

  @override
  String get avisoPruebaTitulo => 'Aviso de prueba';

  @override
  String get avisoPruebaCuerpo =>
      'Así te avisaremos de tus medicinas y de tus citas.';

  @override
  String vozMedicamento(String medicamento) {
    return '$medicamento.';
  }

  @override
  String vozMedicamentoConDosis(String medicamento, String dosis) {
    return '$medicamento, $dosis.';
  }

  @override
  String vozToma(String hora, String detalle, String boton) {
    return 'Medicina de las $hora: $detalle Cuando la tomes, pulsa: $boton.';
  }

  @override
  String vozCita(String cita, String cuando) {
    return 'Tienes una cita: $cita, $cuando.';
  }

  @override
  String vozCitaConLugar(String cita, String cuando, String lugar) {
    return 'Tienes una cita: $cita, $cuando, en $lugar.';
  }

  @override
  String get vozSinTomas => 'Hoy no tienes ninguna toma.';

  @override
  String vozTotalTomas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad tomas',
      one: 'una toma',
    );
    return '$_temp0';
  }

  @override
  String vozTodasTomadas(String total) {
    return 'Hoy tienes $total y ya las has tomado todas.';
  }

  @override
  String vozHasTomado(String total, String tomadas) {
    return 'Hoy tienes $total. Has tomado $tomadas.';
  }

  @override
  String vozTeFaltan(int cantidad, String lista) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Te faltan: $lista',
      one: 'Te falta: $lista',
    );
    return '$_temp0';
  }

  @override
  String vozNombreConDosis(String medicamento, String dosis) {
    return '$medicamento, $dosis';
  }

  @override
  String vozFaltanteSinMarcar(String medicamento, String hora) {
    return '$medicamento, de las $hora, sin marcar.';
  }

  @override
  String vozFaltanteAplazada(String medicamento, String hora) {
    return '$medicamento, de las $hora, aplazada.';
  }

  @override
  String vozFaltantePendiente(String medicamento, String hora) {
    return '$medicamento, a las $hora.';
  }

  @override
  String vozHasDictado(String texto) {
    return 'Has dictado: $texto. Si no es correcto, vuelve a dictarlo o corrígelo con el teclado.';
  }

  @override
  String get vozNoPuedeDictar =>
      'Este teléfono no permite dictar. Escríbelo con el teclado.';

  @override
  String get vozDictarDescripcion => 'Dilo en voz alta y se escribirá solo.';

  @override
  String respuestaAplazada(String hora) {
    return 'Te lo recordaremos a las $hora.';
  }

  @override
  String get respuestaSinMedicamento =>
      'Ese medicamento ya no está registrado.';

  @override
  String get estadoAvisosListos =>
      'Los avisos están listos para llegar a su hora.';

  @override
  String get estadoAvisosSinPermiso =>
      'El teléfono no deja a esta aplicación mostrar avisos, así que no llegarán.';

  @override
  String get estadoAvisosSinHoraExacta =>
      'Falta el permiso de hora exacta: los avisos pueden llegar unos minutos tarde.';

  @override
  String get estadoAvisosAhorroBateria =>
      'El ahorro de batería del teléfono puede retrasar los avisos o impedir que lleguen.';

  @override
  String get estadoAvisosBotonPermiso => 'Dar permiso para los avisos';

  @override
  String get estadoAvisosBotonHoraExacta => 'Dar permiso de hora exacta';

  @override
  String get estadoAvisosBotonBateria => 'Quitar el ahorro de batería';

  @override
  String get estadoAvisosPermisoConcedido =>
      'Listo: los avisos ya pueden llegar.';

  @override
  String get bateriaTitulo => 'Ahorro de batería';

  @override
  String bateriaMensaje(String boton) {
    return 'Algunos teléfonos cierran las aplicaciones para ahorrar batería, y entonces los avisos llegan tarde o no llegan.\n\nSi pulsas \"$boton\", se abrirá la pantalla de esta aplicación en los ajustes del teléfono. Toca \"Batería\" (o \"Uso de batería\"), elige \"Sin restricciones\" y vuelve con el botón Atrás.';
  }

  @override
  String get bateriaAbrir => 'Abrir los ajustes';

  @override
  String get menuAvisosSinPermiso =>
      'Los avisos no pueden llegar: el teléfono no da permiso a esta aplicación.';

  @override
  String get formularioRecuperado =>
      'Hemos recuperado lo que estabas escribiendo.';

  @override
  String formularioRecuperadoConFoto(String boton) {
    return 'Hemos recuperado lo que estabas escribiendo y la foto. Se guardará al pulsar \"$boton\".';
  }

  @override
  String fechaCorta(String diaSemana, String dia, String mes) {
    return '$diaSemana, $dia de $mes';
  }

  @override
  String horarioDescripcionLibre(int tomas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas tomas al día',
      one: '1 toma al día',
    );
    return '$_temp0';
  }

  @override
  String get semanaLunes => 'lunes';

  @override
  String get semanaMartes => 'martes';

  @override
  String get semanaMiercoles => 'miércoles';

  @override
  String get semanaJueves => 'jueves';

  @override
  String get semanaViernes => 'viernes';

  @override
  String get semanaSabado => 'sábados';

  @override
  String get semanaDomingo => 'domingos';

  @override
  String diasSemanaFrase(String dias) {
    return 'los $dias';
  }

  @override
  String diasCadaFrase(String cada, String fecha) {
    return 'cada $cada días, empezando el $fecha';
  }

  @override
  String get validadorMedicamentoHorasRepetidas =>
      'Hay dos tomas a la misma hora. Cambia una de ellas.';

  @override
  String get validadorMedicamentoSinDias =>
      'Elige al menos un día de la semana.';

  @override
  String validadorMedicamentoCadaDias(String minimo, String maximo) {
    return 'Elige cada cuántos días lo tomas: entre $minimo y $maximo.';
  }

  @override
  String get formularioMedicamentoHorasTitulo => '¿A qué horas lo tomas?';

  @override
  String get formularioMedicamentoHorasDescripcion =>
      'Elige cómo se reparten las tomas a lo largo del día.';

  @override
  String get formularioMedicamentoRepartidas => 'Repartidas por igual';

  @override
  String get formularioMedicamentoRepartidasDescripcion =>
      'Cada cierto número de horas, desde la primera toma.';

  @override
  String get formularioMedicamentoConcretas => 'A horas concretas';

  @override
  String get formularioMedicamentoConcretasDescripcion =>
      'Por ejemplo, con el desayuno, la comida y la cena.';

  @override
  String formularioMedicamentoHoraToma(String numero) {
    return 'Toma $numero';
  }

  @override
  String get formularioMedicamentoHoraUnaToma => 'Hora de la toma';

  @override
  String get formularioMedicamentoHoraUnaTomaDescripcion =>
      '¿A qué hora lo tomas?';

  @override
  String get formularioMedicamentoDiasTitulo => '¿Qué días lo tomas?';

  @override
  String get formularioMedicamentoDiasDescripcion =>
      'Elige si lo tomas a diario o solo algunos días.';

  @override
  String get formularioMedicamentoTodosLosDias => 'Todos los días';

  @override
  String get formularioMedicamentoTodosLosDiasDescripcion =>
      'Cada día, sin saltarse ninguno.';

  @override
  String get formularioMedicamentoAlgunosDias => 'Algunos días de la semana';

  @override
  String get formularioMedicamentoAlgunosDiasDescripcion =>
      'Por ejemplo, una pastilla que se toma los lunes.';

  @override
  String get formularioMedicamentoCadaVariosDias => 'Cada varios días';

  @override
  String get formularioMedicamentoCadaVariosDiasDescripcion =>
      'Por ejemplo, un día sí y otro no.';

  @override
  String get formularioMedicamentoCadaCuantosDias => 'Cada cuántos días';

  @override
  String formularioMedicamentoCadaDiasValor(String dias) {
    return 'Cada $dias días';
  }

  @override
  String get formularioMedicamentoDiaMenos => 'Un día menos entre tomas';

  @override
  String get formularioMedicamentoDiaMas => 'Un día más entre tomas';

  @override
  String get formularioMedicamentoPrimerDia => 'Primer día';

  @override
  String get formularioMedicamentoPrimerDiaDescripcion =>
      'El primer día que lo tomas.';

  @override
  String formularioMedicamentoAvisoDias(String dias, String horas) {
    return 'Te avisaremos a las $horas $dias.';
  }

  @override
  String formularioMedicamentoAvisoDiasHasta(
    String dias,
    String horas,
    String fecha,
  ) {
    return 'Te avisaremos a las $horas $dias, hasta el $fecha, incluido.';
  }

  @override
  String get medicamentoSinFechaDeFinSolo => 'Sin fecha de fin';

  @override
  String get medicamentoADemanda => 'Cuando haga falta, sin avisos';

  @override
  String limitesMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'como mucho $n veces al día',
      one: 'como mucho 1 vez al día',
    );
    return '$_temp0';
  }

  @override
  String limitesHoras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'con al menos $n horas entre una y otra',
      one: 'con al menos 1 hora entre una y otra',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoCuandoTitulo => '¿Cuándo lo tomas?';

  @override
  String get formularioMedicamentoCuandoDescripcion =>
      'Elige si tiene un horario o si lo tomas solo cuando lo necesitas.';

  @override
  String get formularioMedicamentoConHorario => 'Con un horario';

  @override
  String get formularioMedicamentoConHorarioDescripcion =>
      'A sus horas. Te avisaremos de cada toma.';

  @override
  String get formularioMedicamentoADemanda => 'Solo cuando haga falta';

  @override
  String formularioMedicamentoADemandaDescripcion(String pantalla) {
    return 'Por ejemplo, un calmante para el dolor. No hay avisos: cuando lo tomes, lo anotas en \"$pantalla\".';
  }

  @override
  String get formularioMedicamentoLimitesTitulo =>
      'Cuánto se puede tomar (opcional)';

  @override
  String get formularioMedicamentoLimitesDescripcion =>
      'Lo que diga el prospecto o tu médico. Si al anotar una toma te pasas, la aplicación te avisa.';

  @override
  String get formularioMedicamentoMaximoAlDia => 'Como mucho, veces al día';

  @override
  String get formularioMedicamentoSinLimite => 'Sin límite';

  @override
  String formularioMedicamentoVeces(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n veces',
      one: '1 vez',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoVezMenos => 'Una vez menos al día';

  @override
  String get formularioMedicamentoVezMas => 'Una vez más al día';

  @override
  String get formularioMedicamentoHorasEntreTomas =>
      'Horas entre una toma y otra, como mínimo';

  @override
  String get formularioMedicamentoSinMinimo => 'Sin mínimo';

  @override
  String formularioMedicamentoHorasValor(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String formularioMedicamentoAvisoADemanda(String pantalla) {
    return 'Sin avisos. Cuando lo tomes, anótalo en \"$pantalla\".';
  }

  @override
  String formularioMedicamentoAvisoADemandaHasta(
    String pantalla,
    String fecha,
  ) {
    return 'Sin avisos. Podrás anotarlo en \"$pantalla\" hasta el $fecha, incluido.';
  }

  @override
  String formularioMedicamentoResumenADemanda(String medicamento) {
    return '$medicamento: cuando haga falta, sin avisos.';
  }

  @override
  String get tomasADemandaTitulo => 'Cuando haga falta';

  @override
  String tomasADemandaExplicacion(String boton) {
    return 'Si tomas alguno, pulsa \"$boton\" para anotarlo.';
  }

  @override
  String get tomasADemandaMarcar => 'Lo he tomado ahora';

  @override
  String tomasADemandaMarcarSemantica(String medicamento) {
    return 'He tomado $medicamento ahora';
  }

  @override
  String get tomasADemandaNingunaHoy => 'Hoy no lo has tomado';

  @override
  String tomasADemandaMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Hoy ya lo has tomado las $n veces que se puede',
      one: 'Hoy ya lo has tomado la vez que se puede',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaProximaHoy(String hora) {
    return 'La próxima, a partir de las $hora';
  }

  @override
  String tomasADemandaProximaManana(String hora) {
    return 'La próxima, mañana a partir de las $hora';
  }

  @override
  String get tomasADemandaAvisoTitulo => 'Es más de lo que se puede';

  @override
  String tomasADemandaAvisoMaximo(int n, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          'Hoy ya has tomado $medicamento $n veces, que es el máximo al día.',
      one: 'Hoy ya has tomado $medicamento 1 vez, que es el máximo al día.',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaAvisoPronto(int horas, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      horas,
      locale: localeName,
      other:
          'Entre una toma de $medicamento y otra tienen que pasar al menos $horas horas.',
      one:
          'Entre una toma de $medicamento y otra tiene que pasar al menos 1 hora.',
    );
    return '$_temp0';
  }

  @override
  String get tomasADemandaAvisoConsejo =>
      'Si tienes dudas, pregunta a tu médico o farmacéutico. ¿Lo anotas igualmente?';

  @override
  String get tomasADemandaAvisoSi => 'Sí, lo he tomado';

  @override
  String get tomasADemandaAvisoNo => 'No, no lo anoto';

  @override
  String tomasADemandaHoy(int veces, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      veces,
      locale: localeName,
      other: 'Hoy lo has tomado $veces veces: a las $horas',
      one: 'Hoy lo has tomado a las $horas',
    );
    return '$_temp0';
  }

  @override
  String historialADemanda(String hora, String medicamento) {
    return '$hora · $medicamento: tomada cuando hacía falta';
  }

  @override
  String get informeADemanda => 'Cuando hacía falta:';

  @override
  String informeADemandaDia(String dia, String tomas) {
    return '$dia: $tomas.';
  }

  @override
  String informeADemandaTomas(String medicamento, String horas) {
    return '$medicamento a las $horas';
  }

  @override
  String get tomasADemandaQuitar => 'Quitar la última';

  @override
  String tomasADemandaQuitarSemantica(String medicamento, String hora) {
    return 'Quitar la toma de $medicamento de las $hora';
  }

  @override
  String get formularioMedicamentoGuardar => 'Guardar medicamento';

  @override
  String existenciasQuedan(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Quedan $cantidad pastillas',
      one: 'Queda 1 pastilla',
      zero: 'No quedan pastillas',
    );
    return '$_temp0';
  }

  @override
  String existenciasPastillas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastillas',
      one: '1 pastilla',
    );
    return '$_temp0';
  }

  @override
  String existenciasPastillasYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastillas y media',
      one: '1 pastilla y media',
      zero: 'media pastilla',
    );
    return '$_temp0';
  }

  @override
  String get existenciasMedia => 'media';

  @override
  String existenciasYMedia(String n) {
    return '$n y media';
  }

  @override
  String existenciasQuedanYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Quedan $n pastillas y media',
      one: 'Queda 1 pastilla y media',
      zero: 'Queda media pastilla',
    );
    return '$_temp0';
  }

  @override
  String existenciasParaDias(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other: 'para unos $dias días',
      one: 'para 1 día',
    );
    return '$_temp0';
  }

  @override
  String get existenciasHastaElFinal =>
      'suficientes hasta el final del tratamiento';

  @override
  String existenciasConDetalle(String quedan, String detalle) {
    return '$quedan, $detalle';
  }

  @override
  String get avisoExistenciasTitulo => 'Te quedan pocas pastillas';

  @override
  String get avisoRecetaTitulo => 'Renueva la receta';

  @override
  String avisoRecetaCuerpo(String medicamento, String fecha) {
    return 'La receta de $medicamento se acaba el $fecha. Pide cita con tu médico para renovarla.';
  }

  @override
  String avisoRecetaCuerpoHoy(String medicamento) {
    return 'La receta de $medicamento se acaba hoy. Pide cita con tu médico para renovarla.';
  }

  @override
  String avisoRecetaCuerpoAcabada(String medicamento, String fecha) {
    return 'La receta de $medicamento se acabó el $fecha. Pide cita con tu médico para renovarla.';
  }

  @override
  String avisoExistenciasSemana(String medicamento, String boton) {
    return '$medicamento: no llegan para una semana. Cuando compres más, pulsa \"$boton\" en tus medicamentos.';
  }

  @override
  String avisoExistenciasQuedan(
    int cantidad,
    String medicamento,
    String boton,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other:
          '$medicamento: quedan $cantidad. Cuando compres más, pulsa \"$boton\" en tus medicamentos.',
      one:
          '$medicamento: queda 1. Cuando compres más, pulsa \"$boton\" en tus medicamentos.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasQuedanYMedia(int n, String medicamento, String boton) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$medicamento: quedan $n y media. Cuando compres más, pulsa \"$boton\" en tus medicamentos.',
      one:
          '$medicamento: queda 1 y media. Cuando compres más, pulsa \"$boton\" en tus medicamentos.',
      zero:
          '$medicamento: queda media. Cuando compres más, pulsa \"$boton\" en tus medicamentos.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasAcabadas(String medicamento, String boton) {
    return '$medicamento: ya no quedan. Cuando compres más, pulsa \"$boton\" en tus medicamentos.';
  }

  @override
  String medicamentoExistenciasPocas(String boton) {
    return 'Quedan pocas. Cuando compres más, pulsa \"$boton\".';
  }

  @override
  String get medicamentoComprarMas => 'He comprado más';

  @override
  String medicamentoComprarMasSemantica(String medicamento) {
    return 'He comprado más $medicamento';
  }

  @override
  String menuExistenciasPocas(String medicamentos) {
    return 'Te quedan pocas pastillas de $medicamentos.';
  }

  @override
  String menuRecetas(String medicamentos) {
    return 'Hay que renovar la receta de $medicamentos.';
  }

  @override
  String get formularioMedicamentoExistenciasTitulo =>
      'Pastillas que te quedan (opcional)';

  @override
  String get formularioMedicamentoExistenciasDescripcion =>
      'Si quieres, la aplicación las cuenta y te avisa antes de que se acaben.';

  @override
  String get formularioMedicamentoSinCuenta => 'No llevar la cuenta';

  @override
  String get formularioMedicamentoSinCuentaDescripcion =>
      'No te avisaremos de cuántas quedan.';

  @override
  String get formularioMedicamentoConCuenta => 'Llevar la cuenta';

  @override
  String get formularioMedicamentoConCuentaDescripcion =>
      'Cada toma se descuenta y te avisaremos cuando queden pocas.';

  @override
  String get formularioMedicamentoExistenciasCampo =>
      'Pastillas que tienes ahora';

  @override
  String get formularioMedicamentoExistenciasCampoDescripcion =>
      'Cuéntalas, o pon las de la caja si está sin empezar. Si queda media, escribe por ejemplo 14,5. Vale también para cápsulas o sobres.';

  @override
  String get formularioMedicamentoPorToma => 'Pastillas en cada toma';

  @override
  String formularioMedicamentoPorTomaValor(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastillas en cada toma',
      one: '1 pastilla en cada toma',
    );
    return '$_temp0';
  }

  @override
  String formularioMedicamentoPorTomaYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastillas y media en cada toma',
      one: '1 pastilla y media en cada toma',
      zero: 'media pastilla en cada toma',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoPorTomaMenos =>
      'Media pastilla menos en cada toma';

  @override
  String get formularioMedicamentoPorTomaMas =>
      'Media pastilla más en cada toma';

  @override
  String formularioMedicamentoPorTomaDeLas(String hora) {
    return 'Pastillas en la toma de las $hora';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMenos(String hora) {
    return 'Media pastilla menos a las $hora';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMas(String hora) {
    return 'Media pastilla más a las $hora';
  }

  @override
  String validadorMedicamentoExistencias(String maximo) {
    return 'Escribe cuántas pastillas tienes: un número entre 0 y $maximo. Si hay media, con coma: 14,5.';
  }

  @override
  String get comprarCampo => '¿Cuántas has comprado?';

  @override
  String get comprarCampoDescripcion =>
      'Mira cuántas trae la caja; por ejemplo, 28.';

  @override
  String comprarTendras(String pastillas) {
    return 'Tendrás $pastillas.';
  }

  @override
  String get comprarAnadir => 'Añadir a las que tengo';

  @override
  String comprarError(String maximo) {
    return 'Escribe cuántas has comprado: un número entre 1 y $maximo.';
  }

  @override
  String get comprarHechoTitulo => 'Pastillas añadidas';

  @override
  String get recetaTitulo => 'Receta renovada';

  @override
  String get recetaPregunta => '¿Hasta qué día es la receta nueva?';

  @override
  String get recetaGuardar => 'Guardar la fecha nueva';

  @override
  String get recetaQuitar => 'Ya no hace falta renovarla';

  @override
  String get recetaQuitarDescripcion =>
      'Quita la fecha: no te avisaremos más de esta receta.';

  @override
  String recetaGuardada(String medicamento, String fecha) {
    return 'Receta de $medicamento: hasta el $fecha.';
  }

  @override
  String recetaQuitada(String medicamento) {
    return 'Ya no te avisaremos de la receta de $medicamento.';
  }

  @override
  String comprarHecho(String pastillas, String medicamento) {
    return 'Ahora tienes $pastillas de $medicamento.';
  }

  @override
  String get compartirDeOtroMovil => 'Medicamentos preparados en otro móvil';

  @override
  String compartirDeOtroMovilExplicacion(String boton) {
    return 'Un familiar puede apuntar tus medicinas y tus citas en su teléfono, con esta misma aplicación, y mandarte una copia con \"$boton\". Aquí las añades sin borrar nada de lo que ya tienes.';
  }

  @override
  String get compartirImportar => 'Añadir medicamentos de otro móvil';

  @override
  String get compartirImportarDescripcion =>
      'Elige la copia que te han enviado. Antes te dirá qué añade.';

  @override
  String get importarNoSePuede =>
      'No se pueden añadir los medicamentos de este fichero';

  @override
  String get importarPregunta => '¿Añadir lo que trae esta copia?';

  @override
  String importarCopiaDel(String fecha, String hora) {
    return 'Copia del $fecha, a las $hora.';
  }

  @override
  String importarSeAnadiran(String medicamentos) {
    return 'Se añadirán: $medicamentos.';
  }

  @override
  String importarSeActualizaran(int cuantos, String medicamentos) {
    String _temp0 = intl.Intl.pluralLogic(
      cuantos,
      locale: localeName,
      other:
          'Ya tenías $medicamentos: se pondrán como en la copia, sin perder las tomas anotadas.',
      one:
          'Ya tenías $medicamentos: se pondrá como en la copia, sin perder las tomas anotadas.',
    );
    return '$_temp0';
  }

  @override
  String importarCitas(String citas) {
    return 'Citas nuevas: $citas.';
  }

  @override
  String get importarNoSeBorra =>
      'No se borra nada: tus tomas anotadas y tus ajustes se quedan como están.';

  @override
  String get importarSi => 'Sí, añadir';

  @override
  String get importarNadaNuevo => 'No hay nada que añadir';

  @override
  String get importarNadaNuevoMensaje =>
      'Esta copia no trae medicamentos ni citas que no tengas.';

  @override
  String get importarHecho => 'Medicamentos añadidos';

  @override
  String get importarError =>
      'No se han podido añadir los medicamentos. Inténtalo otra vez.';

  @override
  String historialResumenSemana(
    String tomadas,
    String total,
    String porcentaje,
  ) {
    return 'En los últimos 7 días has marcado $tomadas de $total tomas ($porcentaje %).';
  }

  @override
  String informeResumenSemana(String tomadas, String total, String porcentaje) {
    return 'Marcadas $tomadas de $total tomas ($porcentaje %).';
  }

  @override
  String get compartirRecordarResumen => 'Recordarme enviarlo cada semana';

  @override
  String get compartirRecordarResumenDescripcion =>
      'Los domingos a las 18:00 te avisaremos para enviar tu medicación y tus tomas.';

  @override
  String get avisoResumenTitulo => '¿Envías tu resumen a la familia?';

  @override
  String avisoResumenCuerpo(String boton) {
    return 'Toca aquí y pulsa \"$boton\" para mandar tu medicación y tus tomas de la semana.';
  }

  @override
  String get widgetTitulo => 'Próxima toma';

  @override
  String get widgetVacio => 'No hay más tomas previstas.';

  @override
  String get ajustesWidget => 'Poner la próxima toma en la pantalla de inicio';

  @override
  String ajustesWidgetDescripcion(String boton) {
    return 'Un recuadro con la próxima toma y el botón \"$boton\", sin abrir la aplicación.';
  }

  @override
  String ajustesWidgetManual(String app) {
    return 'Mantén pulsado un hueco de la pantalla de inicio del teléfono, toca \"Widgets\" y busca \"$app\".';
  }
}
