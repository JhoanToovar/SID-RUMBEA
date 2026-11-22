# SID-RUMBEA

## Registro de uso de Inteligencia Artificial

Este documento registra las consultas realizadas a herramientas de IA durante el desarrollo del proyecto **SID-RUMBEA**, indicando el propósito de cada una, la herramienta utilizada y el tratamiento que el equipo dio a las respuestas.

El uso de IA fue siempre consultivo y estuvo limitado a cuatro funciones: **aportar ideas, revisar trabajo ya hecho por el equipo, ayudar a precisar especificaciones y resolver dudas puntuales**. La IA no redactó scripts, no construyó modelos, no generó documentos y no tomó decisiones de diseño. Cada artefacto del proyecto fue elaborado por los integrantes, y las respuestas de la IA se evaluaron, se aceptaron parcialmente o se descartaron.

En las **Entregas 0 a 2** (nivel 2) el proyecto se desarrolló de forma manual: caso de estudio, historias de usuario, modelo entidad-relación (MER), modelo relacional (MR) y organización del repositorio fueron elaboración propia en Oracle Data Modeler y GitHub. La IA se consultó solo para revisar redacción, aclarar conceptos pequeños y recordar sintaxis de Markdown.

En la **Entrega 3** (nivel 4, IAG completa) el equipo mantuvo el mismo criterio. La IA se usó para contrastar el alcance, revisar decisiones y resolver dudas técnicas, como se registra en los Prompts No. 05 a 10. Los scripts y la documentación los escribió el equipo.

---

# Prompt No. 01

## Información general

| Campo                  | Información                    |
| ---------------------- | ------------------------------ |
| **Fecha**              | 29/08/2026                     |
| **Herramienta**        | ChatGPT                        |
| **Etapa del proyecto** | Entrega 0                      |
| **Componente**         | Documentación - Caso de estudio|
| **Responsable**        | Jhoan                          |

## 1. Objetivo del prompt

Revisar la ortografía y claridad de un párrafo del caso de estudio que habíamos redactado nosotros, sin que nos lo reescribiera desde cero.

## 2. Prompt utilizado

```text
Te paso un párrafo que redactamos para nuestro caso de estudio, no me generes nada nuevo ni me cambies las entidades. Solo dime si se entiende y corrígeme ortografía y tildes:

"En Cali existe una gran variedad de establecimientos de entretenimiento nocturno como discotecas, bares y terrazas, pero la información se encuentra dispersa en diferentes plataformas lo que dificulta a los usuarios encontrar un lugar que se adapte a sus preferencias."
```

## 3. Resultado obtenido

La herramienta devolvió el mismo párrafo con corrección de una coma y sugirió dos formas alternativas de redactar la última parte. También propuso agregar entidades nuevas, lo cual ignoramos.

```text
[Respuesta relevante: corrección de coma antes de "lo que" y sugerencia de "se adapte a sus gustos y necesidades"]
```

## 4. Uso de la respuesta

* Se utilizó únicamente como referencia de redacción.
* Solo se aceptó la corrección de la coma y una tilde.
* Se descartó todo lo demás, en especial las entidades que proponía.

## 5. Modificaciones realizadas por el equipo

El párrafo final lo redactamos nosotros. No se incorporó ninguna frase generada por la IA tal cual, solo ajustamos puntuación. El contenido, entidades y reglas de negocio son 100% del equipo y se validaron contra las historias de usuario.

## 6. Validación

Se comparó el párrafo corregido con las historias de usuario HU1-HU7 para verificar que no se hubiera cambiado el sentido. Lo revisamos entre Jhoan y Juan Pablo en el CAMBAS.

## 7. Resultado final

Párrafo del caso de estudio con mejor puntuación, pero con el mismo contenido definido por el equipo. Sirvió solo para pulir redacción.

---

# Prompt No. 02

## Información general

| Campo                  | Información       |
| ---------------------- | ----------------- |
| **Fecha**              | 02/09/2026        |
| **Herramienta**        | Gemini            |
| **Etapa del proyecto** | Entrega 1         |
| **Componente**         | MER - Duda conceptual |
| **Responsable**        | Juan Pablo        |

## 1. Objetivo del prompt

