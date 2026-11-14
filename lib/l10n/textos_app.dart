import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'textos_app_ca.dart';
import 'textos_app_es.dart';
import 'textos_app_eu.dart';
import 'textos_app_gl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of TextosApp
/// returned by `TextosApp.of(context)`.
///
/// Applications need to include `TextosApp.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/textos_app.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TextosApp.localizationsDelegates,
///   supportedLocales: TextosApp.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TextosApp.supportedLocales
/// property.
abstract class TextosApp {
  TextosApp(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TextosApp of(BuildContext context) {
    return Localizations.of<TextosApp>(context, TextosApp)!;
  }

  static const LocalizationsDelegate<TextosApp> delegate = _TextosAppDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('ca'),
    Locale('eu'),
    Locale('gl'),
  ];

  /// No description provided for @fechaLunes.
  ///
  /// In es, this message translates to:
  /// **'lunes'**
  String get fechaLunes;

  /// No description provided for @fechaMartes.
  ///
  /// In es, this message translates to:
  /// **'martes'**
  String get fechaMartes;

  /// No description provided for @fechaMiercoles.
  ///
  /// In es, this message translates to:
  /// **'miércoles'**
  String get fechaMiercoles;

  /// No description provided for @fechaJueves.
  ///
  /// In es, this message translates to:
  /// **'jueves'**
  String get fechaJueves;

  /// No description provided for @fechaViernes.
  ///
  /// In es, this message translates to:
  /// **'viernes'**
  String get fechaViernes;

  /// No description provided for @fechaSabado.
  ///
  /// In es, this message translates to:
  /// **'sábado'**
  String get fechaSabado;

  /// No description provided for @fechaDomingo.
  ///
  /// In es, this message translates to:
  /// **'domingo'**
  String get fechaDomingo;

  /// No description provided for @fechaEnero.
  ///
  /// In es, this message translates to:
  /// **'enero'**
  String get fechaEnero;

  /// No description provided for @fechaFebrero.
  ///
  /// In es, this message translates to:
  /// **'febrero'**
  String get fechaFebrero;

  /// No description provided for @fechaMarzo.
  ///
  /// In es, this message translates to:
  /// **'marzo'**
  String get fechaMarzo;

  /// No description provided for @fechaAbril.
  ///
  /// In es, this message translates to:
  /// **'abril'**
  String get fechaAbril;

  /// No description provided for @fechaMayo.
  ///
  /// In es, this message translates to:
  /// **'mayo'**
  String get fechaMayo;

  /// No description provided for @fechaJunio.
  ///
  /// In es, this message translates to:
  /// **'junio'**
  String get fechaJunio;

  /// No description provided for @fechaJulio.
  ///
  /// In es, this message translates to:
  /// **'julio'**
  String get fechaJulio;

  /// No description provided for @fechaAgosto.
  ///
  /// In es, this message translates to:
  /// **'agosto'**
  String get fechaAgosto;

  /// No description provided for @fechaSeptiembre.
  ///
  /// In es, this message translates to:
  /// **'septiembre'**
  String get fechaSeptiembre;

  /// No description provided for @fechaOctubre.
  ///
  /// In es, this message translates to:
  /// **'octubre'**
  String get fechaOctubre;

  /// No description provided for @fechaNoviembre.
  ///
  /// In es, this message translates to:
  /// **'noviembre'**
  String get fechaNoviembre;

  /// No description provided for @fechaDiciembre.
  ///
  /// In es, this message translates to:
  /// **'diciembre'**
  String get fechaDiciembre;

  /// Fecha completa, por ejemplo: domingo, 25 de octubre de 2026.
  ///
  /// In es, this message translates to:
  /// **'{diaSemana}, {dia} de {mes} de {anio}'**
  String fechaLarga(String diaSemana, String dia, String mes, String anio);

  /// No description provided for @fechaHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy, {fecha}'**
  String fechaHoy(String fecha);

  /// No description provided for @fechaManana.
  ///
  /// In es, this message translates to:
  /// **'Mañana, {fecha}'**
  String fechaManana(String fecha);

  /// No description provided for @fechaAyer.
  ///
  /// In es, this message translates to:
  /// **'Ayer, {fecha}'**
  String fechaAyer(String fecha);

  /// No description provided for @fechaCuandoHoy.
  ///
  /// In es, this message translates to:
  /// **'hoy a las {hora}'**
  String fechaCuandoHoy(String hora);

  /// No description provided for @fechaCuandoManana.
  ///
  /// In es, this message translates to:
  /// **'mañana a las {hora}'**
  String fechaCuandoManana(String hora);

  /// Cuándo ocurre algo otro día, por ejemplo: el martes, 27 de octubre, a las 10:30.
  ///
  /// In es, this message translates to:
  /// **'el {diaSemana}, {dia} de {mes}, a las {hora}'**
  String fechaCuandoOtroDia(
    String diaSemana,
    String dia,
    String mes,
    String hora,
  );

  /// No description provided for @fechaDeLaMadrugada.
  ///
  /// In es, this message translates to:
  /// **'de la madrugada'**
  String get fechaDeLaMadrugada;

  /// No description provided for @fechaDeLaManana.
  ///
  /// In es, this message translates to:
  /// **'de la mañana'**
  String get fechaDeLaManana;

  /// No description provided for @fechaDelMediodia.
  ///
  /// In es, this message translates to:
  /// **'del mediodía'**
  String get fechaDelMediodia;

  /// No description provided for @fechaDeLaTarde.
  ///
  /// In es, this message translates to:
  /// **'de la tarde'**
  String get fechaDeLaTarde;

  /// No description provided for @fechaDeLaNoche.
  ///
  /// In es, this message translates to:
  /// **'de la noche'**
  String get fechaDeLaNoche;

  /// Por ejemplo: 08:30 de la mañana.
  ///
  /// In es, this message translates to:
  /// **'{hora} {parteDelDia}'**
  String fechaHoraConParteDelDia(String hora, String parteDelDia);

  /// Une el último elemento de una lista: «08:00, 16:00 y 00:00».
  ///
  /// In es, this message translates to:
  /// **'{anteriores} y {ultimo}'**
  String fechaListaUltimo(String anteriores, String ultimo);

  /// No description provided for @fechaSeparadorLista.
  ///
  /// In es, this message translates to:
  /// **', '**
  String get fechaSeparadorLista;

  /// No description provided for @appTitulo.
  ///
  /// In es, this message translates to:
  /// **'Salud y Medicación'**
  String get appTitulo;

  /// No description provided for @avisoDeshecho.
  ///
  /// In es, this message translates to:
  /// **'Hecho. Se ha deshecho la acción.'**
  String get avisoDeshecho;

  /// No description provided for @avisoNoSeHaPodidoDeshacer.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido deshacer. Inténtalo otra vez.'**
  String get avisoNoSeHaPodidoDeshacer;

  /// No description provided for @botonDeshacer.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get botonDeshacer;

  /// Lo que TalkBack dice del botón «Deshacer» cuando no hay una explicación más concreta.
  ///
  /// In es, this message translates to:
  /// **'Deshace lo que acabas de hacer'**
  String get botonDeshacerPista;

  /// No description provided for @botonDeshacerPistaEliminar.
  ///
  /// In es, this message translates to:
  /// **'Recupera lo que acabas de eliminar'**
  String get botonDeshacerPistaEliminar;

  /// No description provided for @barraInicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get barraInicio;

  /// No description provided for @barraAtras.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get barraAtras;

  /// No description provided for @barraInicioSemantica.
  ///
  /// In es, this message translates to:
  /// **'Inicio. Volver al menú principal'**
  String get barraInicioSemantica;

  /// No description provided for @barraAtrasSemantica.
  ///
  /// In es, this message translates to:
  /// **'Atrás. Volver a la pantalla anterior'**
  String get barraAtrasSemantica;

  /// No description provided for @interruptorActivado.
  ///
  /// In es, this message translates to:
  /// **'Activado'**
  String get interruptorActivado;

  /// No description provided for @interruptorDesactivado.
  ///
  /// In es, this message translates to:
  /// **'Desactivado'**
  String get interruptorDesactivado;

  /// Lo que lee TalkBack en un selector + / −, por ejemplo «Tomas al día: 2 tomas».
  ///
  /// In es, this message translates to:
  /// **'{etiqueta}: {valor}'**
  String selectorValor(String etiqueta, String valor);

  /// No description provided for @cargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get cargando;

  /// No description provided for @mensajeError.
  ///
  /// In es, this message translates to:
  /// **'Error: {texto}'**
  String mensajeError(String texto);

  /// No description provided for @dialogoSiEliminar.
  ///
  /// In es, this message translates to:
  /// **'Sí, eliminar'**
  String get dialogoSiEliminar;

  /// No description provided for @dialogoNoVolver.
  ///
  /// In es, this message translates to:
  /// **'No, volver'**
  String get dialogoNoVolver;

  /// No description provided for @dialogoAceptar.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get dialogoAceptar;

  /// No description provided for @dialogoEntendido.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get dialogoEntendido;

  /// No description provided for @dialogoAhoraNo.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get dialogoAhoraNo;

  /// No description provided for @selectorHoraElegida.
  ///
  /// In es, this message translates to:
  /// **'Hora elegida: {hora}'**
  String selectorHoraElegida(String hora);

  /// No description provided for @selectorHora.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get selectorHora;

  /// No description provided for @selectorHoraValor.
  ///
  /// In es, this message translates to:
  /// **'{hora} horas'**
  String selectorHoraValor(String hora);

  /// No description provided for @selectorRestarHora.
  ///
  /// In es, this message translates to:
  /// **'Restar una hora'**
  String get selectorRestarHora;

  /// No description provided for @selectorSumarHora.
  ///
  /// In es, this message translates to:
  /// **'Sumar una hora'**
  String get selectorSumarHora;

  /// No description provided for @selectorMinutos.
  ///
  /// In es, this message translates to:
  /// **'Minutos'**
  String get selectorMinutos;

  /// No description provided for @selectorMinutosValor.
  ///
  /// In es, this message translates to:
  /// **'{minutos} minutos'**
  String selectorMinutosValor(String minutos);

  /// No description provided for @selectorRestarMinutos.
  ///
  /// In es, this message translates to:
  /// **'Restar {minutos} minutos'**
  String selectorRestarMinutos(String minutos);

  /// No description provided for @selectorSumarMinutos.
  ///
  /// In es, this message translates to:
  /// **'Sumar {minutos} minutos'**
  String selectorSumarMinutos(String minutos);

  /// No description provided for @selectorAtajoHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get selectorAtajoHoy;

  /// No description provided for @selectorAtajoManana.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get selectorAtajoManana;

  /// No description provided for @selectorAtajoEnUnaSemana.
  ///
  /// In es, this message translates to:
  /// **'En una semana'**
  String get selectorAtajoEnUnaSemana;

  /// No description provided for @selectorDiaElegido.
  ///
  /// In es, this message translates to:
  /// **'Día elegido: {fecha}'**
  String selectorDiaElegido(String fecha);

  /// No description provided for @selectorDia.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get selectorDia;

  /// No description provided for @selectorDiaAnterior.
  ///
  /// In es, this message translates to:
  /// **'Día anterior'**
  String get selectorDiaAnterior;

  /// No description provided for @selectorDiaSiguiente.
  ///
  /// In es, this message translates to:
  /// **'Día siguiente'**
  String get selectorDiaSiguiente;

  /// No description provided for @selectorMes.
  ///
  /// In es, this message translates to:
  /// **'Mes'**
  String get selectorMes;

  /// No description provided for @selectorMesAnterior.
  ///
  /// In es, this message translates to:
  /// **'Mes anterior'**
  String get selectorMesAnterior;

  /// No description provided for @selectorMesSiguiente.
  ///
  /// In es, this message translates to:
  /// **'Mes siguiente'**
  String get selectorMesSiguiente;

  /// No description provided for @selectorAnio.
  ///
  /// In es, this message translates to:
  /// **'Año'**
  String get selectorAnio;

  /// No description provided for @selectorAnioAnterior.
  ///
  /// In es, this message translates to:
  /// **'Año anterior'**
  String get selectorAnioAnterior;

  /// No description provided for @selectorAnioSiguiente.
  ///
  /// In es, this message translates to:
  /// **'Año siguiente'**
  String get selectorAnioSiguiente;

  /// Lo que lee TalkBack en los atajos de fecha, por ejemplo «Elegir: Mañana».
  ///
  /// In es, this message translates to:
  /// **'Elegir: {texto}'**
  String selectorElegir(String texto);

  /// No description provided for @menuTitulo.
  ///
  /// In es, this message translates to:
  /// **'Menú principal'**
  String get menuTitulo;

  /// No description provided for @menuPregunta.
  ///
  /// In es, this message translates to:
  /// **'¿Qué quieres hacer?'**
  String get menuPregunta;

  /// No description provided for @menuMedicamentos.
  ///
  /// In es, this message translates to:
  /// **'Registro de medicamentos'**
  String get menuMedicamentos;

  /// No description provided for @menuAgenda.
  ///
  /// In es, this message translates to:
  /// **'Agenda'**
  String get menuAgenda;

  /// No description provided for @menuEmergencias.
  ///
  /// In es, this message translates to:
  /// **'Botón de emergencias'**
  String get menuEmergencias;

  /// No description provided for @menuAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get menuAjustes;

  /// No description provided for @menuTomasDeHoy.
  ///
  /// In es, this message translates to:
  /// **'Tomas de hoy: {tomadas} de {total} marcadas.'**
  String menuTomasDeHoy(String tomadas, String total);

  /// Por ejemplo: «Próxima toma: Paracetamol, hoy a las 16:00.»
  ///
  /// In es, this message translates to:
  /// **'Próxima toma: {medicamento}, {cuando}.'**
  String menuProximaToma(String medicamento, String cuando);

  /// Por ejemplo: «Próxima cita: Dentista, el martes, 27 de octubre, a las 10:30.»
  ///
  /// In es, this message translates to:
  /// **'Próxima cita: {cita}, {cuando}.'**
  String menuProximaCita(String cita, String cuando);

  /// No description provided for @tomasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tomas de hoy'**
  String get tomasTitulo;

  /// No description provided for @medicamentosMenuTomasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Marca las medicinas que ya has tomado hoy.'**
  String get medicamentosMenuTomasDescripcion;

  /// No description provided for @medicamentosMenuNuevo.
  ///
  /// In es, this message translates to:
  /// **'Registrar nuevo medicamento'**
  String get medicamentosMenuNuevo;

  /// No description provided for @medicamentosMenuNuevoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Apunta una medicina y te avisaremos cuando tengas que tomarla.'**
  String get medicamentosMenuNuevoDescripcion;

  /// No description provided for @medicamentosMenuVer.
  ///
  /// In es, this message translates to:
  /// **'Ver medicamentos registrados'**
  String get medicamentosMenuVer;

  /// No description provided for @medicamentosMenuVerDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Consulta tus medicinas y sus horas, cámbialas o borra las que ya no tomes.'**
  String get medicamentosMenuVerDescripcion;

  /// No description provided for @historialTitulo.
  ///
  /// In es, this message translates to:
  /// **'Historial de tomas'**
  String get historialTitulo;

  /// No description provided for @medicamentosMenuHistorialDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Mira qué tomas marcaste en los últimos 7 días.'**
  String get medicamentosMenuHistorialDescripcion;

  /// No description provided for @medicamentosMenuCompartir.
  ///
  /// In es, this message translates to:
  /// **'Compartir con el médico o la familia'**
  String get medicamentosMenuCompartir;

  /// No description provided for @medicamentosMenuCompartirDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Envía o imprime tus medicinas, tus tomas y tus citas.'**
  String get medicamentosMenuCompartirDescripcion;

  /// No description provided for @listaMedicamentosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos registrados'**
  String get listaMedicamentosTitulo;

  /// No description provided for @listaMedicamentosPreguntaEliminar.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar este medicamento?'**
  String get listaMedicamentosPreguntaEliminar;

  /// No description provided for @listaMedicamentosDetalleEliminar.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}\n\nTambién se borrarán sus avisos.'**
  String listaMedicamentosDetalleEliminar(String medicamento);

  /// No description provided for @listaMedicamentosErrorEliminar.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido eliminar el medicamento. Inténtalo otra vez.'**
  String get listaMedicamentosErrorEliminar;

  /// No description provided for @listaMedicamentosEliminado.
  ///
  /// In es, this message translates to:
  /// **'Medicamento eliminado: {medicamento}'**
  String listaMedicamentosEliminado(String medicamento);

  /// No description provided for @listaMedicamentosRecuperado.
  ///
  /// In es, this message translates to:
  /// **'Medicamento recuperado: {medicamento}'**
  String listaMedicamentosRecuperado(String medicamento);

  /// No description provided for @listaMedicamentosVacio.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has registrado ningún medicamento'**
  String get listaMedicamentosVacio;

  /// No description provided for @listaMedicamentosVacioExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Cuando registres uno, aparecerá aquí con sus horas de toma.'**
  String get listaMedicamentosVacioExplicacion;

  /// No description provided for @listaMedicamentosCuantos.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{Tienes 1 medicamento registrado.} other{Tienes {cantidad} medicamentos registrados.}}'**
  String listaMedicamentosCuantos(int cantidad);

