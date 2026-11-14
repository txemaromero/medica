import 'package:flutter/material.dart';

import '../features/agenda/domain/cita.dart';
import '../features/agenda/presentation/agenda_screen.dart';
import '../features/agenda/presentation/formulario_cita_screen.dart';
import '../features/ajustes/presentation/ajustes_screen.dart';
import '../features/ajustes/presentation/repetir_avisos_screen.dart';
import '../features/ajustes/presentation/tamano_texto_screen.dart';
import '../features/ajustes/presentation/tema_screen.dart';
import '../features/asistente/asistente_screen.dart';
import '../features/compartir/presentation/compartir_screen.dart';
import '../features/emergencias/presentation/emergencias_screen.dart';
import '../features/medicamentos/domain/borrador_medicamento.dart';
import '../features/medicamentos/domain/medicamento.dart';
import '../features/medicamentos/presentation/comprar_mas_screen.dart';
import '../features/medicamentos/presentation/formulario_medicamento_screen.dart';
import '../features/medicamentos/presentation/lista_medicamentos_screen.dart';
import '../features/medicamentos/presentation/medicamentos_menu_screen.dart';
import '../features/medicamentos/presentation/renovar_receta_screen.dart';
import '../features/menu_principal/menu_principal_screen.dart';
import '../features/tomas/presentation/historial_tomas_screen.dart';
import '../features/tomas/presentation/tomas_hoy_screen.dart';

/// Arquitectura de la información: menú principal → 4 secciones →
/// subpantallas (como máximo dos niveles de profundidad).
abstract final class Rutas {
  static const String menuPrincipal = '/';

  static const String medicamentos = '/medicamentos';
  static const String nuevoMedicamento = '/medicamentos/nuevo';
  static const String listaMedicamentos = '/medicamentos/lista';
  static const String modificarMedicamento = '/medicamentos/modificar';
  static const String tomasHoy = '/medicamentos/hoy';
  static const String historialTomas = '/medicamentos/historial';
  static const String comprarMas = '/medicamentos/comprar';
  static const String renovarReceta = '/medicamentos/receta';

  static const String agenda = '/agenda';
  static const String nuevaCita = '/agenda/nueva';
  static const String modificarCita = '/agenda/modificar';

  static const String emergencias = '/emergencias';

  static const String ajustes = '/ajustes';
  static const String tamanoTexto = '/ajustes/tamano-texto';
  static const String tema = '/ajustes/tema';
  static const String repetirAvisos = '/ajustes/repetir-avisos';
  static const String compartir = '/ajustes/compartir';

  /// Asistente de la primera vez. Como empieza por "/", al abrir la app en
  /// esta ruta queda el menú principal debajo.
  static const String asistente = '/asistente';

  /// Las pantallas accesibles por nombre: las 10 del diseño original más
  /// "Tomas de hoy", "Historial de tomas", el asistente de la primera vez,
  /// "Compartir y copia de seguridad" y "Repetir los avisos".
  static final Map<String, WidgetBuilder> mapa = {
    menuPrincipal: (_) => const MenuPrincipalScreen(),
    medicamentos: (_) => const MedicamentosMenuScreen(),
    nuevoMedicamento: (_) => const FormularioMedicamentoScreen(),
    listaMedicamentos: (_) => const ListaMedicamentosScreen(),
    tomasHoy: (_) => const TomasHoyScreen(),
    historialTomas: (_) => const HistorialTomasScreen(),
    agenda: (_) => const AgendaScreen(),
    nuevaCita: (_) => const FormularioCitaScreen(),
    emergencias: (_) => const EmergenciasScreen(),
    ajustes: (_) => const AjustesScreen(),
    tamanoTexto: (_) => const TamanoTextoScreen(),
    tema: (_) => const TemaScreen(),
    repetirAvisos: (_) => const RepetirAvisosScreen(),
    asistente: (_) => const AsistenteScreen(),
    compartir: (_) => const CompartirScreen(),
  };

  /// Abre el formulario de medicamento con los datos de [medicamento].
  static Future<void> abrirModificarMedicamento(
    BuildContext context,
    Medicamento medicamento,
  ) => abrirFormularioMedicamento(
    Navigator.of(context),
    medicamento: medicamento,
  );

  /// Abre el formulario de medicamento: para modificar [medicamento] o, sin
  /// él, para uno nuevo; con un [borrador], con lo que se había escrito.
  static Future<void> abrirFormularioMedicamento(
    NavigatorState navegador, {
    Medicamento? medicamento,
    BorradorMedicamento? borrador,
  }) => navegador.push(
    MaterialPageRoute<void>(
      settings: RouteSettings(
        name: medicamento == null ? nuevoMedicamento : modificarMedicamento,
      ),
      builder: (_) => FormularioMedicamentoScreen(
        medicamento: medicamento,
        borrador: borrador,
      ),
    ),
  );

  /// Abre "He comprado más" para [medicamento].
  static Future<void> abrirComprarMas(
    BuildContext context,
    Medicamento medicamento,
  ) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      settings: const RouteSettings(name: comprarMas),
      builder: (_) => ComprarMasScreen(medicamento: medicamento),
    ),
  );

  /// Abre "Ya la he renovado" para la receta de [medicamento].
  static Future<void> abrirRenovarReceta(
    BuildContext context,
    Medicamento medicamento,
  ) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      settings: const RouteSettings(name: renovarReceta),
      builder: (_) => RenovarRecetaScreen(medicamento: medicamento),
    ),
  );

  /// Abre el formulario de cita con los datos de [cita].
  static Future<void> abrirModificarCita(BuildContext context, Cita cita) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: modificarCita),
          builder: (_) => FormularioCitaScreen(cita: cita),
        ),
      );
}
