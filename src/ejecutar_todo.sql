-- ==========================================================================
-- RUMBEA - Script maestro de la Entrega 3
--
-- En SQL Developer: File > Open este archivo (no copiar y pegar, porque las
-- rutas @@ son relativas a el), elegir la conexion y pulsar F5.
--
-- NO borra nada. Si ya existen objetos con esos nombres se detiene. Para
-- repetir desde cero, correr antes DDL/rumbea_limpieza.sql.
-- ==========================================================================
SET ECHO OFF
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT [0/5] Version de Oracle
COLUMN product FORMAT A50
COLUMN version FORMAT A14
SELECT product, version FROM product_component_version;

PROMPT [1/5] DDL
@@DDL/rumbea_ddl.sql

PROMPT [2/5] DML
@@DML/rumbea_dml.sql

PROMPT [3/5] PL/SQL
@@PL-SQL/rumbea_plsql.sql

PROMPT [4/5] Pruebas
@@PL-SQL/rumbea_pruebas.sql

PROMPT [5/5] Reportes
@@DQL/rumbea_dql.sql

PROMPT FIN: ejecucion completa.