  /// No description provided for @medicamentoSinFechaDeFin.
  ///
  /// In es, this message translates to:
  /// **'Cada día, sin fecha de fin'**
  String get medicamentoSinFechaDeFin;

  /// No description provided for @medicamentoTerminadoEl.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento terminado el {fecha}'**
  String medicamentoTerminadoEl(String fecha);

  /// Por ejemplo: «Receta: hasta el lunes, 2 de noviembre de 2026».
  ///
  /// In es, this message translates to:
  /// **'Receta: hasta el {fecha}'**
  String medicamentoRecetaHasta(String fecha);

  /// No description provided for @medicamentoRecetaPronto.
  ///
  /// In es, this message translates to:
  /// **'{dias, plural, =0{La receta se acaba hoy: pide cita con tu médico para renovarla} =1{La receta se acaba mañana: pide cita con tu médico para renovarla} other{La receta se acaba dentro de {dias} días: pide cita con tu médico para renovarla}}'**
  String medicamentoRecetaPronto(int dias);

  /// No description provided for @medicamentoRecetaAcabada.
  ///
  /// In es, this message translates to:
  /// **'La receta se acabó el {fecha}: pide cita con tu médico para renovarla'**
  String medicamentoRecetaAcabada(String fecha);

  /// Botón de la tarjeta del medicamento cuando hay que renovar la receta.
  ///
  /// In es, this message translates to:
  /// **'Ya la he renovado'**
  String get medicamentoRecetaRenovada;

  /// No description provided for @medicamentoRecetaRenovadaSemantica.
  ///
  /// In es, this message translates to:
  /// **'Ya he renovado la receta de {medicamento}'**
  String medicamentoRecetaRenovadaSemantica(String medicamento);

  /// No description provided for @medicamentoHastaEl.
  ///
  /// In es, this message translates to:
  /// **'Hasta el {fecha}, incluido'**
  String medicamentoHastaEl(String fecha);

  /// No description provided for @medicamentoDosis.
  ///
  /// In es, this message translates to:
  /// **'Dosis: {dosis}'**
  String medicamentoDosis(String dosis);

  /// Parte de «Dosis: 1 pastilla a las 08:00 y media pastilla a las 21:00».
  ///
  /// In es, this message translates to:
  /// **'{dosis} a las {hora}'**
  String medicamentoDosisALas(String dosis, String hora);

  /// No description provided for @medicamentoHoras.
  ///
  /// In es, this message translates to:
  /// **'Horas: {horas}'**
  String medicamentoHoras(String horas);

  /// No description provided for @botonModificar.
  ///
  /// In es, this message translates to:
  /// **'Modificar'**
  String get botonModificar;

  /// No description provided for @botonModificarSemantica.
  ///
  /// In es, this message translates to:
  /// **'Modificar {nombre}'**
  String botonModificarSemantica(String nombre);

  /// No description provided for @botonEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get botonEliminar;

  /// No description provided for @botonEliminarSemantica.
  ///
  /// In es, this message translates to:
  /// **'Eliminar {nombre}'**
  String botonEliminarSemantica(String nombre);

  /// No description provided for @formularioMedicamentoTituloNuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo medicamento'**
  String get formularioMedicamentoTituloNuevo;

  /// No description provided for @formularioMedicamentoTituloModificar.
  ///
  /// In es, this message translates to:
  /// **'Modificar medicamento'**
  String get formularioMedicamentoTituloModificar;

  /// No description provided for @formularioMedicamentoCrear.
  ///
  /// In es, this message translates to:
  /// **'Crear recordatorio'**
  String get formularioMedicamentoCrear;

  /// No description provided for @formularioGuardarCambios.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get formularioGuardarCambios;

  /// No description provided for @formularioMedicamentoGuardado.
  ///
  /// In es, this message translates to:
  /// **'Medicamento guardado correctamente'**
  String get formularioMedicamentoGuardado;

  /// No description provided for @formularioCambiosGuardados.
  ///
  /// In es, this message translates to:
  /// **'Cambios guardados correctamente'**
  String get formularioCambiosGuardados;

  /// No description provided for @formularioFotoAnadida.
  ///
  /// In es, this message translates to:
  /// **'Foto añadida. Se guardará al pulsar \"{boton}\".'**
  String formularioFotoAnadida(String boton);

  /// No description provided for @formularioErrorFotoCamara.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido hacer la foto. Inténtalo otra vez.'**
  String get formularioErrorFotoCamara;

  /// No description provided for @formularioErrorFotoGaleria.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido abrir la galería. Inténtalo otra vez.'**
  String get formularioErrorFotoGaleria;

  /// No description provided for @formularioFotoQuitada.
  ///
  /// In es, this message translates to:
  /// **'Foto quitada. El cambio se guardará al pulsar \"{boton}\".'**
  String formularioFotoQuitada(String boton);

  /// No description provided for @formularioMedicamentoErrorGuardar.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido guardar el medicamento. Inténtalo otra vez.'**
  String get formularioMedicamentoErrorGuardar;

  /// Por ejemplo: «Paracetamol: 3 tomas al día, cada 8 horas.» y, en otra línea, «Horas de toma: 08:00, 16:00 y 00:00.»
  ///
  /// In es, this message translates to:
  /// **'{medicamento}: {tomas}.\nHoras de toma: {horas}.'**
  String formularioMedicamentoResumenGuardado(
    String medicamento,
    String tomas,
    String horas,
  );

  /// No description provided for @formularioMedicamentoUltimoDia.
  ///
  /// In es, this message translates to:
  /// **'Último día: {fecha}.'**
  String formularioMedicamentoUltimoDia(String fecha);

  /// No description provided for @avisosDesactivadosEnAjustes.
  ///
  /// In es, this message translates to:
  /// **'Los avisos están desactivados. Puedes activarlos en Ajustes.'**
  String get avisosDesactivadosEnAjustes;

  /// No description provided for @formularioMedicamentoAvisoCadaDia.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos cada día a las {horas}.'**
  String formularioMedicamentoAvisoCadaDia(String horas);

  /// No description provided for @formularioMedicamentoAvisoHasta.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos a las {horas} hasta el {fecha}, incluido.'**
  String formularioMedicamentoAvisoHasta(String horas, String fecha);

  /// No description provided for @formularioGuardando.
  ///
  /// In es, this message translates to:
  /// **'Guardando…'**
  String get formularioGuardando;

  /// No description provided for @formularioRellenaYPulsa.
  ///
  /// In es, this message translates to:
  /// **'Rellena los datos y pulsa \"{boton}\".'**
  String formularioRellenaYPulsa(String boton);

  /// No description provided for @formularioMedicamentoNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre del medicamento'**
  String get formularioMedicamentoNombre;

  /// No description provided for @formularioMedicamentoNombreDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: Paracetamol.'**
  String get formularioMedicamentoNombreDescripcion;

  /// No description provided for @formularioMedicamentoDictarNombre.
  ///
  /// In es, this message translates to:
  /// **'Dictar el nombre'**
  String get formularioMedicamentoDictarNombre;

  /// No description provided for @formularioMedicamentoDictarNombreIndicacion.
  ///
  /// In es, this message translates to:
  /// **'Di el nombre del medicamento'**
  String get formularioMedicamentoDictarNombreIndicacion;

  /// No description provided for @formularioMedicamentoDosis.
  ///
  /// In es, this message translates to:
  /// **'Dosis (opcional)'**
  String get formularioMedicamentoDosis;

  /// No description provided for @formularioMedicamentoDosisDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cuánto tomas cada vez. Por ejemplo: 1 pastilla.'**
  String get formularioMedicamentoDosisDescripcion;

  /// No description provided for @formularioMedicamentoDosisEnCadaToma.
  ///
  /// In es, this message translates to:
  /// **'La dosis cambia según la hora: la de cada toma está más abajo, en \"{seccion}\".'**
  String formularioMedicamentoDosisEnCadaToma(String seccion);

  /// No description provided for @formularioMedicamentoDosisTomasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Dosis en cada toma'**
  String get formularioMedicamentoDosisTomasTitulo;

  /// No description provided for @formularioMedicamentoDosisTomasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Si cambia según la hora; por ejemplo, una pastilla por la mañana y media por la noche.'**
  String get formularioMedicamentoDosisTomasDescripcion;

  /// No description provided for @formularioMedicamentoDosisIgual.
  ///
  /// In es, this message translates to:
  /// **'La misma en todas'**
  String get formularioMedicamentoDosisIgual;

  /// No description provided for @formularioMedicamentoDosisIgualDescripcion.
  ///
  /// In es, this message translates to:
  /// **'La de arriba, en el campo de la dosis.'**
  String get formularioMedicamentoDosisIgualDescripcion;

  /// No description provided for @formularioMedicamentoDosisDistinta.
  ///
  /// In es, this message translates to:
  /// **'Distinta según la hora'**
  String get formularioMedicamentoDosisDistinta;

  /// No description provided for @formularioMedicamentoDosisDistintaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Escribe abajo la de cada toma.'**
  String get formularioMedicamentoDosisDistintaDescripcion;

  /// No description provided for @formularioMedicamentoDosisDeLas.
  ///
  /// In es, this message translates to:
  /// **'Dosis de las {hora}'**
  String formularioMedicamentoDosisDeLas(String hora);

  /// No description provided for @formularioMedicamentoInstrucciones.
  ///
  /// In es, this message translates to:
  /// **'Instrucciones (opcional)'**
  String get formularioMedicamentoInstrucciones;

  /// No description provided for @formularioMedicamentoInstruccionesDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: con el desayuno.'**
  String get formularioMedicamentoInstruccionesDescripcion;

  /// No description provided for @formularioMedicamentoFoto.
  ///
  /// In es, this message translates to:
  /// **'Foto de la caja (opcional)'**
  String get formularioMedicamentoFoto;

  /// No description provided for @formularioMedicamentoFotoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Así reconocerás el medicamento de un vistazo.'**
  String get formularioMedicamentoFotoDescripcion;

  /// No description provided for @formularioMedicamentoHacerFoto.
  ///
  /// In es, this message translates to:
  /// **'Hacer una foto'**
  String get formularioMedicamentoHacerFoto;

  /// No description provided for @formularioMedicamentoHacerOtraFoto.
  ///
  /// In es, this message translates to:
  /// **'Hacer otra foto'**
  String get formularioMedicamentoHacerOtraFoto;

  /// No description provided for @formularioMedicamentoHacerFotoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Con la cámara del teléfono.'**
  String get formularioMedicamentoHacerFotoDescripcion;

  /// No description provided for @formularioMedicamentoElegirGaleria.
  ///
  /// In es, this message translates to:
  /// **'Elegir de la galería'**
  String get formularioMedicamentoElegirGaleria;

  /// No description provided for @formularioMedicamentoElegirOtraGaleria.
  ///
  /// In es, this message translates to:
  /// **'Elegir otra de la galería'**
  String get formularioMedicamentoElegirOtraGaleria;

  /// No description provided for @formularioMedicamentoGaleriaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Una foto que ya tengas en el teléfono.'**
  String get formularioMedicamentoGaleriaDescripcion;

  /// No description provided for @formularioMedicamentoQuitarFoto.
  ///
  /// In es, this message translates to:
  /// **'Quitar la foto'**
  String get formularioMedicamentoQuitarFoto;

  /// No description provided for @formularioMedicamentoNumeroTomas.
  ///
  /// In es, this message translates to:
  /// **'Número de tomas al día'**
  String get formularioMedicamentoNumeroTomas;

  /// No description provided for @formularioMedicamentoNumeroTomasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas veces al día lo tomas?'**
  String get formularioMedicamentoNumeroTomasDescripcion;

  /// No description provided for @formularioMedicamentoTomasAlDia.
  ///
  /// In es, this message translates to:
  /// **'Tomas al día'**
  String get formularioMedicamentoTomasAlDia;

  /// No description provided for @formularioMedicamentoTomasValor.
  ///
  /// In es, this message translates to:
  /// **'{tomas, plural, =1{1 toma} other{{tomas} tomas}}'**
  String formularioMedicamentoTomasValor(int tomas);

  /// No description provided for @formularioMedicamentoTomaMenos.
  ///
  /// In es, this message translates to:
  /// **'Una toma menos'**
  String get formularioMedicamentoTomaMenos;

  /// No description provided for @formularioMedicamentoTomaMas.
  ///
  /// In es, this message translates to:
  /// **'Una toma más'**
  String get formularioMedicamentoTomaMas;

  /// No description provided for @formularioMedicamentoCadaCuantasHoras.
  ///
  /// In es, this message translates to:
  /// **'Cada cuántas horas'**
  String get formularioMedicamentoCadaCuantasHoras;

  /// No description provided for @formularioMedicamentoCadaHorasCorto.
  ///
  /// In es, this message translates to:
  /// **'Cada {horas} h'**
  String formularioMedicamentoCadaHorasCorto(String horas);

  /// No description provided for @formularioMedicamentoCadaHorasValor.
  ///
  /// In es, this message translates to:
  /// **'Cada {horas} horas'**
  String formularioMedicamentoCadaHorasValor(String horas);

  /// No description provided for @formularioMedicamentoHoraMenos.
  ///
  /// In es, this message translates to:
  /// **'Una hora menos entre tomas'**
  String get formularioMedicamentoHoraMenos;

  /// No description provided for @formularioMedicamentoHoraMas.
  ///
  /// In es, this message translates to:
  /// **'Una hora más entre tomas'**
  String get formularioMedicamentoHoraMas;

  /// No description provided for @formularioMedicamentoHoraInicio.
  ///
  /// In es, this message translates to:
  /// **'Hora de inicio'**
  String get formularioMedicamentoHoraInicio;

  /// No description provided for @formularioMedicamentoHoraInicioDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿A qué hora es la primera toma del día?'**
  String get formularioMedicamentoHoraInicioDescripcion;

  /// No description provided for @formularioMedicamentoDuracion.
  ///
  /// In es, this message translates to:
  /// **'Duración del tratamiento'**
  String get formularioMedicamentoDuracion;

  /// No description provided for @formularioMedicamentoDuracionDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿Lo tomas siempre o solo unos días?'**
  String get formularioMedicamentoDuracionDescripcion;

  /// No description provided for @formularioMedicamentoSiempre.
  ///
  /// In es, this message translates to:
  /// **'Siempre'**
  String get formularioMedicamentoSiempre;

  /// No description provided for @formularioMedicamentoSiempreDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha de fin. Por ejemplo, una medicina para la tensión.'**
  String get formularioMedicamentoSiempreDescripcion;

  /// No description provided for @formularioMedicamentoHastaUnDia.
  ///
  /// In es, this message translates to:
  /// **'Hasta un día concreto'**
  String get formularioMedicamentoHastaUnDia;

  /// No description provided for @formularioMedicamentoHastaUnDiaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo, un antibiótico durante 7 días.'**
  String get formularioMedicamentoHastaUnDiaDescripcion;

  /// No description provided for @formularioMedicamentoUltimoDiaEtiqueta.
  ///
  /// In es, this message translates to:
  /// **'Último día del tratamiento'**
  String get formularioMedicamentoUltimoDiaEtiqueta;

  /// No description provided for @formularioMedicamentoUltimoDiaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Ese día todavía hay que tomarlo.'**
  String get formularioMedicamentoUltimoDiaDescripcion;

  /// No description provided for @formularioMedicamentoRecetaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Receta (opcional)'**
  String get formularioMedicamentoRecetaTitulo;

  /// No description provided for @formularioMedicamentoRecetaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Si la receta se acaba un día, te avisamos una semana antes para que pidas cita con tu médico.'**
  String get formularioMedicamentoRecetaDescripcion;

  /// No description provided for @formularioMedicamentoSinReceta.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha'**
  String get formularioMedicamentoSinReceta;

  /// No description provided for @formularioMedicamentoSinRecetaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'No te avisamos de la receta.'**
  String get formularioMedicamentoSinRecetaDescripcion;

  /// No description provided for @formularioMedicamentoConReceta.
  ///
  /// In es, this message translates to:
  /// **'Se acaba un día concreto'**
  String get formularioMedicamentoConReceta;

  /// No description provided for @formularioMedicamentoConRecetaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Te avisamos una semana antes y, hasta que la renueves, cada día que abras la aplicación.'**
  String get formularioMedicamentoConRecetaDescripcion;

  /// No description provided for @formularioMedicamentoRecetaFecha.
  ///
  /// In es, this message translates to:
  /// **'Último día de la receta'**
  String get formularioMedicamentoRecetaFecha;

  /// No description provided for @formularioMedicamentoRecetaFechaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Lo pone en la hoja de la receta, o te lo dicen en la farmacia.'**
  String get formularioMedicamentoRecetaFechaDescripcion;

  /// No description provided for @formularioResumen.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get formularioResumen;

  /// No description provided for @fotoCaja.
  ///
  /// In es, this message translates to:
  /// **'Foto de la caja'**
  String get fotoCaja;

  /// No description provided for @fotoCajaDe.
  ///
  /// In es, this message translates to:
  /// **'Foto de la caja de {medicamento}'**
  String fotoCajaDe(String medicamento);

  /// No description provided for @fotoNoSePuedeMostrar.
  ///
  /// In es, this message translates to:
  /// **'No se puede mostrar la foto.'**
  String get fotoNoSePuedeMostrar;

