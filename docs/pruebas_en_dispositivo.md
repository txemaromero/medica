# Pruebas en un móvil real

Los tests automáticos cubren la lógica y las pantallas, y los tests de integración (`integration_test/`) comprueban en el dispositivo que los avisos quedan programados en Android. Lo que sigue hay que verlo y oírlo: que el aviso llega, cómo suena, si sobrevive a un reinicio, cómo lo lee TalkBack, la cámara, la voz, el dictado y lo que se envía a la familia.

Conviene hacerlo en **Android 13** (primer permiso de notificaciones) y en **Android 14 o posterior** (permiso de alarmas exactas denegado por defecto), y al menos una vez con el móvil bloqueado.

Anota en cada prueba: modelo y versión de Android, fecha, resultado (✅ / ❌) y observaciones.

## Preparación

1. Instala la app limpia: `adb uninstall es.saludmayores.salud_mayores` y después `flutter run` o `adb install build/app/outputs/flutter-apk/app-debug.apk`.
2. Pon el volumen de notificaciones alto y desactiva "No molestar".
3. La primera vez se abre el asistente: haz antes la sección 8. Para repetir las secciones 1 a 7 desde cero, reinstala y pulsa "Saltar estos pasos".

## 1. Permisos

| # | Pasos | Resultado esperado |
|---|---|---|
| 1.1 | Ajustes → "Activar notificaciones" | Aparece el diálogo de permiso de Android. |
| 1.2 | En el diálogo, pulsa "No permitir" | La app explica que falta el permiso y ofrece "Abrir ajustes del teléfono". El interruptor sigue en rojo, "Desactivado". |
| 1.3 | Pulsa "Abrir ajustes del teléfono", activa las notificaciones y vuelve | Se abre la pantalla de notificaciones de la app. Al volver, "Activar notificaciones" ya se puede activar. |
| 1.4 | (Android 14+) Al activar las notificaciones | La app ofrece el permiso de "alarmas y recordatorios". Pulsa "Dar permiso", actívalo y vuelve: aparece "Listo: los avisos llegarán a su hora exacta". |
| 1.5 | (Android 14+) Repite sin conceder ese permiso ("Ahora no") | Aviso de que pueden llegar unos minutos tarde. Las pruebas de la sección 3 deben seguir llegando, con algo de retraso. |
| 1.6 | Con los avisos activados, mira la tarjeta que hay bajo "Activar notificaciones" | "Los avisos están listos para llegar a su hora" o lo que falta (permiso, hora exacta, ahorro de batería), cada cosa con su botón. |
| 1.7 | (Samsung, Xiaomi, Huawei, Oppo, Realme, Vivo, OnePlus…) Mira esa tarjeta | Sale "El ahorro de batería del teléfono puede retrasar los avisos…". "Quitar el ahorro de batería" abre la pantalla de la app en los ajustes del teléfono: en "Batería", elige "Sin restricciones" y vuelve; la tarjeta pasa a "listos". Apunta cómo se llaman esas opciones en ese móvil. |
| 1.8 | Quita el permiso de notificaciones de la app en los ajustes del teléfono y vuelve a la app | El menú principal avisa "Los avisos no pueden llegar…" con "Dar permiso para los avisos"; al darlo, el aviso desaparece. |

## 2. Aviso de prueba, sonido y vibración

| # | Pasos | Resultado esperado |
|---|---|---|
| 2.1 | Sonido y vibración desactivados → "Probar aviso" | Llega una notificación "Aviso de prueba", sin sonido ni vibración. |
| 2.2 | Activa "Activar sonidos" → "Probar aviso" | Suena, sin vibrar. |
| 2.3 | Activa también "Activar vibración" → "Probar aviso" | Suena y vibra. |
| 2.4 | Desactiva "Activar notificaciones" → "Probar aviso" | La app explica que las notificaciones están desactivadas; no llega nada. |
| 2.5 | Quita el permiso en los ajustes del teléfono → "Probar aviso" | La app explica que falta el permiso y ofrece abrir los ajustes del teléfono. |

## 3. Recordatorios reales

Pon la hora de inicio 2–3 minutos después de la hora actual.

