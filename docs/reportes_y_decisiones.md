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
| Q1 | R1 | Accesos por día | `ADM01` | 14 |
| Q2 | R1 | Reseñas de la sede | `ADM01` | 15 |
| Q3 | R2 | Establecimientos por favoritos | `OWN01` | 12 |
| Q4 | R2 | Eventos por audiencia potencial | `OWN01` | 14 |
| Q5 | R2 | TOP 10 sedes por favoritos | `OWN01` | 10 |
| Q6 | R3 | Sedes por tipo y género | Discoteca, Reggaeton | 14 |
| Q7 | R3 | TOP 10 sedes según preferencias | `CLI001` | 10 |

Código: [rumbea_dql.sql](../src/DQL/rumbea_dql.sql).

## 3. Ajustes por decisión de mantener el modelo

Se decidió implementar el MR sin agregar ni cambiar tablas o columnas. Esto tiene tres consecuencias:

1. **"Recordar evento" no se puede contar (R2).** El MR no guarda ese dato. Q4 muestra la *audiencia potencial*: clientes distintos que tienen como favorita alguna sede del evento. **No es lo mismo** que un recordatorio. Una versión futura necesitaría una relación cliente–evento.
2. **El historial de accesos es parcial (R1).** La PK de `VISIT_PROFILES` es (cliente, sede), así que cada cliente aparece una sola vez por sede. Q1 cuenta esos registros por día. Una versión futura necesitaría una PK propia por acceso.
3. **No se sabe cuál género predomina (R3).** Q6 filtra por género asociado a la sede, como dice la HU12.

## 4. Restricciones agregadas en el DDL

No cambian tablas ni columnas. En [rumbea_ddl.sql](../src/DDL/rumbea_ddl.sql) están marcadas con `[E3]`.

| Restricción | Regla de negocio |
| --- | --- |
| `BRANCHS_CAPACITY_CK` | El aforo no es negativo. |
| `BRANCHS_COVER_CK` | El cover no es negativo y puede ser 0. |
| `BRANCH_UPDATES_CAPACITY_CK` | El nuevo aforo no es negativo. |
| `BRANCH_UPDATES_COVER_CK` | El nuevo cover no es negativo. |
| `EVENTS_SPECIAL_COVER_CK` | El cover especial no es negativo. |
| `REVIEWS_RATING_CK` | La calificación va de 1 a 5. |
| `BRANCH_TYPES_BRANCH_UN` | Una sede tiene un solo tipo. |
| `BRANCH_SCHEDULES_DAY_UN` | Una sede tiene un solo horario por día. |

## 5. Reglas y dónde se garantizan

| Regla del caso | Mecanismo |
| --- | --- |
| Roles excluyentes | `CHECK` de `role` y FK compuesta `(id, role)` |
| Un admin por sede como máximo | `UNIQUE (BRANCH_id)` en `ADMINS` |
| Actualización hecha por dueño o admin, no por ambos | `CHECK` del arco y trigger |
| Solo actualiza el dueño de la sede o su admin activo | Trigger |
| La sede refleja la última actualización | Trigger |
| Evento solo en sedes del mismo establecimiento | Dos FK compuestas en `BRANCH_EVENTS` |
| Dueño con al menos un establecimiento, establecimiento con al menos una sede, evento con al menos una sede | No son declarables con FK. Los datos de prueba las cumplen y la aplicación debe validarlas. |
| Todo usuario tiene su fila de subtipo (especialización total) | No es declarable con FK. Los datos de prueba la cumplen. |

## 6. Puntos conocidos del modelo

- **`BRANCH_EVENTS.ESTABLISHMENT_id` es redundancia controlada.** Depende de cada parte de la PK por separado, por lo que estrictamente no cumple 2FN. Se mantiene para declarar con FK que sede y evento son del mismo establecimiento, y esas mismas FK impiden que el valor quede inconsistente.
- **`visitTimeIn` es `INTEGER`.** Se guarda como HH24MI: `2130` es 21:30.
- **`stateActive` es texto.** Se usan los valores `ACTIVO` e `INACTIVO`.
- **`password` admite 50 caracteres.** Un hash bcrypt ocupa 60, así que habría que ampliarla en producción. Los datos de prueba usan valores ficticios.
- **`"date"` es palabra reservada.** Siempre se escribe entre comillas dobles y en minúscula.
- **Compatibilidad con 11g.** Por eso el TOP usa `ROWNUM` y los identificadores no pasan de 30 caracteres.
