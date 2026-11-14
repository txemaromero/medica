# Publicar en Google Play

Pasos para publicar Salud y Medicación en Google Play, con los textos y las respuestas ya preparados. Lo que depende de la cuenta de quien publica (clave de firma, datos de contacto, dirección de la política de privacidad) está marcado con **[…]**.

## 1. Antes de empezar

- Una **cuenta de desarrollador de Google Play** con la identidad verificada.
- Si es una **cuenta personal creada después del 13 de noviembre de 2023**, Google exige una **prueba cerrada con al menos 12 testers durante 14 días seguidos** antes de poder publicar en producción ([ayuda de Google](https://support.google.com/googleplay/android-developer/answer/14151465)). Conviene buscar esos testers desde el principio: familiares, cuidadores, una asociación de mayores…
- La **política de privacidad** publicada en una dirección web pública (ver el punto 5).

## 2. Clave de firma

Google Play firma la app con su propia clave (**firma de apps de Play**). Lo que hace falta es una **clave de subida**, con la que se firma cada versión que se sube. Si se pierde, se puede pedir a Google que la cambie, pero conviene no perderla.

Crear la clave (una sola vez; `keytool` viene con el JDK):

```sh
keytool -genkeypair -v -keystore C:\ruta\segura\salud_mayores_subida.jks -keyalg RSA -keysize 2048 -validity 10000 -alias subida
```

Después, crear `android/key.properties` (git lo ignora: **no se sube nunca al repositorio**):

```properties
storePassword=[contraseña del almacén]
keyPassword=[contraseña de la clave]
keyAlias=subida
storeFile=C:/ruta/segura/salud_mayores_subida.jks
```

Guarda el `.jks` y las contraseñas en un sitio seguro y con copia (por ejemplo, un gestor de contraseñas). Sin `key.properties`, la versión release se firma con la clave de depuración: sirve para probarla, pero Google Play la rechaza.

## 3. Versión y compilación

- La versión está en `pubspec.yaml` (`version: 1.0.0+1`). El número tras el `+` (código de versión) **tiene que subir en cada envío** a Google Play: `1.0.1+2`, `1.1.0+3`…
- Comprobar todo y compilar el App Bundle firmado:

  ```sh
  powershell -ExecutionPolicy Bypass -File tool/comprobar.ps1 -Release
  ```

  El fichero queda en `build/app/outputs/bundle/release/app-release.aab`.
- Antes de subirlo, probar la **versión release** en un móvil: `flutter build apk --release` y `adb install build/app/outputs/flutter-apk/app-release.apk`. En el emulador se ha comprobado que en release funcionan los avisos (con la foto y los botones), "Ya la he tomado", la voz, el PDF, la copia de seguridad, los medicamentos "cuando haga falta", la cuenta de las pastillas, añadir los medicamentos de otro móvil y el widget de la pantalla de inicio.

## 4. Ficha de la tienda

**Nombre** (máximo 30 caracteres):

> Salud y Medicación

**Descripción breve** (máximo 80):

> Recordatorios de medicinas y citas, pensados para personas mayores.

**Descripción completa** (máximo 4000):

> Salud y Medicación te avisa de cada medicina y de cada cita, con letras grandes, botones grandes y colores de alto contraste. Está pensada para personas mayores y para quienes las cuidan.
>
> AVISOS DE MEDICINAS
> • Te avisa a la hora de cada toma, con la foto de la caja para reconocer la medicina.
> • Si la dosis cambia según la hora (por ejemplo, una pastilla por la mañana y media por la noche), cada aviso dice la suya.
> • Desde el propio aviso: "Ya la he tomado" o "Recordar en 10 min".
> • Si no marcas una toma, te lo vuelve a recordar a la media hora. En Ajustes eliges cuándo se repite el aviso (o que no se repita) y cuántos minutos espera el botón para recordarlo más tarde.
> • Si quieres, avisos discretos: no dicen qué medicina toca ni el motivo de la cita, y así no se leen en la pantalla de bloqueo.
> • Tomas repartidas por igual a lo largo del día o a las horas que elijas (desayuno, comida y cena).
> • Todos los días, solo algunos días de la semana o cada varios días; para siempre o hasta un día concreto.
> • Medicinas que se toman solo cuando hace falta, como un calmante: sin avisos, y apuntas cada vez que las tomas. Si les pones un máximo al día o unas horas entre una toma y otra, te avisa antes de pasarte.
>
> PASTILLAS Y RECETAS
> • Si quieres, lleva la cuenta de las pastillas (también las medias) y te avisa antes de que se acaben, para que compres más a tiempo.
> • Apunta cuándo se acaba la receta y te avisa una semana antes, para que pidas cita con tu médico.
>
> TOMAS DE HOY E HISTORIAL
> • Mira de un vistazo qué has tomado hoy y qué te falta.
> • Historial de los últimos 7 días, con cuántas tomas has marcado.
> • Un widget en la pantalla de inicio con la próxima toma y el botón "Ya la he tomado".
>
> AGENDA DE CITAS
> • Apunta tus citas médicas y recibe un aviso la tarde antes, el mismo día por la mañana y una hora antes.
>
> EMERGENCIAS
> • Un botón enorme para llamar al número de emergencia que elijas y otro para llamar a un familiar. Entrar en la pantalla no llama: se abre el teléfono con el número ya escrito.
>
> PARA LA FAMILIA Y EL MÉDICO
> • Envía o imprime un documento con tus medicinas, tus tomas de la semana y tus próximas citas. Si quieres, te lo recuerda cada domingo.
> • Un familiar puede apuntar tus medicinas en su móvil y enviártelas: se añaden a las tuyas sin borrar nada.
> • Guarda una copia de seguridad para no perder nada al cambiar de móvil.
>
> FÁCIL DE USAR
> • Asistente de primeros pasos.
> • Tamaño de letra ajustable y tres temas de colores.
> • Lectura en voz alta y dictado.
> • Compatible con TalkBack.
>
> PRIVACIDAD
> Tus datos se guardan solo en tu teléfono. Sin cuentas, sin publicidad y sin conexión a Internet.
>
> Salud y Medicación es una ayuda para recordar. No sustituye las indicaciones de tu médico ni de tu farmacéutico.

La ficha en catalán, gallego y euskera está en [traducciones.md](traducciones.md#ficha-de-google-play) (borradores para revisar).

**Categoría:** Medicina. **Correo de contacto:** [correo].

**Recursos gráficos**, en [docs/google_play](google_play) (se regeneran con `flutter test tool/google_play/recursos_test.dart`):

| Recurso | Fichero | Formato |
|---|---|---|
| Icono | `icono_512.png` | 512 × 512, PNG |
| Gráfico destacado | `grafico_destacado.png` (y `grafico_destacado_ca.png`, `_gl` y `_eu`) | 1024 × 500, PNG sin transparencia |
| Capturas de teléfono | `capturas/01…08` (y `capturas_ca/`, `capturas_gl/` y `capturas_eu/`) | 1080 × 1920, PNG sin transparencia |

Las capturas del README no valen para Google Play: su lado largo mide más del doble que el corto. Las de cada idioma salen con la app y los datos de ejemplo en ese idioma (los nombres de los medicamentos, como en las cajas); se suben en la ficha traducida de ese idioma, junto con su gráfico destacado (ver [traducciones.md](traducciones.md#ficha-de-google-play)).

## 5. Contenido de la app (Play Console)

**Política de privacidad.** El texto está en [politica_de_privacidad.md](politica_de_privacidad.md): completa el responsable y el contacto y publícalo en una dirección pública [URL]. Como el repositorio es privado, GitHub Pages solo sirve si se publica desde un repositorio público aparte (o con un plan de pago); también vale cualquier web propia o Google Sites.

**Acceso a la app:** todas las funciones están disponibles sin restricciones (no hay cuentas).

**Anuncios:** la app no contiene anuncios.

**Clasificación de contenido:** en el cuestionario, categoría "Todas las demás aplicaciones" y "No" a todas las preguntas (no hay violencia, contenido sexual, compras, comunicación entre usuarios ni ubicación).

**Público objetivo:** 18 años o más. La app no está dirigida a niños.

**Seguridad de los datos:** "No" a recoger y a compartir datos. Motivos, según la [ayuda de Google](https://support.google.com/googleplay/android-developer/answer/10787469):
- los datos solo se procesan en el teléfono (la versión release ni siquiera tiene permiso de Internet), y lo que no sale del teléfono no se declara;
- el PDF y la copia de seguridad solo salen del teléfono cuando la persona lo pide expresamente, con la app que elige, y a su propia nube si así lo decide: son envíos iniciados por la persona, que Google excluye.

**Declaración de apps de salud:** la app tiene funciones de salud. Categorías:
- "Medication and Treatment Management" (recordatorios y registro de tomas);
- "Healthcare Services and Management" (citas médicas y sus recordatorios).

No usa Health Connect ni es un dispositivo médico.

**Alarmas exactas.** La app declara `SCHEDULE_EXACT_ALARM`, el permiso que concede la propia persona (no `USE_EXACT_ALARM`, reservado a despertadores y calendarios). Antes de pedirlo explica para qué sirve y, si no se concede, usa alarmas inexactas. Si Play Console pide justificarlo:

> Recordatorios de medicación a la hora exacta que elige la persona usuaria (por ejemplo, "Omeprazol a las 9:00"). El permiso lo concede la propia persona tras una explicación; sin él, los avisos se programan como alarmas inexactas.

**Permisos del APK** (comprobados en la versión release): `POST_NOTIFICATIONS`, `VIBRATE`, `RECEIVE_BOOT_COMPLETED` y `SCHEDULE_EXACT_ALARM`. No pide cámara, micrófono, ubicación, contactos ni almacenamiento.

## 6. Pruebas y producción

1. Subir el App Bundle a **prueba interna** y comprobarlo en un móvil real con la lista de [pruebas en dispositivo](pruebas_en_dispositivo.md).
2. Pasar a **prueba cerrada** con los testers (al menos 12 durante 14 días, si la cuenta lo exige). Cómo organizarla, el mensaje de invitación, la guía para quien prueba y las preguntas del final están en [prueba_cerrada.md](prueba_cerrada.md).
3. Solicitar el **acceso a producción** desde el panel de Play Console y publicar.
