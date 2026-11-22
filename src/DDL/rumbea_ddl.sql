-- ==========================================================================
-- RUMBEA - Entrega 3 - Script DDL
-- Motor: Oracle 11g Release 2 o superior
--
-- Origen: DDLProyecto.ddl, exportado de Data Modeler 24.3.1. Este script es la
--   version oficial: si el .ddl y este archivo difieren, manda este. Agrega:
--     * orden por modulo y documentacion de tablas, columnas y reglas
--     * 8 restricciones de negocio, marcadas con [E3]
--     * correcciones posteriores a la revision, marcadas con [E3-R]:
--         VISIT_PROFILES con id propio y tiempo de interaccion
--         tabla CLIENT_EVENT_REMINDERS para "recordar evento" (Reporte 2)
--         CHECK de stateActive y de la hora de acceso
--     * una verificacion previa para no chocar con otros objetos del esquema
--
-- Notas:
--   * "date" va entre comillas dobles y en minuscula por ser palabra reservada
--   * los textos van sin tildes para verse igual con cualquier codificacion
--   * ejecutar completo con F5 (Run Script)
-- ==========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

-- Verificacion previa: se detiene antes de crear algo si un nombre ya existe
DECLARE
  v_objetos       PLS_INTEGER;
  v_restricciones PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_objetos
  FROM user_objects
  WHERE object_name IN (
    'USERS', 'CLIENTS', 'ESTABLISHMENT_OWNERS',
    'ADMINS', 'ESTABLISHMENTS', 'BRANCHS',
    'BRANCH_TYPES', 'BRANCH_SCHEDULES', 'LINK_OF_INTERESTS',
    'BRANCH_UPDATES', 'MUSIC_GENRES', 'BRANCH_MUSIC_GENRES',
    'CLIENT_MUSIC_PREFERENCES', 'EVENTS', 'BRANCH_EVENTS',
    'FAVORITES', 'REVIEWS', 'VISIT_PROFILES', 'CLIENT_EVENT_REMINDERS',
    'RUMBEA_UPDATE_SEQ', 'FN_RUMBEA_PROMEDIO_SEDE', 'PR_RUMBEA_ACTUALIZAR_SEDE',
    'TRG_RUMBEA_BRANCH_UPDATE');

  SELECT COUNT(*) INTO v_restricciones
  FROM user_constraints
  WHERE constraint_name IN (
    'ADMINS_CK_1', 'ADMIN_PK', 'ADMINS__UN',
    'BRANCH_EVENT_PK', 'BRANCH_MUSIC_GENRE_PK', 'BRANCH_SCHEDULE_PK',
    'BRANCH_TYPE_PK', 'BRANCH_UPDATES_CK_1', 'BRANCH_UPDATE_PK',
    'BRANCH_PK', 'BRANCHS__UN', 'CLIENT_MUSIC_PREFERENCE_PK',
    'CLIENTS_CK_1', 'CLIENT_PK', 'ESTABLISHMENT_OWNERS_CK_1',
    'ESTABLISHMENT_OWNER_PK', 'ESTABLISHMENT_PK', 'EVENT_PK',
    'EVENTS__UN', 'FAVORITE_PK', 'LINK_OF_INTEREST_PK',
    'MUSIC_GENRE_PK', 'MUSIC_GENRE_NAME_UN', 'REVIEW_PK',
    'USERS_CK_1', 'USER_PK', 'USER_EMAIL_UN',
    'USERS_ID_ROLE_UN', 'VISIT_PROFILE_PK', 'ADMIN_BRANCH_FK',
    'ADMIN_USER_FK', 'BRANCH_ESTABLISHMENT_FK', 'BRANCH_EVENT_BRANCH_FK',
    'BRANCH_EVENT_EVENT_FK', 'BRANCH_MUSIC_GENRE_BRANCH_FK', 'BRANCH_MUSIC_GENRE_GENRE_FK',
    'BRANCH_SCHEDULE_BRANCH_FK', 'BRANCH_TYPES_BRANCHS_FK', 'BRANCH_UPDATE_ADMIN_FK',
    'BRANCH_UPDATE_BRANCH_FK', 'BRANCH_UPDATE_OWNER_FK', 'CLIENT_MUSIC_PREF_CLIENT_FK',
    'CLIENT_MUSIC_PREF_GENRE_FK', 'CLIENT_USER_FK', 'ESTABLISHMENT_OWNER_FK',
    'ESTABLISHMENT_OWNER_USER_FK', 'EVENTS_ESTABLISHMENTS_FK', 'FAVORITE_BRANCH_FK',
    'FAVORITE_CLIENT_FK', 'LINK_OF_INTEREST_BRANCH_FK', 'REVIEW_BRANCH_FK',
    'REVIEW_CLIENT_FK', 'VISIT_PROFILE_BRANCH_FK', 'VISIT_PROFILE_CLIENT_FK',
    'BRANCHS_CAPACITY_CK', 'BRANCHS_COVER_CK', 'BRANCH_UPDATES_CAPACITY_CK',
    'BRANCH_UPDATES_COVER_CK', 'EVENTS_SPECIAL_COVER_CK', 'REVIEWS_RATING_CK',
    'BRANCH_TYPES__UN', 'BRANCH_SCHEDULES_DAY_UN', 'ADMINS_STATE_CK',
    'VISIT_PROFILES_TIME_CK', 'VISIT_PROFILES_SECONDS_CK', 'CLIENT_EVENT_REMINDER_PK',
    'REMINDER_CLIENT_FK', 'REMINDER_EVENT_FK');

  IF v_objetos + v_restricciones > 0 THEN
    RAISE_APPLICATION_ERROR(-20100,
      'El esquema ya tiene objetos con nombres de Rumbea. Revise DDL/rumbea_limpieza.sql');
  END IF;
