-- ==========================================================================
-- RUMBEA - Pruebas de PL/SQL y de restricciones
-- Requiere: DDL, DML y PL/SQL.
--
-- Cada linea sale como [OK] o [FALLA]. Los cambios se deshacen con savepoints,
-- por lo que los datos de los reportes quedan intactos.
-- ==========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

DECLARE
  v_ok        PLS_INTEGER := 0;
  v_fallas    PLS_INTEGER := 0;
  v_id        BRANCH_UPDATES.id%TYPE;
  v_antes     BRANCHS%ROWTYPE;
  v_despues   BRANCHS%ROWTYPE;
  v_historial BRANCH_UPDATES%ROWTYPE;
  v_esperado  NUMBER;

  PROCEDURE verificar (p_caso IN VARCHAR2, p_cumple IN BOOLEAN) IS
  BEGIN
    IF p_cumple THEN
      v_ok := v_ok + 1;
      DBMS_OUTPUT.PUT_LINE('[OK]    ' || p_caso);
    ELSE
      v_fallas := v_fallas + 1;
      DBMS_OUTPUT.PUT_LINE('[FALLA] ' || p_caso);
    END IF;
  END verificar;

  -- Ejecuta algo que debe fallar con un codigo exacto
  PROCEDURE espera_error (p_caso IN VARCHAR2, p_codigo IN NUMBER, p_sql IN VARCHAR2) IS
    v_codigo NUMBER := 0;
  BEGIN
    SAVEPOINT caso_negativo;
    BEGIN
      EXECUTE IMMEDIATE p_sql;
    EXCEPTION
      WHEN OTHERS THEN
        v_codigo := SQLCODE;
    END;
    ROLLBACK TO caso_negativo;
    verificar(p_caso || ' (esperado ' || p_codigo || ', obtenido ' || v_codigo || ')',
              v_codigo = p_codigo);
  END espera_error;

