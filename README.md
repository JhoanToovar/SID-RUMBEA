# SID-RUMBEA

## Sistemas Intensivos en Datos

Proyecto académico desarrollado para la asignatura **Sistemas Intensivos en Datos** de la **Universidad Icesi**.

**SID-RUMBEA** es un proyecto de diseño e implementación de un sistema de información transaccional orientado a la gestión de la información asociada al caso de estudio **RUMBEA**. El proyecto comprende el análisis del problema, levantamiento de requerimientos, modelado conceptual, diseño del modelo relacional normalizado y, posteriormente, la implementación de la base de datos mediante SQL y PL/SQL.

---

## Integrantes

| Integrante | Código | GitHub |
| --- | --- | --- |
| Jhoan Manuel Tovar Rendon | A00408185 | [JhoanToovar](https://github.com/JhoanToovar) |
| Juan Pablo Martinez Rosero | A00407215 | [ArkJuanpa](https://github.com/ArkJuanpa) |
| Miguel Pérez | A00407054 | [miguelperezdev](https://github.com/miguelperezdev) |

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
├── .gitattributes
│
├── docs/
│   ├── CasoDeEstudio.pdf
│   ├── enunciado/
│   ├── reportes_y_decisiones.md
│   ├── guia_ejecucion.md
│   ├── evidencias/
│   ├── riesgos_iag.md
│   ├── bitacora_prompts.md
│   ├── bitacora_seguimiento.md
│   ├── acuerdos_trabajo_equipo.md
│   └── actas_de_reunion/
│
├── model/
│   ├── conceptual/
│   │   ├── MERentrega2rumbea.pdf
│   │   ├── correccionMerEntrega1.pdf
│   │   ├── Equipo19_retroalimentacion.pdf
│   │   └── rumbea/
│   │
│   └── relacional/
│       ├── MERentrega2rumbeaCorregido.pdf   (es el MR)
│       ├── DFNormYRelaciones.pdf
│       └── rumbea/
│
└── src/
    ├── ejecutar_todo.sql
    ├── DDL/
    │   ├── DDLProyecto.ddl                  (exportación original)
    │   ├── rumbea_ddl.sql
    │   └── rumbea_limpieza.sql
    ├── DML/
    │   └── rumbea_dml.sql
    ├── DQL/
    │   └── rumbea_dql.sql
    └── PL-SQL/
        ├── rumbea_plsql.sql
        └── rumbea_pruebas.sql
```

> La estructura se actualizará progresivamente a medida que avance el proyecto.

---

# Documentación

La documentación del proyecto se encuentra en la carpeta [`docs`](./docs).

## Caso de estudio

Documento que describe la situación problema seleccionada, su contexto, objetivo y alcance.

[Consultar caso de estudio](./docs/CasoDeEstudio.pdf)

## Reportes y decisiones de implementación

Los tres reportes definidos en la Entrega 0, las consultas que los resuelven y las limitaciones conocidas.

[Consultar reportes y decisiones](./docs/reportes_y_decisiones.md)

## Guía de ejecución

Cómo crear, probar y limpiar la base de datos desde SQL Developer.

[Consultar guía de ejecución](./docs/guia_ejecucion.md)

## Evidencia de ejecución

Salida real de la creación de la base, las 24 pruebas y los 7 reportes en Oracle 11g XE.

[Consultar evidencia](./docs/evidencias/ejecucion_oracle11g.txt)

## Riesgos del uso de IAg

Análisis de riesgos del uso de IA generativa en un contexto profesional.

[Consultar riesgos de IAg](./docs/riesgos_iag.md)

## Bitácora de prompts

Registro de las consultas puntuales realizadas a herramientas de Inteligencia Artificial Generativa como apoyo de ideas, revisión y resolución de dudas. La autoría de los artefactos es del equipo.

[Consultar bitácora de prompts](./docs/bitacora_prompts.md)

## Acuerdos de trabajo

Documento que establece los roles, responsabilidades, estrategia de trabajo y acuerdos establecidos por los integrantes del equipo.

[Consultar acuerdos de trabajo](./docs/acuerdos_trabajo_equipo.md)

## Bitácora de seguimiento

Registro del seguimiento del proyecto. Incluye asistentes, tareas realizadas, nuevas asignaciones, dificultades, cambios y decisiones tomadas durante las reuniones.

[Consultar bitácora de seguimiento](./docs/bitacora_seguimiento.md)

## Actas de reuniones

Documentación correspondiente a las reuniones realizadas durante las actividades académicas del proyecto.

[Consultar actas](./docs/actas_de_reunion/)

---

# Modelos de datos

Los modelos de datos se encuentran en la carpeta [`model`](./model).

## Modelo Entidad-Relación

El Modelo Entidad-Relación representa conceptualmente la información del caso de estudio, identificando las entidades, atributos, relaciones y restricciones necesarias para representar la situación problema.

El modelo fue desarrollado utilizando **Oracle SQL Developer Data Modeler**.

[Consultar MER (PDF)](./model/conceptual/MERentrega2rumbea.pdf) · [Carpeta y fuentes](./model/conceptual/)

## Modelo Relacional

El Modelo Relacional corresponde a la transformación del modelo conceptual y representa las relaciones, atributos, claves primarias, claves foráneas y demás restricciones necesarias para la implementación de la base de datos.

El modelo será normalizado hasta **Tercera Forma Normal (3FN)**.

[Consultar MR (PDF)](./model/relacional/MERentrega2rumbeaCorregido.pdf) · [Normalización](./model/relacional/DFNormYRelaciones.pdf) · [Carpeta y fuentes](./model/relacional/)

---

# Implementación

Los scripts de implementación se encuentran en la carpeta [`src`](./src). Para crear y probar todo, abrir [`ejecutar_todo.sql`](./src/ejecutar_todo.sql) en SQL Developer y pulsar F5 (ver la [guía](./docs/guia_ejecucion.md)).

## DDL

Contiene los scripts utilizados para la creación de la estructura de la base de datos.

Incluye:

* Creación de tablas.
* Claves primarias.
* Claves foráneas.
* Restricciones de integridad.
* Tipos de datos.
* Otras estructuras necesarias para la implementación.

[Consultar script DDL](./src/DDL/rumbea_ddl.sql)

## DML

Contiene los scripts utilizados para insertar los datos necesarios para la operación y generación de los reportes definidos en el proyecto.

Los datos permiten la ejecución y validación de las consultas desarrolladas.

[Consultar script DML](./src/DML/rumbea_dml.sql)

## DQL

Contiene las consultas SQL utilizadas para obtener los reportes definidos para el sistema.

Las consultas contemplan, según los requerimientos del proyecto:

* `JOIN`
* `INNER JOIN`
* `OUTER JOIN`
* Agrupamiento mediante `GROUP BY`
* Ordenamiento mediante `ORDER BY`
* Consultas con selección de los registros superiores (`TOP`)

Cada consulta está acompañada de una descripción en lenguaje natural que explique su propósito.

[Consultar script DQL](./src/DQL/rumbea_dql.sql)

## PL/SQL

Contiene los elementos procedimentales desarrollados sobre la base de datos.

Como mínimo, el proyecto contempla:

* Un procedimiento almacenado.
* Una función.
* Un trigger.

Cada elemento está documentado indicando su propósito, funcionamiento y comportamiento dentro del sistema.

[Consultar script PL/SQL](./src/PL-SQL/rumbea_plsql.sql) · [Pruebas](./src/PL-SQL/rumbea_pruebas.sql)

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
| Docker                            | Oracle 11g XE local para ejecución y pruebas |
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
| Modelo Relacional       | Completado                    |
| Normalización 3FN       | Completado                  |
| DDL                     | Probado en Oracle 11g XE               |
| DML                     | Probado en Oracle 11g XE               |
| DQL                     | Probado en Oracle 11g XE               |
| PL/SQL                  | Probado en Oracle 11g XE               |
| Riesgos de IAg          | Escrito, pendiente de revisión del equipo |
| Documentación final     | En proceso                    |

---

# Curso

**Asignatura:** Sistemas Intensivos en Datos
**Universidad:** Universidad Icesi
**Proyecto:** SID-RUMBEA
**Tipo:** Proyecto académico
**Periodo:** 2026