  /// Por ejemplo: «3 tomas al día, cada 8 horas».
  ///
  /// In es, this message translates to:
  /// **'{tomas, plural, =1{1 toma al día} other{{tomas} tomas al día, cada {horas} horas}}'**
  String horarioDescripcion(int tomas, String horas);

  /// No description provided for @validadorMedicamentoNombreVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre del medicamento. Por ejemplo: Paracetamol.'**
  String get validadorMedicamentoNombreVacio;

  /// No description provided for @validadorMedicamentoNombreLargo.
  ///
  /// In es, this message translates to:
  /// **'El nombre es demasiado largo. Usa como máximo {maximo} letras.'**
  String validadorMedicamentoNombreLargo(String maximo);

  /// No description provided for @validadorMedicamentoTomas.
  ///
  /// In es, this message translates to:
  /// **'Elige cuántas veces al día lo tomas: entre {minimo} y {maximo}.'**
  String validadorMedicamentoTomas(String minimo, String maximo);

  /// No description provided for @validadorMedicamentoFrecuenciaUnaToma.
  ///
  /// In es, this message translates to:
  /// **'Con 1 toma al día no hace falta elegir la frecuencia.'**
  String get validadorMedicamentoFrecuenciaUnaToma;

  /// No description provided for @validadorMedicamentoFrecuencia.
  ///
  /// In es, this message translates to:
  /// **'Con {tomas} tomas al día, elige una frecuencia de {horas} horas o menos.'**
  String validadorMedicamentoFrecuencia(String tomas, String horas);

  /// No description provided for @validadorMedicamentoDosisLarga.
  ///
  /// In es, this message translates to:
  /// **'La dosis es demasiado larga. Usa como máximo {maximo} letras.'**
  String validadorMedicamentoDosisLarga(String maximo);

  /// No description provided for @validadorMedicamentoInstruccionesLargas.
  ///
  /// In es, this message translates to:
  /// **'Las instrucciones son demasiado largas. Usa como máximo {maximo} letras.'**
  String validadorMedicamentoInstruccionesLargas(String maximo);

  /// No description provided for @validadorMedicamentoHoraInicio.
  ///
  /// In es, this message translates to:
  /// **'Elige la hora de la primera toma.'**
  String get validadorMedicamentoHoraInicio;

  /// {opcion} es el texto de la opción «Siempre» del formulario.
  ///
  /// In es, this message translates to:
  /// **'Ese día ya ha pasado. Elige hoy o un día futuro, o marca \"{opcion}\" si no tiene fin.'**
  String validadorMedicamentoFechaFinPasada(String opcion);

  /// No description provided for @errorCargarMedicamentos.
  ///
  /// In es, this message translates to:
  /// **'No se han podido cargar tus medicamentos. Cierra la aplicación y vuelve a abrirla.'**
  String get errorCargarMedicamentos;

  /// No description provided for @tomasMarcar.
  ///
  /// In es, this message translates to:
  /// **'Ya la he tomado'**
  String get tomasMarcar;

  /// No description provided for @tomasDesmarcar.
  ///
  /// In es, this message translates to:
  /// **'Desmarcar'**
  String get tomasDesmarcar;

  /// No description provided for @tomasVacio.
  ///
  /// In es, this message translates to:
  /// **'Hoy no tienes ninguna toma'**
  String get tomasVacio;

  /// No description provided for @tomasVacioExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Cuando registres un medicamento, aquí podrás marcar cada toma.'**
  String get tomasVacioExplicacion;

  /// No description provided for @tomasEscuchar.
  ///
  /// In es, this message translates to:
  /// **'Escuchar las tomas de hoy'**
  String get tomasEscuchar;

  /// No description provided for @tomasEscucharDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Te leerá cuáles has tomado y cuáles faltan.'**
  String get tomasEscucharDescripcion;

  /// No description provided for @tomasAnotada.
  ///
  /// In es, this message translates to:
  /// **'Anotado: has tomado {medicamento} ({hora}).'**
  String tomasAnotada(String medicamento, String hora);

  /// No description provided for @tomasDesmarcada.
  ///
  /// In es, this message translates to:
  /// **'Toma desmarcada: {medicamento} ({hora}).'**
  String tomasDesmarcada(String medicamento, String hora);

  /// No description provided for @tomasDeshacerMarcarPista.
  ///
  /// In es, this message translates to:
  /// **'Quita la marca de esta toma'**
  String get tomasDeshacerMarcarPista;

  /// No description provided for @tomasDeshacerDesmarcarPista.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a marcar esta toma'**
  String get tomasDeshacerDesmarcarPista;

  /// No description provided for @tomasErrorCarga.
  ///
  /// In es, this message translates to:
  /// **'No se han podido cargar tus tomas. Cierra la aplicación y vuelve a abrirla.'**
  String get tomasErrorCarga;

  /// No description provided for @tomasHasTomado.
  ///
  /// In es, this message translates to:
  /// **'Has tomado {tomadas} de {total}.'**
  String tomasHasTomado(String tomadas, String total);

  /// No description provided for @tomasEstadoTomada.
  ///
  /// In es, this message translates to:
  /// **'Tomada a las {hora}'**
  String tomasEstadoTomada(String hora);

  /// No description provided for @tomasEstadoAplazada.
  ///
  /// In es, this message translates to:
  /// **'Aplazada: te lo recordaremos a las {hora}'**
  String tomasEstadoAplazada(String hora);

  /// No description provided for @tomasEstadoPendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get tomasEstadoPendiente;

  /// No description provided for @tomasEstadoSinMarcar.
  ///
  /// In es, this message translates to:
  /// **'Sin marcar. Era a las {hora}.'**
  String tomasEstadoSinMarcar(String hora);

  /// No description provided for @tomasDesmarcarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Si la marcaste por error.'**
  String get tomasDesmarcarDescripcion;

  /// No description provided for @tomasDesmarcarSemantica.
  ///
  /// In es, this message translates to:
  /// **'Desmarcar {medicamento} de las {hora}'**
  String tomasDesmarcarSemantica(String medicamento, String hora);

  /// No description provided for @tomasMarcarSemantica.
  ///
  /// In es, this message translates to:
  /// **'Ya he tomado {medicamento} de las {hora}'**
  String tomasMarcarSemantica(String medicamento, String hora);

  /// No description provided for @historialVacio.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay tomas que mostrar'**
  String get historialVacio;

  /// No description provided for @historialVacioExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Aquí verás las tomas de los últimos 7 días y cuáles marcaste como tomadas.'**
  String get historialVacioExplicacion;

  /// No description provided for @historialErrorCarga.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar el historial. Cierra la aplicación y vuelve a abrirla.'**
  String get historialErrorCarga;

  /// No description provided for @historialUltimosDias.
  ///
  /// In es, this message translates to:
  /// **'Últimos {dias} días.'**
  String historialUltimosDias(String dias);

  /// No description provided for @historialMarcadas.
  ///
  /// In es, this message translates to:
  /// **'Marcadas: {tomadas} de {total}.'**
  String historialMarcadas(String tomadas, String total);

  /// {hora} es la hora prevista de la toma y {momento}, la hora a la que se marcó.
  ///
  /// In es, this message translates to:
  /// **'{hora} · {medicamento}: tomada a las {momento}'**
  String historialTomada(String hora, String medicamento, String momento);

  /// No description provided for @historialAplazada.
  ///
  /// In es, this message translates to:
  /// **'{hora} · {medicamento}: aplazada, sin marcar'**
  String historialAplazada(String hora, String medicamento);

  /// No description provided for @historialPendiente.
  ///
  /// In es, this message translates to:
  /// **'{hora} · {medicamento}: pendiente'**
  String historialPendiente(String hora, String medicamento);

  /// No description provided for @historialSinMarcar.
  ///
  /// In es, this message translates to:
  /// **'{hora} · {medicamento}: sin marcar'**
  String historialSinMarcar(String hora, String medicamento);

  /// No description provided for @agendaCrearCita.
  ///
  /// In es, this message translates to:
  /// **'Crear cita'**
  String get agendaCrearCita;

  /// No description provided for @agendaCrearCitaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Apunta una cita nueva.'**
  String get agendaCrearCitaDescripcion;

  /// No description provided for @agendaPreguntaEliminar.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar esta cita?'**
  String get agendaPreguntaEliminar;

  /// No description provided for @agendaDetalleEliminar.
  ///
  /// In es, this message translates to:
  /// **'{cita}\n{fecha}, a las {hora}'**
  String agendaDetalleEliminar(String cita, String fecha, String hora);

  /// No description provided for @agendaErrorEliminar.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido eliminar la cita. Inténtalo otra vez.'**
  String get agendaErrorEliminar;

  /// No description provided for @agendaCitaEliminada.
  ///
  /// In es, this message translates to:
  /// **'Cita eliminada: {cita}'**
  String agendaCitaEliminada(String cita);

  /// No description provided for @agendaCitaRecuperada.
  ///
  /// In es, this message translates to:
  /// **'Cita recuperada: {cita}'**
  String agendaCitaRecuperada(String cita);

  /// No description provided for @agendaErrorCarga.
  ///
  /// In es, this message translates to:
  /// **'No se han podido cargar tus citas. Cierra la aplicación y vuelve a abrirla.'**
  String get agendaErrorCarga;

  /// No description provided for @agendaVacio.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes ninguna cita'**
  String get agendaVacio;

  /// No description provided for @agendaVacioExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Pulsa el botón \"{boton}\" para apuntar tu primera cita.'**
  String agendaVacioExplicacion(String boton);

  /// No description provided for @agendaProximas.
  ///
  /// In es, this message translates to:
  /// **'Próximas citas'**
  String get agendaProximas;

  /// No description provided for @agendaSinProximas.
  ///
  /// In es, this message translates to:
  /// **'No tienes citas próximas.'**
  String get agendaSinProximas;

  /// No description provided for @agendaPasadas.
  ///
  /// In es, this message translates to:
  /// **'Citas pasadas'**
  String get agendaPasadas;

  /// No description provided for @agendaCitaPasada.
  ///
  /// In es, this message translates to:
  /// **'Esta cita ya ha pasado.'**
  String get agendaCitaPasada;

  /// No description provided for @agendaModificarSemantica.
  ///
  /// In es, this message translates to:
  /// **'Modificar la cita {cita}'**
  String agendaModificarSemantica(String cita);

  /// No description provided for @agendaEliminarSemantica.
  ///
  /// In es, this message translates to:
  /// **'Eliminar la cita {cita}'**
  String agendaEliminarSemantica(String cita);

  /// No description provided for @formularioCitaTituloModificar.
  ///
  /// In es, this message translates to:
  /// **'Modificar cita'**
  String get formularioCitaTituloModificar;

  /// No description provided for @formularioCitaGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar cita'**
  String get formularioCitaGuardar;

  /// No description provided for @formularioCitaGuardada.
  ///
  /// In es, this message translates to:
  /// **'Cita guardada correctamente'**
  String get formularioCitaGuardada;

  /// No description provided for @formularioCitaErrorGuardar.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido guardar la cita. Inténtalo otra vez.'**
  String get formularioCitaErrorGuardar;

  /// No description provided for @formularioCitaMuyPronto.
  ///
  /// In es, this message translates to:
  /// **'La cita es muy pronto: no da tiempo a avisarte antes.'**
  String get formularioCitaMuyPronto;

  /// Por ejemplo: «Te avisaremos ese día a las 08:00 y una hora antes.»
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos {cuando}.'**
  String formularioCitaTeAvisaremos(String cuando);

  /// Parte de «Te avisaremos el día antes a las 18:00, ese día a las 08:00 y una hora antes.»
  ///
  /// In es, this message translates to:
  /// **'el día antes a las {hora}'**
  String formularioCitaAvisoDiaAntes(String hora);

  /// No description provided for @formularioCitaAvisoMismoDia.
  ///
  /// In es, this message translates to:
  /// **'ese día a las {hora}'**
  String formularioCitaAvisoMismoDia(String hora);

  /// No description provided for @formularioCitaAvisoUnaHoraAntes.
  ///
  /// In es, this message translates to:
  /// **'una hora antes'**
  String get formularioCitaAvisoUnaHoraAntes;

  /// No description provided for @formularioCitaResumenGuardada.
  ///
  /// In es, this message translates to:
  /// **'{cita}\n{fecha}, a las {hora}.'**
  String formularioCitaResumenGuardada(String cita, String fecha, String hora);

  /// No description provided for @formularioCitaMotivo.
  ///
  /// In es, this message translates to:
  /// **'Motivo de la cita'**
  String get formularioCitaMotivo;

  /// No description provided for @formularioCitaMotivoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: Médico de cabecera.'**
  String get formularioCitaMotivoDescripcion;

  /// No description provided for @formularioCitaDictarMotivo.
  ///
  /// In es, this message translates to:
  /// **'Dictar el motivo'**
  String get formularioCitaDictarMotivo;

  /// No description provided for @formularioCitaDictarMotivoIndicacion.
  ///
  /// In es, this message translates to:
  /// **'Di el motivo de la cita'**
  String get formularioCitaDictarMotivoIndicacion;

  /// No description provided for @formularioCitaFecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get formularioCitaFecha;

  /// No description provided for @formularioCitaFechaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué día es la cita?'**
  String get formularioCitaFechaDescripcion;

  /// No description provided for @formularioCitaHora.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get formularioCitaHora;

  /// No description provided for @formularioCitaHoraDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿A qué hora es la cita?'**
  String get formularioCitaHoraDescripcion;

  /// No description provided for @formularioCitaLugar.
  ///
  /// In es, this message translates to:
  /// **'Lugar (opcional)'**
  String get formularioCitaLugar;

  /// No description provided for @formularioCitaLugarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: Centro de salud.'**
  String get formularioCitaLugarDescripcion;

  /// No description provided for @formularioCitaNotas.
  ///
  /// In es, this message translates to:
  /// **'Notas (opcional)'**
  String get formularioCitaNotas;

  /// No description provided for @formularioCitaNotasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: llevar los análisis.'**
  String get formularioCitaNotasDescripcion;

  /// No description provided for @validadorCitaMotivoVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe el motivo de la cita. Por ejemplo: Médico de cabecera.'**
  String get validadorCitaMotivoVacio;

  /// No description provided for @validadorCitaMotivoLargo.
  ///
  /// In es, this message translates to:
  /// **'El motivo es demasiado largo. Usa como máximo {maximo} letras.'**
  String validadorCitaMotivoLargo(String maximo);

  /// No description provided for @validadorCitaDia.
  ///
  /// In es, this message translates to:
  /// **'Elige el día de la cita.'**
  String get validadorCitaDia;

  /// No description provided for @validadorCitaHora.
  ///
  /// In es, this message translates to:
  /// **'Elige la hora de la cita.'**
  String get validadorCitaHora;

  /// No description provided for @validadorCitaDiaPasado.
  ///
  /// In es, this message translates to:
  /// **'Ese día ya ha pasado. Elige hoy o un día futuro.'**
  String get validadorCitaDiaPasado;

  /// No description provided for @validadorCitaHoraPasada.
  ///
  /// In es, this message translates to:
  /// **'Esa hora ya ha pasado. Elige una hora más tarde.'**
  String get validadorCitaHoraPasada;

  /// No description provided for @validadorCitaLugarLargo.
  ///
  /// In es, this message translates to:
  /// **'El lugar es demasiado largo. Usa como máximo {maximo} letras.'**
  String validadorCitaLugarLargo(String maximo);

  /// No description provided for @validadorCitaNotasLargas.
  ///
  /// In es, this message translates to:
  /// **'Las notas son demasiado largas. Usa como máximo {maximo} letras.'**
  String validadorCitaNotasLargas(String maximo);

  /// No description provided for @emergenciasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Emergencias'**
  String get emergenciasTitulo;

  /// No description provided for @emergenciasLlamar.
  ///
  /// In es, this message translates to:
  /// **'Llamar'**
  String get emergenciasLlamar;

  /// No description provided for @emergenciasLlamarAlNumero.
  ///
  /// In es, this message translates to:
  /// **'Llamar al {numero}'**
  String emergenciasLlamarAlNumero(String numero);

  /// Botón para llamar al familiar o cuidador, por ejemplo «Llamar a Ana».
  ///
  /// In es, this message translates to:
  /// **'Llamar a {nombre}'**
  String emergenciasLlamarA(String nombre);

  /// No description provided for @emergenciasAbriendoNumero.
  ///
  /// In es, this message translates to:
  /// **'Abriendo el teléfono para llamar al {numero}…'**
  String emergenciasAbriendoNumero(String numero);

  /// No description provided for @emergenciasAbriendoNombre.
  ///
  /// In es, this message translates to:
  /// **'Abriendo el teléfono para llamar a {nombre}…'**
  String emergenciasAbriendoNombre(String nombre);

  /// No description provided for @emergenciasNoSeHaPodidoAbrir.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido abrir el teléfono'**
  String get emergenciasNoSeHaPodidoAbrir;

  /// No description provided for @emergenciasMarcaAMano.
  ///
  /// In es, this message translates to:
  /// **'Marca el {numero} a mano desde la aplicación de teléfono.'**
  String emergenciasMarcaAMano(String numero);