END;
/

-- ==========================================================================
-- 1. USUARIOS Y ROLES
-- ==========================================================================

-- USERS: Datos comunes de toda persona con cuenta (HU1 a HU4)
--   Regla: Supertipo de una especializacion total y disjunta
--   Regla: UNIQUE (id, role) permite que cada subtipo referencie el rol exacto
CREATE TABLE USERS
    (
     id           VARCHAR2 (10 CHAR)  NOT NULL ,
     name         VARCHAR2 (100 CHAR)  NOT NULL ,
     email        VARCHAR2 (100 CHAR)  NOT NULL ,
     password     VARCHAR2 (50 CHAR)  NOT NULL ,
     phoneNumber  VARCHAR2 (10 CHAR) ,
     creationDate DATE  NOT NULL ,
     role         VARCHAR2 (20 CHAR)  NOT NULL
    );

COMMENT ON TABLE USERS IS 'RUMBEA - Datos comunes de toda persona con cuenta (HU1 a HU4)';
COMMENT ON COLUMN USERS.id IS 'Identificador unico del usuario';
COMMENT ON COLUMN USERS.name IS 'Nombre completo';
COMMENT ON COLUMN USERS.email IS 'Correo de acceso, no se repite';
COMMENT ON COLUMN USERS.password IS 'Contrasena, en produccion debe guardarse su hash';
COMMENT ON COLUMN USERS.phoneNumber IS 'Telefono opcional';
COMMENT ON COLUMN USERS.creationDate IS 'Fecha de creacion de la cuenta';
COMMENT ON COLUMN USERS.role IS 'Rol unico: ADMIN, CLIENT u OWNER';

ALTER TABLE USERS
    ADD CONSTRAINT USERS_CK_1
    CHECK (role IN ('ADMIN','CLIENT','OWNER'));

ALTER TABLE USERS
    ADD CONSTRAINT USER_PK PRIMARY KEY ( id );

ALTER TABLE USERS
    ADD CONSTRAINT USER_email_UN UNIQUE ( email );

ALTER TABLE USERS
    ADD CONSTRAINT USERS_ID_ROLE_UN UNIQUE ( id , role );

-- CLIENTS: Usuarios que buscan sedes, opinan y guardan favoritos (HU1)
--   Regla: El CHECK de role y la FK (id, role) impiden que sea tambien dueno o admin
CREATE TABLE CLIENTS
    (
     id   VARCHAR2 (10 CHAR)  NOT NULL ,
     role VARCHAR2 (20 CHAR) DEFAULT 'CLIENT'  NOT NULL
    );

COMMENT ON TABLE CLIENTS IS 'RUMBEA - Usuarios que buscan sedes, opinan y guardan favoritos (HU1)';
COMMENT ON COLUMN CLIENTS.id IS 'Cliente, es el mismo id de USERS';
COMMENT ON COLUMN CLIENTS.role IS 'Siempre CLIENT';

ALTER TABLE CLIENTS
    ADD CONSTRAINT CLIENTS_CK_1
    CHECK (role = 'CLIENT');

ALTER TABLE CLIENTS
    ADD CONSTRAINT CLIENT_PK PRIMARY KEY ( id );

-- ESTABLISHMENT_OWNERS: Duenos de establecimientos (HU2)
--   Regla: El CHECK de role y la FK (id, role) impiden otro rol simultaneo
CREATE TABLE ESTABLISHMENT_OWNERS
    (
     id   VARCHAR2 (10 CHAR)  NOT NULL ,
     role VARCHAR2 (20 CHAR) DEFAULT 'OWNER'  NOT NULL
    );

COMMENT ON TABLE ESTABLISHMENT_OWNERS IS 'RUMBEA - Duenos de establecimientos (HU2)';
COMMENT ON COLUMN ESTABLISHMENT_OWNERS.id IS 'Dueno, es el mismo id de USERS';
COMMENT ON COLUMN ESTABLISHMENT_OWNERS.role IS 'Siempre OWNER';

ALTER TABLE ESTABLISHMENT_OWNERS
    ADD CONSTRAINT ESTABLISHMENT_OWNERS_CK_1
    CHECK (role = 'OWNER');

ALTER TABLE ESTABLISHMENT_OWNERS
    ADD CONSTRAINT ESTABLISHMENT_OWNER_PK PRIMARY KEY ( id );

-- ADMINS: Administradores, cada uno asignado a una sede (HU3)
--   Regla: Una sede tiene a lo sumo un administrador (UNIQUE BRANCH_id)
--   Regla: El CHECK de role y la FK (id, role) impiden otro rol simultaneo
CREATE TABLE ADMINS
    (
     id                 VARCHAR2 (10 CHAR)  NOT NULL ,
     stateActive        VARCHAR2 (20 CHAR)  NOT NULL ,
     lastConnectionDate DATE  NOT NULL ,
     BRANCH_id          VARCHAR2 (10 CHAR)  NOT NULL ,
     role               VARCHAR2 (20 CHAR) DEFAULT 'ADMIN'  NOT NULL
    );

