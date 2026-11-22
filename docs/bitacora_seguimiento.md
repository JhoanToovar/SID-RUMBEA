# SID-RUMBEA

## Bitácora de seguimiento del proyecto

Registro consolidado del seguimiento. Cada entrada resume qué se cumplió, qué cambió, qué dificultades aparecieron y cómo se redistribuyeron las tareas. El detalle de cada sesión está en su acta correspondiente.

> Sobre el uso de IA: se consultó como apoyo para aportar ideas, revisar trabajo ya hecho, precisar especificaciones y resolver dudas puntuales. La autoría de los modelos, scripts y documentos es del equipo; la IA no generó artefactos.

| N.º | Fecha | Asistentes | Acta |
| --- | ----- | ---------- | ---- |
| 1 | Viernes 28 de agosto de 2026 | Jhoan, Juan Pablo | [Acta 1](./actas_de_reunion/acta_1.md) |
| 2 | Miércoles 2 de septiembre de 2026 | Jhoan, Juan Pablo | [Acta 2](./actas_de_reunion/acta_2.md) |
| 3 | Viernes 4 de septiembre de 2026 | Jhoan, Juan Pablo | [Acta 3](./actas_de_reunion/acta_3.md) |
| 4 | Jueves 1 de octubre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 4](./actas_de_reunion/acta_4.md) |
| 5 | Domingo 4 de octubre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 5](./actas_de_reunion/acta_5.md) |
| 6 | Miércoles 4 de noviembre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 6](./actas_de_reunion/acta_6.md) |
| 7 | Miércoles 11 de noviembre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 7](./actas_de_reunion/acta_7.md) |
| 8 | Miércoles 18 de noviembre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 8](./actas_de_reunion/acta_8.md) |
| 9 | Viernes 20 de noviembre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 9](./actas_de_reunion/acta_9.md) |
| 10 | Domingo 22 de noviembre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 10](./actas_de_reunion/acta_10.md) |

> Nota: en las sesiones 1-3 Miguel no asistió por cruce con parciales de otras materias; desde la sesión 4 se reintegra y participa en MR, repo y DDL base. Ver detalle en Acta 4. Las sesiones 6-10 corresponden a noviembre y cubren la planeación, el desarrollo y el cierre de la Entrega 3.

---

## Seguimiento 1 — 28/08/2026 — Replanteamiento del caso de estudio

**Qué se cumplió:**
* Revisión del caso inicial y de las historias de usuario existentes.

**Qué cambió:**
* Se descartó el caso inicial por ambiguo (mezclaba reglas de negocio con decisiones de modelado).
* Se acordó replantearlo desde cero dejando explícitas cardinalidades y opcionalidad.

**Dificultades:**
* Entidades y cardinalidades no se podían inferir del texto original.
* Hubo que reservar una sesión extra de corrección.

**Redistribución de tareas:**
* Juan Pablo: borrador del caso reformulado.
* Jhoan: validar el nuevo caso contra HUs.

## Seguimiento 2 — 02/09/2026 — Jerarquía de usuarios y arco

**Qué se cumplió:**
* Definición de roles cliente, propietario y administrador como mutuamente excluyentes (especialización total).

**Qué cambió:**
* Se agregó la entidad `BRANCH_UPDATE` con arco: cada actualización la hace exactamente un dueño o exactamente un administrador, nunca ambos.

**Dificultades:**
* Configuración del arco y columna discriminadora en Oracle Data Modeler.

**Redistribución de tareas:**
* Pendiente formal de esta sesión: no quedó tabla de responsables con fecha en el acta (se retoma en Seguimiento 3). Juan Pablo asumió el ajuste en Data Modeler y Jhoan la validación contra HU8.

## Seguimiento 3 — 04/09/2026 — Validación del MER

**Qué se cumplió:**
* Validación de entidades, atributos, relaciones M:N con intermedias, jerarquía y arco `BRANCH_UPDATE`.
* Corrección de tipos de datos en Data Modeler.

**Qué cambió:**
* Ajustes menores de tipos y validación del caso corregido contra el MER para Entrega 0/1.

**Dificultades:**
* Tipos de datos inconsistentes heredados del MER inicial.

**Redistribución de tareas:**
* Jhoan: finalizar HUs y acuerdos (límite 08/09/2026).
* Juan Pablo: exportar DDL y verificar errores del modelo (límite 09/09/2026).
* Ambos: revisión completa del documento (límite 10/09/2026).

## Seguimiento 4 — 01/10/2026 — Definición del MR

**Qué se cumplió:**
* Generación del MR con `Engineer to Relational Model` y revisión tabla por tabla.
* Definición de PK/FK, intermedias M:N y regla relacional de `BRANCH_UPDATE` (`OWNER_ID` / `ADMIN_ID` nulables + `CHECK` de exclusividad).
* Unificación de tipos (`NUMBER`, `VARCHAR2`, `DATE`).
* Revisión 1FN/2FN/3FN.

