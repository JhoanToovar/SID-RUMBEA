-- ==========================================================================
-- RUMBEA - Limpieza del esquema
--
-- ATENCION: BORRA las tablas de Rumbea y todos sus datos.
-- No lo llama ejecutar_todo.sql, se corre a mano para volver a empezar.
--
-- Proteccion: el esquema de la universidad tambien se usa para practicas. Si
-- una tabla se llama igual pero no tiene el comentario "RUMBEA - ...", el script
-- se detiene sin borrar nada. No usa CASCADE CONSTRAINTS.
-- ==========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

DECLARE
  TYPE t_nombres IS TABLE OF VARCHAR2(30);
  -- Hijas primero, padres al final
  v_tablas t_nombres := t_nombres(
    'CLIENT_EVENT_REMINDERS',
    'BRANCH_EVENTS', 'BRANCH_MUSIC_GENRES', 'BRANCH_SCHEDULES',
    'BRANCH_TYPES', 'BRANCH_UPDATES', 'LINK_OF_INTERESTS',
    'CLIENT_MUSIC_PREFERENCES', 'FAVORITES', 'REVIEWS',
    'VISIT_PROFILES', 'EVENTS', 'ADMINS',
    'BRANCHS', 'ESTABLISHMENTS', 'MUSIC_GENRES',
    'CLIENTS', 'ESTABLISHMENT_OWNERS', 'USERS');
  v_total   PLS_INTEGER;
  v_marcada PLS_INTEGER;
BEGIN
  -- Fase 1: validar todo antes del primer borrado
  FOR i IN 1 .. v_tablas.COUNT LOOP
    SELECT COUNT(*) INTO v_total FROM user_tables WHERE table_name = v_tablas(i);
    SELECT COUNT(*) INTO v_marcada FROM user_tab_comments
    WHERE table_name = v_tablas(i) AND comments LIKE 'RUMBEA - %';
    IF v_total > 0 AND v_marcada = 0 THEN
      RAISE_APPLICATION_ERROR(-20101,
        'La tabla ' || v_tablas(i) || ' no es de Rumbea. No se borro nada.');
    END IF;
  END LOOP;

  -- Fase 2: borrar (los triggers se van con su tabla)
  FOR i IN 1 .. v_tablas.COUNT LOOP
    SELECT COUNT(*) INTO v_total FROM user_tables WHERE table_name = v_tablas(i);
    IF v_total > 0 THEN
      EXECUTE IMMEDIATE 'DROP TABLE ' || v_tablas(i) || ' PURGE';
      DBMS_OUTPUT.PUT_LINE('Eliminada: ' || v_tablas(i));
    END IF;
  END LOOP;

  FOR r IN (SELECT object_type, object_name FROM user_objects
            WHERE (object_type = 'FUNCTION'  AND object_name = 'FN_RUMBEA_PROMEDIO_SEDE')
               OR (object_type = 'PROCEDURE' AND object_name = 'PR_RUMBEA_ACTUALIZAR_SEDE')
               OR (object_type = 'SEQUENCE'  AND object_name = 'RUMBEA_UPDATE_SEQ')) LOOP
    EXECUTE IMMEDIATE 'DROP ' || r.object_type || ' ' || r.object_name;
    DBMS_OUTPUT.PUT_LINE('Eliminado: ' || r.object_name);
  END LOOP;
END;
/