  /// No description provided for @emergenciasIrAAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ir a Ajustes'**
  String get emergenciasIrAAjustes;

  /// No description provided for @emergenciasIrAAjustesDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Allí puedes guardar el número de emergencia.'**
  String get emergenciasIrAAjustesDescripcion;

  /// No description provided for @emergenciasSinNumero.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has guardado un número de emergencia'**
  String get emergenciasSinNumero;

  /// No description provided for @emergenciasSinNumeroExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Para poder llamar desde aquí, primero escribe el número en Ajustes. Por ejemplo, el 112.'**
  String get emergenciasSinNumeroExplicacion;

  /// No description provided for @emergenciasPulsaParaLlamar.
  ///
  /// In es, this message translates to:
  /// **'Pulsa el botón para llamar al {numero}.'**
  String emergenciasPulsaParaLlamar(String numero);

  /// No description provided for @emergenciasExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Se abrirá el teléfono con el número ya escrito. Para hablar, pulsa el botón de llamada del teléfono.'**
  String get emergenciasExplicacion;

  /// No description provided for @ajustesSonidosActivados.
  ///
  /// In es, this message translates to:
  /// **'Sonidos activados'**
  String get ajustesSonidosActivados;

  /// No description provided for @ajustesSonidosDesactivados.
  ///
  /// In es, this message translates to:
  /// **'Sonidos desactivados'**
  String get ajustesSonidosDesactivados;

  /// No description provided for @ajustesVibracionActivada.
  ///
  /// In es, this message translates to:
  /// **'Vibración activada'**
  String get ajustesVibracionActivada;

  /// No description provided for @ajustesVibracionDesactivada.
  ///
  /// In es, this message translates to:
  /// **'Vibración desactivada'**
  String get ajustesVibracionDesactivada;

  /// No description provided for @ajustesLecturaActivada.
  ///
  /// In es, this message translates to:
  /// **'Lectura en voz alta activada'**
  String get ajustesLecturaActivada;

  /// No description provided for @ajustesLecturaDesactivada.
  ///
  /// In es, this message translates to:
  /// **'Lectura en voz alta desactivada'**
  String get ajustesLecturaDesactivada;

  /// No description provided for @ajustesSinVozTitulo.
  ///
  /// In es, this message translates to:
  /// **'Este teléfono no puede leer en voz alta'**
  String get ajustesSinVozTitulo;

  /// Al traducir, cambiar «en español» por el idioma de la traducción: la app lee en voz alta en el idioma de sus textos.
  ///
  /// In es, this message translates to:
  /// **'Le falta la voz en español. Se puede instalar en los ajustes del teléfono, en Accesibilidad, opción \"Texto a voz\".'**
  String get ajustesSinVozMensaje;

  /// En un iPhone, en lugar de ajustesSinVozMensaje: dónde se descargan las voces. Al traducir, cambiar «en español» por el idioma de la traducción.
  ///
  /// In es, this message translates to:
  /// **'Le falta la voz en español. Se puede descargar en los ajustes del iPhone: Accesibilidad → Contenido leído → Voces.'**
  String get ajustesSinVozMensajeIphone;

  /// No description provided for @ajustesNumeroGuardado.
  ///
  /// In es, this message translates to:
  /// **'Número de emergencia guardado: {numero}'**
  String ajustesNumeroGuardado(String numero);

  /// No description provided for @ajustesContactoGuardado.
  ///
  /// In es, this message translates to:
  /// **'Contacto guardado: {nombre}, {numero}'**
  String ajustesContactoGuardado(String nombre, String numero);

  /// No description provided for @ajustesContactoBorrado.
  ///
  /// In es, this message translates to:
  /// **'Contacto del familiar borrado'**
  String get ajustesContactoBorrado;

  /// No description provided for @ajustesCambiosAlMomento.
  ///
  /// In es, this message translates to:
  /// **'Los cambios se guardan al momento.'**
  String get ajustesCambiosAlMomento;

  /// No description provided for @ajustesActivarSonidos.
  ///
  /// In es, this message translates to:
  /// **'Activar sonidos'**
  String get ajustesActivarSonidos;

  /// No description provided for @ajustesActivarSonidosDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Los avisos sonarán.'**
  String get ajustesActivarSonidosDescripcion;

  /// No description provided for @ajustesActivarVibracion.
  ///
  /// In es, this message translates to:
  /// **'Activar vibración'**
  String get ajustesActivarVibracion;

  /// No description provided for @ajustesActivarVibracionDescripcion.
  ///
  /// In es, this message translates to:
  /// **'El teléfono vibrará con cada aviso.'**
  String get ajustesActivarVibracionDescripcion;

  /// No description provided for @ajustesActivarNotificaciones.
  ///
  /// In es, this message translates to:
  /// **'Activar notificaciones'**
  String get ajustesActivarNotificaciones;

  /// No description provided for @ajustesActivarNotificacionesDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Recibirás avisos de tus medicinas y de tus citas.'**
  String get ajustesActivarNotificacionesDescripcion;

  /// No description provided for @ajustesProbarAviso.
  ///
  /// In es, this message translates to:
  /// **'Probar aviso'**
  String get ajustesProbarAviso;

  /// No description provided for @ajustesProbarAvisoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Envía un aviso ahora para comprobar cómo suena y se ve.'**
  String get ajustesProbarAvisoDescripcion;

  /// No description provided for @ajustesRepetirAvisos.
  ///
  /// In es, this message translates to:
  /// **'Repetir los avisos'**
  String get ajustesRepetirAvisos;

  /// {boton} es el botón de los avisos, por ejemplo «Recordar en 10 min».
  ///
  /// In es, this message translates to:
  /// **'Cuándo te avisamos otra vez si no marcas una toma, y cuánto espera el botón \"{boton}\".'**
  String ajustesRepetirAvisosDescripcion(String boton);

  /// No description provided for @ajustesAvisosDiscretos.
  ///
  /// In es, this message translates to:
  /// **'Avisos discretos'**
  String get ajustesAvisosDiscretos;

  /// No description provided for @ajustesAvisosDiscretosDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Los avisos no dirán qué medicina toca ni el motivo de la cita, ni llevarán la foto de la caja: así no se verán en la pantalla de bloqueo. Al tocar el aviso, la aplicación te lo dirá.'**
  String get ajustesAvisosDiscretosDescripcion;

  /// No description provided for @ajustesAvisosDiscretosActivados.
  ///
  /// In es, this message translates to:
  /// **'Avisos discretos activados'**
  String get ajustesAvisosDiscretosActivados;

  /// No description provided for @ajustesAvisosDiscretosDesactivados.
  ///
  /// In es, this message translates to:
  /// **'Avisos discretos desactivados'**
  String get ajustesAvisosDiscretosDesactivados;

  /// No description provided for @repetirSinMarcarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Si no marcas la toma'**
  String get repetirSinMarcarTitulo;

  /// No description provided for @repetirSinMarcarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Te avisamos una vez más, por si no oíste el primer aviso.'**
  String get repetirSinMarcarDescripcion;

  /// Opción: el aviso se repite 15 o 30 minutos después de la hora de la toma.
  ///
  /// In es, this message translates to:
  /// **'A los {minutos} minutos'**
  String repetirALosMinutos(int minutos);

  /// Opción: el aviso se repite una hora después de la hora de la toma.
  ///
  /// In es, this message translates to:
  /// **'A la hora'**
  String get repetirALaHora;

  /// No description provided for @repetirNunca.
  ///
  /// In es, this message translates to:
  /// **'No repetir el aviso'**
  String get repetirNunca;

  /// Por ejemplo: «Una toma de las 08:00 se repite a las 08:30.»
  ///
  /// In es, this message translates to:
  /// **'Una toma de las {hora} se repite a las {repeticion}.'**
  String repetirEjemplo(String hora, String repeticion);

  /// No description provided for @repetirNuncaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Solo suena el aviso de su hora.'**
  String get repetirNuncaDescripcion;

  /// No description provided for @repetirAplazarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Recordar más tarde'**
  String get repetirAplazarTitulo;

  /// No description provided for @repetirAplazarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Los avisos de las tomas llevan un botón para que te lo recordemos un poco después.'**
  String get repetirAplazarDescripcion;

  /// Por ejemplo: «Si lo pulsas a las 08:00, te lo recordamos a las 08:10.»
  ///
  /// In es, this message translates to:
  /// **'Si lo pulsas a las {hora}, te lo recordamos a las {despues}.'**
  String repetirAplazarEjemplo(String hora, String despues);

  /// Mensaje al elegir una opción, por ejemplo «Guardado: A los 15 minutos».
  ///
  /// In es, this message translates to:
  /// **'Guardado: {opcion}'**
  String repetirGuardado(String opcion);

  /// No description provided for @ajustesLeerEnVozAlta.
  ///
  /// In es, this message translates to:
  /// **'Leer en voz alta'**
  String get ajustesLeerEnVozAlta;

  /// No description provided for @ajustesLeerEnVozAltaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Leerá los avisos al abrirlos y podrás escuchar las tomas de hoy.'**
  String get ajustesLeerEnVozAltaDescripcion;

  /// No description provided for @ajustesNumeroEmergencia.
  ///
  /// In es, this message translates to:
  /// **'Nº de emergencia'**
  String get ajustesNumeroEmergencia;

  /// No description provided for @ajustesNumeroEmergenciaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'El número al que llamará el botón de emergencias. Por ejemplo: 112.'**
  String get ajustesNumeroEmergenciaDescripcion;

  /// No description provided for @ajustesGuardarNumero.
  ///
  /// In es, this message translates to:
  /// **'Guardar número'**
  String get ajustesGuardarNumero;

  /// No description provided for @ajustesNombreFamiliar.
  ///
  /// In es, this message translates to:
  /// **'Nombre de un familiar'**
  String get ajustesNombreFamiliar;

  /// No description provided for @ajustesNombreFamiliarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Otra persona a la que podrás llamar desde Emergencias. Por ejemplo: Mi hija Ana.'**
  String get ajustesNombreFamiliarDescripcion;

  /// No description provided for @ajustesTelefonoFamiliar.
  ///
  /// In es, this message translates to:
  /// **'Teléfono del familiar'**
  String get ajustesTelefonoFamiliar;

  /// No description provided for @ajustesGuardarContacto.
  ///
  /// In es, this message translates to:
  /// **'Guardar contacto'**
  String get ajustesGuardarContacto;

  /// No description provided for @ajustesGuardarContactoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Para borrarlo, deja los dos campos vacíos.'**
  String get ajustesGuardarContactoDescripcion;

  /// No description provided for @ajustesTamanoTexto.
  ///
  /// In es, this message translates to:
  /// **'Ajustar tamaño de texto'**
  String get ajustesTamanoTexto;

  /// No description provided for @ajustesTamanoTextoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Haz las letras más grandes o más pequeñas.'**
  String get ajustesTamanoTextoDescripcion;

  /// No description provided for @ajustesTema.
  ///
  /// In es, this message translates to:
  /// **'Ajustar tema'**
  String get ajustesTema;

  /// No description provided for @ajustesTemaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cambia los colores de la aplicación.'**
  String get ajustesTemaDescripcion;

  /// No description provided for @compartirTitulo.
  ///
  /// In es, this message translates to:
  /// **'Compartir y copia de seguridad'**
  String get compartirTitulo;

  /// No description provided for @ajustesCompartirDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Envía tu medicación al médico o a la familia y guarda tus datos para no perderlos.'**
  String get ajustesCompartirDescripcion;

  /// No description provided for @permisosNotificacionesActivadas.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas'**
  String get permisosNotificacionesActivadas;

  /// No description provided for @permisosNotificacionesDesactivadas.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones desactivadas'**
  String get permisosNotificacionesDesactivadas;

  /// No description provided for @permisosDenegado.
  ///
  /// In es, this message translates to:
  /// **'El teléfono no ha dado permiso para mostrar avisos, así que siguen desactivados.'**
  String get permisosDenegado;

  /// No description provided for @permisosHoraExactaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Avisos a la hora exacta'**
  String get permisosHoraExactaTitulo;

  /// No description provided for @permisosHoraExactaMensaje.
  ///
  /// In es, this message translates to:
  /// **'Las notificaciones ya están activadas. Para que los avisos lleguen justo a su hora, el teléfono necesita un permiso más.\n\nSi pulsas \"{boton}\" se abrirá una pantalla del teléfono: activa la opción y vuelve con el botón Atrás.'**
  String permisosHoraExactaMensaje(String boton);

  /// No description provided for @permisosDarPermiso.
  ///
  /// In es, this message translates to:
  /// **'Dar permiso'**
  String get permisosDarPermiso;

  /// No description provided for @permisosHoraExactaConcedido.
  ///
  /// In es, this message translates to:
  /// **'Listo: los avisos llegarán a su hora exacta.'**
  String get permisosHoraExactaConcedido;

  /// No description provided for @permisosHoraExactaDenegado.
  ///
  /// In es, this message translates to:
  /// **'Sin ese permiso, los avisos pueden llegar unos minutos tarde.'**
  String get permisosHoraExactaDenegado;

  /// No description provided for @permisosFaltaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Falta el permiso del teléfono'**
  String get permisosFaltaTitulo;

  /// No description provided for @permisosFaltaMensaje.
  ///
  /// In es, this message translates to:
  /// **'{explicacion}\n\nPulsa \"{boton}\", activa las notificaciones y vuelve con el botón Atrás.'**
  String permisosFaltaMensaje(String explicacion, String boton);

  /// No description provided for @permisosAbrirAjustes.
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes del teléfono'**
  String get permisosAbrirAjustes;

  /// No description provided for @permisosPruebaEnviada.
  ///
  /// In es, this message translates to:
  /// **'Aviso de prueba enviado. Mira la parte de arriba de la pantalla.'**
  String get permisosPruebaEnviada;

  /// No description provided for @permisosPruebaDesactivadasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Las notificaciones están desactivadas'**
  String get permisosPruebaDesactivadasTitulo;

  /// No description provided for @permisosPruebaDesactivadasMensaje.
  ///
  /// In es, this message translates to:
  /// **'Activa primero \"{interruptor}\" y después vuelve a pulsar \"{boton}\".'**
  String permisosPruebaDesactivadasMensaje(String interruptor, String boton);

  /// No description provided for @permisosPruebaSinPermiso.
  ///
  /// In es, this message translates to:
  /// **'El teléfono no deja mostrar los avisos de esta aplicación.'**
  String get permisosPruebaSinPermiso;

  /// No description provided for @temaPredeterminado.
  ///
  /// In es, this message translates to:
  /// **'Tema predeterminado'**
  String get temaPredeterminado;

  /// No description provided for @temaPredeterminadoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Fondo azul claro y letras negras.'**
  String get temaPredeterminadoDescripcion;

  /// No description provided for @temaOscuro.
  ///
  /// In es, this message translates to:
  /// **'Tema oscuro'**
  String get temaOscuro;

  /// No description provided for @temaOscuroDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Fondo oscuro y letras blancas. Cansa menos la vista con poca luz.'**
  String get temaOscuroDescripcion;

  /// No description provided for @temaAlternativo.
  ///
  /// In es, this message translates to:
  /// **'Tema alternativo'**
  String get temaAlternativo;

  /// No description provided for @temaAlternativoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Fondo amarillo suave y letras negras. Reduce los reflejos.'**
  String get temaAlternativoDescripcion;

  /// No description provided for @temaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get temaTitulo;

  /// No description provided for @temaAplicar.
  ///
  /// In es, this message translates to:
  /// **'Aplicar este tema'**
  String get temaAplicar;

  /// No description provided for @temaAplicado.
  ///
  /// In es, this message translates to:
  /// **'Tema aplicado: {tema}'**
  String temaAplicado(String tema);

  /// No description provided for @temaToca.
  ///
  /// In es, this message translates to:
  /// **'Toca un tema para verlo en la muestra.'**
  String get temaToca;

  /// No description provided for @temaMuestra.
  ///
  /// In es, this message translates to:
  /// **'Muestra: {tema}'**
  String temaMuestra(String tema);

  /// No description provided for @temaYaLoUsas.
  ///
  /// In es, this message translates to:
  /// **'Este es el tema que ya usas.'**
  String get temaYaLoUsas;

  /// No description provided for @temaAhoraUsas.
  ///
  /// In es, this message translates to:
  /// **'Ahora usas: {tema}.'**
  String temaAhoraUsas(String tema);

  /// No description provided for @temaElegido.
  ///
  /// In es, this message translates to:
  /// **'Elegido'**
  String get temaElegido;

  /// No description provided for @temaEnUso.
  ///
  /// In es, this message translates to:
  /// **'En uso'**
  String get temaEnUso;

  /// No description provided for @temaSeparadorEstado.
  ///
  /// In es, this message translates to:
  /// **' · '**
  String get temaSeparadorEstado;

  /// No description provided for @temaMuestraTexto.
  ///
  /// In es, this message translates to:
  /// **'Así se verán las pantallas con este tema.'**
  String get temaMuestraTexto;

  /// No description provided for @temaMuestraBoton.
  ///
  /// In es, this message translates to:
  /// **'Botón de ejemplo'**
  String get temaMuestraBoton;

  /// No description provided for @temaMuestraInterruptor.
  ///
  /// In es, this message translates to:
  /// **'Interruptor de ejemplo'**
  String get temaMuestraInterruptor;