Entender la diferencia entre un arco y un simple CHECK, porque en clase nos quedó la duda de cuándo usar arco en `BRANCH_UPDATE`.

## 2. Prompt utilizado

```text
Explícame con un ejemplo sencillo qué es un arco en un modelo entidad-relación y cuándo se usa. No me hagas el modelo, solo la explicación corta, es para una clase de bases de datos con Oracle Data Modeler.
```

## 3. Resultado obtenido

Explicación teórica corta: el arco se usa cuando una entidad debe relacionarse con exactamente una de dos (o más) entidades, ejemplo típico de "pagado por tarjeta o efectivo". No dio ningún modelo de nuestro proyecto.

## 4. Uso de la respuesta

* Se utilizó únicamente para resolver una duda conceptual.
* No se copió nada al proyecto.
* El modelado de `BRANCH_UPDATE` (dueño o administrador, pero no ambos) lo hicimos nosotros a mano en Data Modeler.

## 5. Modificaciones realizadas por el equipo

Ninguna incorporación directa. La explicación nos sirvió para confirmar lo que ya habíamos discutido en clase y en la reunión del 2 de septiembre. La configuración de la columna discriminadora y el arco la hicimos por nuestra cuenta probando en la herramienta, que de hecho nos dio error al principio.

## 6. Validación

Validamos lo entendido contra los apuntes de clase y contra la regla de negocio HU8: "una actualización debe haber sido realizada por exactamente un dueño o exactamente un administrador". El profesor en asesoría nos confirmó que iba por buen camino.

## 7. Resultado final

Nos quedó claro el concepto y pudimos justificar el arco en el MER. El diagrama sigue siendo trabajo totalmente manual del equipo.

---

# Prompt No. 03

## Información general

| Campo                  | Información                 |
| ---------------------- | --------------------------- |
| **Fecha**              | 02/10/2026                  |
| **Herramienta**        | ChatGPT                     |
| **Etapa del proyecto** | Entrega 2                   |
| **Componente**         | Documentación - README      |
| **Responsable**        | Miguel                      |

## 1. Objetivo del prompt

Recordar la sintaxis de tablas en Markdown para acomodar el README, que se nos descuadraba a cada rato.

## 2. Prompt utilizado

```text
¿Cómo se hace una tabla en markdown con 3 columnas y cómo se centra el texto? Dame solo la sintaxis, yo pongo mi contenido.
```

## 3. Resultado obtenido

Devolvió el ejemplo básico con `| | |` y los `---`, y cómo alinear con `:---:`.

```text
| col1 | col2 | col3 |
| :--- | :--- | :--- |
```

## 4. Uso de la respuesta

* Se usó solo para formato.
* Todo el contenido del README (descripción, integrantes, estados, estructura de carpetas) lo escribimos nosotros.

## 5. Modificaciones realizadas por el equipo

Usamos la sintaxis como referencia y armamos la tabla con nuestra información. Tuvimos que arreglar a mano varias filas porque se nos movían las columnas al hacer push.

## 6. Validación

Previsualizamos el README en GitHub y verificamos que las tablas se vieran bien. El contenido lo revisamos entre los tres en la reunión virtual del 4 de octubre.

## 7. Resultado final

README con tablas bien formateadas, pero con contenido 100% redactado por el equipo. La IA solo ayudó con la sintaxis Markdown.

---

# Prompt No. 04

## Información general

| Campo                  | Información                |
| ---------------------- | -------------------------- |
| **Fecha**              | 04/10/2026                 |
| **Herramienta**        | ChatGPT                    |
| **Etapa del proyecto** | Entrega 2                  |
| **Componente**         | Documentación - Actas      |
| **Responsable**        | Jhoan                      |

## 1. Objetivo del prompt

Revisar que las actas 4 y 5 que redactamos nosotros no tuvieran errores de ortografía y que sonaran formales, sin que nos inventara contenido.

## 2. Prompt utilizado

```text
Te paso un acta que ya redacté de una reunión de universidad, solo revísame ortografía y que suene formal. No me agregues acuerdos ni fechas nuevas, respeta lo que yo escribí:

"Durante la reunión se revisó el caso de estudio corregido y se procedió a validar el modelo relacional desarrollado en Oracle Data Modeler..."
```

