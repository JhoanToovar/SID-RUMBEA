# SID-RUMBEA

## Acta de Reunión No. 06

| Campo               | Información                                      |
| ------------------- | ------------------------------------------------ |
| **Proyecto**        | SID-RUMBEA                                       |
| **Reunión**         | Planeación de la Entrega 3 y revisión del enunciado |
| **Fecha**           | Miércoles 4 de noviembre de 2026                 |
| **Hora**            | 10:00 a. m.                                      |
| **Lugar**           | CAMBAS, Universidad Icesi                        |
| **Asistentes**      | Jhoan, Juan Pablo, Miguel                        |
| **Próxima reunión** | Miércoles 11 de noviembre de 2026                |

## 1. Objetivo de la reunión

Retomar el proyecto después del cierre de la Entrega 2, revisar completa la consigna de la Entrega 3 y organizar el trabajo de las semanas que quedan antes de la sustentación.

## 2. Agenda

1. Estado del repositorio y cierre de la Entrega 2.
2. Lectura del enunciado de la Entrega 3.
3. Revisión del DDL exportado desde Data Modeler.
4. Alcance de DML, DQL, PL/SQL y riesgos de IAg.
5. Entorno de pruebas.
6. Distribución de tareas y fechas.

## 3. Desarrollo de la reunión

Nos encontramos en el CAMBAS después de clase. La última vez que nos habíamos sentado los tres había sido el 4 de octubre, cuando dejamos congelado el MR, así que lo primero fue abrir el repositorio y ver en qué había quedado. La verdad el modelo y la documentación estaban bien, pero la parte de `src/` seguía prácticamente vacía; solo estaba el esqueleto de carpetas que había dejado Miguel.

Jhoan abrió el Word del enunciado que está en `docs/enunciado/` y lo leímos completo, no solo la parte de la Entrega 3. Nos dimos cuenta de varias cosas que se nos habían pasado: la entrega no era solo hacer scripts, también pedía DDL documentado, DML con datos suficientes para que cada reporte tuviera al menos 10 registros, DQL con agrupamiento, joins, ordenamiento y por lo menos un TOP, un documento de riesgos del uso de IAg y la sustentación de 30 minutos. Además, en la Entrega 3 el nivel de uso de IAg es 4, o sea que sí podíamos apoyarnos en herramientas, pero con uso crítico, justificación y registro. También caímos en cuenta de que la entrega se sube por Saman, no solo queda en GitHub.

También repasamos la estructura del repositorio que pide el enunciado: README, `docs/`, `model/` y `src/`. Ahí caímos en cuenta de que el README ya tenía casi todo, pero faltaba actualizar el estado real de la implementación y enlazar la evidencia.

Antes de seguir, repasamos lo que ya estaba entregado: el caso y las HUs de la Entrega 0, el MER de la Entrega 1 y el MR con la normalización de la Entrega 2. La idea era no contradecir nada de lo que ya habíamos trabajado y sustentado.

Juan Pablo abrió el `DDLProyecto.ddl` que había exportado de Data Modeler y lo revisamos por encima. Las 18 tablas, las PK y las FK venían del MR corregido, pero el DDL exportado no traía las restricciones de negocio que habíamos discutido (aforo no negativo, cover, calificación entre 1 y 5, un solo tipo por sede, etc.). Decidimos agregarlas sin cambiar tablas ni columnas, para no abrir otra vez el modelo a estas alturas.

Después definimos el orden de los scripts: DDL, DML, PL/SQL y DQL. Miguel insistió en que el DML va antes del PL/SQL porque el trigger de actualizaciones reemplaza la fecha del historial por la fecha actual; si cargábamos primero el PL/SQL, perdíamos las fechas pasadas que necesitan los reportes. Quedó anotado.

Sobre el entorno, la idea inicial era usar el servidor Oracle de la universidad, pero no teníamos a mano los datos de acceso ni sabíamos si estaba disponible para los tres. Dejamos Docker con Oracle 11g XE como plan B, que además nos servía para repetir la ejecución en cualquier computador.

Al final repartimos el trabajo. Juan Pablo se encargó de revisar el DDL y los tipos; Miguel del DML y las pruebas; Jhoan de las consultas y la documentación. Igual quedamos en que todos revisamos todo antes de subir.

## 4. Dificultades identificadas

* El repositorio llevaba casi un mes sin avances en la parte de implementación y el tiempo hasta la entrega era corto.
* El DDL exportado no incluía las restricciones de negocio que habíamos definido en el MR.
* No teníamos claro el acceso al servidor Oracle de la universidad.
* Coordinar horarios en noviembre fue difícil por parciales y trabajos de otras materias.

## 5. Acuerdos y compromisos

| Responsable    | Compromiso                                                                                | Fecha límite              |
| -------------- | ----------------------------------------------------------------------------------------- | ------------------------- |
| **Juan Pablo** | Revisar el DDL exportado, los tipos y los nombres; dejar el DDL base listo.               | 8 de noviembre de 2026    |
| **Miguel**     | Diseñar el DML con datos suficientes para los tres reportes y probar las restricciones.   | 15 de noviembre de 2026   |
| **Jhoan**      | Revisar el enunciado, plantear las consultas DQL y actualizar la documentación.            | 15 de noviembre de 2026   |
| **Los tres**   | No modificar el MER ni el MR salvo que sea estrictamente necesario y registrar el uso de IAg. | Permanente                |

## 6. Aspectos definidos

* Alcance completo de la Entrega 3.
* Orden de ejecución de los scripts: DDL, DML, PL/SQL y DQL.
* Restricciones que se agregarán al DDL sin cambiar el modelo.
* Docker con Oracle 11g XE como entorno alterno.
* Distribución inicial de tareas.

## 7. Resultado

Quedó armado el plan de trabajo de noviembre y revisado el DDL base. Nos fuimos con la sensación de que había bastante por hacer, pero esta vez con una lista concreta y con el modelo ya cerrado, que era lo que más nos preocupaba.

## 8. Próxima reunión

El miércoles 11 de noviembre de 2026, de forma virtual, para revisar el DDL con las restricciones y el avance del DML.