  /// No description provided for @temaMuestraInterruptorDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Verde es activado.'**
  String get temaMuestraInterruptorDescripcion;

  /// No description provided for @tamanoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de texto'**
  String get tamanoTitulo;

  /// No description provided for @tamanoAumentar.
  ///
  /// In es, this message translates to:
  /// **'Aumentar (+)'**
  String get tamanoAumentar;

  /// No description provided for @tamanoReducir.
  ///
  /// In es, this message translates to:
  /// **'Reducir (−)'**
  String get tamanoReducir;

  /// No description provided for @tamanoMuestraTexto.
  ///
  /// In es, this message translates to:
  /// **'Así se verán los textos de la aplicación. Por ejemplo: Paracetamol, 3 tomas al día, cada 8 horas.'**
  String get tamanoMuestraTexto;

  /// No description provided for @tamanoActual.
  ///
  /// In es, this message translates to:
  /// **'Tamaño actual: {tamano}'**
  String tamanoActual(String tamano);

  /// No description provided for @tamanoActualNormal.
  ///
  /// In es, this message translates to:
  /// **'Tamaño actual: {tamano} (normal)'**
  String tamanoActualNormal(String tamano);

  /// No description provided for @tamanoActualMinimo.
  ///
  /// In es, this message translates to:
  /// **'Tamaño actual: {tamano} (mínimo)'**
  String tamanoActualMinimo(String tamano);

  /// No description provided for @tamanoActualMaximo.
  ///
  /// In es, this message translates to:
  /// **'Tamaño actual: {tamano} (máximo)'**
  String tamanoActualMaximo(String tamano);

  /// No description provided for @tamanoPuedesElegir.
  ///
  /// In es, this message translates to:
  /// **'Puedes elegir entre {minimo} y {maximo}. El cambio se aplica a toda la aplicación.'**
  String tamanoPuedesElegir(String minimo, String maximo);

  /// No description provided for @tamanoMasGrandes.
  ///
  /// In es, this message translates to:
  /// **'Letras más grandes.'**
  String get tamanoMasGrandes;

  /// No description provided for @tamanoYaMaximo.
  ///
  /// In es, this message translates to:
  /// **'Ya está en el tamaño máximo.'**
  String get tamanoYaMaximo;

  /// No description provided for @tamanoMasPequenas.
  ///
  /// In es, this message translates to:
  /// **'Letras más pequeñas.'**
  String get tamanoMasPequenas;

  /// No description provided for @tamanoYaMinimo.
  ///
  /// In es, this message translates to:
  /// **'Ya está en el tamaño mínimo.'**
  String get tamanoYaMinimo;

  /// No description provided for @tamanoMuestra.
  ///
  /// In es, this message translates to:
  /// **'Muestra'**
  String get tamanoMuestra;

  /// No description provided for @ajustesFraseDePruebaVoz.
  ///
  /// In es, this message translates to:
  /// **'Así sonará la voz. Leeré tus avisos y tus tomas de hoy.'**
  String get ajustesFraseDePruebaVoz;

  /// No description provided for @validadorFamiliarNombreVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe cómo se llama. Por ejemplo: Mi hija Ana.'**
  String get validadorFamiliarNombreVacio;

  /// No description provided for @validadorFamiliarNombreLargo.
  ///
  /// In es, this message translates to:
  /// **'El nombre es demasiado largo: como mucho {maximo} letras.'**
  String validadorFamiliarNombreLargo(String maximo);

  /// No description provided for @validadorFamiliarNumeroVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe su número de teléfono.'**
  String get validadorFamiliarNumeroVacio;

  /// No description provided for @validadorTelefonoVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe un número de teléfono. Por ejemplo: 112.'**
  String get validadorTelefonoVacio;

  /// No description provided for @validadorTelefonoSoloNumeros.
  ///
  /// In es, this message translates to:
  /// **'Escribe solo números. Por ejemplo: 112 o 600123456.'**
  String get validadorTelefonoSoloNumeros;

  /// No description provided for @validadorTelefonoCorto.
  ///
  /// In es, this message translates to:
  /// **'El número es demasiado corto. Debe tener al menos {minimo} cifras.'**
  String validadorTelefonoCorto(String minimo);

  /// No description provided for @validadorTelefonoLargo.
  ///
  /// In es, this message translates to:
  /// **'El número es demasiado largo. Revisa que esté bien escrito.'**
  String get validadorTelefonoLargo;

  /// No description provided for @asistenteTitulo.
  ///
  /// In es, this message translates to:
  /// **'Primeros pasos'**
  String get asistenteTitulo;

  /// No description provided for @asistenteEmpezar.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get asistenteEmpezar;

  /// No description provided for @asistenteSaltar.
  ///
  /// In es, this message translates to:
  /// **'Saltar estos pasos'**
  String get asistenteSaltar;

  /// No description provided for @asistenteSaltarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Ir directamente al menú principal.'**
  String get asistenteSaltarDescripcion;

  /// No description provided for @asistenteSiguiente.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get asistenteSiguiente;

  /// No description provided for @asistenteTerminar.
  ///
  /// In es, this message translates to:
  /// **'Empezar a usar la aplicación'**
  String get asistenteTerminar;

  /// No description provided for @asistenteHola.
  ///
  /// In es, this message translates to:
  /// **'Hola'**
  String get asistenteHola;

  /// No description provided for @asistenteBienvenida.
  ///
  /// In es, this message translates to:
  /// **'Vamos a preparar la aplicación en 3 pasos: el tamaño de la letra, los avisos y el número de emergencia.'**
  String get asistenteBienvenida;

  /// No description provided for @asistenteCambiarEnAjustes.
  ///
  /// In es, this message translates to:
  /// **'Todo se puede cambiar más tarde en Ajustes.'**
  String get asistenteCambiarEnAjustes;

  /// Encabezado de cada paso, por ejemplo «Paso 1 de 3: Tamaño de la letra».
  ///
  /// In es, this message translates to:
  /// **'Paso {numero} de {total}: {titulo}'**
  String asistentePaso(String numero, String total, String titulo);

  /// No description provided for @asistenteTamanoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de la letra'**
  String get asistenteTamanoTitulo;

  /// No description provided for @asistenteTamanoExplicacion.
  ///
  /// In es, this message translates to:
  /// **'¿Lees bien este texto? Si te cuesta, haz las letras más grandes.'**
  String get asistenteTamanoExplicacion;

  /// No description provided for @asistenteAvisosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Avisos de medicinas y citas'**
  String get asistenteAvisosTitulo;

  /// No description provided for @asistenteAvisosExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos a la hora de cada medicina y antes de cada cita, con sonido y vibración.'**
  String get asistenteAvisosExplicacion;

  /// No description provided for @asistenteActivarAvisos.
  ///
  /// In es, this message translates to:
  /// **'Activar los avisos'**
  String get asistenteActivarAvisos;

  /// «Permitir» es el botón del aviso de permiso de Android en ese idioma.
  ///
  /// In es, this message translates to:
  /// **'El teléfono te pedirá permiso: pulsa \"Permitir\".'**
  String get asistenteActivarAvisosDescripcion;

  /// No description provided for @asistenteSiPrefieresNo.
  ///
  /// In es, this message translates to:
  /// **'Si prefieres no activarlos ahora, pulsa \"{boton}\".'**
  String asistenteSiPrefieresNo(String boton);

  /// No description provided for @asistenteConSonido.
  ///
  /// In es, this message translates to:
  /// **'con sonido'**
  String get asistenteConSonido;

  /// No description provided for @asistenteSinSonido.
  ///
  /// In es, this message translates to:
  /// **'sin sonido'**
  String get asistenteSinSonido;

  /// No description provided for @asistenteConVibracion.
  ///
  /// In es, this message translates to:
  /// **'con vibración'**
  String get asistenteConVibracion;

  /// No description provided for @asistenteSinVibracion.
  ///
  /// In es, this message translates to:
  /// **'sin vibración'**
  String get asistenteSinVibracion;

  /// No description provided for @asistenteAvisosActivados.
  ///
  /// In es, this message translates to:
  /// **'Los avisos están activados, {sonido} y {vibracion}.'**
  String asistenteAvisosActivados(String sonido, String vibracion);

  /// No description provided for @asistenteProbarAvisoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Envía un aviso ahora para ver cómo suena y se ve.'**
  String get asistenteProbarAvisoDescripcion;

  /// No description provided for @asistenteEmergenciaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Número de emergencia'**
  String get asistenteEmergenciaTitulo;

  /// No description provided for @asistenteEmergenciaExplicacion.
  ///
  /// In es, this message translates to:
  /// **'El botón de emergencias llamará a este número. Puede ser el 112 o el de un familiar.'**
  String get asistenteEmergenciaExplicacion;

  /// No description provided for @asistenteEmergenciaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Si no quieres ponerlo ahora, déjalo vacío.'**
  String get asistenteEmergenciaDescripcion;

  /// No description provided for @asistenteTodoListo.
  ///
  /// In es, this message translates to:
  /// **'Todo listo'**
  String get asistenteTodoListo;

  /// No description provided for @asistenteResumenTamano.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de la letra: {tamano}.'**
  String asistenteResumenTamano(String tamano);

  /// No description provided for @asistenteResumenAvisosActivados.
  ///
  /// In es, this message translates to:
  /// **'Avisos activados.'**
  String get asistenteResumenAvisosActivados;

  /// No description provided for @asistenteResumenAvisosDesactivados.
  ///
  /// In es, this message translates to:
  /// **'Avisos desactivados. Puedes activarlos en Ajustes.'**
  String get asistenteResumenAvisosDesactivados;

  /// No description provided for @asistenteResumenNumero.
  ///
  /// In es, this message translates to:
  /// **'Número de emergencia: {numero}.'**
  String asistenteResumenNumero(String numero);

  /// No description provided for @asistenteResumenSinNumero.
  ///
  /// In es, this message translates to:
  /// **'Sin número de emergencia. Puedes ponerlo en Ajustes.'**
  String get asistenteResumenSinNumero;

  /// No description provided for @asistenteTambienEnAjustes.
  ///
  /// In es, this message translates to:
  /// **'En Ajustes también puedes elegir los colores y activar la lectura en voz alta.'**
  String get asistenteTambienEnAjustes;

  /// No description provided for @compartirEnviarInforme.
  ///
  /// In es, this message translates to:
  /// **'Enviar mi medicación y citas'**
  String get compartirEnviarInforme;

  /// No description provided for @compartirEnviarInformeDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por WhatsApp, correo… En la pantalla siguiente eliges a quién.'**
  String get compartirEnviarInformeDescripcion;

  /// No description provided for @compartirImprimir.
  ///
  /// In es, this message translates to:
  /// **'Imprimir'**
  String get compartirImprimir;

  /// No description provided for @compartirImprimirDescripcion.
  ///
  /// In es, this message translates to:
  /// **'En una impresora conectada al teléfono, o guardarlo como PDF.'**
  String get compartirImprimirDescripcion;

  /// No description provided for @compartirGuardarCopia.
  ///
  /// In es, this message translates to:
  /// **'Guardar una copia'**
  String get compartirGuardarCopia;

  /// No description provided for @compartirGuardarCopiaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'En Google Drive o en la carpeta de descargas.'**
  String get compartirGuardarCopiaDescripcion;

  /// No description provided for @compartirEnviarCopia.
  ///
  /// In es, this message translates to:
  /// **'Enviar una copia'**
  String get compartirEnviarCopia;

  /// No description provided for @compartirEnviarCopiaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por correo o WhatsApp: a tu propio correo o a un familiar.'**
  String get compartirEnviarCopiaDescripcion;

  /// No description provided for @compartirRecuperar.
  ///
  /// In es, this message translates to:
  /// **'Recuperar una copia'**
  String get compartirRecuperar;

  /// No description provided for @compartirRecuperarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cambia los datos de este teléfono por los de una copia. Antes te preguntará.'**
  String get compartirRecuperarDescripcion;

  /// No description provided for @compartirSiRecuperar.
  ///
  /// In es, this message translates to:
  /// **'Sí, recuperar la copia'**
  String get compartirSiRecuperar;

  /// No description provided for @compartirErrorDocumento.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido preparar el documento. Inténtalo otra vez.'**
  String get compartirErrorDocumento;

  /// No description provided for @compartirErrorImprimir.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido abrir la impresión. Inténtalo otra vez.'**
  String get compartirErrorImprimir;

  /// No description provided for @compartirCopiaGuardada.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad guardada.'**
  String get compartirCopiaGuardada;

  /// No description provided for @compartirErrorGuardarCopia.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido guardar la copia. Inténtalo otra vez.'**
  String get compartirErrorGuardarCopia;

  /// No description provided for @compartirErrorEnviarCopia.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido preparar la copia. Inténtalo otra vez.'**
  String get compartirErrorEnviarCopia;

  /// No description provided for @compartirNoSePuedeRecuperar.
  ///
  /// In es, this message translates to:
  /// **'No se puede recuperar este fichero'**
  String get compartirNoSePuedeRecuperar;

  /// No description provided for @compartirSustitucionVacio.
  ///
  /// In es, this message translates to:
  /// **'Se pondrá en este teléfono lo que hay en la copia.'**
  String get compartirSustitucionVacio;

  /// {actual} es un resumen de los datos, por ejemplo «2 medicamentos y 1 cita».
  ///
  /// In es, this message translates to:
  /// **'Se borrará lo que hay ahora en este teléfono ({actual}) y se pondrá lo de la copia.'**
  String compartirSustitucion(String actual);

  /// No description provided for @compartirPreguntaRecuperar.
  ///
  /// In es, this message translates to:
  /// **'¿Recuperar esta copia?'**
  String get compartirPreguntaRecuperar;

  /// No description provided for @compartirCopiaDel.
  ///
  /// In es, this message translates to:
  /// **'Copia del {fecha}, a las {hora}: {resumen}.'**
  String compartirCopiaDel(String fecha, String hora, String resumen);

  /// En la pregunta de recuperar una copia: el número que se pondrá en Emergencias.
  ///
  /// In es, this message translates to:
  /// **'Número de emergencia: {numero}.'**
  String compartirCopiaEmergencia(String numero);

  /// No description provided for @compartirCopiaSinEmergencia.
  ///
  /// In es, this message translates to:
  /// **'Sin número de emergencia.'**
  String get compartirCopiaSinEmergencia;

  /// {familiar} es como «Mi hija Ana, 600123456».
  ///
  /// In es, this message translates to:
  /// **'Familiar: {familiar}.'**
  String compartirCopiaFamiliar(String familiar);

  /// No description provided for @compartirCopiaSinFamiliar.
  ///
  /// In es, this message translates to:
  /// **'Sin familiar.'**
  String get compartirCopiaSinFamiliar;

  /// No description provided for @compartirCopiaRecuperada.
  ///
  /// In es, this message translates to:
  /// **'Copia recuperada'**
  String get compartirCopiaRecuperada;

  /// No description provided for @compartirYaTienes.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes en este teléfono {resumen}.'**
  String compartirYaTienes(String resumen);

  /// No description provided for @compartirAvisosDesactivados.
  ///
  /// In es, this message translates to:
  /// **'Los avisos están desactivados en este teléfono: actívalos en Ajustes para recibirlos.'**
  String get compartirAvisosDesactivados;

  /// No description provided for @compartirErrorRecuperar.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido recuperar la copia. Inténtalo otra vez.'**
  String get compartirErrorRecuperar;

  /// No description provided for @compartirParaElMedico.
  ///
  /// In es, this message translates to:
  /// **'Para el médico o la familia'**
  String get compartirParaElMedico;

  /// No description provided for @compartirParaElMedicoExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Un documento con tus medicinas, tus tomas de la última semana y tus próximas citas.'**
  String get compartirParaElMedicoExplicacion;

  /// No description provided for @compartirCopiaDeSeguridad.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad'**
  String get compartirCopiaDeSeguridad;

  /// No description provided for @compartirCopiaExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Guarda en un fichero todos tus datos: medicinas con sus fotos, tomas, citas y ajustes. En un móvil nuevo, instala la aplicación y pulsa \"{boton}\".'**
  String compartirCopiaExplicacion(String boton);

  /// No description provided for @compartirUnMomento.
  ///
  /// In es, this message translates to:
  /// **'Un momento, por favor…'**
  String get compartirUnMomento;

  /// {app} es el nombre de la aplicación (appTitulo).
  ///
  /// In es, this message translates to:
  /// **'Este fichero no es una copia de {app}, o está dañado.'**
  String copiaNoEsCopia(String app);

  /// No description provided for @copiaDemasiadoGrande.
  ///
  /// In es, this message translates to:
  /// **'Este fichero es demasiado grande para ser una copia de {app}.'**
  String copiaDemasiadoGrande(String app);

  /// No description provided for @copiaVersionNueva.
  ///
  /// In es, this message translates to:
  /// **'Esta copia es de una versión más nueva de la aplicación. Actualiza la aplicación y vuelve a intentarlo.'**
  String get copiaVersionNueva;

  /// Nombre del fichero de la copia (sin «.json»). {fecha} va en formato AAAA-MM-DD.
  ///
  /// In es, this message translates to:
  /// **'Copia de {app} {fecha}'**
  String copiaNombreFichero(String app, String fecha);