**Qué cambió:**
* Renombres de tablas intermedias generadas automáticamente.
* Jerarquía pasa de arco conceptual a discriminador + `CHECK` en el diseño relacional.
* Dirección y teléfonos se separan para cumplir 3FN.

**Dificultades:**
* El arco no migró solo al MR, tocó modelarlo a mano.
* FK duplicada y nombres automáticos confusos.
* Duda de diseño: dirección en tabla propia o no.

**Redistribución de tareas:**
* Juan Pablo: ajustar MR y exportar `MR.pdf` (límite 03/10/2026).
* Jhoan: dependencias funcionales y 3FN (límite 03/10/2026).
* Miguel: PK/FK y propuesta de `CHECK` para `BRANCH_UPDATE` (límite 03/10/2026).

## Seguimiento 5 — 04/10/2026 — Organización del repo y cierre MR

**Qué se cumplió:**
* Versión definitiva en `model/relacional/MRRumbea.pdf` + fuentes Data Modeler.
* Limpieza de duplicados y sincronización GitHub con commits descriptivos.
* Actualización de `README.md` y actas al día.
* Esqueleto `src/DDL/DML/DQL/PL-SQL` planteado.

**Qué cambió:**
* Se congeló el MR para Entrega 2; el DDL completo quedó como pendiente de Entrega 3.
* Se eliminó PDF duplicado (`EnunciadoBitacorasHUs.pdf` idéntico a `caso_estudio.pdf`).

**Dificultades:**
* Repo desordenado, `README` desactualizado y conflicto Git por no hacer `pull` antes del `push`. Se resolvió en vivo.
* Falta de tiempo para DDL completo.

**Redistribución de tareas:**
* Juan Pablo: congelar MR y fuentes (04/10/2026).
* Jhoan: `README`, actas 4-5 y bitácora Entrega 2 (límite 05/10/2026).
* Miguel: DDL base desde el MR (límite 08/10/2026).
* Los tres: revisar el repo antes de cada avance (permanente).

---

## Seguimiento 6 — 04/11/2026 — Planeación de la Entrega 3

**Qué se cumplió:**
* Revisión completa del enunciado de la Entrega 3 y de la estructura del repositorio.
* Revisión del DDL exportado desde Data Modeler.
* Distribución inicial de tareas y fechas.

**Qué cambió:**
* Se retomó la implementación después del cierre de la Entrega 2.
* Se definió el orden DDL → DML → PL/SQL → DQL.
* Docker con Oracle 11g XE quedó como plan B frente al servidor de la universidad.

**Dificultades:**
* El repositorio no tenía avances en `src/` y el tiempo hasta la entrega era corto.
* El DDL exportado no incluía las restricciones de negocio.
* No se tenía confirmado el acceso al servidor Oracle de la universidad.
* Cruce con parciales y trabajos de otras materias.

**Redistribución de tareas:**
* Juan Pablo: revisar DDL, tipos y nombres (límite 08/11/2026).
* Miguel: diseñar DML y pruebas (límite 15/11/2026).
* Jhoan: revisar enunciado, plantear DQL y documentación (límite 15/11/2026).
* Los tres: no modificar MER/MR y registrar el uso de IAg (permanente).

## Seguimiento 7 — 11/11/2026 — DDL, restricciones y DML

**Qué se cumplió:**
* DDL con 18 tablas y 8 restricciones `[E3]`.
* Validación previa y script de limpieza protegido.
* DML de 1080 filas con casos límite.
* Documentación del alcance de R1 y R2.

**Qué cambió:**
* Se agregaron las restricciones de negocio sin cambiar tablas ni columnas.
* Q4 pasó a llamarse "audiencia potencial"; no se agregó tabla de recordatorios.
* Se corrigió el sesgo del DML para que el `LEFT JOIN` de Q2 probara reseñas sin favorito.

**Dificultades:**
* Restricciones faltantes en el DDL exportado.
* Datos de prueba sesgados en la primera versión.
* Tensión entre la fidelidad de los reportes y el MR congelado.

**Redistribución de tareas:**
* Juan Pablo: DDL con `[E3]` (límite 14/11/2026).
* Miguel: DML ajustado (límite 17/11/2026).
* Jhoan: documentar R1/R2 y renombrar Q4 (límite 17/11/2026).
* Los tres: MR congelado (permanente).

## Seguimiento 8 — 18/11/2026 — DQL y PL/SQL

**Qué se cumplió:**
* 7 consultas para R1, R2 y R3.
* Función, procedimiento, trigger y secuencia.
* Matriz de 24 pruebas.

**Qué cambió:**
* La función devuelve `NULL` cuando la sede no tiene reseñas, no 0.
* La autorización quedó en el trigger para cubrir también inserts directos.
* El TOP se resolvió con `ROWNUM` dentro de una subconsulta.

**Dificultades:**
* El TOP en Oracle 11g obliga a ordenar antes de filtrar.
* Unir reseñas y géneros directamente infla los conteos.
* El flujo procedimiento → insert → trigger → update de la sede generó confusión al principio.

