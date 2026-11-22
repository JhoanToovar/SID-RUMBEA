# SID-RUMBEA

## Acta de Reunión No. 08

| Campo               | Información                                      |
| ------------------- | ------------------------------------------------ |
| **Proyecto**        | SID-RUMBEA                                       |
| **Reunión**         | Consultas DQL y elementos de PL/SQL              |
| **Fecha**           | Miércoles 18 de noviembre de 2026                |
| **Hora**            | 4:00 p. m.                                       |
| **Lugar**           | CAMBAS, Universidad Icesi                        |
| **Asistentes**      | Jhoan, Juan Pablo, Miguel                        |
| **Próxima reunión** | Viernes 20 de noviembre de 2026                  |

## 1. Objetivo de la reunión

Definir las siete consultas que resuelven los tres reportes y los tres elementos de PL/SQL (función, procedimiento y trigger), junto con sus reglas y pruebas.

## 2. Agenda

1. Mapa de consultas por reporte.
2. Técnicas requeridas: joins, agrupamiento, ordenamiento y TOP.
3. Función de promedio.
4. Procedimiento y trigger de actualización.
5. Casos de prueba.
6. Compromisos.

## 3. Desarrollo de la reunión

Nos reunimos en el CAMBAS a las 4, con el portátil de Miguel y el MR abierto al lado. La idea era no salir sin el mapa completo de consultas y sin el flujo del PL/SQL.

Sobre DQL, definimos siete consultas para los tres reportes. Q1 y Q2 son de R1 (actividad del establecimiento asignado); Q3, Q4 y Q5 de R2 (popularidad de establecimientos y eventos); y Q6 y Q7 de R3 (consulta filtrada de establecimientos). Cada una lleva su descripción en lenguaje natural como comentario, y arriba un bloque de parámetros para no repetir el id del admin, del dueño o del cliente en toda la consulta.

Repasamos las técnicas que pedía el enunciado: `INNER JOIN`, `LEFT OUTER JOIN`, `GROUP BY`, `ORDER BY` y al menos un TOP. Como Oracle 11g no tiene `FETCH FIRST`, el TOP de Q5 y Q7 se hace con `ROWNUM`, pero ordenando primero en una subconsulta; si se pone `ROWNUM` antes del `ORDER BY`, Oracle toma diez filas cualesquiera y luego las ordena, que es un error clásico. También discutimos Q3: hay que usar `COUNT(f.CLIENT_id)` y no `COUNT(*)`, porque con `COUNT(*)` un establecimiento sin favoritos mostraría 1 en vez de 0.

En Q4 volvimos a lo de la audiencia potencial y en Q7 cuidamos de agregar las reseñas en un bloque aparte antes de unirlas con los géneros. Si se unen directamente, cada reseña se cuenta una vez por cada género que coincida y los promedios salen mal. Eso lo dejamos comentado en el script para que no se nos olvide.

En PL/SQL definimos tres objetos. La función `FN_RUMBEA_PROMEDIO_SEDE` recibe el id de una sede y devuelve el promedio de estrellas redondeado a dos decimales, o `NULL` si no tiene reseñas. Decidimos que devuelva `NULL` y no 0, porque un 0 se leería como una calificación malísima. El procedimiento `PR_RUMBEA_ACTUALIZAR_SEDE` registra un cambio de aforo, cover, descripción o dirección; usa parámetros tipados y SQL estático, nada de SQL dinámico. El trigger `TRG_RUMBEA_BRANCH_UPDATE` se dispara antes de insertar en `BRANCH_UPDATES`, valida que haya exactamente un autor (dueño o administrador, nunca los dos), que el dueño sea del establecimiento de la sede y que el administrador esté activo y asignado, y luego aplica el cambio en `BRANCHS`.

Discutimos si la autorización debía ir en el procedimiento o en el trigger. La conclusión fue que va en el trigger, porque así también se cumple si alguien inserta directo en la tabla sin pasar por el procedimiento. El procedimiento queda como la forma cómoda de hacerlo, pero la regla vive en el trigger.

También agregamos una secuencia `RUMBEA_UPDATE_SEQ` para generar los ids `BUP...` del historial, en vez de hacer `MAX(id) + 1`, que se puede chocar si dos sesiones insertan al mismo tiempo.

Al final armamos la lista de pruebas: 3 de la función, 5 de casos válidos del procedimiento y el trigger, 9 de casos rechazados y 7 de restricciones del DDL. En total 24. La idea es que cada caso tenga un resultado esperado y que el script muestre `[OK]` o `[FALLA]`, no que uno mire a ojo si funcionó.

## 4. Dificultades identificadas

* El TOP en Oracle 11g obliga a usar `ROWNUM` y a ordenar dentro de una subconsulta.
* Unir reseñas y géneros directamente infla los conteos; hay que agregar antes de unir.
* La diferencia entre `NULL` y 0 en el promedio no era obvia al principio.
* El flujo procedimiento → insert → trigger → update de la sede nos enredó un rato; tocó dibujarlo en el tablero.

## 5. Acuerdos y compromisos

| Responsable    | Compromiso                                                              | Fecha límite            |
| -------------- | ----------------------------------------------------------------------- | ----------------------- |
| **Miguel**     | Cerrar el script PL/SQL y el script de 24 pruebas.                      | 20 de noviembre de 2026 |
| **Jhoan**      | Cerrar las 7 consultas y sus comentarios en lenguaje natural.           | 20 de noviembre de 2026 |
| **Juan Pablo** | Revisar que las consultas y el trigger correspondan al MR y a las HU.   | 20 de noviembre de 2026 |
| **Los tres**   | Probar en Oracle real, no solo revisar la sintaxis.                     | 21 de noviembre de 2026 |

## 6. Aspectos definidos

* Mapa de 7 consultas para R1, R2 y R3.
* Uso de `INNER JOIN`, `LEFT OUTER JOIN`, `GROUP BY`, `ORDER BY` y `ROWNUM` para el TOP.
* Función de promedio con `NULL` cuando no hay reseñas.
* Procedimiento de actualización con parámetros tipados.
* Trigger con la autorización y la aplicación del cambio.
* Secuencia para los ids del historial.
* Matriz de 24 pruebas.

## 7. Resultado

Quedaron definidas las consultas y el PL/SQL, con las reglas y los casos de prueba. Nos faltaba ejecutarlo todo en Oracle y cerrar la documentación, pero el diseño ya estaba completo y revisado contra el MR.

## 8. Próxima reunión

El viernes 20 de noviembre de 2026, de forma virtual, para revisar los riesgos de IAg, la documentación y el ensayo de la sustentación.