## 3. Resultado obtenido

Devolvió el texto con dos tildes corregidas y sugirió cambiar "acomodamos el repo" por "se organizó el repositorio". No agregó ningún acuerdo nuevo.

## 4. Uso de la respuesta

* Se utilizó como corrector de estilo.
* Se aceptó solo el cambio de "acomodamos" por "se acomodó / se organizó" para que sonara más formal.
* Las fechas, asistentes, acuerdos y compromisos son los que definimos en las reuniones del 1 y 4 de octubre.

## 5. Modificaciones realizadas por el equipo

Releímos todo y dejamos nuestra redacción original casi intacta. Solo ajustamos tildes y un par de palabras. El contenido de qué se definió en el MR y cómo se acomodó el repo lo escribimos nosotros con base en lo que realmente hicimos.

## 6. Validación

Comparamos la versión corregida con nuestros apuntes de WhatsApp y con el MR definitivo (`MRRumbea.pdf`) para asegurar que no se hubiera inventado nada. Lo revisamos los tres antes de subirlo.

## 7. Resultado final

Actas 4 y 5 con mejor redacción, pero con contenido totalmente del equipo. La IA actuó solo como corrector.

---

# Prompt No. 05

## Información general

| Campo                  | Información                                              |
| ---------------------- | -------------------------------------------------------- |
| **Fecha**              | 04/11/2026                                               |
| **Herramienta**        | Claude                                                   |
| **Etapa del proyecto** | Entrega 3                                                |
| **Componente**         | Planeación - Alcance y especificación                    |
| **Responsable**        | Jhoan                                                    |

## 1. Objetivo del prompt

Revisar el alcance que el equipo ya había definido para la Entrega 3 y detectar ambigüedades o requisitos faltantes antes de empezar a escribir los scripts. La IA no redactó el alcance: solo lo revisó.

## 2. Prompt utilizado

```text
Te paso el alcance que ya definimos para la Entrega 3. No escribas scripts, documentos ni consultas. Solo revísalo y dime qué ambigüedades, requisitos faltantes o riesgos ves, para corregirlo nosotros:

- DDL de la base de datos, debidamente documentado.
- DML con los datos de prueba necesarios para los reportes, con al menos 10 registros por reporte.
- DQL para los reportes definidos, con agrupamiento, INNER JOIN, OUTER JOIN, ordenamiento y al menos un TOP.
- Documento sobre los riesgos del uso de IAG en un contexto profesional.
- PL/SQL con al menos un procedimiento almacenado, una función y un trigger, cada uno documentado.
- Entrega completa del repositorio.

El MR ya está validado y no se modifica. La información de negocio está en docs/CasoDeEstudio.pdf.
```

```text
También tenemos esta restricción: no cambiar el modelo ni agregar tablas. Solo se pueden agregar restricciones que no modifiquen tablas ni columnas. ¿Ves algún problema con eso?
```

## 3. Resultado obtenido

La herramienta devolvió observaciones, no artefactos:

* Señaló que el alcance debía declarar qué pasaría si el modelo no soportaba algún reporte.
* Recordó que el DML debía cubrir al menos 10 registros por cada reporte y no solo llenar las tablas.
* Advirtió que el TOP debía resolverse con `ROWNUM` por la versión de Oracle.
* Recomendó confirmar el entorno de ejecución antes de asumir credenciales o rutas.

## 4. Uso de la respuesta

* El equipo mantuvo el alcance que ya había definido y solo agregó la aclaración sobre reportes no soportados.
* Se confirmó la decisión de no modificar el MR.
* La idea de usar Docker se evaluó después, cuando no se consiguió el acceso al servidor de la universidad.
* No se copió ningún texto de la respuesta.

## 5. Modificaciones realizadas por el equipo

El alcance, las restricciones y el orden de los scripts los definió el equipo en la reunión del 4 de noviembre. La IA no escribió el documento ni los scripts.

## 6. Validación

El alcance se contrastó con el enunciado de la Entrega 3 y con lo acordado en el Acta 6.

## 7. Resultado final

Alcance claro y sin cambios de fondo, con la autoría del equipo.

---

# Prompt No. 06