| # | Pasos | Resultado esperado |
|---|---|---|
| 3.1 | Registra un medicamento con 1 toma | A la hora indicada llega "Hora de tu medicina · Toma …". |
| 3.2 | Igual, con el móvil bloqueado y la pantalla apagada | La notificación llega con el móvil bloqueado. |
| 3.3 | Cierra la app (quítala de recientes) y espera la siguiente toma | El aviso llega igualmente. |
| 3.4 | Registra un medicamento y elimínalo antes de su hora | No llega ningún aviso. |
| 3.5 | Elimina un medicamento y pulsa "Deshacer" | El aviso vuelve a llegar a su hora. |
| 3.6 | Modifica la hora de un medicamento | Llega a la hora nueva y no a la antigua. |
| 3.7 | Medicamento "Hasta un día concreto" con fin hoy | Llegan las tomas de hoy; mañana ya no. En la lista pone "Tratamiento terminado". |
| 3.8 | Cita dentro de algo más de 1 hora | El aviso "Tu cita es dentro de 1 hora" llega a su hora. |
| 3.9 | Medicamento de 2 tomas "A horas concretas", las dos en los próximos minutos con unos minutos de diferencia | Llega un aviso a cada hora elegida. En la lista salen esas horas. |
| 3.10 | Medicamento de "Algunos días de la semana" con solo el día de hoy | Llega hoy a su hora. Mañana no llega; vuelve el mismo día de la semana siguiente. En la lista pone "Los …" con ese día. |
| 3.11 | Medicamento "Cada varios días" (cada 2 días, primer día hoy) | Llega hoy; mañana no; pasado mañana sí. "Tomas de hoy" mañana no lo muestra. |
| 3.12 | Antes de las 18:00, crea una cita para mañana | Al guardarla dice "Te avisaremos el día antes a las 18:00, ese día a las 08:00 y una hora antes.". A las 18:00 llega "Mañana tienes una cita". |

## 4. Seguimiento de tomas

Con un medicamento de 1 toma 2–3 minutos después de la hora actual.

