# SID-RUMBEA

## Bitácora de seguimiento del proyecto

Registro consolidado del seguimiento. Cada entrada resume qué se cumplió, qué cambió, qué dificultades aparecieron y cómo se redistribuyeron las tareas. El detalle de cada sesión está en su acta correspondiente.

| N.º | Fecha | Asistentes | Acta |
| --- | ----- | ---------- | ---- |
| 1 | Jueves 28 de agosto de 2026 | Jhoan, Juan Pablo | [Acta 1](./actas_de_reunion/acta_1.md) |
| 2 | Martes 2 de septiembre de 2026 | Jhoan, Juan Pablo | [Acta 2](./actas_de_reunion/acta_2.md) |
| 3 | Jueves 4 de septiembre de 2026 | Jhoan, Juan Pablo | [Acta 3](./actas_de_reunion/acta_3.md) |
| 4 | Jueves 1 de octubre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 4](./actas_de_reunion/acta_4.md) |
| 5 | Domingo 4 de octubre de 2026 | Jhoan, Juan Pablo, Miguel | [Acta 5](./actas_de_reunion/acta_5.md) |

> Nota: en las sesiones 1-3 Miguel no asistió por cruce con parciales de otras materias; desde la sesión 4 se reintegra y participa en MR, repo y DDL base. Ver detalle en Acta 4.

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

## Estado global a 04/10/2026

| Componente | Estado | Evidencia |
| ---------- | ------ | --------- |
| Caso de estudio + HUs | Completado | `docs/caso_estudio.pdf`, Acta 1 y 3 |
| Acuerdos de equipo | Completado | `docs/acuerdos_trabajo_equipo.md` |
| MER | Completado | `model/conceptual/`, Acta 3 |
| MR + normalización 3FN | Completado | `model/relacional/MRRumbea.pdf`, Acta 4 y 5 |
| DDL / DML / DQL / PL/SQL | Pendiente (base planteada) | `src/` + compromiso Miguel 08/10/2026 |
| Actas 1-5 | Completado | `docs/actas_de_reunion/` |
| Bitácora prompts (IA solo apoyo) | Completado | `docs/bitacora_prompts.md` |