  /// No description provided for @copiaMedicamentos.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{1 medicamento} other{{cantidad} medicamentos}}'**
  String copiaMedicamentos(int cantidad);

  /// No description provided for @copiaCitas.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{1 cita} other{{cantidad} citas}}'**
  String copiaCitas(int cantidad);

  /// No description provided for @copiaTomas.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{1 toma anotada} other{{cantidad} tomas anotadas}}'**
  String copiaTomas(int cantidad);

  /// No description provided for @copiaAsunto.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad de {app}'**
  String copiaAsunto(String app);

  /// No description provided for @informeTitulo.
  ///
  /// In es, this message translates to:
  /// **'Mi medicación y mis citas'**
  String get informeTitulo;

  /// Nombre del fichero PDF (sin «.pdf»). {fecha} va como 25-10-2026.
  ///
  /// In es, this message translates to:
  /// **'Medicación y citas {fecha}'**
  String informeNombreFichero(String fecha);

  /// No description provided for @informePagina.
  ///
  /// In es, this message translates to:
  /// **'Página {pagina} de {total}'**
  String informePagina(String pagina, String total);

  /// No description provided for @informeActualizado.
  ///
  /// In es, this message translates to:
  /// **'Actualizado el {fecha}, a las {hora}.'**
  String informeActualizado(String fecha, String hora);

  /// No description provided for @informeTelefonosEmergencia.
  ///
  /// In es, this message translates to:
  /// **'Teléfonos de emergencia: {telefonos}.'**
  String informeTelefonosEmergencia(String telefonos);

  /// No description provided for @informeContactoFamiliar.
  ///
  /// In es, this message translates to:
  /// **'{nombre}: {numero}'**
  String informeContactoFamiliar(String nombre, String numero);

  /// No description provided for @informeSeparadorTelefonos.
  ///
  /// In es, this message translates to:
  /// **' · '**
  String get informeSeparadorTelefonos;

  /// No description provided for @informeMedicamentos.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get informeMedicamentos;

  /// No description provided for @informeSinMedicamentos.
  ///
  /// In es, this message translates to:
  /// **'No hay medicamentos registrados.'**
  String get informeSinMedicamentos;

  /// Por ejemplo: «3 tomas al día, cada 8 horas: 08:00, 16:00 y 00:00».
  ///
  /// In es, this message translates to:
  /// **'{tomas}: {horas}'**
  String informeTomasYHoras(String tomas, String horas);

  /// No description provided for @informeInstrucciones.
  ///
  /// In es, this message translates to:
  /// **'Instrucciones: {instrucciones}'**
  String informeInstrucciones(String instrucciones);

  /// No description provided for @informeTomasUltimosDias.
  ///
  /// In es, this message translates to:
  /// **'Tomas de los últimos {dias} días'**
  String informeTomasUltimosDias(String dias);

  /// No description provided for @informeColumnaDia.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get informeColumnaDia;

  /// No description provided for @informeColumnaTomadas.
  ///
  /// In es, this message translates to:
  /// **'Tomadas'**
  String get informeColumnaTomadas;

  /// No description provided for @informeColumnaSinMarcar.
  ///
  /// In es, this message translates to:
  /// **'Sin marcar'**
  String get informeColumnaSinMarcar;

  /// No description provided for @informeHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get informeHoy;

  /// Primera columna de la tabla de tomas, por ejemplo «Hoy 25/10» o «sábado 24/10».
  ///
  /// In es, this message translates to:
  /// **'{dia} {numero}/{mes}'**
  String informeDiaFecha(String dia, String numero, String mes);

  /// No description provided for @informeTomadas.
  ///
  /// In es, this message translates to:
  /// **'{tomadas} de {total}'**
  String informeTomadas(String tomadas, String total);

  /// No description provided for @informeTomadasConPendientes.
  ///
  /// In es, this message translates to:
  /// **'{tomadas} de {total} ({pendientes} por llegar)'**
  String informeTomadasConPendientes(
    String tomadas,
    String total,
    String pendientes,
  );

  /// No description provided for @informeTomaSinMarcar.
  ///
  /// In es, this message translates to:
  /// **'{hora} {medicamento}'**
  String informeTomaSinMarcar(String hora, String medicamento);

  /// No description provided for @informeYMas.
  ///
  /// In es, this message translates to:
  /// **'{lista} y {mas} más'**
  String informeYMas(String lista, String mas);

  /// No description provided for @informeSinTomas.
  ///
  /// In es, this message translates to:
  /// **'No hay tomas en estos días.'**
  String get informeSinTomas;

  /// No description provided for @informeProximasCitas.
  ///
  /// In es, this message translates to:
  /// **'Próximas citas'**
  String get informeProximasCitas;

  /// No description provided for @informeSinCitas.
  ///
  /// In es, this message translates to:
  /// **'No hay citas próximas.'**
  String get informeSinCitas;

  /// No description provided for @informeCitaCuando.
  ///
  /// In es, this message translates to:
  /// **'{fecha}, a las {hora}'**
  String informeCitaCuando(String fecha, String hora);

  /// No description provided for @informeLugar.
  ///
  /// In es, this message translates to:
  /// **'Lugar: {lugar}'**
  String informeLugar(String lugar);

  /// No description provided for @informeNotas.
  ///
  /// In es, this message translates to:
  /// **'Notas: {notas}'**
  String informeNotas(String notas);

  /// No description provided for @canalConSonidoYVibracion.
  ///
  /// In es, this message translates to:
  /// **'Avisos con sonido y vibración'**
  String get canalConSonidoYVibracion;

  /// No description provided for @canalConSonido.
  ///
  /// In es, this message translates to:
  /// **'Avisos con sonido'**
  String get canalConSonido;

  /// No description provided for @canalConVibracion.
  ///
  /// In es, this message translates to:
  /// **'Avisos con vibración'**
  String get canalConVibracion;

  /// No description provided for @canalSilencioso.
  ///
  /// In es, this message translates to:
  /// **'Avisos silenciosos'**
  String get canalSilencioso;

  /// No description provided for @canalDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Avisos de tomas de medicamentos y de citas.'**
  String get canalDescripcion;

  /// No description provided for @avisoNotaRenovar.
  ///
  /// In es, this message translates to:
  /// **'Abre la aplicación para seguir recibiendo estos avisos.'**
  String get avisoNotaRenovar;

  /// No description provided for @avisoTomaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Hora de tu medicina'**
  String get avisoTomaTitulo;

  /// No description provided for @avisoAplazadoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Recuerda tu medicina'**
  String get avisoAplazadoTitulo;

  /// No description provided for @avisoRepeticionTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Has tomado tu medicina?'**
  String get avisoRepeticionTitulo;

  /// No description provided for @avisoTomaCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Toma {medicamento} ({hora}).'**
  String avisoTomaCuerpo(String medicamento, String hora);

  /// No description provided for @avisoTomaCuerpoConDosis.
  ///
  /// In es, this message translates to:
  /// **'Toma {medicamento}: {dosis} ({hora}).'**
  String avisoTomaCuerpoConDosis(String medicamento, String dosis, String hora);

  /// No description provided for @avisoRepeticionCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Era a las {hora}: {medicamento}. Si ya la has tomado, pulsa \"{boton}\".'**
  String avisoRepeticionCuerpo(String hora, String medicamento, String boton);

  /// No description provided for @avisoRepeticionCuerpoConDosis.
  ///
  /// In es, this message translates to:
  /// **'Era a las {hora}: {medicamento}: {dosis}. Si ya la has tomado, pulsa \"{boton}\".'**
  String avisoRepeticionCuerpoConDosis(
    String hora,
    String medicamento,
    String dosis,
    String boton,
  );

  /// Con "Avisos discretos": el aviso de una toma sin el nombre de la medicina (el título es "Hora de tu medicina").
  ///
  /// In es, this message translates to:
  /// **'La de las {hora}. Toca aquí para ver cuál es.'**
  String avisoTomaCuerpoDiscreto(String hora);

  /// Con "Avisos discretos": la repetición de una toma sin marcar (el título es "¿Has tomado tu medicina?").
  ///
  /// In es, this message translates to:
  /// **'Era a las {hora}. Toca aquí para ver cuál es.'**
  String avisoRepeticionCuerpoDiscreto(String hora);

  /// Con "Avisos discretos": el aviso de que quedan pocas pastillas (el título es "Te quedan pocas pastillas").
  ///
  /// In es, this message translates to:
  /// **'De una de tus medicinas. Toca aquí para ver cuál es.'**
  String get avisoExistenciasCuerpoDiscreto;

  /// Con "Avisos discretos": el aviso de renovar la receta (el título es "Renueva la receta").
  ///
  /// In es, this message translates to:
  /// **'La de una de tus medicinas. Toca aquí para ver cuál es.'**
  String get avisoRecetaCuerpoDiscreto;

  /// Con "Avisos discretos": el aviso de una cita sin el motivo ni el lugar (el título es "Hoy tienes una cita").
  ///
  /// In es, this message translates to:
  /// **'A las {hora}. Toca aquí para ver cuál es.'**
  String avisoCitaCuerpoDiscreto(String hora);

  /// No description provided for @avisoCitaHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy tienes una cita'**
  String get avisoCitaHoy;

  /// Título del aviso de una cita, la tarde del día anterior (a las 18:00).
  ///
  /// In es, this message translates to:
  /// **'Mañana tienes una cita'**
  String get avisoCitaManana;

  /// No description provided for @avisoCitaUnaHora.
  ///
  /// In es, this message translates to:
  /// **'Tu cita es dentro de 1 hora'**
  String get avisoCitaUnaHora;

  /// No description provided for @avisoCitaCuerpo.
  ///
  /// In es, this message translates to:
  /// **'{cita} a las {hora}.'**
  String avisoCitaCuerpo(String cita, String hora);

  /// No description provided for @avisoCitaCuerpoConLugar.
  ///
  /// In es, this message translates to:
  /// **'{cita} a las {hora} en {lugar}.'**
  String avisoCitaCuerpoConLugar(String cita, String hora, String lugar);

  /// Botón de los avisos de tomas. {minutos} es lo elegido en Ajustes → Repetir los avisos: 5, 10, 15 o 30.
  ///
  /// In es, this message translates to:
  /// **'Recordar en {minutos} min'**
  String avisoAplazar(int minutos);

  /// No description provided for @avisoPruebaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Aviso de prueba'**
  String get avisoPruebaTitulo;

  /// No description provided for @avisoPruebaCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Así te avisaremos de tus medicinas y de tus citas.'**
  String get avisoPruebaCuerpo;

  /// No description provided for @vozMedicamento.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}.'**
  String vozMedicamento(String medicamento);

  /// No description provided for @vozMedicamentoConDosis.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}, {dosis}.'**
  String vozMedicamentoConDosis(String medicamento, String dosis);

  /// Se lee al abrir un aviso de toma. {detalle} es, por ejemplo, «Paracetamol, 1 pastilla. Con el desayuno.» y {boton}, el texto del botón «Ya la he tomado».
  ///
  /// In es, this message translates to:
  /// **'Medicina de las {hora}: {detalle} Cuando la tomes, pulsa: {boton}.'**
  String vozToma(String hora, String detalle, String boton);

  /// No description provided for @vozCita.
  ///
  /// In es, this message translates to:
  /// **'Tienes una cita: {cita}, {cuando}.'**
  String vozCita(String cita, String cuando);

  /// No description provided for @vozCitaConLugar.
  ///
  /// In es, this message translates to:
  /// **'Tienes una cita: {cita}, {cuando}, en {lugar}.'**
  String vozCitaConLugar(String cita, String cuando, String lugar);

  /// No description provided for @vozSinTomas.
  ///
  /// In es, this message translates to:
  /// **'Hoy no tienes ninguna toma.'**
  String get vozSinTomas;

  /// No description provided for @vozTotalTomas.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{una toma} other{{cantidad} tomas}}'**
  String vozTotalTomas(int cantidad);

  /// No description provided for @vozTodasTomadas.
  ///
  /// In es, this message translates to:
  /// **'Hoy tienes {total} y ya las has tomado todas.'**
  String vozTodasTomadas(String total);

  /// No description provided for @vozHasTomado.
  ///
  /// In es, this message translates to:
  /// **'Hoy tienes {total}. Has tomado {tomadas}.'**
  String vozHasTomado(String total, String tomadas);

  /// No description provided for @vozTeFaltan.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{Te falta: {lista}} other{Te faltan: {lista}}}'**
  String vozTeFaltan(int cantidad, String lista);

  /// No description provided for @vozNombreConDosis.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}, {dosis}'**
  String vozNombreConDosis(String medicamento, String dosis);

  /// No description provided for @vozFaltanteSinMarcar.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}, de las {hora}, sin marcar.'**
  String vozFaltanteSinMarcar(String medicamento, String hora);

  /// No description provided for @vozFaltanteAplazada.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}, de las {hora}, aplazada.'**
  String vozFaltanteAplazada(String medicamento, String hora);

  /// No description provided for @vozFaltantePendiente.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}, a las {hora}.'**
  String vozFaltantePendiente(String medicamento, String hora);

  /// No description provided for @vozHasDictado.
  ///
  /// In es, this message translates to:
  /// **'Has dictado: {texto}. Si no es correcto, vuelve a dictarlo o corrígelo con el teclado.'**
  String vozHasDictado(String texto);

  /// No description provided for @vozNoPuedeDictar.
  ///
  /// In es, this message translates to:
  /// **'Este teléfono no permite dictar. Escríbelo con el teclado.'**
  String get vozNoPuedeDictar;

  /// No description provided for @vozDictarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Dilo en voz alta y se escribirá solo.'**
  String get vozDictarDescripcion;

  /// No description provided for @respuestaAplazada.
  ///
  /// In es, this message translates to:
  /// **'Te lo recordaremos a las {hora}.'**
  String respuestaAplazada(String hora);

  /// No description provided for @respuestaSinMedicamento.
  ///
  /// In es, this message translates to:
  /// **'Ese medicamento ya no está registrado.'**
  String get respuestaSinMedicamento;

  /// No description provided for @estadoAvisosListos.
  ///
  /// In es, this message translates to:
  /// **'Los avisos están listos para llegar a su hora.'**
  String get estadoAvisosListos;

  /// No description provided for @estadoAvisosSinPermiso.
  ///
  /// In es, this message translates to:
  /// **'El teléfono no deja a esta aplicación mostrar avisos, así que no llegarán.'**
  String get estadoAvisosSinPermiso;

  /// No description provided for @estadoAvisosSinHoraExacta.
  ///
  /// In es, this message translates to:
  /// **'Falta el permiso de hora exacta: los avisos pueden llegar unos minutos tarde.'**
  String get estadoAvisosSinHoraExacta;

  /// No description provided for @estadoAvisosAhorroBateria.
  ///
  /// In es, this message translates to:
  /// **'El ahorro de batería del teléfono puede retrasar los avisos o impedir que lleguen.'**
  String get estadoAvisosAhorroBateria;

  /// No description provided for @estadoAvisosBotonPermiso.
  ///
  /// In es, this message translates to:
  /// **'Dar permiso para los avisos'**
  String get estadoAvisosBotonPermiso;

  /// No description provided for @estadoAvisosBotonHoraExacta.
  ///
  /// In es, this message translates to:
  /// **'Dar permiso de hora exacta'**
  String get estadoAvisosBotonHoraExacta;

  /// No description provided for @estadoAvisosBotonBateria.
  ///
  /// In es, this message translates to:
  /// **'Quitar el ahorro de batería'**
  String get estadoAvisosBotonBateria;

  /// No description provided for @estadoAvisosPermisoConcedido.
  ///
  /// In es, this message translates to:
  /// **'Listo: los avisos ya pueden llegar.'**
  String get estadoAvisosPermisoConcedido;

  /// No description provided for @bateriaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Ahorro de batería'**
  String get bateriaTitulo;

  /// "Batería", "Uso de batería" y "Sin restricciones" son los nombres de Android en ese idioma.
  ///
  /// In es, this message translates to:
  /// **'Algunos teléfonos cierran las aplicaciones para ahorrar batería, y entonces los avisos llegan tarde o no llegan.\n\nSi pulsas \"{boton}\", se abrirá la pantalla de esta aplicación en los ajustes del teléfono. Toca \"Batería\" (o \"Uso de batería\"), elige \"Sin restricciones\" y vuelve con el botón Atrás.'**
  String bateriaMensaje(String boton);

  /// No description provided for @bateriaAbrir.
  ///
  /// In es, this message translates to:
  /// **'Abrir los ajustes'**
  String get bateriaAbrir;

  /// No description provided for @menuAvisosSinPermiso.
  ///
  /// In es, this message translates to:
  /// **'Los avisos no pueden llegar: el teléfono no da permiso a esta aplicación.'**
  String get menuAvisosSinPermiso;

  /// No description provided for @formularioRecuperado.
  ///
  /// In es, this message translates to:
  /// **'Hemos recuperado lo que estabas escribiendo.'**
  String get formularioRecuperado;

  /// No description provided for @formularioRecuperadoConFoto.
  ///
  /// In es, this message translates to:
  /// **'Hemos recuperado lo que estabas escribiendo y la foto. Se guardará al pulsar \"{boton}\".'**
  String formularioRecuperadoConFoto(String boton);