| # | Pasos | Resultado esperado |
|---|---|---|
| 4.1 | Cuando llegue el aviso, pulsa "Ya la he tomado" en la notificación | Se abre la app en "Tomas de hoy" con la toma "Tomada a las …" y el mensaje "Anotado: has tomado …". La notificación desaparece. |
| 4.2 | Igual, con el móvil bloqueado | Android pide desbloquear; después se abre la app y la toma queda anotada. |
| 4.3 | Pulsa "Recordar en 10 min" | Se abre la app con la toma "Aplazada: te lo recordaremos a las …". A los 10 minutos llega "Recuerda tu medicina", con los mismos botones. |
| 4.4 | No hagas nada con el aviso | A los 30 minutos llega "¿Has tomado tu medicina?", con los botones. |
| 4.5 | Marca la toma en "Tomas de hoy" antes de que pasen esos 30 minutos | Ya no llega "¿Has tomado tu medicina?". |
| 4.6 | Marca en "Tomas de hoy" una toma que aún no ha llegado | Hoy no llega su aviso; mañana sí. |
| 4.7 | Desmarca una toma (o pulsa "Deshacer") antes de su hora | Vuelve a "Pendiente" y su aviso llega a su hora. |
| 4.8 | Toca el texto de la notificación, no los botones | Se abre "Tomas de hoy" sin marcar nada. |
| 4.9 | Con dos avisos de la app en la bandeja (por ejemplo, el de una toma y un "Probar aviso"), toca el grupo sin desplegarlo | Se abre "Tomas de hoy"; "Atrás" vuelve a la pantalla que había. |
| 4.10 | Con la app cerrada (quitada de recientes), pulsa "Ya la he tomado" | La app se abre en "Tomas de hoy" con la toma anotada. |
| 4.11 | "Historial de tomas" | Aparecen los últimos días con lo marcado y lo que quedó sin marcar. |
| 4.12 | Con TalkBack, en "Tomas de hoy" | Cada botón se lee con el medicamento y la hora ("Ya he tomado … de las …"). |
| 4.13 | Registra un medicamento "Solo cuando haga falta" | No llega ningún aviso. En "Tomas de hoy" sale en "Cuando haga falta", con "Hoy no lo has tomado". |
| 4.14 | Pulsa "Lo he tomado ahora" dos veces, con unos minutos entre una y otra | Pone "Hoy lo has tomado 2 veces: a las …". "Quitar la última" quita la segunda. En el historial salen como "tomada cuando hacía falta". |
| 4.15 | Modifícalo: "Cuánto se puede tomar" → como mucho 2 veces al día y 4 horas entre una y otra. Vuelve a "Tomas de hoy" | Dice "Como mucho 2 veces al día, con al menos 4 horas entre una y otra.", "Hoy ya lo has tomado las 2 veces que se puede" y, al pulsar "Lo he tomado ahora", explica por qué es más de lo que se puede y pregunta. "No, no lo anoto" no anota nada. |
| 4.16 | Registra un medicamento de 1 toma al día con "Llevar la cuenta" y 5 pastillas | La lista dice "Quedan 5 pastillas, para unos …" y "Quedan pocas"; el menú, "Te quedan pocas pastillas de …". A las 10:00 siguientes llega "Te quedan pocas pastillas"; al tocarlo se abre la lista. |
| 4.17 | Al día siguiente, después de su hora | La lista cuenta una pastilla menos, aunque no se haya marcado la toma. |
| 4.18 | Pulsa "He comprado más" y escribe 28 | La lista suma las 28 y el aviso del menú desaparece. |
| 4.19 | Medicamento de 2 tomas "A horas concretas" → "Dosis en cada toma" → "Distinta según la hora": "1 pastilla" y "media pastilla"; con "Llevar la cuenta", 30 pastillas, una y media | El aviso de cada hora dice su dosis; la lista, "Dosis: 1 pastilla a las … y media pastilla a las …". Tras la toma de la noche, la lista cuenta media pastilla menos. |
| 4.20 | Modifica un medicamento: "Receta" → "Se acaba un día concreto", dentro de 3 días | La lista dice "La receta se acaba dentro de 3 días…" con el botón "Ya la he renovado", y el menú, "Hay que renovar la receta de …". A las 10:00 siguientes llega "Renueva la receta"; al tocarlo se abre la lista. |
| 4.21 | Pulsa "Ya la he renovado" y guarda la fecha que propone (dentro de un mes) | La tarjeta dice "Receta: hasta el …", sin botón; el aviso del menú desaparece. |
| 4.22 | Ajustes → "Repetir los avisos" → "A los 15 minutos" y "Recordar en 5 min". Espera un aviso de toma sin tocarlo | El aviso lleva el botón "Recordar en 5 min"; a los 15 minutos llega "¿Has tomado tu medicina?". Al pulsar "Recordar en 5 min", llega a los 5 minutos. |
| 4.23 | Elige "No repetir el aviso" y deja pasar una toma sin marcar | Llega el aviso de su hora y ninguno más. |
| 4.24 | Ajustes → activa "Avisos discretos". Bloquea el móvil y espera un aviso de toma (y, si puedes, el de una cita) | En la pantalla de bloqueo sale "Hora de tu medicina" y "La de las …. Toca aquí para ver cuál es.", sin el nombre, la dosis ni la foto; el de la cita, sin el motivo ni el lugar. "Ya la he tomado" abre la app y dice qué medicina ha anotado. Al desactivarla, los siguientes avisos vuelven a decirlo todo. |

## 5. Reinicio y actualizaciones

> **Importante.** Si se usa "Forzar detención" en los ajustes del teléfono, o la app se instala por `adb`/`flutter test` y no se abre después desde su icono, Android la deja en *estado detenido*. En ese estado cancela sus alarmas y no le avisa cuando el teléfono arranca. Al abrir la app desde su icono, vuelve a programar todos los avisos. Antes de la prueba 5.1, abre la app al menos una vez desde el icono.
>
> Comprobación con `adb`: `adb shell "dumpsys package es.saludmayores.salud_mayores | grep stopped="` debe mostrar `stopped=false`, y `adb shell "dumpsys alarm | grep -c 'walarm\*:es.saludmayores'"` el número de alarmas programadas.

| # | Pasos | Resultado esperado |
|---|---|---|
| 5.1 | Con una toma programada en unos minutos, reinicia el móvil y **no abras la app** | El aviso llega igualmente tras el reinicio. |
| 5.2 | Instala encima una versión nueva (`adb install -r …`) sin abrirla | Los avisos siguen llegando. |
| 5.3 | Cambia la hora del móvil manualmente y abre la app | Los avisos se reprograman con la nueva hora. |

