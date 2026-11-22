# SID-RUMBEA

## Ajustes al caso de estudio — Entrega 3

Este documento complementa [`CasoDeEstudio.pdf`](./CasoDeEstudio.pdf). Las retroalimentaciones del MER y del MR agregaron al modelo datos que el caso original no describía: el horario por día, las visitas al perfil y los recordatorios de eventos. Además, el PDF no incluía los reportes de la Entrega 0. Aquí se dejan por escrito para que el caso, el modelo y la implementación coincidan.

## 1. Ajustes a la descripción del caso

* **Horario.** Cada sede tiene un horario por día de la semana, con hora de apertura y de cierre. El cierre puede ser al día siguiente (por ejemplo, 20:00 a 03:00). Una sede tiene como máximo un horario por día.
* **Tipo de establecimiento.** El tipo (discoteca, bar, taberna o terraza) se define para cada sede, no para el establecimiento general. Una sede tiene un solo tipo.
* **Visitas al perfil.** Cada vez que un cliente abre el perfil de una sede se registra la fecha, la hora del acceso y el tiempo que permaneció en él. Un cliente puede visitar muchas veces el perfil de una misma sede.
* **Recordar evento.** Un cliente puede activar "recordar evento" en cero o varios eventos, y un evento puede ser recordado por cero o varios clientes. Se registra la fecha en que se activó. Un cliente activa el recordatorio de un evento una sola vez.
* **Estado del administrador.** Es un valor booleano. En la base se guarda como `ACTIVO` o `INACTIVO`, y un CHECK solo permite esos dos valores.
* **Administrador creado por un dueño.** No se guarda como un dato aparte, porque se deduce: el dueño es el del establecimiento al que pertenece la sede del administrador.

## 2. Nuevas historias de usuario

**Módulo 2: Establecimientos y sedes**

HU21. Como dueño quiero registrar el horario de cada sede por día para que los clientes sepan cuándo está abierta.
* Datos necesarios: horario de sede (día de la semana, hora de apertura, hora de cierre, sede asociada — tabla `BRANCH_SCHEDULE`).

**Módulo 8: Actividad de los perfiles**

HU22. Como administrador quiero ver cuántas veces y cuánto tiempo visitan los clientes el perfil de mi sede para medir el interés que genera.
* Datos necesarios: visita al perfil (cliente asociado, sede asociada, fecha, hora de acceso, tiempo de interacción en segundos — tabla `VISIT_PROFILE`).

**Módulo 7: Eventos**

HU23. Como cliente quiero activar "recordar evento" en un evento para que la app me avise antes de que empiece.
* Datos necesarios: recordatorio (cliente asociado, evento asociado, fecha de activación — tabla `CLIENT_EVENT_REMINDER`).

Con esto quedan **23 historias de usuario en 8 módulos**.

## 3. Reportes del sistema (Entrega 0)

| Reporte | Actor | Contenido | Datos que lo soportan | Consultas |
| --- | --- | --- | --- | --- |
| R1. Actividad del establecimiento asignado | Administrador | Historial diario de accesos al perfil de su sede (cantidad, clientes distintos, tiempo promedio) y reseñas de los clientes | `VISIT_PROFILES`, `REVIEWS`, `FAVORITES` | Q1, Q2 |
| R2. Popularidad de establecimientos y eventos | Dueño | Establecimientos y sedes ordenados por favoritos, y número de clientes que activaron "recordar evento" en cada evento | `FAVORITES`, `CLIENT_EVENT_REMINDERS`, `BRANCH_EVENTS` | Q3, Q4, Q5 |
| R3. Consulta filtrada de establecimientos | Cliente | Sedes filtradas por tipo y género musical, y recomendación según sus preferencias | `BRANCH_TYPES`, `BRANCH_MUSIC_GENRES`, `CLIENT_MUSIC_PREFERENCES`, `REVIEWS` | Q6, Q7 |

Las consultas están en [`src/DQL/rumbea_dql.sql`](../src/DQL/rumbea_dql.sql).
