# SID-RUMBEA

## Normalización del Modelo Relacional — Entrega 3

Este documento actualiza `model/relacional/DFNormYRelaciones.pdf` (Entrega 2) al modelo que se implementa en [`src/DDL/rumbea_ddl.sql`](../src/DDL/rumbea_ddl.sql). Después de la Entrega 2 el modelo cambió por la retroalimentación del profesor: nuevas PK en `REVIEWS`, `BRANCH_UPDATES` y `VISIT_PROFILES`, el tipo pasó de establecimiento a sede, se agregó el rol a los usuarios, el evento quedó asociado a un establecimiento y se agregó la tabla de recordatorios. Por eso las dependencias funcionales (DF) de la Entrega 2 ya no describen el modelo.

**Resultado:** las 19 tablas cumplen 3FN, excepto `BRANCH_EVENTS`, que tiene una desnormalización controlada y justificada (sección 4).

---

## 1. Dependencias funcionales

| Tabla | Dependencias funcionales | Claves candidatas |
| --- | --- | --- |
| USERS | id → name, email, password, phoneNumber, creationDate, role · email → id | {id}, {email} |
| CLIENTS | id → role (role es constante: `CLIENT`) | {id} |
| ESTABLISHMENT_OWNERS | id → role (constante: `OWNER`) | {id} |
| ADMINS | id → stateActive, lastConnectionDate, BRANCH_id, role · BRANCH_id → id | {id}, {BRANCH_id} |
| ESTABLISHMENTS | id → name, ESTABLISHMENT_OWNER_id | {id} |
| BRANCHS | id → suffix, location, description, capacity, cover, ESTABLISHMENT_id | {id} |
| BRANCH_TYPES | id → type, BRANCH_id · BRANCH_id → id | {id}, {BRANCH_id} |
| BRANCH_SCHEDULES | id → dayOfWeek, openTime, closeTime, BRANCH_id · {BRANCH_id, dayOfWeek} → id | {id}, {BRANCH_id, dayOfWeek} |
| LINK_OF_INTERESTS | id → name, link, BRANCH_id | {id} |
| BRANCH_UPDATES | id → date, newCapacity, newCover, newDescription, newLocation, BRANCH_id, ADMIN_id, ESTABLISHMENT_OWNER_id | {id} |
| MUSIC_GENRES | id → name · name → id | {id}, {name} |
| BRANCH_MUSIC_GENRES | solo la trivial | {BRANCH_id, MUSIC_GENRE_id} |
| CLIENT_MUSIC_PREFERENCES | solo la trivial | {CLIENT_id, MUSIC_GENRE_id} |
| EVENTS | id → name, realizationDate, description, specialCover, ESTABLISHMENT_id | {id} |
| BRANCH_EVENTS | BRANCH_id → ESTABLISHMENT_id · EVENT_id → ESTABLISHMENT_id | {BRANCH_id, EVENT_id} |
| FAVORITES | {CLIENT_id, BRANCH_id} → assignmentDate | {CLIENT_id, BRANCH_id} |
| REVIEWS | id → text, rating, date, BRANCH_id, CLIENT_id | {id} |
| VISIT_PROFILES | id → visitDate, visitTimeIn, interactionSeconds, CLIENT_id, BRANCH_id | {id} |
| CLIENT_EVENT_REMINDERS | {CLIENT_id, EVENT_id} → reminderDate | {CLIENT_id, EVENT_id} |

### Cambios frente a la Entrega 2