## 6. Emergencias

| # | Pasos | Resultado esperado |
|---|---|---|
| 6.1 | Sin número guardado → Botón de emergencias | Mensaje explicativo y botón "Ir a Ajustes". |
| 6.2 | Guarda el 112 → Botón de emergencias | Entrar no llama. Pulsar "Llamar" abre el marcador con el 112 escrito, sin llamar todavía. |

## 7. Accesibilidad

| # | Pasos | Resultado esperado |
|---|---|---|
| 7.1 | Activa TalkBack y recorre el menú | Lee el título y cada tarjeta ("Agenda, botón…"). |
| 7.2 | Con TalkBack, crea un medicamento con un error (sin nombre) | Al pulsar "Crear recordatorio" anuncia el error. |
| 7.3 | Con TalkBack, recorre Ajustes | Cada interruptor se lee con su estado ("Activado" / "Desactivado"). |
| 7.4 | Pon la letra del sistema al máximo y la de la app en 35 | Nada se corta ni se solapa; todo se alcanza con desplazamiento vertical. |
| 7.5 | Prueba los tres temas a plena luz del día | Todo se lee bien. |
| 7.6 | Con TalkBack, toca el campo "Nº de emergencia" en Ajustes y en el asistente | Lee "Nº de emergencia, cuadro de edición" y su descripción, sin mezclarlo con otros textos; con doble toque se puede escribir. |
| 7.7 | Con TalkBack, recorre Emergencias de arriba abajo | Lee, en este orden: "Pulsa el botón para llamar al 112", el botón de emergencias, el del familiar y la explicación final. |

## 8. Primera vez (asistente)

Con la app recién instalada.

| # | Pasos | Resultado esperado |
|---|---|---|
| 8.1 | Abre la app | Se abre "Primeros pasos" con "Hola" y los botones "Empezar" y "Saltar estos pasos". |
| 8.2 | "Empezar" → "Aumentar (+)" | La letra crece al momento en toda la pantalla. |
| 8.3 | "Siguiente" → "Activar los avisos" → "Permitir" | (Android 14+) Ofrece "Dar permiso" para la hora exacta. Después: "Los avisos están activados, con sonido y con vibración". |
| 8.4 | "Probar aviso" | Llega un aviso de prueba que suena y vibra. En la barra de estado se ve la silueta del frasco, no un cuadrado. |
| 8.5 | "Siguiente", escribe el 112 y "Siguiente" | "Todo listo" con el resumen de lo elegido. "Empezar a usar la aplicación" lleva al menú. |
| 8.6 | Cierra y vuelve a abrir la app | Se abre el menú principal: el asistente no vuelve a salir. |
| 8.7 | Reinstala, empieza el asistente, aumenta la letra y cierra la app a medias | Al volver a abrirla, el asistente sale otra vez. |
| 8.8 | En el escritorio del teléfono | El icono es el frasco azul marino sobre azul claro, recortado con la forma del launcher. |

## 9. Foto de la caja

| # | Pasos | Resultado esperado |
|---|---|---|
| 9.1 | Nuevo medicamento → "Hacer una foto" | Se abre la cámara del teléfono. Tras hacer la foto y aceptarla, se ve en el formulario. No se pide ningún permiso a la app. |
| 9.2 | "Elegir otra de la galería" | Se abre el selector de fotos del teléfono; la foto elegida sustituye a la anterior. |
| 9.3 | Guarda el medicamento | La foto aparece en la lista y en "Tomas de hoy". |
| 9.4 | Espera al aviso de ese medicamento | El aviso muestra la foto de la caja junto al texto y los botones. |
| 9.5 | Modificar → "Quitar la foto" → "Guardar cambios" | La foto desaparece de la lista y de los avisos siguientes. |
| 9.6 | Con TalkBack, recorre la lista | Lee "Foto de la caja de …" con el nombre del medicamento. |
| 9.7 | Activa "No conservar actividades" en las opciones de desarrollador, rellena a medias un medicamento y haz una foto | Al volver de la cámara, el formulario sigue con lo escrito y la foto, y avisa "Hemos recuperado lo que estabas escribiendo y la foto". Desactiva después la opción. |