## Información general

| Campo                  | Información                                              |
| ---------------------- | -------------------------------------------------------- |
| **Fecha**              | 11/11/2026                                               |
| **Herramienta**        | Claude                                                   |
| **Etapa del proyecto** | Entrega 3                                                |
| **Componente**         | DDL y restricciones                                      |
| **Responsable**        | Juan Pablo                                               |

## 1. Objetivo del prompt

Revisar el DDL exportado desde Data Modeler y las restricciones que el equipo pensaba agregar, sin cambiar tablas ni columnas. La IA no escribió el DDL.

## 2. Prompt utilizado

```text
Revisa este DDL que exportamos de Data Modeler. No propongas tablas nuevas ni cambios de columnas; solo dime si ves errores de sintaxis, nombres problemáticos para Oracle 11g o restricciones que falten:

[ fragmento del DDL exportado ]
```

```text
Estas son las restricciones que pensamos agregar. No cambies el modelo; solo dime si alguna es inválida o si se nos está escapando una regla:

- Aforo y cover no negativos.
- Calificación de reseñas entre 1 y 5.
- Un solo tipo por sede.
- Un solo horario por día por sede.
```

## 3. Resultado obtenido

* Confirmó que las restricciones propuestas se podían declarar con `CHECK` y `UNIQUE` sin tocar la estructura.
* Advirtió que el cover debía permitir el valor 0 y que los nombres no debían pasar de 30 caracteres por Oracle 11g.
* Sugirió una validación al inicio del script para detenerse si ya existían objetos con esos nombres.
* Recomendó un script de limpieza separado, sin `CASCADE CONSTRAINTS`.

## 4. Uso de la respuesta

* Se aceptaron las 8 restricciones `[E3]` que no cambian tablas ni columnas.
* Se aceptó la validación previa y el script de limpieza protegido.
* Se rechazó cualquier cambio de esquema.
* El DDL exportado por Juan Pablo se conservó intacto.

## 5. Modificaciones realizadas por el equipo

Juan Pablo agregó las restricciones y las marcó con `[E3]`. El equipo escribió la validación inicial y el script de limpieza. Ningún objeto fue generado por la IA.

## 6. Validación

Se revisó la sintaxis con el parser de SQL Developer y luego se ejecutó el DDL completo en Oracle 11g XE.

## 7. Resultado final

DDL documentado con 18 tablas y 8 restricciones adicionales, sin cambios estructurales.

---

# Prompt No. 07

## Información general

| Campo                  | Información                                              |
| ---------------------- | -------------------------------------------------------- |
| **Fecha**              | 11/11/2026                                               |
| **Herramienta**        | Claude                                                   |
| **Etapa del proyecto** | Entrega 3                                                |
| **Componente**         | DML y datos de prueba                                    |
| **Responsable**        | Miguel                                                   |

## 1. Objetivo del prompt

Revisar la estrategia de datos de prueba que el equipo había planteado, para que los reportes tuvieran casos límite y no solo datos que confirmaran el resultado esperado. La IA no generó los inserts.

## 2. Prompt utilizado

```text
Te describo los datos que planeamos cargar para los reportes. No generes inserts ni tablas; solo dime qué casos límite nos pueden faltar para que las consultas prueben algo de verdad:

- Al menos 10 registros por reporte.
- Clientes, sedes, eventos, reseñas, favoritos y visitas.
- Queremos probar LEFT JOIN, promedios y empates.

¿Qué casos deberíamos incluir?
```

## 3. Resultado obtenido

* Sugirió incluir reseñas de clientes que no marcaron la sede como favorita.
* Recomendó ceros, nulos, empates y eventos sin reseñas.
* Advirtió que si todos los datos apuntan al mismo resultado, las consultas no demuestran nada.
* No propuso valores concretos ni generó filas.

## 4. Uso de la respuesta

* El equipo incluyó los casos límite en el DML que ya estaba escribiendo.
* Se corrigió el sesgo de SED01, donde todas las reseñas venían de clientes que la tenían como favorita.
* Se mantuvieron 1080 filas, todas redactadas por el equipo.
* No se copió ningún insert de la respuesta.

## 5. Modificaciones realizadas por el equipo

