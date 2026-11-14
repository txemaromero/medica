// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class TextosAppEu extends TextosApp {
  TextosAppEu([String locale = 'eu']) : super(locale);

  @override
  String get fechaLunes => 'astelehena';

  @override
  String get fechaMartes => 'asteartea';

  @override
  String get fechaMiercoles => 'asteazkena';

  @override
  String get fechaJueves => 'osteguna';

  @override
  String get fechaViernes => 'ostirala';

  @override
  String get fechaSabado => 'larunbata';

  @override
  String get fechaDomingo => 'igandea';

  @override
  String get fechaEnero => 'urtarrila';

  @override
  String get fechaFebrero => 'otsaila';

  @override
  String get fechaMarzo => 'martxoa';

  @override
  String get fechaAbril => 'apirila';

  @override
  String get fechaMayo => 'maiatza';

  @override
  String get fechaJunio => 'ekaina';

  @override
  String get fechaJulio => 'uztaila';

  @override
  String get fechaAgosto => 'abuztua';

  @override
  String get fechaSeptiembre => 'iraila';

  @override
  String get fechaOctubre => 'urria';

  @override
  String get fechaNoviembre => 'azaroa';

  @override
  String get fechaDiciembre => 'abendua';

  @override
  String fechaLarga(String diaSemana, String dia, String mes, String anio) {
    return '${anio}ko ${mes}ren ${dia}a, $diaSemana';
  }

  @override
  String fechaHoy(String fecha) {
    return 'Gaur, $fecha';
  }

  @override
  String fechaManana(String fecha) {
    return 'Bihar, $fecha';
  }

  @override
  String fechaAyer(String fecha) {
    return 'Atzo, $fecha';
  }

  @override
  String fechaCuandoHoy(String hora) {
    return 'gaur ${hora}etan';
  }

  @override
  String fechaCuandoManana(String hora) {
    return 'bihar ${hora}etan';
  }

  @override
  String fechaCuandoOtroDia(
    String diaSemana,
    String dia,
    String mes,
    String hora,
  ) {
    return '${mes}ren ${dia}a, $diaSemana, ${hora}etan';
  }

  @override
  String get fechaDeLaMadrugada => 'goizaldeko';

  @override
  String get fechaDeLaManana => 'goizeko';

  @override
  String get fechaDelMediodia => 'eguerdiko';

  @override
  String get fechaDeLaTarde => 'arratsaldeko';

  @override
  String get fechaDeLaNoche => 'gaueko';

  @override
  String fechaHoraConParteDelDia(String hora, String parteDelDia) {
    return '$parteDelDia $hora';
  }

  @override
  String fechaListaUltimo(String anteriores, String ultimo) {
    return '$anteriores eta $ultimo';
  }

  @override
  String get fechaSeparadorLista => ', ';

  @override
  String get appTitulo => 'Salud y Medicación';

  @override
  String get avisoDeshecho => 'Eginda. Ekintza desegin da.';

  @override
  String get avisoNoSeHaPodidoDeshacer =>
      'Ezin izan da desegin. Saiatu berriro.';

  @override
  String get botonDeshacer => 'Desegin';

  @override
  String get botonDeshacerPista => 'Egin berri duzuna desegiten du';

  @override
  String get botonDeshacerPistaEliminar =>
      'Ezabatu berri duzuna berreskuratzen du';

  @override
  String get barraInicio => 'Hasiera';

  @override
  String get barraAtras => 'Atzera';

  @override
  String get barraInicioSemantica => 'Hasiera. Itzuli menu nagusira';

  @override
  String get barraAtrasSemantica => 'Atzera. Itzuli aurreko pantailara';

  @override
  String get interruptorActivado => 'Aktibatuta';

  @override
  String get interruptorDesactivado => 'Desaktibatuta';

  @override
  String selectorValor(String etiqueta, String valor) {
    return '$etiqueta: $valor';
  }

  @override
  String get cargando => 'Kargatzen…';

  @override
  String mensajeError(String texto) {
    return 'Errorea: $texto';
  }

  @override
  String get dialogoSiEliminar => 'Bai, ezabatu';

  @override
  String get dialogoNoVolver => 'Ez, itzuli';

  @override
  String get dialogoAceptar => 'Ados';

  @override
  String get dialogoEntendido => 'Ulertuta';

  @override
  String get dialogoAhoraNo => 'Orain ez';

  @override
  String selectorHoraElegida(String hora) {
    return 'Aukeratutako ordua: $hora';
  }

  @override
  String get selectorHora => 'Ordua';

  @override
  String selectorHoraValor(String hora) {
    return '${hora}ak';
  }

  @override
  String get selectorRestarHora => 'Ordu bat kendu';

  @override
  String get selectorSumarHora => 'Ordu bat gehitu';

  @override
  String get selectorMinutos => 'Minutuak';

  @override
  String selectorMinutosValor(String minutos) {
    return '$minutos minutu';
  }

  @override
  String selectorRestarMinutos(String minutos) {
    return '$minutos minutu kendu';
  }

  @override
  String selectorSumarMinutos(String minutos) {
    return '$minutos minutu gehitu';
  }

  @override
  String get selectorAtajoHoy => 'Gaur';

  @override
  String get selectorAtajoManana => 'Bihar';

  @override
  String get selectorAtajoEnUnaSemana => 'Astebete barru';

  @override
  String selectorDiaElegido(String fecha) {
    return 'Aukeratutako eguna: $fecha';
  }

  @override
  String get selectorDia => 'Eguna';

  @override
  String get selectorDiaAnterior => 'Aurreko eguna';

  @override
  String get selectorDiaSiguiente => 'Hurrengo eguna';

  @override
  String get selectorMes => 'Hilabetea';

  @override
  String get selectorMesAnterior => 'Aurreko hilabetea';

  @override
  String get selectorMesSiguiente => 'Hurrengo hilabetea';

  @override
  String get selectorAnio => 'Urtea';

  @override
  String get selectorAnioAnterior => 'Aurreko urtea';

  @override
  String get selectorAnioSiguiente => 'Hurrengo urtea';

  @override
  String selectorElegir(String texto) {
    return 'Aukeratu: $texto';
  }

  @override
  String get menuTitulo => 'Menu nagusia';

  @override
  String get menuPregunta => 'Zer egin nahi duzu?';

  @override
  String get menuMedicamentos => 'Botiken erregistroa';

  @override
  String get menuAgenda => 'Hitzorduak';

  @override
  String get menuEmergencias => 'Larrialdi-botoia';

  @override
  String get menuAjustes => 'Ezarpenak';

  @override
  String menuTomasDeHoy(String tomadas, String total) {
    return 'Gaurko hartualdiak: $tomadas markatuta, guztira $total.';
  }

  @override
  String menuProximaToma(String medicamento, String cuando) {
    return 'Hurrengo hartualdia: $medicamento, $cuando.';
  }

  @override
  String menuProximaCita(String cita, String cuando) {
    return 'Hurrengo hitzordua: $cita, $cuando.';
  }

  @override
  String get tomasTitulo => 'Gaurko hartualdiak';

  @override
  String get medicamentosMenuTomasDescripcion =>
      'Markatu gaur hartu dituzun botikak.';

  @override
  String get medicamentosMenuNuevo => 'Botika berria erregistratu';

  @override
  String get medicamentosMenuNuevoDescripcion =>
      'Idatzi botika bat, eta hartu behar duzunean abisatuko dizugu.';

  @override
  String get medicamentosMenuVer => 'Erregistratutako botikak ikusi';

  @override
  String get medicamentosMenuVerDescripcion =>
      'Begiratu zure botikak eta haien orduak, aldatu edo ezabatu jada hartzen ez dituzunak.';

  @override
  String get historialTitulo => 'Hartualdien historia';

  @override
  String get medicamentosMenuHistorialDescripcion =>
      'Ikusi zer hartualdi markatu dituzun azken 7 egunetan.';

  @override
  String get medicamentosMenuCompartir =>
      'Medikuarekin edo familiarekin partekatu';

  @override
  String get medicamentosMenuCompartirDescripcion =>
      'Bidali edo inprimatu zure botikak, hartualdiak eta hitzorduak.';

  @override
  String get listaMedicamentosTitulo => 'Erregistratutako botikak';

  @override
  String get listaMedicamentosPreguntaEliminar =>
      'Ziur botika hau ezabatu nahi duzula?';

  @override
  String listaMedicamentosDetalleEliminar(String medicamento) {
    return '$medicamento\n\nHaren abisuak ere ezabatuko dira.';
  }

  @override
  String get listaMedicamentosErrorEliminar =>
      'Ezin izan da botika ezabatu. Saiatu berriro.';

  @override
  String listaMedicamentosEliminado(String medicamento) {
    return 'Botika ezabatuta: $medicamento';
  }

  @override
  String listaMedicamentosRecuperado(String medicamento) {
    return 'Botika berreskuratuta: $medicamento';
  }

  @override
  String get listaMedicamentosVacio =>
      'Oraindik ez duzu botikarik erregistratu';

  @override
  String get listaMedicamentosVacioExplicacion =>
      'Bat erregistratzen duzunean, hemen agertuko da, hartzeko orduekin.';

  @override
  String listaMedicamentosCuantos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad botika dituzu erregistratuta.',
      one: 'Botika 1 duzu erregistratuta.',
    );
    return '$_temp0';
  }

  @override
  String get medicamentoSinFechaDeFin => 'Egunero, amaiera-datarik gabe';

  @override
  String medicamentoTerminadoEl(String fecha) {
    return 'Tratamendua amaituta. Azken eguna: $fecha';
  }

  @override
  String medicamentoRecetaHasta(String fecha) {
    return 'Errezeta: $fecha arte';
  }

  @override
  String medicamentoRecetaPronto(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other:
          'Errezeta $dias egun barru amaitzen da: eskatu hitzordua zure medikuari berritzeko',
      one: 'Errezeta bihar amaitzen da: eskatu hitzordua zure medikuari berritzeko',
      zero: 'Errezeta gaur amaitzen da: eskatu hitzordua zure medikuari berritzeko',
    );
    return '$_temp0';
  }

  @override
  String medicamentoRecetaAcabada(String fecha) {
    return 'Errezeta amaitu zen ($fecha): eskatu hitzordua zure medikuari berritzeko';
  }

  @override
  String get medicamentoRecetaRenovada => 'Berritu dut';

  @override
  String medicamentoRecetaRenovadaSemantica(String medicamento) {
    return '$medicamento botikaren errezeta berritu dut';
  }

  @override
  String medicamentoHastaEl(String fecha) {
    return 'Azken eguna: $fecha';
  }

  @override
  String medicamentoDosis(String dosis) {
    return 'Dosia: $dosis';
  }

  @override
  String medicamentoDosisALas(String dosis, String hora) {
    return '${hora}etan, $dosis';
  }

  @override
  String medicamentoHoras(String horas) {
    return 'Orduak: $horas';
  }

  @override
  String get botonModificar => 'Aldatu';

  @override
  String botonModificarSemantica(String nombre) {
    return 'Aldatu: $nombre';
  }

  @override
  String get botonEliminar => 'Ezabatu';

  @override
  String botonEliminarSemantica(String nombre) {
    return 'Ezabatu: $nombre';
  }

  @override
  String get formularioMedicamentoTituloNuevo => 'Botika berria';

  @override
  String get formularioMedicamentoTituloModificar => 'Botika aldatu';

  @override
  String get formularioMedicamentoCrear => 'Abisua sortu';

  @override
  String get formularioGuardarCambios => 'Aldaketak gorde';

  @override
  String get formularioMedicamentoGuardado => 'Botika ondo gorde da';

  @override
  String get formularioCambiosGuardados => 'Aldaketak ondo gorde dira';

  @override
  String formularioFotoAnadida(String boton) {
    return 'Argazkia gehituta. \"$boton\" sakatzean gordeko da.';
  }

  @override
  String get formularioErrorFotoCamara =>
      'Ezin izan da argazkia atera. Saiatu berriro.';

  @override
  String get formularioErrorFotoGaleria =>
      'Ezin izan da galeria ireki. Saiatu berriro.';

  @override
  String formularioFotoQuitada(String boton) {
    return 'Argazkia kenduta. Aldaketa \"$boton\" sakatzean gordeko da.';
  }

  @override
  String get formularioMedicamentoErrorGuardar =>
      'Ezin izan da botika gorde. Saiatu berriro.';

  @override
  String formularioMedicamentoResumenGuardado(
    String medicamento,
    String tomas,
    String horas,
  ) {
    return '$medicamento: $tomas.\nHartzeko orduak: $horas.';
  }

  @override
  String formularioMedicamentoUltimoDia(String fecha) {
    return 'Azken eguna: $fecha.';
  }

  @override
  String get avisosDesactivadosEnAjustes =>
      'Abisuak desaktibatuta daude. Ezarpenetan aktiba ditzakezu.';

  @override
  String formularioMedicamentoAvisoCadaDia(String horas) {
    return 'Egunero abisatuko dizugu: $horas.';
  }

  @override
  String formularioMedicamentoAvisoHasta(String horas, String fecha) {
    return 'Egunero abisatuko dizugu: $horas. Azken eguna: $fecha.';
  }

  @override
  String get formularioGuardando => 'Gordetzen…';

  @override
  String formularioRellenaYPulsa(String boton) {
    return 'Bete datuak eta sakatu \"$boton\".';
  }

  @override
  String get formularioMedicamentoNombre => 'Botikaren izena';

  @override
  String get formularioMedicamentoNombreDescripcion =>
      'Adibidez: Parazetamola.';

  @override
  String get formularioMedicamentoDictarNombre => 'Izena diktatu';

  @override
  String get formularioMedicamentoDictarNombreIndicacion =>
      'Esan botikaren izena';

  @override
  String get formularioMedicamentoDosis => 'Dosia (aukerakoa)';

  @override
  String get formularioMedicamentoDosisDescripcion =>
      'Aldi bakoitzean zenbat hartzen duzun. Adibidez: pilula 1.';

  @override
  String formularioMedicamentoDosisEnCadaToma(String seccion) {
    return 'Dosia orduaren arabera aldatzen da: hartualdi bakoitzekoa beherago dago, \"$seccion\" atalean.';
  }

  @override
  String get formularioMedicamentoDosisTomasTitulo =>
      'Dosia hartualdi bakoitzean';

  @override
  String get formularioMedicamentoDosisTomasDescripcion =>
      'Orduaren arabera aldatzen bada; adibidez, pilula bat goizean eta erdi bat gauean.';

  @override
  String get formularioMedicamentoDosisIgual => 'Berdina guztietan';

  @override
  String get formularioMedicamentoDosisIgualDescripcion =>
      'Goikoa, dosiaren eremuan.';

  @override
  String get formularioMedicamentoDosisDistinta =>
      'Desberdina orduaren arabera';

  @override
  String get formularioMedicamentoDosisDistintaDescripcion =>
      'Idatzi behean hartualdi bakoitzekoa.';

  @override
  String formularioMedicamentoDosisDeLas(String hora) {
    return '${hora}etako dosia';
  }

  @override
  String get formularioMedicamentoInstrucciones => 'Jarraibideak (aukerakoa)';

  @override
  String get formularioMedicamentoInstruccionesDescripcion =>
      'Adibidez: gosariarekin.';

  @override
  String get formularioMedicamentoFoto => 'Kaxaren argazkia (aukerakoa)';

  @override
  String get formularioMedicamentoFotoDescripcion =>
      'Horrela, begi-kolpe batean ezagutuko duzu botika.';

  @override
  String get formularioMedicamentoHacerFoto => 'Argazkia atera';

  @override
  String get formularioMedicamentoHacerOtraFoto => 'Beste argazki bat atera';

  @override
  String get formularioMedicamentoHacerFotoDescripcion =>
      'Telefonoaren kamerarekin.';

  @override
  String get formularioMedicamentoElegirGaleria => 'Galeriatik aukeratu';

  @override
  String get formularioMedicamentoElegirOtraGaleria =>
      'Galeriatik beste bat aukeratu';

  @override
  String get formularioMedicamentoGaleriaDescripcion =>
      'Telefonoan lehendik duzun argazki bat.';

  @override
  String get formularioMedicamentoQuitarFoto => 'Argazkia kendu';

  @override
  String get formularioMedicamentoNumeroTomas => 'Eguneko hartualdi kopurua';

  @override
  String get formularioMedicamentoNumeroTomasDescripcion =>
      'Egunean zenbat aldiz hartzen duzu?';

  @override
  String get formularioMedicamentoTomasAlDia => 'Eguneko hartualdiak';

  @override
  String formularioMedicamentoTomasValor(int tomas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas hartualdi',
      one: 'hartualdi 1',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoTomaMenos => 'Hartualdi bat gutxiago';

  @override
  String get formularioMedicamentoTomaMas => 'Hartualdi bat gehiago';

  @override
  String get formularioMedicamentoCadaCuantasHoras => 'Zenbat orduro';

  @override
  String formularioMedicamentoCadaHorasCorto(String horas) {
    return '$horas orduro';
  }

  @override
  String formularioMedicamentoCadaHorasValor(String horas) {
    return '$horas orduro';
  }

  @override
  String get formularioMedicamentoHoraMenos =>
      'Ordu bat gutxiago hartualdien artean';

  @override
  String get formularioMedicamentoHoraMas =>
      'Ordu bat gehiago hartualdien artean';

  @override
  String get formularioMedicamentoHoraInicio => 'Hasiera-ordua';

  @override
  String get formularioMedicamentoHoraInicioDescripcion =>
      'Zer ordutan da eguneko lehen hartualdia?';

  @override
  String get formularioMedicamentoDuracion => 'Tratamenduaren iraupena';

  @override
  String get formularioMedicamentoDuracionDescripcion =>
      'Beti hartzen duzu, ala egun batzuetan bakarrik?';

  @override
  String get formularioMedicamentoSiempre => 'Beti';

  @override
  String get formularioMedicamentoSiempreDescripcion =>
      'Amaiera-datarik gabe. Adibidez, tentsiorako botika bat.';

  @override
  String get formularioMedicamentoHastaUnDia => 'Egun jakin bat arte';

  @override
  String get formularioMedicamentoHastaUnDiaDescripcion =>
      'Adibidez, antibiotiko bat 7 egunez.';

  @override
  String get formularioMedicamentoUltimoDiaEtiqueta =>
      'Tratamenduaren azken eguna';

  @override
  String get formularioMedicamentoUltimoDiaDescripcion =>
      'Egun horretan oraindik hartu behar da.';

  @override
  String get formularioMedicamentoRecetaTitulo => 'Errezeta (aukerakoa)';

  @override
  String get formularioMedicamentoRecetaDescripcion =>
      'Errezeta egun batean amaitzen bada, astebete lehenago abisatuko dizugu, zure medikuarekin hitzordua eska dezazun.';

  @override
  String get formularioMedicamentoSinReceta => 'Datarik gabe';

  @override
  String get formularioMedicamentoSinRecetaDescripcion =>
      'Ez dizugu errezetaz abisatuko.';

  @override
  String get formularioMedicamentoConReceta => 'Egun jakin batean amaitzen da';

  @override
  String get formularioMedicamentoConRecetaDescripcion =>
      'Astebete lehenago abisatuko dizugu eta, berritzen duzun arte, aplikazioa irekitzen duzun egun bakoitzean.';

  @override
  String get formularioMedicamentoRecetaFecha => 'Errezetaren azken eguna';

  @override
  String get formularioMedicamentoRecetaFechaDescripcion =>
      'Errezetaren orrian dago, edo farmazian esango dizute.';

  @override
  String get formularioResumen => 'Laburpena';

  @override
  String get fotoCaja => 'Kaxaren argazkia';

  @override
  String fotoCajaDe(String medicamento) {
    return 'Kaxaren argazkia: $medicamento';
  }

  @override
  String get fotoNoSePuedeMostrar => 'Ezin da argazkia erakutsi.';

  @override
  String horarioDescripcion(int tomas, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas hartualdi egunean, $horas orduro',
      one: 'hartualdi 1 egunean',
    );
    return '$_temp0';
  }

  @override
  String get validadorMedicamentoNombreVacio =>
      'Idatzi botikaren izena. Adibidez: Parazetamola.';

  @override
  String validadorMedicamentoNombreLargo(String maximo) {
    return 'Izena luzeegia da. Erabili $maximo letra gehienez.';
  }

  @override
  String validadorMedicamentoTomas(String minimo, String maximo) {
    return 'Aukeratu egunean zenbat aldiz hartzen duzun: $minimo eta $maximo artean.';
  }

  @override
  String get validadorMedicamentoFrecuenciaUnaToma =>
      'Egunean hartualdi 1 baduzu, ez da maiztasuna aukeratu behar.';

  @override
  String validadorMedicamentoFrecuencia(String tomas, String horas) {
    return 'Egunean $tomas hartualdi badituzu, aukeratu $horas ordu edo gutxiago hartualdien artean.';
  }

  @override
  String validadorMedicamentoDosisLarga(String maximo) {
    return 'Dosia luzeegia da. Erabili $maximo letra gehienez.';
  }

  @override
  String validadorMedicamentoInstruccionesLargas(String maximo) {
    return 'Jarraibideak luzeegiak dira. Erabili $maximo letra gehienez.';
  }

  @override
  String get validadorMedicamentoHoraInicio =>
      'Aukeratu lehen hartualdiaren ordua.';

  @override
  String validadorMedicamentoFechaFinPasada(String opcion) {
    return 'Egun hori pasatu da. Aukeratu gaur edo etorkizuneko egun bat, edo markatu \"$opcion\" amaierarik ez badu.';
  }

  @override
  String get errorCargarMedicamentos =>
      'Ezin izan dira zure botikak kargatu. Itxi aplikazioa eta ireki berriro.';

  @override
  String get tomasMarcar => 'Hartu dut';

  @override
  String get tomasDesmarcar => 'Marka kendu';

  @override
  String get tomasVacio => 'Gaur ez duzu hartualdirik';

  @override
  String get tomasVacioExplicacion =>
      'Botika bat erregistratzen duzunean, hemen markatu ahal izango duzu hartualdi bakoitza.';

  @override
  String get tomasEscuchar => 'Gaurko hartualdiak entzun';

  @override
  String get tomasEscucharDescripcion =>
      'Zein hartu dituzun eta zein falta diren irakurriko dizu.';

  @override
  String tomasAnotada(String medicamento, String hora) {
    return 'Idatzita: $medicamento hartu duzu ($hora).';
  }

  @override
  String tomasDesmarcada(String medicamento, String hora) {
    return 'Marka kenduta: $medicamento ($hora).';
  }

  @override
  String get tomasDeshacerMarcarPista => 'Hartualdi honen marka kentzen du';

  @override
  String get tomasDeshacerDesmarcarPista =>
      'Hartualdi hau berriro markatzen du';

  @override
  String get tomasErrorCarga =>
      'Ezin izan dira zure hartualdiak kargatu. Itxi aplikazioa eta ireki berriro.';

  @override
  String tomasHasTomado(String tomadas, String total) {
    return '$tomadas hartuta, guztira $total.';
  }

  @override
  String tomasEstadoTomada(String hora) {
    return 'Hartuta ($hora)';
  }

  @override
  String tomasEstadoAplazada(String hora) {
    return 'Atzeratuta: berriro gogoraraziko dizugu ($hora)';
  }

  @override
  String get tomasEstadoPendiente => 'Hartzeko';

  @override
  String tomasEstadoSinMarcar(String hora) {
    return 'Markatu gabe. ${hora}etan zen.';
  }

  @override
  String get tomasDesmarcarDescripcion => 'Akatsez markatu baduzu.';

  @override
  String tomasDesmarcarSemantica(String medicamento, String hora) {
    return 'Marka kendu: $medicamento ($hora)';
  }

  @override
  String tomasMarcarSemantica(String medicamento, String hora) {
    return 'Hartu dut: $medicamento ($hora)';
  }

  @override
  String get historialVacio => 'Oraindik ez dago erakusteko hartualdirik';

  @override
  String get historialVacioExplicacion =>
      'Hemen ikusiko dituzu azken 7 egunetako hartualdiak, eta zein markatu zenituen hartutzat.';

  @override
  String get historialErrorCarga =>
      'Ezin izan da historia kargatu. Itxi aplikazioa eta ireki berriro.';

  @override
  String historialUltimosDias(String dias) {
    return 'Azken $dias egunak.';
  }

  @override
  String historialMarcadas(String tomadas, String total) {
    return 'Markatuta: $tomadas, guztira $total.';
  }

  @override
  String historialTomada(String hora, String medicamento, String momento) {
    return '$hora · $medicamento: hartuta ($momento)';
  }

  @override
  String historialAplazada(String hora, String medicamento) {
    return '$hora · $medicamento: atzeratuta, markatu gabe';
  }

  @override
  String historialPendiente(String hora, String medicamento) {
    return '$hora · $medicamento: hartzeko';
  }

  @override
  String historialSinMarcar(String hora, String medicamento) {
    return '$hora · $medicamento: markatu gabe';
  }

  @override
  String get agendaCrearCita => 'Hitzordua sortu';

  @override
  String get agendaCrearCitaDescripcion => 'Idatzi hitzordu berri bat.';

  @override
  String get agendaPreguntaEliminar => 'Ziur hitzordu hau ezabatu nahi duzula?';

  @override
  String agendaDetalleEliminar(String cita, String fecha, String hora) {
    return '$cita\n$fecha, ${hora}etan';
  }

  @override
  String get agendaErrorEliminar =>
      'Ezin izan da hitzordua ezabatu. Saiatu berriro.';

  @override
  String agendaCitaEliminada(String cita) {
    return 'Hitzordua ezabatuta: $cita';
  }

  @override
  String agendaCitaRecuperada(String cita) {
    return 'Hitzordua berreskuratuta: $cita';
  }

  @override
  String get agendaErrorCarga =>
      'Ezin izan dira zure hitzorduak kargatu. Itxi aplikazioa eta ireki berriro.';

  @override
  String get agendaVacio => 'Oraindik ez duzu hitzordurik';

  @override
  String agendaVacioExplicacion(String boton) {
    return 'Sakatu \"$boton\" botoia zure lehen hitzordua idazteko.';
  }

  @override
  String get agendaProximas => 'Hurrengo hitzorduak';

  @override
  String get agendaSinProximas => 'Ez duzu hurrengo hitzordurik.';

  @override
  String get agendaPasadas => 'Pasatutako hitzorduak';

  @override
  String get agendaCitaPasada => 'Hitzordu hau pasatu da.';

  @override
  String agendaModificarSemantica(String cita) {
    return 'Aldatu hitzordua: $cita';
  }

  @override
  String agendaEliminarSemantica(String cita) {
    return 'Ezabatu hitzordua: $cita';
  }

  @override
  String get formularioCitaTituloModificar => 'Hitzordua aldatu';

  @override
  String get formularioCitaGuardar => 'Hitzordua gorde';

  @override
  String get formularioCitaGuardada => 'Hitzordua ondo gorde da';

  @override
  String get formularioCitaErrorGuardar =>
      'Ezin izan da hitzordua gorde. Saiatu berriro.';

  @override
  String get formularioCitaMuyPronto =>
      'Hitzordua oso laster da: ez dago aurretik abisatzeko astirik.';

  @override
  String formularioCitaTeAvisaremos(String cuando) {
    return 'Abisatuko dizugu $cuando.';
  }

  @override
  String formularioCitaAvisoDiaAntes(String hora) {
    return 'aurreko egunean ${hora}etan';
  }

  @override
  String formularioCitaAvisoMismoDia(String hora) {
    return 'egun horretan ${hora}etan';
  }

  @override
  String get formularioCitaAvisoUnaHoraAntes => 'ordubete lehenago';

  @override
  String formularioCitaResumenGuardada(String cita, String fecha, String hora) {
    return '$cita\n$fecha, ${hora}etan.';
  }

  @override
  String get formularioCitaMotivo => 'Hitzorduaren arrazoia';

  @override
  String get formularioCitaMotivoDescripcion => 'Adibidez: Familia-medikua.';

  @override
  String get formularioCitaDictarMotivo => 'Arrazoia diktatu';

  @override
  String get formularioCitaDictarMotivoIndicacion =>
      'Esan hitzorduaren arrazoia';

  @override
  String get formularioCitaFecha => 'Data';

  @override
  String get formularioCitaFechaDescripcion => 'Zer egunetan da hitzordua?';

  @override
  String get formularioCitaHora => 'Ordua';

  @override
  String get formularioCitaHoraDescripcion => 'Zer ordutan da hitzordua?';

  @override
  String get formularioCitaLugar => 'Lekua (aukerakoa)';

  @override
  String get formularioCitaLugarDescripcion => 'Adibidez: Osasun-zentroa.';

  @override
  String get formularioCitaNotas => 'Oharrak (aukerakoa)';

  @override
  String get formularioCitaNotasDescripcion => 'Adibidez: analisiak eraman.';

  @override
  String get validadorCitaMotivoVacio =>
      'Idatzi hitzorduaren arrazoia. Adibidez: Familia-medikua.';

  @override
  String validadorCitaMotivoLargo(String maximo) {
    return 'Arrazoia luzeegia da. Erabili $maximo letra gehienez.';
  }

  @override
  String get validadorCitaDia => 'Aukeratu hitzorduaren eguna.';

  @override
  String get validadorCitaHora => 'Aukeratu hitzorduaren ordua.';

  @override
  String get validadorCitaDiaPasado =>
      'Egun hori pasatu da. Aukeratu gaur edo etorkizuneko egun bat.';

  @override
  String get validadorCitaHoraPasada =>
      'Ordu hori pasatu da. Aukeratu beranduagoko ordu bat.';

  @override
  String validadorCitaLugarLargo(String maximo) {
    return 'Lekua luzeegia da. Erabili $maximo letra gehienez.';
  }

  @override
  String validadorCitaNotasLargas(String maximo) {
    return 'Oharrak luzeegiak dira. Erabili $maximo letra gehienez.';
  }

  @override
  String get emergenciasTitulo => 'Larrialdiak';

  @override
  String get emergenciasLlamar => 'Deitu';

  @override
  String emergenciasLlamarAlNumero(String numero) {
    return 'Deitu $numero zenbakira';
  }

  @override
  String emergenciasLlamarA(String nombre) {
    return 'Deitu: $nombre';
  }

  @override
  String emergenciasAbriendoNumero(String numero) {
    return 'Telefonoa irekitzen, $numero zenbakira deitzeko…';
  }

  @override
  String emergenciasAbriendoNombre(String nombre) {
    return 'Telefonoa irekitzen, pertsona honi deitzeko: $nombre…';
  }

  @override
  String get emergenciasNoSeHaPodidoAbrir => 'Ezin izan da telefonoa ireki';

  @override
  String emergenciasMarcaAMano(String numero) {
    return 'Markatu $numero zenbakia eskuz, telefono-aplikazioan.';
  }

  @override
  String get emergenciasIrAAjustes => 'Joan Ezarpenetara';

  @override
  String get emergenciasIrAAjustesDescripcion =>
      'Han larrialdi-zenbakia gorde dezakezu.';

  @override
  String get emergenciasSinNumero =>
      'Oraindik ez duzu larrialdi-zenbakirik gorde';

  @override
  String get emergenciasSinNumeroExplicacion =>
      'Hemendik deitu ahal izateko, idatzi lehenik zenbakia Ezarpenetan. Adibidez, 112.';

  @override
  String emergenciasPulsaParaLlamar(String numero) {
    return 'Sakatu botoia $numero zenbakira deitzeko.';
  }

  @override
  String get emergenciasExplicacion =>
      'Telefonoa irekiko da, zenbakia idatzita duela. Hitz egiteko, sakatu telefonoaren deitzeko botoia.';

  @override
  String get ajustesSonidosActivados => 'Soinuak aktibatuta';

  @override
  String get ajustesSonidosDesactivados => 'Soinuak desaktibatuta';

  @override
  String get ajustesVibracionActivada => 'Bibrazioa aktibatuta';

  @override
  String get ajustesVibracionDesactivada => 'Bibrazioa desaktibatuta';

  @override
  String get ajustesLecturaActivada => 'Ozen irakurtzea aktibatuta';

  @override
  String get ajustesLecturaDesactivada => 'Ozen irakurtzea desaktibatuta';

  @override
  String get ajustesSinVozTitulo => 'Telefono honek ezin du ozen irakurri';

  @override
  String get ajustesSinVozMensaje =>
      'Euskarazko ahotsa falta zaio. Telefonoaren ezarpenetan instala daiteke: Erabilerraztasuna atalean, \"Testua ahots bihurtzeko irteera\" aukeran.';

  @override
  String get ajustesSinVozMensajeIphone =>
      'Euskarazko ahotsa falta zaio. iPhonearen ezarpenetan deskarga daiteke: Erabilerraztasuna → Ahozko edukia → Ahotsak.';

  @override
  String ajustesNumeroGuardado(String numero) {
    return 'Larrialdi-zenbakia gordeta: $numero';
  }

  @override
  String ajustesContactoGuardado(String nombre, String numero) {
    return 'Kontaktua gordeta: $nombre, $numero';
  }

  @override
  String get ajustesContactoBorrado => 'Senidearen kontaktua ezabatuta';

  @override
  String get ajustesCambiosAlMomento => 'Aldaketak berehala gordetzen dira.';

  @override
  String get ajustesActivarSonidos => 'Soinuak aktibatu';

  @override
  String get ajustesActivarSonidosDescripcion => 'Abisuek soinua egingo dute.';

  @override
  String get ajustesActivarVibracion => 'Bibrazioa aktibatu';

  @override
  String get ajustesActivarVibracionDescripcion =>
      'Telefonoak bibratu egingo du abisu bakoitzean.';

  @override
  String get ajustesActivarNotificaciones => 'Jakinarazpenak aktibatu';

  @override
  String get ajustesActivarNotificacionesDescripcion =>
      'Zure botiken eta hitzorduen abisuak jasoko dituzu.';

  @override
  String get ajustesProbarAviso => 'Abisua probatu';

  @override
  String get ajustesProbarAvisoDescripcion =>
      'Abisu bat bidaltzen du orain, nola entzuten eta ikusten den egiaztatzeko.';

  @override
  String get ajustesRepetirAvisos => 'Abisuak errepikatu';

  @override
  String ajustesRepetirAvisosDescripcion(String boton) {
    return 'Hartualdi bat markatzen ez baduzu, noiz abisatuko dizugun berriro, eta \"$boton\" botoiak zenbat itxaroten duen.';
  }

  @override
  String get ajustesAvisosDiscretos => 'Abisu diskretuak';

  @override
  String get ajustesAvisosDiscretosDescripcion =>
      'Abisuek ez dute esango zein botika hartu behar duzun edo hitzorduaren arrazoia, eta ez dute kaxaren argazkia erakutsiko: horrela, ez dira blokeo-pantailan ikusiko. Abisua ukitzean, aplikazioak esango dizu.';

  @override
  String get ajustesAvisosDiscretosActivados => 'Abisu diskretuak aktibatuta';

  @override
  String get ajustesAvisosDiscretosDesactivados =>
      'Abisu diskretuak desaktibatuta';

  @override
  String get repetirSinMarcarTitulo => 'Hartualdia markatzen ez baduzu';

  @override
  String get repetirSinMarcarDescripcion =>
      'Beste behin abisatuko dizugu, lehen abisua entzun ez bazenuen.';

  @override
  String repetirALosMinutos(int minutos) {
    return '$minutos minutu geroago';
  }

  @override
  String get repetirALaHora => 'Ordubete geroago';

  @override
  String get repetirNunca => 'Abisua ez errepikatu';

  @override
  String repetirEjemplo(String hora, String repeticion) {
    return '${hora}etako hartualdi bat ${repeticion}etan errepikatzen da.';
  }

  @override
  String get repetirNuncaDescripcion => 'Bere orduko abisua bakarrik joko du.';

  @override
  String get repetirAplazarTitulo => 'Geroago gogorarazi';

  @override
  String get repetirAplazarDescripcion =>
      'Hartualdien abisuek botoi bat dute, apur bat geroago gogorarazteko.';

  @override
  String repetirAplazarEjemplo(String hora, String despues) {
    return '${hora}etan sakatzen baduzu, ${despues}etan gogoraraziko dizugu.';
  }

  @override
  String repetirGuardado(String opcion) {
    return 'Gordeta: $opcion';
  }

  @override
  String get ajustesLeerEnVozAlta => 'Ozen irakurri';

  @override
  String get ajustesLeerEnVozAltaDescripcion =>
      'Abisuak irekitzean irakurriko ditu, eta gaurko hartualdiak entzun ahal izango dituzu.';

  @override
  String get ajustesNumeroEmergencia => 'Larrialdi-zenbakia';

  @override
  String get ajustesNumeroEmergenciaDescripcion =>
      'Larrialdi-botoiak zenbaki honetara deituko du. Adibidez: 112.';

  @override
  String get ajustesGuardarNumero => 'Zenbakia gorde';

  @override
  String get ajustesNombreFamiliar => 'Senide baten izena';

  @override
  String get ajustesNombreFamiliarDescripcion =>
      'Larrialdiak pantailatik deitu ahal izango diozun beste pertsona bat. Adibidez: Nire alaba Ana.';

  @override
  String get ajustesTelefonoFamiliar => 'Senidearen telefonoa';

  @override
  String get ajustesGuardarContacto => 'Kontaktua gorde';

  @override
  String get ajustesGuardarContactoDescripcion =>
      'Ezabatzeko, utzi bi eremuak hutsik.';

  @override
  String get ajustesTamanoTexto => 'Testuaren tamaina doitu';

  @override
  String get ajustesTamanoTextoDescripcion =>
      'Egin letrak handiagoak edo txikiagoak.';

  @override
  String get ajustesTema => 'Gaia doitu';

  @override
  String get ajustesTemaDescripcion => 'Aldatu aplikazioaren koloreak.';

  @override
  String get compartirTitulo => 'Partekatzea eta babeskopia';

  @override
  String get ajustesCompartirDescripcion =>
      'Bidali zure medikazioa medikuari edo familiari, eta gorde zure datuak ez galtzeko.';

  @override
  String get permisosNotificacionesActivadas => 'Jakinarazpenak aktibatuta';

  @override
  String get permisosNotificacionesDesactivadas =>
      'Jakinarazpenak desaktibatuta';

  @override
  String get permisosDenegado =>
      'Telefonoak ez du abisuak erakusteko baimenik eman; beraz, desaktibatuta jarraitzen dute.';

  @override
  String get permisosHoraExactaTitulo => 'Abisuak ordu zehatzean';

  @override
  String permisosHoraExactaMensaje(String boton) {
    return 'Jakinarazpenak aktibatuta daude jada. Abisuak beren orduan iristeko, telefonoak beste baimen bat behar du.\n\n\"$boton\" sakatzen baduzu, telefonoaren pantaila bat irekiko da: aktibatu aukera eta itzuli Atzera botoiarekin.';
  }

  @override
  String get permisosDarPermiso => 'Baimena eman';

  @override
  String get permisosHoraExactaConcedido =>
      'Prest: abisuak ordu zehatzean iritsiko dira.';

  @override
  String get permisosHoraExactaDenegado =>
      'Baimen hori gabe, abisuak minutu batzuk berandu irits daitezke.';

  @override
  String get permisosFaltaTitulo => 'Telefonoaren baimena falta da';

  @override
  String permisosFaltaMensaje(String explicacion, String boton) {
    return '$explicacion\n\nSakatu \"$boton\", aktibatu jakinarazpenak eta itzuli Atzera botoiarekin.';
  }

  @override
  String get permisosAbrirAjustes => 'Telefonoaren ezarpenak ireki';

  @override
  String get permisosPruebaEnviada =>
      'Proba-abisua bidalita. Begiratu pantailaren goiko aldera.';

  @override
  String get permisosPruebaDesactivadasTitulo =>
      'Jakinarazpenak desaktibatuta daude';

  @override
  String permisosPruebaDesactivadasMensaje(String interruptor, String boton) {
    return 'Aktibatu lehenik \"$interruptor\", eta gero sakatu berriro \"$boton\".';
  }

  @override
  String get permisosPruebaSinPermiso =>
      'Telefonoak ez du uzten aplikazio honen abisuak erakusten.';

  @override
  String get temaPredeterminado => 'Gai lehenetsia';

  @override
  String get temaPredeterminadoDescripcion =>
      'Hondo urdin argia eta letra beltzak.';

  @override
  String get temaOscuro => 'Gai iluna';

  @override
  String get temaOscuroDescripcion =>
      'Hondo iluna eta letra zuriak. Argi gutxirekin, gutxiago nekatzen ditu begiak.';

  @override
  String get temaAlternativo => 'Gai alternatiboa';

  @override
  String get temaAlternativoDescripcion =>
      'Hondo hori leuna eta letra beltzak. Islak gutxitzen ditu.';

  @override
  String get temaTitulo => 'Gaia';

  @override
  String get temaAplicar => 'Gai hau aplikatu';

  @override
  String temaAplicado(String tema) {
    return 'Gaia aplikatuta: $tema';
  }

  @override
  String get temaToca => 'Ukitu gai bat laginean ikusteko.';

  @override
  String temaMuestra(String tema) {
    return 'Lagina: $tema';
  }

  @override
  String get temaYaLoUsas => 'Hau da dagoeneko erabiltzen duzun gaia.';

  @override
  String temaAhoraUsas(String tema) {
    return 'Orain erabiltzen duzuna: $tema.';
  }

  @override
  String get temaElegido => 'Aukeratuta';

  @override
  String get temaEnUso => 'Erabilian';

  @override
  String get temaSeparadorEstado => ' · ';

  @override
  String get temaMuestraTexto => 'Horrela ikusiko dira pantailak gai honekin.';

  @override
  String get temaMuestraBoton => 'Adibide-botoia';

  @override
  String get temaMuestraInterruptor => 'Adibide-etengailua';

  @override
  String get temaMuestraInterruptorDescripcion => 'Berdea: aktibatuta.';

  @override
  String get tamanoTitulo => 'Testuaren tamaina';

  @override
  String get tamanoAumentar => 'Handitu (+)';

  @override
  String get tamanoReducir => 'Txikitu (−)';

  @override
  String get tamanoMuestraTexto =>
      'Horrela ikusiko dira aplikazioko testuak. Adibidez: Parazetamola, 3 hartualdi egunean, 8 orduro.';

  @override
  String tamanoActual(String tamano) {
    return 'Oraingo tamaina: $tamano';
  }

  @override
  String tamanoActualNormal(String tamano) {
    return 'Oraingo tamaina: $tamano (normala)';
  }

  @override
  String tamanoActualMinimo(String tamano) {
    return 'Oraingo tamaina: $tamano (txikiena)';
  }

  @override
  String tamanoActualMaximo(String tamano) {
    return 'Oraingo tamaina: $tamano (handiena)';
  }

  @override
  String tamanoPuedesElegir(String minimo, String maximo) {
    return '$minimo eta $maximo artean aukera dezakezu. Aldaketa aplikazio osoan aplikatzen da.';
  }

  @override
  String get tamanoMasGrandes => 'Letra handiagoak.';

  @override
  String get tamanoYaMaximo => 'Tamaina handienean dago jada.';

  @override
  String get tamanoMasPequenas => 'Letra txikiagoak.';

  @override
  String get tamanoYaMinimo => 'Tamaina txikienean dago jada.';

  @override
  String get tamanoMuestra => 'Lagina';

  @override
  String get ajustesFraseDePruebaVoz =>
      'Horrela entzungo da ahotsa. Zure abisuak eta gaurko hartualdiak irakurriko ditut.';

  @override
  String get validadorFamiliarNombreVacio =>
      'Idatzi nola deitzen den. Adibidez: Nire alaba Ana.';

  @override
  String validadorFamiliarNombreLargo(String maximo) {
    return 'Izena luzeegia da: $maximo letra gehienez.';
  }

  @override
  String get validadorFamiliarNumeroVacio => 'Idatzi haren telefono-zenbakia.';

  @override
  String get validadorTelefonoVacio =>
      'Idatzi telefono-zenbaki bat. Adibidez: 112.';

  @override
  String get validadorTelefonoSoloNumeros =>
      'Idatzi zenbakiak bakarrik. Adibidez: 112 edo 600123456.';

  @override
  String validadorTelefonoCorto(String minimo) {
    return 'Zenbakia laburregia da. Gutxienez $minimo zifra izan behar ditu.';
  }

  @override
  String get validadorTelefonoLargo =>
      'Zenbakia luzeegia da. Begiratu ondo idatzita dagoen.';

  @override
  String get asistenteTitulo => 'Lehen urratsak';

  @override
  String get asistenteEmpezar => 'Hasi';

  @override
  String get asistenteSaltar => 'Urrats hauek saltatu';

  @override
  String get asistenteSaltarDescripcion => 'Zuzenean menu nagusira joan.';

  @override
  String get asistenteSiguiente => 'Hurrengoa';

  @override
  String get asistenteTerminar => 'Aplikazioa erabiltzen hasi';

  @override
  String get asistenteHola => 'Kaixo';

  @override
  String get asistenteBienvenida =>
      'Aplikazioa 3 urratsetan prestatuko dugu: letraren tamaina, abisuak eta larrialdi-zenbakia.';

  @override
  String get asistenteCambiarEnAjustes =>
      'Dena alda daiteke geroago Ezarpenetan.';

  @override
  String asistentePaso(String numero, String total, String titulo) {
    return '$numero. urratsa ($total guztira): $titulo';
  }

  @override
  String get asistenteTamanoTitulo => 'Letraren tamaina';

  @override
  String get asistenteTamanoExplicacion =>
      'Ondo irakurtzen duzu testu hau? Kosta egiten bazaizu, egin letrak handiagoak.';

  @override
  String get asistenteAvisosTitulo => 'Botiken eta hitzorduen abisuak';

  @override
  String get asistenteAvisosExplicacion =>
      'Botika bakoitzaren orduan eta hitzordu bakoitzaren aurretik abisatuko dizugu, soinuarekin eta bibrazioarekin.';

  @override
  String get asistenteActivarAvisos => 'Abisuak aktibatu';

  @override
  String get asistenteActivarAvisosDescripcion =>
      'Telefonoak baimena eskatuko dizu: sakatu \"Baimendu\".';

  @override
  String asistenteSiPrefieresNo(String boton) {
    return 'Orain aktibatu nahi ez badituzu, sakatu \"$boton\".';
  }

  @override
  String get asistenteConSonido => 'soinuarekin';

  @override
  String get asistenteSinSonido => 'soinurik gabe';

  @override
  String get asistenteConVibracion => 'bibrazioarekin';

  @override
  String get asistenteSinVibracion => 'bibraziorik gabe';

  @override
  String asistenteAvisosActivados(String sonido, String vibracion) {
    return 'Abisuak aktibatuta daude, $sonido eta $vibracion.';
  }

  @override
  String get asistenteProbarAvisoDescripcion =>
      'Abisu bat bidaltzen du orain, nola entzuten eta ikusten den jakiteko.';

  @override
  String get asistenteEmergenciaTitulo => 'Larrialdi-zenbakia';

  @override
  String get asistenteEmergenciaExplicacion =>
      'Larrialdi-botoiak zenbaki honetara deituko du. 112 izan daiteke, edo senide batena.';

  @override
  String get asistenteEmergenciaDescripcion =>
      'Orain jarri nahi ez baduzu, utzi hutsik.';

  @override
  String get asistenteTodoListo => 'Dena prest';

  @override
  String asistenteResumenTamano(String tamano) {
    return 'Letraren tamaina: $tamano.';
  }

  @override
  String get asistenteResumenAvisosActivados => 'Abisuak aktibatuta.';

  @override
  String get asistenteResumenAvisosDesactivados =>
      'Abisuak desaktibatuta. Ezarpenetan aktiba ditzakezu.';

  @override
  String asistenteResumenNumero(String numero) {
    return 'Larrialdi-zenbakia: $numero.';
  }

  @override
  String get asistenteResumenSinNumero =>
      'Ez dago larrialdi-zenbakirik. Ezarpenetan jar dezakezu.';

  @override
  String get asistenteTambienEnAjustes =>
      'Ezarpenetan, koloreak aukeratu eta ozen irakurtzea aktiba dezakezu.';

  @override
  String get compartirEnviarInforme => 'Medikazioa eta hitzorduak bidali';

  @override
  String get compartirEnviarInformeDescripcion =>
      'WhatsApp bidez, posta elektronikoz… Hurrengo pantailan aukeratuko duzu nori.';

  @override
  String get compartirImprimir => 'Inprimatu';

  @override
  String get compartirImprimirDescripcion =>
      'Telefonoari konektatutako inprimagailu batean, edo PDF gisa gorde.';

  @override
  String get compartirGuardarCopia => 'Kopia bat gorde';

  @override
  String get compartirGuardarCopiaDescripcion =>
      'Google Drive-n edo deskargen karpetan.';

  @override
  String get compartirEnviarCopia => 'Kopia bat bidali';

  @override
  String get compartirEnviarCopiaDescripcion =>
      'Posta elektronikoz edo WhatsApp bidez: zure posta helbidera edo senide bati.';

  @override
  String get compartirRecuperar => 'Kopia bat berreskuratu';

  @override
  String get compartirRecuperarDescripcion =>
      'Telefono honetako datuak kopia bateko datuekin ordezten ditu. Aurretik galdetu egingo dizu.';

  @override
  String get compartirSiRecuperar => 'Bai, kopia berreskuratu';

  @override
  String get compartirErrorDocumento =>
      'Ezin izan da dokumentua prestatu. Saiatu berriro.';

  @override
  String get compartirErrorImprimir =>
      'Ezin izan da inprimatzeko pantaila ireki. Saiatu berriro.';

  @override
  String get compartirCopiaGuardada => 'Babeskopia gordeta.';

  @override
  String get compartirErrorGuardarCopia =>
      'Ezin izan da kopia gorde. Saiatu berriro.';

  @override
  String get compartirErrorEnviarCopia =>
      'Ezin izan da kopia prestatu. Saiatu berriro.';

  @override
  String get compartirNoSePuedeRecuperar =>
      'Ezin da fitxategi hau berreskuratu';

  @override
  String get compartirSustitucionVacio =>
      'Kopian dagoena jarriko da telefono honetan.';

  @override
  String compartirSustitucion(String actual) {
    return 'Telefono honetan orain dagoena ezabatuko da ($actual), eta kopiakoa jarriko da.';
  }

  @override
  String get compartirPreguntaRecuperar => 'Kopia hau berreskuratu?';

  @override
  String compartirCopiaDel(String fecha, String hora, String resumen) {
    return 'Kopiaren data: $fecha, $hora. Edukia: $resumen.';
  }

  @override
  String compartirCopiaEmergencia(String numero) {
    return 'Larrialdi-zenbakia: $numero.';
  }

  @override
  String get compartirCopiaSinEmergencia => 'Larrialdi-zenbakirik gabe.';

  @override
  String compartirCopiaFamiliar(String familiar) {
    return 'Senidea: $familiar.';
  }

  @override
  String get compartirCopiaSinFamiliar => 'Seniderik gabe.';

  @override
  String get compartirCopiaRecuperada => 'Kopia berreskuratuta';

  @override
  String compartirYaTienes(String resumen) {
    return 'Telefono honetan dagoeneko duzuna: $resumen.';
  }

  @override
  String get compartirAvisosDesactivados =>
      'Abisuak desaktibatuta daude telefono honetan: aktibatu Ezarpenetan, jasotzeko.';

  @override
  String get compartirErrorRecuperar =>
      'Ezin izan da kopia berreskuratu. Saiatu berriro.';

  @override
  String get compartirParaElMedico => 'Medikuarentzat edo familiarentzat';

  @override
  String get compartirParaElMedicoExplicacion =>
      'Dokumentu bat zure botikekin, azken asteko hartualdiekin eta hurrengo hitzorduekin.';

  @override
  String get compartirCopiaDeSeguridad => 'Babeskopia';

  @override
  String compartirCopiaExplicacion(String boton) {
    return 'Gorde zure datu guztiak fitxategi batean: botikak argazkiekin, hartualdiak, hitzorduak eta ezarpenak. Mugikor berri batean, instalatu aplikazioa eta sakatu \"$boton\".';
  }

  @override
  String get compartirUnMomento => 'Itxaron une batez, mesedez…';

  @override
  String copiaNoEsCopia(String app) {
    return 'Fitxategi hau ez da aplikazio honen kopia bat ($app), edo hondatuta dago.';
  }

  @override
  String copiaDemasiadoGrande(String app) {
    return 'Fitxategi hau handiegia da aplikazio honen kopia bat izateko ($app).';
  }

  @override
  String get copiaVersionNueva =>
      'Kopia hau aplikazioaren bertsio berriago batekoa da. Eguneratu aplikazioa eta saiatu berriro.';

  @override
  String copiaNombreFichero(String app, String fecha) {
    return '$app kopia $fecha';
  }

  @override
  String copiaMedicamentos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad botika',
      one: 'botika 1',
    );
    return '$_temp0';
  }

  @override
  String copiaCitas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad hitzordu',
      one: 'hitzordu 1',
    );
    return '$_temp0';
  }

  @override
  String copiaTomas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'idatzitako $cantidad hartualdi',
      one: 'idatzitako hartualdi 1',
    );
    return '$_temp0';
  }

  @override
  String copiaAsunto(String app) {
    return 'Babeskopia: $app';
  }

  @override
  String get informeTitulo => 'Nire medikazioa eta hitzorduak';

  @override
  String informeNombreFichero(String fecha) {
    return 'Medikazioa eta hitzorduak $fecha';
  }

  @override
  String informePagina(String pagina, String total) {
    return 'Orrialdea: $pagina/$total';
  }

  @override
  String informeActualizado(String fecha, String hora) {
    return 'Eguneratuta: $fecha, $hora.';
  }

  @override
  String informeTelefonosEmergencia(String telefonos) {
    return 'Larrialdi-telefonoak: $telefonos.';
  }

  @override
  String informeContactoFamiliar(String nombre, String numero) {
    return '$nombre: $numero';
  }

  @override
  String get informeSeparadorTelefonos => ' · ';

  @override
  String get informeMedicamentos => 'Botikak';

  @override
  String get informeSinMedicamentos => 'Ez dago botikarik erregistratuta.';

  @override
  String informeTomasYHoras(String tomas, String horas) {
    return '$tomas: $horas';
  }

  @override
  String informeInstrucciones(String instrucciones) {
    return 'Jarraibideak: $instrucciones';
  }

  @override
  String informeTomasUltimosDias(String dias) {
    return 'Azken $dias egunetako hartualdiak';
  }

  @override
  String get informeColumnaDia => 'Eguna';

  @override
  String get informeColumnaTomadas => 'Hartutakoak';

  @override
  String get informeColumnaSinMarcar => 'Markatu gabe';

  @override
  String get informeHoy => 'Gaur';

  @override
  String informeDiaFecha(String dia, String numero, String mes) {
    return '$dia $numero/$mes';
  }

  @override
  String informeTomadas(String tomadas, String total) {
    return '$tomadas/$total';
  }

  @override
  String informeTomadasConPendientes(
    String tomadas,
    String total,
    String pendientes,
  ) {
    return '$tomadas/$total ($pendientes hartzeko)';
  }

  @override
  String informeTomaSinMarcar(String hora, String medicamento) {
    return '$hora $medicamento';
  }

  @override
  String informeYMas(String lista, String mas) {
    return '$lista eta beste $mas';
  }

  @override
  String get informeSinTomas => 'Ez dago hartualdirik egun hauetan.';

  @override
  String get informeProximasCitas => 'Hurrengo hitzorduak';

  @override
  String get informeSinCitas => 'Ez dago hurrengo hitzordurik.';

  @override
  String informeCitaCuando(String fecha, String hora) {
    return '$fecha, ${hora}etan';
  }

  @override
  String informeLugar(String lugar) {
    return 'Lekua: $lugar';
  }

  @override
  String informeNotas(String notas) {
    return 'Oharrak: $notas';
  }

  @override
  String get canalConSonidoYVibracion =>
      'Abisuak soinuarekin eta bibrazioarekin';

  @override
  String get canalConSonido => 'Abisuak soinuarekin';

  @override
  String get canalConVibracion => 'Abisuak bibrazioarekin';

  @override
  String get canalSilencioso => 'Abisu isilak';

  @override
  String get canalDescripcion => 'Botiken hartualdien eta hitzorduen abisuak.';

  @override
  String get avisoNotaRenovar =>
      'Ireki aplikazioa abisu hauek jasotzen jarraitzeko.';

  @override
  String get avisoTomaTitulo => 'Botika hartzeko ordua';

  @override
  String get avisoAplazadoTitulo => 'Gogoratu zure botika';

  @override
  String get avisoRepeticionTitulo => 'Hartu duzu zure botika?';

  @override
  String avisoTomaCuerpo(String medicamento, String hora) {
    return 'Hartu $medicamento ($hora).';
  }

  @override
  String avisoTomaCuerpoConDosis(
    String medicamento,
    String dosis,
    String hora,
  ) {
    return 'Hartu $medicamento: $dosis ($hora).';
  }

  @override
  String avisoRepeticionCuerpo(String hora, String medicamento, String boton) {
    return '${hora}etan zen: $medicamento. Hartu baduzu, sakatu \"$boton\".';
  }

  @override
  String avisoRepeticionCuerpoConDosis(
    String hora,
    String medicamento,
    String dosis,
    String boton,
  ) {
    return '${hora}etan zen: $medicamento: $dosis. Hartu baduzu, sakatu \"$boton\".';
  }

  @override
  String avisoTomaCuerpoDiscreto(String hora) {
    return '${hora}etakoa. Ukitu hemen zein den ikusteko.';
  }

  @override
  String avisoRepeticionCuerpoDiscreto(String hora) {
    return '${hora}etan zen. Ukitu hemen zein den ikusteko.';
  }

  @override
  String get avisoExistenciasCuerpoDiscreto =>
      'Botika batenak dira. Ukitu hemen zein den ikusteko.';

  @override
  String get avisoRecetaCuerpoDiscreto =>
      'Botika batena da. Ukitu hemen zein den ikusteko.';

  @override
  String avisoCitaCuerpoDiscreto(String hora) {
    return '${hora}etan. Ukitu hemen zein den ikusteko.';
  }

  @override
  String get avisoCitaHoy => 'Gaur hitzordu bat duzu';

  @override
  String get avisoCitaManana => 'Bihar hitzordu bat duzu';

  @override
  String get avisoCitaUnaHora => 'Zure hitzordua ordubete barru da';

  @override
  String avisoCitaCuerpo(String cita, String hora) {
    return '$cita, ${hora}etan.';
  }

  @override
  String avisoCitaCuerpoConLugar(String cita, String hora, String lugar) {
    return '$cita, ${hora}etan. Lekua: $lugar.';
  }

  @override
  String avisoAplazar(int minutos) {
    return 'Gogorarazi $minutos min barru';
  }

  @override
  String get avisoPruebaTitulo => 'Proba-abisua';

  @override
  String get avisoPruebaCuerpo =>
      'Horrela abisatuko dizugu zure botiken eta hitzorduen berri.';

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
    return 'Botika hartzeko ordua: $hora. $detalle Hartzen duzunean, sakatu: $boton.';
  }

  @override
  String vozCita(String cita, String cuando) {
    return 'Hitzordu bat duzu: $cita, $cuando.';
  }

  @override
  String vozCitaConLugar(String cita, String cuando, String lugar) {
    return 'Hitzordu bat duzu: $cita, $cuando. Lekua: $lugar.';
  }

  @override
  String get vozSinTomas => 'Gaur ez duzu hartualdirik.';

  @override
  String vozTotalTomas(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad hartualdi dituzu',
      one: 'hartualdi bat duzu',
    );
    return '$_temp0';
  }

  @override
  String vozTodasTomadas(String total) {
    return 'Gaur $total, eta denak hartu dituzu.';
  }

  @override
  String vozHasTomado(String total, String tomadas) {
    return 'Gaur $total. Hartuta: $tomadas.';
  }

  @override
  String vozTeFaltan(int cantidad, String lista) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: 'Falta zaizkizu: $lista',
      one: 'Falta zaizu: $lista',
    );
    return '$_temp0';
  }

  @override
  String vozNombreConDosis(String medicamento, String dosis) {
    return '$medicamento, $dosis';
  }

  @override
  String vozFaltanteSinMarcar(String medicamento, String hora) {
    return '$medicamento, $hora, markatu gabe.';
  }

  @override
  String vozFaltanteAplazada(String medicamento, String hora) {
    return '$medicamento, $hora, atzeratuta.';
  }

  @override
  String vozFaltantePendiente(String medicamento, String hora) {
    return '$medicamento, ${hora}etan.';
  }

  @override
  String vozHasDictado(String texto) {
    return 'Diktatu duzuna: $texto. Zuzena ez bada, diktatu berriro edo zuzendu teklatuarekin.';
  }

  @override
  String get vozNoPuedeDictar =>
      'Telefono honek ez du diktatzen uzten. Idatzi teklatuarekin.';

  @override
  String get vozDictarDescripcion => 'Esan ozen, eta berez idatziko da.';

  @override
  String respuestaAplazada(String hora) {
    return 'Berriro gogoraraziko dizugu ($hora).';
  }

  @override
  String get respuestaSinMedicamento =>
      'Botika hori ez dago erregistratuta jada.';

  @override
  String get estadoAvisosListos => 'Abisuak prest daude beren orduan iristeko.';

  @override
  String get estadoAvisosSinPermiso =>
      'Telefonoak ez dio aplikazio honi abisuak erakusten uzten; beraz, ez dira iritsiko.';

  @override
  String get estadoAvisosSinHoraExacta =>
      'Ordu zehatzeko baimena falta da: abisuak minutu batzuk berandu irits daitezke.';

  @override
  String get estadoAvisosAhorroBateria =>
      'Telefonoaren bateria-aurrezpenak abisuak atzeratu ditzake, edo iristea eragotzi.';

  @override
  String get estadoAvisosBotonPermiso => 'Abisuetarako baimena eman';

  @override
  String get estadoAvisosBotonHoraExacta => 'Ordu zehatzeko baimena eman';

  @override
  String get estadoAvisosBotonBateria => 'Bateria-aurrezpena kendu';

  @override
  String get estadoAvisosPermisoConcedido =>
      'Prest: abisuak iritsi daitezke orain.';

  @override
  String get bateriaTitulo => 'Bateria-aurrezpena';

  @override
  String bateriaMensaje(String boton) {
    return 'Telefono batzuek aplikazioak ixten dituzte bateria aurrezteko, eta orduan abisuak berandu iristen dira edo ez dira iristen.\n\n\"$boton\" sakatzen baduzu, aplikazio honen pantaila irekiko da telefonoaren ezarpenetan. Ukitu \"Bateria\" (edo \"Bateriaren erabilera\"), aukeratu \"Murriztapenik gabe\" eta itzuli Atzera botoiarekin.';
  }

  @override
  String get bateriaAbrir => 'Ezarpenak ireki';

  @override
  String get menuAvisosSinPermiso =>
      'Abisuak ezin dira iritsi: telefonoak ez dio baimenik ematen aplikazio honi.';

  @override
  String get formularioRecuperado => 'Idazten ari zinena berreskuratu dugu.';

  @override
  String formularioRecuperadoConFoto(String boton) {
    return 'Idazten ari zinena eta argazkia berreskuratu ditugu. \"$boton\" sakatzean gordeko da.';
  }

  @override
  String fechaCorta(String diaSemana, String dia, String mes) {
    return '${mes}ren ${dia}a, $diaSemana';
  }

  @override
  String horarioDescripcionLibre(int tomas) {
    String _temp0 = intl.Intl.pluralLogic(
      tomas,
      locale: localeName,
      other: '$tomas hartualdi egunean',
      one: 'hartualdi 1 egunean',
    );
    return '$_temp0';
  }

  @override
  String get semanaLunes => 'astelehenetan';

  @override
  String get semanaMartes => 'asteartetan';

  @override
  String get semanaMiercoles => 'asteazkenetan';

  @override
  String get semanaJueves => 'ostegunetan';

  @override
  String get semanaViernes => 'ostiraletan';

  @override
  String get semanaSabado => 'larunbatetan';

  @override
  String get semanaDomingo => 'igandetan';

  @override
  String diasSemanaFrase(String dias) {
    return '$dias';
  }

  @override
  String diasCadaFrase(String cada, String fecha) {
    return '$cada egunetik behin (lehen eguna: $fecha)';
  }

  @override
  String get validadorMedicamentoHorasRepetidas =>
      'Bi hartualdi ordu berean daude. Aldatu horietako bat.';

  @override
  String get validadorMedicamentoSinDias =>
      'Aukeratu asteko egun bat gutxienez.';

  @override
  String validadorMedicamentoCadaDias(String minimo, String maximo) {
    return 'Aukeratu zenbat egunetik behin hartzen duzun: $minimo eta $maximo artean.';
  }

  @override
  String get formularioMedicamentoHorasTitulo => 'Zer ordutan hartzen duzu?';

  @override
  String get formularioMedicamentoHorasDescripcion =>
      'Aukeratu nola banatzen diren hartualdiak egunean zehar.';

  @override
  String get formularioMedicamentoRepartidas => 'Berdin banatuta';

  @override
  String get formularioMedicamentoRepartidasDescripcion =>
      'Ordu-tarte berdinarekin, lehen hartualditik hasita.';

  @override
  String get formularioMedicamentoConcretas => 'Ordu jakinetan';

  @override
  String get formularioMedicamentoConcretasDescripcion =>
      'Adibidez, gosariarekin, bazkariarekin eta afariarekin.';

  @override
  String formularioMedicamentoHoraToma(String numero) {
    return '$numero. hartualdia';
  }

  @override
  String get formularioMedicamentoHoraUnaToma => 'Hartualdiaren ordua';

  @override
  String get formularioMedicamentoHoraUnaTomaDescripcion =>
      'Zer ordutan hartzen duzu?';

  @override
  String get formularioMedicamentoDiasTitulo => 'Zer egunetan hartzen duzu?';

  @override
  String get formularioMedicamentoDiasDescripcion =>
      'Aukeratu egunero hartzen duzun ala egun batzuetan bakarrik.';

  @override
  String get formularioMedicamentoTodosLosDias => 'Egunero';

  @override
  String get formularioMedicamentoTodosLosDiasDescripcion =>
      'Egun guztietan, bat ere saltatu gabe.';

  @override
  String get formularioMedicamentoAlgunosDias => 'Asteko egun batzuetan';

  @override
  String get formularioMedicamentoAlgunosDiasDescripcion =>
      'Adibidez, astelehenetan hartzen den pilula bat.';

  @override
  String get formularioMedicamentoCadaVariosDias => 'Zenbait egunetik behin';

  @override
  String get formularioMedicamentoCadaVariosDiasDescripcion =>
      'Adibidez, egun batean bai eta hurrengoan ez.';

  @override
  String get formularioMedicamentoCadaCuantosDias => 'Zenbat egunetik behin';

  @override
  String formularioMedicamentoCadaDiasValor(String dias) {
    return '$dias egunetik behin';
  }

  @override
  String get formularioMedicamentoDiaMenos =>
      'Egun bat gutxiago hartualdien artean';

  @override
  String get formularioMedicamentoDiaMas =>
      'Egun bat gehiago hartualdien artean';

  @override
  String get formularioMedicamentoPrimerDia => 'Lehen eguna';

  @override
  String get formularioMedicamentoPrimerDiaDescripcion =>
      'Hartzen duzun lehen eguna.';

  @override
  String formularioMedicamentoAvisoDias(String dias, String horas) {
    return 'Abisatuko dizugu $dias: $horas.';
  }

  @override
  String formularioMedicamentoAvisoDiasHasta(
    String dias,
    String horas,
    String fecha,
  ) {
    return 'Abisatuko dizugu $dias: $horas. Azken eguna: $fecha.';
  }

  @override
  String get medicamentoSinFechaDeFinSolo => 'Amaiera-datarik gabe';

  @override
  String get medicamentoADemanda => 'Behar denean, abisurik gabe';

  @override
  String limitesMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'gehienez $n aldiz egunean',
      one: 'gehienez behin egunean',
    );
    return '$_temp0';
  }

  @override
  String limitesHoras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'gutxienez $n ordu bakoitzaren artean',
      one: 'gutxienez ordu 1 bakoitzaren artean',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoCuandoTitulo => 'Noiz hartzen duzu?';

  @override
  String get formularioMedicamentoCuandoDescripcion =>
      'Aukeratu ordutegi bat duen, ala behar duzunean bakarrik hartzen duzun.';

  @override
  String get formularioMedicamentoConHorario => 'Ordutegi batekin';

  @override
  String get formularioMedicamentoConHorarioDescripcion =>
      'Bere orduetan. Hartualdi bakoitzean abisatuko dizugu.';

  @override
  String get formularioMedicamentoADemanda => 'Behar denean bakarrik';

  @override
  String formularioMedicamentoADemandaDescripcion(String pantalla) {
    return 'Adibidez, mina kentzeko botika bat. Ez dago abisurik: hartzen duzunean, idatzi \"$pantalla\" pantailan.';
  }

  @override
  String get formularioMedicamentoLimitesTitulo =>
      'Zenbat har daitekeen (aukerakoa)';

  @override
  String get formularioMedicamentoLimitesDescripcion =>
      'Prospektuak edo zure medikuak esaten duena. Hartualdi bat idaztean gehiegi hartzen baduzu, aplikazioak abisatuko dizu.';

  @override
  String get formularioMedicamentoMaximoAlDia =>
      'Gehienez, egunean zenbat aldiz';

  @override
  String get formularioMedicamentoSinLimite => 'Mugarik gabe';

  @override
  String formularioMedicamentoVeces(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n aldiz',
      one: 'aldi 1',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoVezMenos => 'Aldi bat gutxiago egunean';

  @override
  String get formularioMedicamentoVezMas => 'Aldi bat gehiago egunean';

  @override
  String get formularioMedicamentoHorasEntreTomas =>
      'Hartualdi baten eta hurrengoaren arteko orduak, gutxienez';

  @override
  String get formularioMedicamentoSinMinimo => 'Gutxienekorik gabe';

  @override
  String formularioMedicamentoHorasValor(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ordu',
      one: 'ordu 1',
    );
    return '$_temp0';
  }

  @override
  String formularioMedicamentoAvisoADemanda(String pantalla) {
    return 'Abisurik gabe. Hartzen duzunean, idatzi \"$pantalla\" pantailan.';
  }

  @override
  String formularioMedicamentoAvisoADemandaHasta(
    String pantalla,
    String fecha,
  ) {
    return 'Abisurik gabe. \"$pantalla\" pantailan idatzi ahal izango duzu. Azken eguna: $fecha.';
  }

  @override
  String formularioMedicamentoResumenADemanda(String medicamento) {
    return '$medicamento: behar denean, abisurik gabe.';
  }

  @override
  String get tomasADemandaTitulo => 'Behar denean';

  @override
  String tomasADemandaExplicacion(String boton) {
    return 'Bat hartzen baduzu, sakatu \"$boton\" idazteko.';
  }

  @override
  String get tomasADemandaMarcar => 'Orain hartu dut';

  @override
  String tomasADemandaMarcarSemantica(String medicamento) {
    return 'Orain hartu dut: $medicamento';
  }

  @override
  String get tomasADemandaNingunaHoy => 'Gaur ez duzu hartu';

  @override
  String tomasADemandaMaximo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Gaur $n aldiz hartu duzu, eta ezin da gehiago',
      one: 'Gaur hartu duzu behin, eta ezin da gehiago',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaProximaHoy(String hora) {
    return 'Hurrengoa, ${hora}etatik aurrera';
  }

  @override
  String tomasADemandaProximaManana(String hora) {
    return 'Hurrengoa, bihar ${hora}etatik aurrera';
  }

  @override
  String get tomasADemandaAvisoTitulo => 'Har daitekeena baino gehiago da';

  @override
  String tomasADemandaAvisoMaximo(int n, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          'Gaur $n aldiz hartu duzu $medicamento, eta hori da eguneko gehienekoa.',
      one:
          'Gaur behin hartu duzu $medicamento, eta hori da eguneko gehienekoa.',
    );
    return '$_temp0';
  }

  @override
  String tomasADemandaAvisoPronto(int horas, String medicamento) {
    String _temp0 = intl.Intl.pluralLogic(
      horas,
      locale: localeName,
      other:
          '$medicamento hartualdi baten eta hurrengoaren artean gutxienez $horas ordu igaro behar dira.',
      one:
          '$medicamento hartualdi baten eta hurrengoaren artean gutxienez ordu 1 igaro behar da.',
    );
    return '$_temp0';
  }

  @override
  String get tomasADemandaAvisoConsejo =>
      'Zalantzarik baduzu, galdetu zure medikuari edo farmazialariari. Hala ere idatzi nahi duzu?';

  @override
  String get tomasADemandaAvisoSi => 'Bai, hartu dut';

  @override
  String get tomasADemandaAvisoNo => 'Ez, ez dut idatziko';

  @override
  String tomasADemandaHoy(int veces, String horas) {
    String _temp0 = intl.Intl.pluralLogic(
      veces,
      locale: localeName,
      other: 'Gaur $veces aldiz hartu duzu: $horas',
      one: 'Gaur hartu duzu: $horas',
    );
    return '$_temp0';
  }

  @override
  String historialADemanda(String hora, String medicamento) {
    return '$hora · $medicamento: behar zenean hartuta';
  }

  @override
  String get informeADemanda => 'Behar zenean:';

  @override
  String informeADemandaDia(String dia, String tomas) {
    return '$dia: $tomas.';
  }

  @override
  String informeADemandaTomas(String medicamento, String horas) {
    return '$medicamento ($horas)';
  }

  @override
  String get tomasADemandaQuitar => 'Azkena kendu';

  @override
  String tomasADemandaQuitarSemantica(String medicamento, String hora) {
    return 'Hartualdia kendu: $medicamento ($hora)';
  }

  @override
  String get formularioMedicamentoGuardar => 'Botika gorde';

  @override
  String existenciasQuedan(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad pilula geratzen dira',
      one: 'Pilula 1 geratzen da',
      zero: 'Ez da pilularik geratzen',
    );
    return '$_temp0';
  }

  @override
  String existenciasPastillas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilula',
      one: 'pilula 1',
    );
    return '$_temp0';
  }

  @override
  String existenciasPastillasYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilula eta erdi',
      one: 'pilula 1 eta erdi',
      zero: 'pilula erdi',
    );
    return '$_temp0';
  }

  @override
  String get existenciasMedia => 'erdia';

  @override
  String existenciasYMedia(String n) {
    return '$n eta erdi';
  }

  @override
  String existenciasQuedanYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilula eta erdi geratzen dira',
      one: 'Pilula 1 eta erdi geratzen da',
      zero: 'Pilula erdi geratzen da',
    );
    return '$_temp0';
  }

  @override
  String existenciasParaDias(int dias) {
    String _temp0 = intl.Intl.pluralLogic(
      dias,
      locale: localeName,
      other: '$dias egun ingururako',
      one: 'egun baterako',
    );
    return '$_temp0';
  }

  @override
  String get existenciasHastaElFinal => 'tratamendua amaitu arte nahikoa';

  @override
  String existenciasConDetalle(String quedan, String detalle) {
    return '$quedan, $detalle';
  }

  @override
  String get avisoExistenciasTitulo => 'Pilula gutxi geratzen zaizkizu';

  @override
  String get avisoRecetaTitulo => 'Berritu errezeta';

  @override
  String avisoRecetaCuerpo(String medicamento, String fecha) {
    return '$medicamento botikaren errezeta amaitu egingo da: $fecha. Eskatu hitzordua zure medikuari berritzeko.';
  }

  @override
  String avisoRecetaCuerpoHoy(String medicamento) {
    return '$medicamento botikaren errezeta gaur amaitzen da. Eskatu hitzordua zure medikuari berritzeko.';
  }

  @override
  String avisoRecetaCuerpoAcabada(String medicamento, String fecha) {
    return '$medicamento botikaren errezeta amaitu zen: $fecha. Eskatu hitzordua zure medikuari berritzeko.';
  }

  @override
  String avisoExistenciasSemana(String medicamento, String boton) {
    return '$medicamento: ez dago aste baterako adina. Gehiago erosten duzunean, sakatu \"$boton\" zure botiken zerrendan.';
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
          '$medicamento: $cantidad geratzen dira. Gehiago erosten duzunean, sakatu \"$boton\" zure botiken zerrendan.',
      one:
          '$medicamento: 1 geratzen da. Gehiago erosten duzunean, sakatu \"$boton\" zure botiken zerrendan.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasQuedanYMedia(int n, String medicamento, String boton) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$medicamento: $n eta erdi geratzen dira. Gehiago erosten duzunean, sakatu \"$boton\" zure botiken zerrendan.',
      one:
          '$medicamento: 1 eta erdi geratzen da. Gehiago erosten duzunean, sakatu \"$boton\" zure botiken zerrendan.',
      zero:
          '$medicamento: erdi bat geratzen da. Gehiago erosten duzunean, sakatu \"$boton\" zure botiken zerrendan.',
    );
    return '$_temp0';
  }

  @override
  String avisoExistenciasAcabadas(String medicamento, String boton) {
    return '$medicamento: ez da bat ere geratzen. Gehiago erosten duzunean, sakatu \"$boton\" zure botiken zerrendan.';
  }

  @override
  String medicamentoExistenciasPocas(String boton) {
    return 'Gutxi geratzen dira. Gehiago erosten duzunean, sakatu \"$boton\".';
  }

  @override
  String get medicamentoComprarMas => 'Gehiago erosi dut';

  @override
  String medicamentoComprarMasSemantica(String medicamento) {
    return 'Gehiago erosi dut: $medicamento';
  }

  @override
  String menuExistenciasPocas(String medicamentos) {
    return 'Pilula gutxi geratzen zaizkizu: $medicamentos.';
  }

  @override
  String menuRecetas(String medicamentos) {
    return 'Errezeta berritu behar da: $medicamentos.';
  }

  @override
  String get formularioMedicamentoExistenciasTitulo =>
      'Geratzen zaizkizun pilulak (aukerakoa)';

  @override
  String get formularioMedicamentoExistenciasDescripcion =>
      'Nahi baduzu, aplikazioak zenbatu egingo ditu, eta amaitu aurretik abisatuko dizu.';

  @override
  String get formularioMedicamentoSinCuenta => 'Kontua ez eraman';

  @override
  String get formularioMedicamentoSinCuentaDescripcion =>
      'Ez dizugu abisatuko zenbat geratzen diren.';

  @override
  String get formularioMedicamentoConCuenta => 'Kontua eraman';

  @override
  String get formularioMedicamentoConCuentaDescripcion =>
      'Hartualdi bakoitzean pilulak kontutik kentzen dira, eta gutxi geratzen direnean abisatuko dizugu.';

  @override
  String get formularioMedicamentoExistenciasCampo => 'Orain dituzun pilulak';

  @override
  String get formularioMedicamentoExistenciasCampoDescripcion =>
      'Zenbatu, edo jarri kaxakoak, hasi gabe badago. Erdi bat geratzen bada, idatzi adibidez 14,5. Kapsuletarako edo poltsatxoetarako ere balio du.';

  @override
  String get formularioMedicamentoPorToma => 'Pilulak hartualdi bakoitzean';

  @override
  String formularioMedicamentoPorTomaValor(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilula hartualdi bakoitzean',
      one: 'pilula 1 hartualdi bakoitzean',
    );
    return '$_temp0';
  }

  @override
  String formularioMedicamentoPorTomaYMedia(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilula eta erdi hartualdi bakoitzean',
      one: 'pilula 1 eta erdi hartualdi bakoitzean',
      zero: 'pilula erdi hartualdi bakoitzean',
    );
    return '$_temp0';
  }

  @override
  String get formularioMedicamentoPorTomaMenos =>
      'Pilula erdi gutxiago hartualdi bakoitzean';

  @override
  String get formularioMedicamentoPorTomaMas =>
      'Pilula erdi gehiago hartualdi bakoitzean';

  @override
  String formularioMedicamentoPorTomaDeLas(String hora) {
    return '${hora}etako hartualdiko pilulak';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMenos(String hora) {
    return 'Pilula erdi gutxiago ${hora}etan';
  }

  @override
  String formularioMedicamentoPorTomaDeLasMas(String hora) {
    return 'Pilula erdi gehiago ${hora}etan';
  }

  @override
  String validadorMedicamentoExistencias(String maximo) {
    return 'Idatzi zenbat pilula dituzun: 0 eta $maximo arteko zenbaki bat. Erdi bat badago, komarekin: 14,5.';
  }

  @override
  String get comprarCampo => 'Zenbat erosi dituzu?';

  @override
  String get comprarCampoDescripcion =>
      'Begiratu zenbat dakartzan kaxak; adibidez, 28.';

  @override
  String comprarTendras(String pastillas) {
    return 'Guztira: $pastillas.';
  }

  @override
  String get comprarAnadir => 'Ditudanei gehitu';

  @override
  String comprarError(String maximo) {
    return 'Idatzi zenbat erosi dituzun: 1 eta $maximo arteko zenbaki bat.';
  }

  @override
  String get comprarHechoTitulo => 'Pilulak gehituta';

  @override
  String get recetaTitulo => 'Errezeta berrituta';

  @override
  String get recetaPregunta => 'Zein egunera arte da errezeta berria?';

  @override
  String get recetaGuardar => 'Gorde data berria';

  @override
  String get recetaQuitar => 'Ez da gehiago berritu behar';

  @override
  String get recetaQuitarDescripcion =>
      'Data kentzen du: ez dizugu errezeta honetaz gehiago abisatuko.';

  @override
  String recetaGuardada(String medicamento, String fecha) {
    return '$medicamento botikaren errezeta: $fecha arte.';
  }

  @override
  String recetaQuitada(String medicamento) {
    return 'Ez dizugu gehiago abisatuko $medicamento botikaren errezetaz.';
  }

  @override
  String comprarHecho(String pastillas, String medicamento) {
    return '$medicamento: orain, guztira, $pastillas.';
  }

  @override
  String get compartirDeOtroMovil =>
      'Beste mugikor batean prestatutako botikak';

  @override
  String compartirDeOtroMovilExplicacion(String boton) {
    return 'Senide batek zure botikak eta hitzorduak idatz ditzake bere telefonoan, aplikazio honekin bertan, eta zuri bidali \"$boton\" botoiarekin. Hemen gehitzen dituzu, lehendik duzunetik ezer ezabatu gabe.';
  }

  @override
  String get compartirImportar => 'Beste mugikor bateko botikak gehitu';

  @override
  String get compartirImportarDescripcion =>
      'Aukeratu bidali dizuten kopia. Aurretik, zer gehituko duen esango dizu.';

  @override
  String get importarNoSePuede => 'Ezin dira fitxategi honetako botikak gehitu';

  @override
  String get importarPregunta => 'Kopia honek dakarrena gehitu?';

  @override
  String importarCopiaDel(String fecha, String hora) {
    return 'Kopiaren data: $fecha, $hora.';
  }

  @override
  String importarSeAnadiran(String medicamentos) {
    return 'Hauek gehituko dira: $medicamentos.';
  }

  @override
  String importarSeActualizaran(int cuantos, String medicamentos) {
    String _temp0 = intl.Intl.pluralLogic(
      cuantos,
      locale: localeName,
      other:
          'Lehendik zenituen: $medicamentos. Kopian bezala jarriko dira, idatzitako hartualdiak galdu gabe.',
      one:
          'Lehendik zenuen: $medicamentos. Kopian bezala jarriko da, idatzitako hartualdiak galdu gabe.',
    );
    return '$_temp0';
  }

  @override
  String importarCitas(String citas) {
    return 'Hitzordu berriak: $citas.';
  }

  @override
  String get importarNoSeBorra =>
      'Ez da ezer ezabatzen: idatzitako hartualdiak eta ezarpenak dauden bezala geratzen dira.';

  @override
  String get importarSi => 'Bai, gehitu';

  @override
  String get importarNadaNuevo => 'Ez dago ezer gehitzeko';

  @override
  String get importarNadaNuevoMensaje =>
      'Kopia honek ez dakar zuk ez duzun botikarik edo hitzordurik.';

  @override
  String get importarHecho => 'Botikak gehituta';

  @override
  String get importarError => 'Ezin izan dira botikak gehitu. Saiatu berriro.';

  @override
  String historialResumenSemana(
    String tomadas,
    String total,
    String porcentaje,
  ) {
    return 'Azken 7 egunetako hartualdiak: $tomadas markatuta, guztira $total (% $porcentaje).';
  }

  @override
  String informeResumenSemana(String tomadas, String total, String porcentaje) {
    return 'Markatuta: $tomadas, guztira $total hartualdi (% $porcentaje).';
  }

  @override
  String get compartirRecordarResumen => 'Astero bidaltzeko gogorarazi';

  @override
  String get compartirRecordarResumenDescripcion =>
      'Igandeetan 18:00etan abisatuko dizugu, zure medikazioa eta hartualdiak bidaltzeko.';

  @override
  String get avisoResumenTitulo => 'Laburpena familiari bidaliko diozu?';

  @override
  String avisoResumenCuerpo(String boton) {
    return 'Ukitu hemen eta sakatu \"$boton\", zure medikazioa eta asteko hartualdiak bidaltzeko.';
  }

  @override
  String get widgetTitulo => 'Hurrengo hartualdia';

  @override
  String get widgetVacio => 'Ez dago hartualdi gehiago aurreikusita.';

  @override
  String get ajustesWidget => 'Hurrengo hartualdia hasierako pantailan jarri';

  @override
  String ajustesWidgetDescripcion(String boton) {
    return 'Laukitxo bat hurrengo hartualdiarekin eta \"$boton\" botoiarekin, aplikazioa ireki gabe.';
  }

  @override
  String ajustesWidgetManual(String app) {
    return 'Eduki sakatuta telefonoaren hasierako pantailako leku huts bat, ukitu \"Widgetak\" eta bilatu \"$app\".';
  }
}