## 10. Voz y dictado

Con el volumen multimedia alto (la voz usa ese volumen, no el de las notificaciones).

| # | Pasos | Resultado esperado |
|---|---|---|
| 10.1 | Ajustes → "Leer en voz alta" | Se oye "Así sonará la voz…" en español y el interruptor queda "Activado". |
| 10.2 | Toca el texto de un aviso de toma | Se abre "Tomas de hoy" y se oye la medicina, la dosis y "Cuando la tomes, pulsa: Ya la he tomado". |
| 10.3 | Pulsa "Ya la he tomado" en un aviso | Se oye "Anotado: has tomado …". |
| 10.4 | "Tomas de hoy" → "Escuchar las tomas de hoy" | Se oye cuántas hay, cuántas se han tomado y cuáles faltan. |
| 10.5 | Desactiva "Leer en voz alta" y toca otro aviso | No se oye nada y no aparece "Escuchar las tomas de hoy". |
| 10.6 | Nuevo medicamento → "Dictar el nombre" → di "paracetamol" | Se abre el dictado del teléfono ("Di el nombre del medicamento") y en el campo queda "Paracetamol". La app no pide permiso de micrófono. |
| 10.7 | Crear cita → "Dictar el motivo" | El motivo dictado queda en el campo. |
| 10.8 | En un teléfono sin dictado (o sin la app de Google) | No aparece el botón "Dictar". |

## 11. Familia y cuidadores

| # | Pasos | Resultado esperado |
|---|---|---|
| 11.1 | Ajustes → escribe el nombre y el teléfono de un familiar → "Guardar contacto" | Confirma el contacto. En Emergencias aparece "Llamar a …" debajo del botón de emergencias. |
| 11.2 | Pulsa "Llamar a …" | Se abre el marcador con su número, sin llamar todavía. |
| 11.3 | Ajustes → "Compartir y copia de seguridad" → "Enviar mi medicación y citas" → elige WhatsApp o el correo | Llega un PDF "Medicación y citas …" con las medicinas (y sus fotos), las tomas de la semana, las próximas citas y los teléfonos de emergencia. Se lee bien en otro móvil y en un ordenador. |
| 11.4 | "Imprimir" | Se abre la impresión del teléfono con la vista previa; con una impresora conectada, sale en papel. |
| 11.5 | "Guardar una copia" → Google Drive | La copia queda en Drive con el nombre "Copia de Salud y Medicación …". |
| 11.6 | En otro móvil (o tras reinstalar), instala la app, salta el asistente y pulsa "Recuperar una copia" → elige la copia de Drive | Explica de qué día es, qué contiene y qué teléfonos de emergencia y del familiar trae, y pide confirmación. Al aceptar aparecen las medicinas con sus fotos, las citas, el historial de tomas y los ajustes. |
| 11.7 | Tras recuperar, activa los avisos en Ajustes | Los avisos de las medicinas recuperadas llegan a su hora. |
| 11.8 | "Recuperar una copia" → elige otro fichero (una foto, un PDF) | Explica que no es una copia de la aplicación y no cambia nada. |
| 11.9 | Con la copia de seguridad de Google activada en el teléfono, instala la app en otro móvil con la misma cuenta (o reinstálala) | Android recupera solo los datos: las medicinas (con las fotos de las cajas), las citas, el historial y los ajustes aparecen sin pasar por el asistente. Como el permiso de avisos no se copia, el menú pide "Dar permiso para los avisos". |
| 11.10 | En el móvil de un familiar, apunta dos medicinas (una que ya esté en el de la persona mayor, a otra hora) y envíale una copia por WhatsApp. En el de la persona mayor, "Añadir medicamentos de otro móvil" → elige ese fichero | Dice qué se añadirá y qué se pondrá como en la copia, y que no se borra nada. Al aceptar, aparece la nueva y la otra cambia de hora; sus tomas anotadas y los ajustes siguen igual. |
| 11.11 | "Recordarme enviarlo cada semana" activado | El domingo a las 18:00 llega "¿Envías tu resumen a la familia?"; al tocarlo se abre "Compartir". |
| 11.12 | "Historial de tomas" | Arriba dice cuántas tomas se han marcado en los últimos 7 días y el porcentaje. |

