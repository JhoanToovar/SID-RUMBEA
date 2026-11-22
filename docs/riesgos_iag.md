# SID-RUMBEA

## Riesgos del uso de IAg en bases de datos en un contexto profesional

## 1. Alcance

La Entrega 3 permite el uso completo de IAg (nivel 4), con uso crítico y justificado. En esta entrega se consultó a Claude como apoyo de revisión: para contrastar el alcance, resolver dudas puntuales de Oracle 11g y revisar decisiones sobre el DDL exportado de Data Modeler. Los scripts y la documentación los redactó el equipo.

Este documento analiza qué puede salir mal al hacer lo mismo en una empresa. Cuando aplica, usa como evidencia lo ocurrido en este proyecto.

## 2. Matriz de riesgos

| N.º | Riesgo | Probabilidad | Impacto | Control principal |
| --- | --- | --- | --- | --- |
| 1 | SQL válido que responde otra pregunta | Alta | Alto | Casos con resultado conocido |
| 2 | Requisitos inventados o reinterpretados | Alta | Alto | Trazabilidad y aprobación humana |
| 3 | Afirmaciones incorrectas dichas con seguridad | Alta | Medio | Contrastar con la fuente |
| 4 | Falsa sensación de "ya está probado" | Media | Alto | Ejecutar en el motor real |
| 5 | Operaciones destructivas | Media | Crítico | Mínimo privilegio y scripts protegidos |
| 6 | Fuga de datos y credenciales | Media | Crítico | No compartir secretos ni datos reales |
| 7 | Vulnerabilidades en el código | Media | Alto | Revisión de seguridad |
| 8 | Instrucciones ocultas en documentos | Baja | Alto | Aprobar cada acción sensible |
| 9 | Mal rendimiento con volumen real | Media | Medio | Planes de ejecución |
| 10 | Datos de prueba sesgados | Alta | Medio | Diseñar casos límite |
| 11 | Pérdida de comprensión del equipo | Alta | Alto | Explicar el código sin la herramienta |
| 12 | Autoría, licencias y responsabilidad | Media | Medio | Registrar el uso y revisar políticas |

## 3. Detalle

### 1. SQL válido que responde otra pregunta
Una consulta puede ejecutar sin error y dar un número falso. Si en Q7 se unieran las reseñas directamente con los géneros, cada reseña se contaría una vez por género coincidente. En Q3, un `COUNT(*)` mostraría 1 favorito donde hay 0.
**Control:** agregar antes de unir y comprobar contra casos calculados a mano.

### 2. Requisitos inventados o reinterpretados
El R2 pedía contar "recordar evento" y el MR no guarda ese dato. Al consultarle, la IA propuso crear una tabla y el equipo decidió no cambiar el modelo. Habría sido fácil renombrar un conteo de favoritos como "recordatorios" y entregar un reporte falso.
**Control:** Q4 se llama *audiencia potencial* y la diferencia está documentada.

### 3. Afirmaciones incorrectas dichas con seguridad
Al leer solo el PDF del MR, la IA señaló un posible error en el tipo de `role` y varios nombres demasiado largos para versiones antiguas de Oracle. El DDL mostró que ninguno de los dos problemas existía.
**Control:** validar contra el artefacto fuente antes de corregir.

### 4. Falsa sensación de "ya está probado"
El equipo validó la sintaxis con el parser de SQL Developer y los datos con una réplica en SQLite, y la IA advirtió que eso no compila PL/SQL ni reproduce Oracle: por ejemplo, SQLite y Oracle concatenan `NULL` de forma distinta.
**Control:** no se dieron por probados los scripts hasta ejecutar `ejecutar_todo.sql` en un Oracle 11g real ([evidencia](./evidencias/ejecucion_oracle11g.txt)).

### 5. Operaciones destructivas
Un `DROP` generado para "empezar limpio" puede borrar el trabajo de otros. Un esquema de estudiante suele reutilizarse para varias prácticas y nombres como `USERS` o `CLIENTS` se repiten.
**Control:** la limpieza es manual, verifica una marca en cada tabla y no usa `CASCADE CONSTRAINTS`.

### 6. Fuga de datos y credenciales
Lo que se pega o lo que una herramienta lee se envía a un proveedor externo. Una herramienta con acceso al disco también puede leer fuera del repositorio; por eso aquí se limitó su uso a consultas puntuales y no se le dio acceso autónomo a carpetas con información sensible. En una empresa, esto puede incumplir la Ley 1581 de 2012 de protección de datos y los contratos con clientes.
**Control:** datos ficticios, credenciales fuera del chat y carpetas de acceso limitadas.

### 7. Vulnerabilidades en el código
La IA puede sugerir SQL dinámico inyectable, permisos excesivos o contraseñas en texto plano.
**Control:** procedimiento con parámetros tipados y SQL estático, y autorización en el trigger. En producción faltaría guardar hashes y autenticar al usuario, porque el procedimiento confía en el id que recibe.

### 8. Instrucciones ocultas en documentos
Un PDF, un issue o un comentario puede contener texto que el agente interprete como una orden.
**Control:** tratar los documentos como datos y aprobar commits, envíos y borrados.

### 9. Mal rendimiento con volumen real
Con mil filas todo es rápido. Con millones, filtrar `REVIEWS` por sede sin índice puede recorrer la tabla completa.
**Control:** revisar `EXPLAIN PLAN` e indexar las FK que más se consultan antes de producción.

### 10. Datos de prueba sesgados
Quien genera el código y los datos tiende a fabricar datos que le dan la razón. En la primera versión del DML, todos los clientes que reseñaron la sede de prueba la tenían como favorita, y el `OUTER JOIN` de Q2 no demostraba nada. Se detectó al mirar las filas, no por un error.
**Control:** incluir ceros, nulos, empates y casos rechazados.

### 11. Pérdida de comprensión del equipo
Se puede entregar código que nadie sabe defender ni mantener.
**Control:** cada integrante debe poder explicar el arco, las FK compuestas, el trigger y cada consulta.

### 12. Autoría, licencias y responsabilidad
El código sugerido o revisado con IA puede parecerse a código con licencia y el proveedor no responde por sus errores.
**Control:** seguir la política de la organización y registrar el uso en la [bitácora de prompts](./bitacora_prompts.md). Responde quien aprueba y entrega.

## 4. Decisión técnica que hubo que validar

**Pregunta:** ¿cambiar el MR para soportar por completo R1 y R2, o mantenerlo?

- **Propuesta de la IA:** una tabla de recordatorios y una PK propia para las visitas.
- **Decisión del equipo:** no tocar el modelo.
- **Consecuencia:** R1 y R2 tienen un alcance menor, declarado en [reportes y decisiones](./reportes_y_decisiones.md).

La IA puede mostrar alternativas y costos, pero el alcance lo decide quien responde por el proyecto.

## 5. Conclusión

La IAg ayuda a revisar, contrastar y resolver dudas, pero no reemplaza el criterio ni la escritura del equipo. En un contexto profesional debe usarse con mínimo privilegio, datos no sensibles, pruebas en el motor real y una persona responsable que entienda cada cambio.
