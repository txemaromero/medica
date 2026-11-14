import 'package:flutter/material.dart';

import '../../../app/rutas.dart';
import '../../../core/widgets/botones.dart';
import '../../../core/widgets/pantalla_base.dart';
import '../../../core/widgets/pictogramas.dart';
import '../../../l10n/textos.dart';

/// Pantalla 2: submenú de "Registro de medicamentos".
class MedicamentosMenuScreen extends StatelessWidget {
  const MedicamentosMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = TextosApp.of(context);
    void abrir(String ruta) => Navigator.of(context).pushNamed(ruta);
    return PantallaBase(
      titulo: t.menuMedicamentos,
      cuerpo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TarjetaMenu(
            etiqueta: t.tomasTitulo,
            descripcion: t.medicamentosMenuTomasDescripcion,
            icono: const Pictograma(Icons.task_alt),
            onPressed: () => abrir(Rutas.tomasHoy),
          ),
          const Hueco(),
          TarjetaMenu(
            etiqueta: t.medicamentosMenuNuevo,
            descripcion: t.medicamentosMenuNuevoDescripcion,
            icono: const Pictograma(Icons.add_circle),
            onPressed: () => abrir(Rutas.nuevoMedicamento),
          ),
          const Hueco(),
          TarjetaMenu(
            etiqueta: t.medicamentosMenuVer,
            descripcion: t.medicamentosMenuVerDescripcion,
            icono: const Pictograma(Icons.list_alt),
            onPressed: () => abrir(Rutas.listaMedicamentos),
          ),
          const Hueco(),
          TarjetaMenu(
            etiqueta: t.historialTitulo,
            descripcion: t.medicamentosMenuHistorialDescripcion,
            icono: const Pictograma(Icons.history),
            onPressed: () => abrir(Rutas.historialTomas),
          ),
          const Hueco(),
          TarjetaMenu(
            etiqueta: t.medicamentosMenuCompartir,
            descripcion: t.medicamentosMenuCompartirDescripcion,
            icono: const Pictograma(Icons.share),
            onPressed: () => abrir(Rutas.compartir),
          ),
        ],
      ),
    );
  }
}
