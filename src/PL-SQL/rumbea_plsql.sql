-- ==========================================================================
-- RUMBEA - Entrega 3 - PL/SQL
-- Requiere: DDL y DML, en ese orden. Oracle 11g R2 o superior.
--
--   Funcion        FN_RUMBEA_PROMEDIO_SEDE    calificacion de una sede (HU17)
--   Procedimiento  PR_RUMBEA_ACTUALIZAR_SEDE  registra un cambio de sede (HU8)
--   Trigger        TRG_RUMBEA_BRANCH_UPDATE   autoriza y aplica el cambio (HU8)
--   Secuencia      RUMBEA_UPDATE_SEQ          apoyo para el id del historial
--
-- Flujo de una actualizacion:
--   procedimiento -> INSERT en BRANCH_UPDATES -> trigger -> UPDATE de BRANCHS
--
-- La autorizacion vive en el trigger para que tambien se cumpla cuando alguien
-- inserta directamente, sin pasar por el procedimiento.
--
-- Codigos de error:
--   -20001  la sede no existe (funcion)
--   -20011  el usuario no existe
--   -20012  el rol no puede actualizar sedes
--   -20020  debe haber exactamente un autor
--   -20021  la actualizacion no trae cambios
--   -20022  la sede no existe (trigger)
--   -20023  el dueno no es dueno de esa sede
--   -20024  el admin no esta activo o no esta asignado a esa sede
-- ==========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

-- ==========================================================================
-- SECUENCIA DE APOYO
-- El MR usa ids VARCHAR2(10). El procedimiento arma 'BUP' mas 7 digitos.
-- Una secuencia evita el choque de dos sesiones que tendria un MAX(id) + 1.
-- ==========================================================================
DECLARE
  v_total PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_total
  FROM user_sequences
  WHERE sequence_name = 'RUMBEA_UPDATE_SEQ';

  IF v_total = 0 THEN
    EXECUTE IMMEDIATE
      'CREATE SEQUENCE RUMBEA_UPDATE_SEQ START WITH 1 INCREMENT BY 1 MAXVALUE 9999999 NOCACHE';
  END IF;
END;
/

-- ==========================================================================
-- FUNCION FN_RUMBEA_PROMEDIO_SEDE
-- Funcionalidad: calcula el promedio de estrellas de una sede.
-- Se invoca:     desde una consulta o un bloque, al mostrar el perfil.
-- Entrada:       p_branch_id, id de la sede.
-- Retorna:       promedio a 2 decimales, o NULL si no hay resenas. No retorna
--                0 porque se leeria como una mala calificacion.
-- Errores:       -20001 si la sede no existe.
-- Efectos:       ninguno, solo lee.
-- Ejemplo:       SELECT FN_RUMBEA_PROMEDIO_SEDE('SED01') FROM dual
-- ==========================================================================
CREATE OR REPLACE FUNCTION FN_RUMBEA_PROMEDIO_SEDE (
  p_branch_id IN BRANCHS.id%TYPE
) RETURN NUMBER
IS
  v_existe   PLS_INTEGER;
  v_promedio NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_existe
  FROM BRANCHS
  WHERE id = p_branch_id;

  IF v_existe = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'No existe la sede ' || p_branch_id);
  END IF;

  SELECT ROUND(AVG(rating), 2) INTO v_promedio
  FROM REVIEWS
  WHERE BRANCH_id = p_branch_id;

  RETURN v_promedio;
END FN_RUMBEA_PROMEDIO_SEDE;
/
SHOW ERRORS

-- ==========================================================================
-- TRIGGER TRG_RUMBEA_BRANCH_UPDATE
-- Funcionalidad: mantiene la sede al dia y protege quien puede cambiarla.
-- Se ejecuta:    antes de cada fila insertada en BRANCH_UPDATES.
-- Operaciones:
--   1. exige un unico autor y al menos un cambio
--   2. dueno: debe serlo del establecimiento de la sede
--      admin: debe estar ACTIVO y asignado a esa sede
--   3. pone la fecha del servidor, para que nadie registre fechas falsas
--   4. copia a BRANCHS solo los campos que cambiaron
-- Por que un trigger: un CHECK no puede consultar otras tablas.
-- Atomicidad:    si el INSERT falla, Oracle deshace tambien el UPDATE.
-- Nota:          el historial del DML se carga antes de crear este trigger.
-- ==========================================================================
CREATE OR REPLACE TRIGGER TRG_RUMBEA_BRANCH_UPDATE
BEFORE INSERT ON BRANCH_UPDATES
FOR EACH ROW
DECLARE
  v_dueno      ESTABLISHMENTS.ESTABLISHMENT_OWNER_id%TYPE;
  v_autorizado PLS_INTEGER;
