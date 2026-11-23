# SID-RUMBEA

## Acta de Reunión No. 10

| Campo               | Información                                      |
| ------------------- | ------------------------------------------------ |
| **Proyecto**        | SID-RUMBEA                                       |
| **Reunión**         | Reunión de decisiones y cierre de la Entrega 3   |
| **Fecha**           | Domingo 22 de noviembre de 2026                  |
| **Hora**            | 9:00 a. m.                                      |
| **Lugar**           | Reunión virtual (Meet)                           |
| **Asistentes**      | Jhoan, Juan Pablo, Miguel                        |
| **Próxima reunión** | Sustentación, semana 17 (fecha por confirmar)    |

## 1. Objetivo de la reunión

Tomar las decisiones finales de la Entrega 3, verificar la ejecución completa en Oracle, cerrar los pendientes documentales y dejar el equipo listo para la sustentación.

## 2. Agenda

1. Verificación de la entrega contra el enunciado.
2. Ejecución final y evidencia.
3. Decisiones sobre el modelo y el alcance de los reportes.
4. Uso de IAg y revisión de comprensión.
5. Documentación y repositorio.
6. Reparto y ensayo de la sustentación.
7. Cierre.

## 3. Desarrollo de la reunión

Nos conectamos el domingo a las 10, ya con todo el material a mano. Jhoan compartió pantalla y abrimos el enunciado, el README, el repositorio y el contenedor de Oracle. La idea era no irnos sin cerrar la entrega y sin tomar las decisiones que habíamos dejado para el final.

Primero corrimos `src/ejecutar_todo.sql` completo en Oracle 11g XE desde SQL Developer. Salió todo: 18 tablas, 1080 filas en el DML, la función, el procedimiento y el trigger compilados sin errores, las 24 pruebas en `24 correctas, 0 fallidas` y las 7 consultas con 14, 15, 12, 14, 10, 14 y 10 filas. Al final apareció `FIN: ejecucion completa.` Guardamos la salida como evidencia en `docs/evidencias/ejecucion_oracle11g.txt` y la enlazamos desde el README y la guía.

Después revisamos la lista del enunciado punto por punto. DDL documentado, sí; DML con al menos 10 registros por reporte, sí; DQL con agrupamiento, joins, ordenamiento y TOP, sí; documento de riesgos de IAg, sí; procedimiento, función y trigger documentados, sí; repositorio completo, sí. Ahí caímos en cuenta de que ya no había que agregar nada más al modelo, y eso nos tranquilizó.

Las decisiones que tomamos fueron estas:

1. Se cierra la Entrega 3 con los scripts y la documentación que ya están en el repositorio. No se hacen cambios estructurales de última hora.
2. El MR se queda como está. Se rechaza la idea de agregar una tabla de recordatorios y de cambiar la PK de `VISIT_PROFILES`. R1 y R2 quedan con el alcance documentado: Q4 se llama "audiencia potencial" y el historial de accesos es parcial. Preferimos eso a inventar un reporte que el modelo no puede sostener.
3. Se aceptan las 8 restricciones marcadas con `[E3]` porque no cambian tablas ni columnas y refuerzan reglas de negocio que ya estaban en el caso.
4. Oracle 11g XE en Docker queda como el entorno oficial de pruebas. La evidencia es la corrida real de hoy, no la validación de sintaxis ni la réplica de SQLite.
5. El uso de IAg se declara en la bitácora de prompts y se explica en la sustentación. Toda consulta a la IAg queda registrada, los artefactos son del equipo y, sobre todo, tienen que ser entendidos por los tres. No vamos a defender algo que no sepamos explicar.
6. La documentación final queda cerrada en cuanto a contenido: README, guía de ejecución, reportes y decisiones, riesgos, bitácoras y actas. La revisión de comprensión del código queda como el último pendiente antes de la sustentación.
7. Los puntos conocidos del modelo se explican sin esconderlos: la redundancia controlada de `BRANCH_EVENTS.ESTABLISHMENT_id`, el `visitTimeIn` en formato HH24MI, el `stateActive` como texto, el `password` de 50 caracteres frente a un hash bcrypt de 60 y la compatibilidad con 11g. Si nos preguntan, mejor tener la respuesta.

