# SID-RUMBEA

## Reportes y decisiones de la Entrega 3

## 1. Reportes propuestos en la Entrega 0

| Reporte | Actor | Qué pedía |
| --- | --- | --- |
| **R1. Actividad del establecimiento asignado** | Administrador | Historial de accesos diarios al perfil y reseñas de los clientes. |
| **R2. Popularidad de establecimientos y eventos** | Dueño | Establecimientos ordenados por favoritos y conteo de usuarios que activaron "recordar evento" en cada evento. |
| **R3. Consulta filtrada de establecimientos** | Cliente | Establecimientos filtrados por tipo y género musical predominante. |

## 2. Consultas que los resuelven

| Consulta | Reporte | Qué responde | Parámetro de ejemplo | Filas esperadas |
| --- | --- | --- | --- | ---: |
| Q1 | R1 | Accesos, clientes distintos y tiempo promedio por día | `ADM01` | 14 |
| Q2 | R1 | Reseñas de la sede | `ADM01` | 15 |
| Q3 | R2 | Establecimientos por favoritos | `OWN01` | 12 |
| Q4 | R2 | Eventos por recordatorios ("recordar evento") | `OWN01` | 14 |
| Q5 | R2 | TOP 10 sedes por favoritos | `OWN01` | 10 |
| Q6 | R3 | Sedes por tipo y género | Discoteca, Reggaeton | 14 |
| Q7 | R3 | TOP 10 sedes según preferencias | `CLI001` | 10 |

Código: [rumbea_dql.sql](../src/DQL/rumbea_dql.sql).

## 3. Correcciones al modelo después de la revisión

En la primera versión de la Entrega 3 se decidió no cambiar el modelo, y eso dejaba R1 y R2 incompletos. En la revisión final se aplicaron los cambios, marcados con `[E3-R]` en el código:

1. **"Recordar evento" ahora se guarda (R2).** La nueva tabla `CLIENT_EVENT_REMINDERS (CLIENT_id, EVENT_id, reminderDate)` registra qué cliente activó el recordatorio de cada evento. Q4 cuenta recordatorios reales y ya no es una aproximación por favoritos.
2. **El historial de accesos es completo (R1).** `VISIT_PROFILES` tiene PK propia (`id`), así que un cliente puede visitar el perfil de una sede muchas veces, y guarda `interactionSeconds`, el tiempo de interacción que pidió el profesor en la retroalimentación del MER. Q1 muestra accesos, clientes distintos y tiempo promedio por día.
3. **No se sabe cuál género predomina (R3).** Esto se mantiene: Q6 filtra por género asociado a la sede, como dice la HU12.

Los ajustes al caso de estudio (HU21 a HU23 y los reportes) están en [ajustes al caso de estudio](./caso_estudio_ajustes_entrega3.md), y la normalización actualizada en [normalización Entrega 3](./normalizacion_entrega3.md).

## 4. Restricciones agregadas en el DDL

En [rumbea_ddl.sql](../src/DDL/rumbea_ddl.sql) están marcadas con `[E3]` (primera versión) y `[E3-R]` (revisión final).

| Restricción | Regla de negocio |
| --- | --- |
| `BRANCHS_CAPACITY_CK` | El aforo no es negativo. |
| `BRANCHS_COVER_CK` | El cover no es negativo y puede ser 0. |
| `BRANCH_UPDATES_CAPACITY_CK` | El nuevo aforo no es negativo. |
| `BRANCH_UPDATES_COVER_CK` | El nuevo cover no es negativo. |
| `EVENTS_SPECIAL_COVER_CK` | El cover especial no es negativo. |
| `REVIEWS_RATING_CK` | La calificación va de 1 a 5. |
| `BRANCH_TYPES__UN` | Una sede tiene un solo tipo. |
| `BRANCH_SCHEDULES_DAY_UN` | Una sede tiene un solo horario por día. |
| `ADMINS_STATE_CK` `[E3-R]` | El estado del administrador solo es `ACTIVO` o `INACTIVO` (booleano del caso). |
| `VISIT_PROFILES_TIME_CK` `[E3-R]` | La hora de acceso es válida (0000 a 2359, minutos menores a 60). |
| `VISIT_PROFILES_SECONDS_CK` `[E3-R]` | El tiempo de interacción es mayor que cero. |
| `CLIENT_EVENT_REMINDER_PK` `[E3-R]` | Un cliente recuerda un evento una sola vez. |

## 5. Reglas y dónde se garantizan

| Regla del caso | Mecanismo |
| --- | --- |
| Roles excluyentes | `CHECK` de `role` y FK compuesta `(id, role)` |
| Un admin por sede como máximo | `UNIQUE (BRANCH_id)` en `ADMINS` |
| Actualización hecha por dueño o admin, no por ambos | `CHECK` del arco y trigger |
| Solo actualiza el dueño de la sede o su admin activo | Trigger |
| La sede refleja la última actualización | Trigger |
| Evento solo en sedes del mismo establecimiento | Dos FK compuestas en `BRANCH_EVENTS` |
| Un cliente puede visitar muchas veces un perfil | PK propia en `VISIT_PROFILES` |
| Estado del administrador booleano | `CHECK` de `stateActive` |
| Dueño con al menos un establecimiento, establecimiento con al menos una sede, evento con al menos una sede | No son declarables con FK. Los datos de prueba las cumplen y la aplicación debe validarlas. |
| Todo usuario tiene su fila de subtipo (especialización total) | No es declarable con FK. Los datos de prueba la cumplen. |

## 6. Puntos conocidos del modelo

- **`BRANCH_EVENTS.ESTABLISHMENT_id` es redundancia controlada.** Depende de cada parte de la PK por separado, por lo que estrictamente no cumple 2FN. Se mantiene para declarar con FK que sede y evento son del mismo establecimiento, y esas mismas FK impiden que el valor quede inconsistente. Está justificada en la sección 4 de la [normalización](./normalizacion_entrega3.md).
- **`visitTimeIn` es `INTEGER`.** Se guarda como HH24MI: `2130` es 21:30. Un CHECK valida que sea una hora real. El tiempo de interacción va aparte, en `interactionSeconds`.
- **`stateActive` es texto.** Representa el booleano del caso con los valores `ACTIVO` e `INACTIVO`, garantizados por `ADMINS_STATE_CK`.
- **`password` admite 50 caracteres.** Un hash bcrypt ocupa 60, así que habría que ampliarla en producción. Los datos de prueba usan valores ficticios.
- **`"date"` es palabra reservada.** Siempre se escribe entre comillas dobles y en minúscula.
- **Compatibilidad con 11g.** Por eso el TOP usa `ROWNUM` y los identificadores no pasan de 30 caracteres.
