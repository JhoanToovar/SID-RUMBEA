# SID-RUMBEA

## Guía de ejecución en SQL Developer

## 1. Entorno

Se usa Oracle 11g XE local en Docker. Es la versión para la que Data Modeler exportó el DDL y no requiere el servidor de la universidad. La última ejecución está en [la evidencia](./evidencias/ejecucion_oracle11g.txt).

**Crear la base (una sola vez por computador)**, con Docker Desktop abierto, en una sola línea y eligiendo las dos contraseñas:

```text
docker run -d --name rumbea-oracle -p 127.0.0.1:1521:1521 -e TZ=America/Bogota -e ORACLE_PASSWORD=<clave_admin> -e APP_USER=rumbea -e APP_USER_PASSWORD=<clave_rumbea> gvenzl/oracle-xe:11-slim
```

**Las siguientes veces:** `docker start rumbea-oracle` y esperar cerca de un minuto.

**Conexión en SQL Developer:**

| Campo | Valor |
| --- | --- |
| Usuario | `rumbea` |
| Contraseña | La elegida al crear la base. Se consulta con `docker exec rumbea-oracle printenv APP_USER_PASSWORD` |
| Host | `localhost` |
| Puerto | `1521` |
| SID | `XE` |

Los scripts sirven también en otro Oracle 11g R2 o superior con permisos para crear tablas, secuencias, procedimientos y triggers, pero solo se probaron en 11g XE. No guardar contraseñas en el repositorio.

## 2. Ejecutar todo

1. `File > Open` y abrir `src/ejecutar_todo.sql`. No copiar y pegar: las rutas son relativas al archivo.
2. Elegir la conexión arriba a la derecha.
3. Pulsar **F5** (Run Script), no Ctrl+Enter.
4. Guardar la salida de *Script Output* como evidencia.

| Paso | Script | Resultado esperado |
| --- | --- | --- |
| 1 | `DDL/rumbea_ddl.sql` | 18 tablas |
| 2 | `DML/rumbea_dml.sql` | 1080 filas |
| 3 | `PL-SQL/rumbea_plsql.sql` | Función, procedimiento y trigger sin errores |
| 4 | `PL-SQL/rumbea_pruebas.sql` | `RESULTADO: 24 correctas, 0 fallidas` |
| 5 | `DQL/rumbea_dql.sql` | 7 consultas con 14, 15, 12, 14, 10, 14 y 10 filas |

Al final debe aparecer `FIN: ejecucion completa.`

El DML va antes del PL/SQL: el historial tiene fechas pasadas y el trigger las reemplazaría por la fecha actual.

`DDL/DDLProyecto.ddl` es la exportación original de Data Modeler. **No se ejecuta**, queda como referencia.

## 3. Repetir desde cero

Ejecutar con F5 `src/DDL/rumbea_limpieza.sql` y luego otra vez el maestro.

**La limpieza borra las tablas de Rumbea y sus datos.** Solo borra tablas marcadas con el comentario `RUMBEA - ...`.

## 4. Problemas comunes

| Mensaje | Causa y solución |
| --- | --- |
| `ORA-20100` | Ya hay objetos con esos nombres. Si son de Rumbea, correr la limpieza. |
| `ORA-20101` | Hay una tabla de otra práctica con el mismo nombre. No se borró nada. Revisarla a mano. |
| `ORA-20102` | Un objeto PL/SQL no compiló. Revisar `SHOW ERRORS`. |
| `ORA-20103` | Falló una prueba. Buscar `[FALLA]` en la salida. |
| La conexión es rechazada | Docker está cerrado o el contenedor detenido: `docker start rumbea-oracle`. |
| `ORA-01031` | Falta un privilegio. Pedirlo al administrador del servidor. |
| `SP2-0310` | No encontró un archivo. Abrir el maestro con `File > Open`. |
| La conexión se cierra tras un error | Es intencional (`WHENEVER SQLERROR EXIT`). Reconectar. |

## 5. Demostración para la sustentación

```sql
SET SERVEROUTPUT ON

-- Funcion
SELECT FN_RUMBEA_PROMEDIO_SEDE('SED01') AS promedio FROM dual;

-- Procedimiento, que dispara el trigger
SELECT id, capacity FROM BRANCHS WHERE id = 'SED01';

DECLARE
  v_id VARCHAR2(40);
BEGIN
  PR_RUMBEA_ACTUALIZAR_SEDE(p_user_id => 'ADM01', p_branch_id => 'SED01',
                            p_new_capacity => 180, p_update_id => v_id);
  DBMS_OUTPUT.PUT_LINE('Actualizacion: ' || v_id);
END;
/

SELECT id, capacity FROM BRANCHS WHERE id = 'SED01';
COLUMN id FORMAT A12
COLUMN autor FORMAT A10
SELECT id, TO_CHAR("date", 'YYYY-MM-DD HH24:MI') AS fecha, newCapacity,
       COALESCE(ADMIN_id, ESTABLISHMENT_OWNER_id) AS autor
FROM BRANCH_UPDATES
WHERE BRANCH_id = 'SED01';

-- Dejar los datos como estaban
ROLLBACK;
```
