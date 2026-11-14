// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class TextosAppCa extends TextosApp {
  TextosAppCa([String locale = 'ca']) : super(locale);

  @override
  String get fechaLunes => 'dilluns';

  @override
  String get fechaMartes => 'dimarts';

  @override
  String get fechaMiercoles => 'dimecres';

  @override
  String get fechaJueves => 'dijous';

  @override
  String get fechaViernes => 'divendres';

  @override
  String get fechaSabado => 'dissabte';

  @override
  String get fechaDomingo => 'diumenge';

  @override
  String get fechaEnero => 'gener';

  @override
  String get fechaFebrero => 'febrer';

  @override
  String get fechaMarzo => 'març';

  @override
  String get fechaAbril => 'abril';

  @override
  String get fechaMayo => 'maig';

  @override
  String get fechaJunio => 'juny';

  @override
  String get fechaJulio => 'juliol';

  @override
  String get fechaAgosto => 'agost';

  @override
  String get fechaSeptiembre => 'setembre';

  @override
  String get fechaOctubre => 'octubre';

  @override
  String get fechaNoviembre => 'novembre';

  @override
  String get fechaDiciembre => 'desembre';

  @override
  String fechaLarga(String diaSemana, String dia, String mes, String anio) {
    String _temp0 = intl.Intl.selectLogic(mes, {
      'abril': 'd\'abril',
      'agost': 'd\'agost',
      'octubre': 'd\'octubre',
      'other': 'de $mes',
    });
    return '$diaSemana, $dia $_temp0 de $anio';
  }

  @override
  String fechaHoy(String fecha) {
    return 'Avui, $fecha';
  }

  @override
  String fechaManana(String fecha) {
    return 'Demà, $fecha';
  }

  @override
  String fechaAyer(String fecha) {
    return 'Ahir, $fecha';
  }

  @override
  String fechaCuandoHoy(String hora) {
    return 'avui a les $hora';
  }

  @override
  String fechaCuandoManana(String hora) {
    return 'demà a les $hora';
  }

  @override
  String fechaCuandoOtroDia(
    String diaSemana,
    String dia,
    String mes,
    String hora,
  ) {
    String _temp0 = intl.Intl.selectLogic(mes, {
      'abril': 'd\'abril',
      'agost': 'd\'agost',
      'octubre': 'd\'octubre',
      'other': 'de $mes',
    });
    return 'el $diaSemana, $dia $_temp0, a les $hora';
  }

  @override
  String get fechaDeLaMadrugada => 'de la matinada';

  @override
  String get fechaDeLaManana => 'del matí';

  @override
  String get fechaDelMediodia => 'del migdia';

  @override
  String get fechaDeLaTarde => 'de la tarda';

  @override
  String get fechaDeLaNoche => 'de la nit';

  @override
  String fechaHoraConParteDelDia(String hora, String parteDelDia) {
    return '$hora $parteDelDia';
  }

  @override
  String fechaListaUltimo(String anteriores, String ultimo) {
    return '$anteriores i $ultimo';
  }

  @override
  String get fechaSeparadorLista => ', ';

  @override
  String get appTitulo => 'Salud y Medicación';

  @override
  String get avisoDeshecho => 'Fet. S\'ha desfet l\'acció.';

  @override
  String get avisoNoSeHaPodidoDeshacer =>
      'No s\'ha pogut desfer. Torna-ho a provar.';

  @override
  String get botonDeshacer => 'Desfés';

  @override
  String get botonDeshacerPista => 'Desfà el que acabes de fer';

  @override
  String get botonDeshacerPistaEliminar => 'Recupera el que acabes d\'eliminar';

  @override
  String get barraInicio => 'Inici';

  @override
  String get barraAtras => 'Enrere';

  @override
  String get barraInicioSemantica => 'Inici. Torna al menú principal';

  @override
  String get barraAtrasSemantica => 'Enrere. Torna a la pantalla anterior';

  @override
  String get interruptorActivado => 'Activat';

  @override
  String get interruptorDesactivado => 'Desactivat';

  @override
  String selectorValor(String etiqueta, String valor) {
    return '$etiqueta: $valor';
  }

  @override
  String get cargando => 'S\'està carregant…';

  @override
  String mensajeError(String texto) {
    return 'S\'ha produït un error: $texto';
  }

  @override
  String get dialogoSiEliminar => 'Sí, elimina';

  @override
  String get dialogoNoVolver => 'No, torna enrere';

  @override
  String get dialogoAceptar => 'D\'acord';

  @override
  String get dialogoEntendido => 'Entesos';

  @override
  String get dialogoAhoraNo => 'Ara no';

  @override
  String selectorHoraElegida(String hora) {
    return 'Hora triada: $hora';
  }

  @override
  String get selectorHora => 'Hora';

  @override
  String selectorHoraValor(String hora) {
    return '$hora hores';
  }

  @override
  String get selectorRestarHora => 'Resta una hora';

  @override
  String get selectorSumarHora => 'Suma una hora';

  @override
  String get selectorMinutos => 'Minuts';

  @override
  String selectorMinutosValor(String minutos) {
    return '$minutos minuts';
  }

  @override
  String selectorRestarMinutos(String minutos) {
    return 'Resta $minutos minuts';
  }

  @override
  String selectorSumarMinutos(String minutos) {
    return 'Suma $minutos minuts';
  }

  @override
  String get selectorAtajoHoy => 'Avui';

  @override
  String get selectorAtajoManana => 'Demà';

  @override
  String get selectorAtajoEnUnaSemana => 'D\'aquí a una setmana';

  @override
  String selectorDiaElegido(String fecha) {
    return 'Dia triat: $fecha';
  }

  @override
  String get selectorDia => 'Dia';

  @override
  String get selectorDiaAnterior => 'Dia anterior';

  @override
  String get selectorDiaSiguiente => 'Dia següent';

  @override
  String get selectorMes => 'Mes';

  @override
  String get selectorMesAnterior => 'Mes anterior';

  @override
  String get selectorMesSiguiente => 'Mes següent';

  @override
  String get selectorAnio => 'Any';

  @override
  String get selectorAnioAnterior => 'Any anterior';

  @override
  String get selectorAnioSiguiente => 'Any següent';

  @override
  String selectorElegir(String texto) {
    return 'Tria: $texto';
  }

  @override
  String get menuTitulo => 'Menú principal';

  @override
  String get menuPregunta => 'Què vols fer?';

  @override
  String get menuMedicamentos => 'Registre de medicaments';

  @override
  String get menuAgenda => 'Agenda';

  @override
  String get menuEmergencias => 'Botó d\'emergències';

  @override
  String get menuAjustes => 'Configuració';

  @override
  String menuTomasDeHoy(String tomadas, String total) {
    return 'Preses d\'avui: $tomadas de $total marcades.';
  }

  @override
  String menuProximaToma(String medicamento, String cuando) {
    return 'Propera presa: $medicamento, $cuando.';
  }

  @override
  String menuProximaCita(String cita, String cuando) {
    return 'Propera cita: $cita, $cuando.';
  }

  @override
  String get tomasTitulo => 'Preses d\'avui';

  @override
  String get medicamentosMenuTomasDescripcion =>
      'Marca les medicines que ja t\'has pres avui.';

  @override
  String get medicamentosMenuNuevo => 'Registra un medicament nou';

  @override
  String get medicamentosMenuNuevoDescripcion =>
      'Apunta una medicina i t\'avisarem quan te l\'hagis de prendre.';

  @override
  String get medicamentosMenuVer => 'Mira els medicaments registrats';

  @override
  String get medicamentosMenuVerDescripcion =>
      'Consulta les teves medicines i les seves hores, canvia-les o esborra les que ja no prenguis.';

  @override
  String get historialTitulo => 'Historial de preses';

  @override
  String get medicamentosMenuHistorialDescripcion =>
      'Mira quines preses vas marcar els últims 7 dies.';

  @override
  String get medicamentosMenuCompartir =>
      'Comparteix amb el metge o la família';

  @override
  String get medicamentosMenuCompartirDescripcion =>
      'Envia o imprimeix les teves medicines, preses i cites.';

  @override
  String get listaMedicamentosTitulo => 'Medicaments registrats';

  @override
  String get listaMedicamentosPreguntaEliminar =>
      'Segur que vols eliminar aquest medicament?';

  @override
  String listaMedicamentosDetalleEliminar(String medicamento) {
    return '$medicamento\n\nTambé s\'esborraran els seus avisos.';
  }

  @override
  String get listaMedicamentosErrorEliminar =>
      'No s\'ha pogut eliminar el medicament. Torna-ho a provar.';

  @override
  String listaMedicamentosEliminado(String medicamento) {
    return 'Medicament eliminat: $medicamento';
  }

  @override
  String listaMedicamentosRecuperado(String medicamento) {
    return 'Medicament recuperat: $medicamento';
  }

  @override
  String get listaMedicamentosVacio => 'Encara no has registrat cap medicament';

  @override
  String get listaMedicamentosVacioExplicacion =>
      'Quan en registris un, apareixerà aquí amb les seves hores de presa.';

  @override
  String listaMedicamentosCuantos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Tens $cantidad medicaments registrats.',
      one: 'Tens 1 medicament registrat.',
    );
    return '$_temp0';
  }

  @override
  String get medicamentoSinFechaDeFin => 'Cada dia, sense data de fi';

  @override
  String medicamentoTerminadoEl(String fecha) {
    return 'Tractament acabat el $fecha';
  }

  @override
  String medicamentoRecetaHasta(String fecha) {
    return 'Recepta: fins al $fecha';
  }

  @override
  String medicamentoRecetaPronto(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other:
          'La recepta s\'acaba d\'aquí a $dias dies: demana cita al teu metge per renovar-la',
      one: 'La recepta s\'acaba demà: demana cita al teu metge per renovar-la',
      zero: 'La recepta s\'acaba avui: demana cita al teu metge per renovar-la',
    );
    return '$_temp0';
  }

  @override
  String medicamentoRecetaAcabada(String fecha) {
    return 'La recepta es va acabar el $fecha: demana cita al teu metge per renovar-la';
  }

  @override
  String get medicamentoRecetaRenovada => 'Ja l\'he renovada';

  @override
  String medicamentoRecetaRenovadaSemantica(String medicamento) {
    return 'Ja he renovat la recepta de $medicamento';
  }

  @override
  String medicamentoHastaEl(String fecha) {
    return 'Fins al $fecha, inclòs';
  }

  @override
  String medicamentoDosis(String dosis) {
    return 'Dosi: $dosis';
  }

  @override
  String medicamentoDosisALas(String dosis, String hora) {
    return '$dosis a les $hora';
  }

  @override
  String medicamentoHoras(String horas) {
    return 'Hores: $horas';
  }

  @override
  String get botonModificar => 'Modifica';

  @override
  String botonModificarSemantica(String nombre) {
    return 'Modifica $nombre';
  }

  @override
  String get botonEliminar => 'Elimina';

  @override
  String botonEliminarSemantica(String nombre) {
    return 'Elimina $nombre';
  }

  @override
  String get formularioMedicamentoTituloNuevo => 'Medicament nou';

  @override
  String get formularioMedicamentoTituloModificar => 'Modifica el medicament';

  @override
  String get formularioMedicamentoCrear => 'Crea el recordatori';

  @override
  String get formularioGuardarCambios => 'Desa els canvis';

  @override
  String get formularioMedicamentoGuardado => 'Medicament desat correctament';

  @override
  String get formularioCambiosGuardados => 'Canvis desats correctament';

  @override
  String formularioFotoAnadida(String boton) {
    return 'Foto afegida. Es desarà quan premis \"$boton\".';
  }

  @override
  String get formularioErrorFotoCamara =>
      'No s\'ha pogut fer la foto. Torna-ho a provar.';

  @override
  String get formularioErrorFotoGaleria =>
      'No s\'ha pogut obrir la galeria. Torna-ho a provar.';

  @override
  String formularioFotoQuitada(String boton) {
    return 'S\'ha tret la foto. El canvi es desarà quan premis \"$boton\".';
  }

  @override
  String get formularioMedicamentoErrorGuardar =>
      'No s\'ha pogut desar el medicament. Torna-ho a provar.';

  @override
  String formularioMedicamentoResumenGuardado(
    String medicamento,
    String tomas,
    String horas,
  ) {
    return '$medicamento: $tomas.\nHores de presa: $horas.';
  }

  @override
  String formularioMedicamentoUltimoDia(String fecha) {
    return 'Últim dia: $fecha.';
  }

  @override
  String get avisosDesactivadosEnAjustes =>
      'Els avisos estan desactivats. Pots activar-los a Configuració.';

  @override
  String formularioMedicamentoAvisoCadaDia(String horas) {
    return 'T\'avisarem cada dia a les $horas.';
  }

  @override
  String formularioMedicamentoAvisoHasta(String horas, String fecha) {
    return 'T\'avisarem a les $horas fins al $fecha, inclòs.';
  }

  @override
  String get formularioGuardando => 'S\'està desant…';

  @override
  String formularioRellenaYPulsa(String boton) {
    return 'Omple les dades i prem \"$boton\".';
  }

  @override
  String get formularioMedicamentoNombre => 'Nom del medicament';

  @override
  String get formularioMedicamentoNombreDescripcion =>
      'Per exemple: Paracetamol.';

  @override
  String get formularioMedicamentoDictarNombre => 'Dicta el nom';

  @override
  String get formularioMedicamentoDictarNombreIndicacion =>
      'Digues el nom del medicament';

  @override
  String get formularioMedicamentoDosis => 'Dosi (opcional)';

  @override
  String get formularioMedicamentoDosisDescripcion =>
      'Quant en prens cada vegada. Per exemple: 1 pastilla.';

  @override
  String formularioMedicamentoDosisEnCadaToma(String seccion) {
    return 'La dosi canvia segons l\'hora: la de cada presa és més avall, a \"$seccion\".';
  }

  @override
  String get formularioMedicamentoDosisTomasTitulo => 'Dosi a cada presa';

  @override
  String get formularioMedicamentoDosisTomasDescripcion =>
      'Si canvia segons l\'hora; per exemple, una pastilla al matí i mitja a la nit.';

  @override
  String get formularioMedicamentoDosisIgual => 'La mateixa a totes';

  @override
  String get formularioMedicamentoDosisIgualDescripcion =>
      'La de dalt, al camp de la dosi.';

  @override
  String get formularioMedicamentoDosisDistinta => 'Diferent segons l\'hora';

  @override
  String get formularioMedicamentoDosisDistintaDescripcion =>
      'Escriu a sota la de cada presa.';

  @override
  String formularioMedicamentoDosisDeLas(String hora) {
    return 'Dosi de les $hora';
  }

  @override
  String get formularioMedicamentoInstrucciones => 'Instruccions (opcional)';

  @override
  String get formularioMedicamentoInstruccionesDescripcion =>
      'Per exemple: amb l\'esmorzar.';

  @override
  String get formularioMedicamentoFoto => 'Foto de la capsa (opcional)';

  @override
  String get formularioMedicamentoFotoDescripcion =>
      'Així reconeixeràs el medicament d\'un cop d\'ull.';

  @override
  String get formularioMedicamentoHacerFoto => 'Fes una foto';

  @override
  String get formularioMedicamentoHacerOtraFoto => 'Fes una altra foto';

  @override
  String get formularioMedicamentoHacerFotoDescripcion =>
      'Amb la càmera del telèfon.';

  @override
  String get formularioMedicamentoElegirGaleria => 'Tria de la galeria';

  @override
  String get formularioMedicamentoElegirOtraGaleria =>
      'Tria\'n una altra de la galeria';

  @override
  String get formularioMedicamentoGaleriaDescripcion =>
      'Una foto que ja tinguis al telèfon.';

  @override
  String get formularioMedicamentoQuitarFoto => 'Treu la foto';

  @override
  String get formularioMedicamentoNumeroTomas => 'Nombre de preses al dia';

  @override
  String get formularioMedicamentoNumeroTomasDescripcion =>
      'Quantes vegades al dia el prens?';

  @override
  String get formularioMedicamentoTomasAlDia => 'Preses al dia';

  @override
  String formularioMedicamentoTomasValor(int tomas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas preses',
      one: '1 presa',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoTomaMenos => 'Una presa menys';

  @override
  String get formularioMedicamentoTomaMas => 'Una presa més';

  @override
  String get formularioMedicamentoCadaCuantasHoras => 'Cada quantes hores';

  @override
  String formularioMedicamentoCadaHorasCorto(String horas) {
    return 'Cada $horas h';
  }

  @override
  String formularioMedicamentoCadaHorasValor(String horas) {
    return 'Cada $horas hores';
  }

  @override
  String get formularioMedicamentoHoraMenos => 'Una hora menys entre preses';

  @override
  String get formularioMedicamentoHoraMas => 'Una hora més entre preses';

  @override
  String get formularioMedicamentoHoraInicio => 'Hora d\'inici';

  @override
  String get formularioMedicamentoHoraInicioDescripcion =>
      'A quina hora és la primera presa del dia?';

  @override
  String get formularioMedicamentoDuracion => 'Durada del tractament';

  @override
  String get formularioMedicamentoDuracionDescripcion =>
      'El prens sempre o només uns quants dies?';

  @override
  String get formularioMedicamentoSiempre => 'Sempre';

  @override
  String get formularioMedicamentoSiempreDescripcion =>
      'Sense data de fi. Per exemple, una medicina per a la tensió.';

  @override
  String get formularioMedicamentoHastaUnDia => 'Fins a un dia concret';

  @override
  String get formularioMedicamentoHastaUnDiaDescripcion =>
      'Per exemple, un antibiòtic durant 7 dies.';

  @override
  String get formularioMedicamentoUltimoDiaEtiqueta =>
      'Últim dia del tractament';

  @override
  String get formularioMedicamentoUltimoDiaDescripcion =>
      'Aquell dia encara s\'ha de prendre.';

  @override
  String get formularioMedicamentoRecetaTitulo => 'Recepta (opcional)';

  @override
  String get formularioMedicamentoRecetaDescripcion =>
      'Si la recepta s\'acaba un dia, t\'avisem una setmana abans perquè demanis cita al teu metge.';

  @override
  String get formularioMedicamentoSinReceta => 'Sense data';

  @override
  String get formularioMedicamentoSinRecetaDescripcion =>
      'No t\'avisem de la recepta.';

  @override
  String get formularioMedicamentoConReceta => 'S\'acaba un dia concret';

  @override
  String get formularioMedicamentoConRecetaDescripcion =>
      'T\'avisem una setmana abans i, fins que la renovis, cada dia que obris l\'aplicació.';

  @override
  String get formularioMedicamentoRecetaFecha => 'Últim dia de la recepta';

  @override
  String get formularioMedicamentoRecetaFechaDescripcion =>
      'Ho posa al full de la recepta, o t\'ho diuen a la farmàcia.';

  @override
  String get formularioResumen => 'Resum';

  @override
  String get fotoCaja => 'Foto de la capsa';

  @override
  String fotoCajaDe(String medicamento) {
    return 'Foto de la capsa: $medicamento';
  }

  @override
  String get fotoNoSePuedeMostrar => 'No es pot mostrar la foto.';

  @override
  String horarioDescripcion(int tomas, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas preses al dia, cada $horas hores',
      one: '1 presa al dia',
    );
    return '$_temp0';
  }

  @override
  String get validadorMedicamentoNombreVacio =>
      'Escriu el nom del medicament. Per exemple: Paracetamol.';

  @override
  String validadorMedicamentoNombreLargo(String maximo) {
    return 'El nom és massa llarg. Fes servir com a màxim $maximo lletres.';
  }

  @override
  String validadorMedicamentoTomas(String minimo, String maximo) {
    return 'Tria quantes vegades al dia el prens: entre $minimo i $maximo.';
  }

  @override
  String get validadorMedicamentoFrecuenciaUnaToma =>
      'Amb 1 presa al dia no cal triar la freqüència.';

  @override
  String validadorMedicamentoFrecuencia(String tomas, String horas) {
    return 'Amb $tomas preses al dia, tria una freqüència de $horas hores o menys.';
  }

  @override
  String validadorMedicamentoDosisLarga(String maximo) {
    return 'La dosi és massa llarga. Fes servir com a màxim $maximo lletres.';
  }

  @override
  String validadorMedicamentoInstruccionesLargas(String maximo) {
    return 'Les instruccions són massa llargues. Fes servir com a màxim $maximo lletres.';
  }

  @override
  String get validadorMedicamentoHoraInicio =>
      'Tria l\'hora de la primera presa.';

  @override
  String validadorMedicamentoFechaFinPasada(String opcion) {
    return 'Aquest dia ja ha passat. Tria avui o un dia futur, o marca \"$opcion\" si no té fi.';
  }

  @override
  String get errorCargarMedicamentos =>
      'No s\'han pogut carregar els teus medicaments. Tanca l\'aplicació i torna-la a obrir.';

  @override
  String get tomasMarcar => 'Ja me l\'he presa';

  @override
  String get tomasDesmarcar => 'Desmarca';

  @override
  String get tomasVacio => 'Avui no tens cap presa';

  @override
  String get tomasVacioExplicacion =>
      'Quan registris un medicament, aquí podràs marcar cada presa.';

  @override
  String get tomasEscuchar => 'Escolta les preses d\'avui';

  @override
  String get tomasEscucharDescripcion =>
      'Et llegirà quines t\'has pres i quines falten.';

  @override
  String tomasAnotada(String medicamento, String hora) {
    return 'Anotat: t\'has pres $medicamento ($hora).';
  }

  @override
  String tomasDesmarcada(String medicamento, String hora) {
    return 'Presa desmarcada: $medicamento ($hora).';
  }

  @override
  String get tomasDeshacerMarcarPista => 'Treu la marca d\'aquesta presa';

  @override
  String get tomasDeshacerDesmarcarPista => 'Torna a marcar aquesta presa';

  @override
  String get tomasErrorCarga =>
      'No s\'han pogut carregar les teves preses. Tanca l\'aplicació i torna-la a obrir.';

  @override
  String tomasHasTomado(String tomadas, String total) {
    return 'N\'has pres $tomadas de $total.';
  }

  @override
  String tomasEstadoTomada(String hora) {
    return 'Te l\'has presa a les $hora';
  }

  @override
  String tomasEstadoAplazada(String hora) {
    return 'Ajornada: t\'ho recordarem a les $hora';
  }

  @override
  String get tomasEstadoPendiente => 'Pendent';

  @override
  String tomasEstadoSinMarcar(String hora) {
    return 'Sense marcar. Era a les $hora.';
  }

  @override
  String get tomasDesmarcarDescripcion => 'Si la vas marcar per error.';

  @override
  String tomasDesmarcarSemantica(String medicamento, String hora) {
    return 'Desmarca $medicamento de les $hora';
  }

  @override
  String tomasMarcarSemantica(String medicamento, String hora) {
    return 'Ja m\'he pres $medicamento de les $hora';
  }

  @override
  String get historialVacio => 'Encara no hi ha preses per mostrar';

  @override
  String get historialVacioExplicacion =>
      'Aquí veuràs les preses dels últims 7 dies i si les vas marcar.';

  @override
  String get historialErrorCarga =>
      'No s\'ha pogut carregar l\'historial. Tanca l\'aplicació i torna-la a obrir.';

  @override
  String historialUltimosDias(String dias) {
    return 'Últims $dias dies.';
  }

  @override
  String historialMarcadas(String tomadas, String total) {
    return 'Marcades: $tomadas de $total.';
  }

  @override
  String historialTomada(String hora, String medicamento, String momento) {
    return '$hora · $medicamento: presa a les $momento';
  }

  @override
  String historialAplazada(String hora, String medicamento) {
    return '$hora · $medicamento: ajornada, sense marcar';
  }

  @override
  String historialPendiente(String hora, String medicamento) {
    return '$hora · $medicamento: pendent';
  }

  @override
  String historialSinMarcar(String hora, String medicamento) {
    return '$hora · $medicamento: sense marcar';
  }

  @override
  String get agendaCrearCita => 'Crea una cita';

  @override
  String get agendaCrearCitaDescripcion => 'Apunta una cita nova.';

  @override
  String get agendaPreguntaEliminar => 'Segur que vols eliminar aquesta cita?';

  @override
  String agendaDetalleEliminar(String cita, String fecha, String hora) {
    return '$cita\n$fecha, a les $hora';
  }

  @override
  String get agendaErrorEliminar =>
      'No s\'ha pogut eliminar la cita. Torna-ho a provar.';

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
      'No s\'han pogut carregar les teves cites. Tanca l\'aplicació i torna-la a obrir.';

  @override
  String get agendaVacio => 'Encara no tens cap cita';

  @override
  String agendaVacioExplicacion(String boton) {
    return 'Prem el botó \"$boton\" per apuntar la teva primera cita.';
  }

  @override
  String get agendaProximas => 'Properes cites';

  @override
  String get agendaSinProximas => 'No tens cites properes.';

  @override
  String get agendaPasadas => 'Cites passades';

  @override
  String get agendaCitaPasada => 'Aquesta cita ja ha passat.';

  @override
  String agendaModificarSemantica(String cita) {
    return 'Modifica la cita $cita';
  }

  @override
  String agendaEliminarSemantica(String cita) {
    return 'Elimina la cita $cita';
  }

  @override
  String get formularioCitaTituloModificar => 'Modifica la cita';

  @override
  String get formularioCitaGuardar => 'Desa la cita';

  @override
  String get formularioCitaGuardada => 'Cita desada correctament';

  @override
  String get formularioCitaErrorGuardar =>
      'No s\'ha pogut desar la cita. Torna-ho a provar.';

  @override
  String get formularioCitaMuyPronto =>
      'La cita és molt aviat: no hi ha temps d\'avisar-te abans.';

  @override
  String formularioCitaTeAvisaremos(String cuando) {
    return 'T\'avisarem $cuando.';
  }

  @override
  String formularioCitaAvisoDiaAntes(String hora) {
    return 'el dia abans a les $hora';
  }

  @override
  String formularioCitaAvisoMismoDia(String hora) {
    return 'aquell dia a les $hora';
  }

  @override
  String get formularioCitaAvisoUnaHoraAntes => 'una hora abans';

  @override
  String formularioCitaResumenGuardada(String cita, String fecha, String hora) {
    return '$cita\n$fecha, a les $hora.';
  }

  @override
  String get formularioCitaMotivo => 'Motiu de la cita';

  @override
  String get formularioCitaMotivoDescripcion =>
      'Per exemple: Metge de capçalera.';

  @override
  String get formularioCitaDictarMotivo => 'Dicta el motiu';

  @override
  String get formularioCitaDictarMotivoIndicacion =>
      'Digues el motiu de la cita';

  @override
  String get formularioCitaFecha => 'Data';

  @override
  String get formularioCitaFechaDescripcion => 'Quin dia és la cita?';

  @override
  String get formularioCitaHora => 'Hora';

  @override
  String get formularioCitaHoraDescripcion => 'A quina hora és la cita?';

  @override
  String get formularioCitaLugar => 'Lloc (opcional)';

  @override
  String get formularioCitaLugarDescripcion => 'Per exemple: Centre de salut.';

  @override
  String get formularioCitaNotas => 'Notes (opcional)';

  @override
  String get formularioCitaNotasDescripcion =>
      'Per exemple: portar les anàlisis.';

  @override
  String get validadorCitaMotivoVacio =>
      'Escriu el motiu de la cita. Per exemple: Metge de capçalera.';

  @override
  String validadorCitaMotivoLargo(String maximo) {
    return 'El motiu és massa llarg. Fes servir com a màxim $maximo lletres.';
  }

  @override
  String get validadorCitaDia => 'Tria el dia de la cita.';

  @override
  String get validadorCitaHora => 'Tria l\'hora de la cita.';

  @override
  String get validadorCitaDiaPasado =>
      'Aquest dia ja ha passat. Tria avui o un dia futur.';

  @override
  String get validadorCitaHoraPasada =>
      'Aquesta hora ja ha passat. Tria una hora més tard.';

  @override
  String validadorCitaLugarLargo(String maximo) {
    return 'El lloc és massa llarg. Fes servir com a màxim $maximo lletres.';
  }

  @override
  String validadorCitaNotasLargas(String maximo) {
    return 'Les notes són massa llargues. Fes servir com a màxim $maximo lletres.';
  }

  @override
  String get emergenciasTitulo => 'Emergències';

  @override
  String get emergenciasLlamar => 'Truca';

  @override
  String emergenciasLlamarAlNumero(String numero) {
    return 'Truca al $numero';
  }

  @override
  String emergenciasLlamarA(String nombre) {
    return 'Truca a $nombre';
  }

  @override
  String emergenciasAbriendoNumero(String numero) {
    return 'S\'està obrint el telèfon per trucar al $numero…';
  }

  @override
  String emergenciasAbriendoNombre(String nombre) {
    return 'S\'està obrint el telèfon per trucar a $nombre…';
  }

  @override
  String get emergenciasNoSeHaPodidoAbrir => 'No s\'ha pogut obrir el telèfon';

  @override
  String emergenciasMarcaAMano(String numero) {
    return 'Marca el $numero a mà des de l\'aplicació de telèfon.';
  }

  @override
  String get emergenciasIrAAjustes => 'Ves a Configuració';

  @override
  String get emergenciasIrAAjustesDescripcion =>
      'Allà pots desar el número d\'emergència.';

  @override
  String get emergenciasSinNumero =>
      'Encara no has desat cap número d\'emergència';

  @override
  String get emergenciasSinNumeroExplicacion =>
      'Per poder trucar des d\'aquí, primer escriu el número a Configuració. Per exemple, el 112.';

  @override
  String emergenciasPulsaParaLlamar(String numero) {
    return 'Prem el botó per trucar al $numero.';
  }

  @override
  String get emergenciasExplicacion =>
      'S\'obrirà el telèfon amb el número ja escrit. Per parlar, prem el botó de trucada del telèfon.';

  @override
  String get ajustesSonidosActivados => 'Sons activats';

  @override
  String get ajustesSonidosDesactivados => 'Sons desactivats';

  @override
  String get ajustesVibracionActivada => 'Vibració activada';

  @override
  String get ajustesVibracionDesactivada => 'Vibració desactivada';

  @override
  String get ajustesLecturaActivada => 'Lectura en veu alta activada';

  @override
  String get ajustesLecturaDesactivada => 'Lectura en veu alta desactivada';

  @override
  String get ajustesSinVozTitulo => 'Aquest telèfon no pot llegir en veu alta';

  @override
  String get ajustesSinVozMensaje =>
      'Li falta la veu en català. Es pot instal·lar a la configuració del telèfon, a Accessibilitat, opció \"Sortida de text a veu\".';

  @override
  String get ajustesSinVozMensajeIphone =>
      'Li falta la veu en català. Es pot descarregar a la configuració de l\'iPhone: Accessibilitat → Contingut parlat → Veus.';

  @override
  String ajustesNumeroGuardado(String numero) {
    return 'Número d\'emergència desat: $numero';
  }

  @override
  String ajustesContactoGuardado(String nombre, String numero) {
    return 'Contacte desat: $nombre, $numero';
  }

  @override
  String get ajustesContactoBorrado => 'Contacte del familiar esborrat';

  @override
  String get ajustesCambiosAlMomento => 'Els canvis es desen al moment.';

  @override
  String get ajustesActivarSonidos => 'Activa els sons';

  @override
  String get ajustesActivarSonidosDescripcion => 'Els avisos sonaran.';

  @override
  String get ajustesActivarVibracion => 'Activa la vibració';

  @override
  String get ajustesActivarVibracionDescripcion =>
      'El telèfon vibrarà amb cada avís.';

  @override
  String get ajustesActivarNotificaciones => 'Activa les notificacions';

  @override
  String get ajustesActivarNotificacionesDescripcion =>
      'Rebràs avisos de les teves medicines i de les teves cites.';

  @override
  String get ajustesProbarAviso => 'Prova l\'avís';

  @override
  String get ajustesProbarAvisoDescripcion =>
      'Envia un avís ara per comprovar com sona i com es veu.';

  @override
  String get ajustesRepetirAvisos => 'Repeteix els avisos';

  @override
  String ajustesRepetirAvisosDescripcion(String boton) {
    return 'Quan t\'avisem una altra vegada si no marques una presa, i quant espera el botó \"$boton\".';
  }

  @override
  String get ajustesAvisosDiscretos => 'Avisos discrets';

  @override
  String get ajustesAvisosDiscretosDescripcion =>
      'Els avisos no diran quina medicina toca ni el motiu de la cita, ni portaran la foto de la capsa: així no es veuran a la pantalla de bloqueig. En tocar l\'avís, l\'aplicació t\'ho dirà.';

  @override
  String get ajustesAvisosDiscretosActivados => 'Avisos discrets activats';

  @override
  String get ajustesAvisosDiscretosDesactivados =>
      'Avisos discrets desactivats';

  @override
  String get repetirSinMarcarTitulo => 'Si no marques la presa';

  @override
  String get repetirSinMarcarDescripcion =>
      'T\'avisem una vegada més, per si no vas sentir el primer avís.';

  @override
  String repetirALosMinutos(int minutos) {
    return 'Als $minutos minuts';
  }

  @override
  String get repetirALaHora => 'Al cap d\'una hora';

  @override
  String get repetirNunca => 'No repetir l\'avís';

  @override
  String repetirEjemplo(String hora, String repeticion) {
    return 'Una presa de les $hora es repeteix a les $repeticion.';
  }

  @override
  String get repetirNuncaDescripcion => 'Només sona l\'avís de la seva hora.';

  @override
  String get repetirAplazarTitulo => 'Recorda-m\'ho més tard';

  @override
  String get repetirAplazarDescripcion =>
      'Els avisos de les preses porten un botó perquè t\'ho recordem una mica després.';

  @override
  String repetirAplazarEjemplo(String hora, String despues) {
    return 'Si el prems a les $hora, t\'ho recordem a les $despues.';
  }

  @override
  String repetirGuardado(String opcion) {
    return 'Desat: $opcion';
  }

  @override
  String get ajustesLeerEnVozAlta => 'Llegeix en veu alta';

  @override
  String get ajustesLeerEnVozAltaDescripcion =>
      'Llegirà els avisos en obrir-los i podràs escoltar les preses d\'avui.';

  @override
  String get ajustesNumeroEmergencia => 'Núm. d\'emergència';

  @override
  String get ajustesNumeroEmergenciaDescripcion =>
      'El número al qual trucarà el botó d\'emergències. Per exemple: 112.';

  @override
  String get ajustesGuardarNumero => 'Desa el número';

  @override
  String get ajustesNombreFamiliar => 'Nom d\'un familiar';

  @override
  String get ajustesNombreFamiliarDescripcion =>
      'Una altra persona a qui podràs trucar des d\'Emergències. Per exemple: La meva filla Anna.';

  @override
  String get ajustesTelefonoFamiliar => 'Telèfon del familiar';

  @override
  String get ajustesGuardarContacto => 'Desa el contacte';

  @override
  String get ajustesGuardarContactoDescripcion =>
      'Per esborrar-lo, deixa els dos camps buits.';

  @override
  String get ajustesTamanoTexto => 'Ajusta la mida del text';

  @override
  String get ajustesTamanoTextoDescripcion =>
      'Fes les lletres més grans o més petites.';

  @override
  String get ajustesTema => 'Ajusta el tema';

  @override
  String get ajustesTemaDescripcion => 'Canvia els colors de l\'aplicació.';

  @override
  String get compartirTitulo => 'Compartir i còpia de seguretat';

  @override
  String get ajustesCompartirDescripcion =>
      'Envia la teva medicació al metge o a la família i desa les teves dades per no perdre-les.';

  @override
  String get permisosNotificacionesActivadas => 'Notificacions activades';

  @override
  String get permisosNotificacionesDesactivadas => 'Notificacions desactivades';

  @override
  String get permisosDenegado =>
      'El telèfon no ha donat permís per mostrar avisos, així que continuen desactivats.';

  @override
  String get permisosHoraExactaTitulo => 'Avisos a l\'hora exacta';

  @override
  String permisosHoraExactaMensaje(String boton) {
    return 'Les notificacions ja estan activades. Perquè els avisos arribin just a la seva hora, el telèfon necessita un permís més.\n\nSi prems \"$boton\", s\'obrirà una pantalla del telèfon: activa l\'opció i torna amb el botó Enrere.';
  }

  @override
  String get permisosDarPermiso => 'Dona permís';

  @override
  String get permisosHoraExactaConcedido =>
      'Fet: els avisos arribaran a l\'hora exacta.';

  @override
  String get permisosHoraExactaDenegado =>
      'Sense aquest permís, els avisos poden arribar uns minuts tard.';

  @override
  String get permisosFaltaTitulo => 'Falta el permís del telèfon';

  @override
  String permisosFaltaMensaje(String explicacion, String boton) {
    return '$explicacion\n\nPrem \"$boton\", activa les notificacions i torna amb el botó Enrere.';
  }

  @override
  String get permisosAbrirAjustes => 'Obre la configuració del telèfon';

  @override
  String get permisosPruebaEnviada =>
      'Avís de prova enviat. Mira la part de dalt de la pantalla.';

  @override
  String get permisosPruebaDesactivadasTitulo =>
      'Les notificacions estan desactivades';

  @override
  String permisosPruebaDesactivadasMensaje(String interruptor, String boton) {
    return 'Primer activa \"$interruptor\" i després torna a prémer \"$boton\".';
  }

  @override
  String get permisosPruebaSinPermiso =>
      'El telèfon no deixa mostrar els avisos d\'aquesta aplicació.';

  @override
  String get temaPredeterminado => 'Tema predeterminat';

  @override
  String get temaPredeterminadoDescripcion =>
      'Fons blau clar i lletres negres.';

  @override
  String get temaOscuro => 'Tema fosc';

  @override
  String get temaOscuroDescripcion =>
      'Fons fosc i lletres blanques. Cansa menys la vista amb poca llum.';

  @override
  String get temaAlternativo => 'Tema alternatiu';

  @override
  String get temaAlternativoDescripcion =>
      'Fons groc suau i lletres negres. Redueix els reflexos.';

  @override
  String get temaTitulo => 'Tema';

  @override
  String get temaAplicar => 'Aplica aquest tema';

  @override
  String temaAplicado(String tema) {
    return 'Tema aplicat: $tema';
  }

  @override
  String get temaToca => 'Toca un tema per veure\'l a la mostra.';

  @override
  String temaMuestra(String tema) {
    return 'Mostra: $tema';
  }

  @override
  String get temaYaLoUsas => 'Aquest és el tema que ja fas servir.';

  @override
  String temaAhoraUsas(String tema) {
    return 'Ara fas servir: $tema.';
  }

  @override
  String get temaElegido => 'Triat';

  @override
  String get temaEnUso => 'En ús';

  @override
  String get temaSeparadorEstado => ' · ';

  @override
  String get temaMuestraTexto =>
      'Així es veuran les pantalles amb aquest tema.';

  @override
  String get temaMuestraBoton => 'Botó d\'exemple';

  @override
  String get temaMuestraInterruptor => 'Interruptor d\'exemple';

  @override
  String get temaMuestraInterruptorDescripcion => 'Verd vol dir activat.';

  @override
  String get tamanoTitulo => 'Mida del text';

  @override
  String get tamanoAumentar => 'Augmenta (+)';

  @override
  String get tamanoReducir => 'Redueix (−)';

  @override
  String get tamanoMuestraTexto =>
      'Així es veuran els textos de l\'aplicació. Per exemple: Paracetamol, 3 preses al dia, cada 8 hores.';

  @override
  String tamanoActual(String tamano) {
    return 'Mida actual: $tamano';
  }

  @override
  String tamanoActualNormal(String tamano) {
    return 'Mida actual: $tamano (normal)';
  }

  @override
  String tamanoActualMinimo(String tamano) {
    return 'Mida actual: $tamano (mínima)';
  }

  @override
  String tamanoActualMaximo(String tamano) {
    return 'Mida actual: $tamano (màxima)';
  }

  @override
  String tamanoPuedesElegir(String minimo, String maximo) {
    return 'Pots triar entre $minimo i $maximo. El canvi s\'aplica a tota l\'aplicació.';
  }

  @override
  String get tamanoMasGrandes => 'Lletres més grans.';

  @override
  String get tamanoYaMaximo => 'Ja és a la mida màxima.';

  @override
  String get tamanoMasPequenas => 'Lletres més petites.';

  @override
  String get tamanoYaMinimo => 'Ja és a la mida mínima.';

  @override
  String get tamanoMuestra => 'Mostra';

  @override
  String get ajustesFraseDePruebaVoz =>
      'Així sonarà la veu. Llegiré els teus avisos i les teves preses d\'avui.';

  @override
  String get validadorFamiliarNombreVacio =>
      'Escriu com es diu. Per exemple: La meva filla Anna.';

  @override
  String validadorFamiliarNombreLargo(String maximo) {
    return 'El nom és massa llarg: com a màxim $maximo lletres.';
  }

  @override
  String get validadorFamiliarNumeroVacio => 'Escriu el seu número de telèfon.';

  @override
  String get validadorTelefonoVacio =>
      'Escriu un número de telèfon. Per exemple: 112.';

  @override
  String get validadorTelefonoSoloNumeros =>
      'Escriu només números. Per exemple: 112 o 600123456.';

  @override
  String validadorTelefonoCorto(String minimo) {
    return 'El número és massa curt. Ha de tenir almenys $minimo xifres.';
  }

  @override
  String get validadorTelefonoLargo =>
      'El número és massa llarg. Revisa que estigui ben escrit.';

  @override
  String get asistenteTitulo => 'Primers passos';

  @override
  String get asistenteEmpezar => 'Comença';

  @override
  String get asistenteSaltar => 'Salta aquests passos';

  @override
  String get asistenteSaltarDescripcion => 'Ves directament al menú principal.';

  @override
  String get asistenteSiguiente => 'Següent';

  @override
  String get asistenteTerminar => 'Comença a fer servir l\'aplicació';

  @override
  String get asistenteHola => 'Hola';

  @override
  String get asistenteBienvenida =>
      'Prepararem l\'aplicació en 3 passos: la mida de la lletra, els avisos i el número d\'emergència.';

  @override
  String get asistenteCambiarEnAjustes =>
      'Tot es pot canviar més endavant a Configuració.';

  @override
  String asistentePaso(String numero, String total, String titulo) {
    return 'Pas $numero de $total: $titulo';
  }

  @override
  String get asistenteTamanoTitulo => 'Mida de la lletra';

  @override
  String get asistenteTamanoExplicacion =>
      'Llegeixes bé aquest text? Si et costa, fes les lletres més grans.';

  @override
  String get asistenteAvisosTitulo => 'Avisos de medicines i cites';

  @override
  String get asistenteAvisosExplicacion =>
      'T\'avisarem a l\'hora de cada medicina i abans de cada cita, amb so i vibració.';

  @override
  String get asistenteActivarAvisos => 'Activa els avisos';

  @override
  String get asistenteActivarAvisosDescripcion =>
      'El telèfon et demanarà permís: prem \"Permet\".';

  @override
  String asistenteSiPrefieresNo(String boton) {
    return 'Si prefereixes no activar-los ara, prem \"$boton\".';
  }

  @override
  String get asistenteConSonido => 'amb so';

  @override
  String get asistenteSinSonido => 'sense so';

  @override
  String get asistenteConVibracion => 'amb vibració';

  @override
  String get asistenteSinVibracion => 'sense vibració';

  @override
  String asistenteAvisosActivados(String sonido, String vibracion) {
    return 'Els avisos estan activats, $sonido i $vibracion.';
  }

  @override
  String get asistenteProbarAvisoDescripcion =>
      'Envia un avís ara per veure com sona i com es veu.';

  @override
  String get asistenteEmergenciaTitulo => 'Número d\'emergència';

  @override
  String get asistenteEmergenciaExplicacion =>
      'El botó d\'emergències trucarà a aquest número. Pot ser el 112 o el d\'un familiar.';

  @override
  String get asistenteEmergenciaDescripcion =>
      'Si no el vols posar ara, deixa\'l buit.';

  @override
  String get asistenteTodoListo => 'Tot a punt';

  @override
  String asistenteResumenTamano(String tamano) {
    return 'Mida de la lletra: $tamano.';
  }

  @override
  String get asistenteResumenAvisosActivados => 'Avisos activats.';

  @override
  String get asistenteResumenAvisosDesactivados =>
      'Avisos desactivats. Pots activar-los a Configuració.';

  @override
  String asistenteResumenNumero(String numero) {
    return 'Número d\'emergència: $numero.';
  }

  @override
  String get asistenteResumenSinNumero =>
      'Sense número d\'emergència. Pots posar-lo a Configuració.';

  @override
  String get asistenteTambienEnAjustes =>
      'A Configuració també pots triar els colors i activar la lectura en veu alta.';

  @override
  String get compartirEnviarInforme => 'Envia la medicació i les cites';

  @override
  String get compartirEnviarInformeDescripcion =>
      'Per WhatsApp, correu… A la pantalla següent tries a qui.';

  @override
  String get compartirImprimir => 'Imprimeix';

  @override
  String get compartirImprimirDescripcion =>
      'En una impressora connectada al telèfon, o desa-ho com a PDF.';

  @override
  String get compartirGuardarCopia => 'Desa una còpia';

  @override
  String get compartirGuardarCopiaDescripcion =>
      'A Google Drive o a la carpeta de baixades.';

  @override
  String get compartirEnviarCopia => 'Envia una còpia';

  @override
  String get compartirEnviarCopiaDescripcion =>
      'Per correu o WhatsApp: al teu propi correu o a un familiar.';

  @override
  String get compartirRecuperar => 'Recupera una còpia';

  @override
  String get compartirRecuperarDescripcion =>
      'Canvia les dades d\'aquest telèfon per les d\'una còpia. Abans t\'ho preguntarà.';

  @override
  String get compartirSiRecuperar => 'Sí, recupera la còpia';

  @override
  String get compartirErrorDocumento =>
      'No s\'ha pogut preparar el document. Torna-ho a provar.';

  @override
  String get compartirErrorImprimir =>
      'No s\'ha pogut obrir la impressió. Torna-ho a provar.';

  @override
  String get compartirCopiaGuardada => 'Còpia de seguretat desada.';

  @override
  String get compartirErrorGuardarCopia =>
      'No s\'ha pogut desar la còpia. Torna-ho a provar.';

  @override
  String get compartirErrorEnviarCopia =>
      'No s\'ha pogut preparar la còpia. Torna-ho a provar.';

  @override
  String get compartirNoSePuedeRecuperar => 'No es pot recuperar aquest fitxer';

  @override
  String get compartirSustitucionVacio =>
      'Es posarà en aquest telèfon el que hi ha a la còpia.';

  @override
  String compartirSustitucion(String actual) {
    return 'S\'esborrarà el que hi ha ara en aquest telèfon ($actual) i es posarà el de la còpia.';
  }

  @override
  String get compartirPreguntaRecuperar => 'Vols recuperar aquesta còpia?';

  @override
  String compartirCopiaDel(String fecha, String hora, String resumen) {
    return 'Còpia del $fecha, a les $hora: $resumen.';
  }

  @override
  String compartirCopiaEmergencia(String numero) {
    return 'Número d\'emergència: $numero.';
  }

  @override
  String get compartirCopiaSinEmergencia => 'Sense número d\'emergència.';

  @override
  String compartirCopiaFamiliar(String familiar) {
    return 'Familiar: $familiar.';
  }

  @override
  String get compartirCopiaSinFamiliar => 'Sense familiar.';

  @override
  String get compartirCopiaRecuperada => 'Còpia recuperada';

  @override
  String compartirYaTienes(String resumen) {
    return 'Ja tens en aquest telèfon $resumen.';
  }

  @override
  String get compartirAvisosDesactivados =>
      'Els avisos estan desactivats en aquest telèfon: activa\'ls a Configuració per rebre\'ls.';

  @override
  String get compartirErrorRecuperar =>
      'No s\'ha pogut recuperar la còpia. Torna-ho a provar.';

  @override
  String get compartirParaElMedico => 'Per al metge o la família';

  @override
  String get compartirParaElMedicoExplicacion =>
      'Un document amb les teves medicines, les preses de l\'última setmana i les properes cites.';

  @override
  String get compartirCopiaDeSeguridad => 'Còpia de seguretat';

  @override
  String compartirCopiaExplicacion(String boton) {
    return 'Desa en un fitxer totes les teves dades: medicines amb les seves fotos, preses, cites i configuració. En un mòbil nou, instal·la l\'aplicació i prem \"$boton\".';
  }

  @override
  String get compartirUnMomento => 'Un moment, si us plau…';

  @override
  String copiaNoEsCopia(String app) {
    return 'Aquest fitxer no és una còpia de $app, o està malmès.';
  }

  @override
  String copiaDemasiadoGrande(String app) {
    return 'Aquest fitxer és massa gran per ser una còpia de $app.';
  }

  @override
  String get copiaVersionNueva =>
      'Aquesta còpia és d\'una versió més nova de l\'aplicació. Actualitza l\'aplicació i torna-ho a provar.';

  @override
  String copiaNombreFichero(String app, String fecha) {
    return 'Còpia de $app $fecha';
  }

  @override
  String copiaMedicamentos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad medicaments',
      one: '1 medicament',
    );
    return '$_temp0';
  }

  @override
  String copiaCitas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad cites',
      one: '1 cita',
    );
    return '$_temp0';
  }

  @override
  String copiaTomas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad preses anotades',
      one: '1 presa anotada',
    );
    return '$_temp0';
  }

  @override
  String copiaAsunto(String app) {
    return 'Còpia de seguretat de $app';
  }

  @override
  String get informeTitulo => 'La meva medicació i les meves cites';

  @override
  String informeNombreFichero(String fecha) {
    return 'Medicació i cites $fecha';
  }

  @override
  String informePagina(String pagina, String total) {
    return 'Pàgina $pagina de $total';
  }

  @override
  String informeActualizado(String fecha, String hora) {
    return 'Actualitzat el $fecha, a les $hora.';
  }

  @override
  String informeTelefonosEmergencia(String telefonos) {
    return 'Telèfons d\'emergència: $telefonos.';
  }

  @override
  String informeContactoFamiliar(String nombre, String numero) {
    return '$nombre: $numero';
  }

  @override
  String get informeSeparadorTelefonos => ' · ';

  @override
  String get informeMedicamentos => 'Medicaments';

  @override
  String get informeSinMedicamentos => 'No hi ha medicaments registrats.';

  @override
  String informeTomasYHoras(String tomas, String horas) {
    return '$tomas: $horas';
  }

  @override
  String informeInstrucciones(String instrucciones) {
    return 'Instruccions: $instrucciones';
  }

  @override
  String informeTomasUltimosDias(String dias) {
    return 'Preses dels últims $dias dies';
  }

  @override
  String get informeColumnaDia => 'Dia';

  @override
  String get informeColumnaTomadas => 'Marcades';

  @override
  String get informeColumnaSinMarcar => 'Sense marcar';

  @override
  String get informeHoy => 'Avui';

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
    return '$tomadas de $total ($pendientes per arribar)';
  }

  @override
  String informeTomaSinMarcar(String hora, String medicamento) {
    return '$hora $medicamento';
  }

  @override
  String informeYMas(String lista, String mas) {
    return '$lista i $mas més';
  }

  @override
  String get informeSinTomas => 'No hi ha preses en aquests dies.';

  @override
  String get informeProximasCitas => 'Properes cites';

  @override
  String get informeSinCitas => 'No hi ha cites properes.';

  @override
  String informeCitaCuando(String fecha, String hora) {
    return '$fecha, a les $hora';
  }

  @override
  String informeLugar(String lugar) {
    return 'Lloc: $lugar';
  }

  @override
  String informeNotas(String notas) {
    return 'Notes: $notas';
  }

  @override
  String get canalConSonidoYVibracion => 'Avisos amb so i vibració';

  @override
  String get canalConSonido => 'Avisos amb so';

  @override
  String get canalConVibracion => 'Avisos amb vibració';

  @override
  String get canalSilencioso => 'Avisos en silenci';

  @override
  String get canalDescripcion => 'Avisos de preses de medicaments i de cites.';

  @override
  String get avisoNotaRenovar =>
      'Obre l\'aplicació per continuar rebent aquests avisos.';

  @override
  String get avisoTomaTitulo => 'Hora de la teva medicina';

  @override
  String get avisoAplazadoTitulo => 'Recorda\'t de la medicina';

  @override
  String get avisoRepeticionTitulo => 'T\'has pres la medicina?';

  @override
  String avisoTomaCuerpo(String medicamento, String hora) {
    return 'Pren $medicamento ($hora).';
  }

  @override
  String avisoTomaCuerpoConDosis(
    String medicamento,
    String dosis,
    String hora,
  ) {
    return 'Pren $medicamento: $dosis ($hora).';
  }

  @override
  String avisoRepeticionCuerpo(String hora, String medicamento, String boton) {
    return 'Era a les $hora: $medicamento. Si ja te l\'has presa, prem \"$boton\".';
  }

  @override
  String avisoRepeticionCuerpoConDosis(
    String hora,
    String medicamento,
    String dosis,
    String boton,
  ) {
    return 'Era a les $hora: $medicamento: $dosis. Si ja te l\'has presa, prem \"$boton\".';
  }

  @override
  String avisoTomaCuerpoDiscreto(String hora) {
    return 'La de les $hora. Toca aquí per veure quina és.';
  }

  @override
  String avisoRepeticionCuerpoDiscreto(String hora) {
    return 'Era a les $hora. Toca aquí per veure quina és.';
  }

  @override
  String get avisoExistenciasCuerpoDiscreto =>
      'D\'una de les teves medicines. Toca aquí per veure quina és.';

  @override
  String get avisoRecetaCuerpoDiscreto =>
      'La d\'una de les teves medicines. Toca aquí per veure quina és.';

  @override
  String avisoCitaCuerpoDiscreto(String hora) {
    return 'A les $hora. Toca aquí per veure quina és.';
  }

  @override
  String get avisoCitaHoy => 'Avui tens una cita';

  @override
  String get avisoCitaManana => 'Demà tens una cita';

  @override
  String get avisoCitaUnaHora => 'La teva cita és d\'aquí a 1 hora';

  @override
  String avisoCitaCuerpo(String cita, String hora) {
    return '$cita a les $hora.';
  }

  @override
  String avisoCitaCuerpoConLugar(String cita, String hora, String lugar) {
    return '$cita a les $hora a $lugar.';
  }

  @override
  String avisoAplazar(int minutos) {
    return 'Recorda-m\'ho en $minutos min';
  }

  @override
  String get avisoPruebaTitulo => 'Avís de prova';

  @override
  String get avisoPruebaCuerpo =>
      'Així t\'avisarem de les teves medicines i de les teves cites.';

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
    return 'Medicina de les $hora: $detalle Quan te la prenguis, prem: $boton.';
  }

  @override
  String vozCita(String cita, String cuando) {
    return 'Tens una cita: $cita, $cuando.';
  }

  @override
  String vozCitaConLugar(String cita, String cuando, String lugar) {
    return 'Tens una cita: $cita, $cuando, a $lugar.';
  }

  @override
  String get vozSinTomas => 'Avui no tens cap presa.';

  @override
  String vozTotalTomas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad preses',
      one: 'una presa',
    );
    return '$_temp0';
  }

  @override
  String vozTodasTomadas(String total) {
    return 'Avui tens $total i ja no te\'n falta cap.';
  }

  @override
  String vozHasTomado(String total, String tomadas) {
    return 'Avui tens $total. Te n\'has pres $tomadas.';
  }

  @override
  String vozTeFaltan(int cantidad, String lista) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Et falten: $lista',
      one: 'Et falta: $lista',
    );
    return '$_temp0';
  }

  @override
  String vozNombreConDosis(String medicamento, String dosis) {
    return '$medicamento, $dosis';
  }

  @override
  String vozFaltanteSinMarcar(String medicamento, String hora) {
    return '$medicamento, de les $hora, sense marcar.';
  }

  @override
  String vozFaltanteAplazada(String medicamento, String hora) {
    return '$medicamento, de les $hora, ajornada.';
  }

  @override
  String vozFaltantePendiente(String medicamento, String hora) {
    return '$medicamento, a les $hora.';
  }

  @override
  String vozHasDictado(String texto) {
    return 'Has dictat: $texto. Si no és correcte, torna-ho a dictar o corregeix-ho amb el teclat.';
  }

  @override
  String get vozNoPuedeDictar =>
      'Aquest telèfon no permet dictar. Escriu-ho amb el teclat.';

  @override
  String get vozDictarDescripcion => 'Digues-ho en veu alta i s\'escriurà sol.';

  @override
  String respuestaAplazada(String hora) {
    return 'T\'ho recordarem a les $hora.';
  }

  @override
  String get respuestaSinMedicamento =>
      'Aquest medicament ja no està registrat.';

  @override
  String get estadoAvisosListos =>
      'Els avisos estan a punt per arribar a la seva hora.';

  @override
  String get estadoAvisosSinPermiso =>
      'El telèfon no deixa que aquesta aplicació mostri avisos, així que no arribaran.';

  @override
  String get estadoAvisosSinHoraExacta =>
      'Falta el permís d\'hora exacta: els avisos poden arribar uns minuts tard.';

  @override
  String get estadoAvisosAhorroBateria =>
      'L\'estalvi de bateria del telèfon pot endarrerir els avisos o impedir que arribin.';

  @override
  String get estadoAvisosBotonPermiso => 'Dona permís per als avisos';

  @override
  String get estadoAvisosBotonHoraExacta => 'Dona permís d\'hora exacta';

  @override
  String get estadoAvisosBotonBateria => 'Treu l\'estalvi de bateria';

  @override
  String get estadoAvisosPermisoConcedido =>
      'Fet: els avisos ja poden arribar.';

  @override
  String get bateriaTitulo => 'Estalvi de bateria';

  @override
  String bateriaMensaje(String boton) {
    return 'Alguns telèfons tanquen les aplicacions per estalviar bateria, i llavors els avisos arriben tard o no arriben.\n\nSi prems \"$boton\", s\'obrirà la pantalla d\'aquesta aplicació a la configuració del telèfon. Toca \"Bateria\" (o \"Ús de la bateria\"), tria \"Sense restriccions\" i torna amb el botó Enrere.';
  }

  @override
  String get bateriaAbrir => 'Obre la configuració';

  @override
  String get menuAvisosSinPermiso =>
      'Els avisos no poden arribar: el telèfon no dona permís a aquesta aplicació.';

  @override
  String get formularioRecuperado => 'Hem recuperat el que estaves escrivint.';

  @override
  String formularioRecuperadoConFoto(String boton) {
    return 'Hem recuperat el que estaves escrivint i la foto. Es desarà quan premis \"$boton\".';
  }

  @override
  String fechaCorta(String diaSemana, String dia, String mes) {
    String _temp0 = intl.Intl.selectLogic(mes, {
      'abril': 'd\'abril',
      'agost': 'd\'agost',
      'octubre': 'd\'octubre',
      'other': 'de $mes',
    });
    return '$diaSemana, $dia $_temp0';
  }

  @override
  String horarioDescripcionLibre(int tomas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas preses al dia',
      one: '1 presa al dia',
    );
    return '$_temp0';
  }

  @override
  String get semanaLunes => 'dilluns';

  @override
  String get semanaMartes => 'dimarts';

  @override
  String get semanaMiercoles => 'dimecres';

  @override
  String get semanaJueves => 'dijous';

  @override
  String get semanaViernes => 'divendres';

  @override
  String get semanaSabado => 'dissabtes';

  @override
  String get semanaDomingo => 'diumenges';

  @override
  String diasSemanaFrase(String dias) {
    return 'els $dias';
  }

  @override
  String diasCadaFrase(String cada, String fecha) {
    return 'cada $cada dies, a partir del $fecha';
  }

  @override
  String get validadorMedicamentoHorasRepetidas =>
      'Hi ha dues preses a la mateixa hora. Canvia\'n una.';

  @override
  String get validadorMedicamentoSinDias =>
      'Tria almenys un dia de la setmana.';

  @override
  String validadorMedicamentoCadaDias(String minimo, String maximo) {
    return 'Tria cada quants dies el prens: entre $minimo i $maximo.';
  }

  @override
  String get formularioMedicamentoHorasTitulo => 'A quines hores el prens?';

  @override
  String get formularioMedicamentoHorasDescripcion =>
      'Tria com es reparteixen les preses al llarg del dia.';

  @override
  String get formularioMedicamentoRepartidas => 'Repartides per igual';

  @override
  String get formularioMedicamentoRepartidasDescripcion =>
      'Cada cert nombre d\'hores, des de la primera presa.';

  @override
  String get formularioMedicamentoConcretas => 'A hores concretes';

  @override
  String get formularioMedicamentoConcretasDescripcion =>
      'Per exemple, amb l\'esmorzar, el dinar i el sopar.';

  @override
  String formularioMedicamentoHoraToma(String numero) {
    return 'Presa $numero';
  }

  @override
  String get formularioMedicamentoHoraUnaToma => 'Hora de la presa';

  @override
  String get formularioMedicamentoHoraUnaTomaDescripcion =>
      'A quina hora el prens?';

  @override
  String get formularioMedicamentoDiasTitulo => 'Quins dies el prens?';

  @override
  String get formularioMedicamentoDiasDescripcion =>
      'Tria si el prens cada dia o només alguns dies.';

  @override
  String get formularioMedicamentoTodosLosDias => 'Tots els dies';

  @override
  String get formularioMedicamentoTodosLosDiasDescripcion =>
      'Cada dia, sense saltar-se\'n cap.';

  @override
  String get formularioMedicamentoAlgunosDias => 'Alguns dies de la setmana';

  @override
  String get formularioMedicamentoAlgunosDiasDescripcion =>
      'Per exemple, una pastilla que es pren els dilluns.';

  @override
  String get formularioMedicamentoCadaVariosDias => 'Cada uns quants dies';

  @override
  String get formularioMedicamentoCadaVariosDiasDescripcion =>
      'Per exemple, un dia sí i un dia no.';

  @override
  String get formularioMedicamentoCadaCuantosDias => 'Cada quants dies';

  @override
  String formularioMedicamentoCadaDiasValor(String dias) {
    return 'Cada $dias dies';
  }

  @override
  String get formularioMedicamentoDiaMenos => 'Un dia menys entre preses';

  @override
  String get formularioMedicamentoDiaMas => 'Un dia més entre preses';

  @override
  String get formularioMedicamentoPrimerDia => 'Primer dia';

  @override
  String get formularioMedicamentoPrimerDiaDescripcion =>
      'El primer dia que el prens.';

  @override
  String formularioMedicamentoAvisoDias(String dias, String horas) {
    return 'T\'avisarem a les $horas $dias.';
  }

  @override
  String formularioMedicamentoAvisoDiasHasta(
    String dias,
    String horas,
    String fecha,
  ) {
    return 'T\'avisarem a les $horas $dias, fins al $fecha, inclòs.';
  }

  @override
  String get medicamentoSinFechaDeFinSolo => 'Sense data de fi';

  @override
  String get medicamentoADemanda => 'Quan calgui, sense avisos';

  @override
  String limitesMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'com a màxim $n vegades al dia',
      one: 'com a màxim 1 vegada al dia',
    );
    return '$_temp0';
  }

  @override
  String limitesHoras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'amb almenys $n hores entre una i una altra',
      one: 'amb almenys 1 hora entre una i una altra',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoCuandoTitulo => 'Quan el prens?';

  @override
  String get formularioMedicamentoCuandoDescripcion =>
      'Tria si té un horari o si el prens només quan el necessites.';

  @override
  String get formularioMedicamentoConHorario => 'Amb un horari';

  @override
  String get formularioMedicamentoConHorarioDescripcion =>
      'A les seves hores. T\'avisarem de cada presa.';

  @override
  String get formularioMedicamentoADemanda => 'Només quan calgui';

  @override
  String formularioMedicamentoADemandaDescripcion(String pantalla) {
    return 'Per exemple, un calmant per al dolor. No hi ha avisos: quan el prenguis, ho anotes a \"$pantalla\".';
  }

  @override
  String get formularioMedicamentoLimitesTitulo =>
      'Quant se\'n pot prendre (opcional)';

  @override
  String get formularioMedicamentoLimitesDescripcion =>
      'El que digui el prospecte o el teu metge. Si en anotar una presa te\'n passes, l\'aplicació t\'avisa.';

  @override
  String get formularioMedicamentoMaximoAlDia => 'Com a màxim, vegades al dia';

  @override
  String get formularioMedicamentoSinLimite => 'Sense límit';

  @override
  String formularioMedicamentoVeces(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n vegades',
      one: '1 vegada',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoVezMenos => 'Una vegada menys al dia';

  @override
  String get formularioMedicamentoVezMas => 'Una vegada més al dia';

  @override
  String get formularioMedicamentoHorasEntreTomas =>
      'Hores entre una presa i una altra, com a mínim';

  @override
  String get formularioMedicamentoSinMinimo => 'Sense mínim';

  @override
  String formularioMedicamentoHorasValor(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hores',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String formularioMedicamentoAvisoADemanda(String pantalla) {
    return 'Sense avisos. Quan el prenguis, anota-ho a \"$pantalla\".';
  }

  @override
  String formularioMedicamentoAvisoADemandaHasta(
    String pantalla,
    String fecha,
  ) {
    return 'Sense avisos. Podràs anotar-ho a \"$pantalla\" fins al $fecha, inclòs.';
  }

  @override
  String formularioMedicamentoResumenADemanda(String medicamento) {
    return '$medicamento: quan calgui, sense avisos.';
  }

  @override
  String get tomasADemandaTitulo => 'Quan calgui';

  @override
  String tomasADemandaExplicacion(String boton) {
    return 'Si en prens algun, prem \"$boton\" per anotar-ho.';
  }

  @override
  String get tomasADemandaMarcar => 'Me l\'he pres ara';

  @override
  String tomasADemandaMarcarSemantica(String medicamento) {
    return 'M\'he pres $medicamento ara';
  }

  @override
  String get tomasADemandaNingunaHoy => 'Avui no te l\'has pres';

  @override
  String tomasADemandaMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Avui ja te l\'has pres les $n vegades que es pot',
      one: 'Avui ja te l\'has pres l\'única vegada que es pot',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaProximaHoy(String hora) {
    return 'La propera, a partir de les $hora';
  }

  @override
  String tomasADemandaProximaManana(String hora) {
    return 'La propera, demà a partir de les $hora';
  }

  @override
  String get tomasADemandaAvisoTitulo => 'És més del que es pot';

  @override
  String tomasADemandaAvisoMaximo(int n, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          'Avui ja t\'has pres $medicamento $n vegades, que és el màxim al dia.',
      one: 'Avui ja t\'has pres $medicamento 1 vegada, que és el màxim al dia.',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaAvisoPronto(int horas, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      horas,
      locale: localeName,
      other:
          'Entre una presa de $medicamento i una altra han de passar almenys $horas hores.',
      one:
          'Entre una presa de $medicamento i una altra ha de passar almenys 1 hora.',
    );
    return '$_temp0';
  }

  @override
  String get tomasADemandaAvisoConsejo =>
      'Si tens dubtes, pregunta-ho al teu metge o farmacèutic. L\'anotes igualment?';

  @override
  String get tomasADemandaAvisoSi => 'Sí, me l\'he pres';

  @override
  String get tomasADemandaAvisoNo => 'No, no l\'anoto';

  @override
  String tomasADemandaHoy(int veces, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      veces,
      locale: localeName,
      other: 'Avui te l\'has pres $veces vegades: a les $horas',
      one: 'Avui te l\'has pres a les $horas',
    );
    return '$_temp0';
  }

  @override
  String historialADemanda(String hora, String medicamento) {
    return '$hora · $medicamento: presa quan calia';
  }

  @override
  String get informeADemanda => 'Quan calia:';

  @override
  String informeADemandaDia(String dia, String tomas) {
    return '$dia: $tomas.';
  }

  @override
  String informeADemandaTomas(String medicamento, String horas) {
    return '$medicamento a les $horas';
  }

  @override
  String get tomasADemandaQuitar => 'Treu l\'última';

  @override
  String tomasADemandaQuitarSemantica(String medicamento, String hora) {
    return 'Treu la presa de les $hora: $medicamento';
  }

  @override
  String get formularioMedicamentoGuardar => 'Desa el medicament';

  @override
  String existenciasQuedan(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Queden $cantidad pastilles',
      one: 'Queda 1 pastilla',
      zero: 'No queda cap pastilla',
    );
    return '$_temp0';
  }

  @override
  String existenciasPastillas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastilles',
      one: '1 pastilla',
    );
    return '$_temp0';
  }

  @override
  String existenciasPastillasYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastilles i mitja',
      one: '1 pastilla i mitja',
      zero: 'mitja pastilla',
    );
    return '$_temp0';
  }

  @override
  String get existenciasMedia => 'mitja';

  @override
  String existenciasYMedia(String n) {
    return '$n i mitja';
  }

  @override
  String existenciasQuedanYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Queden $n pastilles i mitja',
      one: 'Queda 1 pastilla i mitja',
      zero: 'Queda mitja pastilla',
    );
    return '$_temp0';
  }

  @override
  String existenciasParaDias(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other: 'per a uns $dias dies',
      one: 'per a 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get existenciasHastaElFinal =>
      'suficients fins al final del tractament';

  @override
  String existenciasConDetalle(String quedan, String detalle) {
    return '$quedan, $detalle';
  }

  @override
  String get avisoExistenciasTitulo => 'Et queden poques pastilles';

  @override
  String get avisoRecetaTitulo => 'Renova la recepta';

  @override
  String avisoRecetaCuerpo(String medicamento, String fecha) {
    return 'La recepta de $medicamento s\'acaba el $fecha. Demana cita al teu metge per renovar-la.';
  }

  @override
  String avisoRecetaCuerpoHoy(String medicamento) {
    return 'La recepta de $medicamento s\'acaba avui. Demana cita al teu metge per renovar-la.';
  }

  @override
  String avisoRecetaCuerpoAcabada(String medicamento, String fecha) {
    return 'La recepta de $medicamento es va acabar el $fecha. Demana cita al teu metge per renovar-la.';
  }

  @override
  String avisoExistenciasSemana(String medicamento, String boton) {
    return '$medicamento: no n\'hi ha prou per a una setmana. Quan en compris més, prem \"$boton\" als teus medicaments.';
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
          '$medicamento: en queden $cantidad. Quan en compris més, prem \"$boton\" als teus medicaments.',
      one:
          '$medicamento: en queda 1. Quan en compris més, prem \"$boton\" als teus medicaments.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasQuedanYMedia(int n, String medicamento, String boton) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$medicamento: en queden $n i mitja. Quan en compris més, prem \"$boton\" als teus medicaments.',
      one:
          '$medicamento: en queda 1 i mitja. Quan en compris més, prem \"$boton\" als teus medicaments.',
      zero:
          '$medicamento: en queda mitja. Quan en compris més, prem \"$boton\" als teus medicaments.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasAcabadas(String medicamento, String boton) {
    return '$medicamento: ja no en queda cap. Quan en compris més, prem \"$boton\" als teus medicaments.';
  }

  @override
  String medicamentoExistenciasPocas(String boton) {
    return 'En queden poques. Quan en compris més, prem \"$boton\".';
  }

  @override
  String get medicamentoComprarMas => 'N\'he comprat més';

  @override
  String medicamentoComprarMasSemantica(String medicamento) {
    return 'He comprat més $medicamento';
  }

  @override
  String menuExistenciasPocas(String medicamentos) {
    return 'Et queden poques pastilles: $medicamentos.';
  }

  @override
  String menuRecetas(String medicamentos) {
    return 'Cal renovar la recepta de $medicamentos.';
  }

  @override
  String get formularioMedicamentoExistenciasTitulo =>
      'Pastilles que et queden (opcional)';

  @override
  String get formularioMedicamentoExistenciasDescripcion =>
      'Si vols, l\'aplicació les compta i t\'avisa abans que s\'acabin.';

  @override
  String get formularioMedicamentoSinCuenta => 'No portar el compte';

  @override
  String get formularioMedicamentoSinCuentaDescripcion =>
      'No t\'avisarem de quantes en queden.';

  @override
  String get formularioMedicamentoConCuenta => 'Portar el compte';

  @override
  String get formularioMedicamentoConCuentaDescripcion =>
      'Cada presa es descompta i t\'avisarem quan en quedin poques.';

  @override
  String get formularioMedicamentoExistenciasCampo => 'Pastilles que tens ara';

  @override
  String get formularioMedicamentoExistenciasCampoDescripcion =>
      'Compta-les, o posa les de la capsa si no l\'has començada. Si en queda mitja, escriu per exemple 14,5. També serveix per a càpsules o sobres.';

  @override
  String get formularioMedicamentoPorToma => 'Pastilles a cada presa';

  @override
  String formularioMedicamentoPorTomaValor(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastilles a cada presa',
      one: '1 pastilla a cada presa',
    );
    return '$_temp0';
  }

  @override
  String formularioMedicamentoPorTomaYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastilles i mitja a cada presa',
      one: '1 pastilla i mitja a cada presa',
      zero: 'mitja pastilla a cada presa',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoPorTomaMenos =>
      'Mitja pastilla menys a cada presa';

  @override
  String get formularioMedicamentoPorTomaMas =>
      'Mitja pastilla més a cada presa';

  @override
  String formularioMedicamentoPorTomaDeLas(String hora) {
    return 'Pastilles a la presa de les $hora';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMenos(String hora) {
    return 'Mitja pastilla menys a les $hora';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMas(String hora) {
    return 'Mitja pastilla més a les $hora';
  }

  @override
  String validadorMedicamentoExistencias(String maximo) {
    return 'Escriu quantes pastilles tens: un número entre 0 i $maximo. Si n\'hi ha mitja, amb coma: 14,5.';
  }

  @override
  String get comprarCampo => 'Quantes n\'has comprat?';

  @override
  String get comprarCampoDescripcion =>
      'Mira quantes en porta la capsa; per exemple, 28.';

  @override
  String comprarTendras(String pastillas) {
    return 'Tindràs $pastillas.';
  }

  @override
  String get comprarAnadir => 'Afegeix a les que tinc';

  @override
  String comprarError(String maximo) {
    return 'Escriu quantes n\'has comprat: un número entre 1 i $maximo.';
  }

  @override
  String get comprarHechoTitulo => 'Pastilles afegides';

  @override
  String get recetaTitulo => 'Recepta renovada';

  @override
  String get recetaPregunta => 'Fins a quin dia és la recepta nova?';

  @override
  String get recetaGuardar => 'Desa la data nova';

  @override
  String get recetaQuitar => 'Ja no cal renovar-la';

  @override
  String get recetaQuitarDescripcion =>
      'Treu la data: no t\'avisarem més d\'aquesta recepta.';

  @override
  String recetaGuardada(String medicamento, String fecha) {
    return 'Recepta de $medicamento: fins al $fecha.';
  }

  @override
  String recetaQuitada(String medicamento) {
    return 'Ja no t\'avisarem de la recepta de $medicamento.';
  }

  @override
  String comprarHecho(String pastillas, String medicamento) {
    return '$medicamento: ara tens $pastillas.';
  }

  @override
  String get compartirDeOtroMovil => 'Medicaments preparats en un altre mòbil';

  @override
  String compartirDeOtroMovilExplicacion(String boton) {
    return 'Un familiar pot apuntar les teves medicines i les teves cites al seu telèfon, amb aquesta mateixa aplicació, i enviar-te una còpia amb \"$boton\". Aquí les afegeixes sense esborrar res del que ja tens.';
  }

  @override
  String get compartirImportar => 'Afegeix medicaments d\'un altre mòbil';

  @override
  String get compartirImportarDescripcion =>
      'Tria la còpia que t\'han enviat. Abans et dirà què afegirà.';

  @override
  String get importarNoSePuede =>
      'No es poden afegir els medicaments d\'aquest fitxer';

  @override
  String get importarPregunta => 'Vols afegir el que porta aquesta còpia?';

  @override
  String importarCopiaDel(String fecha, String hora) {
    return 'Còpia del $fecha, a les $hora.';
  }

  @override
  String importarSeAnadiran(String medicamentos) {
    return 'S\'afegiran: $medicamentos.';
  }

  @override
  String importarSeActualizaran(int cuantos, String medicamentos) {
    String _temp0 = intl.Intl.pluralLogic(
      cuantos,
      locale: localeName,
      other:
          'Ja tenies $medicamentos: quedaran com a la còpia, sense perdre les preses anotades.',
      one:
          'Ja tenies $medicamentos: quedarà com a la còpia, sense perdre les preses anotades.',
    );
    return '$_temp0';
  }

  @override
  String importarCitas(String citas) {
    return 'Cites noves: $citas.';
  }

  @override
  String get importarNoSeBorra =>
      'No s\'esborra res: les teves preses anotades i la teva configuració queden com estan.';

  @override
  String get importarSi => 'Sí, afegeix';

  @override
  String get importarNadaNuevo => 'No hi ha res per afegir';

  @override
  String get importarNadaNuevoMensaje =>
      'Aquesta còpia no porta medicaments ni cites que no tinguis.';

  @override
  String get importarHecho => 'Medicaments afegits';

  @override
  String get importarError =>
      'No s\'han pogut afegir els medicaments. Torna-ho a provar.';

  @override
  String historialResumenSemana(
    String tomadas,
    String total,
    String porcentaje,
  ) {
    return 'Els últims 7 dies has marcat $tomadas de $total preses ($porcentaje %).';
  }

  @override
  String informeResumenSemana(String tomadas, String total, String porcentaje) {
    return 'Marcades: $tomadas de $total preses ($porcentaje %).';
  }

  @override
  String get compartirRecordarResumen => 'Recorda\'m que l\'enviï cada setmana';

  @override
  String get compartirRecordarResumenDescripcion =>
      'Els diumenges a les 18:00 t\'avisarem perquè enviïs la teva medicació i les teves preses.';

  @override
  String get avisoResumenTitulo => 'Envies el resum a la família?';

  @override
  String avisoResumenCuerpo(String boton) {
    return 'Toca aquí i prem \"$boton\" per enviar la teva medicació i les preses de la setmana.';
  }

  @override
  String get widgetTitulo => 'Propera presa';

  @override
  String get widgetVacio => 'No hi ha més preses previstes.';

  @override
  String get ajustesWidget => 'Posa la propera presa a la pantalla d\'inici';

  @override
  String ajustesWidgetDescripcion(String boton) {
    return 'Un requadre amb la propera presa i el botó \"$boton\", sense obrir l\'aplicació.';
  }

  @override
  String ajustesWidgetManual(String app) {
    return 'Mantén premut un espai buit de la pantalla d\'inici del telèfon, toca \"Widgets\" i cerca \"$app\".';
  }
}