| Tabla | DF en la Entrega 2 | Por qué cambió |
| --- | --- | --- |
| REVIEWS | {CLIENT_id, BRANCH_id} → text, rating, date | Esa DF dice que un cliente reseña una sede una sola vez, y el caso dice que puede dejar muchas reseñas. El profesor lo marcó. Ahora la PK es `id`. |
| VISIT_PROFILES | {CLIENT_id, BRANCH_id} → visitDate, visitTimeIn | La DF era falsa por la misma razón: un cliente visita el perfil de una sede muchas veces. Ahora la PK es `id` y se agrega `interactionSeconds`, el tiempo de interacción pedido en la retroalimentación del MER. |
| BRANCH_UPDATES | PK {id, ADMIN_id, ESTABLISHMENT_OWNER_id} en el MR | La PK obligaba a registrar a los dos autores. Ahora la PK es `id`, y un CHECK de arco exige exactamente uno. |
| ESTABLISHMENT_TYPE → BRANCH_TYPES | id → type, ESTABLISHMENT_id | El caso define el tipo por sede. `BRANCH_id` es clave candidata (UNIQUE): una sede tiene un solo tipo. |
| BRANCH_SCHEDULES | PK {BRANCH_id, dayOfWeek} | Se usa `id` como PK simple (recomendación del profesor) y {BRANCH_id, dayOfWeek} queda como clave candidata (UNIQUE). |
| USERS y subtipos | sin `role` | `role` y la FK compuesta (id, role) garantizan que un usuario tenga un solo rol. |
| EVENTS | sin establecimiento | El evento pertenece a un establecimiento, para validar sus sedes. |
| BRANCH_EVENTS | solo la trivial | Se agregó `ESTABLISHMENT_id` (sección 4). |
| CLIENT_EVENT_REMINDERS | no existía | Guarda "recordar evento" del Reporte 2. |

## 2. Primera forma normal

Todas las tablas tienen atributos atómicos y ninguna guarda listas en una columna.

* La única descomposición sigue siendo la de la Entrega 2: `openingHours` de `BRANCH` pasó a `BRANCH_SCHEDULES` (un registro por sede y día).
* Los datos que podían ser multivaluados ya están en tablas aparte: géneros de una sede, gustos de un cliente, sedes de un evento, enlaces, favoritos, reseñas, visitas y recordatorios.
* `name`, `location` y `newLocation` se consideran atómicos porque el negocio los usa como un solo dato.
* `visitDate` (fecha) y `visitTimeIn` (hora HH24MI) son dos datos distintos, no una repetición.

**Resultado:** todas cumplen 1FN.

## 3. Segunda forma normal

Solo puede haber dependencia parcial en tablas con una clave candidata compuesta.

| Tabla | Clave compuesta | Atributos no clave | ¿Dependen de una parte? | Resultado |
| --- | --- | --- | --- | --- |
| BRANCH_SCHEDULES | {BRANCH_id, dayOfWeek} | openTime, closeTime | No: cada sede abre a horas distintas según el día | Cumple |
| BRANCH_MUSIC_GENRES | {BRANCH_id, MUSIC_GENRE_id} | ninguno | No aplica | Cumple |
| CLIENT_MUSIC_PREFERENCES | {CLIENT_id, MUSIC_GENRE_id} | ninguno | No aplica | Cumple |
| FAVORITES | {CLIENT_id, BRANCH_id} | assignmentDate | No: la fecha depende de la pareja | Cumple |
| CLIENT_EVENT_REMINDERS | {CLIENT_id, EVENT_id} | reminderDate | No: la fecha depende de la pareja | Cumple |
| BRANCH_EVENTS | {BRANCH_id, EVENT_id} | ESTABLISHMENT_id | **Sí:** BRANCH_id → ESTABLISHMENT_id | **No cumple (sección 4)** |

Las demás tablas tienen claves de un solo atributo y no pueden tener dependencias parciales.

## 4. Excepción justificada: `BRANCH_EVENTS`

**El problema.** El profesor pidió garantizar que un evento compartido se asocie solo a sedes de su mismo establecimiento. Con `BRANCH_EVENTS (BRANCH_id, EVENT_id)` las FK no lo impiden.

**La solución implementada.** Se agregó `ESTABLISHMENT_id` y dos FK compuestas:

* `(BRANCH_id, ESTABLISHMENT_id)` → `BRANCHS (id, ESTABLISHMENT_id)`
* `(EVENT_id, ESTABLISHMENT_id)` → `EVENTS (id, ESTABLISHMENT_id)`

Como la columna es la misma en las dos FK, la sede y el evento tienen que ser del mismo establecimiento.

**Por qué viola 2FN.** `ESTABLISHMENT_id` no es clave y depende de una sola parte de la PK (`BRANCH_id → ESTABLISHMENT_id`, y también `EVENT_id → ESTABLISHMENT_id`).

