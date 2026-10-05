# SID-RUMBEA

## Registro de uso de Inteligencia Artificial

Este documento registra los prompts utilizados como apoyo durante el desarrollo del proyecto **SID-RUMBEA**, indicando el propósito de cada consulta, la herramienta utilizada y el tratamiento realizado sobre las respuestas obtenidas.

El proyecto fue desarrollado de forma manual por el equipo: caso de estudio, historias de usuario, modelo entidad-relación (MER), modelo relacional (MR) y organización del repositorio fueron elaboración propia en Oracle Data Modeler y GitHub. La IA se usó únicamente como apoyo puntual para revisar redacción, resolver dudas conceptuales pequeñas y ayudar con formato Markdown. Ningún artefacto fue generado por IA.

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

Devuelvió el ejemplo básico con `| | |` y los `---`, y cómo alinear con `:---:`.

```text
| col1 | col2 | col3 |
| :--- | :--- | :--- |
```

## 4. Uso de la respuesta

* Se usó solo para formato.
* Todo el contenido del README (descripción, integrantes, estados, estructura de carpetas) lo escribimos nosotros.

## 5. Modificaciones realizadas por el equipo

Copiamos solo la estructura de la tabla y la llenamos con nuestra información. Tuvimos que arreglar a mano varias filas porque se nos movían las columnas al hacer push.

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

# Consideraciones generales sobre el uso de IA

La inteligencia artificial fue utilizada de forma mínima y solo como apoyo. Todo el trabajo central fue humano:

* El caso de estudio, las 20 historias de usuario, el MER y el MR fueron diseñados por el equipo en Oracle SQL Developer Data Modeler.
* La normalización hasta 3FN, las PK/FK y la restricción de `BRANCH_UPDATE` las definimos nosotros discutiendo en las reuniones.
* La organización del repositorio, los commits y el README los hicimos manualmente.

Cada respuesta de IA fue revisada y en la mayoría de los casos descartada casi por completo. Solo se aprovecharon correcciones de ortografía, explicaciones conceptuales cortas y sintaxis de Markdown. Ningún diagrama, código o documento fue generado por IA.

El registro anterior permite evidenciar la trazabilidad y diferenciar entre las sugerencias puntuales de la IA y las decisiones finales tomadas por el equipo.
