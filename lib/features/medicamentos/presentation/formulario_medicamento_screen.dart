import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/proveedores.dart';
import '../../../app/rutas.dart';
import '../../../core/tema/tema_visual.dart';
import '../../../core/tiempo/formato_fechas.dart';
import '../../../core/tiempo/hora_del_dia.dart';
import '../../../core/widgets/avisos.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/campo_texto.dart';
import '../../../core/widgets/dialogos.dart';
import '../../../core/widgets/mensaje_error.dart';
import '../../../core/widgets/opcion_seleccionable.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/parrafo.dart';
import '../../../core/widgets/selector_numerico.dart';
import '../../../core/widgets/selectores_tiempo.dart';
import '../../../core/widgets/tarjetas.dart';
import '../../../l10n/textos.dart';
import '../../../voz/boton_dictar.dart';
import '../../ajustes/application/ajustes_controller.dart';
import '../application/existencias_controller.dart';
import '../application/medicamentos_controller.dart';
import '../data/fotos.dart';
import '../domain/borrador_medicamento.dart';
import '../domain/dias_de_toma.dart';
import '../domain/existencias.dart';
import '../domain/horario_tomas.dart';
import '../domain/medicamento.dart';
import '../domain/validador_medicamento.dart';
import 'foto_caja.dart';

/// Pantalla 3: formulario para registrar un medicamento nuevo o, si se le
/// pasa [medicamento], para modificar uno ya guardado.
class FormularioMedicamentoScreen extends ConsumerStatefulWidget {
  const FormularioMedicamentoScreen({
    super.key,
    this.medicamento,
    this.borrador,
  });

  final Medicamento? medicamento;

  /// Lo que se había escrito antes de que Android cerrara la app con la
  /// cámara o la galería abiertas (ver [BorradorMedicamento]).
  final BorradorMedicamento? borrador;

  /// Duración que se propone al elegir "Hasta un día concreto".
  static const int diasTratamientoPropuestos = 7;

  /// Último día de la receta que se propone: dentro de un mes.
  static DateTime recetaPropuesta(DateTime hoy) =>
      SelectorFecha.sumarMeses(hoy, 1);

  @override
  ConsumerState<FormularioMedicamentoScreen> createState() =>
      _FormularioMedicamentoScreenState();
}