COMMENT ON TABLE ADMINS IS 'RUMBEA - Administradores, cada uno asignado a una sede (HU3)';
COMMENT ON COLUMN ADMINS.id IS 'Administrador, es el mismo id de USERS';
COMMENT ON COLUMN ADMINS.stateActive IS 'Estado: ACTIVO o INACTIVO (el booleano del caso)';
COMMENT ON COLUMN ADMINS.lastConnectionDate IS 'Fecha y hora de ultima conexion';
COMMENT ON COLUMN ADMINS.BRANCH_id IS 'Unica sede que administra, FK a BRANCHS';
COMMENT ON COLUMN ADMINS.role IS 'Siempre ADMIN';

ALTER TABLE ADMINS
    ADD CONSTRAINT ADMINS_CK_1
    CHECK (role = 'ADMIN');

ALTER TABLE ADMINS
    ADD CONSTRAINT ADMIN_PK PRIMARY KEY ( id );

ALTER TABLE ADMINS
    ADD CONSTRAINT ADMINS__UN UNIQUE ( BRANCH_id );

-- [E3-R] El caso define el estado como booleano: solo dos valores posibles.
--        El trigger de BRANCH_UPDATES depende de que el valor sea exactamente ACTIVO.
ALTER TABLE ADMINS
    ADD CONSTRAINT ADMINS_STATE_CK
    CHECK ( stateActive IN ('ACTIVO','INACTIVO') );

-- ==========================================================================
-- 2. ESTABLECIMIENTOS Y SEDES
-- ==========================================================================

