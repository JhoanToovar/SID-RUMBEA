# SID-RUMBEA

## Acta de Reunión No. 05

| Campo               | Información                                   |
| ------------------- | --------------------------------------------- |
| **Proyecto**        | SID-RUMBEA                                    |
| **Reunión**         | Organización del repositorio y cierre del MR  |
| **Fecha**           | Domingo 4 de octubre de 2026                  |
| **Hora**            | 2:00 p. m.                                    |
| **Lugar**           | Reunión virtual (Meet) + trabajo en CAMBAS    |
| **Asistentes**      | Jhoan, Juan Pablo, Miguel                     |
| **Próxima reunión** | Por definir                                   |

## 1. Objetivo de la reunión

Acomodar el repositorio del proyecto, ubicar la versión definitiva del Modelo Relacional, actualizar la documentación y dejar todo listo para la Entrega 2.

## 2. Agenda

1. Revisión final del MR ajustado.
2. Organización de carpetas `model/`, `src/` y `docs/`.
3. Ubicación del `MR.pdf` y fuentes del modelo.
4. Actualización del `README.md` y estados del proyecto.
5. Verificación de commits y limpieza de archivos.
6. Definición de pendientes para DDL y Entrega 3.

## 3. Desarrollo de la reunión

Nos conectamos el domingo por la tarde por Meet porque estábamos contra el tiempo y cada uno estaba en un lado distinto. Jhoan compartió pantalla y abrimos el GitHub para ver en qué estado estaba el repo, y la verdad estaba bastante desordenado: había PDFs viejos en `model/relacional/`, el `rumbea.dmd` desactualizado, carpetas de `src/` vacías y el `README` todavía decía que el MR estaba “en desarrollo”.

Entre los tres fuimos acomodando todo:

* Revisamos el `MRRumbea.pdf` que había exportado Juan Pablo y lo comparamos con el MER para confirmar que ya incluía los arreglos del jueves (renombres, tipos, intermedias y la nota del `BRANCH_UPDATE`).
* Movimos la versión definitiva a `model/relacional/` y dejamos las fuentes del Data Modeler en su carpeta para no perderlas.
* Borramos archivos temporales y PDFs duplicados de la Entrega 1 que estaban estorbando.
* Actualizamos el `README.md`: estados del MR y normalización 3FN, estructura de carpetas y enlaces a actas.
* Revisamos que las actas 1, 2 y 3 estuvieran bien subidas y preparamos estas actas 4 y 5 para que quedara constancia de lo que hicimos esta semana.
* Miguel adelantó la estructura de `src/DDL`, `DML`, `DQL` y `PL-SQL` y dejó planteado el esqueleto del DDL con las tablas principales para no empezar de cero la próxima fase.

Hubo un momento chistoso porque intentamos hacer push y nos dio conflicto por no haber hecho pull antes, nos tocó resolverlo en vivo y aprovechar para recordar no subirnos encima de los cambios del otro. Al final dejamos todo sincronizado y con commits descriptivos.

## 4. Dificultades identificadas

* El repositorio tenía archivos duplicados y versiones viejas del modelo que confundían cuál era la definitiva.
* El `README` estaba desactualizado respecto al avance real del MR.
* Tuvimos un conflicto en Git por trabajar sobre versiones distintas sin sincronizar.
* Nos faltó tiempo para empezar el DDL completo, solo quedó planteado.

## 5. Acuerdos y compromisos

| Responsable    | Compromiso                                                              | Fecha límite          |
| -------------- | ----------------------------------------------------------------------- | --------------------- |
| **Juan Pablo** | Dejar congelada la versión del MR en `model/relacional/` y sus fuentes. | 4 de octubre de 2026  |
| **Jhoan**      | Actualizar `README`, actas 4 y 5 y bitácora de la Entrega 2.            | 5 de octubre de 2026  |
| **Miguel**     | Iniciar el script DDL base a partir del MR normalizado.                 | 8 de octubre de 2026  |
| **Los tres**   | Revisar el repo antes de cada avance y usar commits descriptivos.       | Permanente            |

## 6. Aspectos validados

* MR definitivo revisado contra el MER.
* Tablas, PK, FK y tablas intermedias verificadas.
* Restricción de `BRANCH_UPDATE` documentada para el DDL.
* Normalización hasta 3FN revisada.
* Estructura del repositorio organizada (`model/`, `src/`, `docs/`).
* `README.md` actualizado.
* Repositorio sincronizado en GitHub sin archivos basura.

## 7. Resultado

Se acomodó el repositorio y se dejó el Modelo Relacional listo como resultado de la Entrega 2, con documentación y actas al día.

El equipo quedó tranquilo porque ya los tres manejamos la misma versión del modelo y tenemos claro el paso a seguir: empezar el DDL y la implementación en Oracle.

## 8. Próxima reunión

La fecha de la próxima reunión quedó por definir, según el avance del DDL inicial y la asignación de tareas de la Entrega 3.