class _FormularioMedicamentoScreenState
    extends ConsumerState<FormularioMedicamentoScreen> {
  final _nombre = TextEditingController();
  final _dosis = TextEditingController();
  final _instrucciones = TextEditingController();
  final _claveNombre = GlobalKey();
  final _claveDosis = GlobalKey();
  final _claveDosisTomas = GlobalKey();
  final _claveFrecuencia = GlobalKey();
  final _claveHora = GlobalKey();
  final _claveDias = GlobalKey();
  final _claveDuracion = GlobalKey();
  final _claveExistencias = GlobalKey();
  final _existencias = TextEditingController();

  late final DateTime _hoy;

  /// "Solo cuando haga falta": sin tomas, horas ni días. Lo demás se conserva
  /// por si se vuelve a elegir un horario.
  bool _aDemanda = false;
  int _numTomas = 1;
  int _frecuenciaHoras = HorarioTomas.frecuenciaUnaToma;
  HoraDelDia _horaInicio = const HoraDelDia(8, 0);

  /// Con 2 tomas o más, si las horas se eligen una a una ([_horas], una por
  /// toma) en lugar de repartirse por igual.
  bool _horasConcretas = false;
  List<HoraDelDia> _horas = const [];

  _ModoDias _modoDias = _ModoDias.todos;
  Set<int> _diasSemana = const {};
  int _cadaDias = CadaVariosDias.minimo;
  late DateTime _desde;
  bool _conFechaFin = false;
  late DateTime _fechaFin;
  bool _conReceta = false;
  late DateTime _receta;
  ErroresMedicamento _errores = const ErroresMedicamento();
  bool _guardando = false;

  /// Foto de la caja (nombre del fichero), o `null` si no tiene.
  String? _foto;

  /// Cuenta de las pastillas: si se lleva, cuántas en cada toma y lo que se
  /// puso al abrir el formulario en "Pastillas que tienes ahora" (las que
  /// quedan, al modificarlo). Si no se cambia nada, se conserva la cuenta.
  bool _llevarCuenta = false;
  double _porToma = 1;
  String _existenciasIniciales = '';

  /// Si la dosis cambia según la hora (con 2 tomas o más): lo escrito en la
  /// de cada toma y las pastillas de cada una, en el orden de las tomas del
  /// formulario ([_horas] o el reparto por igual). Al guardar se ordenan
  /// como las horas del medicamento.
  bool _dosisDistinta = false;
  final List<TextEditingController> _dosisTomas = [];
  List<double> _porTomas = const [];

  /// Límites de un "cuando haga falta"; 0 es sin límite.
  int _maximoAlDia = 0;
  int _horasEntreTomas = 0;

  bool get _modificando => widget.medicamento != null;

  @override
  void initState() {
    super.initState();
    _hoy = FormatoFechas.soloFecha(ref.read(relojProvider)());
    _fechaFin = DateTime(
      _hoy.year,
      _hoy.month,
      _hoy.day + FormularioMedicamentoScreen.diasTratamientoPropuestos,
    );
    _desde = _hoy;
    _receta = FormularioMedicamentoScreen.recetaPropuesta(_hoy);
    final m = widget.medicamento;
    if (m != null) {
      _nombre.text = m.nombre;
      _dosis.text = m.dosis ?? '';
      _instrucciones.text = m.instrucciones ?? '';
      _numTomas = m.numTomas;
      _frecuenciaHoras = m.frecuenciaHoras;
      _horaInicio = m.horaInicio;
      _conFechaFin = m.fechaFin != null;
      _fechaFin = m.fechaFin ?? _fechaFin;
      _foto = m.foto;
      _aDemanda = m.aDemanda;
      _dosisDistinta = m.dosisPorToma != null;
      for (final d in m.dosisPorToma ?? const <String>[]) {
        _dosisTomas.add(TextEditingController(text: d));
      }
      _maximoAlDia = m.maximoAlDia ?? 0;
      _horasEntreTomas = m.horasEntreTomas ?? 0;
      _conReceta = m.renovarReceta != null;
      _receta = m.renovarReceta ?? _receta;
      _ponerHoras(m.horasLibres);
      _ponerDias(m.dias);
      final e = m.existencias;
      if (e != null) {
        _llevarCuenta = true;
        _porToma = e.porToma;
        _porTomas = [...?e.porTomas];
        final quedan = ref.read(existenciasProvider).value?[m.id]?.quedan;
        _existenciasIniciales = Existencias.numero(quedan ?? e.cantidad);
        _existencias.text = _existenciasIniciales;
      }
    }
    final b = widget.borrador;
    if (b != null) {
      _nombre.text = b.nombre;
      _dosis.text = b.dosis;
      _instrucciones.text = b.instrucciones;
      _numTomas = b.numTomas;
      _frecuenciaHoras = b.frecuenciaHoras;
      _horaInicio = b.horaInicio;
      _conFechaFin = b.conFechaFin;
      _fechaFin = b.fechaFin;
      _foto = b.foto;
      _aDemanda = b.aDemanda;
      _maximoAlDia = b.maximoAlDia;
      _horasEntreTomas = b.horasEntreTomas;
      _conReceta = b.conReceta;
      _receta = b.receta ?? _receta;
      _ponerHoras(b.horas);
      _ponerDias(b.dias);
      _llevarCuenta = b.llevarCuenta;
      _existencias.text = b.existencias;
      _porToma = b.porToma;
      _porTomas = [...b.porTomas];
      _dosisDistinta = b.dosisDistinta;
      for (final c in _dosisTomas) {
        c.dispose();
      }
      _dosisTomas
        ..clear()
        ..addAll([
          for (final d in b.dosisTomas) TextEditingController(text: d),
        ]);
      WidgetsBinding.instance.addPostFrameCallback((_) => _recuperar());
    }
    _ajustarTomas();
    // El resumen cambia mientras se escriben las pastillas.
    _existencias.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombre.dispose();
    _dosis.dispose();
    _instrucciones.dispose();
    _existencias.dispose();
    for (final c in _dosisTomas) {
      c.dispose();
    }
    super.dispose();
  }

  /// Una dosis y unas pastillas por toma: las que faltan, como la dosis de
  /// arriba y las de cada toma; las que sobran, fuera.
  void _ajustarTomas() {
    while (_dosisTomas.length < _numTomas) {
      _dosisTomas.add(TextEditingController(text: _dosis.text));
    }
    while (_dosisTomas.length > _numTomas) {
      _dosisTomas.removeLast().dispose();
    }
    _porTomas = [
      for (var i = 0; i < _numTomas; i++)
        i < _porTomas.length ? _porTomas[i] : _porToma,
    ];
  }

  bool get _conDosisDistinta => _dosisDistinta && !_aDemanda && _numTomas > 1;

  /// Las tomas del formulario en el orden en que las guarda el medicamento:
  /// las horas concretas se guardan ordenadas.
  List<int> get _ordenTomas {
    final indices = [for (var i = 0; i < _numTomas; i++) i];
    final horas = _horasLibres;
    if (horas != null) indices.sort((a, b) => horas[a].compareTo(horas[b]));
    return indices;
  }

  List<String>? get _dosisPorToma => _conDosisDistinta
      ? [for (final i in _ordenTomas) _dosisTomas[i].text]
      : null;

  List<double>? get _porTomasAGuardar =>
      _conDosisDistinta ? [for (final i in _ordenTomas) _porTomas[i]] : null;

  void _elegirDosisDistinta() {
    setState(() {
      if (!_dosisDistinta) {
        for (final c in _dosisTomas) {
          if (c.text.trim().isEmpty) c.text = _dosis.text;
        }
        _porTomas = [for (final _ in _porTomas) _porToma];
      }
      _dosisDistinta = true;
    });
    // El campo de la dosis de arriba se cambia por una explicación más
    // corta: se vuelve a la sección para no perderla de vista.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final seccion = _claveDosisTomas.currentContext;
      if (seccion != null && mounted) Scrollable.ensureVisible(seccion);
    });
  }

  void _ponerHoras(List<HoraDelDia>? horas) {
    _horasConcretas = horas != null;
    _horas = [...?horas];
  }

  void _ponerDias(DiasDeToma dias) {
    switch (dias) {
      case TodosLosDias():
        _modoDias = _ModoDias.todos;
      case DiasDeLaSemana(:final dias):
        _modoDias = _ModoDias.semana;
        _diasSemana = {...dias};
      case CadaVariosDias(:final cada, :final desde):
        _modoDias = _ModoDias.cada;
        _cadaDias = cada;
        _desde = desde;
    }
  }

  void _cambiarTomas(int tomas) {
    setState(() {
      if (tomas == 1) {
        // Con una sola toma solo hay una hora: la de inicio.
        if (_horasConcretas) _horaInicio = _horas.first;
        _horasConcretas = false;
      } else if (_horasConcretas) {
        _horas = tomas > _horas.length
            ? [..._horas, _horaNueva()]
            : _horas.sublist(0, tomas);
      }
      _numTomas = tomas;
      _ajustarTomas();
      // Se propone repartir las tomas por igual durante el día; así nunca
      // queda una combinación imposible.
      _frecuenciaHoras = HorarioTomas.frecuenciaSugerida(tomas);
      _errores = ErroresMedicamento(
        nombre: _errores.nombre,
        dosis: _errores.dosis,
        instrucciones: _errores.instrucciones,
        dias: _errores.dias,
        fechaFin: _errores.fechaFin,
        existencias: _errores.existencias,
      );
    });
  }

  /// Hora para una toma más: la siguiente del reparto por igual que no esté
  /// ya elegida.
  HoraDelDia _horaNueva() {
    final tomas = _horas.length + 1;
    final propuestas = HorarioTomas.calcular(
      horaInicio: _horas.first,
      numTomas: tomas,
      frecuenciaHoras: HorarioTomas.frecuenciaSugerida(tomas),
    );
    return propuestas.firstWhere(
      (hora) => !_horas.contains(hora),
      orElse: () => _horas.last.sumarMinutos(60),
    );
  }

  /// Al pasar a horas concretas se proponen las de las comidas (con 2 o 3
  /// tomas) o las del reparto por igual.
  List<HoraDelDia> _horasPropuestas() => switch (_numTomas) {
    2 => const [HoraDelDia(9, 0), HoraDelDia(21, 0)],
    3 => const [HoraDelDia(8, 0), HoraDelDia(14, 0), HoraDelDia(21, 0)],
    _ => HorarioTomas.calcular(
      horaInicio: _horaInicio,
      numTomas: _numTomas,
      frecuenciaHoras: _frecuenciaHoras,
    ),
  };

  void _elegirHorasConcretas(bool concretas) {
    setState(() {
      if (concretas && !_horasConcretas) _horas = _horasPropuestas();
      _horasConcretas = concretas;
    });
  }

  void _elegirModoDias(_ModoDias modo) {
    setState(() {
      // Al elegir días de la semana se propone el de hoy.
      if (modo == _ModoDias.semana && _diasSemana.isEmpty) {
        _diasSemana = {_hoy.weekday};
      }
      _modoDias = modo;
    });
  }

  void _cambiarDia(int dia) {
    setState(() {
      _diasSemana = _diasSemana.contains(dia)
          ? ({..._diasSemana}..remove(dia))
          : {..._diasSemana, dia};
    });
  }

  /// Las horas elegidas una a una, o `null` si se reparten por igual.
  List<HoraDelDia>? get _horasLibres =>
      _horasConcretas && _numTomas > 1 ? _horas : null;

  List<HoraDelDia> get _horasDeToma =>
      _horasLibres ??
      HorarioTomas.calcular(
        horaInicio: _horaInicio,
        numTomas: _numTomas,
        frecuenciaHoras: _frecuenciaHoras,
      );

  DiasDeToma get _dias => switch (_modoDias) {
    _ModoDias.todos => const TodosLosDias(),
    // Los siete días es lo mismo que todos los días.
    _ModoDias.semana =>
      _diasSemana.length == 7
          ? const TodosLosDias()
          : DiasDeLaSemana({..._diasSemana}),
    _ModoDias.cada => CadaVariosDias(cada: _cadaDias, desde: _desde),
  };

  NuevoMedicamento get _datos => _datosCon(_existenciasAGuardar);

  /// La cuenta que se guarda: la de antes si no se ha cambiado nada (ni las
  /// pastillas, ni cuántas en cada toma, ni la pauta, que cambiaría las
  /// tomas ya descontadas), o una nueva desde ahora.
  Existencias? get _existenciasAGuardar {
    if (!_llevarCuenta) return null;
    final original = widget.medicamento?.existencias;
    if (original != null &&
        _existencias.text == _existenciasIniciales &&
        _porToma == original.porToma &&
        listEquals(_porTomasAGuardar, original.porTomas) &&
        _mismaPauta(widget.medicamento!)) {
      return original;
    }
    final cantidad = Existencias.leer(_existencias.text);
    if (cantidad == null) return null;
    return Existencias(
      cantidad: cantidad,
      contadas: ref.read(relojProvider)(),
      porToma: _porToma,
      porTomas: _porTomasAGuardar,
    );
  }

  bool _mismaPauta(Medicamento m) {
    if (m.aDemanda || _aDemanda) return m.aDemanda == _aDemanda;
    final horas = m.horasDeToma.toSet();
    return m.dias == _dias &&
        horas.length == _horasDeToma.length &&
        horas.containsAll(_horasDeToma);
  }

  NuevoMedicamento _datosCon(Existencias? existencias) {
    if (_aDemanda) {
      return NuevoMedicamento(
        nombre: _nombre.text,
        dosis: _dosis.text,
        instrucciones: _instrucciones.text,
        numTomas: 1,
        frecuenciaHoras: HorarioTomas.frecuenciaUnaToma,
        horaInicio: _horaInicio,
        fechaFin: _conFechaFin ? _fechaFin : null,
        foto: _foto,
        aDemanda: true,
        existencias: existencias,
        maximoAlDia: _maximoAlDia == 0 ? null : _maximoAlDia,
        horasEntreTomas: _horasEntreTomas == 0 ? null : _horasEntreTomas,
        renovarReceta: _conReceta ? _receta : null,
      );
    }
    final horas = _horasLibres;
    return NuevoMedicamento(
      nombre: _nombre.text,
      dosis: _dosis.text,
      dosisPorToma: _dosisPorToma,
      instrucciones: _instrucciones.text,
      numTomas: _numTomas,
      frecuenciaHoras: horas == null
          ? _frecuenciaHoras
          : HorarioTomas.frecuenciaSugerida(_numTomas),
      horaInicio: horas == null ? _horaInicio : ([...horas]..sort()).first,
      fechaFin: _conFechaFin ? _fechaFin : null,
      foto: _foto,
      horasLibres: horas,
      dias: _dias,
      existencias: existencias,
      renovarReceta: _conReceta ? _receta : null,
    );
  }

  BorradorMedicamento get _borrador => BorradorMedicamento(
    medicamentoId: widget.medicamento?.id,
    nombre: _nombre.text,
    dosis: _dosis.text,
    instrucciones: _instrucciones.text,
    numTomas: _numTomas,
    frecuenciaHoras: _frecuenciaHoras,
    horaInicio: _horaInicio,
    conFechaFin: _conFechaFin,
    fechaFin: _fechaFin,
    foto: _foto,
    horas: _horasLibres,
    dias: _dias,
    aDemanda: _aDemanda,
    llevarCuenta: _llevarCuenta,
    existencias: _existencias.text,
    porToma: _porToma,
    porTomas: _porTomas,
    dosisDistinta: _dosisDistinta,
    dosisTomas: [for (final c in _dosisTomas) c.text],
    maximoAlDia: _maximoAlDia,
    horasEntreTomas: _horasEntreTomas,
    conReceta: _conReceta,
    receta: _receta,
  );

  /// "Crear recordatorio", o "Guardar medicamento" si no va a tener avisos.
  String get _textoBoton {
    final t = TextosApp.of(context);
    return _modificando
        ? t.formularioGuardarCambios
        : _aDemanda
        ? t.formularioMedicamentoGuardar
        : t.formularioMedicamentoCrear;
  }

  Future<void> _elegirFoto(OrigenFoto origen) async {
    FocusScope.of(context).unfocus();
    final borradores = ref.read(borradorRepositoryProvider);
    // Si Android cierra la app con la cámara abierta, al volver a abrirla se
    // recupera el formulario con este borrador (ver app.dart).
    await borradores.guardar(_borrador);
    try {
      final String? ruta;
      try {
        ruta = await ref.read(selectorFotosProvider).elegir(origen);
      } finally {
        await borradores.borrar();
      }
      if (ruta == null || !mounted) return;
      await _ponerFoto(ruta);
      if (!mounted) return;
      mostrarAviso(
        context,
        TextosApp.of(context).formularioFotoAnadida(_textoBoton),
        icono: Icons.photo,
      );
    } on Object {
      if (!mounted) return;
      final t = TextosApp.of(context);
      mostrarAviso(
        context,
        origen == OrigenFoto.camara
            ? t.formularioErrorFotoCamara
            : t.formularioErrorFotoGaleria,
        icono: Icons.error,
      );
    }
  }

  Future<void> _ponerFoto(String ruta) async {
    final nombre = await ref.read(almacenFotosProvider).guardar(ruta);
    if (mounted) setState(() => _foto = nombre);
  }

  /// Tras abrir el formulario con un borrador: pone la foto que se acababa de
  /// hacer o elegir, si el teléfono la ha guardado, y lo explica.
  Future<void> _recuperar() async {
    var conFoto = false;
    try {
      final ruta = await ref.read(selectorFotosProvider).recuperarPerdida();
      if (ruta != null) {
        await _ponerFoto(ruta);
        conFoto = true;
      }
    } on Object {
      // Sin la foto, se recupera al menos lo escrito.
    }
    if (!mounted) return;
    final t = TextosApp.of(context);
    mostrarAviso(
      context,
      conFoto
          ? t.formularioRecuperadoConFoto(_textoBoton)
          : t.formularioRecuperado,
      icono: Icons.restore,
    );
  }

  void _quitarFoto() {
    setState(() => _foto = null);
    mostrarAviso(
      context,
      TextosApp.of(context).formularioFotoQuitada(_textoBoton),
      icono: Icons.hide_image,
    );
  }

  Future<void> _guardar() async {
    if (_guardando) return;
    FocusScope.of(context).unfocus();
    final datos = _datos;
    final errores = ValidadorMedicamento.validar(
      nombre: datos.nombre,
      dosis: datos.dosis ?? '',
      dosisPorToma: datos.dosisPorToma,
      instrucciones: datos.instrucciones ?? '',
      numTomas: datos.numTomas,
      frecuenciaHoras: datos.frecuenciaHoras,
      horaInicio: datos.horaInicio,
      fechaFin: datos.fechaFin,
      ahora: ref.read(relojProvider)(),
      horasLibres: datos.horasLibres,
      dias: datos.dias,
      existencias: _llevarCuenta ? _existencias.text : null,
    );
    setState(() => _errores = errores);
    if (!errores.sinErrores) {
      // El error se muestra junto al campo (y TalkBack lo anuncia); se
      // desplaza la pantalla hasta el primero para que se vea.
      final clave = errores.nombre != null
          ? _claveNombre
          : errores.dosis != null && _conDosisDistinta
          ? _claveDosisTomas
          : (errores.dosis ?? errores.instrucciones) != null
          ? _claveDosis
          : (errores.frecuencia ?? errores.numTomas ?? errores.horas) != null
          ? _claveFrecuencia
          : errores.horaInicio != null
          ? _claveHora
          : errores.dias != null
          ? _claveDias
          : errores.fechaFin != null
          ? _claveDuracion
          : _claveExistencias;
      final campo = clave.currentContext;
      if (campo != null) {
        await Scrollable.ensureVisible(
          campo,
          duration: const Duration(milliseconds: 300),
        );
      }
      return;
    }

    setState(() => _guardando = true);
    final controlador = ref.read(medicamentosProvider.notifier);
    final Medicamento medicamento;
    try {
      final original = widget.medicamento;
      if (original == null) {
        medicamento = await controlador.crear(datos);
      } else {
        medicamento = original.conDatos(datos);
        await controlador.actualizar(medicamento);
      }
    } on Object {
      if (mounted) {
        setState(() => _guardando = false);
        mostrarAviso(
          context,
          TextosApp.of(context).formularioMedicamentoErrorGuardar,
          icono: Icons.error,
        );
      }
      return;
    }
    if (!mounted) return;

    final t = TextosApp.of(context);
    final avisosActivos = ref.read(ajustesProvider).notificacionesActivadas;
    final fin = medicamento.fechaFin;
    final receta = medicamento.renovarReceta;
    final dias = medicamento.dias.describir();
    await mostrarConfirmacion(
      context,
      titulo: _modificando
          ? t.formularioCambiosGuardados
          : t.formularioMedicamentoGuardado,
      mensaje: [
        if (medicamento.aDemanda) ...[
          t.formularioMedicamentoResumenADemanda(medicamento.nombre),
          ?medicamento.describirLimites,
        ] else ...[
          t.formularioMedicamentoResumenGuardado(
            medicamento.nombre,
            medicamento.descripcionTomas,
            FormatoFechas.listaDeHoras(medicamento.horasDeToma),
          ),
          if (dias != null) FormatoFechas.conMayuscula('$dias.'),
        ],
        if (fin != null)
          t.formularioMedicamentoUltimoDia(FormatoFechas.fechaLarga(fin)),
        if (receta != null)
          '${t.medicamentoRecetaHasta(FormatoFechas.fechaLarga(receta))}.',
        if (!avisosActivos && !medicamento.aDemanda) ...[
          '',
          t.avisosDesactivadosEnAjustes,
        ],
      ].join('\n'),
    );
    if (!mounted) return;
    if (_modificando) {
      Navigator.of(context).pop();
    } else {
      // Se muestra la lista; "Atrás" desde ella vuelve al submenú.
      Navigator.of(context).pushNamedAndRemoveUntil(
        Rutas.listaMedicamentos,
        ModalRoute.withName(Rutas.medicamentos),
      );
    }
  }

  String get _textoResumenAvisos {
    final t = TextosApp.of(context);
    if (_aDemanda) {
      return _conFechaFin
          ? t.formularioMedicamentoAvisoADemandaHasta(
              t.tomasTitulo,
              FormatoFechas.fechaLarga(_fechaFin),
            )
          : t.formularioMedicamentoAvisoADemanda(t.tomasTitulo);
    }
    final dias = _dias;
    if (dias is DiasDeLaSemana && dias.dias.isEmpty) {
      return t.validadorMedicamentoSinDias;
    }
    final lista = FormatoFechas.listaDeHoras(_horasDeToma);
    final fin = FormatoFechas.fechaLarga(_fechaFin);
    return switch (dias.describir()) {
      null when _conFechaFin => t.formularioMedicamentoAvisoHasta(lista, fin),
      null => t.formularioMedicamentoAvisoCadaDia(lista),
      final frase when _conFechaFin => t.formularioMedicamentoAvisoDiasHasta(
        frase,
        lista,
        fin,
      ),
      final frase => t.formularioMedicamentoAvisoDias(frase, lista),
    };
  }

  /// Tomas al día, horas y días: solo con horario.
  List<Widget> _horario(TextosApp t) {
    final frecuenciaMaxima = HorarioTomas.frecuenciaMaxima(_numTomas);
    return [
      const Hueco(alto: Medidas.separacion * 1.5),
      _Seccion(
        etiqueta: t.formularioMedicamentoNumeroTomas,
        descripcion: t.formularioMedicamentoNumeroTomasDescripcion,
        error: _errores.numTomas,
        child: SelectorNumerico(
          etiqueta: t.formularioMedicamentoTomasAlDia,
          valor: '$_numTomas',
          valorSemantico: t.formularioMedicamentoTomasValor(_numTomas),
          etiquetaMenos: t.formularioMedicamentoTomaMenos,
          etiquetaMas: t.formularioMedicamentoTomaMas,
          onMenos: _numTomas > HorarioTomas.minTomas
              ? () => _cambiarTomas(_numTomas - 1)
              : null,
          onMas: _numTomas < HorarioTomas.maxTomas
              ? () => _cambiarTomas(_numTomas + 1)
              : null,
        ),
      ),
      if (_numTomas > 1) ...[
        const Hueco(alto: Medidas.separacion * 1.5),
        _Seccion(
          key: _claveFrecuencia,
          etiqueta: t.formularioMedicamentoHorasTitulo,
          descripcion: t.formularioMedicamentoHorasDescripcion,
          error: _errores.frecuencia ?? _errores.horas,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OpcionSeleccionable(
                etiqueta: t.formularioMedicamentoRepartidas,
                descripcion: t.formularioMedicamentoRepartidasDescripcion,
                elegida: !_horasConcretas,
                onPressed: () => _elegirHorasConcretas(false),
              ),
              const Hueco(alto: 12),
              OpcionSeleccionable(
                etiqueta: t.formularioMedicamentoConcretas,
                descripcion: t.formularioMedicamentoConcretasDescripcion,
                elegida: _horasConcretas,
                onPressed: () => _elegirHorasConcretas(true),
              ),
              if (!_horasConcretas) ...[
                const Hueco(),
                SelectorNumerico(
                  etiqueta: t.formularioMedicamentoCadaCuantasHoras,
                  valor: t.formularioMedicamentoCadaHorasCorto(
                    '$_frecuenciaHoras',
                  ),
                  valorSemantico: t.formularioMedicamentoCadaHorasValor(
                    '$_frecuenciaHoras',
                  ),
                  etiquetaMenos: t.formularioMedicamentoHoraMenos,
                  etiquetaMas: t.formularioMedicamentoHoraMas,
                  onMenos: _frecuenciaHoras > 1
                      ? () => setState(() => _frecuenciaHoras--)
                      : null,
                  onMas: _frecuenciaHoras < frecuenciaMaxima
                      ? () => setState(() => _frecuenciaHoras++)
                      : null,
                ),
              ],
            ],
          ),
        ),
      ],
      const Hueco(alto: Medidas.separacion * 1.5),
      if (_horasLibres != null) ...[
        for (final (i, hora) in _horas.indexed) ...[
          if (i > 0) const Hueco(),
          SelectorHora(
            key: i == 0 ? _claveHora : null,
            etiqueta: t.formularioMedicamentoHoraToma('${i + 1}'),
            hora: hora,
            conError: _errores.horas != null,
            onChanged: (nueva) =>
                setState(() => _horas = [..._horas]..[i] = nueva),
          ),
        ],
      ] else ...[
        SelectorHora(
          key: _claveHora,
          etiqueta: _numTomas == 1
              ? t.formularioMedicamentoHoraUnaToma
              : t.formularioMedicamentoHoraInicio,
          descripcion: _numTomas == 1
              ? t.formularioMedicamentoHoraUnaTomaDescripcion
              : t.formularioMedicamentoHoraInicioDescripcion,
          hora: _horaInicio,
          conError: _errores.horaInicio != null,
          onChanged: (hora) => setState(() => _horaInicio = hora),
        ),
        if (_errores.horaInicio != null) MensajeError(_errores.horaInicio!),
      ],
      if (_numTomas > 1) ...[
        const Hueco(alto: Medidas.separacion * 1.5),
        _Seccion(
          key: _claveDosisTomas,
          etiqueta: t.formularioMedicamentoDosisTomasTitulo,
          descripcion: t.formularioMedicamentoDosisTomasDescripcion,
          error: _conDosisDistinta ? _errores.dosis : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OpcionSeleccionable(
                etiqueta: t.formularioMedicamentoDosisIgual,
                descripcion: t.formularioMedicamentoDosisIgualDescripcion,
                elegida: !_dosisDistinta,
                onPressed: () => setState(() => _dosisDistinta = false),
              ),
              const Hueco(alto: 12),
              OpcionSeleccionable(
                etiqueta: t.formularioMedicamentoDosisDistinta,
                descripcion: t.formularioMedicamentoDosisDistintaDescripcion,
                elegida: _dosisDistinta,
                onPressed: _elegirDosisDistinta,
              ),
              if (_dosisDistinta)
                for (final (i, hora) in _horasDeToma.indexed) ...[
                  const Hueco(),
                  CampoTexto(
                    etiqueta: t.formularioMedicamentoDosisDeLas(hora.texto),
                    controller: _dosisTomas[i],
                    accion: TextInputAction.done,
                  ),
                ],
            ],
          ),
        ),
      ],
      const Hueco(alto: Medidas.separacion * 1.5),
      _Seccion(
        key: _claveDias,
        etiqueta: t.formularioMedicamentoDiasTitulo,
        descripcion: t.formularioMedicamentoDiasDescripcion,
        error: _errores.dias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OpcionSeleccionable(
              etiqueta: t.formularioMedicamentoTodosLosDias,
              descripcion: t.formularioMedicamentoTodosLosDiasDescripcion,
              elegida: _modoDias == _ModoDias.todos,
              onPressed: () => _elegirModoDias(_ModoDias.todos),
            ),
            const Hueco(alto: 12),
            OpcionSeleccionable(
              etiqueta: t.formularioMedicamentoAlgunosDias,
              descripcion: t.formularioMedicamentoAlgunosDiasDescripcion,
              elegida: _modoDias == _ModoDias.semana,
              onPressed: () => _elegirModoDias(_ModoDias.semana),
            ),
            const Hueco(alto: 12),
            OpcionSeleccionable(
              etiqueta: t.formularioMedicamentoCadaVariosDias,
              descripcion: t.formularioMedicamentoCadaVariosDiasDescripcion,
              elegida: _modoDias == _ModoDias.cada,
              onPressed: () => _elegirModoDias(_ModoDias.cada),
            ),
            if (_modoDias == _ModoDias.semana) ...[
              const Hueco(),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var d = DateTime.monday; d <= DateTime.sunday; d++)
                    _BotonDia(
                      texto: FormatoFechas.conMayuscula(
                        FormatoFechas.diasSemana[d - 1],
                      ),
                      elegido: _diasSemana.contains(d),
                      onPressed: () => _cambiarDia(d),
                    ),
                ],
              ),
            ],
            if (_modoDias == _ModoDias.cada) ...[
              const Hueco(),
              SelectorNumerico(
                etiqueta: t.formularioMedicamentoCadaCuantosDias,
                valor: t.formularioMedicamentoCadaDiasValor('$_cadaDias'),
                etiquetaMenos: t.formularioMedicamentoDiaMenos,
                etiquetaMas: t.formularioMedicamentoDiaMas,
                onMenos: _cadaDias > CadaVariosDias.minimo
                    ? () => setState(() => _cadaDias--)
                    : null,
                onMas: _cadaDias < CadaVariosDias.maximo
                    ? () => setState(() => _cadaDias++)
                    : null,
              ),
              const Hueco(),
              SelectorFecha(
                etiqueta: t.formularioMedicamentoPrimerDia,
                descripcion: t.formularioMedicamentoPrimerDiaDescripcion,
                fecha: _desde,
                hoy: _hoy,
                // Al modificarlo, el primer día puede haber pasado ya.
                primerDia: _desde.isBefore(_hoy) ? _desde : _hoy,
                ultimoDia: DateTime(_hoy.year + 1, _hoy.month, _hoy.day),
                onChanged: (fecha) => setState(() => _desde = fecha),
              ),
            ],
          ],
        ),
      ),
    ];
  }

  void _cambiarPorToma(int indice, double cambio) => setState(
    () => _porTomas = [..._porTomas]..[indice] = _porTomas[indice] + cambio,
  );

  /// Máximo al día y horas entre tomas: solo en los "cuando haga falta".
  List<Widget> _limites(TextosApp t) => [
    const Hueco(alto: Medidas.separacion * 1.5),
    _Seccion(
      etiqueta: t.formularioMedicamentoLimitesTitulo,
      descripcion: t.formularioMedicamentoLimitesDescripcion,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectorNumerico(
            etiqueta: t.formularioMedicamentoMaximoAlDia,
            valor: _maximoAlDia == 0
                ? t.formularioMedicamentoSinLimite
                : t.formularioMedicamentoVeces(_maximoAlDia),
            etiquetaMenos: t.formularioMedicamentoVezMenos,
            etiquetaMas: t.formularioMedicamentoVezMas,
            onMenos: _maximoAlDia > 0
                ? () => setState(() => _maximoAlDia--)
                : null,
            onMas: _maximoAlDia < Medicamento.maximoVecesAlDia
                ? () => setState(() => _maximoAlDia++)
                : null,
          ),
          const Hueco(),
          SelectorNumerico(
            etiqueta: t.formularioMedicamentoHorasEntreTomas,
            valor: _horasEntreTomas == 0
                ? t.formularioMedicamentoSinMinimo
                : t.formularioMedicamentoHorasValor(_horasEntreTomas),
            etiquetaMenos: t.formularioMedicamentoHoraMenos,
            etiquetaMas: t.formularioMedicamentoHoraMas,
            onMenos: _horasEntreTomas > 0
                ? () => setState(() => _horasEntreTomas--)
                : null,
            onMas: _horasEntreTomas < Medicamento.maximoHorasEntreTomas
                ? () => setState(() => _horasEntreTomas++)
                : null,
          ),
        ],
      ),
    ),
  ];

  /// Lo que se ve en el resumen sobre las pastillas que quedan, o `null` si
  /// no se lleva la cuenta (o aún no se ha escrito un número válido).
  String? get _resumenExistencias {
    final cantidad = Existencias.leer(_existencias.text);
    if (!_llevarCuenta || cantidad == null) return null;
    final ahora = ref.read(relojProvider)();
    final medicamento = Medicamento.desdeDatos(
      id: widget.medicamento?.id ?? 0,
      fechaCreacion: widget.medicamento?.fechaCreacion ?? ahora,
      datos: _datosCon(
        Existencias(
          cantidad: math.min(cantidad, Existencias.maximo),
          contadas: ahora,
          porToma: _porToma,
          porTomas: _porTomasAGuardar,
        ),
      ),
    );
    return CalculoExistencias.estado(medicamento, const [], ahora)?.describir();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = TextosApp.of(context);
    final textoBoton = _textoBoton;
    final resumenExistencias = _resumenExistencias;
    final limites = _aDemanda
        ? Medicamento.desdeDatos(
            id: 0,
            fechaCreacion: _hoy,
            datos: _datosCon(null),
          ).describirLimites
        : null;
    // Al modificarlo, "Pastillas que tienes ahora" muestra las que quedan en
    // cuanto se calculan (si no se ha escrito nada todavía).
    final original = widget.medicamento;
    if (original?.existencias != null) {
      ref.listen(existenciasProvider, (_, siguiente) {
        final quedan = siguiente.value?[original!.id]?.quedan;
        if (quedan == null || _existencias.text != _existenciasIniciales) {
          return;
        }
        _existenciasIniciales = Existencias.numero(quedan);
        _existencias.text = _existenciasIniciales;
      });
    }

    return PantallaBase(
      titulo: _modificando
          ? t.formularioMedicamentoTituloModificar
          : t.formularioMedicamentoTituloNuevo,
      pie: BotonGrande(
        etiqueta: _guardando ? t.formularioGuardando : textoBoton,
        icono: _modificando || _aDemanda ? Icons.save : Icons.alarm_add,
        centrado: true,
        onPressed: _guardando ? null : _guardar,
      ),
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Parrafo(t.formularioRellenaYPulsa(textoBoton)),
          const Hueco(),
          CampoTexto(
            key: _claveNombre,
            etiqueta: t.formularioMedicamentoNombre,
            descripcion: t.formularioMedicamentoNombreDescripcion,
            controller: _nombre,
            error: _errores.nombre,
            accion: TextInputAction.done,
          ),
          BotonDictar(
            controller: _nombre,
            etiqueta: t.formularioMedicamentoDictarNombre,
            indicacion: t.formularioMedicamentoDictarNombreIndicacion,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          if (_conDosisDistinta)
            Parrafo(
              key: _claveDosis,
              t.formularioMedicamentoDosisEnCadaToma(
                t.formularioMedicamentoDosisTomasTitulo,
              ),
            )
          else
            CampoTexto(
              key: _claveDosis,
              etiqueta: t.formularioMedicamentoDosis,
              descripcion: t.formularioMedicamentoDosisDescripcion,
              controller: _dosis,
              error: _errores.dosis,
              accion: TextInputAction.done,
            ),
          const Hueco(alto: Medidas.separacion * 1.5),
          CampoTexto(
            etiqueta: t.formularioMedicamentoInstrucciones,
            descripcion: t.formularioMedicamentoInstruccionesDescripcion,
            controller: _instrucciones,
            error: _errores.instrucciones,
            accion: TextInputAction.done,
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          _Seccion(
            etiqueta: t.formularioMedicamentoFoto,
            descripcion: t.formularioMedicamentoFotoDescripcion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_foto != null) ...[
                  FotoCaja(foto: _foto!, nombreMedicamento: _nombre.text),
                  const Hueco(alto: 12),
                ],
                BotonGrande(
                  etiqueta: _foto == null
                      ? t.formularioMedicamentoHacerFoto
                      : t.formularioMedicamentoHacerOtraFoto,
                  descripcion: t.formularioMedicamentoHacerFotoDescripcion,
                  icono: Icons.photo_camera,
                  onPressed: () => _elegirFoto(OrigenFoto.camara),
                ),
                const Hueco(alto: 12),
                BotonGrande(
                  etiqueta: _foto == null
                      ? t.formularioMedicamentoElegirGaleria
                      : t.formularioMedicamentoElegirOtraGaleria,
                  descripcion: t.formularioMedicamentoGaleriaDescripcion,
                  icono: Icons.photo_library,
                  onPressed: () => _elegirFoto(OrigenFoto.galeria),
                ),
                if (_foto != null) ...[
                  const Hueco(alto: 12),
                  BotonGrande(
                    etiqueta: t.formularioMedicamentoQuitarFoto,
                    icono: Icons.hide_image,
                    onPressed: _quitarFoto,
                  ),
                ],
              ],
            ),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          _Seccion(
            etiqueta: t.formularioMedicamentoCuandoTitulo,
            descripcion: t.formularioMedicamentoCuandoDescripcion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoConHorario,
                  descripcion: t.formularioMedicamentoConHorarioDescripcion,
                  elegida: !_aDemanda,
                  onPressed: () => setState(() => _aDemanda = false),
                ),
                const Hueco(alto: 12),
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoADemanda,
                  descripcion: t.formularioMedicamentoADemandaDescripcion(
                    t.tomasTitulo,
                  ),
                  elegida: _aDemanda,
                  onPressed: () => setState(() => _aDemanda = true),
                ),
              ],
            ),
          ),
          if (_aDemanda) ..._limites(t) else ..._horario(t),
          const Hueco(alto: Medidas.separacion * 1.5),
          _Seccion(
            key: _claveDuracion,
            etiqueta: t.formularioMedicamentoDuracion,
            descripcion: t.formularioMedicamentoDuracionDescripcion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoSiempre,
                  descripcion: t.formularioMedicamentoSiempreDescripcion,
                  elegida: !_conFechaFin,
                  onPressed: () => setState(() => _conFechaFin = false),
                ),
                const Hueco(alto: 12),
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoHastaUnDia,
                  descripcion: t.formularioMedicamentoHastaUnDiaDescripcion,
                  elegida: _conFechaFin,
                  onPressed: () => setState(() => _conFechaFin = true),
                ),
                if (_conFechaFin) ...[
                  const Hueco(),
                  SelectorFecha(
                    etiqueta: t.formularioMedicamentoUltimoDiaEtiqueta,
                    descripcion: t.formularioMedicamentoUltimoDiaDescripcion,
                    fecha: _fechaFin,
                    hoy: _hoy,
                    primerDia: _hoy,
                    ultimoDia: DateTime(_hoy.year + 2, _hoy.month, _hoy.day),
                    conError: _errores.fechaFin != null,
                    onChanged: (fecha) => setState(() => _fechaFin = fecha),
                  ),
                ],
                if (_errores.fechaFin != null) MensajeError(_errores.fechaFin!),
              ],
            ),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          _Seccion(
            etiqueta: t.formularioMedicamentoRecetaTitulo,
            descripcion: t.formularioMedicamentoRecetaDescripcion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoSinReceta,
                  descripcion: t.formularioMedicamentoSinRecetaDescripcion,
                  elegida: !_conReceta,
                  onPressed: () => setState(() => _conReceta = false),
                ),
                const Hueco(alto: 12),
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoConReceta,
                  descripcion: t.formularioMedicamentoConRecetaDescripcion,
                  elegida: _conReceta,
                  onPressed: () => setState(() => _conReceta = true),
                ),
                if (_conReceta) ...[
                  const Hueco(),
                  SelectorFecha(
                    etiqueta: t.formularioMedicamentoRecetaFecha,
                    descripcion: t.formularioMedicamentoRecetaFechaDescripcion,
                    fecha: _receta,
                    hoy: _hoy,
                    // Al modificarlo, la receta puede haberse acabado ya.
                    primerDia: _receta.isBefore(_hoy) ? _receta : _hoy,
                    ultimoDia: DateTime(_hoy.year + 2, _hoy.month, _hoy.day),
                    onChanged: (fecha) => setState(() => _receta = fecha),
                  ),
                ],
              ],
            ),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          _Seccion(
            key: _claveExistencias,
            etiqueta: t.formularioMedicamentoExistenciasTitulo,
            descripcion: t.formularioMedicamentoExistenciasDescripcion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoSinCuenta,
                  descripcion: t.formularioMedicamentoSinCuentaDescripcion,
                  elegida: !_llevarCuenta,
                  onPressed: () => setState(() => _llevarCuenta = false),
                ),
                const Hueco(alto: 12),
                OpcionSeleccionable(
                  etiqueta: t.formularioMedicamentoConCuenta,
                  descripcion: t.formularioMedicamentoConCuentaDescripcion,
                  elegida: _llevarCuenta,
                  onPressed: () => setState(() => _llevarCuenta = true),
                ),
                if (_llevarCuenta) ...[
                  const Hueco(),
                  CampoTexto(
                    etiqueta: t.formularioMedicamentoExistenciasCampo,
                    descripcion:
                        t.formularioMedicamentoExistenciasCampoDescripcion,
                    controller: _existencias,
                    error: _errores.existencias,
                    teclado: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    formateadores: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      LengthLimitingTextInputFormatter(6),
                    ],
                    accion: TextInputAction.done,
                  ),
                  if (_conDosisDistinta)
                    for (final (i, hora) in _horasDeToma.indexed) ...[
                      const Hueco(),
                      SelectorNumerico(
                        etiqueta: t.formularioMedicamentoPorTomaDeLas(
                          hora.texto,
                        ),
                        valor: Existencias.corto(_porTomas[i]),
                        valorSemantico: Existencias.describir(_porTomas[i]),
                        etiquetaMenos: t.formularioMedicamentoPorTomaDeLasMenos(
                          hora.texto,
                        ),
                        etiquetaMas: t.formularioMedicamentoPorTomaDeLasMas(
                          hora.texto,
                        ),
                        onMenos: _porTomas[i] > Existencias.paso
                            ? () => _cambiarPorToma(i, -Existencias.paso)
                            : null,
                        onMas: _porTomas[i] < Existencias.maximoPorToma
                            ? () => _cambiarPorToma(i, Existencias.paso)
                            : null,
                      ),
                    ]
                  else ...[
                    const Hueco(),
                    SelectorNumerico(
                      etiqueta: t.formularioMedicamentoPorToma,
                      valor: Existencias.corto(_porToma),
                      valorSemantico: _porToma == _porToma.roundToDouble()
                          ? t.formularioMedicamentoPorTomaValor(
                              _porToma.toInt(),
                            )
                          : t.formularioMedicamentoPorTomaYMedia(
                              _porToma.floor(),
                            ),
                      etiquetaMenos: t.formularioMedicamentoPorTomaMenos,
                      etiquetaMas: t.formularioMedicamentoPorTomaMas,
                      onMenos: _porToma > Existencias.paso
                          ? () => setState(() => _porToma -= Existencias.paso)
                          : null,
                      onMas: _porToma < Existencias.maximoPorToma
                          ? () => setState(() => _porToma += Existencias.paso)
                          : null,
                    ),
                  ],
                ],
              ],
            ),
          ),
          const Hueco(alto: Medidas.separacion * 1.5),
          Semantics(
            container: true,
            liveRegion: true,
            child: TarjetaInfo(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.formularioResumen, style: textos.titleLarge),
                  LineaDato(
                    icono: Icons.repeat,
                    texto: _aDemanda
                        ? t.medicamentoADemanda
                        : _horasLibres == null
                        ? HorarioTomas.describir(_numTomas, _frecuenciaHoras)
                        : HorarioTomas.describirLibres(_numTomas),
                  ),
                  LineaDato(
                    icono: _aDemanda ? Icons.notifications_off : Icons.alarm,
                    texto: _textoResumenAvisos,
                  ),
                  if (limites != null)
                    LineaDato(icono: Icons.rule, texto: limites),
                  if (resumenExistencias != null)
                    LineaDato(
                      icono: Icons.inventory_2,
                      texto: resumenExistencias,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Qué días se toma: todos, algunos de la semana o cada varios días.
enum _ModoDias { todos, semana, cada }

/// Botón de un día de la semana, que se elige o se quita al tocarlo. El
/// elegido lleva una marca ✓, para no depender solo del borde y el color.
class _BotonDia extends StatelessWidget {
  const _BotonDia({
    required this.texto,
    required this.elegido,
    required this.onPressed,
  });

  final String texto;
  final bool elegido;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      selected: elegido,
      label: texto,
      onTap: onPressed,
      excludeSemantics: true,
      child: SuperficiePulsable(
        onPressed: onPressed,
        seleccionado: elegido,
        relleno: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextoConMarca(texto: texto, elegido: elegido),
      ),
    );
  }
}

/// Bloque del formulario con etiqueta grande, descripción y un control.
class _Seccion extends StatelessWidget {
  const _Seccion({
    super.key,
    required this.etiqueta,
    required this.descripcion,
    required this.child,
    this.error,
  });

  final String etiqueta;
  final String descripcion;
  final Widget? child;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(etiqueta, style: textos.titleLarge),
        ),
        const SizedBox(height: 4),
        Parrafo(descripcion),
        if (child != null) ...[const SizedBox(height: 12), child!],
        if (error != null) MensajeError(error!),
      ],
    );
  }
}