  /// Fecha sin el año, por ejemplo: domingo, 25 de octubre.
  ///
  /// In es, this message translates to:
  /// **'{diaSemana}, {dia} de {mes}'**
  String fechaCorta(String diaSemana, String dia, String mes);

  /// Cuando las horas se eligen una a una (sin frecuencia fija).
  ///
  /// In es, this message translates to:
  /// **'{tomas, plural, =1{1 toma al día} other{{tomas} tomas al día}}'**
  String horarioDescripcionLibre(int tomas);

  /// Días de la semana en plural, para «los lunes», «los sábados»…
  ///
  /// In es, this message translates to:
  /// **'lunes'**
  String get semanaLunes;

  /// No description provided for @semanaMartes.
  ///
  /// In es, this message translates to:
  /// **'martes'**
  String get semanaMartes;

  /// No description provided for @semanaMiercoles.
  ///
  /// In es, this message translates to:
  /// **'miércoles'**
  String get semanaMiercoles;

  /// No description provided for @semanaJueves.
  ///
  /// In es, this message translates to:
  /// **'jueves'**
  String get semanaJueves;

  /// No description provided for @semanaViernes.
  ///
  /// In es, this message translates to:
  /// **'viernes'**
  String get semanaViernes;

  /// No description provided for @semanaSabado.
  ///
  /// In es, this message translates to:
  /// **'sábados'**
  String get semanaSabado;

  /// No description provided for @semanaDomingo.
  ///
  /// In es, this message translates to:
  /// **'domingos'**
  String get semanaDomingo;

  /// Para meterlo en una frase: «Te avisaremos los lunes y jueves a las 09:00».
  ///
  /// In es, this message translates to:
  /// **'los {dias}'**
  String diasSemanaFrase(String dias);

  /// Por ejemplo: «cada 2 días, empezando el domingo, 25 de octubre».
  ///
  /// In es, this message translates to:
  /// **'cada {cada} días, empezando el {fecha}'**
  String diasCadaFrase(String cada, String fecha);

  /// No description provided for @validadorMedicamentoHorasRepetidas.
  ///
  /// In es, this message translates to:
  /// **'Hay dos tomas a la misma hora. Cambia una de ellas.'**
  String get validadorMedicamentoHorasRepetidas;

  /// No description provided for @validadorMedicamentoSinDias.
  ///
  /// In es, this message translates to:
  /// **'Elige al menos un día de la semana.'**
  String get validadorMedicamentoSinDias;

  /// No description provided for @validadorMedicamentoCadaDias.
  ///
  /// In es, this message translates to:
  /// **'Elige cada cuántos días lo tomas: entre {minimo} y {maximo}.'**
  String validadorMedicamentoCadaDias(String minimo, String maximo);

  /// No description provided for @formularioMedicamentoHorasTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿A qué horas lo tomas?'**
  String get formularioMedicamentoHorasTitulo;

  /// No description provided for @formularioMedicamentoHorasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Elige cómo se reparten las tomas a lo largo del día.'**
  String get formularioMedicamentoHorasDescripcion;

  /// No description provided for @formularioMedicamentoRepartidas.
  ///
  /// In es, this message translates to:
  /// **'Repartidas por igual'**
  String get formularioMedicamentoRepartidas;

  /// No description provided for @formularioMedicamentoRepartidasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cada cierto número de horas, desde la primera toma.'**
  String get formularioMedicamentoRepartidasDescripcion;

  /// No description provided for @formularioMedicamentoConcretas.
  ///
  /// In es, this message translates to:
  /// **'A horas concretas'**
  String get formularioMedicamentoConcretas;

  /// No description provided for @formularioMedicamentoConcretasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo, con el desayuno, la comida y la cena.'**
  String get formularioMedicamentoConcretasDescripcion;

  /// Título del selector de hora de cada toma, con horas concretas: «Toma 1», «Toma 2»…
  ///
  /// In es, this message translates to:
  /// **'Toma {numero}'**
  String formularioMedicamentoHoraToma(String numero);

  /// No description provided for @formularioMedicamentoHoraUnaToma.
  ///
  /// In es, this message translates to:
  /// **'Hora de la toma'**
  String get formularioMedicamentoHoraUnaToma;

  /// No description provided for @formularioMedicamentoHoraUnaTomaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿A qué hora lo tomas?'**
  String get formularioMedicamentoHoraUnaTomaDescripcion;

  /// No description provided for @formularioMedicamentoDiasTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Qué días lo tomas?'**
  String get formularioMedicamentoDiasTitulo;

  /// No description provided for @formularioMedicamentoDiasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Elige si lo tomas a diario o solo algunos días.'**
  String get formularioMedicamentoDiasDescripcion;

  /// No description provided for @formularioMedicamentoTodosLosDias.
  ///
  /// In es, this message translates to:
  /// **'Todos los días'**
  String get formularioMedicamentoTodosLosDias;

  /// No description provided for @formularioMedicamentoTodosLosDiasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cada día, sin saltarse ninguno.'**
  String get formularioMedicamentoTodosLosDiasDescripcion;

  /// No description provided for @formularioMedicamentoAlgunosDias.
  ///
  /// In es, this message translates to:
  /// **'Algunos días de la semana'**
  String get formularioMedicamentoAlgunosDias;

  /// No description provided for @formularioMedicamentoAlgunosDiasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo, una pastilla que se toma los lunes.'**
  String get formularioMedicamentoAlgunosDiasDescripcion;

  /// No description provided for @formularioMedicamentoCadaVariosDias.
  ///
  /// In es, this message translates to:
  /// **'Cada varios días'**
  String get formularioMedicamentoCadaVariosDias;

  /// No description provided for @formularioMedicamentoCadaVariosDiasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo, un día sí y otro no.'**
  String get formularioMedicamentoCadaVariosDiasDescripcion;

  /// No description provided for @formularioMedicamentoCadaCuantosDias.
  ///
  /// In es, this message translates to:
  /// **'Cada cuántos días'**
  String get formularioMedicamentoCadaCuantosDias;

  /// No description provided for @formularioMedicamentoCadaDiasValor.
  ///
  /// In es, this message translates to:
  /// **'Cada {dias} días'**
  String formularioMedicamentoCadaDiasValor(String dias);

  /// No description provided for @formularioMedicamentoDiaMenos.
  ///
  /// In es, this message translates to:
  /// **'Un día menos entre tomas'**
  String get formularioMedicamentoDiaMenos;

  /// No description provided for @formularioMedicamentoDiaMas.
  ///
  /// In es, this message translates to:
  /// **'Un día más entre tomas'**
  String get formularioMedicamentoDiaMas;

  /// No description provided for @formularioMedicamentoPrimerDia.
  ///
  /// In es, this message translates to:
  /// **'Primer día'**
  String get formularioMedicamentoPrimerDia;

  /// No description provided for @formularioMedicamentoPrimerDiaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'El primer día que lo tomas.'**
  String get formularioMedicamentoPrimerDiaDescripcion;

  /// Por ejemplo: «Te avisaremos a las 08:00 los lunes y jueves.» {dias} viene de diasSemanaFrase o diasCadaFrase.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos a las {horas} {dias}.'**
  String formularioMedicamentoAvisoDias(String dias, String horas);

  /// No description provided for @formularioMedicamentoAvisoDiasHasta.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos a las {horas} {dias}, hasta el {fecha}, incluido.'**
  String formularioMedicamentoAvisoDiasHasta(
    String dias,
    String horas,
    String fecha,
  );

  /// Para las medicinas que no se toman todos los días (la línea de arriba ya dice cuáles).
  ///
  /// In es, this message translates to:
  /// **'Sin fecha de fin'**
  String get medicamentoSinFechaDeFinSolo;

  /// En la lista y en el PDF, en lugar de las tomas al día de un medicamento que no tiene horario.
  ///
  /// In es, this message translates to:
  /// **'Cuando haga falta, sin avisos'**
  String get medicamentoADemanda;

  /// Parte de «Como mucho 3 veces al día, con al menos 6 horas entre una y otra.» Empieza en minúscula: la app pone la mayúscula.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{como mucho 1 vez al día} other{como mucho {n} veces al día}}'**
  String limitesMaximo(int n);