## 12. Widget de la pantalla de inicio

| # | Pasos | Resultado esperado |
|---|---|---|
| 12.1 | Ajustes → "Poner la próxima toma en la pantalla de inicio" | El teléfono pregunta si se añade; al aceptar, aparece en la pantalla de inicio con la próxima toma. Si el teléfono no sabe ponerlo, la app explica cómo hacerlo a mano. |
| 12.2 | Espera a la hora de una toma sin abrir la app | El widget pasa a "Sin marcar. Era a las …" con el botón "Ya la he tomado". |
| 12.3 | Pulsa "Ya la he tomado" en el widget | Se abre la app en "Tomas de hoy" con la toma anotada; al volver, el widget muestra la siguiente. |
| 12.4 | Igual, con la app cerrada (quitada de recientes) | Lo mismo. |
| 12.5 | Toca el widget fuera del botón | Se abre "Tomas de hoy" sin marcar nada. |
| 12.6 | Con TalkBack, en el widget | Lee la medicina, la hora y el botón ("Ya he tomado … de las …"). |
| 12.7 | Pon la letra del teléfono al máximo | El texto del widget se agranda y el botón se sigue viendo (si no, se puede agrandar el widget). |
| 12.8 | Actualiza la app (instala la nueva versión encima) sin abrirla y pulsa "Ya la he tomado" en el widget | La toma se anota igual: al actualizar, Android redibuja el widget con su código secreto. |

## 13. Idiomas

Mejor con alguien que hable el idioma: las traducciones son borradores por revisar (ver [traducciones.md](traducciones.md)).

| # | Pasos | Resultado esperado |
|---|---|---|
| 13.1 | Pon el teléfono en catalán, gallego o euskera y abre la app | Todo sale en ese idioma: pantallas, fechas ("dilluns, 26 d'octubre"…), avisos y el PDF. |
| 13.2 | Con el teléfono en castellano, en Android 13 o posterior: Ajustes del teléfono → Aplicaciones → Salud y Medicación → Idioma, y elige otro | La app cambia de idioma sin cambiar el del teléfono. Al volver, los avisos que lleguen y el widget están en el idioma nuevo. |
| 13.3 | Con el teléfono en un idioma sin traducción (por ejemplo, francés) | La app sale en castellano. |
| 13.4 | En cada idioma, activa "Leer en voz alta" | Si el teléfono tiene la voz de ese idioma, se oye la frase de prueba con buena pronunciación; si no, la app explica cómo instalarla. |
| 13.5 | En cada idioma, "Dictar el nombre" | El dictado de Google entiende ese idioma. |
| 13.6 | Con la letra al máximo, recorre las pantallas | Ningún texto se corta ni se sale; las palabras largas pasan a la línea siguiente. |

## 14. iPhone

Solo si se prueba en iOS: ese código se ha escrito sin un Mac y no se ha probado nunca.

| # | Pasos | Resultado esperado |
|---|---|---|
| 14.1 | Primera vez, paso de los avisos | iOS pide el permiso de notificaciones; al aceptarlo, "Probar aviso" muestra uno. |
| 14.2 | Deja que llegue un aviso de toma y mantenlo pulsado | Salen "Ya la he tomado" y "Recordar en 10 min"; cada uno abre la app y hace lo suyo. |
| 14.3 | Ajustes → "Leer en voz alta" | Se oye la frase de prueba, también con el interruptor de silencio puesto. |
| 14.4 | "Enviar mi medicación y citas" | Sale la hoja de compartir de iOS con el PDF; en Mail, con asunto. En un iPad, como globo en el centro. |
| 14.5 | "Guardar una copia" y después "Recuperar una copia" | Se guarda donde se elija (En mi iPhone, iCloud Drive) y se recupera desde ahí. Volver sin elegir no cambia nada. |
| 14.6 | Foto de la caja con la cámara | iOS explica para qué la pide, en el idioma del iPhone. |
| 14.7 | Formulario de medicamento | No hay botón "Dictar el nombre"; el micrófono del teclado sí funciona. En Ajustes no está el botón del widget. |
