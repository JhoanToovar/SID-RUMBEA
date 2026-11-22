# SID-RUMBEA

## Acta de Reunión No. 09

| Campo               | Información                                          |
| ------------------- | ---------------------------------------------------- |
| **Proyecto**        | SID-RUMBEA                                           |
| **Reunión**         | Riesgos de IAg, documentación y ensayo de sustentación |
| **Fecha**           | Viernes 20 de noviembre de 2026                      |
| **Hora**            | 6:00 p. m.                                           |
| **Lugar**           | Reunión virtual (Meet)                               |
| **Asistentes**      | Jhoan, Juan Pablo, Miguel                            |
| **Próxima reunión** | Domingo 22 de noviembre de 2026                      |

## 1. Objetivo de la reunión

Revisar el documento de riesgos del uso de IAg, cerrar la documentación del repositorio y preparar el contenido y los roles de la sustentación.

## 2. Agenda

1. Riesgos del uso de IAg en la Entrega 3.
2. Registro en la bitácora de prompts.
3. README, guía de ejecución y evidencias.
4. Correcciones de actas y rutas.
5. Estructura de la sustentación.
6. Ensayo y pendientes.

## 3. Desarrollo de la reunión

Nos conectamos el viernes en la noche, después de una semana pesada. Empezamos por el documento de riesgos, que era lo que menos habíamos trabajado. Ya teníamos una propuesta de matriz de 12 riesgos con probabilidad, impacto y control, y la fuimos discutiendo uno por uno.

Los que más nos marcaron fueron cuatro. El primero, que una consulta puede correr sin error y responder otra pregunta: nos pasó con Q7, donde unir reseñas y géneros directamente inflaba los conteos. El segundo, que la IAg puede inventar o reinterpretar requisitos: propuso agregar una tabla de recordatorios y cambiar la PK de las visitas para cumplir R1 y R2, y nosotros decidimos no tocar el modelo. El tercero, la falsa sensación de "ya está probado": el equipo validó sintaxis con el parser de SQL Developer y los datos en una réplica de SQLite, y la IA nos advirtió que eso no compila PL/SQL ni reproduce Oracle; por eso la ejecución real en 11g era obligatoria. Y el cuarto, la pérdida de comprensión del equipo: no queremos entregar código que nadie sepa defender.

También revisamos la bitácora de prompts. En la Entrega 3 el nivel de uso de IAg es 4, así que podíamos usar la herramienta, pero teníamos que registrar los prompts, decir qué se aceptó, qué se rechazó y cómo se validó. Dejamos las entradas 05 a 10 con eso, incluyendo la decisión de no cambiar el modelo y la autorización para usar Docker cuando no encontramos el acceso al servidor de la universidad.

Sobre el servidor de la U: buscamos los datos de acceso y no los encontramos. La verdad no valía la pena seguir intentando; ya teníamos Oracle 11g XE en Docker y funcionaba. Decidimos que ese sería el entorno oficial de pruebas y que la guía de ejecución iba a explicar cómo crear la base, conectarse, correr todo con F5, repetir desde cero y qué hacer con los errores comunes.

Revisamos el README y las rutas. Encontramos que algunas actas tenían mal el día de la semana, que la bitácora apuntaba a rutas viejas y que dos PDF se habían dañado. Los restauramos desde los originales sin cambiarles el contenido y normalizamos los saltos de línea de `DDLProyecto.ddl` para que no apareciera como modificado en Git. También dejamos la evidencia de ejecución en `docs/evidencias/`.

Al final armamos la sustentación. Son 30 minutos en total y 12 de presentación, con siete secciones: contexto y requerimientos, MER, MR y normalización, DDL y DML, consultas y reportes, PL/SQL, y uso de IAg y reflexión. Repartimos así: Jhoan arranca con contexto, requerimientos y MER; Juan Pablo sigue con MR, normalización y DDL/DML; Miguel cierra con DQL, reportes y PL/SQL; y entre los tres cubrimos la parte de IAg. Igual todos tenemos que poder responder por cualquier componente, no solo por el nuestro.

Antes de cerrar hicimos un mini ensayo con cronómetro y nos dimos cuenta de que con el detalle que queríamos meter no alcanzaba. Tocó recortar tablas y quedarnos con las decisiones importantes: el arco de `BRANCH_UPDATE`, las FK compuestas, el trigger y las consultas más representativas.

## 4. Dificultades identificadas

* No encontramos el acceso al servidor Oracle de la universidad.
* La validación con SQLite y el parser no equivalía a una prueba real en Oracle.
* Dos PDF estaban dañados y varias rutas de la bitácora y días de las actas estaban desactualizados.
* El tiempo de la sustentación es corto para todo lo que hay para mostrar.
* Todavía no habíamos hecho la ejecución completa con la evidencia final.

## 5. Acuerdos y compromisos

| Responsable    | Compromiso                                                                   | Fecha límite            |
| -------------- | ---------------------------------------------------------------------------- | ----------------------- |
| **Miguel**     | Dejar lista la guía de ejecución y la evidencia de la corrida final.          | 21 de noviembre de 2026 |
| **Jhoan**      | Actualizar README, actas 6 a 10 y bitácora de seguimiento.                    | 22 de noviembre de 2026 |
| **Juan Pablo** | Revisar riesgos y preparar las diapositivas de MR, normalización y DDL/DML.   | 22 de noviembre de 2026 |
| **Los tres**   | Leer y entender los scripts y hacer el ensayo general.                        | 22 de noviembre de 2026 |

## 6. Aspectos definidos

* Documento de riesgos de IAg con 12 riesgos y controles.
* Registro del uso de IAg en la bitácora de prompts.
* Oracle 11g XE en Docker como entorno oficial.
* README y guía de ejecución actualizados.
* Evidencia de ejecución en `docs/evidencias/`.
* Reparto de la sustentación por secciones.
* Ensayo general para el domingo.

## 7. Resultado

Quedó cerrada la parte documental y definido el reparto de la sustentación. Nos quedó pendiente la corrida final en Oracle con la evidencia y la revisión de comprensión del código, que era justo lo que no queríamos dejar pasar.

## 8. Próxima reunión

El domingo 22 de noviembre de 2026, de forma virtual, para la ejecución final, las decisiones de cierre y el ensayo general.