  /// Parte de «Como mucho 3 veces al día, con al menos 6 horas entre una y otra.» (o sola, con mayúscula).
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{con al menos 1 hora entre una y otra} other{con al menos {n} horas entre una y otra}}'**
  String limitesHoras(int n);

  /// No description provided for @formularioMedicamentoCuandoTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo lo tomas?'**
  String get formularioMedicamentoCuandoTitulo;

  /// No description provided for @formularioMedicamentoCuandoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Elige si tiene un horario o si lo tomas solo cuando lo necesitas.'**
  String get formularioMedicamentoCuandoDescripcion;

  /// No description provided for @formularioMedicamentoConHorario.
  ///
  /// In es, this message translates to:
  /// **'Con un horario'**
  String get formularioMedicamentoConHorario;

  /// No description provided for @formularioMedicamentoConHorarioDescripcion.
  ///
  /// In es, this message translates to:
  /// **'A sus horas. Te avisaremos de cada toma.'**
  String get formularioMedicamentoConHorarioDescripcion;

  /// No description provided for @formularioMedicamentoADemanda.
  ///
  /// In es, this message translates to:
  /// **'Solo cuando haga falta'**
  String get formularioMedicamentoADemanda;

  /// {pantalla} es el título de la pantalla "Tomas de hoy".
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo, un calmante para el dolor. No hay avisos: cuando lo tomes, lo anotas en \"{pantalla}\".'**
  String formularioMedicamentoADemandaDescripcion(String pantalla);

  /// No description provided for @formularioMedicamentoLimitesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Cuánto se puede tomar (opcional)'**
  String get formularioMedicamentoLimitesTitulo;

  /// No description provided for @formularioMedicamentoLimitesDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Lo que diga el prospecto o tu médico. Si al anotar una toma te pasas, la aplicación te avisa.'**
  String get formularioMedicamentoLimitesDescripcion;

  /// No description provided for @formularioMedicamentoMaximoAlDia.
  ///
  /// In es, this message translates to:
  /// **'Como mucho, veces al día'**
  String get formularioMedicamentoMaximoAlDia;

  /// No description provided for @formularioMedicamentoSinLimite.
  ///
  /// In es, this message translates to:
  /// **'Sin límite'**
  String get formularioMedicamentoSinLimite;

  /// No description provided for @formularioMedicamentoVeces.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 vez} other{{n} veces}}'**
  String formularioMedicamentoVeces(int n);

  /// No description provided for @formularioMedicamentoVezMenos.
  ///
  /// In es, this message translates to:
  /// **'Una vez menos al día'**
  String get formularioMedicamentoVezMenos;

  /// No description provided for @formularioMedicamentoVezMas.
  ///
  /// In es, this message translates to:
  /// **'Una vez más al día'**
  String get formularioMedicamentoVezMas;

  /// No description provided for @formularioMedicamentoHorasEntreTomas.
  ///
  /// In es, this message translates to:
  /// **'Horas entre una toma y otra, como mínimo'**
  String get formularioMedicamentoHorasEntreTomas;

  /// No description provided for @formularioMedicamentoSinMinimo.
  ///
  /// In es, this message translates to:
  /// **'Sin mínimo'**
  String get formularioMedicamentoSinMinimo;

  /// No description provided for @formularioMedicamentoHorasValor.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 hora} other{{n} horas}}'**
  String formularioMedicamentoHorasValor(int n);

  /// Resumen del formulario. {pantalla} es el título de la pantalla "Tomas de hoy".
  ///
  /// In es, this message translates to:
  /// **'Sin avisos. Cuando lo tomes, anótalo en \"{pantalla}\".'**
  String formularioMedicamentoAvisoADemanda(String pantalla);

  /// Resumen del formulario con fecha de fin. {pantalla} es el título de la pantalla "Tomas de hoy".
  ///
  /// In es, this message translates to:
  /// **'Sin avisos. Podrás anotarlo en \"{pantalla}\" hasta el {fecha}, incluido.'**
  String formularioMedicamentoAvisoADemandaHasta(String pantalla, String fecha);

  /// Mensaje al guardar un medicamento que no tiene horario.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}: cuando haga falta, sin avisos.'**
  String formularioMedicamentoResumenADemanda(String medicamento);

  /// No description provided for @tomasADemandaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Cuando haga falta'**
  String get tomasADemandaTitulo;

  /// No description provided for @tomasADemandaExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Si tomas alguno, pulsa \"{boton}\" para anotarlo.'**
  String tomasADemandaExplicacion(String boton);

  /// No description provided for @tomasADemandaMarcar.
  ///
  /// In es, this message translates to:
  /// **'Lo he tomado ahora'**
  String get tomasADemandaMarcar;

  /// No description provided for @tomasADemandaMarcarSemantica.
  ///
  /// In es, this message translates to:
  /// **'He tomado {medicamento} ahora'**
  String tomasADemandaMarcarSemantica(String medicamento);

  /// No description provided for @tomasADemandaNingunaHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy no lo has tomado'**
  String get tomasADemandaNingunaHoy;

  /// No description provided for @tomasADemandaMaximo.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Hoy ya lo has tomado la vez que se puede} other{Hoy ya lo has tomado las {n} veces que se puede}}'**
  String tomasADemandaMaximo(int n);

  /// No description provided for @tomasADemandaProximaHoy.
  ///
  /// In es, this message translates to:
  /// **'La próxima, a partir de las {hora}'**
  String tomasADemandaProximaHoy(String hora);

  /// No description provided for @tomasADemandaProximaManana.
  ///
  /// In es, this message translates to:
  /// **'La próxima, mañana a partir de las {hora}'**
  String tomasADemandaProximaManana(String hora);

  /// Título del aviso al pulsar «Lo he tomado ahora» si se pasa del máximo al día o es antes de tiempo.
  ///
  /// In es, this message translates to:
  /// **'Es más de lo que se puede'**
  String get tomasADemandaAvisoTitulo;

  /// No description provided for @tomasADemandaAvisoMaximo.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Hoy ya has tomado {medicamento} 1 vez, que es el máximo al día.} other{Hoy ya has tomado {medicamento} {n} veces, que es el máximo al día.}}'**
  String tomasADemandaAvisoMaximo(int n, String medicamento);

  /// No description provided for @tomasADemandaAvisoPronto.
  ///
  /// In es, this message translates to:
  /// **'{horas, plural, =1{Entre una toma de {medicamento} y otra tiene que pasar al menos 1 hora.} other{Entre una toma de {medicamento} y otra tienen que pasar al menos {horas} horas.}}'**
  String tomasADemandaAvisoPronto(int horas, String medicamento);

  /// No description provided for @tomasADemandaAvisoConsejo.
  ///
  /// In es, this message translates to:
  /// **'Si tienes dudas, pregunta a tu médico o farmacéutico. ¿Lo anotas igualmente?'**
  String get tomasADemandaAvisoConsejo;

  /// No description provided for @tomasADemandaAvisoSi.
  ///
  /// In es, this message translates to:
  /// **'Sí, lo he tomado'**
  String get tomasADemandaAvisoSi;

  /// No description provided for @tomasADemandaAvisoNo.
  ///
  /// In es, this message translates to:
  /// **'No, no lo anoto'**
  String get tomasADemandaAvisoNo;

  /// {horas} es la lista de horas, por ejemplo "08:10 y 14:30".
  ///
  /// In es, this message translates to:
  /// **'{veces, plural, =1{Hoy lo has tomado a las {horas}} other{Hoy lo has tomado {veces} veces: a las {horas}}}'**
  String tomasADemandaHoy(int veces, String horas);

  /// No description provided for @historialADemanda.
  ///
  /// In es, this message translates to:
  /// **'{hora} · {medicamento}: tomada cuando hacía falta'**
  String historialADemanda(String hora, String medicamento);

  /// No description provided for @informeADemanda.
  ///
  /// In es, this message translates to:
  /// **'Cuando hacía falta:'**
  String get informeADemanda;

  /// {dia} es como "Hoy 25/10"; {tomas}, como "Paracetamol a las 08:10 y 14:30".
  ///
  /// In es, this message translates to:
  /// **'{dia}: {tomas}.'**
  String informeADemandaDia(String dia, String tomas);

  /// No description provided for @informeADemandaTomas.
  ///
  /// In es, this message translates to:
  /// **'{medicamento} a las {horas}'**
  String informeADemandaTomas(String medicamento, String horas);

  /// Botón para borrar la última toma anotada de un medicamento "cuando haga falta", si se anotó por error.
  ///
  /// In es, this message translates to:
  /// **'Quitar la última'**
  String get tomasADemandaQuitar;

  /// No description provided for @tomasADemandaQuitarSemantica.
  ///
  /// In es, this message translates to:
  /// **'Quitar la toma de {medicamento} de las {hora}'**
  String tomasADemandaQuitarSemantica(String medicamento, String hora);

  /// Botón del formulario para un medicamento nuevo "cuando haga falta": no crea ningún recordatorio.
  ///
  /// In es, this message translates to:
  /// **'Guardar medicamento'**
  String get formularioMedicamentoGuardar;

  /// Pastillas que quedan de un medicamento (también cápsulas o sobres).
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =0{No quedan pastillas} =1{Queda 1 pastilla} other{Quedan {cantidad} pastillas}}'**
  String existenciasQuedan(int cantidad);

  /// No description provided for @existenciasPastillas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 pastilla} other{{n} pastillas}}'**
  String existenciasPastillas(int n);

  /// {n} es la parte entera: 0 es media pastilla; 14, catorce pastillas y media.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =0{media pastilla} =1{1 pastilla y media} other{{n} pastillas y media}}'**
  String existenciasPastillasYMedia(int n);

  /// Media pastilla, en el selector de las pastillas de cada toma.
  ///
  /// In es, this message translates to:
  /// **'media'**
  String get existenciasMedia;

  /// En el selector: «1 y media».
  ///
  /// In es, this message translates to:
  /// **'{n} y media'**
  String existenciasYMedia(String n);

  /// No description provided for @existenciasQuedanYMedia.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =0{Queda media pastilla} =1{Queda 1 pastilla y media} other{Quedan {n} pastillas y media}}'**
  String existenciasQuedanYMedia(int n);

  /// Va detrás de existenciasQuedan: "Quedan 20 pastillas, para unos 20 días".
  ///
  /// In es, this message translates to:
  /// **'{dias, plural, =1{para 1 día} other{para unos {dias} días}}'**
  String existenciasParaDias(int dias);

  /// No description provided for @existenciasHastaElFinal.
  ///
  /// In es, this message translates to:
  /// **'suficientes hasta el final del tratamiento'**
  String get existenciasHastaElFinal;

  /// {quedan} es existenciasQuedan; {detalle}, existenciasParaDias o existenciasHastaElFinal.
  ///
  /// In es, this message translates to:
  /// **'{quedan}, {detalle}'**
  String existenciasConDetalle(String quedan, String detalle);

  /// No description provided for @avisoExistenciasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Te quedan pocas pastillas'**
  String get avisoExistenciasTitulo;

  /// No description provided for @avisoRecetaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Renueva la receta'**
  String get avisoRecetaTitulo;

  /// No description provided for @avisoRecetaCuerpo.
  ///
  /// In es, this message translates to:
  /// **'La receta de {medicamento} se acaba el {fecha}. Pide cita con tu médico para renovarla.'**
  String avisoRecetaCuerpo(String medicamento, String fecha);

  /// No description provided for @avisoRecetaCuerpoHoy.
  ///
  /// In es, this message translates to:
  /// **'La receta de {medicamento} se acaba hoy. Pide cita con tu médico para renovarla.'**
  String avisoRecetaCuerpoHoy(String medicamento);

  /// No description provided for @avisoRecetaCuerpoAcabada.
  ///
  /// In es, this message translates to:
  /// **'La receta de {medicamento} se acabó el {fecha}. Pide cita con tu médico para renovarla.'**
  String avisoRecetaCuerpoAcabada(String medicamento, String fecha);

  /// No description provided for @avisoExistenciasSemana.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}: no llegan para una semana. Cuando compres más, pulsa \"{boton}\" en tus medicamentos.'**
  String avisoExistenciasSemana(String medicamento, String boton);

  /// Aviso de un medicamento "cuando haga falta" del que quedan pocas.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{{medicamento}: queda 1. Cuando compres más, pulsa \"{boton}\" en tus medicamentos.} other{{medicamento}: quedan {cantidad}. Cuando compres más, pulsa \"{boton}\" en tus medicamentos.}}'**
  String avisoExistenciasQuedan(int cantidad, String medicamento, String boton);

  /// No description provided for @avisoExistenciasQuedanYMedia.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =0{{medicamento}: queda media. Cuando compres más, pulsa \"{boton}\" en tus medicamentos.} =1{{medicamento}: queda 1 y media. Cuando compres más, pulsa \"{boton}\" en tus medicamentos.} other{{medicamento}: quedan {n} y media. Cuando compres más, pulsa \"{boton}\" en tus medicamentos.}}'**
  String avisoExistenciasQuedanYMedia(int n, String medicamento, String boton);

  /// No description provided for @avisoExistenciasAcabadas.
  ///
  /// In es, this message translates to:
  /// **'{medicamento}: ya no quedan. Cuando compres más, pulsa \"{boton}\" en tus medicamentos.'**
  String avisoExistenciasAcabadas(String medicamento, String boton);

  /// No description provided for @medicamentoExistenciasPocas.
  ///
  /// In es, this message translates to:
  /// **'Quedan pocas. Cuando compres más, pulsa \"{boton}\".'**
  String medicamentoExistenciasPocas(String boton);

  /// No description provided for @medicamentoComprarMas.
  ///
  /// In es, this message translates to:
  /// **'He comprado más'**
  String get medicamentoComprarMas;

  /// No description provided for @medicamentoComprarMasSemantica.
  ///
  /// In es, this message translates to:
  /// **'He comprado más {medicamento}'**
  String medicamentoComprarMasSemantica(String medicamento);

  /// {medicamentos} es la lista de nombres, por ejemplo "Omeprazol y Paracetamol".
  ///
  /// In es, this message translates to:
  /// **'Te quedan pocas pastillas de {medicamentos}.'**
  String menuExistenciasPocas(String medicamentos);

  /// {medicamentos} es una lista, por ejemplo «Omeprazol y Enalapril».
  ///
  /// In es, this message translates to:
  /// **'Hay que renovar la receta de {medicamentos}.'**
  String menuRecetas(String medicamentos);

  /// No description provided for @formularioMedicamentoExistenciasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Pastillas que te quedan (opcional)'**
  String get formularioMedicamentoExistenciasTitulo;

  /// No description provided for @formularioMedicamentoExistenciasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Si quieres, la aplicación las cuenta y te avisa antes de que se acaben.'**
  String get formularioMedicamentoExistenciasDescripcion;

  /// No description provided for @formularioMedicamentoSinCuenta.
  ///
  /// In es, this message translates to:
  /// **'No llevar la cuenta'**
  String get formularioMedicamentoSinCuenta;

  /// No description provided for @formularioMedicamentoSinCuentaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'No te avisaremos de cuántas quedan.'**
  String get formularioMedicamentoSinCuentaDescripcion;

  /// No description provided for @formularioMedicamentoConCuenta.
  ///
  /// In es, this message translates to:
  /// **'Llevar la cuenta'**
  String get formularioMedicamentoConCuenta;

  /// No description provided for @formularioMedicamentoConCuentaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cada toma se descuenta y te avisaremos cuando queden pocas.'**
  String get formularioMedicamentoConCuentaDescripcion;

  /// No description provided for @formularioMedicamentoExistenciasCampo.
  ///
  /// In es, this message translates to:
  /// **'Pastillas que tienes ahora'**
  String get formularioMedicamentoExistenciasCampo;

  /// No description provided for @formularioMedicamentoExistenciasCampoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cuéntalas, o pon las de la caja si está sin empezar. Si queda media, escribe por ejemplo 14,5. Vale también para cápsulas o sobres.'**
  String get formularioMedicamentoExistenciasCampoDescripcion;

  /// No description provided for @formularioMedicamentoPorToma.
  ///
  /// In es, this message translates to:
  /// **'Pastillas en cada toma'**
  String get formularioMedicamentoPorToma;

  /// No description provided for @formularioMedicamentoPorTomaValor.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 pastilla en cada toma} other{{n} pastillas en cada toma}}'**
  String formularioMedicamentoPorTomaValor(int n);

  /// No description provided for @formularioMedicamentoPorTomaYMedia.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =0{media pastilla en cada toma} =1{1 pastilla y media en cada toma} other{{n} pastillas y media en cada toma}}'**
  String formularioMedicamentoPorTomaYMedia(int n);

  /// No description provided for @formularioMedicamentoPorTomaMenos.
  ///
  /// In es, this message translates to:
  /// **'Media pastilla menos en cada toma'**
  String get formularioMedicamentoPorTomaMenos;

  /// No description provided for @formularioMedicamentoPorTomaMas.
  ///
  /// In es, this message translates to:
  /// **'Media pastilla más en cada toma'**
  String get formularioMedicamentoPorTomaMas;

  /// No description provided for @formularioMedicamentoPorTomaDeLas.
  ///
  /// In es, this message translates to:
  /// **'Pastillas en la toma de las {hora}'**
  String formularioMedicamentoPorTomaDeLas(String hora);

  /// No description provided for @formularioMedicamentoPorTomaDeLasMenos.
  ///
  /// In es, this message translates to:
  /// **'Media pastilla menos a las {hora}'**
  String formularioMedicamentoPorTomaDeLasMenos(String hora);

  /// No description provided for @formularioMedicamentoPorTomaDeLasMas.
  ///
  /// In es, this message translates to:
  /// **'Media pastilla más a las {hora}'**
  String formularioMedicamentoPorTomaDeLasMas(String hora);

  /// No description provided for @validadorMedicamentoExistencias.
  ///
  /// In es, this message translates to:
  /// **'Escribe cuántas pastillas tienes: un número entre 0 y {maximo}. Si hay media, con coma: 14,5.'**
  String validadorMedicamentoExistencias(String maximo);

  /// No description provided for @comprarCampo.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas has comprado?'**
  String get comprarCampo;

  /// No description provided for @comprarCampoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Mira cuántas trae la caja; por ejemplo, 28.'**
  String get comprarCampoDescripcion;

  /// {pastillas} es como «31 pastillas» o «14 pastillas y media».
  ///
  /// In es, this message translates to:
  /// **'Tendrás {pastillas}.'**
  String comprarTendras(String pastillas);

  /// No description provided for @comprarAnadir.
  ///
  /// In es, this message translates to:
  /// **'Añadir a las que tengo'**
  String get comprarAnadir;

  /// No description provided for @comprarError.
  ///
  /// In es, this message translates to:
  /// **'Escribe cuántas has comprado: un número entre 1 y {maximo}.'**
  String comprarError(String maximo);

  /// No description provided for @comprarHechoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Pastillas añadidas'**
  String get comprarHechoTitulo;

  /// No description provided for @recetaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Receta renovada'**
  String get recetaTitulo;

  /// No description provided for @recetaPregunta.
  ///
  /// In es, this message translates to:
  /// **'¿Hasta qué día es la receta nueva?'**
  String get recetaPregunta;

  /// No description provided for @recetaGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar la fecha nueva'**
  String get recetaGuardar;

  /// No description provided for @recetaQuitar.
  ///
  /// In es, this message translates to:
  /// **'Ya no hace falta renovarla'**
  String get recetaQuitar;

  /// No description provided for @recetaQuitarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Quita la fecha: no te avisaremos más de esta receta.'**
  String get recetaQuitarDescripcion;

  /// No description provided for @recetaGuardada.
  ///
  /// In es, this message translates to:
  /// **'Receta de {medicamento}: hasta el {fecha}.'**
  String recetaGuardada(String medicamento, String fecha);

  /// No description provided for @recetaQuitada.
  ///
  /// In es, this message translates to:
  /// **'Ya no te avisaremos de la receta de {medicamento}.'**
  String recetaQuitada(String medicamento);

  /// {pastillas} es como «31 pastillas» o «14 pastillas y media».
  ///
  /// In es, this message translates to:
  /// **'Ahora tienes {pastillas} de {medicamento}.'**
  String comprarHecho(String pastillas, String medicamento);

  /// No description provided for @compartirDeOtroMovil.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos preparados en otro móvil'**
  String get compartirDeOtroMovil;

  /// {boton} es el texto del botón compartirEnviarCopia.
  ///
  /// In es, this message translates to:
  /// **'Un familiar puede apuntar tus medicinas y tus citas en su teléfono, con esta misma aplicación, y mandarte una copia con \"{boton}\". Aquí las añades sin borrar nada de lo que ya tienes.'**
  String compartirDeOtroMovilExplicacion(String boton);

  /// No description provided for @compartirImportar.
  ///
  /// In es, this message translates to:
  /// **'Añadir medicamentos de otro móvil'**
  String get compartirImportar;

  /// No description provided for @compartirImportarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Elige la copia que te han enviado. Antes te dirá qué añade.'**
  String get compartirImportarDescripcion;

  /// No description provided for @importarNoSePuede.
  ///
  /// In es, this message translates to:
  /// **'No se pueden añadir los medicamentos de este fichero'**
  String get importarNoSePuede;

  /// No description provided for @importarPregunta.
  ///
  /// In es, this message translates to:
  /// **'¿Añadir lo que trae esta copia?'**
  String get importarPregunta;

  /// No description provided for @importarCopiaDel.
  ///
  /// In es, this message translates to:
  /// **'Copia del {fecha}, a las {hora}.'**
  String importarCopiaDel(String fecha, String hora);

  /// No description provided for @importarSeAnadiran.
  ///
  /// In es, this message translates to:
  /// **'Se añadirán: {medicamentos}.'**
  String importarSeAnadiran(String medicamentos);

  /// No description provided for @importarSeActualizaran.
  ///
  /// In es, this message translates to:
  /// **'{cuantos, plural, =1{Ya tenías {medicamentos}: se pondrá como en la copia, sin perder las tomas anotadas.} other{Ya tenías {medicamentos}: se pondrán como en la copia, sin perder las tomas anotadas.}}'**
  String importarSeActualizaran(int cuantos, String medicamentos);

  /// No description provided for @importarCitas.
  ///
  /// In es, this message translates to:
  /// **'Citas nuevas: {citas}.'**
  String importarCitas(String citas);

  /// No description provided for @importarNoSeBorra.
  ///
  /// In es, this message translates to:
  /// **'No se borra nada: tus tomas anotadas y tus ajustes se quedan como están.'**
  String get importarNoSeBorra;

  /// No description provided for @importarSi.
  ///
  /// In es, this message translates to:
  /// **'Sí, añadir'**
  String get importarSi;

  /// No description provided for @importarNadaNuevo.
  ///
  /// In es, this message translates to:
  /// **'No hay nada que añadir'**
  String get importarNadaNuevo;

  /// No description provided for @importarNadaNuevoMensaje.
  ///
  /// In es, this message translates to:
  /// **'Esta copia no trae medicamentos ni citas que no tengas.'**
  String get importarNadaNuevoMensaje;

  /// No description provided for @importarHecho.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos añadidos'**
  String get importarHecho;

  /// No description provided for @importarError.
  ///
  /// In es, this message translates to:
  /// **'No se han podido añadir los medicamentos. Inténtalo otra vez.'**
  String get importarError;

  /// Solo cuentan las tomas cuya hora ya ha llegado.
  ///
  /// In es, this message translates to:
  /// **'En los últimos 7 días has marcado {tomadas} de {total} tomas ({porcentaje} %).'**
  String historialResumenSemana(
    String tomadas,
    String total,
    String porcentaje,
  );

  /// No description provided for @informeResumenSemana.
  ///
  /// In es, this message translates to:
  /// **'Marcadas {tomadas} de {total} tomas ({porcentaje} %).'**
  String informeResumenSemana(String tomadas, String total, String porcentaje);

  /// No description provided for @compartirRecordarResumen.
  ///
  /// In es, this message translates to:
  /// **'Recordarme enviarlo cada semana'**
  String get compartirRecordarResumen;

  /// No description provided for @compartirRecordarResumenDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Los domingos a las 18:00 te avisaremos para enviar tu medicación y tus tomas.'**
  String get compartirRecordarResumenDescripcion;

  /// No description provided for @avisoResumenTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Envías tu resumen a la familia?'**
  String get avisoResumenTitulo;

  /// {boton} es el texto del botón compartirEnviarInforme.
  ///
  /// In es, this message translates to:
  /// **'Toca aquí y pulsa \"{boton}\" para mandar tu medicación y tus tomas de la semana.'**
  String avisoResumenCuerpo(String boton);

  /// No description provided for @widgetTitulo.
  ///
  /// In es, this message translates to:
  /// **'Próxima toma'**
  String get widgetTitulo;

  /// No description provided for @widgetVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay más tomas previstas.'**
  String get widgetVacio;

  /// No description provided for @ajustesWidget.
  ///
  /// In es, this message translates to:
  /// **'Poner la próxima toma en la pantalla de inicio'**
  String get ajustesWidget;

  /// {boton} es el texto del botón tomasMarcar.
  ///
  /// In es, this message translates to:
  /// **'Un recuadro con la próxima toma y el botón \"{boton}\", sin abrir la aplicación.'**
  String ajustesWidgetDescripcion(String boton);

  /// Cuando el teléfono no sabe poner el widget por sí mismo. {app} es el nombre de la aplicación.
  ///
  /// In es, this message translates to:
  /// **'Mantén pulsado un hueco de la pantalla de inicio del teléfono, toca \"Widgets\" y busca \"{app}\".'**
  String ajustesWidgetManual(String app);
}

class _TextosAppDelegate extends LocalizationsDelegate<TextosApp> {
  const _TextosAppDelegate();

  @override
  Future<TextosApp> load(Locale locale) {
    return SynchronousFuture<TextosApp>(lookupTextosApp(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'es', 'eu', 'gl'].contains(locale.languageCode);

  @override
  bool shouldReload(_TextosAppDelegate old) => false;
}

TextosApp lookupTextosApp(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return TextosAppCa();
    case 'es':
      return TextosAppEs();
    case 'eu':
      return TextosAppEu();
    case 'gl':
      return TextosAppGl();
  }

  throw FlutterError(
    'TextosApp.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
