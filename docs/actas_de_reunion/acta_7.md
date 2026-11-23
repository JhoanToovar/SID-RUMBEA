# SID-RUMBEA

## Acta de Reunión No. 07

| Campo               | Información                                    |
| ------------------- | ---------------------------------------------- |
| **Proyecto**        | SID-RUMBEA                                     |
| **Reunión**         | DDL, restricciones y datos de prueba           |
| **Fecha**           | Miércoles 11 de noviembre de 2026              |
| **Hora**            | 6:30 p. m.                                     |
| **Lugar**           | Reunión virtual (Meet)                         |
| **Asistentes**      | Jhoan, Juan Pablo, Miguel                      |
| **Próxima reunión** | Miércoles 18 de noviembre de 2026              |

## 1. Objetivo de la reunión

Cerrar el DDL con las restricciones de negocio, revisar la coherencia del DML y definir cómo cubrir los tres reportes sin modificar el modelo relacional.

## 2. Agenda

1. Revisión del DDL y las restricciones.
2. Compatibilidad con Oracle 11g.
3. Estructura y volumen del DML.
4. Cobertura de los reportes R1, R2 y R3.
5. Limitaciones del modelo y decisiones de alcance.
6. Compromisos.

## 3. Desarrollo de la reunión

Nos conectamos por Meet a las 6:30 porque Juan Pablo salía del trabajo y Miguel estaba en la casa. Jhoan compartió pantalla con SQL Developer y fuimos revisando el DDL línea por línea.

El DDL ya tenía las 18 tablas, las PK, las FK y los tipos del MR. Definimos ocho restricciones marcadas con `[E3]` que no cambian tablas ni columnas: aforo y cover no negativos, calificación entre 1 y 5, un solo tipo por sede, un solo horario por día, entre otras. También quedó una validación al inicio para que el script se detenga si ya existen objetos con esos nombres, y un script de limpieza aparte que solo borra las tablas marcadas como de Rumbea y no usa `CASCADE CONSTRAINTS`.

Revisamos detalles de compatibilidad con 11g: los identificadores no pasan de 30 caracteres, `"date"` va entre comillas dobles porque es palabra reservada y los textos van sin tildes para que no se dañen con cualquier codificación. Eso último nos pareció medio feo, pero preferimos que el script corra igual en cualquier máquina.

Después pasamos al DML. Ya teníamos una primera versión con 1080 inserts, que Miguel había estado revisando. La idea era que cada reporte tuviera al menos 10 filas, como pide el enunciado, pero también que los datos fueran coherentes entre sí: que las reseñas correspondieran a clientes que visitaron la sede, que los eventos estuvieran en sedes del mismo establecimiento y que hubiera casos con cero favoritos, promedios nulos y empates. Ahí Juan Pablo notó un problema: en la primera versión todos los clientes que habían reseñado SED01 la tenían como favorita, entonces el `LEFT JOIN` de Q2 no estaba demostrando nada. Tocó ajustar los datos para que hubiera reseñas de clientes que no la marcaron como favorita.

El tema que se nos llevó más tiempo fue R2. El reporte original pedía contar los usuarios que activaron "recordar evento", pero el MR no guarda esa información. Discutimos dos opciones: agregar una tabla de recordatorios y cambiar la PK de `VISIT_PROFILES` para tener un historial completo de accesos, o mantener el modelo y dejar claro el alcance de lo que sí se podía responder. Jhoan dijo que cambiar el modelo a estas alturas era volver a abrir la Entrega 2 y que no había tiempo; Miguel estuvo de acuerdo en que era mejor entregar algo honesto y documentado que inventar un reporte. Decidimos mantener el MR y llamar a Q4 "audiencia potencial", que son los clientes que tienen como favorita alguna sede del evento. No es lo mismo que un recordatorio y así quedó escrito.

Con R1 pasó algo parecido: como la PK de `VISIT_PROFILES` es (cliente, sede), cada cliente aparece una sola vez por sede, así que el historial de accesos es parcial. Lo dejamos documentado también y no tocamos el modelo.

Al final revisamos que el DML dejara datos para los tres reportes y que las restricciones del DDL se pudieran probar con casos límite.

## 4. Dificultades identificadas

* El DDL exportado no traía las restricciones de negocio; tocó agregarlas a mano.
* La primera versión del DML estaba sesgada y no probaba bien los `LEFT JOIN`.
* Tensión entre cumplir literalmente los reportes de la Entrega 0 y mantener congelado el MR.
* Explicar la diferencia entre "recordatorio" y "audiencia potencial" sin que sonara a excusa.

## 5. Acuerdos y compromisos

| Responsable    | Compromiso                                                                 | Fecha límite            |
| -------------- | -------------------------------------------------------------------------- | ----------------------- |
| **Juan Pablo** | Dejar el DDL con las 8 restricciones `[E3]`, sin cambiar tablas ni columnas. | 14 de noviembre de 2026 |
| **Miguel**     | Ajustar el DML a 1080 filas e incluir ceros, nulos y empates.               | 17 de noviembre de 2026 |
| **Jhoan**      | Documentar el alcance de R1 y R2 y renombrar Q4 como audiencia potencial.  | 17 de noviembre de 2026 |
| **Los tres**   | Mantener el MR congelado; cualquier cambio estructural se discute primero.  | Permanente              |

## 6. Aspectos definidos

* DDL con 18 tablas y 8 restricciones adicionales.
* Validación previa y script de limpieza protegido.
* DML de 1080 filas con casos límite.
* Límites de R1 y R2 documentados.
* Q4 queda como audiencia potencial, no como recordatorios.
* El DML se ejecuta antes del PL/SQL.

## 7. Resultado

El DDL quedó cerrado y el DML quedó encaminado. Nos quedó claro que no íbamos a tocar el modelo y que las limitaciones de R1 y R2 se iban a explicar en la documentación y en la sustentación, no a esconder.

## 8. Próxima reunión

El miércoles 18 de noviembre de 2026, en el CAMBAS, para revisar las consultas DQL y los elementos de PL/SQL.