**Redistribución de tareas:**
* Miguel: PL/SQL y pruebas (límite 20/11/2026).
* Jhoan: DQL y comentarios (límite 20/11/2026).
* Juan Pablo: revisión contra MR/HU (límite 20/11/2026).
* Los tres: probar en Oracle real (21/11/2026).

## Seguimiento 9 — 20/11/2026 — Riesgos de IAg, documentación y ensayo

**Qué se cumplió:**
* Matriz de 12 riesgos y controles.
* Registro de las consultas 05 a 10.
* README, guía de ejecución, evidencia y correcciones de actas y rutas.
* Reparto y primer ensayo de la sustentación.

**Qué cambió:**
* Oracle 11g XE en Docker quedó como entorno oficial.
* Se restauraron dos PDF dañados y se normalizó `DDLProyecto.ddl`.
* Se recortó el contenido de la sustentación por tiempo.

**Dificultades:**
* No se encontró el acceso al servidor Oracle de la universidad.
* La validación en SQLite y con el parser no equivale a Oracle.
* PDF dañados y documentación desactualizada.
* Poco tiempo para el ensayo.

**Redistribución de tareas:**
* Miguel: guía de ejecución y evidencia (límite 21/11/2026).
* Jhoan: README, actas 6-10 y bitácora (límite 22/11/2026).
* Juan Pablo: riesgos y diapositivas (límite 22/11/2026).
* Los tres: comprensión de scripts y ensayo (22/11/2026).

## Seguimiento 10 — 22/11/2026 — Decisiones y cierre de la Entrega 3

**Qué se cumplió:**
* Ejecución completa en Oracle 11g XE: 18 tablas, 1080 filas, 24/24 pruebas y 7 reportes.
* Evidencia guardada en `docs/evidencias/ejecucion_oracle11g.txt`.
* Cierre documental y ensayo general.
* Cambios listos para el commit de cierre de la Entrega 3.

**Qué cambió:**
* Se congeló la Entrega 3: no hay más cambios estructurales.
* Se rechazó la tabla de recordatorios y el cambio de PK de visitas.
* Se aceptaron las 8 restricciones `[E3]`.
* Docker quedó como entorno oficial de pruebas.
* El uso de IAg se declara y se cita en la bitácora.

**Dificultades:**
* Falta repasar la comprensión del trigger y de Q7.
* El tiempo de la sustentación es corto.
* Limitaciones conocidas de R1 y R2.
* Cansancio y cruce con otras entregas del semestre.

**Redistribución de tareas:**
* Jhoan: actas 6-10, bitácora, README y contexto/MER/IAg (22/11/2026).
* Juan Pablo: DDL/DML/MR y 3FN (22/11/2026).
* Miguel: DQL/PL/SQL, evidencia y demo (22/11/2026).
* Los tres: ensayo, preguntas cruzadas y repaso del trigger y Q7 (22/11/2026).

### Ajuste posterior al cierre — 22/11/2026

En la revisión final se revirtieron dos decisiones de esta sesión (ver Prompt No. 11 de la bitácora de prompts):

* Se agregó la tabla `CLIENT_EVENT_REMINDERS`: Q4 cuenta recordatorios reales.
* `VISIT_PROFILES` tiene PK propia y tiempo de interacción: Q1 muestra el historial completo.
* Se agregaron el CHECK de `stateActive`, la normalización actualizada (`docs/normalizacion_entrega3.md`) y los ajustes al caso (HU21 a HU23).
* **Pendiente del equipo:** llevar los cambios a Data Modeler, volver a exportar el MER, el MR y `DDLProyecto.ddl`, y regenerar la evidencia en Oracle.

---

## Estado global a 22/11/2026

| Componente | Estado | Evidencia |
| ---------- | ------ | --------- |
| Caso de estudio + HUs | Completado | `docs/CasoDeEstudio.pdf`, Acta 1 y 3 |
| Acuerdos de equipo | Completado | `docs/acuerdos_trabajo_equipo.md` |
| MER | Completado | `model/conceptual/`, Acta 3 |
| MR + normalización 3FN | Completado (normalización actualizada a E3) | `model/relacional/MRentrega3rumbea.pdf`, `docs/normalizacion_entrega3.md`, Acta 4 y 5 |
| DDL / DML / DQL / PL/SQL | Completado y probado en Oracle 11g XE | `src/`, [evidencia](./evidencias/ejecucion_oracle11g.txt), Actas 6-10 |
| Reportes y decisiones | Completado | `docs/reportes_y_decisiones.md`, Acta 7 |
| Riesgos de IAg | Completado | `docs/riesgos_iag.md`, Acta 9 |
| Actas 1-10 | Completado | `docs/actas_de_reunion/` |
| Bitácora de consultas (IAg) | Completado | `docs/bitacora_prompts.md`, Acta 9 |
| Documentación final | Completada; falta regenerar evidencia y PDFs del modelo | `README.md`, `docs/guia_ejecucion.md`, Acta 10 |