Miguel ajustó los datos y verificó que cada reporte tuviera al menos 10 filas. La IA solo aportó la lista de casos por revisar.

## 6. Validación

Se contaron las filas por reporte, se revisaron las FK y se ejecutó el DML en Oracle 11g XE.

## 7. Resultado final

DML de 1080 filas con casos límite, escrito y validado por el equipo.

---

# Prompt No. 08

## Información general

| Campo                  | Información                                              |
| ---------------------- | -------------------------------------------------------- |
| **Fecha**              | 18/11/2026                                               |
| **Herramienta**        | Claude                                                   |
| **Etapa del proyecto** | Entrega 3                                                |
| **Componente**         | DQL y reportes                                           |
| **Responsable**        | Jhoan                                                    |

## 1. Objetivo del prompt

Resolver dudas puntuales sobre `ROWNUM`, `COUNT` y uniones que inflaban los conteos. La IA no escribió las consultas.

## 2. Prompt utilizado

```text
Tengo tres dudas de Oracle 11g. No me escribas las consultas, solo explícame:

1. ¿Cómo se evalúa ROWNUM cuando se combina con ORDER BY?
2. ¿Cuál es la diferencia entre COUNT(*) y COUNT(columna) cuando hay LEFT JOIN?
3. Si uno reseñas con géneros directamente, ¿por qué se inflan los conteos y cómo se evita?
```

## 3. Resultado obtenido

* Explicó que `ROWNUM` se aplica antes del `ORDER BY` si van en la misma consulta, por lo que hay que ordenar en una subconsulta.
* Confirmó que `COUNT(*)` cuenta filas y `COUNT(columna)` ignora los `NULL`, útil para mostrar 0 en un `LEFT JOIN`.
* Explicó el efecto de multiplicar filas al unir reseñas con géneros y recomendó agregar antes de unir.

## 4. Uso de la respuesta

* Jhoan escribió las 7 consultas y aplicó `ROWNUM` dentro de una subconsulta para Q5 y Q7.
* En Q3 se usó `COUNT(f.CLIENT_id)` en vez de `COUNT(*)`.
* En Q7 se agregaron las reseñas en un bloque aparte antes del join con géneros.
* No se copió ninguna consulta de la respuesta.

## 5. Modificaciones realizadas por el equipo

Las consultas, los comentarios en lenguaje natural y los filtros los escribió el equipo. La IA solo explicó los conceptos.

## 6. Validación

Se compararon los resultados esperados (14, 15, 12, 14, 10, 14 y 10 filas) con la ejecución real en Oracle 11g XE.

## 7. Resultado final

7 consultas para R1, R2 y R3, escritas y probadas por el equipo.

---

# Prompt No. 09

## Información general

| Campo                  | Información                                              |
| ---------------------- | -------------------------------------------------------- |
| **Fecha**              | 18/11/2026                                               |
| **Herramienta**        | Claude                                                   |
| **Etapa del proyecto** | Entrega 3                                                |
| **Componente**         | PL/SQL                                                   |
| **Responsable**        | Miguel                                                   |

## 1. Objetivo del prompt

Revisar las decisiones de diseño de la función, el procedimiento y el trigger antes de escribirlos. La IA no redactó el código PL/SQL.

## 2. Prompt utilizado

```text
Estas son las decisiones que tomamos para el PL/SQL. No escribas el código; solo dime si ves un problema de lógica o una alternativa mejor:

- La función devuelve el promedio de reseñas de una sede.
- El procedimiento registra una actualización de aforo o cover.
- El trigger valida que la actualización la haga el dueño o un admin activo.
- Los ids del historial se generan con una secuencia.

¿Qué riesgos ves?
```

## 3. Resultado obtenido

* Recomendó que la función devolviera `NULL` y no 0 cuando la sede no tuviera reseñas.
* Advirtió que la autorización debía cubrir también los inserts directos, no solo los que pasan por el procedimiento.
* Confirmó que una secuencia evita choques frente a `MAX(id) + 1`.
* Sugirió parámetros tipados y SQL estático para evitar inyección.

## 4. Uso de la respuesta

