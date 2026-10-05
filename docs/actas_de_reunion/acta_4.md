# SID-RUMBEA

## Acta de Reunión No. 04

| Campo               | Información                                     |
| ------------------- | ----------------------------------------------- |
| **Proyecto**        | SID-RUMBEA                                      |
| **Reunión**         | Definición del Modelo Relacional (MR)           |
| **Fecha**           | Jueves 1 de octubre de 2026                    |
| **Hora**            | 10:00 a. m.                                     |
| **Lugar**           | CAMBAS, Universidad Icesi                       |
| **Asistentes**      | Jhoan, Juan Pablo, Miguel                       |
| **Próxima reunión** | Domingo 4 de octubre de 2026                    |

## 1. Objetivo de la reunión

Definir el Modelo Relacional (MR) a partir del Modelo Entidad-Relación validado, revisando la transformación de entidades, relaciones muchos a muchos, jerarquía de usuarios y arco de `BRANCH_UPDATE`, e iniciar la normalización hasta tercera forma normal (3FN).

## 2. Agenda

1. Puesta en común y revisión del MER validado.
2. Generación del modelo relacional en Oracle Data Modeler.
3. Definición de tablas, claves primarias y foráneas.
4. Tratamiento de la jerarquía de usuarios en el modelo relacional.
5. Tratamiento del arco de `BRANCH_UPDATE`.
6. Revisión de normalización (1FN, 2FN, 3FN).
7. Distribución de tareas de corrección del MR.

## 3. Desarrollo de la reunión

Por fin nos pudimos reunir los tres de forma presencial en el CAMBAS, que ya hacía falta porque las últimas revisiones las habíamos hecho solo entre dos y por WhatsApp.

Empezamos abriendo el archivo `rumbea.dmd` en el portátil de Juan Pablo y repasando el MER que había quedado validado en la reunión anterior. Miguel, que había estado un poco desconectado por parciales de otras materias, se puso al día rápido y nos ayudó a cuestionar varias cosas que ya dábamos por sentadas, sobre todo los tipos de datos y unos nombres de atributos que estaban muy largos.

Después usamos la opción de `Engineer to Relational Model` del Data Modeler para generar el MR. Ahí se nos armó un rato el enredo: nos generó varias tablas intermedias con nombres automáticos, nos duplicó una foránea y el arco de `BRANCH_UPDATE` no se trasladó solo, tocó revisarlo a mano. Nos tomamos un café mientras mirábamos tabla por tabla para renombrar y dejar todo consistente.

Los puntos principales que definimos fueron:

* Cada entidad del MER pasa a una tabla, con su clave primaria definida.
* Las relaciones muchos a muchos se resuelven con tablas intermedias con llave compuesta.
* La jerarquía de cliente, propietario y administrador se mantiene como especialización con columna discriminadora y restricción de exclusividad, ya no como arco conceptual sino como `CHECK` + validación a nivel de diseño.
* El caso de `BRANCH_UPDATE` quedó definido así: la tabla lleva `OWNER_ID` y `ADMIN_ID` nulables, pero con restricción de que exactamente uno de los dos debe estar lleno. Lo dejamos anotado para implementarlo después con `CHECK` en el DDL.
* Se unificaron tipos: `NUMBER` para IDs y montos, `VARCHAR2` para nombres y descripciones, `DATE` para fechas, y se quitaron varios `CHAR` sueltos que habían quedado del MER.

Al final revisamos rápidamente 1FN, 2FN y 3FN. Vimos que había un problema con la dirección de sucursal y de usuario que estaba repetida y con atributos multivaluados en teléfonos, así que acordamos separarlos y dejarlo normalizado antes del domingo.

## 4. Dificultades identificadas

* El Data Modeler no trasladó automáticamente el arco de `BRANCH_UPDATE` al modelo relacional, tocó modelar la restricción a mano.
* Nombres de tablas intermedias generados automáticamente muy confusos, tocó renombrarlos uno por uno.
* Duda con la dirección: no sabíamos si dejarla en la misma tabla o sacarla aparte para cumplir 3FN.
* Algunos tipos de datos venían del MER sin ajustar a Oracle y generaban advertencias al validar.

## 5. Acuerdos y compromisos

| Responsable            | Compromiso                                                                 | Fecha límite          |
| ---------------------- | -------------------------------------------------------------------------- | --------------------- |
| **Juan Pablo**         | Terminar el ajuste del MR en Data Modeler y exportar el `MR.pdf`.          | 3 de octubre de 2026  |
| **Jhoan**              | Revisar dependencias funcionales y verificar normalización hasta 3FN.      | 3 de octubre de 2026  |
| **Miguel**             | Revisar PK/FK y proponer la restricción `CHECK` para `BRANCH_UPDATE`.      | 3 de octubre de 2026  |
| **Jhoan y Juan Pablo** | Hacer revisión cruzada del MR contra el MER antes de acomodar el repo.     | 4 de octubre de 2026  |

## 6. Aspectos definidos

* Transformación completa del MER al MR.
* Tablas, claves primarias y foráneas principales.
* Tablas intermedias para relaciones M:N.
* Manejo relacional de la jerarquía de usuarios.
* Regla de `BRANCH_UPDATE`: solo propietario o solo administrador.
* Criterios de normalización hasta 3FN.
* Lista de renombres y tipos de datos unificados.

## 7. Resultado

Se definió el diagrama del Modelo Relacional y quedó una primera versión casi lista, pendiente solo de pulir normalización y la restricción de `BRANCH_UPDATE`.

También se acordó que la siguiente reunión sería el domingo 4 de octubre para acomodar el repositorio y dejar todo organizado para la Entrega 2.

## 8. Próxima reunión

La próxima reunión se realizará el domingo 4 de octubre de 2026, con el objetivo de organizar el repositorio, ubicar el MR definitivo y preparar los pendientes de la Entrega 2.
