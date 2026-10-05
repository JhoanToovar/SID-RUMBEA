# SID-RUMBEA

## Acta de Reunión No. 02

| Campo               | Información                            |
| ------------------- | -------------------------------------- |
| **Proyecto**        | SID-RUMBEA                             |
| **Reunión**         | Definición de la jerarquía de usuarios |
| **Fecha**           | Martes 2 de septiembre de 2026         |
| **Hora**            | 9:30 a. m.                             |
| **Lugar**           | CAMBAS, Universidad Icesi              |
| **Asistentes**      | Jhoan, Juan Pablo                      |
| **Próxima reunión** | Por definir                            |

## 1. Objetivo de la reunión

Definir la estructura jerárquica de los usuarios del sistema y establecer las restricciones correspondientes entre los diferentes tipos de usuario.

## 2. Agenda

1. Revisión de los tipos de usuario.
2. Definición de la jerarquía de usuarios.
3. Identificación de restricciones entre roles.
4. Revisión de la relación `BRANCH_UPDATE`.
5. Configuración del arco en Oracle Data Modeler.

## 3. Desarrollo de la reunión

Durante la reunión se analizó la estructura de los usuarios del sistema y se determinó que los roles **cliente, propietario y administrador** deben ser mutuamente excluyentes dentro de una jerarquía de especialización total.

Esto significa que un usuario debe pertenecer a uno de estos roles y no puede pertenecer simultáneamente a más de uno.

Adicionalmente, se identificó una restricción en la entidad `BRANCH_UPDATE`. Cada actualización de una sucursal debe ser realizada exactamente por un propietario o exactamente por un administrador, pero no por ambos.

Para representar esta restricción en el modelo se determinó la necesidad de utilizar un **arco** entre las relaciones correspondientes.

## 4. Dificultades identificadas

La principal dificultad estuvo relacionada con la configuración del arco en Oracle Data Modeler, particularmente con la definición de la columna discriminadora necesaria para representar correctamente la restricción.

Se realizó una revisión de la configuración y se ajustó el modelo para representar la regla de negocio de forma adecuada.

## 5. Acuerdos

| Tema                      | Acuerdo                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------ |
| **Jerarquía de usuarios** | Los roles cliente, propietario y administrador serán mutuamente excluyentes.               |
| **Especialización**       | Se utilizará una especialización total para la jerarquía de usuarios.                      |
| **BRANCH_UPDATE**         | Cada actualización será realizada por un propietario o un administrador.                   |
| **Restricción**           | No se permitirá que una misma actualización sea realizada simultáneamente por ambos roles. |
| **Modelado**              | Se utilizará un arco para representar la restricción.                                      |

## 6. Resultado

Se definió la jerarquía de usuarios y la restricción asociada a `BRANCH_UPDATE`.

Además, se realizaron los ajustes necesarios en Oracle Data Modeler para representar correctamente el arco y su correspondiente restricción.