-- ESTABLISHMENTS: Marca general de un negocio (HU6)
--   Regla: Pertenece a un unico dueno
CREATE TABLE ESTABLISHMENTS
    (
     id                     VARCHAR2 (10 CHAR)  NOT NULL ,
     name                   VARCHAR2 (100)  NOT NULL ,
     ESTABLISHMENT_OWNER_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE ESTABLISHMENTS IS 'RUMBEA - Marca general de un negocio (HU6)';
COMMENT ON COLUMN ESTABLISHMENTS.id IS 'Identificador unico del establecimiento';
COMMENT ON COLUMN ESTABLISHMENTS.name IS 'Nombre de la marca';
COMMENT ON COLUMN ESTABLISHMENTS.ESTABLISHMENT_OWNER_id IS 'Dueno, FK a ESTABLISHMENT_OWNERS';

ALTER TABLE ESTABLISHMENTS
    ADD CONSTRAINT ESTABLISHMENT_PK PRIMARY KEY ( id );

-- BRANCHS: Sedes de un establecimiento con su estado actual (HU7, HU13)
--   Regla: UNIQUE (id, ESTABLISHMENT_id) soporta la FK compuesta de BRANCH_EVENTS
CREATE TABLE BRANCHS
    (
     id               VARCHAR2 (10 CHAR)  NOT NULL ,
     suffix           VARCHAR2 (100) ,
     location         VARCHAR2 (255)  NOT NULL ,
     description      VARCHAR2 (500)  NOT NULL ,
     capacity         NUMBER (8)  NOT NULL ,
     cover            NUMBER (10,2)  NOT NULL ,
     ESTABLISHMENT_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE BRANCHS IS 'RUMBEA - Sedes de un establecimiento con su estado actual (HU7, HU13)';
COMMENT ON COLUMN BRANCHS.id IS 'Identificador unico de la sede';
COMMENT ON COLUMN BRANCHS.suffix IS 'Sufijo que la distingue dentro de la marca';
COMMENT ON COLUMN BRANCHS.location IS 'Direccion';
COMMENT ON COLUMN BRANCHS.description IS 'Descripcion visible para los clientes';
COMMENT ON COLUMN BRANCHS.capacity IS 'Aforo actual';
COMMENT ON COLUMN BRANCHS.cover IS 'Valor actual de la entrada en COP';
COMMENT ON COLUMN BRANCHS.ESTABLISHMENT_id IS 'Establecimiento al que pertenece';

ALTER TABLE BRANCHS
    ADD CONSTRAINT BRANCH_PK PRIMARY KEY ( id );

ALTER TABLE BRANCHS
    ADD CONSTRAINT BRANCHS__UN UNIQUE ( id , ESTABLISHMENT_id );

-- [E3] El aforo no puede ser negativo
ALTER TABLE BRANCHS
    ADD CONSTRAINT BRANCHS_CAPACITY_CK
    CHECK ( capacity >= 0 );

-- [E3] El cover puede ser gratuito pero no negativo
ALTER TABLE BRANCHS
    ADD CONSTRAINT BRANCHS_COVER_CK
    CHECK ( cover >= 0 );

-- BRANCH_TYPES: Tipo de cada sede: discoteca, bar, taberna o terraza (HU11)
--   Regla: Una sede tiene un solo tipo
CREATE TABLE BRANCH_TYPES
    (
     id        VARCHAR2 (10 CHAR)  NOT NULL ,
     type      VARCHAR2 (50)  NOT NULL ,
     BRANCH_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE BRANCH_TYPES IS 'RUMBEA - Tipo de cada sede: discoteca, bar, taberna o terraza (HU11)';
COMMENT ON COLUMN BRANCH_TYPES.id IS 'Identificador unico del registro';
COMMENT ON COLUMN BRANCH_TYPES.type IS 'Tipo de establecimiento de la sede';
COMMENT ON COLUMN BRANCH_TYPES.BRANCH_id IS 'Sede asociada, FK a BRANCHS';

ALTER TABLE BRANCH_TYPES
    ADD CONSTRAINT BRANCH_TYPE_PK PRIMARY KEY ( id );

-- [E3] El caso define un unico tipo por sede
ALTER TABLE BRANCH_TYPES
    ADD CONSTRAINT BRANCH_TYPES__UN
    UNIQUE ( BRANCH_id );

-- BRANCH_SCHEDULES: Horario por dia, resultado de la descomposicion 1FN de BRANCH
--   Regla: Una sede tiene un solo horario por dia
CREATE TABLE BRANCH_SCHEDULES
    (
     id        VARCHAR2 (10)  NOT NULL ,
     dayOfWeek VARCHAR2 (10)  NOT NULL ,
     openTime  VARCHAR2 (10)  NOT NULL ,
     closeTime VARCHAR2 (10)  NOT NULL ,
     BRANCH_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE BRANCH_SCHEDULES IS 'RUMBEA - Horario por dia, resultado de la descomposicion 1FN de BRANCH';
COMMENT ON COLUMN BRANCH_SCHEDULES.id IS 'Identificador unico del horario';
COMMENT ON COLUMN BRANCH_SCHEDULES.dayOfWeek IS 'Dia de la semana en mayusculas';
COMMENT ON COLUMN BRANCH_SCHEDULES.openTime IS 'Hora de apertura HH24:MI';
COMMENT ON COLUMN BRANCH_SCHEDULES.closeTime IS 'Hora de cierre HH24:MI, puede ser del dia siguiente';
COMMENT ON COLUMN BRANCH_SCHEDULES.BRANCH_id IS 'Sede asociada, FK a BRANCHS';

ALTER TABLE BRANCH_SCHEDULES
    ADD CONSTRAINT BRANCH_SCHEDULE_PK PRIMARY KEY ( id );

-- [E3] La normalizacion define (sede, dia) como clave
ALTER TABLE BRANCH_SCHEDULES
    ADD CONSTRAINT BRANCH_SCHEDULES_DAY_UN
    UNIQUE ( BRANCH_id, dayOfWeek );

-- LINK_OF_INTERESTS: Redes y otros enlaces de una sede (HU10)
--   Regla: Cada enlace pertenece a una sola sede
CREATE TABLE LINK_OF_INTERESTS
    (
     id        VARCHAR2 (10 CHAR)  NOT NULL ,
     name      VARCHAR2 (100)  NOT NULL ,
     link      VARCHAR2 (500)  NOT NULL ,
     BRANCH_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE LINK_OF_INTERESTS IS 'RUMBEA - Redes y otros enlaces de una sede (HU10)';
COMMENT ON COLUMN LINK_OF_INTERESTS.id IS 'Identificador unico del enlace';
COMMENT ON COLUMN LINK_OF_INTERESTS.name IS 'Nombre descriptivo';
COMMENT ON COLUMN LINK_OF_INTERESTS.link IS 'URL';
COMMENT ON COLUMN LINK_OF_INTERESTS.BRANCH_id IS 'Sede asociada, FK a BRANCHS';

ALTER TABLE LINK_OF_INTERESTS
    ADD CONSTRAINT LINK_OF_INTEREST_PK PRIMARY KEY ( id );

-- BRANCH_UPDATES: Historial de cambios de una sede (HU8)
--   Regla: Arco: lo realiza exactamente un dueno o exactamente un admin
--   Regla: Los campos new* quedan en NULL si no cambiaron
CREATE TABLE BRANCH_UPDATES
    (
     id                     VARCHAR2 (10 CHAR)  NOT NULL ,
     "date"                 DATE  NOT NULL ,
     newCapacity            NUMBER (8) ,
     newCover               NUMBER (10,2) ,
     BRANCH_id              VARCHAR2 (10 CHAR)  NOT NULL ,
     newDescription         VARCHAR2 (500) ,
     newLocation            VARCHAR2 (255) ,
     ADMIN_id               VARCHAR2 (10 CHAR) ,
     ESTABLISHMENT_OWNER_id VARCHAR2 (10 CHAR)
    );

COMMENT ON TABLE BRANCH_UPDATES IS 'RUMBEA - Historial de cambios de una sede (HU8)';
COMMENT ON COLUMN BRANCH_UPDATES.id IS 'Identificador unico de la actualizacion';
COMMENT ON COLUMN BRANCH_UPDATES."date" IS 'Fecha y hora del cambio';
COMMENT ON COLUMN BRANCH_UPDATES.newCapacity IS 'Nuevo aforo';
COMMENT ON COLUMN BRANCH_UPDATES.newCover IS 'Nuevo cover';
COMMENT ON COLUMN BRANCH_UPDATES.BRANCH_id IS 'Sede asociada, FK a BRANCHS';
COMMENT ON COLUMN BRANCH_UPDATES.newDescription IS 'Nueva descripcion';
COMMENT ON COLUMN BRANCH_UPDATES.newLocation IS 'Nueva direccion';
COMMENT ON COLUMN BRANCH_UPDATES.ADMIN_id IS 'Admin que hizo el cambio, NULL si fue el dueno';
COMMENT ON COLUMN BRANCH_UPDATES.ESTABLISHMENT_OWNER_id IS 'Dueno que hizo el cambio, NULL si fue un admin';

ALTER TABLE BRANCH_UPDATES
    ADD CONSTRAINT BRANCH_UPDATES_CK_1
    CHECK ((ADMIN_id IS NOT NULL AND ESTABLISHMENT_OWNER_id IS NULL) OR (ADMIN_id IS NULL AND ESTABLISHMENT_OWNER_id IS NOT NULL));

ALTER TABLE BRANCH_UPDATES
    ADD CONSTRAINT BRANCH_UPDATE_PK PRIMARY KEY ( id );

-- [E3] El nuevo aforo no puede ser negativo
ALTER TABLE BRANCH_UPDATES
    ADD CONSTRAINT BRANCH_UPDATES_CAPACITY_CK
    CHECK ( newCapacity >= 0 );

-- [E3] El nuevo cover no puede ser negativo
ALTER TABLE BRANCH_UPDATES
    ADD CONSTRAINT BRANCH_UPDATES_COVER_CK
    CHECK ( newCover >= 0 );

-- ==========================================================================
-- 3. MUSICA
-- ==========================================================================

-- MUSIC_GENRES: Catalogo predefinido de generos musicales
--   Regla: El nombre no se repite
CREATE TABLE MUSIC_GENRES
    (
     id   VARCHAR2 (10)  NOT NULL ,
     name VARCHAR2 (100)  NOT NULL
    );

COMMENT ON TABLE MUSIC_GENRES IS 'RUMBEA - Catalogo predefinido de generos musicales';
COMMENT ON COLUMN MUSIC_GENRES.id IS 'Identificador unico del genero';
COMMENT ON COLUMN MUSIC_GENRES.name IS 'Nombre del genero';

ALTER TABLE MUSIC_GENRES
    ADD CONSTRAINT MUSIC_GENRE_PK PRIMARY KEY ( id );

ALTER TABLE MUSIC_GENRES
    ADD CONSTRAINT MUSIC_GENRE_name_UN UNIQUE ( name );

-- BRANCH_MUSIC_GENRES: Generos que ofrece cada sede (HU9, HU12)
--   Regla: Relacion M:N entre sedes y generos
CREATE TABLE BRANCH_MUSIC_GENRES
    (
     BRANCH_id      VARCHAR2 (10 CHAR)  NOT NULL ,
     MUSIC_GENRE_id VARCHAR2 (10)  NOT NULL
    );

COMMENT ON TABLE BRANCH_MUSIC_GENRES IS 'RUMBEA - Generos que ofrece cada sede (HU9, HU12)';
COMMENT ON COLUMN BRANCH_MUSIC_GENRES.BRANCH_id IS 'Sede asociada, FK a BRANCHS';
COMMENT ON COLUMN BRANCH_MUSIC_GENRES.MUSIC_GENRE_id IS 'Genero musical asociado, FK a MUSIC_GENRES';

ALTER TABLE BRANCH_MUSIC_GENRES
    ADD CONSTRAINT BRANCH_MUSIC_GENRE_PK PRIMARY KEY ( BRANCH_id, MUSIC_GENRE_id );

-- CLIENT_MUSIC_PREFERENCES: Generos preferidos de cada cliente (HU18)
--   Regla: Relacion M:N entre clientes y generos
CREATE TABLE CLIENT_MUSIC_PREFERENCES
    (
     MUSIC_GENRE_id VARCHAR2 (10)  NOT NULL ,
     CLIENT_id      VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE CLIENT_MUSIC_PREFERENCES IS 'RUMBEA - Generos preferidos de cada cliente (HU18)';
COMMENT ON COLUMN CLIENT_MUSIC_PREFERENCES.MUSIC_GENRE_id IS 'Genero musical asociado, FK a MUSIC_GENRES';
COMMENT ON COLUMN CLIENT_MUSIC_PREFERENCES.CLIENT_id IS 'Cliente asociado, FK a CLIENTS';

ALTER TABLE CLIENT_MUSIC_PREFERENCES
    ADD CONSTRAINT CLIENT_MUSIC_PREFERENCE_PK PRIMARY KEY ( CLIENT_id, MUSIC_GENRE_id );

-- ==========================================================================
-- 4. EVENTOS
-- ==========================================================================

-- EVENTS: Eventos publicados por un establecimiento (HU19, HU20)
--   Regla: UNIQUE (id, ESTABLISHMENT_id) soporta la FK compuesta de BRANCH_EVENTS
CREATE TABLE EVENTS
    (
     id               VARCHAR2 (10 CHAR)  NOT NULL ,
     name             VARCHAR2 (100)  NOT NULL ,
     realizationDate  DATE  NOT NULL ,
     description      VARCHAR2 (500)  NOT NULL ,
     specialCover     NUMBER (10,2) ,
     ESTABLISHMENT_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE EVENTS IS 'RUMBEA - Eventos publicados por un establecimiento (HU19, HU20)';
COMMENT ON COLUMN EVENTS.id IS 'Identificador unico del evento';
COMMENT ON COLUMN EVENTS.name IS 'Nombre';
COMMENT ON COLUMN EVENTS.realizationDate IS 'Fecha y hora de realizacion';
COMMENT ON COLUMN EVENTS.description IS 'Descripcion';
COMMENT ON COLUMN EVENTS.specialCover IS 'Cover especial, NULL si no aplica';
COMMENT ON COLUMN EVENTS.ESTABLISHMENT_id IS 'Establecimiento organizador';

ALTER TABLE EVENTS
    ADD CONSTRAINT EVENT_PK PRIMARY KEY ( id );

ALTER TABLE EVENTS
    ADD CONSTRAINT EVENTS__UN UNIQUE ( id , ESTABLISHMENT_id );

-- [E3] El cover especial no puede ser negativo
ALTER TABLE EVENTS
    ADD CONSTRAINT EVENTS_SPECIAL_COVER_CK
    CHECK ( specialCover >= 0 );

-- BRANCH_EVENTS: Sedes donde se realiza cada evento (HU19)
--   Regla: Las dos FK compartidas obligan a que sede y evento sean del mismo establecimiento
--   Regla: ESTABLISHMENT_id es redundancia controlada para declarar esa regla sin trigger
CREATE TABLE BRANCH_EVENTS
    (
     BRANCH_id        VARCHAR2 (10 CHAR)  NOT NULL ,
     EVENT_id         VARCHAR2 (10 CHAR)  NOT NULL ,
     ESTABLISHMENT_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE BRANCH_EVENTS IS 'RUMBEA - Sedes donde se realiza cada evento (HU19)';
COMMENT ON COLUMN BRANCH_EVENTS.BRANCH_id IS 'Sede asociada, FK a BRANCHS';
COMMENT ON COLUMN BRANCH_EVENTS.EVENT_id IS 'Evento, FK a EVENTS';
COMMENT ON COLUMN BRANCH_EVENTS.ESTABLISHMENT_id IS 'Establecimiento comun de la sede y el evento';

ALTER TABLE BRANCH_EVENTS
    ADD CONSTRAINT BRANCH_EVENT_PK PRIMARY KEY ( BRANCH_id, EVENT_id );

-- ==========================================================================
-- 5. INTERACCION DE LOS CLIENTES
-- ==========================================================================

-- FAVORITES: Sedes favoritas de cada cliente (HU14, HU15)
--   Regla: Un cliente marca una sede una sola vez
CREATE TABLE FAVORITES
    (
     assignmentDate DATE  NOT NULL ,
     BRANCH_id      VARCHAR2 (10 CHAR)  NOT NULL ,
     CLIENT_id      VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE FAVORITES IS 'RUMBEA - Sedes favoritas de cada cliente (HU14, HU15)';
COMMENT ON COLUMN FAVORITES.assignmentDate IS 'Fecha en que se marco';
COMMENT ON COLUMN FAVORITES.BRANCH_id IS 'Sede asociada, FK a BRANCHS';
COMMENT ON COLUMN FAVORITES.CLIENT_id IS 'Cliente asociado, FK a CLIENTS';

ALTER TABLE FAVORITES
    ADD CONSTRAINT FAVORITE_PK PRIMARY KEY ( CLIENT_id, BRANCH_id );

-- REVIEWS: Resenas y calificaciones (HU16, HU17)
--   Regla: Un cliente puede dejar varias resenas en una sede
CREATE TABLE REVIEWS
    (
     id        VARCHAR2 (10)  NOT NULL ,
     text      VARCHAR2 (200)  NOT NULL ,
     rating    NUMBER (1)  NOT NULL ,
     "date"    DATE  NOT NULL ,
     BRANCH_id VARCHAR2 (10 CHAR)  NOT NULL ,
     CLIENT_id VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE REVIEWS IS 'RUMBEA - Resenas y calificaciones (HU16, HU17)';
COMMENT ON COLUMN REVIEWS.id IS 'Identificador unico de la resena';
COMMENT ON COLUMN REVIEWS.text IS 'Comentario';
COMMENT ON COLUMN REVIEWS.rating IS 'Calificacion de 1 a 5 estrellas';
COMMENT ON COLUMN REVIEWS."date" IS 'Fecha de la resena';
COMMENT ON COLUMN REVIEWS.BRANCH_id IS 'Sede asociada, FK a BRANCHS';
COMMENT ON COLUMN REVIEWS.CLIENT_id IS 'Cliente asociado, FK a CLIENTS';

ALTER TABLE REVIEWS
    ADD CONSTRAINT REVIEW_PK PRIMARY KEY ( id );

-- [E3] La calificacion va de 1 a 5 estrellas
ALTER TABLE REVIEWS
    ADD CONSTRAINT REVIEWS_RATING_CK
    CHECK ( rating BETWEEN 1 AND 5 );

-- VISIT_PROFILES: Cada acceso de un cliente al perfil de una sede (Reporte 1, HU22)
--   Regla: [E3-R] PK propia: un cliente puede visitar el perfil de una sede muchas
--          veces. La PK anterior (CLIENT_id, BRANCH_id) solo permitia una visita
--          en toda la historia, el mismo problema que se corrigio en REVIEWS.
--   Regla: [E3-R] guarda el tiempo de interaccion pedido en la retroalimentacion
CREATE TABLE VISIT_PROFILES
    (
     id                 VARCHAR2 (10 CHAR)  NOT NULL ,
     visitDate          DATE  NOT NULL ,
     visitTimeIn        INTEGER  NOT NULL ,
     interactionSeconds NUMBER (6)  NOT NULL ,
     CLIENT_id          VARCHAR2 (10 CHAR)  NOT NULL ,
     BRANCH_id          VARCHAR2 (10 CHAR)  NOT NULL
    );

COMMENT ON TABLE VISIT_PROFILES IS 'RUMBEA - Cada acceso de un cliente al perfil de una sede (Reporte 1, HU22)';
COMMENT ON COLUMN VISIT_PROFILES.id IS 'Identificador unico del acceso';
COMMENT ON COLUMN VISIT_PROFILES.visitDate IS 'Fecha del acceso';
COMMENT ON COLUMN VISIT_PROFILES.visitTimeIn IS 'Hora del acceso como entero HH24MI, ejemplo 2130';
COMMENT ON COLUMN VISIT_PROFILES.interactionSeconds IS 'Tiempo que el cliente permanecio en el perfil, en segundos';
COMMENT ON COLUMN VISIT_PROFILES.CLIENT_id IS 'Cliente asociado, FK a CLIENTS';
COMMENT ON COLUMN VISIT_PROFILES.BRANCH_id IS 'Sede asociada, FK a BRANCHS';

ALTER TABLE VISIT_PROFILES
    ADD CONSTRAINT VISIT_PROFILE_PK PRIMARY KEY ( id );

-- [E3-R] La hora debe ser valida: 0000 a 2359 y minutos menores a 60
ALTER TABLE VISIT_PROFILES
    ADD CONSTRAINT VISIT_PROFILES_TIME_CK
    CHECK ( visitTimeIn BETWEEN 0 AND 2359 AND MOD(visitTimeIn, 100) < 60 );

-- [E3-R] Una visita dura al menos un segundo
ALTER TABLE VISIT_PROFILES
    ADD CONSTRAINT VISIT_PROFILES_SECONDS_CK
    CHECK ( interactionSeconds > 0 );

-- CLIENT_EVENT_REMINDERS: Eventos que un cliente pidio recordar (Reporte 2, HU23)
--   Regla: [E3-R] Relacion M:N entre clientes y eventos. Un cliente activa el
--          recordatorio de un evento una sola vez.
CREATE TABLE CLIENT_EVENT_REMINDERS
    (
     CLIENT_id    VARCHAR2 (10 CHAR)  NOT NULL ,
     EVENT_id     VARCHAR2 (10 CHAR)  NOT NULL ,
     reminderDate DATE  NOT NULL
    );

COMMENT ON TABLE CLIENT_EVENT_REMINDERS IS 'RUMBEA - Eventos que un cliente pidio recordar (Reporte 2, HU23)';
COMMENT ON COLUMN CLIENT_EVENT_REMINDERS.CLIENT_id IS 'Cliente asociado, FK a CLIENTS';
COMMENT ON COLUMN CLIENT_EVENT_REMINDERS.EVENT_id IS 'Evento, FK a EVENTS';
COMMENT ON COLUMN CLIENT_EVENT_REMINDERS.reminderDate IS 'Fecha en que activo el recordatorio';

ALTER TABLE CLIENT_EVENT_REMINDERS
    ADD CONSTRAINT CLIENT_EVENT_REMINDER_PK PRIMARY KEY ( CLIENT_id, EVENT_id );

-- ==========================================================================
-- 6. INTEGRIDAD REFERENCIAL
-- Van al final para no depender del orden de creacion.
-- Sin borrado en cascada: no se elimina un padre que aun tenga hijos.
-- ==========================================================================

-- ADMINS (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE ADMINS
    ADD CONSTRAINT ADMIN_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- ADMINS (id, role) debe existir en USERS (id, role)
ALTER TABLE ADMINS
    ADD CONSTRAINT ADMIN_USER_FK FOREIGN KEY ( id, role )
    REFERENCES USERS ( id, role );

-- BRANCHS (ESTABLISHMENT_id) debe existir en ESTABLISHMENTS (id)
ALTER TABLE BRANCHS
    ADD CONSTRAINT BRANCH_ESTABLISHMENT_FK FOREIGN KEY ( ESTABLISHMENT_id )
    REFERENCES ESTABLISHMENTS ( id );

-- BRANCH_EVENTS (BRANCH_id, ESTABLISHMENT_id) debe existir en BRANCHS (id, ESTABLISHMENT_id)
ALTER TABLE BRANCH_EVENTS
    ADD CONSTRAINT BRANCH_EVENT_BRANCH_FK FOREIGN KEY ( BRANCH_id, ESTABLISHMENT_id )
    REFERENCES BRANCHS ( id, ESTABLISHMENT_id );

-- BRANCH_EVENTS (EVENT_id, ESTABLISHMENT_id) debe existir en EVENTS (id, ESTABLISHMENT_id)
ALTER TABLE BRANCH_EVENTS
    ADD CONSTRAINT BRANCH_EVENT_EVENT_FK FOREIGN KEY ( EVENT_id, ESTABLISHMENT_id )
    REFERENCES EVENTS ( id, ESTABLISHMENT_id );

-- BRANCH_MUSIC_GENRES (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE BRANCH_MUSIC_GENRES
    ADD CONSTRAINT BRANCH_MUSIC_GENRE_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- BRANCH_MUSIC_GENRES (MUSIC_GENRE_id) debe existir en MUSIC_GENRES (id)
ALTER TABLE BRANCH_MUSIC_GENRES
    ADD CONSTRAINT BRANCH_MUSIC_GENRE_GENRE_FK FOREIGN KEY ( MUSIC_GENRE_id )
    REFERENCES MUSIC_GENRES ( id );

-- BRANCH_SCHEDULES (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE BRANCH_SCHEDULES
    ADD CONSTRAINT BRANCH_SCHEDULE_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- BRANCH_TYPES (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE BRANCH_TYPES
    ADD CONSTRAINT BRANCH_TYPES_BRANCHS_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- BRANCH_UPDATES (ADMIN_id) debe existir en ADMINS (id)
ALTER TABLE BRANCH_UPDATES
    ADD CONSTRAINT BRANCH_UPDATE_ADMIN_FK FOREIGN KEY ( ADMIN_id )
    REFERENCES ADMINS ( id );

-- BRANCH_UPDATES (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE BRANCH_UPDATES
    ADD CONSTRAINT BRANCH_UPDATE_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- BRANCH_UPDATES (ESTABLISHMENT_OWNER_id) debe existir en ESTABLISHMENT_OWNERS (id)
ALTER TABLE BRANCH_UPDATES
    ADD CONSTRAINT BRANCH_UPDATE_OWNER_FK FOREIGN KEY ( ESTABLISHMENT_OWNER_id )
    REFERENCES ESTABLISHMENT_OWNERS ( id );

-- CLIENT_MUSIC_PREFERENCES (CLIENT_id) debe existir en CLIENTS (id)
ALTER TABLE CLIENT_MUSIC_PREFERENCES
    ADD CONSTRAINT CLIENT_MUSIC_PREF_CLIENT_FK FOREIGN KEY ( CLIENT_id )
    REFERENCES CLIENTS ( id );

-- CLIENT_MUSIC_PREFERENCES (MUSIC_GENRE_id) debe existir en MUSIC_GENRES (id)
ALTER TABLE CLIENT_MUSIC_PREFERENCES
    ADD CONSTRAINT CLIENT_MUSIC_PREF_GENRE_FK FOREIGN KEY ( MUSIC_GENRE_id )
    REFERENCES MUSIC_GENRES ( id );

-- CLIENTS (id, role) debe existir en USERS (id, role)
ALTER TABLE CLIENTS
    ADD CONSTRAINT CLIENT_USER_FK FOREIGN KEY ( id, role )
    REFERENCES USERS ( id, role );

-- ESTABLISHMENTS (ESTABLISHMENT_OWNER_id) debe existir en ESTABLISHMENT_OWNERS (id)
ALTER TABLE ESTABLISHMENTS
    ADD CONSTRAINT ESTABLISHMENT_OWNER_FK FOREIGN KEY ( ESTABLISHMENT_OWNER_id )
    REFERENCES ESTABLISHMENT_OWNERS ( id );

-- ESTABLISHMENT_OWNERS (id, role) debe existir en USERS (id, role)
ALTER TABLE ESTABLISHMENT_OWNERS
    ADD CONSTRAINT ESTABLISHMENT_OWNER_USER_FK FOREIGN KEY ( id, role )
    REFERENCES USERS ( id, role );

-- EVENTS (ESTABLISHMENT_id) debe existir en ESTABLISHMENTS (id)
ALTER TABLE EVENTS
    ADD CONSTRAINT EVENTS_ESTABLISHMENTS_FK FOREIGN KEY ( ESTABLISHMENT_id )
    REFERENCES ESTABLISHMENTS ( id );

-- FAVORITES (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE FAVORITES
    ADD CONSTRAINT FAVORITE_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- FAVORITES (CLIENT_id) debe existir en CLIENTS (id)
ALTER TABLE FAVORITES
    ADD CONSTRAINT FAVORITE_CLIENT_FK FOREIGN KEY ( CLIENT_id )
    REFERENCES CLIENTS ( id );

-- LINK_OF_INTERESTS (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE LINK_OF_INTERESTS
    ADD CONSTRAINT LINK_OF_INTEREST_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- REVIEWS (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE REVIEWS
    ADD CONSTRAINT REVIEW_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- REVIEWS (CLIENT_id) debe existir en CLIENTS (id)
ALTER TABLE REVIEWS
    ADD CONSTRAINT REVIEW_CLIENT_FK FOREIGN KEY ( CLIENT_id )
    REFERENCES CLIENTS ( id );

-- VISIT_PROFILES (BRANCH_id) debe existir en BRANCHS (id)
ALTER TABLE VISIT_PROFILES
    ADD CONSTRAINT VISIT_PROFILE_BRANCH_FK FOREIGN KEY ( BRANCH_id )
    REFERENCES BRANCHS ( id );

-- VISIT_PROFILES (CLIENT_id) debe existir en CLIENTS (id)
ALTER TABLE VISIT_PROFILES
    ADD CONSTRAINT VISIT_PROFILE_CLIENT_FK FOREIGN KEY ( CLIENT_id )
    REFERENCES CLIENTS ( id );

-- [E3-R] CLIENT_EVENT_REMINDERS (CLIENT_id) debe existir en CLIENTS (id)
ALTER TABLE CLIENT_EVENT_REMINDERS
    ADD CONSTRAINT REMINDER_CLIENT_FK FOREIGN KEY ( CLIENT_id )
    REFERENCES CLIENTS ( id );

-- [E3-R] CLIENT_EVENT_REMINDERS (EVENT_id) debe existir en EVENTS (id)
ALTER TABLE CLIENT_EVENT_REMINDERS
    ADD CONSTRAINT REMINDER_EVENT_FK FOREIGN KEY ( EVENT_id )
    REFERENCES EVENTS ( id );

PROMPT DDL de Rumbea creado (19 tablas).