BEGIN
  IF (:NEW.ADMIN_id IS NULL AND :NEW.ESTABLISHMENT_OWNER_id IS NULL)
     OR (:NEW.ADMIN_id IS NOT NULL AND :NEW.ESTABLISHMENT_OWNER_id IS NOT NULL) THEN
    RAISE_APPLICATION_ERROR(-20020, 'Debe haber exactamente un autor: dueno o administrador');
  END IF;

  IF :NEW.newCapacity IS NULL AND :NEW.newCover IS NULL
     AND :NEW.newDescription IS NULL AND :NEW.newLocation IS NULL THEN
    RAISE_APPLICATION_ERROR(-20021, 'La actualizacion debe cambiar al menos un campo');
  END IF;

  BEGIN
    SELECT e.ESTABLISHMENT_OWNER_id INTO v_dueno
    FROM BRANCHS b
    INNER JOIN ESTABLISHMENTS e ON e.id = b.ESTABLISHMENT_id
    WHERE b.id = :NEW.BRANCH_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20022, 'No existe la sede ' || :NEW.BRANCH_id);
  END;

  IF :NEW.ESTABLISHMENT_OWNER_id IS NOT NULL THEN
    IF :NEW.ESTABLISHMENT_OWNER_id <> v_dueno THEN
      RAISE_APPLICATION_ERROR(-20023, 'El dueno no es dueno de esta sede');
    END IF;
  ELSE
    SELECT COUNT(*) INTO v_autorizado
    FROM ADMINS
    WHERE id = :NEW.ADMIN_id
      AND BRANCH_id = :NEW.BRANCH_id
      AND UPPER(stateActive) = 'ACTIVO';

    IF v_autorizado = 0 THEN
      RAISE_APPLICATION_ERROR(-20024, 'El administrador no esta activo o no esta asignado a esta sede');
    END IF;
  END IF;

  :NEW."date" := SYSDATE;

  UPDATE BRANCHS
  SET capacity    = NVL(:NEW.newCapacity, capacity),
      cover       = NVL(:NEW.newCover, cover),
      description = NVL(:NEW.newDescription, description),
      location    = NVL(:NEW.newLocation, location)
  WHERE id = :NEW.BRANCH_id;
END TRG_RUMBEA_BRANCH_UPDATE;
/
SHOW ERRORS

-- ==========================================================================
-- PROCEDIMIENTO PR_RUMBEA_ACTUALIZAR_SEDE
-- Funcionalidad: permite a un dueno o admin cambiar aforo, cover, descripcion
--                o direccion de una sede, dejando historial.
-- Se invoca:     cuando el usuario guarda cambios en el perfil de la sede.
-- Entradas:      p_user_id, p_branch_id y los valores nuevos (NULL no cambia).
-- Salida:        p_update_id, id del registro creado en el historial.
-- Operaciones:   busca el rol, llena el lado correcto del arco e inserta. El
--                trigger valida permisos y actualiza la sede.
-- Errores:       -20011, -20012, los del trigger y los CHECK de las tablas.
-- Transaccion:   no hace COMMIT, lo decide quien lo llama.
-- ==========================================================================
CREATE OR REPLACE PROCEDURE PR_RUMBEA_ACTUALIZAR_SEDE (
  p_user_id         IN  USERS.id%TYPE,
  p_branch_id       IN  BRANCHS.id%TYPE,
  p_new_capacity    IN  BRANCH_UPDATES.newCapacity%TYPE    DEFAULT NULL,
  p_new_cover       IN  BRANCH_UPDATES.newCover%TYPE       DEFAULT NULL,
  p_new_description IN  BRANCH_UPDATES.newDescription%TYPE DEFAULT NULL,
  p_new_location    IN  BRANCH_UPDATES.newLocation%TYPE    DEFAULT NULL,
  p_update_id       OUT BRANCH_UPDATES.id%TYPE
)
IS
  v_rol      USERS.role%TYPE;
  v_admin_id BRANCH_UPDATES.ADMIN_id%TYPE;
  v_owner_id BRANCH_UPDATES.ESTABLISHMENT_OWNER_id%TYPE;
  v_id       BRANCH_UPDATES.id%TYPE;
BEGIN
  BEGIN
    SELECT u.role INTO v_rol
    FROM USERS u
    WHERE u.id = p_user_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20011, 'No existe el usuario ' || p_user_id);
  END;

  IF v_rol = 'ADMIN' THEN
    v_admin_id := p_user_id;
  ELSIF v_rol = 'OWNER' THEN
    v_owner_id := p_user_id;
  ELSE
    RAISE_APPLICATION_ERROR(-20012, 'Solo un dueno o administrador puede actualizar sedes');
  END IF;

  SELECT 'BUP' || LPAD(TO_CHAR(RUMBEA_UPDATE_SEQ.NEXTVAL), 7, '0') INTO v_id
  FROM dual;

  INSERT INTO BRANCH_UPDATES (
    id, "date", newCapacity, newCover, BRANCH_id,
    newDescription, newLocation, ADMIN_id, ESTABLISHMENT_OWNER_id
  ) VALUES (
    v_id, SYSDATE, p_new_capacity, p_new_cover, p_branch_id,
    p_new_description, p_new_location, v_admin_id, v_owner_id
  );

  p_update_id := v_id;
END PR_RUMBEA_ACTUALIZAR_SEDE;
/
SHOW ERRORS

-- Un error de compilacion no detiene un script por si solo, se verifica aqui
DECLARE
  v_validos PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_validos
  FROM user_objects
  WHERE status = 'VALID'
    AND object_name IN ('FN_RUMBEA_PROMEDIO_SEDE',
                        'PR_RUMBEA_ACTUALIZAR_SEDE',
                        'TRG_RUMBEA_BRANCH_UPDATE');

  IF v_validos <> 3 THEN
    RAISE_APPLICATION_ERROR(-20102, 'Hay objetos PL/SQL invalidos. Revise SHOW ERRORS');
  END IF;
END;
/
PROMPT PL/SQL de Rumbea compilado.
