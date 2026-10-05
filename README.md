# SID-RUMBEA

## Sistemas Intensivos en Datos

Proyecto académico desarrollado para la asignatura **Sistemas Intensivos en Datos** de la **Universidad Icesi**.

**SID-RUMBEA** es un proyecto de diseño e implementación de un sistema de información transaccional orientado a la gestión de la información asociada al caso de estudio **RUMBEA**. El proyecto comprende el análisis del problema, levantamiento de requerimientos, modelado conceptual, diseño del modelo relacional normalizado y, posteriormente, la implementación de la base de datos mediante SQL y PL/SQL.

---

## Integrantes

| Integrante   | GitHub                                              |
| ------------ | --------------------------------------------------- |
| Jhoan Tovar  |  [JhoanToovar](https://github.com/JhoanToovar) |
| Juan Pablo   |   [ArkJuanpa](https://github.com/ArkJuanpa) |
| Miguel Pérez | [miguelperezdev](https://github.com/miguelperezdev) |

---

## Descripción del proyecto

El proyecto busca diseñar una solución de información que permita gestionar de manera estructurada los datos relacionados con el caso de estudio **RUMBEA**.

Durante el desarrollo se realiza un proceso progresivo que parte de la comprensión de la situación problema y sus requerimientos, continúa con el diseño conceptual y relacional de los datos, y finaliza con la implementación de una base de datos relacional utilizando SQL y PL/SQL.

El diseño busca garantizar la **integridad, consistencia, organización y trazabilidad de la información**, aplicando principios de modelado de datos y normalización hasta tercera forma normal (3FN).

---

## Objetivos

### Objetivo general

Diseñar e implementar una base de datos relacional que permita gestionar la información del caso de estudio RUMBEA, aplicando técnicas de modelado conceptual, diseño relacional, normalización, SQL y PL/SQL.

### Objetivos específicos

* Analizar la situación problema y establecer los requerimientos del sistema.
* Identificar las entidades, atributos y relaciones necesarias para representar la información.
* Construir el Modelo Entidad-Relación (MER).
* Transformar el modelo conceptual en un Modelo Relacional (MR).
* Normalizar el modelo relacional hasta tercera forma normal (3FN).
* Diseñar una estructura de base de datos que garantice la integridad y consistencia de los datos.
* Implementar la base de datos mediante scripts SQL.
* Desarrollar consultas para la generación de reportes.
* Implementar elementos procedimentales mediante PL/SQL.
* Documentar el proceso de desarrollo y las decisiones tomadas por el equipo.

---

# Estructura del repositorio

El repositorio se encuentra organizado de acuerdo con las entregas establecidas para el proyecto.

```text
SID-RUMBEA/
│
├── README.md
│
├── doc/
│   ├── caso_estudio/
│   ├── bitacora_prompts/
│   ├── acuerdos_equipo/
│   ├── reuniones/
│   └── actas/
│
├── model/
│   ├── conceptual/
│   │   ├── MER.pdf
│   │   └── fuentes/
│   │
│   └── relacional/
│       ├── MR.pdf
│       └── fuentes/
│
└── src/
    ├── DDL/
    ├── DML/
    ├── DQL/
    └── PL-SQL/
```

> La estructura se actualizará progresivamente a medida que avance el proyecto.

---

# Documentación

La documentación del proyecto se encuentra en la carpeta [`doc`](./doc).

## Caso de estudio

Documento que describe la situación problema seleccionada, su contexto, objetivo y alcance.

[Consultar caso de estudio](./doc/caso_estudio/)

## Bitácora de prompts

Registro de los prompts utilizados durante el desarrollo del proyecto y de las interacciones realizadas con herramientas de Inteligencia Artificial Generativa.

[Consultar bitácora de prompts](./doc/bitacora_prompts/)

## Acuerdos de trabajo

Documento que establece los roles, responsabilidades, estrategia de trabajo y acuerdos establecidos por los integrantes del equipo.

[Consultar acuerdos de trabajo](./doc/acuerdos_equipo/)

## Bitácora de reuniones

Registro del seguimiento del proyecto. Incluye asistentes, tareas realizadas, nuevas asignaciones, dificultades, cambios y decisiones tomadas durante las reuniones.

[Consultar bitácora de reuniones](./doc/reuniones/)

## Actas de reuniones

Documentación correspondiente a las reuniones realizadas durante las actividades académicas del proyecto.

[Consultar actas](./doc/actas/)

---

# Modelos de datos

Los modelos de datos se encuentran en la carpeta [`model`](./model).

## Modelo Entidad-Relación

El Modelo Entidad-Relación representa conceptualmente la información del caso de estudio, identificando las entidades, atributos, relaciones y restricciones necesarias para representar la situación problema.

El modelo fue desarrollado utilizando **Oracle SQL Developer Data Modeler**.

[Consultar Modelo Entidad-Relación](./model/conceptual/)

## Modelo Relacional

El Modelo Relacional corresponde a la transformación del modelo conceptual y representa las relaciones, atributos, claves primarias, claves foráneas y demás restricciones necesarias para la implementación de la base de datos.

El modelo será normalizado hasta **Tercera Forma Normal (3FN)**.

[Consultar Modelo Relacional](./model/relacional/)

---

# Implementación

Los scripts de implementación se encuentran en la carpeta [`src`](./src).

## DDL

Contendrá los scripts utilizados para la creación de la estructura de la base de datos.

Incluye:

* Creación de tablas.
* Claves primarias.
* Claves foráneas.
* Restricciones de integridad.
* Tipos de datos.
* Otras estructuras necesarias para la implementación.

[Consultar scripts DDL](./src/DDL/)

## DML

Contendrá los scripts utilizados para insertar los datos necesarios para la operación y generación de los reportes definidos en el proyecto.

Los datos deberán permitir la ejecución y validación de las consultas desarrolladas.

[Consultar scripts DML](./src/DML/)

## DQL

Contendrá las consultas SQL utilizadas para obtener los reportes definidos para el sistema.

Las consultas contemplarán, según los requerimientos del proyecto:

* `JOIN`
* `INNER JOIN`
* `OUTER JOIN`
* Agrupamiento mediante `GROUP BY`
* Ordenamiento mediante `ORDER BY`
* Consultas con selección de los registros superiores (`TOP`)

Cada consulta estará acompañada de una descripción en lenguaje natural que explique su propósito.

[Consultar scripts DQL](./src/DQL/)

## PL/SQL

Contendrá los elementos procedimentales desarrollados sobre la base de datos.

Como mínimo, el proyecto contempla:

* Un procedimiento almacenado.
* Una función.
* Un trigger.

Cada elemento estará documentado indicando su propósito, funcionamiento y comportamiento dentro del sistema.

[Consultar scripts PL/SQL](./src/PL-SQL/)

---

# Entregas

El proyecto se desarrolla de manera incremental mediante las siguientes entregas.

## Entrega 0 — Caso de estudio

**Semana 2**

Esta etapa comprende:

* Definición del caso de estudio.
* Identificación de la situación problema.
* Objetivo de la aplicación.
* Definición de reportes de interés.
* Identificación de entidades fundamentales.
* Especificación inicial de requerimientos.
* Acuerdos de trabajo del equipo.

---

## Entrega 1 — Modelo Entidad-Relación

**Semana 5**

Esta etapa comprende:

* Construcción del Modelo Entidad-Relación.
* Ajustes al caso de estudio y requerimientos.
* Documentación del proceso de desarrollo.
* Bitácoras de seguimiento.
* Actas de reuniones.
* Entrega parcial del repositorio.

### Resultado

Modelo conceptual desarrollado mediante Oracle SQL Developer Data Modeler.

---

## Entrega 2 — Modelo Relacional

**Semana 10**

Esta etapa comprende:

* Transformación del Modelo Entidad-Relación al Modelo Relacional.
* Normalización del modelo hasta **Tercera Forma Normal (3FN)**.
* Ajustes al Modelo Entidad-Relación.
* Actualización de los requerimientos.
* Bitácoras de seguimiento.
* Actas de reuniones.
* Actualización del repositorio.

### Resultado

Modelo Relacional normalizado preparado para la posterior implementación de la base de datos.

---

## Entrega 3 — SQL y PL/SQL

**Semana 16**

Esta etapa comprende:

* Script DDL.
* Scripts DML.
* Consultas DQL.
* Reportes.
* Procedimiento almacenado.
* Función.
* Trigger.
* Documentación de los elementos PL/SQL.
* Análisis de riesgos asociados al uso de Inteligencia Artificial Generativa.
* Entrega completa del repositorio.
* Sustentación del proyecto.

---

# Herramientas utilizadas

| Herramienta                       | Uso                                          |
| --------------------------------- | -------------------------------------------- |
| Git                               | Control de versiones                         |
| GitHub                            | Hospedaje y colaboración del repositorio     |
| Oracle SQL Developer Data Modeler | Diseño de modelos de datos                   |
| Oracle Database                   | Implementación de la base de datos           |
| SQL                               | Definición, manipulación y consulta de datos |
| PL/SQL                            | Desarrollo de lógica procedimental           |
| Markdown                          | Documentación del proyecto                   |

---

# Control de versiones

El desarrollo del proyecto utiliza **Git** para mantener un historial de cambios y facilitar el trabajo colaborativo entre los integrantes.

Las modificaciones se registran mediante commits descriptivos relacionados con las diferentes etapas del proyecto.

Ejemplo:

```bash
git add .
git commit -m "feat: agrega modelo relacional normalizado"
git push origin main
```

---

# Estado actual del proyecto

| Componente              | Estado                        |
| ----------------------- | ----------------------------- |
| Caso de estudio         | Completado                    |
| Requerimientos          | Completado / En actualización |
| Acuerdos de trabajo     | Completado                    |
| Modelo Entidad-Relación | Completado                    |
| Modelo Relacional       | En desarrollo                 |
| Normalización 3FN       | En desarrollo                 |
| DDL                     | Pendiente                     |
| DML                     | Pendiente                     |
| DQL                     | Pendiente                     |
| PL/SQL                  | Pendiente                     |
| Documentación final     | Pendiente                     |

---

# Curso

**Asignatura:** Sistemas Intensivos en Datos
**Universidad:** Universidad Icesi
**Proyecto:** SID-RUMBEA
**Tipo:** Proyecto académico
**Periodo:** 2026