* Miguel movió la autorización al trigger para cubrir inserts directos.
* La función devuelve `NULL` cuando no hay reseñas.
* Se agregó la secuencia `RUMBEA_UPDATE_SEQ`.
* El procedimiento y el trigger los escribió el equipo.

## 5. Modificaciones realizadas por el equipo

El PL/SQL completo y las 24 pruebas los escribió Miguel, con revisión de los otros dos integrantes. La IA no generó código.

## 6. Validación

Compilación sin errores y ejecución de las 24 pruebas en Oracle 11g XE: `24 correctas, 0 fallidas`.

## 7. Resultado final

Función, procedimiento, trigger y secuencia documentados, escritos y probados por el equipo.

---

# Prompt No. 10

## Información general

| Campo                  | Información                                              |
| ---------------------- | -------------------------------------------------------- |
| **Fecha**              | 20/11/2026                                               |
| **Herramienta**        | Claude                                                   |
| **Etapa del proyecto** | Entrega 3                                                |
| **Componente**         | Documentación, riesgos y entorno                         |
| **Responsable**        | Juan Pablo                                               |

## 1. Objetivo del prompt

Revisar el borrador del documento de riesgos, la guía de ejecución y la decisión del entorno. La IA no redactó los documentos.

## 2. Prompt utilizado

```text
Revisa este borrador del documento de riesgos de IAg. No agregues riesgos inventados ni cambies el sentido; solo dime si la redacción es clara y si falta algún control:

[ fragmento del borrador ]
```

```text
No tenemos acceso al servidor Oracle de la universidad. ¿Es viable usar Oracle 11g XE en Docker para ejecutar el DDL, el DML, el PL/SQL y las pruebas? No escribas la guía, solo dime qué deberíamos verificar.
```

## 3. Resultado obtenido

* Sugirió ordenar la matriz por probabilidad e impacto y redactar los controles como acciones concretas.
* Señaló que la validación local no equivale al servidor de la universidad y que había que guardar evidencia de la ejecución real.
* Confirmó que Oracle 11g XE en Docker era viable para el alcance del proyecto.
* No agregó riesgos nuevos ni redactó el documento.

## 4. Uso de la respuesta

* El equipo escribió la matriz de 12 riesgos y sus controles.
* Se adoptó Docker con Oracle 11g XE como entorno oficial de pruebas.
* Se guardó la salida de `ejecutar_todo.sql` como evidencia.
* La guía de ejecución la escribió el equipo.

## 5. Modificaciones realizadas por el equipo

Juan Pablo y Jhoan redactaron el documento de riesgos y la guía. Miguel preparó la evidencia. La IA solo revisó y respondió dudas.

## 6. Validación

La ejecución completa se hizo en Oracle 11g XE y quedó registrada en [la evidencia](./evidencias/ejecucion_oracle11g.txt).

## 7. Resultado final

Documento de riesgos, guía de ejecución y evidencia listos, con autoría del equipo.

---

# Consideraciones generales sobre el uso de IA

En la Entrega 3 la IA se usó como apoyo de consulta y revisión: aportó ideas, ayudó a precisar el alcance, resolvió dudas puntuales y revisó fragmentos ya escritos por el equipo. No redactó los artefactos ni tomó decisiones de diseño.

En todas las entregas la inteligencia artificial tuvo un papel marginal y consultivo. Todo el trabajo central fue humano:

* El caso de estudio, las 20 historias de usuario, el MER y el MR fueron diseñados por el equipo en Oracle SQL Developer Data Modeler.
* La normalización hasta 3FN, las PK/FK y la restricción de `BRANCH_UPDATE` las definimos nosotros discutiendo en las reuniones.
* El DDL, el DML, el DQL, el PL/SQL y los datos de prueba los escribió y probó el equipo.
* La organización del repositorio, los commits, el README y las actas los hicimos manualmente.

Cada respuesta de IA fue revisada y, en la mayoría de los casos, descartada casi por completo. Solo se aprovecharon correcciones de ortografía, explicaciones conceptuales cortas, sintaxis de Markdown y observaciones puntuales de revisión. Ningún diagrama, script o documento fue generado por IA.

El registro anterior permite evidenciar la trazabilidad y diferenciar entre las sugerencias puntuales de la IA y las decisiones finales tomadas por el equipo.
