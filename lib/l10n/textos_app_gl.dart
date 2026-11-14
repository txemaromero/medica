// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class TextosAppGl extends TextosApp {
  TextosAppGl([String locale = 'gl']) : super(locale);

  @override
  String get fechaLunes => 'luns';

  @override
  String get fechaMartes => 'martes';

  @override
  String get fechaMiercoles => 'mércores';

  @override
  String get fechaJueves => 'xoves';

  @override
  String get fechaViernes => 'venres';

  @override
  String get fechaSabado => 'sábado';

  @override
  String get fechaDomingo => 'domingo';

  @override
  String get fechaEnero => 'xaneiro';

  @override
  String get fechaFebrero => 'febreiro';

  @override
  String get fechaMarzo => 'marzo';

  @override
  String get fechaAbril => 'abril';

  @override
  String get fechaMayo => 'maio';

  @override
  String get fechaJunio => 'xuño';

  @override
  String get fechaJulio => 'xullo';

  @override
  String get fechaAgosto => 'agosto';

  @override
  String get fechaSeptiembre => 'setembro';

  @override
  String get fechaOctubre => 'outubro';

  @override
  String get fechaNoviembre => 'novembro';

  @override
  String get fechaDiciembre => 'decembro';

  @override
  String fechaLarga(String diaSemana, String dia, String mes, String anio) {
    return '$diaSemana, $dia de $mes de $anio';
  }

  @override
  String fechaHoy(String fecha) {
    return 'Hoxe, $fecha';
  }

  @override
  String fechaManana(String fecha) {
    return 'Mañá, $fecha';
  }

  @override
  String fechaAyer(String fecha) {
    return 'Onte, $fecha';
  }

  @override
  String fechaCuandoHoy(String hora) {
    return 'hoxe ás $hora';
  }

  @override
  String fechaCuandoManana(String hora) {
    return 'mañá ás $hora';
  }

  @override
  String fechaCuandoOtroDia(
    String diaSemana,
    String dia,
    String mes,
    String hora,
  ) {
    return 'o $diaSemana, $dia de $mes, ás $hora';
  }

  @override
  String get fechaDeLaMadrugada => 'da madrugada';

  @override
  String get fechaDeLaManana => 'da mañá';

  @override
  String get fechaDelMediodia => 'do mediodía';

  @override
  String get fechaDeLaTarde => 'da tarde';

  @override
  String get fechaDeLaNoche => 'da noite';

  @override
  String fechaHoraConParteDelDia(String hora, String parteDelDia) {
    return '$hora $parteDelDia';
  }

  @override
  String fechaListaUltimo(String anteriores, String ultimo) {
    return '$anteriores e $ultimo';
  }

  @override
  String get fechaSeparadorLista => ', ';

  @override
  String get appTitulo => 'Salud y Medicación';

  @override
  String get avisoDeshecho => 'Feito. Desfíxose a acción.';

  @override
  String get avisoNoSeHaPodidoDeshacer =>
      'Non se puido desfacer. Téntao de novo.';

  @override
  String get botonDeshacer => 'Desfacer';

  @override
  String get botonDeshacerPista => 'Desfai o que acabas de facer';

  @override
  String get botonDeshacerPistaEliminar => 'Recupera o que acabas de eliminar';

  @override
  String get barraInicio => 'Inicio';

  @override
  String get barraAtras => 'Atrás';

  @override
  String get barraInicioSemantica => 'Inicio. Volver ao menú principal';

  @override
  String get barraAtrasSemantica => 'Atrás. Volver á pantalla anterior';

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
    return 'Erro: $texto';
  }

  @override
  String get dialogoSiEliminar => 'Si, eliminar';

  @override
  String get dialogoNoVolver => 'Non, volver';

  @override
  String get dialogoAceptar => 'Aceptar';

  @override
  String get dialogoEntendido => 'Entendido';

  @override
  String get dialogoAhoraNo => 'Agora non';

  @override
  String selectorHoraElegida(String hora) {
    return 'Hora escollida: $hora';
  }

  @override
  String get selectorHora => 'Hora';

  @override
  String selectorHoraValor(String hora) {
    return '$hora horas';
  }

  @override
  String get selectorRestarHora => 'Restar unha hora';

  @override
  String get selectorSumarHora => 'Sumar unha hora';

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
  String get selectorAtajoHoy => 'Hoxe';

  @override
  String get selectorAtajoManana => 'Mañá';

  @override
  String get selectorAtajoEnUnaSemana => 'Nunha semana';

  @override
  String selectorDiaElegido(String fecha) {
    return 'Día escollido: $fecha';
  }

  @override
  String get selectorDia => 'Día';

  @override
  String get selectorDiaAnterior => 'Día anterior';

  @override
  String get selectorDiaSiguiente => 'Día seguinte';

  @override
  String get selectorMes => 'Mes';

  @override
  String get selectorMesAnterior => 'Mes anterior';

  @override
  String get selectorMesSiguiente => 'Mes seguinte';

  @override
  String get selectorAnio => 'Ano';

  @override
  String get selectorAnioAnterior => 'Ano anterior';

  @override
  String get selectorAnioSiguiente => 'Ano seguinte';

  @override
  String selectorElegir(String texto) {
    return 'Escoller: $texto';
  }

  @override
  String get menuTitulo => 'Menú principal';

  @override
  String get menuPregunta => 'Que queres facer?';

  @override
  String get menuMedicamentos => 'Rexistro de medicamentos';

  @override
  String get menuAgenda => 'Axenda';

  @override
  String get menuEmergencias => 'Botón de emerxencias';

  @override
  String get menuAjustes => 'Axustes';

  @override
  String menuTomasDeHoy(String tomadas, String total) {
    return 'Tomas de hoxe: $tomadas de $total marcadas.';
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
  String get tomasTitulo => 'Tomas de hoxe';

  @override
  String get medicamentosMenuTomasDescripcion =>
      'Marca as medicinas que xa tomaches hoxe.';

  @override
  String get medicamentosMenuNuevo => 'Rexistrar novo medicamento';

  @override
  String get medicamentosMenuNuevoDescripcion =>
      'Apunta unha medicina e avisarémoste cando teñas que tomala.';

  @override
  String get medicamentosMenuVer => 'Ver medicamentos rexistrados';

  @override
  String get medicamentosMenuVerDescripcion =>
      'Consulta as túas medicinas e as súas horas, cambia o que precises ou borra as que xa non tomes.';

  @override
  String get historialTitulo => 'Historial de tomas';

  @override
  String get medicamentosMenuHistorialDescripcion =>
      'Mira que tomas marcaches nos últimos 7 días.';

  @override
  String get medicamentosMenuCompartir => 'Compartir co médico ou coa familia';

  @override
  String get medicamentosMenuCompartirDescripcion =>
      'Envía ou imprime as túas medicinas, as túas tomas e as túas citas.';

  @override
  String get listaMedicamentosTitulo => 'Medicamentos rexistrados';

  @override
  String get listaMedicamentosPreguntaEliminar =>
      'Seguro que queres eliminar este medicamento?';

  @override
  String listaMedicamentosDetalleEliminar(String medicamento) {
    return '$medicamento\n\nTamén se borrarán os seus avisos.';
  }

  @override
  String get listaMedicamentosErrorEliminar =>
      'Non se puido eliminar o medicamento. Téntao de novo.';

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
      'Aínda non rexistraches ningún medicamento';

  @override
  String get listaMedicamentosVacioExplicacion =>
      'Cando rexistres un, aparecerá aquí coas súas horas de toma.';

  @override
  String listaMedicamentosCuantos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Tes $cantidad medicamentos rexistrados.',
      one: 'Tes 1 medicamento rexistrado.',
    );
    return '$_temp0';
  }

  @override
  String get medicamentoSinFechaDeFin => 'Cada día, sen data de fin';

  @override
  String medicamentoTerminadoEl(String fecha) {
    return 'Tratamento rematado o $fecha';
  }

  @override
  String medicamentoRecetaHasta(String fecha) {
    return 'Receita: ata o $fecha';
  }

  @override
  String medicamentoRecetaPronto(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other:
          'A receita acábase dentro de $dias días: pide cita co teu médico para renovala',
      one: 'A receita acábase mañá: pide cita co teu médico para renovala',
      zero: 'A receita acábase hoxe: pide cita co teu médico para renovala',
    );
    return '$_temp0';
  }

  @override
  String medicamentoRecetaAcabada(String fecha) {
    return 'A receita acabouse o $fecha: pide cita co teu médico para renovala';
  }

  @override
  String get medicamentoRecetaRenovada => 'Xa a renovei';

  @override
  String medicamentoRecetaRenovadaSemantica(String medicamento) {
    return 'Xa renovei a receita de $medicamento';
  }

  @override
  String medicamentoHastaEl(String fecha) {
    return 'Ata o $fecha, incluído';
  }

  @override
  String medicamentoDosis(String dosis) {
    return 'Dose: $dosis';
  }

  @override
  String medicamentoDosisALas(String dosis, String hora) {
    return '$dosis ás $hora';
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
  String get formularioMedicamentoTituloNuevo => 'Novo medicamento';

  @override
  String get formularioMedicamentoTituloModificar => 'Modificar medicamento';

  @override
  String get formularioMedicamentoCrear => 'Crear recordatorio';

  @override
  String get formularioGuardarCambios => 'Gardar cambios';

  @override
  String get formularioMedicamentoGuardado =>
      'Medicamento gardado correctamente';

  @override
  String get formularioCambiosGuardados => 'Cambios gardados correctamente';

  @override
  String formularioFotoAnadida(String boton) {
    return 'Foto engadida. Gardarase ao premer \"$boton\".';
  }

  @override
  String get formularioErrorFotoCamara =>
      'Non se puido facer a foto. Téntao de novo.';

  @override
  String get formularioErrorFotoGaleria =>
      'Non se puido abrir a galería. Téntao de novo.';

  @override
  String formularioFotoQuitada(String boton) {
    return 'Foto quitada. O cambio gardarase ao premer \"$boton\".';
  }

  @override
  String get formularioMedicamentoErrorGuardar =>
      'Non se puido gardar o medicamento. Téntao de novo.';

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
      'Os avisos están desactivados. Podes activalos en Axustes.';

  @override
  String formularioMedicamentoAvisoCadaDia(String horas) {
    return 'Avisarémoste cada día ás $horas.';
  }

  @override
  String formularioMedicamentoAvisoHasta(String horas, String fecha) {
    return 'Avisarémoste ás $horas ata o $fecha, incluído.';
  }

  @override
  String get formularioGuardando => 'Gardando…';

  @override
  String formularioRellenaYPulsa(String boton) {
    return 'Cubre os datos e preme \"$boton\".';
  }

  @override
  String get formularioMedicamentoNombre => 'Nome do medicamento';

  @override
  String get formularioMedicamentoNombreDescripcion =>
      'Por exemplo: Paracetamol.';

  @override
  String get formularioMedicamentoDictarNombre => 'Ditar o nome';

  @override
  String get formularioMedicamentoDictarNombreIndicacion =>
      'Di o nome do medicamento';

  @override
  String get formularioMedicamentoDosis => 'Dose (opcional)';

  @override
  String get formularioMedicamentoDosisDescripcion =>
      'Canto tomas cada vez. Por exemplo: 1 pastilla.';

  @override
  String formularioMedicamentoDosisEnCadaToma(String seccion) {
    return 'A dose cambia segundo a hora: a de cada toma está máis abaixo, en \"$seccion\".';
  }

  @override
  String get formularioMedicamentoDosisTomasTitulo => 'Dose en cada toma';

  @override
  String get formularioMedicamentoDosisTomasDescripcion =>
      'Se cambia segundo a hora; por exemplo, unha pastilla pola mañá e media pola noite.';

  @override
  String get formularioMedicamentoDosisIgual => 'A mesma en todas';

  @override
  String get formularioMedicamentoDosisIgualDescripcion =>
      'A de arriba, no campo da dose.';

  @override
  String get formularioMedicamentoDosisDistinta => 'Distinta segundo a hora';

  @override
  String get formularioMedicamentoDosisDistintaDescripcion =>
      'Escribe abaixo a de cada toma.';

  @override
  String formularioMedicamentoDosisDeLas(String hora) {
    return 'Dose das $hora';
  }

  @override
  String get formularioMedicamentoInstrucciones => 'Instrucións (opcional)';

  @override
  String get formularioMedicamentoInstruccionesDescripcion =>
      'Por exemplo: co almorzo.';

  @override
  String get formularioMedicamentoFoto => 'Foto da caixa (opcional)';

  @override
  String get formularioMedicamentoFotoDescripcion =>
      'Así recoñecerás o medicamento dunha ollada.';

  @override
  String get formularioMedicamentoHacerFoto => 'Facer unha foto';

  @override
  String get formularioMedicamentoHacerOtraFoto => 'Facer outra foto';

  @override
  String get formularioMedicamentoHacerFotoDescripcion =>
      'Coa cámara do teléfono.';

  @override
  String get formularioMedicamentoElegirGaleria => 'Escoller da galería';

  @override
  String get formularioMedicamentoElegirOtraGaleria =>
      'Escoller outra da galería';

  @override
  String get formularioMedicamentoGaleriaDescripcion =>
      'Unha foto que xa teñas no teléfono.';

  @override
  String get formularioMedicamentoQuitarFoto => 'Quitar a foto';

  @override
  String get formularioMedicamentoNumeroTomas => 'Número de tomas ao día';

  @override
  String get formularioMedicamentoNumeroTomasDescripcion =>
      'Cantas veces ao día o tomas?';

  @override
  String get formularioMedicamentoTomasAlDia => 'Tomas ao día';

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
  String get formularioMedicamentoTomaMenos => 'Unha toma menos';

  @override
  String get formularioMedicamentoTomaMas => 'Unha toma máis';

  @override
  String get formularioMedicamentoCadaCuantasHoras => 'Cada cantas horas';

  @override
  String formularioMedicamentoCadaHorasCorto(String horas) {
    return 'Cada $horas h';
  }

  @override
  String formularioMedicamentoCadaHorasValor(String horas) {
    return 'Cada $horas horas';
  }

  @override
  String get formularioMedicamentoHoraMenos => 'Unha hora menos entre tomas';

  @override
  String get formularioMedicamentoHoraMas => 'Unha hora máis entre tomas';

  @override
  String get formularioMedicamentoHoraInicio => 'Hora de inicio';

  @override
  String get formularioMedicamentoHoraInicioDescripcion =>
      'A que hora é a primeira toma do día?';

  @override
  String get formularioMedicamentoDuracion => 'Duración do tratamento';

  @override
  String get formularioMedicamentoDuracionDescripcion =>
      'Tómalo sempre ou só uns días?';

  @override
  String get formularioMedicamentoSiempre => 'Sempre';

  @override
  String get formularioMedicamentoSiempreDescripcion =>
      'Sen data de fin. Por exemplo, unha medicina para a tensión.';

  @override
  String get formularioMedicamentoHastaUnDia => 'Ata un día concreto';

  @override
  String get formularioMedicamentoHastaUnDiaDescripcion =>
      'Por exemplo, un antibiótico durante 7 días.';

  @override
  String get formularioMedicamentoUltimoDiaEtiqueta =>
      'Último día do tratamento';

  @override
  String get formularioMedicamentoUltimoDiaDescripcion =>
      'Ese día aínda hai que tomalo.';

  @override
  String get formularioMedicamentoRecetaTitulo => 'Receita (opcional)';

  @override
  String get formularioMedicamentoRecetaDescripcion =>
      'Se a receita se acaba un día, avisámoste unha semana antes para que pidas cita co teu médico.';

  @override
  String get formularioMedicamentoSinReceta => 'Sen data';

  @override
  String get formularioMedicamentoSinRecetaDescripcion =>
      'Non che avisamos da receita.';

  @override
  String get formularioMedicamentoConReceta => 'Acábase un día concreto';

  @override
  String get formularioMedicamentoConRecetaDescripcion =>
      'Avisámoste unha semana antes e, ata que a renoves, cada día que abras a aplicación.';

  @override
  String get formularioMedicamentoRecetaFecha => 'Último día da receita';

  @override
  String get formularioMedicamentoRecetaFechaDescripcion =>
      'Pono na folla da receita, ou dinche na farmacia.';

  @override
  String get formularioResumen => 'Resumo';

  @override
  String get fotoCaja => 'Foto da caixa';

  @override
  String fotoCajaDe(String medicamento) {
    return 'Foto da caixa de $medicamento';
  }

  @override
  String get fotoNoSePuedeMostrar => 'Non se pode mostrar a foto.';

  @override
  String horarioDescripcion(int tomas, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas tomas ao día, cada $horas horas',
      one: '1 toma ao día',
    );
    return '$_temp0';
  }

  @override
  String get validadorMedicamentoNombreVacio =>
      'Escribe o nome do medicamento. Por exemplo: Paracetamol.';

  @override
  String validadorMedicamentoNombreLargo(String maximo) {
    return 'O nome é demasiado longo. Usa como máximo $maximo letras.';
  }

  @override
  String validadorMedicamentoTomas(String minimo, String maximo) {
    return 'Escolle cantas veces ao día o tomas: entre $minimo e $maximo.';
  }

  @override
  String get validadorMedicamentoFrecuenciaUnaToma =>
      'Con 1 toma ao día non fai falta escoller a frecuencia.';

  @override
  String validadorMedicamentoFrecuencia(String tomas, String horas) {
    return 'Con $tomas tomas ao día, escolle unha frecuencia de $horas horas ou menos.';
  }

  @override
  String validadorMedicamentoDosisLarga(String maximo) {
    return 'A dose é demasiado longa. Usa como máximo $maximo letras.';
  }

  @override
  String validadorMedicamentoInstruccionesLargas(String maximo) {
    return 'As instrucións son demasiado longas. Usa como máximo $maximo letras.';
  }

  @override
  String get validadorMedicamentoHoraInicio =>
      'Escolle a hora da primeira toma.';

  @override
  String validadorMedicamentoFechaFinPasada(String opcion) {
    return 'Ese día xa pasou. Escolle hoxe ou un día futuro, ou marca \"$opcion\" se non ten fin.';
  }

  @override
  String get errorCargarMedicamentos =>
      'Non se puideron cargar os teus medicamentos. Pecha a aplicación e volve abrila.';

  @override
  String get tomasMarcar => 'Xa a tomei';

  @override
  String get tomasDesmarcar => 'Desmarcar';

  @override
  String get tomasVacio => 'Hoxe non tes ningunha toma';

  @override
  String get tomasVacioExplicacion =>
      'Cando rexistres un medicamento, aquí poderás marcar cada toma.';

  @override
  String get tomasEscuchar => 'Escoitar as tomas de hoxe';

  @override
  String get tomasEscucharDescripcion =>
      'Lerache cales tomaches e cales faltan.';

  @override
  String tomasAnotada(String medicamento, String hora) {
    return 'Anotado: tomaches $medicamento ($hora).';
  }

  @override
  String tomasDesmarcada(String medicamento, String hora) {
    return 'Toma desmarcada: $medicamento ($hora).';
  }

  @override
  String get tomasDeshacerMarcarPista => 'Quita a marca desta toma';

  @override
  String get tomasDeshacerDesmarcarPista => 'Volve marcar esta toma';

  @override
  String get tomasErrorCarga =>
      'Non se puideron cargar as túas tomas. Pecha a aplicación e volve abrila.';

  @override
  String tomasHasTomado(String tomadas, String total) {
    return 'Tomaches $tomadas de $total.';
  }

  @override
  String tomasEstadoTomada(String hora) {
    return 'Tomada ás $hora';
  }

  @override
  String tomasEstadoAplazada(String hora) {
    return 'Aprazada: avisarémoste de novo ás $hora';
  }

  @override
  String get tomasEstadoPendiente => 'Pendente';

  @override
  String tomasEstadoSinMarcar(String hora) {
    return 'Sen marcar. Era ás $hora.';
  }

  @override
  String get tomasDesmarcarDescripcion => 'Se a marcaches por erro.';

  @override
  String tomasDesmarcarSemantica(String medicamento, String hora) {
    return 'Desmarcar $medicamento das $hora';
  }

  @override
  String tomasMarcarSemantica(String medicamento, String hora) {
    return 'Xa tomei $medicamento das $hora';
  }

  @override
  String get historialVacio => 'Aínda non hai tomas que mostrar';

  @override
  String get historialVacioExplicacion =>
      'Aquí verás as tomas dos últimos 7 días e cales marcaches como tomadas.';

  @override
  String get historialErrorCarga =>
      'Non se puido cargar o historial. Pecha a aplicación e volve abrila.';

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
    return '$hora · $medicamento: tomada ás $momento';
  }

  @override
  String historialAplazada(String hora, String medicamento) {
    return '$hora · $medicamento: aprazada, sen marcar';
  }

  @override
  String historialPendiente(String hora, String medicamento) {
    return '$hora · $medicamento: pendente';
  }

  @override
  String historialSinMarcar(String hora, String medicamento) {
    return '$hora · $medicamento: sen marcar';
  }

  @override
  String get agendaCrearCita => 'Crear cita';

  @override
  String get agendaCrearCitaDescripcion => 'Apunta unha cita nova.';

  @override
  String get agendaPreguntaEliminar => 'Seguro que queres eliminar esta cita?';

  @override
  String agendaDetalleEliminar(String cita, String fecha, String hora) {
    return '$cita\n$fecha, ás $hora';
  }

  @override
  String get agendaErrorEliminar =>
      'Non se puido eliminar a cita. Téntao de novo.';

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
      'Non se puideron cargar as túas citas. Pecha a aplicación e volve abrila.';

  @override
  String get agendaVacio => 'Aínda non tes ningunha cita';

  @override
  String agendaVacioExplicacion(String boton) {
    return 'Preme o botón \"$boton\" para apuntar a túa primeira cita.';
  }

  @override
  String get agendaProximas => 'Próximas citas';

  @override
  String get agendaSinProximas => 'Non tes citas próximas.';

  @override
  String get agendaPasadas => 'Citas pasadas';

  @override
  String get agendaCitaPasada => 'Esta cita xa pasou.';

  @override
  String agendaModificarSemantica(String cita) {
    return 'Modificar a cita $cita';
  }

  @override
  String agendaEliminarSemantica(String cita) {
    return 'Eliminar a cita $cita';
  }

  @override
  String get formularioCitaTituloModificar => 'Modificar cita';

  @override
  String get formularioCitaGuardar => 'Gardar cita';

  @override
  String get formularioCitaGuardada => 'Cita gardada correctamente';

  @override
  String get formularioCitaErrorGuardar =>
      'Non se puido gardar a cita. Téntao de novo.';

  @override
  String get formularioCitaMuyPronto =>
      'A cita é moi pronto: non dá tempo a avisarte antes.';

  @override
  String formularioCitaTeAvisaremos(String cuando) {
    return 'Avisarémoste $cuando.';
  }

  @override
  String formularioCitaAvisoDiaAntes(String hora) {
    return 'o día antes ás $hora';
  }

  @override
  String formularioCitaAvisoMismoDia(String hora) {
    return 'ese día ás $hora';
  }

  @override
  String get formularioCitaAvisoUnaHoraAntes => 'unha hora antes';

  @override
  String formularioCitaResumenGuardada(String cita, String fecha, String hora) {
    return '$cita\n$fecha, ás $hora.';
  }

  @override
  String get formularioCitaMotivo => 'Motivo da cita';

  @override
  String get formularioCitaMotivoDescripcion =>
      'Por exemplo: Médico de cabeceira.';

  @override
  String get formularioCitaDictarMotivo => 'Ditar o motivo';

  @override
  String get formularioCitaDictarMotivoIndicacion => 'Di o motivo da cita';

  @override
  String get formularioCitaFecha => 'Data';

  @override
  String get formularioCitaFechaDescripcion => 'Que día é a cita?';

  @override
  String get formularioCitaHora => 'Hora';

  @override
  String get formularioCitaHoraDescripcion => 'A que hora é a cita?';

  @override
  String get formularioCitaLugar => 'Lugar (opcional)';

  @override
  String get formularioCitaLugarDescripcion => 'Por exemplo: Centro de saúde.';

  @override
  String get formularioCitaNotas => 'Notas (opcional)';

  @override
  String get formularioCitaNotasDescripcion =>
      'Por exemplo: levar as análises.';

  @override
  String get validadorCitaMotivoVacio =>
      'Escribe o motivo da cita. Por exemplo: Médico de cabeceira.';

  @override
  String validadorCitaMotivoLargo(String maximo) {
    return 'O motivo é demasiado longo. Usa como máximo $maximo letras.';
  }

  @override
  String get validadorCitaDia => 'Escolle o día da cita.';

  @override
  String get validadorCitaHora => 'Escolle a hora da cita.';

  @override
  String get validadorCitaDiaPasado =>
      'Ese día xa pasou. Escolle hoxe ou un día futuro.';

  @override
  String get validadorCitaHoraPasada =>
      'Esa hora xa pasou. Escolle unha hora máis tarde.';

  @override
  String validadorCitaLugarLargo(String maximo) {
    return 'O lugar é demasiado longo. Usa como máximo $maximo letras.';
  }

  @override
  String validadorCitaNotasLargas(String maximo) {
    return 'As notas son demasiado longas. Usa como máximo $maximo letras.';
  }

  @override
  String get emergenciasTitulo => 'Emerxencias';

  @override
  String get emergenciasLlamar => 'Chamar';

  @override
  String emergenciasLlamarAlNumero(String numero) {
    return 'Chamar ao $numero';
  }

  @override
  String emergenciasLlamarA(String nombre) {
    return 'Chamar a $nombre';
  }

  @override
  String emergenciasAbriendoNumero(String numero) {
    return 'Abrindo o teléfono para chamar ao $numero…';
  }

  @override
  String emergenciasAbriendoNombre(String nombre) {
    return 'Abrindo o teléfono para chamar a $nombre…';
  }

  @override
  String get emergenciasNoSeHaPodidoAbrir => 'Non se puido abrir o teléfono';

  @override
  String emergenciasMarcaAMano(String numero) {
    return 'Marca o $numero a man desde a aplicación de teléfono.';
  }

  @override
  String get emergenciasIrAAjustes => 'Ir a Axustes';

  @override
  String get emergenciasIrAAjustesDescripcion =>
      'Alí podes gardar o número de emerxencia.';

  @override
  String get emergenciasSinNumero =>
      'Aínda non gardaches un número de emerxencia';

  @override
  String get emergenciasSinNumeroExplicacion =>
      'Para poder chamar desde aquí, primeiro escribe o número en Axustes. Por exemplo, o 112.';

  @override
  String emergenciasPulsaParaLlamar(String numero) {
    return 'Preme o botón para chamar ao $numero.';
  }

  @override
  String get emergenciasExplicacion =>
      'Abrirase o teléfono co número xa escrito. Para falar, preme o botón de chamada do teléfono.';

  @override
  String get ajustesSonidosActivados => 'Sons activados';

  @override
  String get ajustesSonidosDesactivados => 'Sons desactivados';

  @override
  String get ajustesVibracionActivada => 'Vibración activada';

  @override
  String get ajustesVibracionDesactivada => 'Vibración desactivada';

  @override
  String get ajustesLecturaActivada => 'Lectura en voz alta activada';

  @override
  String get ajustesLecturaDesactivada => 'Lectura en voz alta desactivada';

  @override
  String get ajustesSinVozTitulo => 'Este teléfono non pode ler en voz alta';

  @override
  String get ajustesSinVozMensaje =>
      'Fáltalle a voz en galego. Pódese instalar na Configuración do teléfono, en Accesibilidade, opción \"Saída de texto a voz\".';

  @override
  String get ajustesSinVozMensajeIphone =>
      'Fáltalle a voz en galego. Pódese descargar nos axustes do iPhone: Accesibilidade → Contido falado → Voces.';

  @override
  String ajustesNumeroGuardado(String numero) {
    return 'Número de emerxencia gardado: $numero';
  }

  @override
  String ajustesContactoGuardado(String nombre, String numero) {
    return 'Contacto gardado: $nombre, $numero';
  }

  @override
  String get ajustesContactoBorrado => 'Contacto do familiar borrado';

  @override
  String get ajustesCambiosAlMomento => 'Os cambios gárdanse ao momento.';

  @override
  String get ajustesActivarSonidos => 'Activar sons';

  @override
  String get ajustesActivarSonidosDescripcion => 'Os avisos soarán.';

  @override
  String get ajustesActivarVibracion => 'Activar vibración';

  @override
  String get ajustesActivarVibracionDescripcion =>
      'O teléfono vibrará con cada aviso.';

  @override
  String get ajustesActivarNotificaciones => 'Activar notificacións';

  @override
  String get ajustesActivarNotificacionesDescripcion =>
      'Recibirás avisos das túas medicinas e das túas citas.';

  @override
  String get ajustesProbarAviso => 'Probar aviso';

  @override
  String get ajustesProbarAvisoDescripcion =>
      'Envía un aviso agora para comprobar como soa e como se ve.';

  @override
  String get ajustesRepetirAvisos => 'Repetir os avisos';

  @override
  String ajustesRepetirAvisosDescripcion(String boton) {
    return 'Cando che avisamos outra vez se non marcas unha toma, e canto espera o botón \"$boton\".';
  }

  @override
  String get ajustesAvisosDiscretos => 'Avisos discretos';

  @override
  String get ajustesAvisosDiscretosDescripcion =>
      'Os avisos non dirán que medicina toca nin o motivo da cita, nin levarán a foto da caixa: así non se verán na pantalla de bloqueo. Ao tocar o aviso, a aplicación diracho.';

  @override
  String get ajustesAvisosDiscretosActivados => 'Avisos discretos activados';

  @override
  String get ajustesAvisosDiscretosDesactivados =>
      'Avisos discretos desactivados';

  @override
  String get repetirSinMarcarTitulo => 'Se non marcas a toma';

  @override
  String get repetirSinMarcarDescripcion =>
      'Avisámoste unha vez máis, por se non oíches o primeiro aviso.';

  @override
  String repetirALosMinutos(int minutos) {
    return 'Aos $minutos minutos';
  }

  @override
  String get repetirALaHora => 'Ao cabo dunha hora';

  @override
  String get repetirNunca => 'Non repetir o aviso';

  @override
  String repetirEjemplo(String hora, String repeticion) {
    return 'Unha toma das $hora repítese ás $repeticion.';
  }

  @override
  String get repetirNuncaDescripcion => 'Só soa o aviso da súa hora.';

  @override
  String get repetirAplazarTitulo => 'Lembrar máis tarde';

  @override
  String get repetirAplazarDescripcion =>
      'Os avisos das tomas levan un botón para que cho lembremos un pouco despois.';

  @override
  String repetirAplazarEjemplo(String hora, String despues) {
    return 'Se o premes ás $hora, lembrámoscho ás $despues.';
  }

  @override
  String repetirGuardado(String opcion) {
    return 'Gardado: $opcion';
  }

  @override
  String get ajustesLeerEnVozAlta => 'Ler en voz alta';

  @override
  String get ajustesLeerEnVozAltaDescripcion =>
      'Lerá os avisos ao abrilos e poderás escoitar as tomas de hoxe.';

  @override
  String get ajustesNumeroEmergencia => 'N.º de emerxencia';

  @override
  String get ajustesNumeroEmergenciaDescripcion =>
      'O número ao que chamará o botón de emerxencias. Por exemplo: 112.';

  @override
  String get ajustesGuardarNumero => 'Gardar número';

  @override
  String get ajustesNombreFamiliar => 'Nome dun familiar';

  @override
  String get ajustesNombreFamiliarDescripcion =>
      'Outra persoa á que poderás chamar desde Emerxencias. Por exemplo: A miña filla Ana.';

  @override
  String get ajustesTelefonoFamiliar => 'Teléfono do familiar';

  @override
  String get ajustesGuardarContacto => 'Gardar contacto';

  @override
  String get ajustesGuardarContactoDescripcion =>
      'Para borralo, deixa os dous campos baleiros.';

  @override
  String get ajustesTamanoTexto => 'Axustar tamaño do texto';

  @override
  String get ajustesTamanoTextoDescripcion =>
      'Fai as letras máis grandes ou máis pequenas.';

  @override
  String get ajustesTema => 'Axustar tema';

  @override
  String get ajustesTemaDescripcion => 'Cambia as cores da aplicación.';

  @override
  String get compartirTitulo => 'Compartir e copia de seguranza';

  @override
  String get ajustesCompartirDescripcion =>
      'Envía a túa medicación ao médico ou á familia e garda os teus datos para non perdelos.';

  @override
  String get permisosNotificacionesActivadas => 'Notificacións activadas';

  @override
  String get permisosNotificacionesDesactivadas => 'Notificacións desactivadas';

  @override
  String get permisosDenegado =>
      'O teléfono non deu permiso para mostrar avisos, así que seguen desactivados.';

  @override
  String get permisosHoraExactaTitulo => 'Avisos á hora exacta';

  @override
  String permisosHoraExactaMensaje(String boton) {
    return 'As notificacións xa están activadas. Para que os avisos cheguen xusto á súa hora, o teléfono necesita un permiso máis.\n\nSe premes \"$boton\", abrirase unha pantalla do teléfono: activa a opción e volve co botón Atrás.';
  }

  @override
  String get permisosDarPermiso => 'Dar permiso';

  @override
  String get permisosHoraExactaConcedido =>
      'Listo: os avisos chegarán á súa hora exacta.';

  @override
  String get permisosHoraExactaDenegado =>
      'Sen ese permiso, os avisos poden chegar uns minutos tarde.';

  @override
  String get permisosFaltaTitulo => 'Falta o permiso do teléfono';

  @override
  String permisosFaltaMensaje(String explicacion, String boton) {
    return '$explicacion\n\nPreme \"$boton\", activa as notificacións e volve co botón Atrás.';
  }

  @override
  String get permisosAbrirAjustes => 'Abrir a Configuración do teléfono';

  @override
  String get permisosPruebaEnviada =>
      'Aviso de proba enviado. Mira a parte de arriba da pantalla.';

  @override
  String get permisosPruebaDesactivadasTitulo =>
      'As notificacións están desactivadas';

  @override
  String permisosPruebaDesactivadasMensaje(String interruptor, String boton) {
    return 'Activa primeiro \"$interruptor\" e despois volve premer \"$boton\".';
  }

  @override
  String get permisosPruebaSinPermiso =>
      'O teléfono non deixa mostrar os avisos desta aplicación.';

  @override
  String get temaPredeterminado => 'Tema predeterminado';

  @override
  String get temaPredeterminadoDescripcion =>
      'Fondo azul claro e letras negras.';

  @override
  String get temaOscuro => 'Tema escuro';

  @override
  String get temaOscuroDescripcion =>
      'Fondo escuro e letras brancas. Cansa menos a vista con pouca luz.';

  @override
  String get temaAlternativo => 'Tema alternativo';

  @override
  String get temaAlternativoDescripcion =>
      'Fondo amarelo suave e letras negras. Reduce os reflexos.';

  @override
  String get temaTitulo => 'Tema';

  @override
  String get temaAplicar => 'Aplicar este tema';

  @override
  String temaAplicado(String tema) {
    return 'Tema aplicado: $tema';
  }

  @override
  String get temaToca => 'Toca un tema para velo na mostra.';

  @override
  String temaMuestra(String tema) {
    return 'Mostra: $tema';
  }

  @override
  String get temaYaLoUsas => 'Este é o tema que xa usas.';

  @override
  String temaAhoraUsas(String tema) {
    return 'Agora usas: $tema.';
  }

  @override
  String get temaElegido => 'Escollido';

  @override
  String get temaEnUso => 'En uso';

  @override
  String get temaSeparadorEstado => ' · ';

  @override
  String get temaMuestraTexto => 'Así se verán as pantallas con este tema.';

  @override
  String get temaMuestraBoton => 'Botón de exemplo';

  @override
  String get temaMuestraInterruptor => 'Interruptor de exemplo';

  @override
  String get temaMuestraInterruptorDescripcion => 'Verde é activado.';

  @override
  String get tamanoTitulo => 'Tamaño do texto';

  @override
  String get tamanoAumentar => 'Aumentar (+)';

  @override
  String get tamanoReducir => 'Reducir (−)';

  @override
  String get tamanoMuestraTexto =>
      'Así se verán os textos da aplicación. Por exemplo: Paracetamol, 3 tomas ao día, cada 8 horas.';

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
    return 'Podes escoller entre $minimo e $maximo. O cambio aplícase a toda a aplicación.';
  }

  @override
  String get tamanoMasGrandes => 'Letras máis grandes.';

  @override
  String get tamanoYaMaximo => 'Xa está no tamaño máximo.';

  @override
  String get tamanoMasPequenas => 'Letras máis pequenas.';

  @override
  String get tamanoYaMinimo => 'Xa está no tamaño mínimo.';

  @override
  String get tamanoMuestra => 'Mostra';

  @override
  String get ajustesFraseDePruebaVoz =>
      'Así soará a voz. Lerei os teus avisos e as túas tomas de hoxe.';

  @override
  String get validadorFamiliarNombreVacio =>
      'Escribe como se chama. Por exemplo: A miña filla Ana.';

  @override
  String validadorFamiliarNombreLargo(String maximo) {
    return 'O nome é demasiado longo: como moito $maximo letras.';
  }

  @override
  String get validadorFamiliarNumeroVacio =>
      'Escribe o seu número de teléfono.';

  @override
  String get validadorTelefonoVacio =>
      'Escribe un número de teléfono. Por exemplo: 112.';

  @override
  String get validadorTelefonoSoloNumeros =>
      'Escribe só números. Por exemplo: 112 ou 600123456.';

  @override
  String validadorTelefonoCorto(String minimo) {
    return 'O número é demasiado curto. Debe ter polo menos $minimo cifras.';
  }

  @override
  String get validadorTelefonoLargo =>
      'O número é demasiado longo. Revisa que estea ben escrito.';

  @override
  String get asistenteTitulo => 'Primeiros pasos';

  @override
  String get asistenteEmpezar => 'Comezar';

  @override
  String get asistenteSaltar => 'Saltar estes pasos';

  @override
  String get asistenteSaltarDescripcion => 'Ir directamente ao menú principal.';

  @override
  String get asistenteSiguiente => 'Seguinte';

  @override
  String get asistenteTerminar => 'Comezar a usar a aplicación';

  @override
  String get asistenteHola => 'Ola';

  @override
  String get asistenteBienvenida =>
      'Imos preparar a aplicación en 3 pasos: o tamaño da letra, os avisos e o número de emerxencia.';

  @override
  String get asistenteCambiarEnAjustes =>
      'Podes cambialo todo máis tarde en Axustes.';

  @override
  String asistentePaso(String numero, String total, String titulo) {
    return 'Paso $numero de $total: $titulo';
  }

  @override
  String get asistenteTamanoTitulo => 'Tamaño da letra';

  @override
  String get asistenteTamanoExplicacion =>
      'Les ben este texto? Se che custa, fai as letras máis grandes.';

  @override
  String get asistenteAvisosTitulo => 'Avisos de medicinas e citas';

  @override
  String get asistenteAvisosExplicacion =>
      'Avisarémoste á hora de cada medicina e antes de cada cita, con son e vibración.';

  @override
  String get asistenteActivarAvisos => 'Activar os avisos';

  @override
  String get asistenteActivarAvisosDescripcion =>
      'O teléfono pedirache permiso: preme \"Permitir\".';

  @override
  String asistenteSiPrefieresNo(String boton) {
    return 'Se prefires non activalos agora, preme \"$boton\".';
  }

  @override
  String get asistenteConSonido => 'con son';

  @override
  String get asistenteSinSonido => 'sen son';

  @override
  String get asistenteConVibracion => 'con vibración';

  @override
  String get asistenteSinVibracion => 'sen vibración';

  @override
  String asistenteAvisosActivados(String sonido, String vibracion) {
    return 'Os avisos están activados, $sonido e $vibracion.';
  }

  @override
  String get asistenteProbarAvisoDescripcion =>
      'Envía un aviso agora para ver como soa e como se ve.';

  @override
  String get asistenteEmergenciaTitulo => 'Número de emerxencia';

  @override
  String get asistenteEmergenciaExplicacion =>
      'O botón de emerxencias chamará a este número. Pode ser o 112 ou o dun familiar.';

  @override
  String get asistenteEmergenciaDescripcion =>
      'Se non queres poñelo agora, déixao baleiro.';

  @override
  String get asistenteTodoListo => 'Todo listo';

  @override
  String asistenteResumenTamano(String tamano) {
    return 'Tamaño da letra: $tamano.';
  }

  @override
  String get asistenteResumenAvisosActivados => 'Avisos activados.';

  @override
  String get asistenteResumenAvisosDesactivados =>
      'Avisos desactivados. Podes activalos en Axustes.';

  @override
  String asistenteResumenNumero(String numero) {
    return 'Número de emerxencia: $numero.';
  }

  @override
  String get asistenteResumenSinNumero =>
      'Sen número de emerxencia. Podes poñelo en Axustes.';

  @override
  String get asistenteTambienEnAjustes =>
      'En Axustes tamén podes escoller as cores e activar a lectura en voz alta.';

  @override
  String get compartirEnviarInforme => 'Enviar a miña medicación e citas';

  @override
  String get compartirEnviarInformeDescripcion =>
      'Por WhatsApp, correo… Na pantalla seguinte escolles a quen.';

  @override
  String get compartirImprimir => 'Imprimir';

  @override
  String get compartirImprimirDescripcion =>
      'Nunha impresora conectada ao teléfono, ou gardalo como PDF.';

  @override
  String get compartirGuardarCopia => 'Gardar unha copia';

  @override
  String get compartirGuardarCopiaDescripcion =>
      'En Google Drive ou no cartafol de descargas.';

  @override
  String get compartirEnviarCopia => 'Enviar unha copia';

  @override
  String get compartirEnviarCopiaDescripcion =>
      'Por correo ou WhatsApp: ao teu propio correo ou a un familiar.';

  @override
  String get compartirRecuperar => 'Recuperar unha copia';

  @override
  String get compartirRecuperarDescripcion =>
      'Cambia os datos deste teléfono polos dunha copia. Antes preguntarache.';

  @override
  String get compartirSiRecuperar => 'Si, recuperar a copia';

  @override
  String get compartirErrorDocumento =>
      'Non se puido preparar o documento. Téntao de novo.';

  @override
  String get compartirErrorImprimir =>
      'Non se puido abrir a impresión. Téntao de novo.';

  @override
  String get compartirCopiaGuardada => 'Copia de seguranza gardada.';

  @override
  String get compartirErrorGuardarCopia =>
      'Non se puido gardar a copia. Téntao de novo.';

  @override
  String get compartirErrorEnviarCopia =>
      'Non se puido preparar a copia. Téntao de novo.';

  @override
  String get compartirNoSePuedeRecuperar =>
      'Non se pode recuperar este ficheiro';

  @override
  String get compartirSustitucionVacio =>
      'Porase neste teléfono o que hai na copia.';

  @override
  String compartirSustitucion(String actual) {
    return 'Borrarase o que hai agora neste teléfono ($actual) e porase o da copia.';
  }

  @override
  String get compartirPreguntaRecuperar => 'Recuperar esta copia?';

  @override
  String compartirCopiaDel(String fecha, String hora, String resumen) {
    return 'Copia do $fecha, ás $hora: $resumen.';
  }

  @override
  String compartirCopiaEmergencia(String numero) {
    return 'Número de emerxencia: $numero.';
  }

  @override
  String get compartirCopiaSinEmergencia => 'Sen número de emerxencia.';

  @override
  String compartirCopiaFamiliar(String familiar) {
    return 'Familiar: $familiar.';
  }

  @override
  String get compartirCopiaSinFamiliar => 'Sen familiar.';

  @override
  String get compartirCopiaRecuperada => 'Copia recuperada';

  @override
  String compartirYaTienes(String resumen) {
    return 'Xa tes neste teléfono $resumen.';
  }

  @override
  String get compartirAvisosDesactivados =>
      'Os avisos están desactivados neste teléfono: actívaos en Axustes para recibilos.';

  @override
  String get compartirErrorRecuperar =>
      'Non se puido recuperar a copia. Téntao de novo.';

  @override
  String get compartirParaElMedico => 'Para o médico ou a familia';

  @override
  String get compartirParaElMedicoExplicacion =>
      'Un documento coas túas medicinas, as túas tomas da última semana e as túas próximas citas.';

  @override
  String get compartirCopiaDeSeguridad => 'Copia de seguranza';

  @override
  String compartirCopiaExplicacion(String boton) {
    return 'Garda nun ficheiro todos os teus datos: medicinas coas súas fotos, tomas, citas e axustes. Nun móbil novo, instala a aplicación e preme \"$boton\".';
  }

  @override
  String get compartirUnMomento => 'Un momento, por favor…';

  @override
  String copiaNoEsCopia(String app) {
    return 'Este ficheiro non é unha copia de $app, ou está danado.';
  }

  @override
  String copiaDemasiadoGrande(String app) {
    return 'Este ficheiro é demasiado grande para ser unha copia de $app.';
  }

  @override
  String get copiaVersionNueva =>
      'Esta copia é dunha versión máis nova da aplicación. Actualiza a aplicación e téntao de novo.';

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
    return 'Copia de seguranza de $app';
  }

  @override
  String get informeTitulo => 'A miña medicación e as miñas citas';

  @override
  String informeNombreFichero(String fecha) {
    return 'Medicación e citas $fecha';
  }

  @override
  String informePagina(String pagina, String total) {
    return 'Páxina $pagina de $total';
  }

  @override
  String informeActualizado(String fecha, String hora) {
    return 'Actualizado o $fecha, ás $hora.';
  }

  @override
  String informeTelefonosEmergencia(String telefonos) {
    return 'Teléfonos de emerxencia: $telefonos.';
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
  String get informeSinMedicamentos => 'Non hai medicamentos rexistrados.';

  @override
  String informeTomasYHoras(String tomas, String horas) {
    return '$tomas: $horas';
  }

  @override
  String informeInstrucciones(String instrucciones) {
    return 'Instrucións: $instrucciones';
  }

  @override
  String informeTomasUltimosDias(String dias) {
    return 'Tomas dos últimos $dias días';
  }

  @override
  String get informeColumnaDia => 'Día';

  @override
  String get informeColumnaTomadas => 'Tomadas';

  @override
  String get informeColumnaSinMarcar => 'Sen marcar';

  @override
  String get informeHoy => 'Hoxe';

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
    return '$tomadas de $total ($pendientes por chegar)';
  }

  @override
  String informeTomaSinMarcar(String hora, String medicamento) {
    return '$hora $medicamento';
  }

  @override
  String informeYMas(String lista, String mas) {
    return '$lista e $mas máis';
  }

  @override
  String get informeSinTomas => 'Non hai tomas nestes días.';

  @override
  String get informeProximasCitas => 'Próximas citas';

  @override
  String get informeSinCitas => 'Non hai citas próximas.';

  @override
  String informeCitaCuando(String fecha, String hora) {
    return '$fecha, ás $hora';
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
  String get canalConSonidoYVibracion => 'Avisos con son e vibración';

  @override
  String get canalConSonido => 'Avisos con son';

  @override
  String get canalConVibracion => 'Avisos con vibración';

  @override
  String get canalSilencioso => 'Avisos silenciosos';

  @override
  String get canalDescripcion => 'Avisos de tomas de medicamentos e de citas.';

  @override
  String get avisoNotaRenovar =>
      'Abre a aplicación para seguir recibindo estes avisos.';

  @override
  String get avisoTomaTitulo => 'Hora da túa medicina';

  @override
  String get avisoAplazadoTitulo => 'Lembra a túa medicina';

  @override
  String get avisoRepeticionTitulo => 'Tomaches a túa medicina?';

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
    return 'Era ás $hora: $medicamento. Se xa a tomaches, preme \"$boton\".';
  }

  @override
  String avisoRepeticionCuerpoConDosis(
    String hora,
    String medicamento,
    String dosis,
    String boton,
  ) {
    return 'Era ás $hora: $medicamento: $dosis. Se xa a tomaches, preme \"$boton\".';
  }

  @override
  String avisoTomaCuerpoDiscreto(String hora) {
    return 'A das $hora. Toca aquí para ver cal é.';
  }

  @override
  String avisoRepeticionCuerpoDiscreto(String hora) {
    return 'Era ás $hora. Toca aquí para ver cal é.';
  }

  @override
  String get avisoExistenciasCuerpoDiscreto =>
      'Dunha das túas medicinas. Toca aquí para ver cal é.';

  @override
  String get avisoRecetaCuerpoDiscreto =>
      'A dunha das túas medicinas. Toca aquí para ver cal é.';

  @override
  String avisoCitaCuerpoDiscreto(String hora) {
    return 'Ás $hora. Toca aquí para ver cal é.';
  }

  @override
  String get avisoCitaHoy => 'Hoxe tes unha cita';

  @override
  String get avisoCitaManana => 'Mañá tes unha cita';

  @override
  String get avisoCitaUnaHora => 'A túa cita é dentro de 1 hora';

  @override
  String avisoCitaCuerpo(String cita, String hora) {
    return '$cita ás $hora.';
  }

  @override
  String avisoCitaCuerpoConLugar(String cita, String hora, String lugar) {
    return '$cita ás $hora en $lugar.';
  }

  @override
  String avisoAplazar(int minutos) {
    return 'Lembrar en $minutos min';
  }

  @override
  String get avisoPruebaTitulo => 'Aviso de proba';

  @override
  String get avisoPruebaCuerpo =>
      'Así te avisaremos das túas medicinas e das túas citas.';

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
    return 'Medicina das $hora: $detalle Cando a tomes, preme: $boton.';
  }

  @override
  String vozCita(String cita, String cuando) {
    return 'Tes unha cita: $cita, $cuando.';
  }

  @override
  String vozCitaConLugar(String cita, String cuando, String lugar) {
    return 'Tes unha cita: $cita, $cuando, en $lugar.';
  }

  @override
  String get vozSinTomas => 'Hoxe non tes ningunha toma.';

  @override
  String vozTotalTomas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad tomas',
      one: 'unha toma',
    );
    return '$_temp0';
  }

  @override
  String vozTodasTomadas(String total) {
    return 'Hoxe tes $total e xa as tomaches todas.';
  }

  @override
  String vozHasTomado(String total, String tomadas) {
    return 'Hoxe tes $total. Tomaches $tomadas.';
  }

  @override
  String vozTeFaltan(int cantidad, String lista) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Fáltanche: $lista',
      one: 'Fáltache: $lista',
    );
    return '$_temp0';
  }

  @override
  String vozNombreConDosis(String medicamento, String dosis) {
    return '$medicamento, $dosis';
  }

  @override
  String vozFaltanteSinMarcar(String medicamento, String hora) {
    return '$medicamento, das $hora, sen marcar.';
  }

  @override
  String vozFaltanteAplazada(String medicamento, String hora) {
    return '$medicamento, das $hora, aprazada.';
  }

  @override
  String vozFaltantePendiente(String medicamento, String hora) {
    return '$medicamento, ás $hora.';
  }

  @override
  String vozHasDictado(String texto) {
    return 'Ditaches: $texto. Se non é correcto, volve ditalo ou corríxeo co teclado.';
  }

  @override
  String get vozNoPuedeDictar =>
      'Este teléfono non permite ditar. Escríbeo co teclado.';

  @override
  String get vozDictarDescripcion => 'Dio en voz alta e escribirase só.';

  @override
  String respuestaAplazada(String hora) {
    return 'Avisarémoste de novo ás $hora.';
  }

  @override
  String get respuestaSinMedicamento =>
      'Ese medicamento xa non está rexistrado.';

  @override
  String get estadoAvisosListos =>
      'Os avisos están listos para chegar á súa hora.';

  @override
  String get estadoAvisosSinPermiso =>
      'O teléfono non deixa que esta aplicación mostre avisos, así que non chegarán.';

  @override
  String get estadoAvisosSinHoraExacta =>
      'Falta o permiso de hora exacta: os avisos poden chegar uns minutos tarde.';

  @override
  String get estadoAvisosAhorroBateria =>
      'O aforro de batería do teléfono pode atrasar os avisos ou impedir que cheguen.';

  @override
  String get estadoAvisosBotonPermiso => 'Dar permiso para os avisos';

  @override
  String get estadoAvisosBotonHoraExacta => 'Dar permiso de hora exacta';

  @override
  String get estadoAvisosBotonBateria => 'Quitar o aforro de batería';

  @override
  String get estadoAvisosPermisoConcedido =>
      'Listo: os avisos xa poden chegar.';

  @override
  String get bateriaTitulo => 'Aforro de batería';

  @override
  String bateriaMensaje(String boton) {
    return 'Algúns teléfonos pechan as aplicacións para aforrar batería, e entón os avisos chegan tarde ou non chegan.\n\nSe premes \"$boton\", abrirase a pantalla desta aplicación na Configuración do teléfono. Toca \"Batería\" (ou \"Uso da batería\"), escolle \"Sen restricións\" e volve co botón Atrás.';
  }

  @override
  String get bateriaAbrir => 'Abrir a Configuración';

  @override
  String get menuAvisosSinPermiso =>
      'Os avisos non poden chegar: o teléfono non lle dá permiso a esta aplicación.';

  @override
  String get formularioRecuperado => 'Recuperamos o que estabas escribindo.';

  @override
  String formularioRecuperadoConFoto(String boton) {
    return 'Recuperamos o que estabas escribindo e a foto. Gardarase ao premer \"$boton\".';
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
      other: '$tomas tomas ao día',
      one: '1 toma ao día',
    );
    return '$_temp0';
  }

  @override
  String get semanaLunes => 'luns';

  @override
  String get semanaMartes => 'martes';

  @override
  String get semanaMiercoles => 'mércores';

  @override
  String get semanaJueves => 'xoves';

  @override
  String get semanaViernes => 'venres';

  @override
  String get semanaSabado => 'sábados';

  @override
  String get semanaDomingo => 'domingos';

  @override
  String diasSemanaFrase(String dias) {
    return 'os $dias';
  }

  @override
  String diasCadaFrase(String cada, String fecha) {
    return 'cada $cada días, a partir do $fecha';
  }

  @override
  String get validadorMedicamentoHorasRepetidas =>
      'Hai dúas tomas á mesma hora. Cambia unha delas.';

  @override
  String get validadorMedicamentoSinDias =>
      'Escolle polo menos un día da semana.';

  @override
  String validadorMedicamentoCadaDias(String minimo, String maximo) {
    return 'Escolle cada cantos días o tomas: entre $minimo e $maximo.';
  }

  @override
  String get formularioMedicamentoHorasTitulo => 'A que horas o tomas?';

  @override
  String get formularioMedicamentoHorasDescripcion =>
      'Escolle como se reparten as tomas ao longo do día.';

  @override
  String get formularioMedicamentoRepartidas => 'Repartidas por igual';

  @override
  String get formularioMedicamentoRepartidasDescripcion =>
      'Cada certo número de horas, desde a primeira toma.';

  @override
  String get formularioMedicamentoConcretas => 'A horas concretas';

  @override
  String get formularioMedicamentoConcretasDescripcion =>
      'Por exemplo, co almorzo, o xantar e a cea.';

  @override
  String formularioMedicamentoHoraToma(String numero) {
    return 'Toma $numero';
  }

  @override
  String get formularioMedicamentoHoraUnaToma => 'Hora da toma';

  @override
  String get formularioMedicamentoHoraUnaTomaDescripcion =>
      'A que hora o tomas?';

  @override
  String get formularioMedicamentoDiasTitulo => 'Que días o tomas?';

  @override
  String get formularioMedicamentoDiasDescripcion =>
      'Escolle se o tomas a diario ou só algúns días.';

  @override
  String get formularioMedicamentoTodosLosDias => 'Todos os días';

  @override
  String get formularioMedicamentoTodosLosDiasDescripcion =>
      'Cada día, sen saltar ningún.';

  @override
  String get formularioMedicamentoAlgunosDias => 'Algúns días da semana';

  @override
  String get formularioMedicamentoAlgunosDiasDescripcion =>
      'Por exemplo, unha pastilla que se toma os luns.';

  @override
  String get formularioMedicamentoCadaVariosDias => 'Cada varios días';

  @override
  String get formularioMedicamentoCadaVariosDiasDescripcion =>
      'Por exemplo, un día si e outro non.';

  @override
  String get formularioMedicamentoCadaCuantosDias => 'Cada cantos días';

  @override
  String formularioMedicamentoCadaDiasValor(String dias) {
    return 'Cada $dias días';
  }

  @override
  String get formularioMedicamentoDiaMenos => 'Un día menos entre tomas';

  @override
  String get formularioMedicamentoDiaMas => 'Un día máis entre tomas';

  @override
  String get formularioMedicamentoPrimerDia => 'Primeiro día';

  @override
  String get formularioMedicamentoPrimerDiaDescripcion =>
      'O primeiro día que o tomas.';

  @override
  String formularioMedicamentoAvisoDias(String dias, String horas) {
    return 'Avisarémoste ás $horas $dias.';
  }

  @override
  String formularioMedicamentoAvisoDiasHasta(
    String dias,
    String horas,
    String fecha,
  ) {
    return 'Avisarémoste ás $horas $dias, ata o $fecha, incluído.';
  }

  @override
  String get medicamentoSinFechaDeFinSolo => 'Sen data de fin';

  @override
  String get medicamentoADemanda => 'Cando faga falta, sen avisos';

  @override
  String limitesMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'como moito $n veces ao día',
      one: 'como moito 1 vez ao día',
    );
    return '$_temp0';
  }

  @override
  String limitesHoras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'con polo menos $n horas entre unha e outra',
      one: 'con polo menos 1 hora entre unha e outra',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoCuandoTitulo => 'Cando o tomas?';

  @override
  String get formularioMedicamentoCuandoDescripcion =>
      'Escolle se ten un horario ou se o tomas só cando o necesitas.';

  @override
  String get formularioMedicamentoConHorario => 'Cun horario';

  @override
  String get formularioMedicamentoConHorarioDescripcion =>
      'Ás súas horas. Avisarémoste de cada toma.';

  @override
  String get formularioMedicamentoADemanda => 'Só cando faga falta';

  @override
  String formularioMedicamentoADemandaDescripcion(String pantalla) {
    return 'Por exemplo, un calmante para a dor. Non hai avisos: cando o tomes, anótalo en \"$pantalla\".';
  }

  @override
  String get formularioMedicamentoLimitesTitulo =>
      'Canto se pode tomar (opcional)';

  @override
  String get formularioMedicamentoLimitesDescripcion =>
      'O que diga o prospecto ou o teu médico. Se ao anotar unha toma te pasas, a aplicación avísate.';

  @override
  String get formularioMedicamentoMaximoAlDia => 'Como moito, veces ao día';

  @override
  String get formularioMedicamentoSinLimite => 'Sen límite';

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
  String get formularioMedicamentoVezMenos => 'Unha vez menos ao día';

  @override
  String get formularioMedicamentoVezMas => 'Unha vez máis ao día';

  @override
  String get formularioMedicamentoHorasEntreTomas =>
      'Horas entre unha toma e outra, como mínimo';

  @override
  String get formularioMedicamentoSinMinimo => 'Sen mínimo';

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
    return 'Sen avisos. Cando o tomes, anótao en \"$pantalla\".';
  }

  @override
  String formularioMedicamentoAvisoADemandaHasta(
    String pantalla,
    String fecha,
  ) {
    return 'Sen avisos. Poderás anotalo en \"$pantalla\" ata o $fecha, incluído.';
  }

  @override
  String formularioMedicamentoResumenADemanda(String medicamento) {
    return '$medicamento: cando faga falta, sen avisos.';
  }

  @override
  String get tomasADemandaTitulo => 'Cando faga falta';

  @override
  String tomasADemandaExplicacion(String boton) {
    return 'Se tomas algún, preme \"$boton\" para anotalo.';
  }

  @override
  String get tomasADemandaMarcar => 'Tomeino agora';

  @override
  String tomasADemandaMarcarSemantica(String medicamento) {
    return 'Tomei $medicamento agora';
  }

  @override
  String get tomasADemandaNingunaHoy => 'Hoxe non o tomaches';

  @override
  String tomasADemandaMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Hoxe xa o tomaches as $n veces que se pode',
      one: 'Hoxe xa o tomaches a vez que se pode',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaProximaHoy(String hora) {
    return 'A próxima, a partir das $hora';
  }

  @override
  String tomasADemandaProximaManana(String hora) {
    return 'A próxima, mañá a partir das $hora';
  }

  @override
  String get tomasADemandaAvisoTitulo => 'É máis do que se pode';

  @override
  String tomasADemandaAvisoMaximo(int n, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Hoxe xa tomaches $medicamento $n veces, que é o máximo ao día.',
      one: 'Hoxe xa tomaches $medicamento 1 vez, que é o máximo ao día.',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaAvisoPronto(int horas, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      horas,
      locale: localeName,
      other:
          'Entre unha toma de $medicamento e outra teñen que pasar polo menos $horas horas.',
      one:
          'Entre unha toma de $medicamento e outra ten que pasar polo menos 1 hora.',
    );
    return '$_temp0';
  }

  @override
  String get tomasADemandaAvisoConsejo =>
      'Se tes dúbidas, pregúntalle ao teu médico ou farmacéutico. Anótalo igualmente?';

  @override
  String get tomasADemandaAvisoSi => 'Si, tomeino';

  @override
  String get tomasADemandaAvisoNo => 'Non, non o anoto';

  @override
  String tomasADemandaHoy(int veces, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      veces,
      locale: localeName,
      other: 'Hoxe tomáchelo $veces veces: ás $horas',
      one: 'Hoxe tomáchelo ás $horas',
    );
    return '$_temp0';
  }

  @override
  String historialADemanda(String hora, String medicamento) {
    return '$hora · $medicamento: tomada cando facía falta';
  }

  @override
  String get informeADemanda => 'Cando facía falta:';

  @override
  String informeADemandaDia(String dia, String tomas) {
    return '$dia: $tomas.';
  }

  @override
  String informeADemandaTomas(String medicamento, String horas) {
    return '$medicamento ás $horas';
  }

  @override
  String get tomasADemandaQuitar => 'Quitar a última';

  @override
  String tomasADemandaQuitarSemantica(String medicamento, String hora) {
    return 'Quitar a toma de $medicamento das $hora';
  }

  @override
  String get formularioMedicamentoGuardar => 'Gardar medicamento';

  @override
  String existenciasQuedan(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Quedan $cantidad pastillas',
      one: 'Queda 1 pastilla',
      zero: 'Non quedan pastillas',
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
      other: '$n pastillas e media',
      one: '1 pastilla e media',
      zero: 'media pastilla',
    );
    return '$_temp0';
  }

  @override
  String get existenciasMedia => 'media';

  @override
  String existenciasYMedia(String n) {
    return '$n e media';
  }

  @override
  String existenciasQuedanYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Quedan $n pastillas e media',
      one: 'Queda 1 pastilla e media',
      zero: 'Queda media pastilla',
    );
    return '$_temp0';
  }

  @override
  String existenciasParaDias(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other: 'para uns $dias días',
      one: 'para 1 día',
    );
    return '$_temp0';
  }

  @override
  String get existenciasHastaElFinal => 'suficientes ata o final do tratamento';

  @override
  String existenciasConDetalle(String quedan, String detalle) {
    return '$quedan, $detalle';
  }

  @override
  String get avisoExistenciasTitulo => 'Quédanche poucas pastillas';

  @override
  String get avisoRecetaTitulo => 'Renova a receita';

  @override
  String avisoRecetaCuerpo(String medicamento, String fecha) {
    return 'A receita de $medicamento acábase o $fecha. Pide cita co teu médico para renovala.';
  }

  @override
  String avisoRecetaCuerpoHoy(String medicamento) {
    return 'A receita de $medicamento acábase hoxe. Pide cita co teu médico para renovala.';
  }

  @override
  String avisoRecetaCuerpoAcabada(String medicamento, String fecha) {
    return 'A receita de $medicamento acabouse o $fecha. Pide cita co teu médico para renovala.';
  }

  @override
  String avisoExistenciasSemana(String medicamento, String boton) {
    return '$medicamento: non chegan para unha semana. Cando merques máis, preme \"$boton\" nos teus medicamentos.';
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
          '$medicamento: quedan $cantidad. Cando merques máis, preme \"$boton\" nos teus medicamentos.',
      one:
          '$medicamento: queda 1. Cando merques máis, preme \"$boton\" nos teus medicamentos.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasQuedanYMedia(int n, String medicamento, String boton) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$medicamento: quedan $n e media. Cando merques máis, preme \"$boton\" nos teus medicamentos.',
      one:
          '$medicamento: queda 1 e media. Cando merques máis, preme \"$boton\" nos teus medicamentos.',
      zero:
          '$medicamento: queda media. Cando merques máis, preme \"$boton\" nos teus medicamentos.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasAcabadas(String medicamento, String boton) {
    return '$medicamento: xa non quedan. Cando merques máis, preme \"$boton\" nos teus medicamentos.';
  }

  @override
  String medicamentoExistenciasPocas(String boton) {
    return 'Quedan poucas. Cando merques máis, preme \"$boton\".';
  }

  @override
  String get medicamentoComprarMas => 'Merquei máis';

  @override
  String medicamentoComprarMasSemantica(String medicamento) {
    return 'Merquei máis $medicamento';
  }

  @override
  String menuExistenciasPocas(String medicamentos) {
    return 'Quédanche poucas pastillas de $medicamentos.';
  }

  @override
  String menuRecetas(String medicamentos) {
    return 'Hai que renovar a receita de $medicamentos.';
  }

  @override
  String get formularioMedicamentoExistenciasTitulo =>
      'Pastillas que che quedan (opcional)';

  @override
  String get formularioMedicamentoExistenciasDescripcion =>
      'Se queres, a aplicación cóntaas e avísate antes de que se acaben.';

  @override
  String get formularioMedicamentoSinCuenta => 'Non levar a conta';

  @override
  String get formularioMedicamentoSinCuentaDescripcion =>
      'Non te avisaremos de cantas quedan.';

  @override
  String get formularioMedicamentoConCuenta => 'Levar a conta';

  @override
  String get formularioMedicamentoConCuentaDescripcion =>
      'Descontarase cada toma e avisarémoste cando queden poucas.';

  @override
  String get formularioMedicamentoExistenciasCampo => 'Pastillas que tes agora';

  @override
  String get formularioMedicamentoExistenciasCampoDescripcion =>
      'Cóntaas, ou pon as da caixa se está sen comezar. Se queda media, escribe por exemplo 14,5. Vale tamén para cápsulas ou sobres.';

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
      other: '$n pastillas e media en cada toma',
      one: '1 pastilla e media en cada toma',
      zero: 'media pastilla en cada toma',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoPorTomaMenos =>
      'Media pastilla menos en cada toma';

  @override
  String get formularioMedicamentoPorTomaMas =>
      'Media pastilla máis en cada toma';

  @override
  String formularioMedicamentoPorTomaDeLas(String hora) {
    return 'Pastillas na toma das $hora';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMenos(String hora) {
    return 'Media pastilla menos ás $hora';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMas(String hora) {
    return 'Media pastilla máis ás $hora';
  }

  @override
  String validadorMedicamentoExistencias(String maximo) {
    return 'Escribe cantas pastillas tes: un número entre 0 e $maximo. Se hai media, con coma: 14,5.';
  }

  @override
  String get comprarCampo => 'Cantas mercaches?';

  @override
  String get comprarCampoDescripcion =>
      'Mira cantas trae a caixa; por exemplo, 28.';

  @override
  String comprarTendras(String pastillas) {
    return 'Terás $pastillas.';
  }

  @override
  String get comprarAnadir => 'Engadir ás que teño';

  @override
  String comprarError(String maximo) {
    return 'Escribe cantas mercaches: un número entre 1 e $maximo.';
  }

  @override
  String get comprarHechoTitulo => 'Pastillas engadidas';

  @override
  String get recetaTitulo => 'Receita renovada';

  @override
  String get recetaPregunta => 'Ata que día é a receita nova?';

  @override
  String get recetaGuardar => 'Gardar a data nova';

  @override
  String get recetaQuitar => 'Xa non fai falta renovala';

  @override
  String get recetaQuitarDescripcion =>
      'Quita a data: non che avisaremos máis desta receita.';

  @override
  String recetaGuardada(String medicamento, String fecha) {
    return 'Receita de $medicamento: ata o $fecha.';
  }

  @override
  String recetaQuitada(String medicamento) {
    return 'Xa non che avisaremos da receita de $medicamento.';
  }

  @override
  String comprarHecho(String pastillas, String medicamento) {
    return 'Agora tes $pastillas de $medicamento.';
  }

  @override
  String get compartirDeOtroMovil => 'Medicamentos preparados noutro móbil';

  @override
  String compartirDeOtroMovilExplicacion(String boton) {
    return 'Un familiar pode apuntar as túas medicinas e as túas citas no seu teléfono, con esta mesma aplicación, e mandarche unha copia con \"$boton\". Aquí engádelas sen borrar nada do que xa tes.';
  }

  @override
  String get compartirImportar => 'Engadir medicamentos doutro móbil';

  @override
  String get compartirImportarDescripcion =>
      'Escolle a copia que che enviaron. Antes dirache que engade.';

  @override
  String get importarNoSePuede =>
      'Non se poden engadir os medicamentos deste ficheiro';

  @override
  String get importarPregunta => 'Engadir o que trae esta copia?';

  @override
  String importarCopiaDel(String fecha, String hora) {
    return 'Copia do $fecha, ás $hora.';
  }

  @override
  String importarSeAnadiran(String medicamentos) {
    return 'Engadiranse: $medicamentos.';
  }

  @override
  String importarSeActualizaran(int cuantos, String medicamentos) {
    String _temp0 = intl.Intl.pluralLogic(
      cuantos,
      locale: localeName,
      other:
          'Xa tiñas $medicamentos: poranse como na copia, sen perder as tomas anotadas.',
      one:
          'Xa tiñas $medicamentos: porase como na copia, sen perder as tomas anotadas.',
    );
    return '$_temp0';
  }

  @override
  String importarCitas(String citas) {
    return 'Citas novas: $citas.';
  }

  @override
  String get importarNoSeBorra =>
      'Non se borra nada: as túas tomas anotadas e os teus axustes quedan como están.';

  @override
  String get importarSi => 'Si, engadir';

  @override
  String get importarNadaNuevo => 'Non hai nada que engadir';

  @override
  String get importarNadaNuevoMensaje =>
      'Esta copia non trae medicamentos nin citas que non teñas.';

  @override
  String get importarHecho => 'Medicamentos engadidos';

  @override
  String get importarError =>
      'Non se puideron engadir os medicamentos. Téntao de novo.';

  @override
  String historialResumenSemana(
    String tomadas,
    String total,
    String porcentaje,
  ) {
    return 'Nos últimos 7 días marcaches $tomadas de $total tomas ($porcentaje %).';
  }

  @override
  String informeResumenSemana(String tomadas, String total, String porcentaje) {
    return 'Marcadas $tomadas de $total tomas ($porcentaje %).';
  }

  @override
  String get compartirRecordarResumen => 'Lembrarme envialo cada semana';

  @override
  String get compartirRecordarResumenDescripcion =>
      'Os domingos ás 18:00 avisarémoste para enviar a túa medicación e as túas tomas.';

  @override
  String get avisoResumenTitulo => 'Envías o teu resumo á familia?';

  @override
  String avisoResumenCuerpo(String boton) {
    return 'Toca aquí e preme \"$boton\" para mandar a túa medicación e as túas tomas da semana.';
  }

  @override
  String get widgetTitulo => 'Próxima toma';

  @override
  String get widgetVacio => 'Non hai máis tomas previstas.';

  @override
  String get ajustesWidget => 'Poñer a próxima toma na pantalla de inicio';

  @override
  String ajustesWidgetDescripcion(String boton) {
    return 'Un recadro coa próxima toma e o botón \"$boton\", sen abrir a aplicación.';
  }

  @override
  String ajustesWidgetManual(String app) {
    return 'Mantén premido un oco da pantalla de inicio do teléfono, toca \"Widgets\" e busca \"$app\".';
  }
}
