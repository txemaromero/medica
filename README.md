# Salud y Medicación

Aplicación móvil Android (Flutter) para personas mayores de 65 años: recordatorios de medicación (a las horas que se elijan, todos los días o solo algunos, con la dosis de cada toma si cambia según la hora) con seguimiento de las tomas y foto de la caja, medicinas que se toman solo cuando hace falta (con un máximo al día, si se quiere), la cuenta de las pastillas que quedan (también medias, con aviso antes de que se acaben), aviso para renovar la receta, agenda de citas (con aviso la tarde antes), botón de emergencia (con un segundo contacto: un familiar), lectura en voz alta y dictado, un widget en la pantalla de inicio con la próxima toma, y ajustes de accesibilidad (tamaño de texto y temas de alto contraste) y de los avisos (cuándo se repiten y, si se quiere, avisos discretos, que no dicen qué medicina toca). Para la familia y el médico, la medicación y las citas se pueden enviar o imprimir en PDF (con un recordatorio semanal, si se quiere), un familiar puede preparar las medicinas en su móvil y enviarlas, y todos los datos se pueden guardar en una copia de seguridad. La primera vez, un asistente de tres pasos deja la app preparada.

La app implementa un diseño ya validado con Diseño Centrado en el Usuario (encuestas a 70 personas mayores, prototipos en Figma, evaluación heurística de Nielsen y *user journeys*). Todas las decisiones priorizan **simplicidad, legibilidad y prevención de errores**.

