# Traducciones

La app está en castellano (el original) y tiene traducciones al **catalán**, al **gallego** y al **euskera**. Las tres son **borradores hechos con IA** en octubre de 2026: siguen las normas de cada idioma (IEC, RAG y Euskaltzaindia) y pasan los tests, pero nadie nativo las ha revisado todavía. Antes de publicarlas, conviene que alguien que hable el idioma las lea en el móvil, empezando por lo que se indica en cada idioma.

## Qué se traduce

| Fichero | Qué es |
|---|---|
| [lib/l10n/app_ca.arb](../lib/l10n/app_ca.arb), [app_gl.arb](../lib/l10n/app_gl.arb), [app_eu.arb](../lib/l10n/app_eu.arb) | Todos los textos de la app (unos 720): pantallas, avisos, frases que se leen en voz alta, mensajes de error y el PDF. |
| `android/app/src/main/res/values-ca`, `values-gl` y `values-eu` (`strings.xml`) | Los tres textos del widget que se ven antes de abrir la app por primera vez. |
| `ios/Runner/ca.lproj`, `gl.lproj` y `eu.lproj` (`InfoPlist.strings`) | En iPhone, para qué pide la app la cámara y las fotos. |
| [La ficha de Google Play](#ficha-de-google-play), al final de este documento | Nombre, descripción breve y descripción completa. |

El nombre de la app, **"Salud y Medicación"**, se deja igual en todos los idiomas: es el que aparece en el teléfono y en Google Play.

## Cómo revisarlas

- **En el móvil**: pon el teléfono en el idioma o, en Android 13 o posterior, solo la app (Ajustes del teléfono → Aplicaciones → Salud y Medicación → Idioma). Recorre las pantallas, crea un medicamento y una cita, deja que llegue un aviso y genera el PDF. La [lista de pruebas en un móvil real](pruebas_en_dispositivo.md) tiene una sección para los idiomas.
- **En los ficheros**: cada línea es `"clave": "texto"`. Lo que explica cada texto (dónde sale y qué va en los huecos) está en [app_es.arb](../lib/l10n/app_es.arb), en la entrada que empieza por `@` (por ejemplo, `"@fechaLarga"`).
- **Reglas**:
  - no se cambia la clave;
  - lo que va entre llaves (`{hora}`, `{medicamento}`) se deja igual, pero se puede mover;
  - en los plurales (`{cantidad, plural, =1{…} other{…}}`) solo se cambia lo de dentro de cada opción;
  - cuando una frase cita un botón ("pulsa «Ja me l'he presa»"), tiene que decir lo mismo que el botón.
- **Después**: `flutter gen-l10n` y `flutter test`. Los tests comprueban que no falta ningún texto ni hueco y recorren las pantallas en cada idioma con la letra al máximo.

## Catalán

**Términos elegidos**: toma → *presa*; aviso → *avís*; Ajustes (de la app y del teléfono) → *Configuració*; guardar → *desar*; borrar → *esborrar*; pulsar → *prémer*; elegir → *triar*; caja → *capsa*; pastillas → *pastilles*; aplazada → *ajornada*; copia de seguridad → *còpia de seguretat*; Atrás → *Enrere*; "Cuando haga falta" → *Quan calgui*; "Ya la he tomado" → *Ja me l'he presa*; "Recordar en 10 min" → *Recorda-m'ho en 10 min*.

**Para mirar primero**:
1. Los botones van en imperativo ("Desa els canvis", "Elimina", "Truca"), como es habitual en catalán, y no en infinitivo como en castellano.
2. `avisoAplazar`: "en 10 min" es más corto que "d'aquí a 10 min", pero menos normativo.
3. *Presa* es a la vez el nombre y el participio. Para no repetirlo: `tomasEstadoTomada` dice "Te l'has presa a les {hora}" e `informeColumnaTomadas`, "Marcades".
4. Siempre "a les {hora}", también a la 01:00, cuando se diría "a la una".
5. Delante de un nombre que empieza por vocal, "de" tendría que ser "d'", y el nombre se rellena al momento: por eso va detrás de dos puntos en `fotoCajaDe`, `menuExistenciasPocas`, `comprarHecho` y `tomasADemandaQuitarSemantica`.
6. `menuAjustes`: "Configuració" es la misma palabra que usa Android para los ajustes del teléfono.
7. `ajustesNumeroEmergencia`: cómo lee la voz la abreviatura "Núm.".
8. `fechaDeLaTarde`: "de la tarda" llega hasta las 20:59; quizá a partir de cierta hora sea mejor "del vespre".
9. `vozTodasTomadas` dice "ja no te'n falta cap".
10. `selectorAtajoEnUnaSemana` ("D'aquí a una setmana") y `dialogoNoVolver` ("No, torna enrere") son más largos que en castellano.

**Cambios en la forma de las frases**: las fechas eligen "de" o "d'" según el mes ("25 d'octubre", "27 de novembre") con un `select` en `fechaLarga`, `fechaCorta` y `fechaCuandoOtroDia`; los nombres de los meses van solos, porque también se ven así en el selector de fecha. `diasCadaFrase` dice "cada {cada} dies, a partir del {fecha}".

## Gallego

**Términos elegidos**: medicamento / medicina → igual; "Ya la he tomado" → *Xa a tomei*; "Te avisaremos" → *Avisarémoste*; "Recordar en 10 min" → *Lembrar en 10 min*; aplazada → *aprazada*; pulsar → *premer*; elegir → *escoller*; Ajustes (de la app) → *Axustes*; ajustes del teléfono → *Configuración*; copia de seguridad → *copia de seguranza*; fichero → *ficheiro*; móvil → *móbil*; comprar → *mercar* ("Merquei máis"); dictar → *ditar*; "Cuando haga falta" → *Cando faga falta*; desayuno, comida y cena → *almorzo, xantar e cea*.

**Para mirar primero**:
1. En toda la app, "medicina" y no "menciña" (por ejemplo, `avisoTomaTitulo`).
2. "mercar" y no "comprar" (`medicamentoComprarMas`, `comprarCampo`).
3. "copia de seguranza" y no "de seguridade" (`compartirCopiaDeSeguridad`).
4. `bateriaMensaje`: "Uso da batería" y "Sen restricións" como nombres de las opciones de Android en gallego, sin comprobar en un móvil.
5. `tomasADemandaMarcar` ("Tomeino agora") y `tomasADemandaHoy` ("tomáchelo"): los pronombres son correctos, pero hay que ver si se leen y se oyen con facilidad.
6. `respuestaAplazada`, `tomasEstadoAplazada`: "Avisarémoste de novo" en lugar de "lembrarémoscho", más pesado.
7. `emergenciasLlamarA`, `ajustesNombreFamiliarDescripcion`: "a" delante de persona ("Chamar a {nombre}").
8. `formularioCitaMuyPronto`: "A cita é moi pronto".
9. `compartirRecordarResumen`: "Lembrarme envialo cada semana".
10. `permisosAbrirAjustes` ("Abrir a Configuración do teléfono") es más largo que en castellano; `selectorAtajoEnUnaSemana` dice "Nunha semana".

**Cambios en la forma de las frases**: ninguno. Las preguntas no llevan el signo de apertura "¿", que la norma deja como opcional.

## Euskera

**Términos elegidos**: medicamento / medicina → *botika*; toma → *hartualdia*; aviso → *abisua* (notificación → *jakinarazpena*); cita → *hitzordua*; pastillas → *pilulak*; "Ya la he tomado" → *Hartu dut*; "Recordar en 10 min" → *Gogorarazi 10 min barru*; "Tomas de hoy" → *Gaurko hartualdiak*; "Cuando haga falta" → *Behar denean*; Pendiente → *Hartzeko*; Ajustes → *Ezarpenak*; copia de seguridad → *babeskopia*; Eliminar → *Ezabatu*; Modificar → *Aldatu*; anotar → *idatzi*; caja → *kaxa*; pulsar / tocar → *sakatu* / *ukitu*.

**Para mirar primero**:
1. `{hora}etan` (en `fechaCuandoHoy`, `fechaCuandoManana`, `fechaCuandoOtroDia`, `avisoCitaCuerpo`, `avisoRepeticionCuerpo`, `tomasEstadoSinMarcar` y otros): está bien para las horas en punto y las medias, y es dudoso para :15 o :20. Las horas que pueden ser cualquiera (cuándo se marcó, cuándo se recordará, la hora de una copia) van entre paréntesis o detrás de dos puntos.
2. `fechaLarga`, `{anio}ko`: está bien de 2026 a 2029, pero no para algunos años, como 2030 (*2030eko*).
3. `fechaCuandoOtroDia` usa el día en absolutivo (`{dia}a`) para no depender del número (*27an*, *25ean*), así que mezcla casos: "urriaren 27a, asteartea, 10:30etan".
4. `selectorHoraValor`, `{hora}ak` ("zortziak"): falla con las 0 y la 1.
5. `semanaLunes`…`semanaDomingo` van ya declinados ("astelehenetan"), y `diasSemanaFrase` es solo `{dias}`.
6. `informeDiaFecha` mantiene el orden día/mes ("larunbata 24/10"), como el nombre del PDF, y no el mes/día que recomienda Euskaltzaindia.
7. `fechaHoraConParteDelDia` da "goizeko 08:30", sin "-ak", y los títulos que empiezan así quedan en minúscula.
8. Nombres de Android sin comprobar en un móvil: "Murriztapenik gabe" y "Bateriaren erabilera" (`bateriaMensaje`) y "Baimendu" (`asistenteActivarAvisosDescripcion`).
9. `menuAgenda` es "Hitzorduak", no "Agenda".
10. `vozTotalTomas` lleva el verbo ("3 hartualdi dituzu") para que concuerden `vozTodasTomadas` y `vozHasTomado`.

**Cambios en la forma de las frases**:
- Los nombres que se rellenan al momento (medicinas, lugares, personas, fechas) no pueden llevar terminaciones, así que van detrás de dos puntos o en una posición que no las necesita ("Lekua: {lugar}", "Deitu: {nombre}", "Azken eguna: {fecha}").
- Las fechas van en el orden del euskera ("2026ko urriaren 25a, igandea"). Los meses se guardan sin declinar ("urria"), porque también se ven solos en el selector de fecha, y la plantilla añade "-ren".

## Ficha de Google Play

En Play Console, en la ficha de la tienda, se añaden las traducciones (catalán `ca`, euskera `eu-ES` y gallego `gl-ES`) y se pegan estos textos. En cada una se suben también sus capturas y su gráfico destacado: `docs/google_play/capturas_ca/` y `grafico_destacado_ca.png` (y lo mismo con `_gl` y `_eu`). Al revisar la traducción conviene mirarlas también: llevan los textos de la app y los datos de ejemplo (dosis, citas, el familiar y la caja) en ese idioma.

### Catalán

**Descripción breve** (62 de 80 caracteres):

> Recordatoris de medicines i cites, pensats per a la gent gran.

**Descripción completa** (2770 de 4000 caracteres):

> Salud y Medicación t'avisa de cada medicina i de cada cita, amb lletres grans, botons grans i colors d'alt contrast. Està pensada per a la gent gran i per a les persones que en tenen cura.
>
> AVISOS DE MEDICINES
> • T'avisa a l'hora de cada presa, amb la foto de la capsa per reconèixer la medicina.
> • Si la dosi canvia segons l'hora (per exemple, una pastilla al matí i mitja a la nit), cada avís diu la seva.
> • Des del mateix avís: "Ja me l'he presa" o "Recorda-m'ho en 10 min".
> • Si no marques una presa, t'ho torna a recordar al cap de mitja hora. A Configuració tries quan es repeteix l'avís (o que no es repeteixi) i quants minuts espera el botó per recordar-ho més tard.
> • Si vols, avisos discrets: no diuen quina medicina toca ni el motiu de la cita, i així no es llegeixen a la pantalla de bloqueig.
> • Preses repartides per igual al llarg del dia o a les hores que triïs (esmorzar, dinar i sopar).
> • Tots els dies, només alguns dies de la setmana o cada uns quants dies; per sempre o fins a un dia concret.
> • Medicines que només es prenen quan cal, com un calmant: sense avisos, i apuntes cada vegada que te les prens. Si els poses un màxim al dia o unes hores entre una presa i una altra, t'avisa abans que te'n passis.
>
> PASTILLES I RECEPTES
> • Si vols, porta el compte de les pastilles (també les mitges) i t'avisa abans que s'acabin, perquè en compris més a temps.
> • Apunta quan s'acaba la recepta i t'avisa una setmana abans, perquè demanis cita al teu metge.
>
> PRESES D'AVUI I HISTORIAL
> • Mira d'un cop d'ull què t'has pres avui i què et falta.
> • Historial dels últims 7 dies, amb quantes preses has marcat.
> • Un widget a la pantalla d'inici amb la propera presa i el botó "Ja me l'he presa".
>
> AGENDA DE CITES
> • Apunta les teves cites mèdiques i rep un avís la tarda abans, el mateix dia al matí i una hora abans.
>
> EMERGÈNCIES
> • Un botó enorme per trucar al número d'emergència que triïs i un altre per trucar a un familiar. Entrar a la pantalla no fa la trucada: s'obre el telèfon amb el número ja escrit.
>
> PER A LA FAMÍLIA I EL METGE
> • Envia o imprimeix un document amb les teves medicines, les preses de la setmana i les properes cites. Si vols, t'ho recorda cada diumenge.
> • Un familiar pot apuntar les teves medicines al seu mòbil i enviar-te-les: s'afegeixen a les teves sense esborrar res.
> • Desa una còpia de seguretat per no perdre res quan canviïs de mòbil.
>
> FÀCIL D'UTILITZAR
> • Assistent de primers passos.
> • Mida de lletra ajustable i tres temes de colors.
> • Lectura en veu alta i dictat.
> • Compatible amb TalkBack.
>
> PRIVADESA
> Les teves dades es desen només al teu telèfon. Sense comptes, sense publicitat i sense connexió a Internet.
>
> Salud y Medicación és una ajuda per recordar. No substitueix les indicacions del teu metge ni del teu farmacèutic.

### Gallego

**Descripción breve** (66 de 80 caracteres):

> Recordatorios de medicinas e citas, pensados para persoas maiores.

**Descripción completa** (2659 de 4000 caracteres):

> Salud y Medicación avísate de cada medicina e de cada cita, con letras grandes, botóns grandes e cores de alto contraste. Está pensada para persoas maiores e para quen as coida.
>
> AVISOS DE MEDICINAS
> • Avísate á hora de cada toma, coa foto da caixa para recoñecer a medicina.
> • Se a dose cambia segundo a hora (por exemplo, unha pastilla pola mañá e media pola noite), cada aviso di a súa.
> • Desde o propio aviso: "Xa a tomei" ou "Lembrar en 10 min".
> • Se non marcas unha toma, volve avisarte á media hora. En Axustes escolles cando se repite o aviso (ou que non se repita) e cantos minutos espera o botón para lembralo máis tarde.
> • Se queres, avisos discretos: non din que medicina toca nin o motivo da cita, e así non se len na pantalla de bloqueo.
> • Tomas repartidas por igual ao longo do día ou ás horas que escollas (almorzo, xantar e cea).
> • Todos os días, só algúns días da semana ou cada varios días; para sempre ou ata un día concreto.
> • Medicinas que se toman só cando fai falta, como un calmante: sen avisos, e apuntas cada vez que as tomas. Se lles pos un máximo ao día ou unhas horas entre unha toma e outra, avísate antes de que te pases.
>
> PASTILLAS E RECEITAS
> • Se queres, leva a conta das pastillas (tamén as medias) e avísate antes de que se acaben, para que merques máis a tempo.
> • Apunta cando se acaba a receita e avísate unha semana antes, para que pidas cita co teu médico.
>
> TOMAS DE HOXE E HISTORIAL
> • Mira dunha ollada que tomaches hoxe e que che falta.
> • Historial dos últimos 7 días, con cantas tomas marcaches.
> • Un widget na pantalla de inicio coa próxima toma e o botón "Xa a tomei".
>
> AXENDA DE CITAS
> • Apunta as túas citas médicas e recibe un aviso a tarde antes, o mesmo día pola mañá e unha hora antes.
>
> EMERXENCIAS
> • Un botón enorme para chamar ao número de emerxencia que escollas e outro para chamar a un familiar. Entrar na pantalla non chama: ábrese o teléfono co número xa escrito.
>
> PARA A FAMILIA E O MÉDICO
> • Envía ou imprime un documento coas túas medicinas, as túas tomas da semana e as túas próximas citas. Se queres, avísate cada domingo para envialo.
> • Un familiar pode apuntar as túas medicinas no seu móbil e enviarchas: engádense ás túas sen borrar nada.
> • Garda unha copia de seguranza para non perder nada ao cambiar de móbil.
>
> FÁCIL DE USAR
> • Asistente de primeiros pasos.
> • Tamaño de letra axustable e tres temas de cores.
> • Lectura en voz alta e ditado.
> • Compatible con TalkBack.
>
> PRIVACIDADE
> Os teus datos gárdanse só no teu teléfono. Sen contas, sen publicidade e sen conexión a Internet.
>
> Salud y Medicación é unha axuda para lembrar. Non substitúe as indicacións do teu médico nin do teu farmacéutico.

### Euskera

**Descripción breve** (65 de 80 caracteres):

> Botiken eta hitzorduen abisuak, adineko pertsonentzat pentsatuak.

**Descripción completa** (3003 de 4000 caracteres):

> Salud y Medicación aplikazioak botika eta hitzordu bakoitzaren abisua ematen dizu, letra handiekin, botoi handiekin eta kontraste handiko koloreekin. Adineko pertsonentzat eta haiek zaintzen dituztenentzat pentsatuta dago.
>
> BOTIKEN ABISUAK
> • Hartualdi bakoitzaren orduan abisatzen dizu, kaxaren argazkiarekin, botika ezagutzeko.
> • Dosia orduaren arabera aldatzen bada (adibidez, pilula bat goizean eta erdi bat gauean), abisu bakoitzak berea esaten du.
> • Abisutik bertatik: "Hartu dut" edo "Gogorarazi 10 min barru".
> • Hartualdi bat markatzen ez baduzu, ordu erdi barru berriro gogorarazten dizu. Ezarpenetan aukeratzen duzu noiz errepikatzen den abisua (edo ez errepikatzea) eta geroago gogorarazteko botoiak zenbat minutu itxaroten dituen.
> • Nahi baduzu, abisu diskretuak: ez dute esaten zein botika hartu behar duzun edo hitzorduaren arrazoia, eta horrela ez dira blokeo-pantailan irakurtzen.
> • Hartualdiak egunean zehar berdin banatuta, edo zuk aukeratutako orduetan (gosaria, bazkaria eta afaria).
> • Egunero, asteko egun batzuetan bakarrik edo zenbait egunetik behin; betiko edo egun jakin bat arte.
> • Behar denean bakarrik hartzen diren botikak, mina kentzekoak adibidez: abisurik gabe, eta hartzen dituzun bakoitzean idazten duzu. Egunean gehienez zenbat aldiz edo hartualdien artean zenbat ordu jartzen badiezu, gehiegi hartu aurretik abisatzen dizu.
>
> PILULAK ETA ERREZETAK
> • Nahi baduzu, pilulen kontua eramaten du (erdiak ere bai) eta amaitu aurretik abisatzen dizu, garaiz gehiago eros ditzazun.
> • Idatzi noiz amaitzen den errezeta, eta astebete lehenago abisatuko dizu, zure medikuarekin hitzordua eska dezazun.
>
> GAURKO HARTUALDIAK ETA HISTORIA
> • Begi-kolpe batean ikusi zer hartu duzun gaur eta zer falta zaizun.
> • Azken 7 egunetako historia, zenbat hartualdi markatu dituzun ikusteko.
> • Widget bat hasierako pantailan, hurrengo hartualdiarekin eta "Hartu dut" botoiarekin.
>
> HITZORDUEN AGENDA
> • Idatzi zure mediku-hitzorduak, eta jaso abisu bat aurreko arratsaldean, egun berean goizean eta ordubete lehenago.
>
> LARRIALDIAK
> • Botoi erraldoi bat zuk aukeratutako larrialdi-zenbakira deitzeko, eta beste bat senide bati deitzeko. Pantailan sartzeak ez du deitzen: telefonoa irekitzen da, zenbakia idatzita duela.
>
> FAMILIARENTZAT ETA MEDIKUARENTZAT
> • Bidali edo inprimatu dokumentu bat zure botikekin, asteko hartualdiekin eta hurrengo hitzorduekin. Nahi baduzu, igandero gogorarazten dizu.
> • Senide batek zure botikak idatz ditzake bere mugikorrean eta zuri bidali: zureei gehitzen zaizkie, ezer ezabatu gabe.
> • Gorde babeskopia bat, mugikorrez aldatzean ezer ez galtzeko.
>
> ERRAZA ERABILTZEN
> • Lehen urratsetarako laguntzailea.
> • Letraren tamaina doigarria eta hiru kolore-gai.
> • Ozen irakurtzea eta diktatzea.
> • TalkBack-ekin bateragarria.
>
> PRIBATUTASUNA
> Zure datuak zure telefonoan bakarrik gordetzen dira. Konturik gabe, publizitaterik gabe eta Interneteko konexiorik gabe.
>
> Salud y Medicación gogoratzeko laguntza bat da. Ez ditu ordezten zure medikuaren edo farmazialariaren jarraibideak.