La decisión de no tocar el modelo fue la que más discutimos. Jhoan propuso dejar abierta la posibilidad de una tabla de recordatorios para una versión futura, Juan Pablo recordó que eso implicaba rehacer la PK de visitas y volver a la Entrega 2, y Miguel insistió en que era mejor entregar un alcance claro y bien documentado. Al final quedó como estaba: sin cambios estructurales y con las limitaciones explicadas. Nos reímos un poco porque la decisión más importante de la reunión terminó siendo no cambiar nada, pero era justo lo que necesitábamos para cerrar.

También revisamos el repositorio. Dejamos las actas 6 a 10, actualizamos la bitácora de seguimiento, revisamos que los enlaces del README apuntaran a los archivos reales y que la evidencia estuviera en la carpeta correcta. Dejamos listos los cambios para el commit de cierre de la Entrega 3 y verificamos que no se hubiera subido nada temporal. Para Saman dejamos listo el enlace del repositorio y los modelos actualizados; solo quedó pendiente confirmar la fecha de la sustentación.

Al final hicimos el ensayo general con cronómetro. Jhoan expuso contexto, requerimientos, MER y uso de IAg; Juan Pablo expuso MR, normalización, DDL y DML; Miguel expuso DQL, reportes y PL/SQL. Nos hicimos preguntas entre nosotros, sobre todo de las partes que no eran de cada uno. Nos dimos cuenta de que todavía nos falta un poco de fluidez en el trigger y en Q7, así que quedamos en repasarlos esa misma tarde.

## 4. Dificultades identificadas

* La comprensión completa del código es el pendiente más grande; nos falta repasar el trigger y Q7 con calma.
* El tiempo para la sustentación es corto y hay que resumir sin perder las decisiones importantes.
* Quedan limitaciones conocidas del modelo (R1 y R2) que hay que saber explicar sin que suenen a error.
* El cierre coincidió con otras entregas del semestre y con el cansancio acumulado.

## 5. Acuerdos y compromisos

| Responsable    | Compromiso                                                                                             | Fecha límite            |
| -------------- | ------------------------------------------------------------------------------------------------------ | ----------------------- |
| **Jhoan**      | Subir las actas 6 a 10, actualizar la bitácora de seguimiento y el README, y preparar contexto, MER e IAg. | 22 de noviembre de 2026 |
| **Juan Pablo** | Repasar DDL, DML y MR; preparar las diapositivas y explicar 3FN.                                         | 22 de noviembre de 2026 |
| **Miguel**     | Repasar DQL, PL/SQL, la evidencia y la demo; preparar los reportes.                                      | 22 de noviembre de 2026 |
| **Los tres**   | Ensayo general, revisión cruzada de preguntas y repaso del trigger y Q7.                                 | 22 de noviembre de 2026 |

## 6. Decisiones tomadas

* Se cierra la Entrega 3 con los scripts y documentos actuales.
* No se modifica el MR ni se agregan tablas de última hora.
* R1 y R2 quedan con alcance documentado; Q4 es audiencia potencial.
* Se aceptan las 8 restricciones `[E3]`.
* Oracle 11g XE en Docker es el entorno oficial de pruebas.
* El uso de IAg se declara y se cita; el equipo debe entender todo el código.
* La documentación final queda cerrada en contenido, pendiente la revisión de comprensión.
* Los puntos conocidos del modelo se explican en la sustentación.

## 7. Resultado

Se cerró la Entrega 3 y el repositorio quedó completo, con los scripts probados en Oracle, la evidencia, las actas y la documentación al día. El equipo quedó alineado con las decisiones y con el reparto de la sustentación. Nos queda la última revisión de comprensión y el repaso del trigger y Q7, pero la entrega ya está cerrada.

## 8. Próxima reunión

No se programan más reuniones de trabajo. La siguiente cita es la sustentación, en la semana 17, en la fecha que asigne el profesor. Antes de esa fecha cada uno repasa su parte y nos escribimos por WhatsApp para cualquier duda.

## Nota posterior a la reunión

Las 18 tablas, las 24 pruebas, la audiencia potencial de Q4 y el historial parcial de accesos corresponden a la versión revisada durante la reunión. La revisión final incorporó 19 tablas y registró 30 pruebas correctas. Q4 pasó a contar los recordatorios registrados en `CLIENT_EVENT_REMINDERS`. `VISIT_PROFILES` recibió una clave primaria propia (`id`), lo que permite registrar varias visitas del mismo cliente a la misma sede. Los cambios se detallan en [Reportes y decisiones](../reportes_y_decisiones.md#3-correcciones-al-modelo-después-de-la-revisión) y los resultados constan en la [evidencia de ejecución](../evidencias/ejecucion_oracle11g.txt).