BEGIN
  SAVEPOINT inicio_pruebas;

  DBMS_OUTPUT.PUT_LINE('--- Funcion ---');
  SELECT ROUND(AVG(rating), 2) INTO v_esperado FROM REVIEWS WHERE BRANCH_id = 'SED01';
  verificar('promedio de SED01 = ' || v_esperado,
            FN_RUMBEA_PROMEDIO_SEDE('SED01') = v_esperado);
  verificar('sede sin resenas retorna NULL',
            FN_RUMBEA_PROMEDIO_SEDE('SED16') IS NULL);
  espera_error('sede inexistente', -20001,
    q'[DECLARE n NUMBER; BEGIN n := FN_RUMBEA_PROMEDIO_SEDE('NOEXISTE'); END;]');

  DBMS_OUTPUT.PUT_LINE('--- Procedimiento y trigger: casos validos ---');
  SELECT * INTO v_antes FROM BRANCHS WHERE id = 'SED01';
  PR_RUMBEA_ACTUALIZAR_SEDE(p_user_id => 'OWN01', p_branch_id => 'SED01',
                            p_new_capacity => 77, p_update_id => v_id);
  SELECT * INTO v_despues FROM BRANCHS WHERE id = 'SED01';
  SELECT * INTO v_historial FROM BRANCH_UPDATES WHERE id = v_id;
  verificar('dueno cambia el aforo', v_despues.capacity = 77);
  verificar('lo que no se envia no cambia',
            v_despues.cover = v_antes.cover
            AND v_despues.description = v_antes.description
            AND v_despues.location = v_antes.location);
  verificar('el historial registra solo al dueno',
            v_historial.ESTABLISHMENT_OWNER_id = 'OWN01' AND v_historial.ADMIN_id IS NULL);

  PR_RUMBEA_ACTUALIZAR_SEDE(p_user_id => 'ADM01', p_branch_id => 'SED01',
                            p_new_cover => 0, p_new_description => 'Noche de entrada libre',
                            p_update_id => v_id);
  SELECT * INTO v_despues FROM BRANCHS WHERE id = 'SED01';
  SELECT * INTO v_historial FROM BRANCH_UPDATES WHERE id = v_id;
  verificar('admin cambia cover y descripcion',
            v_despues.cover = 0 AND v_despues.description = 'Noche de entrada libre');
  verificar('el historial registra solo al admin',
            v_historial.ADMIN_id = 'ADM01' AND v_historial.ESTABLISHMENT_OWNER_id IS NULL);
  ROLLBACK TO inicio_pruebas;

  DBMS_OUTPUT.PUT_LINE('--- Procedimiento y trigger: casos rechazados ---');
  espera_error('usuario inexistente', -20011,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('NADIE','SED01',5,NULL,NULL,NULL,x); END;]');
  espera_error('cliente no actualiza sedes', -20012,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('CLI001','SED01',5,NULL,NULL,NULL,x); END;]');
  espera_error('actualizacion sin cambios', -20021,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('OWN01','SED01',NULL,NULL,NULL,NULL,x); END;]');
  espera_error('sede inexistente', -20022,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('OWN01','NOEXISTE',5,NULL,NULL,NULL,x); END;]');
  espera_error('dueno de otra sede', -20023,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('OWN02','SED01',5,NULL,NULL,NULL,x); END;]');
  espera_error('admin de otra sede', -20024,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('ADM02','SED01',5,NULL,NULL,NULL,x); END;]');
  espera_error('admin inactivo', -20024,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('ADM14','SED14',5,NULL,NULL,NULL,x); END;]');
  espera_error('INSERT directo con dos autores', -20020,
    q'[INSERT INTO BRANCH_UPDATES (id, "date", newCapacity, BRANCH_id, ADMIN_id, ESTABLISHMENT_OWNER_id) VALUES ('TEST', SYSDATE, 5, 'SED01', 'ADM01', 'OWN01')]');
  espera_error('aforo negativo', -2290,
    q'[DECLARE x VARCHAR2(10); BEGIN PR_RUMBEA_ACTUALIZAR_SEDE('OWN01','SED01',-5,NULL,NULL,NULL,x); END;]');

  DBMS_OUTPUT.PUT_LINE('--- Restricciones del DDL ---');
  espera_error('rating fuera de 1 a 5', -2290,
    q'[INSERT INTO REVIEWS (id, text, rating, "date", BRANCH_id, CLIENT_id) VALUES ('TEST', 'x', 6, SYSDATE, 'SED01', 'CLI001')]');
  espera_error('cover negativo', -2290,
    q'[UPDATE BRANCHS SET cover = -1 WHERE id = 'SED01']');
  espera_error('cover especial negativo', -2290,
    q'[UPDATE EVENTS SET specialCover = -1 WHERE id = 'EVT01']');
  espera_error('un dueno no puede ser cliente', -2291,
    q'[INSERT INTO CLIENTS (id) VALUES ('OWN01')]');
  espera_error('evento en sede de otro establecimiento', -2291,
    q'[INSERT INTO BRANCH_EVENTS (BRANCH_id, EVENT_id, ESTABLISHMENT_id) VALUES ('SED20', 'EVT01', 'EST01')]');
  espera_error('segundo tipo para una sede', -1,
    q'[INSERT INTO BRANCH_TYPES (id, type, BRANCH_id) VALUES ('TEST', 'Bar', 'SED01')]');
  espera_error('segundo horario el mismo dia', -1,
    q'[INSERT INTO BRANCH_SCHEDULES (id, dayOfWeek, openTime, closeTime, BRANCH_id) VALUES ('TEST', 'JUEVES', '18:00', '23:00', 'SED01')]');

  DBMS_OUTPUT.PUT_LINE('--- Correcciones [E3-R] ---');
  espera_error('estado de admin distinto de ACTIVO/INACTIVO', -2290,
    q'[UPDATE ADMINS SET stateActive = 'SI' WHERE id = 'ADM01']');
  espera_error('hora de acceso invalida', -2290,
    q'[INSERT INTO VISIT_PROFILES (id, visitDate, visitTimeIn, interactionSeconds, CLIENT_id, BRANCH_id) VALUES ('TEST', SYSDATE, 2475, 30, 'CLI001', 'SED01')]');
  espera_error('tiempo de interaccion en cero', -2290,
    q'[INSERT INTO VISIT_PROFILES (id, visitDate, visitTimeIn, interactionSeconds, CLIENT_id, BRANCH_id) VALUES ('TEST', SYSDATE, 2100, 0, 'CLI001', 'SED01')]');
  espera_error('recordatorio repetido del mismo evento', -1,
    q'[INSERT INTO CLIENT_EVENT_REMINDERS (CLIENT_id, EVENT_id, reminderDate) VALUES ('CLI001', 'EVT01', SYSDATE)]');
  espera_error('recordatorio de evento inexistente', -2291,
    q'[INSERT INTO CLIENT_EVENT_REMINDERS (CLIENT_id, EVENT_id, reminderDate) VALUES ('CLI001', 'NOEXISTE', SYSDATE)]');

  INSERT INTO VISIT_PROFILES (id, visitDate, visitTimeIn, interactionSeconds, CLIENT_id, BRANCH_id)
  VALUES ('TEST1', SYSDATE, 2100, 45, 'CLI001', 'SED01');
  INSERT INTO VISIT_PROFILES (id, visitDate, visitTimeIn, interactionSeconds, CLIENT_id, BRANCH_id)
  VALUES ('TEST2', SYSDATE, 2130, 60, 'CLI001', 'SED01');
  SELECT COUNT(*) INTO v_esperado FROM VISIT_PROFILES
  WHERE CLIENT_id = 'CLI001' AND BRANCH_id = 'SED01' AND id IN ('TEST1', 'TEST2');
  verificar('un cliente puede visitar varias veces la misma sede', v_esperado = 2);

  ROLLBACK TO inicio_pruebas;
  DBMS_OUTPUT.PUT_LINE('RESULTADO: ' || v_ok || ' correctas, ' || v_fallas || ' fallidas');

  IF v_fallas > 0 THEN
    RAISE_APPLICATION_ERROR(-20103, 'Hay pruebas fallidas');
  END IF;
END;
/