**Por qué se acepta.** Es una desnormalización controlada:

1. La anomalía típica de la 2FN es que el dato repetido quede inconsistente. Aquí no puede pasar: las dos FK rechazan cualquier valor que no coincida con la sede y con el evento.
2. La regla queda declarada en el esquema y se cumple siempre, incluso con un INSERT directo.
3. La alternativa en 2FN (quitar la columna y validar con un trigger) deja la regla fuera del esquema y depende de código.

**Versión estrictamente normalizada (si se exigiera):** `BRANCH_EVENTS (BRANCH_id, EVENT_id)`, más un trigger `BEFORE INSERT OR UPDATE` que compare `BRANCHS.ESTABLISHMENT_id` con `EVENTS.ESTABLISHMENT_id`.

## 5. Tercera forma normal

| Tabla | ¿Algún atributo no clave determina a otro no clave? | Resultado |
| --- | --- | --- |
| USERS | No. email → id no es transitiva porque email es clave candidata. | Cumple |
| CLIENTS / ESTABLISHMENT_OWNERS | No. Solo tienen `role`, que es constante. | Cumple |
| ADMINS | No. BRANCH_id → id no es transitiva porque BRANCH_id es clave candidata. | Cumple |
| ESTABLISHMENTS | No. Un dueño tiene varios establecimientos. | Cumple |
| BRANCHS | No. Cada atributo depende solo de la sede. | Cumple |
| BRANCH_TYPES | No. BRANCH_id es clave candidata. | Cumple |
| BRANCH_SCHEDULES | No. La hora de apertura no determina la de cierre. | Cumple |
| LINK_OF_INTERESTS | No. | Cumple |
| BRANCH_UPDATES | No. Los new* son independientes entre sí, y el autor no determina la sede. | Cumple |
| MUSIC_GENRES | No hay atributos no clave (name es clave candidata). | Cumple |
| EVENTS | No. | Cumple |
| FAVORITES / CLIENT_EVENT_REMINDERS | Un solo atributo no clave. | Cumple |
| REVIEWS | No. La calificación no determina el texto ni la fecha. | Cumple |
| VISIT_PROFILES | No. La fecha no determina la hora ni la duración. | Cumple |

### Puntos que se pueden preguntar en la sustentación

* **`BRANCHS.capacity` y `cover` frente a `BRANCH_UPDATES`.** No es una dependencia transitiva dentro de una tabla. `BRANCHS` guarda el estado actual y `BRANCH_UPDATES` el historial. El trigger `TRG_RUMBEA_BRANCH_UPDATE` mantiene ambos coherentes.
* **El administrador "creado por un dueño".** No se guarda como columna porque se deriva: ADMINS.BRANCH_id → BRANCHS.ESTABLISHMENT_id → ESTABLISHMENTS.ESTABLISHMENT_OWNER_id. Guardarlo en `ADMINS` crearía justamente una dependencia transitiva.
* **El rol en los subtipos.** `CLIENTS.role` es constante. Existe solo para la FK compuesta (id, role) que garantiza roles excluyentes, y no genera anomalías porque el CHECK no permite otro valor.

## 6. Junta sin pérdida y conservación de dependencias

Las tablas que cambiaron desde la Entrega 2 no se obtuvieron descomponiendo otras: cambiaron su PK o se agregaron. La única descomposición sigue siendo `BRANCH → BRANCH + BRANCH_SCHEDULES`.

| Paso | Resultado |
| --- | --- |
| R1 ∩ R2 | {BRANCH id} |
| ¿Es clave de R1? | Sí, es la PK de BRANCHS |
| Junta sin pérdida | Sí |
| Conservación de DF | Sí: id → (datos de sede) se valida en R1; {BRANCH_id, dayOfWeek} → openTime, closeTime se valida en R2 |

## 7. Diagnóstico final

| Tabla / grupo | Forma normal | Acción |
| --- | --- | --- |
| 18 tablas | 3FN | Ninguna |
| BRANCH_EVENTS | 1FN (no cumple 2FN por diseño) | Se mantiene como desnormalización controlada (sección 4) |