Funciona sin conexión, sin cuentas y sin servidor: todo se guarda en el teléfono. Solo el dictado puede necesitar conexión, según el teléfono (lo hace el dictado por voz de Google, no la app). Cómo se protegen los datos, en [Seguridad y privacidad](#seguridad-y-privacidad).

Está preparada para publicarse en Google Play (ver [Versión para Google Play](#versión-para-google-play)) y está en castellano, catalán, gallego y euskera; las tres traducciones son borradores que aún tiene que revisar alguien nativo (ver [Textos e idiomas](#textos-e-idiomas)). La versión de iOS tiene casi todo (falta el widget) y compila en GitHub Actions, pero aún no se ha probado en un iPhone (ver [Limitaciones conocidas](#limitaciones-conocidas)).

## Recorrido en vídeo

![Recorrido por toda la aplicación en un móvil Android, con subtítulos que explican cada paso](demo.webp)

En [demo.webp](demo.webp) hay un recorrido de 10 minutos y medio por toda la app, en 26 escenas, desde la primera vez que se abre. Está grabado en un emulador Android 14 en castellano. Se ven los toques en la pantalla, los permisos y los avisos son los reales del sistema, y los datos son de ejemplo: una semana de uso, que se recupera de una copia de seguridad durante el propio recorrido. Los subtítulos son la narración (la animación no tiene sonido). Empieza al abrir la página y vuelve a empezar al terminar.

<details>
<summary>Las 26 escenas, con el minuto en que empieza cada una</summary>

| Minuto | Escena | Qué se ve |
|---|---|---|
| 0:00 | Salud y Medicación | Qué es la app |
| 0:28 | Primeros pasos: la letra | El asistente de la primera vez y el tamaño de la letra |
| 0:51 | Primeros pasos: los avisos | Los permisos de notificaciones y de alarmas exactas, y «Probar aviso» |
| 1:24 | Primeros pasos: emergencias | El número de emergencia y el resumen final |
| 1:42 | El menú principal | Las cuatro secciones, aún sin datos |
| 2:11 | Recuperar una copia | El selector de ficheros y lo que dice la app antes de sustituir los datos |
| 2:42 | El resumen del día | Las tomas marcadas, la próxima toma y la próxima cita, y los avisos de pocas pastillas y de la receta |
| 3:02 | Llega un aviso | El aviso de una toma sin marcar, con la foto de la caja y sus dos botones, y «Ya la he tomado» |
| 3:31 | Registro de medicamentos | Las cinco opciones |
| 3:46 | Medicamentos registrados | Cinco medicamentos: con fecha de fin, solo algunos días, con la dosis según la hora, con la cuenta de las pastillas y la receta, y uno «cuando haga falta» |
| 4:38 | He comprado más | Sumar las pastillas de una caja nueva |
| 4:52 | Receta renovada | La fecha de la receta nueva |
| 5:06 | Tomas de hoy | Marcar y desmarcar una toma, y anotar un calmante: a partir de qué hora se puede tomar otro |
| 5:41 | Historial | Los últimos siete días |
| 5:57 | Registrar un medicamento | El formulario entero, con la foto elegida de la galería |
| 6:45 | Agenda | Crear una cita con el atajo «En una semana» |
| 7:17 | Emergencias | Los dos botones y el marcador con el 112 |
| 7:36 | Ajustes | La comprobación de los avisos y «Repetir los avisos» |
| 8:06 | Más ajustes | Avisos discretos, leer en voz alta, el número de emergencia y el familiar |
| 8:32 | Tamaño de la letra | De 10 a 35 |
| 8:46 | Tema | Los tres temas, con su vista previa |
| 9:02 | En la pantalla de inicio | El widget con la próxima toma |
| 9:18 | Para el médico o la familia | La vista previa del PDF y el menú de compartir |
| 9:39 | Copias y otro móvil | Las opciones de la copia de seguridad, y añadir las medicinas que ha preparado un familiar en su móvil |
| 10:02 | Idiomas | La app en catalán, gallego y euskera, y otra vez en castellano |
| 10:17 | Y mucho más | TalkBack, y sin Internet, sin cuentas y sin anuncios |

</details>

## Capturas

| Menú principal | Nuevo medicamento | Medicamentos registrados | Confirmar eliminación |
|---|---|---|---|
| ![Menú principal](docs/capturas/01_menu_principal.png) | ![Nuevo medicamento](docs/capturas/03_nuevo_medicamento.png) | ![Medicamentos registrados](docs/capturas/04_medicamentos_registrados.png) | ![Confirmar eliminación](docs/capturas/14_confirmar_eliminar.png) |

| Horas concretas | Días de toma | Modificar medicamento | Foto de la caja |
|---|---|---|---|
| ![Horas concretas](docs/capturas/23_horas_concretas.png) | ![Días de toma](docs/capturas/22_dias_de_toma.png) | ![Modificar medicamento](docs/capturas/15_modificar_medicamento.png) | ![Foto de la caja](docs/capturas/20_foto_de_la_caja.png) |

| Agenda | Emergencias | Ajustes | Tema |
|---|---|---|---|
| ![Agenda](docs/capturas/05_agenda.png) | ![Emergencias](docs/capturas/07_emergencias.png) | ![Ajustes](docs/capturas/08_ajustes.png) | ![Tema](docs/capturas/10_tema.png) |

| Tema oscuro | Tema alternativo | Agenda con texto 35 | Crear cita |
|---|---|---|---|
| ![Tema oscuro](docs/capturas/11_menu_tema_oscuro.png) | ![Tema alternativo](docs/capturas/12_menu_tema_alternativo.png) | ![Agenda con texto 35](docs/capturas/13_agenda_texto_35.png) | ![Crear cita](docs/capturas/06_crear_cita.png) |

| Registro de medicamentos | Tomas de hoy | Cuando haga falta | Historial de tomas |
|---|---|---|---|
| ![Registro de medicamentos](docs/capturas/02_registro_medicamentos.png) | ![Tomas de hoy](docs/capturas/16_tomas_de_hoy.png) | ![Cuando haga falta](docs/capturas/24_cuando_haga_falta.png) | ![Historial de tomas](docs/capturas/17_historial_tomas.png) |

| Asistente: bienvenida | Asistente: avisos | Compartir y copia de seguridad | He comprado más |
|---|---|---|---|
| ![Asistente: bienvenida](docs/capturas/18_asistente_bienvenida.png) | ![Asistente: avisos](docs/capturas/19_asistente_avisos.png) | ![Compartir y copia de seguridad](docs/capturas/21_compartir.png) | ![He comprado más](docs/capturas/25_he_comprado_mas.png) |

| Dosis según la hora | Receta | Límites de "cuando haga falta" | Más de lo que se puede |
|---|---|---|---|
| ![Dosis según la hora](docs/capturas/28_dosis_distinta.png) | ![Receta](docs/capturas/29_receta.png) | ![Límites de "cuando haga falta"](docs/capturas/30_limites.png) | ![Más de lo que se puede](docs/capturas/31_aviso_de_mas.png) |

| Tamaño de texto | Repetir los avisos | Widget en la pantalla de inicio |
|---|---|---|
| ![Tamaño de texto](docs/capturas/09_tamano_texto.png) | ![Repetir los avisos](docs/capturas/27_repetir_avisos.png) | ![Widget en la pantalla de inicio](docs/capturas/26_widget.png) |

En [docs/capturas](docs/capturas) están las 31 capturas (las 17 pantallas, algunas variantes y el widget) y en [docs/informe_ejemplo.pdf](docs/informe_ejemplo.pdf), el PDF para el médico o la familia con los mismos datos. Se generan con `flutter test tool/capturas/capturas_test.dart --update-goldens`, usando Montserrat y los iconos reales; la caja de Omeprazol de las capturas está dibujada por el propio generador, y la receta y los límites se añaden a los datos de ejemplo solo en sus capturas. La del widget es una captura del emulador, porque lo dibuja Android, no Flutter.

## Pantallas

Menú principal → 4 secciones → subpantallas (como máximo dos niveles).

| # | Pantalla | Qué hace |
|---|---|---|
| 1 | Menú principal | Resumen con las tomas de hoy ya marcadas, la próxima toma pendiente y la próxima cita, y cuadrícula 2×2 de tarjetas grandes con pictograma y etiqueta. Si los avisos están activados pero el teléfono no deja mostrarlos, un aviso arriba con **Dar permiso para los avisos**; si quedan pocas pastillas de algún medicamento o hay que renovar alguna receta, otro con **Ver medicamentos registrados**. |
| 2 | Registro de medicamentos | "Tomas de hoy", "Registrar nuevo medicamento", "Ver medicamentos registrados", "Historial de tomas" y "Compartir con el médico o la familia". |
| 3 | Nuevo / modificar medicamento | Nombre (con botón **Dictar el nombre**), dosis e instrucciones (opcionales), **foto de la caja** (hacerla con la cámara o elegirla de la galería), **cuándo se toma** ("Con un horario" o "Solo cuando haga falta", como un calmante: sin avisos ni horas, y con **cuánto se puede tomar** si se quiere: como mucho tantas veces al día y al menos tantas horas entre una toma y otra), tomas al día y a qué horas (**repartidas por igual** desde la primera toma o **a horas concretas**, como el desayuno, la comida y la cena), con 2 tomas o más **la dosis de cada toma** si cambia según la hora (una pastilla por la mañana y media por la noche), **qué días** ("Todos los días", "Algunos días de la semana" con un botón por día, o "Cada varios días" desde un primer día), duración ("Siempre" o "Hasta un día concreto"), **receta** (si se acaba un día, cuál: la app avisa una semana antes) y, si se quiere, **las pastillas que quedan** (cuántas hay, con media si hace falta, y cuántas en cada toma, de media en media; si la dosis cambia según la hora, las de cada toma), con botones + y − grandes. Muestra un resumen en vivo de los avisos y, si se lleva la cuenta, de para cuántos días llegan las pastillas. Botón **Crear recordatorio** (**Guardar medicamento** si es "cuando haga falta") o **Guardar cambios**. |
| 4 | Medicamentos registrados | Tarjetas con nombre, foto de la caja, dosis, tomas, días (si no son todos), horas (o "Cuando haga falta, sin avisos"), duración, receta ("Receta: hasta el…" o, si se acaba en una semana o menos, "La receta se acaba dentro de 3 días: pide cita con tu médico para renovarla"), pastillas que quedan ("Quedan 15 pastillas, para unos 15 días", con un aviso si quedan pocas) e instrucciones, y botones **Ya la he renovado** (si hay que renovar la receta: pide la fecha de la nueva o la quita), **He comprado más** (si se lleva la cuenta), **Modificar** y **Eliminar** (este en rojo, con confirmación y **Deshacer**). |
| 5 | Agenda | Citas ordenadas (próximas y pasadas), con **Modificar** en las próximas y botón fijo **Crear cita**. |
| 6 | Crear / modificar cita | Motivo (con botón **Dictar el motivo**), fecha (con atajos "Hoy", "Mañana" y "En una semana") y hora con botones + y −, lugar y notas opcionales. |
| 7 | Emergencias | Pantalla intermedia con un botón enorme **Llamar** al número de emergencia y, si hay un familiar guardado, otro botón **Llamar a …** con su nombre y su número. Entrar no llama. |
| 8 | Ajustes | Sonidos, vibración, notificaciones y **Leer en voz alta** (rojo = desactivado, verde = activado, siempre con texto), **Probar aviso**, **Repetir los avisos** (cuándo se repite el de una toma sin marcar y los minutos de "Recordar en 10 min"), **Avisos discretos** (sin el nombre de la medicina, el motivo de la cita ni la foto), número de emergencia, contacto de un familiar, **Poner la próxima toma en la pantalla de inicio** (el widget) y accesos a tamaño de texto, tema y compartir. Bajo "Activar notificaciones", la **comprobación de los avisos**: "listos para llegar a su hora" o lo que falta, con su botón. |
| 9 | Tamaño de texto | **Aumentar (+)** / **Reducir (−)** de 5 en 5 (10–35, base 20) con zona de muestra en vivo. |
| 10 | Tema | Predeterminado, oscuro o alternativo, con vista previa antes de aplicarlo. |
| 11 | Tomas de hoy | Una tarjeta por toma, en orden de hora, con la foto de la caja, su estado ("Tomada a las 08:05", "Pendiente", "Sin marcar. Era a las 09:00." o "Aplazada") y un botón grande **Ya la he tomado** (o **Desmarcar**, con **Deshacer**). Arriba, "Has tomado 2 de 4" y, si está activada la lectura en voz alta, **Escuchar las tomas de hoy**. Debajo, los medicamentos **"cuando haga falta"**, cada uno con las veces que se ha tomado hoy ("Hoy lo has tomado 2 veces: a las 08:10 y 14:30"), sus límites y si ya se han alcanzado ("La próxima, a partir de las 16:30"), un botón **Lo he tomado ahora** (que, si se pasa de los límites, lo explica y pregunta antes de anotarlo) y, si se anotó por error, **Quitar la última**. Se abre sola al tocar un aviso de toma, o al abrir la app si en la última hora llegó el aviso de una toma que sigue sin marcar. |
| 12 | Historial de tomas | Los últimos 7 días: arriba, cuántas tomas se marcaron de las que tocaban ("has marcado 18 de 21 tomas (86 %)"); por cada día, cuántas se marcaron, qué pasó con cada toma y lo que se tomó "cuando hacía falta". |
| 13 | Primeros pasos (asistente) | Solo la primera vez: bienvenida y tres pasos (tamaño de la letra, avisos con sonido y vibración, número de emergencia) con un resumen final. Se puede saltar. |
| 14 | Compartir y copia de seguridad | **Enviar mi medicación y citas** (PDF por WhatsApp, correo…), **Imprimir** y **Recordarme enviarlo cada semana**; **Guardar una copia**, **Enviar una copia** y **Recuperar una copia** (pregunta antes de sustituir los datos), y **Añadir medicamentos de otro móvil** (los de una copia que ha preparado un familiar, sin borrar nada). |
| 15 | He comprado más | Cuántas quedan, un campo para las que se han comprado ("Mira cuántas trae la caja") y cuántas habrá ("Tendrás 43 pastillas.", o "Tendrás 42 pastillas y media." si quedaba media). |
| 16 | Repetir los avisos | Desde Ajustes: si no se marca una toma, repetir el aviso a los 15 o 30 minutos, a la hora o no repetirlo, y los minutos del botón "Recordar en…" (5, 10, 15 o 30), cada opción con un ejemplo ("Una toma de las 08:00 se repite a las 08:30"). Se guarda al tocar. |
| 17 | Receta renovada | Desde "Ya la he renovado": el último día de la receta nueva (se propone dentro de un mes), **Guardar la fecha nueva** o **Ya no hace falta renovarla**. |

Todas las pantallas salvo el menú tienen la **barra superior común**: botón casa (vuelve al menú), título y botón atrás. El botón atrás de Android también funciona. En el asistente, "Atrás" vuelve al paso anterior.

## Requisitos

| Herramienta | Versión usada |
|---|---|
| Flutter | 3.47.8 (canal estable) con Dart 3.13.7 |
| JDK | 17 |
| Android SDK | plataforma 36, build-tools 36.0.0, platform-tools |
| Android NDK | 28.2.13676358 (la pide la plantilla de Flutter) |
| Xcode | Solo para iOS, en un Mac. No se ha usado: iOS se compila en GitHub Actions |
| Dispositivo | Android 7.0 (API 24) o superior; iPhone con iOS 15 o superior (sin probar) |

Si Gradle no consigue instalar la NDK por su cuenta (las *command-line tools* 23 ya no instalan paquetes desde `sdkmanager`), instálala con el nuevo Android CLI:

```sh
android sdk install "ndk/28.2.13676358"
```

## Compilar, ejecutar y probar

```sh
flutter pub get
flutter analyze              # análisis estático (sin avisos)
flutter test                 # tests unitarios y de widgets
flutter run                  # en un móvil o emulador conectado
flutter build apk --debug    # APK en build/app/outputs/flutter-apk/app-debug.apk
flutter gen-l10n             # tras cambiar un texto de lib/l10n/*.arb
```

Para instalar el APK en un móvil conectado por USB: `adb install -r build/app/outputs/flutter-apk/app-debug.apk`.

### Comprobación automática

En cada cambio que llega a GitHub (`main` y pull requests), [GitHub Actions](.github/workflows/comprobacion.yml) comprueba que los textos generados de `lib/l10n` están al día, el formato, el análisis estático y los tests, y compila el APK de depuración y el App Bundle de release; el APK queda descargable desde la ejecución. Tarda unos 16 minutos. Usa Ubuntu 24.04 fijo y, al empezar, borra herramientas que trae el servidor y no se usan (.NET, Haskell, CodeQL, las NDK que no son la de Flutter…): sin eso, el App Bundle no cabía en el disco. Los mismos pasos se lanzan en local, antes de subir un cambio, con:

```sh
powershell -ExecutionPolicy Bypass -File tool/comprobar.ps1            # -Release: también el App Bundle
```

Para que nadie pueda colar código en la compilación:
- se usan exactamente las versiones de `pubspec.lock` (`flutter pub get --enforce-lockfile`): si no cuadran con `pubspec.yaml`, falla en vez de cambiarlas;
- las acciones de GitHub van fijadas por su commit, con la versión en un comentario, porque una etiqueta como `v7` se puede mover a otro código;
- el token de GitHub de los dos flujos solo puede leer el repositorio (`permissions: contents: read`);
- Gradle comprueba la suma SHA-256 de la distribución que descarga (`distributionSha256Sum` en `android/gradle/wrapper/gradle-wrapper.properties`). Si se cambia la versión de Gradle, hay que cambiar también la suma, que Gradle publica junto a cada versión.

Una vez al mes, [Dependabot](.github/dependabot.yml) propone con una pull request las versiones nuevas de las acciones y de los paquetes de Dart: las menores, juntas, y cada mayor por separado. Nada se actualiza solo: cada propuesta pasa la comprobación antes de aceptarla.

La compilación de iOS sin firmar está en un flujo aparte que se lanza a mano ([ios.yml](.github/workflows/ios.yml)): en un repositorio privado, los minutos de macOS cuentan por diez. Conviene lanzarlo cada vez que cambia algo de `ios/` o de los avisos, porque el código Swift se escribe sin un Mac. La primera vez que se lanzó, el 27 de octubre de 2026, compiló todo a la primera, también los canales de voz y de ficheros escritos en Swift y la fase 12.

### Versión para Google Play

`flutter build appbundle --release` genera `build/app/outputs/bundle/release/app-release.aab`, reducido con R8 (`isMinifyEnabled` e `isShrinkResources` en `android/app/build.gradle.kts`: Flutter ya los activa en release, pero así no cambia sin darse cuenta). Se firma con la clave de subida si existe `android/key.properties` (no se sube al repositorio); si no, con la de depuración, que sirve para probar pero no para publicar. Los pasos completos para publicar (clave, ficha de la tienda, seguridad de los datos, declaración de apps de salud, alarmas exactas, pruebas cerradas) están en [docs/publicacion.md](docs/publicacion.md), y la política de privacidad, en [docs/politica_de_privacidad.md](docs/politica_de_privacidad.md).

Con algunas versiones del JDK 17, `apkanalyzer` (que Flutter usa al revisar el App Bundle) se niega a arrancar; se evita con la variable `SKIP_JDK_VERSION_CHECK=1`, que `tool/comprobar.ps1 -Release` ya pone.

### Textos e idiomas

Todos los textos de la app (pantallas, avisos, frases que se leen en voz alta, mensajes de error, PDF y nombres de días y meses) están en [lib/l10n/app_es.arb](lib/l10n/app_es.arb), unos 720, y no en el código. Hay **traducciones al catalán, al gallego y al euskera** (`app_ca.arb`, `app_gl.arb` y `app_eu.arb`): son borradores hechos con IA, pendientes de que los revise alguien nativo. En [docs/traducciones.md](docs/traducciones.md) están cómo revisarlas, lo que conviene mirar primero en cada idioma y la ficha de Google Play traducida.

Para **cambiar un texto**, se edita en `app_es.arb` (y en las traducciones) y se ejecuta `flutter gen-l10n`. Los tests que buscan botones y títulos lo hacen con el helper `es` ([test/helpers/textos.dart](test/helpers/textos.dart)) y siguen pasando; los que comprueban una frase entera, como "Próxima toma: Paracetamol, hoy a las 16:00.", hay que cambiarlos a mano.

Para **añadir un idioma**, por ejemplo el portugués:

1. Copiar `lib/l10n/app_es.arb` como `lib/l10n/app_pt.arb`, cambiar `"@@locale": "es"` por `"pt"` y traducir los textos. Lo que va entre llaves (`{hora}`, `{medicamento}`) se deja igual; en los plurales (`{cantidad, plural, =1{1 cita} other{{cantidad} citas}}`) se traduce lo de dentro de cada opción. Las entradas que empiezan por `@` son notas para quien traduce.
2. `flutter gen-l10n` regenera `lib/l10n/textos_app*.dart` (se suben al repositorio).
3. Añadir `pt` a `CFBundleLocalizations` en [ios/Runner/Info.plist](ios/Runner/Info.plist) y a [android/app/src/main/res/xml/locales_config.xml](android/app/src/main/res/xml/locales_config.xml), y copiar [android/app/src/main/res/values/strings.xml](android/app/src/main/res/values/strings.xml) (los tres textos del widget que se ven antes de abrir la app) como `values-pt/strings.xml` traducido. En iOS, además, `ios/Runner/pt.lproj/InfoPlist.strings` con los textos de los permisos de cámara y fotos, añadido al proyecto de Xcode como los demás.
4. `flutter test`: comprueba que la traducción tiene todos los textos y los mismos huecos que el castellano, que el idioma está declarado en Android y en iOS, y recorre las pantallas en cada idioma con la letra al máximo.

Cada idioma puede reordenar los huecos y cambiar la forma de las frases: en catalán, por ejemplo, la fecha elige "de" o "d'" según el mes ("25 d'octubre", "27 de novembre") y en euskera va en otro orden ("2026ko urriaren 25a, igandea").

La app sale en el idioma del teléfono si está traducida a él y, si no, en castellano. En **Android 13 o posterior** también se puede elegir un idioma solo para la app, sin cambiar el del teléfono (Ajustes del teléfono → Aplicaciones → Salud y Medicación → Idioma). Si el idioma cambia con la app abierta, los avisos ya programados y el widget se vuelven a escribir en el nuevo. La voz y el dictado usan el idioma de los textos (la variante de España si hay varias: `es-ES`, `ca-ES`, `gl-ES`, `eu-ES`), así que el teléfono necesita la voz de ese idioma. La ficha de Google Play traducida está en [docs/traducciones.md](docs/traducciones.md), y sus capturas y su gráfico destacado en cada idioma, en [docs/google_play](docs/google_play).

### Tests en un móvil o emulador

Los tests de [integration_test](integration_test) se ejecutan en Android con la base de datos y las notificaciones reales:

```sh
flutter devices                                   # identificador del dispositivo
flutter test integration_test -d <dispositivo>    # unos 2 minutos, con la compilación
```

Comprueban que el asistente de la primera vez aparece en una instalación nueva y se recuerda al terminarlo, que crear, modificar, eliminar y deshacer programa y cancela los avisos en el propio Android (con la toma identificada en la notificación para sus botones), que una medicina de algunos días a horas concretas deja avisos semanales, que una "cuando haga falta" no deja ninguno y se anota en "Tomas de hoy", que con pocas pastillas se programa el aviso y "He comprado más" las suma, que marcar una toma en "Tomas de hoy" se guarda y cancela su repetición, que "Probar aviso" funciona (con permiso y sin él), que el marcador acepta `tel:`, que se consulta el permiso de alarmas exactas, que los canales nativos de la voz, del sistema (batería) y del widget responden y que el PDF (con la letra de la app) y la copia de seguridad funcionan con la base de datos real: se vacía todo y se recupera.

La prueba de **entrega real de avisos** espera en tiempo real a que lleguen. Tarda unos 2 minutos y necesita el permiso de notificaciones, así que hay que pedirla expresamente:

```sh
flutter test integration_test -d <dispositivo> --no-uninstall      # instala la app y la deja
adb shell pm grant es.saludmayores.salud_mayores android.permission.POST_NOTIFICATIONS
flutter test integration_test/entrega_avisos_test.dart -d <dispositivo> \
  --no-uninstall --dart-define=PRUEBA_ENTREGA=true
```

Para un emulador sin Android Studio: `android sdk install "emulator" "system-images/android-34/google_apis/x86_64"`, `avdmanager create avd -n salud_api34 -k "system-images;android-34;google_apis;x86_64" -d pixel_6` y `emulator -avd salud_api34`.

Lo que hay que ver y oír (sonido, vibración, móvil bloqueado, reinicio, TalkBack) está en la lista de [pruebas en un móvil real](docs/pruebas_en_dispositivo.md).

## Estructura del proyecto

Organización por funcionalidades; cada una separa dominio (lógica pura), datos, aplicación (estado) y presentación.

```
lib/
├── main.dart                      Arranque: preferencias, base de datos, carpeta de fotos, notificaciones
├── app/                           App, rutas, proveedores (Riverpod) y respuestas a los avisos y al widget
├── core/
│   ├── tema/                      Paletas de los 3 temas, ThemeData, cálculo de contraste WCAG
│   ├── tiempo/                    HoraDelDia y formato de fechas con palabras
│   ├── texto/                     Ordenación alfabética sin tildes
│   └── widgets/                   Barra superior, botones, interruptor, selectores, diálogos, párrafos…
├── archivos/                      Compartir, guardar, abrir e imprimir ficheros (canal con CanalArchivos.kt y .swift)
├── data/base_datos.dart           SQLite (sqflite): tablas medicamentos, citas y tomas
├── l10n/                          Textos de la app (app_es.arb y sus traducciones: ca, gl, eu) y la clase TextosApp que genera gen-l10n
├── notificaciones/
│   ├── planificador_avisos.dart   Qué avisos deben existir (lógica pura y testeada)
│   ├── sincronizador_avisos.dart  Mantiene los avisos del sistema al día
│   ├── carga_aviso.dart           Qué lleva cada notificación (toma, cita, pastillas, receta o resumen) y el botón del widget
│   └── servicio_notificaciones_locales.dart   flutter_local_notifications + timezone
├── voz/                           Leer en voz alta y dictar (canal con MainActivity.kt y CanalVoz.swift), textos para oír
├── widget_inicio/                 Datos del widget de la pantalla de inicio y su canal (con CanalWidget.kt)
└── features/
    ├── asistente/                 Primeros pasos (solo la primera vez)
    ├── menu_principal/
    ├── medicamentos/              domain (también la cuenta de las pastillas y la receta) · data (también las fotos) · application · presentation
    ├── tomas/                     Tomas de hoy (y los límites de los "cuando haga falta") e historial: domain · data · application · presentation
    ├── agenda/                    domain · data · application · presentation
    ├── emergencias/
    ├── compartir/                 PDF para el médico o la familia, copias de seguridad (comprobadas y recuperadas en una transacción) y medicamentos de otro móvil
    └── ajustes/                   domain · data · application · presentation (también "Repetir los avisos" y "Avisos discretos")
android/app/src/main/kotlin/…/MainActivity.kt   Voz del teléfono (TextToSpeech) y dictado (RecognizerIntent)
android/app/src/main/kotlin/…/CanalArchivos.kt  Menú "Compartir", guardar y abrir documentos del sistema
android/app/src/main/kotlin/…/CanalSistema.kt   Cómo trata Android la batería de la app, y sus ajustes
android/app/src/main/kotlin/…/WidgetToma.kt     Widget "Próxima toma" (diseño en res/layout/widget_toma.xml) y el código secreto de su botón
android/app/src/main/kotlin/…/CanalWidget.kt    Datos del widget, lo que se pulsa en él y ponerlo en la pantalla de inicio
android/app/src/main/res/xml/reglas_copia*.xml   Qué entra en la copia automática de Android (12+ y 11 o anteriores)
ios/Runner/CanalVoz.swift          Voz del iPhone (AVSpeechSynthesizer), con el mismo canal que en Android
ios/Runner/CanalArchivos.swift     Compartir, guardar y abrir ficheros en iOS, con el mismo canal que en Android
assets/icono/                      Imágenes de origen del icono de la app
test/
├── helpers/                       Dobles en memoria, entorno de prueba y textos en castellano (es)
├── unit/                          Lógica, validaciones, repositorios (SQLite en memoria), fotos, voz, textos
└── widget/                        Flujos de pantallas y accesibilidad
integration_test/                  Tests en un móvil o emulador Android real
.github/workflows/                 Comprobación automática (Android en cada cambio; iOS a mano)
.github/dependabot.yml             Propuestas mensuales de versiones nuevas de las acciones y los paquetes
docs/pruebas_en_dispositivo.md     Lista de pruebas manuales en un móvil
docs/traducciones.md               Estado de las traducciones, qué revisar en cada idioma y la ficha de Google Play traducida
docs/publicacion.md                Cómo publicar en Google Play, con los textos de la ficha
docs/politica_de_privacidad.md     Política de privacidad
docs/prueba_cerrada.md             Prueba cerrada de Google Play: organización, invitación, guía y preguntas
docs/google_play/                  Icono, gráfico destacado y capturas para la ficha de Google Play (en los cuatro idiomas)
docs/informe_ejemplo.pdf           Ejemplo del PDF para el médico o la familia
l10n.yaml                          Configuración de gen-l10n (el castellano, idioma por defecto)
tool/comprobar.ps1                 Los pasos de la comprobación automática, en local
tool/capturas/                     Generador de las capturas del README y del PDF de ejemplo
tool/google_play/                  Generador de los recursos de Google Play
tool/icono/                        Generador del icono de la app y del de las notificaciones
```

## Modelo de datos

- **Medicamento**: `id`, `nombre`, `numTomas` (1–12), `frecuenciaHoras`, `horaInicio`, `fechaCreacion` y, opcionales, `dosis`, `instrucciones`, `fechaFin` (último día del tratamiento, incluido), `foto` (nombre del fichero de la foto de la caja), `horasLibres`, `dias`, `aDemanda`, `dosisPorToma`, `existencias`, `maximoAlDia`, `horasEntreTomas` y `renovarReceta` (último día de la receta). Si no tiene horas libres, las horas de toma son `horaInicio + i × frecuencia`; todas deben caber en el día (`numTomas × frecuencia ≤ 24`). Al elegir el número de tomas se propone repartirlas por igual (3 tomas → cada 8 h), así el formulario nunca llega a una combinación imposible. Con `horasLibres` (una por toma, distintas) las horas son esas, en orden. `dias` es "todos los días", unos días de la semana (`semana:1,4`, lunes y jueves) o cada 2–30 días desde un primer día (`cada:2:2026-10-26`); en la base de datos, `NULL` es todos los días. Con `aDemanda` ("cuando haga falta") no hay horas ni días de toma: se guarda como una toma diaria, pero no se usa. `dosisPorToma` es la dosis de cada toma, en el orden de las horas, si cambia según la hora (entonces `dosis` queda vacía). `existencias` es la cuenta de las pastillas: cuántas había (`cantidad`) en un momento (`contadas`) y cuántas se toman cada vez (`porToma` o, si cambian según la hora, `porTomas`); todas en medias pastillas (14,5) y las que quedan se calculan (ver [Existencias](#decisiones-técnicas)). `maximoAlDia` (1–12) y `horasEntreTomas` (1–24) son los límites de un "cuando haga falta"; en los demás no se guardan.
- **Cita**: `id`, `titulo`, `fecha`, `hora`, `lugar` y `notas` opcionales. La fecha se guarda como `AAAA-MM-DD` y la hora en minutos, sin problemas de zona horaria.
- **Registro de toma**: `medicamentoId`, `nombreMedicamento`, `fecha` y `hora` previstas (juntos forman la clave: un registro por toma), `estado` (`tomada` o `aplazada`), `momento` en que se marcó y, si se aplazó, `recordarEn`. Guarda el nombre para que el historial se entienda aunque el medicamento se renombre o se elimine. Solo existen las tomas que la persona ha marcado o aplazado; "sin marcar" y "pendiente" se calculan. En los medicamentos "cuando haga falta", la hora es la de la toma (una por minuto).
- **Ajustes** (shared_preferences): `sonidoActivado`, `vibracionActivada`, `notificacionesActivadas` y `leerEnVozAlta` (desactivados por defecto), `numeroEmergencia`, `familiarNombre` y `familiarNumero` (el segundo contacto, opcional), `tamanoTexto` (10–35, pasos de 5, base 20), `tema`, `recordarResumen` (el recordatorio semanal de enviar el PDF), `minutosRepeticion` (15, 30, 60 o 0, sin repetir; por defecto 30), `minutosAplazamiento` (5, 10, 15 o 30; por defecto 10) y `avisosDiscretos` (desactivado por defecto). Un valor que no sea una de las opciones pasa a ser el de por defecto. Aparte, `asistenteCompletado` recuerda si ya se pasó por el asistente.
- **Copia de seguridad**: un fichero JSON con `app`, `formato` (3, con las horas, los días, "cuando haga falta", la dosis de cada toma y la cuenta de las pastillas con medias, que es opcional; la app sigue leyendo las de los formatos 1 y 2, y una versión anterior rechaza las del 3 en vez de leerlas mal), `creada`, los medicamentos, citas y tomas anotadas, los ajustes y las fotos de las cajas (en base64). Es también lo que lee **Añadir medicamentos de otro móvil**, que solo usa los medicamentos, las citas y las fotos.
- **Widget**: no tiene datos propios. Cada vez que se ponen al día los avisos, la app le pasa las tomas de los próximos 7 días (en las preferencias `widget_toma` de Android; ver [Widget de la pantalla de inicio](#decisiones-técnicas)). No va en la copia, ni en la copia automática de Android.

La base de datos está en la **versión 10**. Al abrir una de la versión 1 se añaden las columnas `dosis`, `instrucciones` y `fecha_fin`; desde la 1 o la 2 se crea la tabla `tomas`; desde la 3 o anteriores se añade la columna `foto`; desde la 4 o anteriores, `horas` y `dias`; desde la 5 o anteriores, `a_demanda`, desde la 6 o anteriores, `existencias`, `existencias_contadas` y `existencias_por_toma`, desde la 7 o anteriores, `maximo_al_dia` y `horas_entre_tomas`; desde la 8 o anteriores, `renovar_receta`, y desde cualquiera anterior, `dosis_por_toma` (una lista JSON) y `existencias_por_tomas`, siempre sin perder los datos. Las medias pastillas no necesitan columnas nuevas: SQLite guarda `14.5` como número real en `existencias`. Un test lo comprueba con una base de datos real de la versión 1.

Las fotos se guardan como ficheros en la carpeta privada de la app (`fotos/`); en la base de datos solo va el nombre del fichero, porque la ruta de la carpeta puede cambiar (en iOS, al actualizar la app).

## Decisiones técnicas

**Estado: Riverpod 3.** Inyección de dependencias sencilla (los tests sustituyen repositorios, notificaciones, marcador y reloj) y estado reactivo sin generación de código. Se usa de forma consistente con `Notifier` y `AsyncNotifier`.

**Persistencia: sqflite + shared_preferences.** sqflite no necesita generación de código y se prueba con SQLite real en memoria (`sqflite_common_ffi`). Los repositorios están detrás de interfaces.

**Recordatorios.**
- El *planificador* calcula, a partir de los datos guardados (medicamentos, citas y tomas marcadas), la lista completa de avisos con identificadores estables (rangos separados para tomas diarias y semanales, citas, pastillas que quedan, recetas, aplazados, avisos día a día y el recordatorio del resumen; ver `planificador_avisos.dart`). Tras cualquier cambio (guardar, eliminar, deshacer, marcar una toma, cambiar un interruptor o el idioma) el *sincronizador* deja en Android exactamente esa lista y pone al día el widget de la pantalla de inicio. Así, al eliminar un medicamento o una cita, sus avisos quedan cancelados, y "Deshacer" los recupera.
- La primera sincronización de cada arranque reprograma todo desde cero (recupera lo que Android haya descartado). Las siguientes solo cancelan lo que sobra y programan lo nuevo o lo que ha cambiado, y las pantallas no esperan a que terminen: guardar es inmediato aunque haya decenas de avisos.
- Las tomas de los tratamientos sin fin son avisos recurrentes: diarios o, si solo se toman algunos días de la semana, semanales (uno por día y hora). Las de "cada varios días" no tienen repetición en Android y se programan día a día, como los tratamientos con fecha de fin. Los medicamentos "cuando haga falta" no tienen avisos de tomas. Si se lleva la cuenta de las pastillas, hay además un aviso cuando quedan pocas (ver **Existencias**, más abajo), y si se pone el último día de la receta, otro para renovarla (ver **Receta**). Las citas avisan la tarde antes a las 18:00, el mismo día a las 08:00 y 1 hora antes (se omite el de la mañana si coincidiría con el de 1 hora antes, y cualquiera que ya haya pasado).
- **Tratamientos con fecha de fin**: un aviso recurrente no se detendría solo, así que se programa un aviso único por toma y día, como mucho para los próximos 14 días. La app renueva esa ventana cada vez que se abre, y el último aviso de la ventana recuerda abrirla. Si hubiera muchos tratamientos, la ventana se acorta para no pasar de 400 avisos, porque Android limita las alarmas por aplicación.
- **Probar aviso** (Ajustes) envía una notificación al momento con el sonido y la vibración elegidos. Si falta el permiso del teléfono, la app lo explica y ofrece abrir directamente los ajustes de notificaciones del teléfono.
- **Sonido y vibración**: en Android 8+ se fijan por canal de notificación y no se pueden cambiar después, así que hay un canal por cada combinación de interruptores y se elige el que corresponde.
- **Notificaciones desactivadas** (valor por defecto): no se programa nada. Al activarlas se pide el permiso de Android 13+; si se deniega, se explica cómo darlo y el interruptor sigue apagado.
- **Alarmas exactas** (Android 12+/14+): se ofrece conceder el permiso con una explicación previa. Sin él se usan alarmas inexactas, que pueden llegar unos minutos tarde.
- **Reinicio del teléfono**: el `ScheduledNotificationBootReceiver` del plugin vuelve a programar los avisos, y además la app los resincroniza cada vez que se abre.
- Solo se cancelan los avisos *pendientes*: una notificación ya mostrada y sin leer no se borra al guardar otro dato.

**Avisos fiables.**
- **Comprobación de los avisos** (Ajustes): con los avisos activados, una tarjeta dice si están "listos para llegar a su hora" o qué lo impide, con un botón para arreglarlo: el permiso de mostrar avisos, el de hora exacta o el ahorro de batería. Se comprueba de nuevo cada vez que se vuelve a la app, porque todo eso se cambia en los ajustes del teléfono.
- **Permiso quitado**: si los avisos están activados pero el teléfono no deja mostrarlos, el menú principal lo avisa. Antes no se notaba: la app seguía programando avisos que nunca aparecían. Pasa al quitar el permiso en los ajustes del teléfono y también con la **copia automática de Android**: en el emulador se comprobó (con `bmgr`) que al reinstalar la app Android recupera los datos y los ajustes, y salta el asistente, pero no el permiso.
- **Ahorro de batería**: en un Pixel, la optimización normal de Android no retrasa los avisos a hora exacta, así que solo se señala si la app está **restringida** en segundo plano (en cualquier móvil) o si el fabricante es de los que cierran apps por su cuenta (Samsung, Xiaomi, Huawei, Honor, Oppo, Realme, Vivo, OnePlus, Meizu). El botón explica qué tocar y abre la pantalla de la app en los ajustes del teléfono; no se pide la exención directamente (`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`), porque Google Play la limita a muy pocos tipos de apps. El canal está en `CanalSistema.kt`.

**Existencias.**
- Las pastillas que quedan no se guardan: se calculan a partir de la cuenta (cuántas había y cuándo), la pauta y lo anotado. Así, marcar, desmarcar o "Deshacer" una toma nunca descuadra la cuenta.
- **Cada toma prevista se descuenta al llegar su hora**, se marque o no (o al marcarla, si se marca antes). Es una decisión de seguridad: quien se olvida de marcar las tomas no se queda sin pastillas sin aviso, y si se salta alguna, el aviso llega antes de tiempo, no después. En los de "cuando haga falta" se descuenta cada toma anotada.
- **Quedan pocas** cuando no llegan para una semana, contando con que se toman todas las previstas (y si llegan hasta el final del tratamiento, nunca son pocas); en los de "cuando haga falta", cuando quedan 5 o menos. Entonces lo dicen la tarjeta del medicamento y el menú principal, y llega el aviso "Te quedan pocas pastillas" a las 10:00 del día en que dejan de llegar para una semana. Mientras sigan siendo pocas, cada vez que se abre la app el aviso se programa para las 10:00 siguientes; si cambia algo (una toma marcada antes de su hora, "He comprado más"), se mueve al nuevo día. Tocarlo abre la lista de medicamentos.
- **Medias pastillas**: todas las cantidades van de media en media. "Pastillas que tienes ahora" admite "14,5" (o "14.5"), cuántas en cada toma sube y baja de media en media, y si la dosis cambia según la hora se pone la de cada toma, que se descuenta en la suya. Los textos lo dicen con palabras ("Quedan 14 pastillas y media", "Queda media pastilla"). En la base de datos van en las mismas columnas, como número real.
- **He comprado más** suma las compradas (cajas enteras) a las que quedan, también si quedaba media. Al modificar el medicamento, el formulario muestra las que quedan; si se cambia el número, cuántas en cada toma o la pauta, la cuenta empieza de nuevo desde ese momento con lo que diga el formulario.

**Dosis según la hora.**
- Con 2 tomas o más, "Dosis en cada toma" permite una distinta en cada una. Se guarda una por toma, en el orden de las horas del medicamento (las horas concretas se ordenan al guardar, así que el formulario empareja cada dosis con su toma y las reordena con ellas). Cada aviso, su repetición, "Tomas de hoy" y la voz dicen la de su toma; la lista y el PDF, todas ("Dosis: 1 pastilla a las 08:00 y media pastilla a las 21:00").
- Al elegirla, el campo de la dosis de arriba se cambia por una explicación y la pantalla vuelve a la sección, para no perderla de vista; cada toma empieza con la dosis que hubiera arriba.

**Límites de los "cuando haga falta".**
- Como mucho tantas veces al día y al menos tantas horas entre una toma y otra, los dos opcionales. "Tomas de hoy" dice si ya se ha llegado al máximo o desde qué hora se puede tomar otra vez ("La próxima, a partir de las 17:40").
- "Lo he tomado ahora" calcula los límites en el momento de pulsar (la pantalla puede llevar rato abierta) y, si se pasa, lo explica y pregunta antes de anotarlo: no lo impide, porque lo anotado tiene que ser lo que de verdad se ha tomado. El tiempo entre tomas cuenta desde la hora anotada (sin segundos) y en horas reales, también en el cambio de hora.

**Receta.**
- Se guarda el **último día de la receta**, si se pone. Una semana antes, a las 10:00, llega "Renueva la receta" ("La receta de Omeprazol se acaba el viernes, 20 de noviembre de 2026. Pide cita con tu médico para renovarla."); desde ese día, la tarjeta y el menú principal lo dicen, y cada vez que se abre la app el aviso se vuelve a programar para las 10:00 siguientes, como el de las pastillas, hasta que se pulse **Ya la he renovado** y se ponga la fecha de la nueva (o se quite).
- Si el tratamiento termina antes que la receta, o ese mismo día, no hace falta renovarla y no se avisa.

**Seguimiento de tomas.**
- Los avisos de tomas llevan dos botones: **Ya la he tomado** y **Recordar en 10 min** (o en 5, 15 o 30, según Ajustes → **Repetir los avisos**). Los dos abren la app en "Tomas de hoy", que muestra el resultado ("Anotado: has tomado Omeprazol (09:00)." o "Te lo recordaremos a las 09:10."). Así la persona ve qué ha pasado, y la respuesta se guarda en el mismo proceso que el resto de la app, sin un segundo proceso en segundo plano escribiendo a la vez en la base de datos. Tocar el texto del aviso abre "Tomas de hoy" sin marcar nada.
- **Varios avisos a la vez** (por ejemplo, dos medicinas a la misma hora): Android los junta en un grupo, y al tocar el grupo abre la app sin decir de qué aviso se trata y los retira todos. Lo destapó la prueba completa en el emulador: la app se quedaba en la última pantalla que se había visto. Ahora, si la app se abre sin venir de un aviso (desde el grupo o desde su icono) y en la última hora ha llegado el aviso de una toma que sigue sin marcar, abre "Tomas de hoy" encima de lo que hubiera, y "Atrás" vuelve a donde estaba. Al volver del segundo plano solo cuentan los avisos que han llegado mientras tanto, así que volver de la cámara, del marcador o de los ajustes del teléfono no cambia de pantalla.
- Si una toma no se marca, **30 minutos después** (por defecto) llega "¿Has tomado tu medicina?", también con los botones. Marcarla o aplazarla cancela esa repetición; "Recordar en 10 min" programa un aviso único 10 minutos después. En Ajustes → **Repetir los avisos** se elige repetirlo a los 15 o 30 minutos, a la hora o no repetirlo, y los minutos del botón (5, 10, 15 o 30). En iOS los botones de un aviso se fijan al abrir la app, así que hay una categoría de notificación por cada opción de minutos.
- **Avisos discretos** (Ajustes, desactivados por defecto): los avisos dicen el nombre de la medicina, la dosis y el motivo y el lugar de la cita, y llevan la foto de la caja, y Android los enseña en la pantalla de bloqueo con sus ajustes normales. Con esta opción, los de tomas, pastillas, recetas y citas solo dicen la hora y que se toque el aviso para verlo ("Hora de tu medicina. La de las 08:00. Toca aquí para ver cuál es."), sin foto. Lo ideal sería un texto con el móvil bloqueado y otro al desbloquearlo (la "versión pública" de Android), pero `flutter_local_notifications` no lo permite; la visibilidad "secreta", que sí permite, quitaría el aviso entero de la pantalla de bloqueo, y una persona mayor oiría el sonido sin ver nada. Por eso el texto es discreto siempre, también desbloqueado, y vale igual en iOS. Los botones siguen: "Ya la he tomado" abre la app y dice cuál ha anotado, con "Deshacer", y lo que se lee en voz alta sale de los datos, no del aviso. El widget no cambia: la app nunca lo pone sola.
- **Limitación de Android encontrada al probar en el emulador**: con `flutter_local_notifications`, un aviso recurrente calcula su primera vez a partir de "ahora" e ignora la fecha pedida, así que no se puede programar uno diario que *empiece mañana*. Por eso las repeticiones son avisos únicos, día a día (en la misma ventana de hasta 14 días que renueva la app), y si una toma se marca antes de su hora, su aviso diario o semanal se sustituye por avisos únicos desde mañana. Si no se abre la app en 14 días, los avisos diarios y semanales siguen llegando, pero las repeticiones se agotan hasta que se vuelva a abrir.
- Desmarcar una toma (o pulsar "Deshacer") la devuelve a "Pendiente" o "Sin marcar" y recupera sus avisos.
- Las tomas se cuentan por día: un aviso respondido pasada la medianoche se anota en el día de la toma (la última vez que llegó su hora).

**Asistente de la primera vez.**
- Se abre solo en una instalación nueva, con el menú principal debajo: "Inicio", "Saltar estos pasos" o el botón atrás desde la bienvenida llevan al menú, y salir de cualquier forma cuenta como completado. "Atrás" dentro del asistente vuelve al paso anterior.
- **Avisos**: un solo botón, "Activar los avisos", que pide el permiso de Android 13+ y, si se concede, activa también el sonido y la vibración (en Ajustes siguen desactivados por defecto). Si falta el permiso de alarmas exactas, se ofrece igual que en Ajustes. Las explicaciones de permisos son las mismas en los dos sitios (`explicaciones_avisos.dart`).
- Quien ya usaba una versión anterior (tiene ajustes guardados) no lo ve. Al abrir el asistente se guarda que está empezado, así que si la app se cierra a medias vuelve a salir aunque ya se haya cambiado el tamaño de la letra.

**Foto de la caja.**
- `image_picker` abre la cámara del teléfono o el selector de fotos del sistema, así que la app no pide permisos de cámara ni de almacenamiento. La foto se reduce a 1200 px como mucho (unos 200 KB) y se copia a la carpeta privada de la app.
- Se ve en el formulario, en la lista, en "Tomas de hoy" y **en el propio aviso** (como imagen grande de la notificación), siempre con su texto alternativo para TalkBack ("Foto de la caja de Omeprazol").
- Una foto que ya no usa ningún medicamento (uno eliminado, o la que se cambió por otra) se borra la siguiente vez que se abre la app. Así "Deshacer" recupera también la foto mientras la app sigue abierta.
- **Si Android cierra la app con la cámara abierta** (pasa en móviles con poca memoria), no se pierde lo escrito: antes de abrir la cámara o la galería, el formulario guarda un borrador, que se borra al volver. Si la app se cerró, al abrirla de nuevo vuelve al formulario como estaba, con la foto que `image_picker` guarda para este caso, y lo explica. En el emulador se comprobó matando el proceso con la cámara abierta.

**Voz.** En lugar de paquetes externos, un canal propio en `MainActivity.kt` (unas 150 líneas) y, en iOS, en `CanalVoz.swift`. Lectura y dictado usan el idioma de los textos de la app, que Flutter pasa en cada llamada:
- **Leer en voz alta** usa el motor de voz del teléfono (`TextToSpeech`) en el idioma de la app, con la variante de España si está instalada (`es-ES`, `ca-ES`…; si no, cualquiera de ese idioma), un poco más despacio de lo normal. Está desactivado por defecto; al activarlo en Ajustes se oye una frase de prueba y, si el teléfono no tiene esa voz, la app lo explica y el interruptor sigue apagado. Con la lectura activada, al abrir la app desde un aviso se lee la medicina, con la dosis de esa toma ("Medicina de las 09:00 de la mañana: Omeprazol, 1 pastilla…"), o la cita, se lee la confirmación de "Ya la he tomado" o "Recordar en 10 min", y "Tomas de hoy" ofrece **Escuchar las tomas de hoy** (cuántas hay y cuáles faltan). Las frases están escritas para oírse (`textos_para_leer.dart`).
- **Dictar** abre la pantalla de dictado del propio teléfono (`RecognizerIntent`, el "Habla ahora" de Google) con la indicación "Di el nombre del medicamento". Esa pantalla es la que escucha: la app **no pide el permiso del micrófono** y solo recibe el texto, que se escribe en el campo con la primera letra en mayúscula y se puede corregir. Si el teléfono no tiene dictado, el botón no aparece.
- Se descartaron `flutter_tts` (avisa de que dejará de compilar en futuras versiones de Flutter) y `speech_to_text` (exige el permiso del micrófono).
- Un aviso no se puede leer en voz alta en el momento en que llega con la app cerrada: lo muestra Android sin que se ejecute la app. Se lee al abrirlo.
- **En iOS**, `CanalVoz.swift` responde al mismo canal con las voces del iPhone (`AVSpeechSynthesizer`): la de España si la hay, un poco más despacio, y suena aunque el iPhone esté en silencio, porque lo ha pedido la persona. No hay botón de dictar: el teclado del iPhone ya trae su propio micrófono, y así la app no pide los permisos del micrófono ni del reconocimiento de voz. Si falta la voz, la explicación dice dónde se descarga en el iPhone.

**Widget de la pantalla de inicio.**
- "Próxima toma": la medicina y cuándo toca ("Hoy a las 20:00", "Mañana a las 08:00"). Si hoy hay una sin marcar cuya hora ya ha llegado, muestra esa ("Sin marcar. Era a las 08:00.") con el botón **Ya la he tomado**. Tocarlo fuera del botón abre "Tomas de hoy".
- Lo dibuja Android (`WidgetToma.kt`, con `RemoteViews`), no Flutter. La app le manda, cada vez que se ponen al día los avisos, las tomas de los próximos 7 días con los textos ya preparados (`DatosWidget`, en JSON), y el widget elige la que toca según la hora. Así sigue bien aunque la app no esté abierta: se redibuja solo a la hora de la siguiente toma y a medianoche (una alarma sin hora exacta, que no necesita permisos). Si la app lleva más de 7 días sin abrirse, pide abrirla.
- El botón abre la app por el mismo camino que el botón del aviso (`ProcesadorRespuestas`), que anota la toma, muestra "Tomas de hoy" y lo explica. A diferencia del aviso, lleva la fecha de la toma.
- El botón lleva además un código secreto: 32 bytes aleatorios (`SecureRandom`) que se crean la primera vez y se guardan en las preferencias del widget. La actividad principal tiene que estar abierta a otras apps, porque es la del icono, así que cualquiera podría abrirla con la acción del botón y marcar una toma que no se ha tomado. Sin el código (o con otro), la app se abre como desde su icono y no anota nada. Solo lo conocen la app y el lanzador, que guarda el botón sin poder cambiarlo (`FLAG_IMMUTABLE`). Al actualizar la app, Android redibuja el widget, así que el botón tiene el código desde el principio.
- **Poner la próxima toma en la pantalla de inicio** (Ajustes) pide al teléfono que lo añada (`requestPinAppWidget`, Android 8+): el lanzador pregunta y lo pone. Si no sabe, la app explica cómo ponerlo a mano.
- Ocupa 4 × 3 casillas al ponerlo y se puede agrandar o encoger. Con 4 × 2, el lanzador del emulador lo proponía de 3 × 3, más estrecho. La app nunca lo pone sola, porque deja a la vista el nombre de la medicina en la pantalla de inicio.
- Mismos colores que el tema predeterminado (negro sobre azul claro, 14:1; botón blanco con borde negro) y tamaños en sp, que crecen con la letra del teléfono. Los textos salen de `lib/l10n`, salvo los tres que se ven antes de abrir la app por primera vez, en `res/values/strings.xml`.

**Icono.** Un frasco de medicina azul marino (#0A2540) sobre el azul claro del tema predeterminado (#B6D8FF), con un contraste de 11:1. Se genera con `tool/icono/icono_test.dart` (el glifo `medication` de Material Icons) y `flutter_launcher_icons`: icono normal, adaptable y monocromo (iconos temáticos de Android 13) e iconos de iOS. Las notificaciones usan su propia silueta blanca (`ic_notificacion`), porque Android solo usa la forma del icono pequeño y uno a todo color se veía como un cuadrado blanco.

**Familia y cuidadores.**
- **PDF para el médico o la familia** ("Mi medicación y mis citas"): medicamentos activos con su foto, dosis (la de cada toma, si cambia), horas (o "Cuando haga falta" y sus límites), días, duración, receta, pastillas que quedan (si se lleva la cuenta) e instrucciones; cuántas tomas de los últimos 7 días se marcaron ("Marcadas 18 de 21 tomas (86 %)") y una tabla con cada día (cuántas se anotaron y cuáles quedaron sin marcar; las anotadas de un medicamento borrado o de una hora que se cambió cuentan, como en el historial) y, debajo, lo que se tomó "cuando hacía falta" cada día ("Hoy 25/10: Paracetamol a las 08:10 y 14:30."); las próximas citas y los teléfonos de emergencia. Se genera en el teléfono con el paquete `pdf` y Montserrat (la letra de la app), en letra grande. Cada sección empieza en una página nueva si queda poco sitio, para que su título no se quede solo, y la tabla se reparte entre páginas si hace falta. Ver [docs/informe_ejemplo.pdf](docs/informe_ejemplo.pdf).
- **Recordarme enviarlo cada semana**: un aviso los domingos a las 18:00, "¿Envías tu resumen a la familia?", que abre "Compartir". Necesita los avisos activados; si no lo están, lo dice al activarlo.
- **Enviar** abre el menú "Compartir" del teléfono (WhatsApp, correo, Drive…); **Imprimir** abre la pantalla de impresión de Android (paquete `printing`), que también permite guardarlo como PDF.
- **Copia de seguridad**: un único fichero JSON con todos los datos, fotos incluidas (una copia con dos medicamentos y una foto ocupa unos 150 KB). Se puede guardar donde se elija (Descargas, Google Drive) o enviar. Al recuperarla, la app explica qué copia es ("Copia del sábado, 24 de octubre de 2026, a las 20:15: 2 medicamentos, 1 cita y 4 tomas anotadas"), qué teléfonos pondrá en Emergencias ("Número de emergencia: 112." y "Familiar: Mi hija Ana, 600123456.", o que no trae) y qué se va a borrar, y pide confirmación. Los teléfonos se dicen siempre porque la copia puede llegar de otro móvil y acaban en los botones de Emergencias. Los datos se sustituyen en una sola transacción de la base de datos: si algo falla a mitad (sin espacio, por ejemplo), el teléfono se queda como estaba, no a medias. Se conserva si los avisos están activados en el teléfono, porque depende de sus permisos y no de la copia; después se reprograman todos los avisos.
- La copia se comprueba entera antes de tocar nada: que sea de esta app, que no sea de una versión más nueva, que los medicamentos sean posibles (por ejemplo, que las tomas quepan en el día, que no haya dos a la misma hora, que los días de toma tengan sentido, que la cuenta de las pastillas tenga números posibles, enteros o con media, que haya una dosis y unas pastillas por toma y que los límites estén dentro de lo que admite el formulario) y que los nombres de las fotos no puedan salir de su carpeta (un fichero manipulado con `../` no escribe fuera).
- Como la copia puede venir de otro móvil (por WhatsApp, por ejemplo), se comprueba además como lo haría el formulario: los textos no pasan de lo que admite (nombre, dosis, instrucciones, motivo, lugar y notas de las citas, nombre del familiar), las citas tienen motivo, no hay dos medicamentos o dos citas con el mismo identificador ni dos registros de la misma toma, las fotos son imágenes de verdad (JPEG, PNG, WebP o HEIC, mirando cómo empieza el fichero) de 5 MB como mucho, y los dos teléfonos pasan la misma validación que en Ajustes. Un número como `**21*666#` (un código del marcador) nunca lo ha guardado la app, así que la copia se rechaza; y por si acaso, el marcador tampoco abre un número que no pase esa validación. Un fichero de más de 50 MB tampoco es una copia: Android e iOS leen como mucho eso (y un poco más, para saber que se pasa) y la app explica que es demasiado grande, sin cargarlo entero en memoria.
- **Copia automática de Android**: además de la copia propia, Android guarda los datos de la app en la cuenta de Google (si la persona la tiene activada) y los pasa al móvil nuevo al cambiar de teléfono. Unas reglas ([reglas_copia.xml](android/app/src/main/res/xml/reglas_copia.xml) para Android 12 y posteriores, y `reglas_copia_android11.xml` para los anteriores) dejan copiar solo lo que la app no puede volver a crear: la base de datos, los ajustes (`FlutterSharedPreferences`) y las fotos de las cajas. Se quedan fuera las preferencias del widget, cuyo código secreto es de cada instalación, y la lista de avisos programados de `flutter_local_notifications`; la app las vuelve a crear al abrirse. No se exige que la copia en la nube vaya cifrada con el bloqueo de pantalla (`disableIfNoEncryptionCapabilities`). Google la cifra con el PIN del teléfono si lo tiene, y exigirlo dejaría sin copia, sin avisar, a quien no usa bloqueo de pantalla, algo frecuente entre las personas mayores.
- **Medicamentos preparados en otro móvil**: un familiar apunta las medicinas (y las citas) en su teléfono, con la misma app, y envía una copia con "Enviar una copia". En el de la persona mayor, **Añadir medicamentos de otro móvil** lee esa copia y, antes de hacer nada, dice qué se añadirá y qué se actualizará. Los medicamentos que no se tienen se añaden; los que ya se tienen (mismo nombre, sin distinguir mayúsculas ni tildes) se ponen como en la copia, con el mismo `id`, así que conservan sus tomas anotadas, y si la copia no trae foto o cuenta de pastillas se quedan las de antes (la dosis de cada toma, los límites y la receta se ponen como en la copia). Las citas se añaden si no se tienen ya y no han pasado. Las tomas anotadas y los ajustes de la copia no se usan, y las fotos se guardan con un nombre nuevo para no pisar ninguna.
- Compartir, guardar y abrir pasan por pantallas del propio sistema (`ACTION_SEND` con un `FileProvider`, `ACTION_CREATE_DOCUMENT` y `ACTION_OPEN_DOCUMENT`, en `CanalArchivos.kt`), así que la app no pide permisos de almacenamiento. En iOS, `CanalArchivos.swift` hace lo mismo con la hoja de compartir y el selector de documentos del sistema.
- Lo que se comparte se deja antes en una carpeta de la caché (`compartir`), solo el último fichero, y esa carpeta se vacía también al abrir la app: un PDF con la medicación no se queda en el teléfono hasta el siguiente envío. Del nombre del fichero solo se usa la última parte, sin carpetas, así que nunca se escribe fuera de ella (hoy los nombres los pone la app, pero así no depende de eso).
- **Segundo contacto de emergencia**: nombre y teléfono de un familiar en Ajustes (se valida igual que el número de emergencia; con los dos campos vacíos se borra). En Emergencias aparece un segundo botón grande, debajo del de emergencias, que también abre el marcador sin llamar.

**Textos traducibles.** Los textos se generan con `gen-l10n` (el sistema de Flutter, sin paquetes externos) a partir de `lib/l10n/app_es.arb`:
- en los widgets se usa `TextosApp.of(context)`; el código que no tiene un `BuildContext` (avisos, frases para leer, validaciones, PDF, copia de seguridad y fechas) usa `textosApp`, que la app pone en el mismo idioma que las pantallas, y desde el arranque, antes de dibujar nada, porque los avisos se programan enseguida;
- los números van como texto en los huecos (`{hora}`, `{anio}`): así no se formatean como cantidades ("2.026");
- el castellano va el primero en la lista de idiomas (`preferred-supported-locales` en [l10n.yaml](l10n.yaml)) porque es el que se usa si el teléfono está en un idioma sin traducción; sin eso, gen-l10n los ordena alfabéticamente y un `app_ca.arb` habría pasado a ser el idioma por defecto. Se vio al probar con un catalán de ejemplo;
- las frases que nombran un botón lo toman del propio texto del botón (por ejemplo, "Si ya la has tomado, pulsa «Ya la he tomado»"), para que una traducción no pueda dejarlos desparejados.

**Llamada de emergencia.** `url_launcher` con `tel:` abre el marcador con el número ya escrito; la persona confirma la llamada en el propio teléfono. Sin número guardado, la pantalla lo explica y ofrece un botón directo a Ajustes.

**Tipografía e iconos.** Montserrat va incluida en la app (`assets/fonts`, licencia SIL OFL 1.1) para que funcione sin conexión. En lugar de pictogramas de ARASAAC (licencia CC BY-NC-SA, solo uso no comercial) se usan **iconos Material** grandes de significado equivalente, siempre con su etiqueta de texto debajo. El pictograma de emergencias combina un teléfono con una cruz roja sobre un círculo blanco, visible en los tres temas.

**Tamaño de texto.** Todos los estilos están definidos para la base de 20 pt y se escalan juntos con un `TextScaler` global: tamaño elegido ÷ 20 × tamaño de letra del sistema (con un límite de ×2,5 para que todo siga cabiendo).

**Diseño adaptable sin cortar texto.** Algunos componentes miden el ancho real de sus palabras con la fuente y el escalado actuales y cambian de disposición antes que partir una palabra:
- el menú pasa de 2×2 a una columna (la cuadrícula cabe con texto base desde 393 dp de ancho);
- el título de la barra superior pasa a una línea propia bajo los botones;
- en los selectores + / −, el valor se coloca encima de los botones.

Con texto ≥ 30 o pantallas bajas (**modo compacto**), la barra superior y el botón principal fijo dejarían casi sin espacio al contenido, así que se desplazan con él. En las listas, el botón de crear se coloca antes de la lista.

El botón principal fijo va en la zona inferior propia del `Scaffold`, de modo que los mensajes emergentes (por ejemplo, el de "Deshacer") aparecen encima de él y nunca lo tapan.

**Prevención de errores.** Los selectores no permiten valores imposibles (fechas pasadas, más tomas de las que caben en el día…), y no se puede guardar un medicamento con dos tomas a la misma hora, con "algunos días de la semana" sin ningún día elegido, llevando la cuenta de las pastillas sin decir cuántas hay (o con una cantidad que no sea entera o con media) o con una dosis de más de 40 letras, también en la de cada toma. Los errores se muestran junto al campo, en lenguaje claro, con icono y borde rojos y texto de alto contraste; la pantalla se desplaza hasta el error y TalkBack lo anuncia. No hay gestos complejos, carruseles, menús ocultos ni scroll horizontal; tocar fuera de un campo cierra el teclado.

## Seguridad y privacidad

La app maneja datos de salud, así que todo se queda en el teléfono: no tiene permiso de Internet, ni cuentas, ni servidor. Los datos están en el almacenamiento privado de la app, al que no llegan las demás (no se cifran aparte; en los móviles actuales, Android cifra todo el almacenamiento). Solo salen cuando la persona envía o guarda un PDF o una copia, y con la copia automática de Android, si la tiene activada. Lo que se reforzó tras una revisión de seguridad en octubre de 2026 (los detalles, en [Decisiones técnicas](#decisiones-técnicas) y [Comprobación automática](#comprobación-automática)):

- **Copias que llegan de otro móvil**: se comprueban como lo haría el formulario (textos de la longitud que admite, teléfonos que se pueden marcar, fotos que de verdad son imágenes de 5 MB como mucho, identificadores sin repetir y 50 MB en total) y se recuperan en una sola transacción de SQLite, así que si algo falla no quedan a medias. Antes de recuperarla, la app dice qué teléfonos pondrá en Emergencias, y el marcador solo abre números que admite Ajustes.
- **Botón del widget**: lleva un código secreto, para que otra app no pueda marcar tomas haciéndose pasar por él.
- **Avisos**: una carga mal formada (por ejemplo, una fecha a medias) se ignora.
- **Ficheros compartidos**: del nombre solo se usa la última parte, sin carpetas, y la carpeta donde se dejan se vacía al abrir la app.
- **Copia automática de Android**: solo la base de datos, los ajustes y las fotos de las cajas; ni el código del widget ni la lista de avisos programados.
- **Pantalla de bloqueo**: con **Avisos discretos**, los avisos no dicen el nombre de la medicina ni el motivo de la cita, ni llevan la foto.
- **Compilación**: las versiones exactas de `pubspec.lock`, las acciones de GitHub fijadas por su commit y con un token de solo lectura, la suma de la distribución de Gradle, R8 en release y Dependabot.
- **Claves de firma**: `android/key.properties` y los almacenes de claves no se suben nunca; el `.gitignore` de la raíz los ignora (también `.env`, `.p12` y `.pem`) estén donde estén. Sin `key.properties`, la versión release se firma con la clave de depuración a propósito, para comprobar que compila; para publicar hace falta la clave de subida (ver [Versión para Google Play](#versión-para-google-play)).

## Accesibilidad y contraste

Ratios WCAG 2.x calculados con la fórmula de luminancia relativa (verificados en `test/unit/tema_y_formato_test.dart`):

| Tema | Texto / fondo | Texto de botón | Selección | Error (borde) |
|---|---|---|---|---|
| Predeterminado (#B6D8FF / negro, botones blancos) | **14,3 : 1** | 21 : 1 | 8,1 : 1 | 7,3 : 1 |
| Oscuro (#121212 / blanco, botones #262626) | **18,7 : 1** | 15,1 : 1 | 13,3 : 1 | 6,6 : 1 |
| Alternativo (#FFF3C4 / negro, botones blancos) | **18,9 : 1** | 21 : 1 | 9,1 : 1 | 7,3 : 1 |

Todos los textos superan AAA (≥ 7:1). El botón rojo de eliminar (#B00020 con texto blanco) tiene 7,3:1 y el verde de "activado" (#1B5E20), 7,9:1. Los interruptores nunca dependen solo del color: el mando lleva ✓ o ✕ y al lado se lee "Activado" o "Desactivado". Los botones no disponibles pierden el relleno pero conservan el texto con contraste completo, para que se pueda leer por qué no están disponibles.

Además:
- áreas táctiles de 64 dp o más en las acciones principales (mínimo de 48 dp en todas), con separación generosa;
- etiquetas semánticas en todos los controles para TalkBack (por ejemplo "Eliminar Paracetamol", "Ya he tomado Paracetamol de las 08:00", "He comprado más Omeprazol" o "Sumar una hora"; el botón "Deshacer" explica qué deshace: "Quita la marca de esta toma", "Recupera lo que acabas de eliminar"…), estados de interruptores y opciones de tema, encabezados y anuncios de errores y cambios en vivo;
- los tests recorren las 17 pantallas (y los formularios de modificar y todos los pasos del asistente) en los 3 temas con las guías de Flutter (`androidTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`). También comprueban que no haya desbordes con texto 10 y 35, en pantallas de 320 dp, en horizontal y con la letra del sistema al 130 %, y en catalán, gallego y euskera (con palabras más largas) los casos más justos;
- cada campo de texto y cada encabezado tiene **su propio nodo para TalkBack**. Al revisar el árbol de accesibilidad en el emulador apareció un fallo que venía de antes: Flutter funde los `Semantics` que no son `container` con lo que tienen alrededor, y el campo del número de emergencia de Ajustes acababa en un solo nodo con los textos de encima, sin poder enfocarse bien. Ahora los campos, encabezados y regiones vivas son `container`, y un test lo comprueba en todas las pantallas (falla si se quita la corrección);
- cada texto suelto (explicaciones, resúmenes, mensajes de los diálogos) es también un nodo propio (`Parrafo`). Lo destapó la fase 4 en el emulador: Flutter juntaba en un solo nodo todos los textos sueltos de una pantalla (en Emergencias, el de arriba y el de abajo), y TalkBack los habría leído de golpe y antes que los botones que hay entre ellos. El test comprueba que ningún texto contenga controles, y las tarjetas que se leen de una vez (`MergeSemantics`) no repiten la foto;
- el contenido de las pantallas se desplaza con un `SingleChildScrollView`, no con un `ListView` de un solo hijo: así, cuando una tarjeta encogía con la lista desplazada (al volver de modificar unas instrucciones largas o de renovar una receta), Flutter fallaba al rehacer el árbol de TalkBack ("Null check operator" en `_buildSemanticsSubtree`). Lo destapó un test de la fase 12 y hay un test de regresión;
- el **widget** de la pantalla de inicio lo dibuja Android, así que los tests de Flutter no lo recorren: tiene los colores del tema predeterminado (14,3:1 el texto y 21:1 el botón), letra en sp que crece con la del teléfono, un botón de 56 dp de alto como mínimo y, para TalkBack, la misma descripción que en "Tomas de hoy" ("Ya he tomado Paracetamol de las 08:00"). Se revisa con la [lista de pruebas en un móvil real](docs/pruebas_en_dispositivo.md) (sección 12).

## Tests

`flutter test` ejecuta **435 tests**:

- **Unitarios**: cálculo de horas de toma (repartidas y a horas concretas), días de toma (días de la semana, cada varios días, en el cambio de hora y guardados como texto), límites del tamaño de texto (10–35, pasos de 5), validaciones de medicamento (dosis, instrucciones, fecha de fin, horas repetidas, ningún día elegido), cita y teléfono, recordatorios de citas (también la tarde antes, y a medianoche), planificador de avisos (tratamientos con fecha de fin, ventana de 14 días, tope de avisos, repeticiones a los minutos elegidos o ninguna, los minutos del botón de aplazar, tomas marcadas antes de su hora, avisos semanales y de cada varios días, aplazados, repeticiones pasada la medianoche, avisos de tomas sin atender, la dosis de cada toma en su aviso y los avisos discretos, sin nombres, dosis, motivos, lugares ni fotos), tomas del día e historial (sin los días que no toca), medicamentos "cuando haga falta" (sin horas ni avisos, cuáles se pueden anotar, sus tomas del día y sus límites: el máximo de hoy, el tiempo desde la toma de ayer y lejos del cambio de hora), dosis según la hora (la de cada toma, cuándo se guarda y su longitud), existencias (tomas descontadas a su hora o al marcarlas antes, días para los que llegan, hasta el final del tratamiento, cuándo son pocas y cuándo avisar, medias pastillas y una cantidad distinta en cada toma), receta (cuándo cuenta, cuándo hay que renovarla, cuándo avisar, qué dicen la tarjeta y el aviso, y sus identificadores), resumen de la semana y su recordatorio, datos del widget de la pantalla de inicio (y la carga de una toma con su fecha; una carga mal formada, como una fecha a medias, se ignora), respuestas a los botones de los avisos, comprobación de los avisos (qué cuenta como problema según el permiso, la hora exacta, la batería y el fabricante), borrador del formulario (guardar, leer y descartar uno roto), resumen de próximos eventos, contraste de las paletas, formato de fechas, repositorios con SQLite en memoria (también el de tomas, la foto, los límites, la receta, la dosis de cada toma y las medias pastillas), migración de la base de datos, ajustes persistentes (también los minutos de la repetición y del aplazamiento, los que no son una opción y los avisos discretos) y la marca del asistente, almacén de fotos con ficheros reales (copia y limpieza), canal de voz (respuestas y ausencia de implementación nativa), frases para leer en voz alta y qué se lee al responder un aviso, copia de seguridad (ida y vuelta con la cuenta de las pastillas, las medias, la dosis de cada toma, los límites, la receta y los minutos de los avisos; copias de formatos anteriores, ficheros que no son copias o demasiado grandes, versión más nueva, nombres de foto peligrosos, medicamentos imposibles, y copias manipuladas: teléfonos que no se pueden marcar, textos más largos de lo que admite el formulario, citas sin motivo, fotos que no son imágenes o enormes, identificadores y tomas repetidos; fotos JPEG, PNG, WebP y HEIC), la restauración en una transacción de SQLite (lo sustituye todo, y si falla a mitad no cambia nada), el marcador (solo abre números válidos), contacto del familiar, PDF (vacío, completo, con foto, con lo tomado "cuando hacía falta", con tantos datos que ocupa varias páginas y con las tomas anotadas de un medicamento borrado, que cuentan en la tabla de cada día como en el historial), el servicio que comparte, guarda, envía, recupera (también cuando falla al guardar) y añade lo de otro móvil (qué se añade, qué se actualiza, fotos con otro nombre, citas pasadas fuera), y los ficheros de textos (el castellano va el primero, no sobra ningún texto, cada traducción tiene todos los textos con los mismos huecos y cada idioma está declarado en Android y en iOS).
- **Sincronización de avisos** (con dobles): se programan al guardar, se reprograman al modificar y se cancelan al eliminar; "Deshacer" los recupera, marcar y desmarcar tomas cancela y recupera sus repeticiones, se respetan los interruptores y se gestionan los permisos denegados y las alarmas exactas.
- **Widgets**: menú (resumen, navegación con casa, atrás y botón atrás de Android, y castellano con el teléfono en un idioma sin traducción), alta y modificación de medicamentos con dosis, duración, horas concretas, días de toma, "cuando haga falta" y sus límites, dosis distinta según la hora (también en la cuenta, la lista y "Tomas de hoy") y la fecha de la receta (con el resumen de los avisos y la marca ✓ de los días elegidos), borrado con confirmación y deshacer, "Tomas de hoy" (marcar, desmarcar, deshacer, estados; anotar y quitar las de "cuando haga falta") e historial, existencias (la cuenta en el formulario y en la lista, de media en media, "He comprado más" también con media, el aviso del menú y el del teléfono, y la cuenta al modificar o cambiar la pauta), receta (el aviso del menú y de la lista, "Ya la he renovado" con la fecha nueva o quitándola, y su aviso), el aviso antes de anotar un "cuando haga falta" de más, respuestas a los botones de una notificación (también con la app cerrada), abrir la app sin tocar el aviso (desde el grupo de avisos o el icono, y al volver del segundo plano), agenda (crear, modificar, atajos de fecha, y los avisos que dice al guardar), emergencias, ajustes ("Probar aviso", permisos, lectura en voz alta, "Repetir los avisos", que cambia los avisos y el botón de aplazar, y "Avisos discretos", que quita de los avisos el nombre, el motivo de la cita y la foto, y vuelve a ponerlos), comprobación de los avisos (cada problema con su botón, el aviso del menú y la nueva comprobación al volver a la app), tamaño de texto con muestra en vivo, tema con vista previa, asistente (recorrido completo, saltar, atrás, permiso denegado, número incorrecto), foto de la caja (cámara, galería, cancelar, fallo, quitar y recuperar el formulario si Android cerró la app con la cámara abierta), voz (escuchar las tomas, leer al tocar un aviso, dictar en medicamentos y citas, y qué se explica si falta la voz, en Android y en un iPhone), familia (guardar, validar y borrar el contacto; llamarle desde Emergencias, también sin número de emergencia), compartir (enviar e imprimir el PDF, el recordatorio semanal, guardar y enviar la copia, recuperar con confirmación (que dice los teléfonos de la copia) o cancelando, añadir los medicamentos de otro móvil, fichero que no es una copia), el resumen de la semana en el historial, el widget de la pantalla de inicio (su botón con la app cerrada o abierta, tocarlo, que se pone al día al marcar una toma y ponerlo desde Ajustes), idiomas (la app en catalán, gallego y euskera, y los avisos y el widget cuando cambia el idioma con la app abierta) y accesibilidad de todas las pantallas, también en los tres idiomas con la letra al máximo. Un test de regresión comprueba que el mensaje de "Deshacer" no tapa el botón principal; otro, que una tarjeta que encoge con la lista desplazada no rompe el árbol de TalkBack, y otros, que TalkBack explica qué deshace en cada caso.

Además, en [integration_test](integration_test) hay 12 tests de integración y la prueba de entrega real de avisos, descritos en [Tests en un móvil o emulador](#tests-en-un-móvil-o-emulador).

### Verificado en un emulador Android 14

Con los tests de integración y probando a mano, en un emulador Pixel 6 con Android 14 en inglés (la app sale en castellano):
- crear, modificar, eliminar y deshacer programan, reprograman y cancelan los avisos en el propio sistema; desactivar las notificaciones los cancela todos;
- los avisos **llegan a su hora**, tanto los diarios como los únicos, con alarmas exactas y sin ellas (modo inexacto, el de una instalación nueva de Android 14);
- "Probar aviso" muestra la notificación cuando hay permiso y, sin él, ofrece los ajustes del teléfono;
- **los botones de la notificación**: "Ya la he tomado" abre la app en "Tomas de hoy" con la toma anotada ("Tomada a las 11:25"), la guarda en SQLite, retira la notificación y cancela en Android la repetición de esa toma de hoy, manteniendo el aviso diario. "Recordar en 10 min" deja la toma "Aplazada" y programa el aviso 10 minutos después, que llega con los mismos botones;
- **varios avisos agrupados**: con dos avisos de la app en la bandeja, tocar el grupo abre "Tomas de hoy" y "Atrás" vuelve a la pantalla que había; al volver de hacer una foto con la cámara, el formulario sigue donde estaba;
- **el asistente** en una instalación nueva, con el diálogo real de permiso de notificaciones de Android 14 y la pantalla del sistema de "Alarmas y recordatorios"; al terminar, los avisos quedan activados con sonido y vibración;
- **la foto de la caja** con la cámara del emulador: se guarda en la carpeta de la app (reducida a 900 × 1200), aparece en la lista y en "Tomas de hoy", y **el aviso de la toma la muestra** junto a sus botones. La galería abre el selector de fotos del sistema. Al eliminar el medicamento y volver a abrir la app, la foto se borra;
- **la voz**: el emulador tiene voz en español (Google) y al abrir la app desde un aviso, o con "Escuchar las tomas de hoy", se pide la síntesis en español. "Dictar el nombre" abre el dictado de Google con la indicación; sin micrófono en el emulador termina en "no se ha entendido" y la app sigue igual;
- **el icono** adaptable en los ajustes del sistema y la silueta del frasco en la barra de notificaciones;
- **la copia de seguridad**: una copia dejada en Descargas se elige con el selector de documentos del sistema, la app la describe y pide confirmación, y al recuperarla aparecen los medicamentos, la cita, las tomas, la foto de la caja y los ajustes (el tamaño de letra de la copia), con los avisos reprogramados. "Guardar una copia" la deja en Descargas con el nombre propuesto;
- **el PDF**: "Imprimir" abre la impresión de Android con la vista previa del documento (dos páginas, con la foto, la tabla de tomas y la cita), y "Enviar mi medicación y citas" abre el menú "Compartir" con el fichero "Medicación y citas 25-10-2026.pdf" (Drive, Mensajes, Imprimir…). Un fichero dejado en la carpeta de compartir desaparece al volver a abrir la app;
- **la versión release** (reducida con R8 y firmada con una clave de prueba), instalada desde cero, en un recorrido completo: el asistente con los permisos reales; un medicamento con dosis, instrucciones y foto, cuyo aviso llega a su hora con la foto y los dos botones; "Ya la he tomado", "Recordar en 10 min" y tocar el aviso; marcar, desmarcar, eliminar y "Deshacer" desde la app; el historial; una cita con sus dos avisos; Emergencias con el 112 y con el familiar; la voz en castellano de España; el tema oscuro; el PDF; guardar y recuperar una copia, y el reinicio. La app pide solo cuatro permisos (notificaciones, vibración, arranque y alarmas exactas) y no tiene acceso a Internet;
- **la comprobación de los avisos**: el permiso de hora exacta concedido desde la tarjeta; la app restringida en segundo plano, señalada y arreglada eligiendo "Unrestricted" en la pantalla que abre el botón; el permiso de avisos quitado desde fuera, avisado en el menú y recuperado con su botón;
- **los avisos discretos**: con la opción activada, el aviso real de una toma (con dosis, instrucciones y foto) llega en la pantalla de bloqueo como "Hora de tu medicina. La de las 00:06. Toca aquí para ver cuál es.", sin foto, y en el panel de avisos igual, con los dos botones. En lo que guarda Android de los avisos programados no aparecen el nombre, la foto ni las instrucciones. "Ya la he tomado" abre "Tomas de hoy" con "Anotado: has tomado Omeprazol (00:06).";
- **la copia automática de Android** (con `bmgr` y el transporte local): al reinstalar, vuelven el medicamento con la foto de la caja y los ajustes, pero no el permiso de avisos, y el menú lo pide. Por las reglas, no vuelven las preferencias del widget (se crea un código nuevo) ni la lista de avisos programados, que la app rehace al abrirse;
- **el formulario de medicamento** tras matar el proceso con la cámara abierta: Android vuelve a abrir la app y aparece el formulario con lo escrito, las tomas elegidas y la foto;
- el canal silencioso se crea con importancia alta, sin sonido y sin vibración;
- **el widget de la pantalla de inicio**: "Poner la próxima toma en la pantalla de inicio" abre la ventana del lanzador para añadirlo; con una toma de las 08:00 sin marcar muestra "Sin marcar. Era a las 08:00." y "Ya la he tomado", que abre "Tomas de hoy" con la toma anotada, también con la app cerrada a la fuerza; después muestra "Mañana a las 08:00". Con una toma para dentro de unos minutos y la app sin abrir, a su hora pasó solo a "Sin marcar. Era a las 20:50." con el botón. Otra app no puede hacerse pasar por el botón: con `adb shell am start` y la acción `WIDGET_TOMADA` (sin código o con uno falso, con la app cerrada y abierta) la app abre el menú sin anotar nada, mientras que el botón de verdad sí la anota;
- **los idiomas**: con el catalán elegido solo para la app (como en Android 13+, sin cambiar el del teléfono), todo sale en catalán, con las fechas bien escritas ("Avui, dimarts, 27 d'octubre de 2026", "Divendres, 27 de novembre de 2026") y "octubre" en el selector de mes, y el widget pasa a "Propera presa". Al cambiar a euskera con el formulario de cita abierto, la app cambia sin perder lo escrito ("2026ko azaroaren 27a, ostirala") y el widget pasa a "Hurrengo hartualdia · Gaur 08:00etan" sin abrirlo;
- **añadir los medicamentos de otro móvil**, con el selector de documentos real: con una copia guardada en Descargas y un medicamento borrado después, la app dice "Se añadirán: Aspirina." y "Ya tenías Omeprazol…", y al aceptar vuelve la Aspirina sin tocar lo demás. Con "Recordarme enviarlo cada semana", Android tiene la alarma del domingo a las 18:00;
- **las existencias**: un medicamento con 5 pastillas sale en la lista con "Quedan 5 pastillas, para unos 5 días" y "Quedan pocas", y en el menú con "Te quedan pocas pastillas de Omeprazol"; en Android queda una alarma para el día siguiente a las 10:00. Con "He comprado más" (28), la lista dice "Quedan 33 pastillas, para unos 33 días", el aviso del menú desaparece y la alarma pasa al día en que vuelvan a no llegar para una semana;
- **"cuando haga falta"**: un calmante creado así sale en la lista como "Cuando haga falta, sin avisos", no añade ninguna alarma, y en "Tomas de hoy" "Lo he tomado ahora" lo anota con la hora ("Hoy lo has tomado a las 03:16") y ofrece "Quitar la última". La base de datos de una versión anterior, recuperada por la copia automática de Android al reinstalar, pasa a la 6 sin perder nada;
- **los avisos semanales**: una medicina de los lunes y jueves a dos horas concretas deja en Android cuatro alarmas, una por día y hora; el aviso llega a su hora y se vuelve a programar para la semana siguiente. El formulario dice "Te avisaremos a las 02:30 y 21:00 los lunes y jueves." y la lista, "Los lunes y jueves";
- **tras reiniciar sin abrir la app**, Android vuelve a tener las mismas alarmas a sus horas (lo restaura el receptor de arranque, unos 45 s después del arranque);
- **la fase 12**, con los 12 tests de integración y a mano: con "Recordar en 5 min" en "Repetir los avisos", el aviso real de la toma lleva ese botón y, al pulsarlo, "Tomas de hoy" dice "Aplazada: te lo recordaremos a las 05:11", cinco minutos después. Un medicamento a dos horas concretas con "1 pastilla" y "media pastilla" avisa con "Toma Enalapril: 1 pastilla (05:05)."; en "Tomas de hoy", la toma de la noche dice "Dosis: media pastilla". Con la receta a tres días y 14,5 pastillas, la lista dice "La receta se acaba dentro de 3 días…" con "Ya la he renovado", y "Quedan 14 pastillas y media, para unos 9 días", y el menú, "Hay que renovar la receta de Enalapril". Un Paracetamol "cuando haga falta" con 3 al día y 6 horas, tras anotarlo, dice "La próxima, a partir de las 11:09", y al pulsar otra vez "Lo he tomado ahora" sale "Es más de lo que se puede" con la explicación;
- **el recorrido completo tras la revisión de seguridad** (28 de octubre de 2026): la comprobación local entera (también el App Bundle), los 12 tests de integración, la entrega real de avisos y la versión release instalada desde cero. A mano:
  - el asistente con los permisos reales;
  - un medicamento con dosis, instrucciones y foto de la cámara, cuyo aviso llegó a la 01:00 en punto con la foto y los dos botones. "Recordar en 10 min" lo aplazó a las 01:11, y "Ya la he tomado" en ese recordatorio lo anotó;
  - desmarcar y deshacer, y eliminar y deshacer (dentro de los 8 segundos que dura el mensaje);
  - la cita con sus tres avisos, el marcador con el 112 y el familiar;
  - el widget puesto desde Ajustes, que no anotó nada con un intent falsificado sin su código;
  - el tema oscuro y la vista previa del PDF;
  - la copia guardada en Descargas, una copia con el número de emergencia cambiado por `**21*666#` rechazada, y la buena recuperada: el diálogo dice los teléfonos, y vuelven los datos, la foto y el tema de la copia;
  - al reiniciar sin abrir la app, todas las alarmas otra vez al cabo de un minuto.

  Destapó un fallo del PDF, ya arreglado: la tabla de cada día no contaba las tomas anotadas de un medicamento borrado, aunque el resumen de encima sí.
- **la grabación del [recorrido en vídeo](#recorrido-en-vídeo)** (28 de octubre de 2026), esta vez con el teléfono en castellano y la hora de Madrid: el asistente con los diálogos del sistema en castellano, una copia con una semana de uso (hecha con las propias clases de la app) recuperada con el selector de ficheros, un aviso real de una toma sin marcar respondido con "Ya la he tomado", un medicamento con la foto elegida de la galería, el marcador con el 112, el widget, la vista previa del PDF, las medicinas de otro móvil y los cuatro idiomas elegidos solo para la app. Destapó que el día en que se registra un medicamento cuentan también sus tomas de antes (ver [Limitaciones conocidas](#limitaciones-conocidas)).

## Limitaciones conocidas

- El objetivo principal es Android. En iOS están los avisos (también con la app abierta) con los botones "Ya la he tomado" y "Recordar en 10 min" (como categorías de notificación, una por cada opción de minutos de "Repetir los avisos"), la lectura en voz alta, enviar, guardar y abrir ficheros (el PDF y las copias) y los textos de los permisos de cámara y fotos en los cuatro idiomas. No hay widget ni botón de dictar (en iOS esos botones no aparecen). **El código de iOS se ha escrito sin un Mac**: compila (el flujo manual de GitHub Actions para iOS lo comprueba), pero no se ha probado en un iPhone ni en el simulador. Lo que hay que mirar está en la sección 14 de las [pruebas en un móvil real](docs/pruebas_en_dispositivo.md).
- Las traducciones al **catalán, gallego y euskera** son borradores hechos con IA que nadie nativo ha revisado todavía (ver [docs/traducciones.md](docs/traducciones.md)). En euskera es donde más hay que mirar: lo que se rellena al momento (medicinas, lugares, fechas) no puede llevar terminaciones, así que algunas frases están dadas la vuelta, y las horas llevan una terminación fija (`08:00etan`) que no vale para todas. La voz y el dictado en esos idiomas no se han probado. Las capturas del README y la política de privacidad siguen solo en castellano (las de la ficha de Google Play ya están en los cuatro idiomas).
- **Voz y dictado** dependen del teléfono: hace falta la voz del idioma de la app instalada (la de español la traen casi todos los Android) y el dictado por voz de Google, que en algunos teléfonos necesita conexión. El dictado real no se ha podido probar en el emulador porque no tiene micrófono.
- La copia de seguridad propia de la app se hace a mano, y recuperarla sustituye todo lo que hay en el teléfono. Para juntar una copia con lo que ya hay está "Añadir medicamentos de otro móvil", pero solo usa los medicamentos y las citas: las tomas anotadas y los ajustes de la copia se quedan fuera. La copia automática de Android sí es automática, pero depende de que la persona la tenga activada con su cuenta de Google, y sin bloqueo de pantalla Google no la cifra con el PIN del teléfono. Sus reglas para Android 11 y anteriores (`reglas_copia_android11.xml`) no se han probado en un dispositivo; las de Android 12 y posteriores, en el emulador.
- La comprobación del ahorro de batería no puede ver los ajustes propios de algunos fabricantes (por ejemplo, el "inicio automático" de Xiaomi): en esas marcas lo señala siempre que Android optimice la batería de la app, y la explicación lleva a la pantalla de la app, desde donde se llega a esos ajustes.
- El PDF y las copias se han probado con el emulador (impresión, Descargas y menú "Compartir"); falta comprobar el envío real por WhatsApp o correo y una impresora de verdad.
- "Añadir medicamentos de otro móvil" reconoce los que ya se tienen por el nombre: si el familiar lo escribe de otra forma ("Omeprazol 20 mg"), se añade como otro. El recordatorio semanal es siempre los domingos a las 18:00; el aviso de una cita el día antes, a las 18:00, y el de la receta, una semana antes a las 10:00: no se pueden cambiar.
- La dosis de cada toma es por hora del día, no por día de la semana: una pauta como la del Sintrom, que cambia cada día, no se puede apuntar en un solo medicamento.
- El widget usa la letra del teléfono, no Montserrat, y siempre los colores del tema predeterminado: no sigue el tema ni el tamaño de texto elegidos en la app. Su botón abre la app para anotar la toma (como el del aviso): no la anota sin abrirla.
- Los **avisos discretos** lo son también con el móvil desbloqueado, porque `flutter_local_notifications` no permite un texto para la pantalla de bloqueo y otro al desbloquear. El widget sigue diciendo el nombre de la medicina, aunque estén activados.
- La cuenta de las pastillas va de media en media (no admite cuartos), y descuenta las tomas previstas aunque no se tomen: si se salta alguna, hay que corregir el número en "Modificar". El aviso de que quedan pocas se repite cada día solo si se abre la app.
- Los medicamentos con fecha de fin y los de "cada varios días" no tienen aviso recurrente en Android: se programan día a día para los próximos 14 días, y la app renueva esa ventana cada vez que se abre (el último aviso recuerda abrirla). Si no se abre en 14 días, dejan de avisar hasta que se abra.
- Los límites de los "cuando haga falta" no impiden anotar una toma de más (lo anotado tiene que ser lo que se ha tomado): la app avisa y pregunta. El máximo cuenta días del calendario, no las últimas 24 horas; para separar las tomas está el tiempo mínimo entre una y otra, que cuenta también la de ayer por la noche. "Escuchar las tomas de hoy" no los incluye.
- Si un medicamento con horario pasa a "cuando haga falta" (o al revés), el historial muestra las tomas que ya tenía anotadas según el modo nuevo.
- El día en que se registra un medicamento cuentan todas sus tomas de ese día, también las de antes de registrarlo: uno guardado a las 16:50 con una toma a las 08:00 la muestra como "Sin marcar. Era a las 08:00." en "Tomas de hoy", en el menú ("4 de 7" en vez de "4 de 6") y en el widget, y entra en el historial y en el PDF como no marcada. Sirve para anotarla si ya se tomó; si no, baja el porcentaje de tomas marcadas de ese día. Lo destapó la grabación del [recorrido en vídeo](#recorrido-en-vídeo).
- Lo verificado en el emulador no sustituye a un móvil físico: falta comprobar que suena y vibra de verdad, cómo se oye la voz, el dictado, la cámara real, el comportamiento con el móvil bloqueado, TalkBack y el widget en lanzadores de otras marcas: cómo lo dimensionan y si saben ponerlo desde Ajustes (ver [pruebas en un móvil real](docs/pruebas_en_dispositivo.md)).
- Si se usa "Forzar detención" en los ajustes del teléfono, Android cancela los avisos y no avisa a la app al reiniciar hasta que se vuelva a abrir; al abrirla se reprograman. Algunos fabricantes, además, cierran apps en segundo plano para ahorrar batería y pueden retrasar los avisos; en esos móviles conviene excluir la app del ahorro de batería.

## Licencias y atribuciones

- Tipografía **Montserrat**: © The Montserrat Project Authors, SIL Open Font License 1.1 ([assets/fonts/OFL.txt](assets/fonts/OFL.txt)).
- **Material Icons**: © Google, Apache License 2.0. El icono de la app usa el glifo `medication`.
- Paquetes **pdf** y **printing** (proyecto [dart_pdf](https://github.com/DavBfr/dart_pdf)), Apache License 2.0.
- No se usan pictogramas de ARASAAC.
