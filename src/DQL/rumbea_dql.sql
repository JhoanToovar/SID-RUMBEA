-- ==========================================================================
-- RUMBEA - Entrega 3 - Consultas DQL de los reportes
-- Requiere: DDL y DML. Compatible con Oracle 11g (el TOP se hace con ROWNUM).
--
-- Consulta  Reporte  INNER  OUTER  GROUP BY  ORDER BY  TOP
--   Q1      R1        si      no      si        si       no
--   Q2      R1        si      si     no         si       no
--   Q3      R2        si      si     si        si       no
--   Q4      R2        si      si     si        si       no
--   Q5      R2        si      si     si        si       10
--   Q6      R3        si      si     si        si       no
--   Q7      R3        si      si     si        si       10
--
-- Los filtros estan en el bloque "parametros" al inicio de cada consulta.
-- [E3-R] Q1 usa visitas con PK propia y Q4 cuenta recordatorios reales.
-- ==========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET LINESIZE 250
SET PAGESIZE 100
SET FEEDBACK 1

COLUMN sede FORMAT A36
COLUMN establecimiento FORMAT A24
COLUMN cliente FORMAT A22
COLUMN comentario FORMAT A44
COLUMN es_favorita FORMAT A11
COLUMN evento FORMAT A22
COLUMN direccion FORMAT A52
COLUMN tipo FORMAT A12
COLUMN genero FORMAT A12

-- ==========================================================================
-- REPORTE 1. Actividad del establecimiento asignado. Actor: administrador.
-- ==========================================================================

PROMPT
PROMPT === Q1 - R1: accesos diarios al perfil de la sede del administrador ===
-- Q1. En lenguaje natural:
--   Para la sede que tiene asignada el administrador ADM01, mostrar por cada
--   dia cuantos accesos tuvo su perfil, cuantos clientes distintos lo vieron,
--   cuanto duro en promedio cada visita y a que hora fueron el primero y el
--   ultimo acceso, del dia mas reciente al mas antiguo.
-- Tecnica:
--   INNER JOIN para llegar del admin a su sede y sus accesos. GROUP BY por dia.
--   [E3-R] Con la PK propia de VISIT_PROFILES un cliente puede aparecer varias
--   veces; por eso accesos y clientes_distintos pueden diferir.
WITH parametros AS (
  SELECT 'ADM01' AS admin_id FROM dual
)
SELECT TO_CHAR(TRUNC(v.visitDate), 'YYYY-MM-DD') AS fecha,
       COUNT(*) AS accesos,
       COUNT(DISTINCT v.CLIENT_id) AS clientes_distintos,
       ROUND(AVG(v.interactionSeconds)) AS seg_promedio,
       SUBSTR(LPAD(MIN(v.visitTimeIn), 4, '0'), 1, 2) || ':' ||
       SUBSTR(LPAD(MIN(v.visitTimeIn), 4, '0'), 3, 2) AS primer_acceso,
       SUBSTR(LPAD(MAX(v.visitTimeIn), 4, '0'), 1, 2) || ':' ||
       SUBSTR(LPAD(MAX(v.visitTimeIn), 4, '0'), 3, 2) AS ultimo_acceso
FROM parametros p
INNER JOIN ADMINS a         ON a.id = p.admin_id
INNER JOIN VISIT_PROFILES v ON v.BRANCH_id = a.BRANCH_id
GROUP BY TRUNC(v.visitDate)
ORDER BY TRUNC(v.visitDate) DESC;

PROMPT
PROMPT === Q2 - R1: resenas de la sede del administrador ===
-- Q2. En lenguaje natural:
--   Para la sede del administrador ADM01, listar las resenas con cliente,
--   estrellas y comentario, indicando si ese cliente la tiene como favorita,
--   de la mas reciente a la mas antigua.
-- Tecnica:
--   LEFT OUTER JOIN a FAVORITES para no perder las resenas de quienes no la
--   marcaron como favorita.
WITH parametros AS (
  SELECT 'ADM01' AS admin_id FROM dual
)
SELECT TO_CHAR(r."date", 'YYYY-MM-DD HH24:MI') AS fecha,
       u.name AS cliente,
       r.rating AS estrellas,
       r.text AS comentario,
       CASE WHEN f.CLIENT_id IS NULL THEN 'NO' ELSE 'SI' END AS es_favorita
FROM parametros p
INNER JOIN ADMINS a  ON a.id = p.admin_id
INNER JOIN REVIEWS r ON r.BRANCH_id = a.BRANCH_id
INNER JOIN USERS u   ON u.id = r.CLIENT_id
LEFT OUTER JOIN FAVORITES f ON f.CLIENT_id = r.CLIENT_id
                           AND f.BRANCH_id = r.BRANCH_id
ORDER BY r."date" DESC, r.id;

-- ==========================================================================
-- REPORTE 2. Popularidad de establecimientos y eventos. Actor: dueno.
-- ==========================================================================

PROMPT
PROMPT === Q3 - R2: establecimientos del dueno por favoritos ===
-- Q3. En lenguaje natural:
--   Listar todos los establecimientos del dueno OWN01 con su numero de sedes,
--   sus favoritos y los clientes distintos que los marcaron, del mas al menos
--   popular, incluyendo los que no tienen favoritos.
-- Tecnica:
--   LEFT OUTER JOIN conserva los establecimientos en cero. Se usa
--   COUNT(columna) porque COUNT(*) contaria 1 donde no hay favoritos.
WITH parametros AS (
  SELECT 'OWN01' AS owner_id FROM dual
)
SELECT e.name AS establecimiento,
       COUNT(DISTINCT b.id) AS sedes,
       COUNT(f.CLIENT_id) AS favoritos,
       COUNT(DISTINCT f.CLIENT_id) AS clientes_distintos
FROM parametros p
INNER JOIN ESTABLISHMENTS e ON e.ESTABLISHMENT_OWNER_id = p.owner_id
LEFT OUTER JOIN BRANCHS b   ON b.ESTABLISHMENT_id = e.id
LEFT OUTER JOIN FAVORITES f ON f.BRANCH_id = b.id
GROUP BY e.id, e.name
ORDER BY favoritos DESC, establecimiento;

PROMPT
PROMPT === Q4 - R2: eventos del dueno por recordatorios ===
-- Q4. En lenguaje natural:
--   Para cada evento de los establecimientos del dueno OWN01, mostrar en
--   cuantas sedes se realiza y cuantos clientes activaron "recordar evento",
--   de mayor a menor, incluyendo los eventos sin recordatorios.
-- [E3-R] Ahora cuenta recordatorios reales (CLIENT_EVENT_REMINDERS), como pedia
--   el reporte de la Entrega 0. Antes era una aproximacion por favoritos.
-- Tecnica:
--   los recordatorios se agregan en la CTE "recordatorios" y luego se unen con
--   LEFT OUTER JOIN; asi no se multiplican por el numero de sedes del evento y
--   los eventos sin recordatorios aparecen con 0.
WITH parametros AS (
  SELECT 'OWN01' AS owner_id FROM dual
),
recordatorios AS (
  SELECT EVENT_id, COUNT(*) AS total
  FROM CLIENT_EVENT_REMINDERS
  GROUP BY EVENT_id
)
SELECT ev.name AS evento,
       e.name AS establecimiento,
       TO_CHAR(ev.realizationDate, 'YYYY-MM-DD HH24:MI') AS fecha,
       COUNT(DISTINCT be.BRANCH_id) AS sedes,
       NVL(r.total, 0) AS recordatorios
FROM parametros p
INNER JOIN ESTABLISHMENTS e      ON e.ESTABLISHMENT_OWNER_id = p.owner_id
INNER JOIN EVENTS ev             ON ev.ESTABLISHMENT_id = e.id
LEFT OUTER JOIN BRANCH_EVENTS be ON be.EVENT_id = ev.id
LEFT OUTER JOIN recordatorios r  ON r.EVENT_id = ev.id
GROUP BY ev.id, ev.name, e.name, ev.realizationDate, r.total
ORDER BY recordatorios DESC, ev.realizationDate, ev.id;

PROMPT
PROMPT === Q5 - R2: TOP 10 sedes del dueno por favoritos ===
-- Q5. En lenguaje natural:
--   Mostrar las 10 sedes del dueno OWN01 con mas favoritos. Un empate se
--   resuelve por el id de la sede.
-- Tecnica:
--   primero se ordena en la subconsulta y despues se filtra con ROWNUM. Al
--   reves, Oracle tomaria 10 filas cualesquiera y luego las ordenaria.
WITH parametros AS (
  SELECT 'OWN01' AS owner_id FROM dual
)
SELECT ROWNUM AS posicion, t.sede, t.favoritos
FROM (
  SELECT e.name || CASE WHEN b.suffix IS NOT NULL THEN ' - ' || b.suffix END AS sede,
         COUNT(f.CLIENT_id) AS favoritos
  FROM parametros p
  INNER JOIN ESTABLISHMENTS e ON e.ESTABLISHMENT_OWNER_id = p.owner_id
  INNER JOIN BRANCHS b        ON b.ESTABLISHMENT_id = e.id
  LEFT OUTER JOIN FAVORITES f ON f.BRANCH_id = b.id
  GROUP BY b.id, e.name, b.suffix
  ORDER BY favoritos DESC, b.id
) t
WHERE ROWNUM <= 10
ORDER BY posicion;

-- ==========================================================================
-- REPORTE 3. Consulta filtrada de establecimientos. Actor: cliente.
-- ==========================================================================

PROMPT
PROMPT === Q6 - R3: discotecas con reggaeton ===
-- Q6. En lenguaje natural:
--   Mostrar las sedes de tipo Discoteca que ofrecen Reggaeton, con direccion,
--   aforo actual, cover y calificacion promedio, de mejor a peor calificada,
--   incluyendo las que aun no tienen resenas.
-- Interpretacion:
--   "genero predominante" se toma como genero asociado a la sede (HU12),
--   porque el MR no distingue cual predomina.
-- Tecnica:
--   LEFT OUTER JOIN a REVIEWS. El filtro no distingue mayusculas.
WITH parametros AS (
  SELECT 'Discoteca' AS tipo_buscado, 'Reggaeton' AS genero_buscado FROM dual
)
SELECT e.name || CASE WHEN b.suffix IS NOT NULL THEN ' - ' || b.suffix END AS sede,
       bt.type AS tipo,
       g.name AS genero,
       b.location AS direccion,
       b.capacity AS aforo_actual,
       b.cover AS cover_cop,
       ROUND(AVG(r.rating), 2) AS promedio,
       COUNT(r.id) AS resenas
FROM parametros p
INNER JOIN BRANCH_TYPES bt         ON UPPER(bt.type) = UPPER(p.tipo_buscado)
INNER JOIN BRANCHS b               ON b.id = bt.BRANCH_id
INNER JOIN ESTABLISHMENTS e        ON e.id = b.ESTABLISHMENT_id
INNER JOIN BRANCH_MUSIC_GENRES bmg ON bmg.BRANCH_id = b.id
INNER JOIN MUSIC_GENRES g          ON g.id = bmg.MUSIC_GENRE_id
                                  AND UPPER(g.name) = UPPER(p.genero_buscado)
LEFT OUTER JOIN REVIEWS r          ON r.BRANCH_id = b.id
GROUP BY b.id, e.name, b.suffix, bt.type, g.name, b.location, b.capacity, b.cover
ORDER BY promedio DESC NULLS LAST, resenas DESC, b.id;

PROMPT
PROMPT === Q7 - R3: TOP 10 sedes segun las preferencias del cliente ===
-- Q7. En lenguaje natural:
--   Recomendar al cliente CLI001 las 10 sedes que mas coinciden con sus generos
--   preferidos, desempatando por calificacion promedio y numero de resenas.
-- Tecnica:
--   las resenas se agregan aparte. Unirlas directamente con los generos
--   multiplicaria filas e inflaria los conteos.
WITH parametros AS (
  SELECT 'CLI001' AS client_id FROM dual
),
calificaciones AS (
  SELECT BRANCH_id, ROUND(AVG(rating), 2) AS promedio, COUNT(*) AS resenas
  FROM REVIEWS
  GROUP BY BRANCH_id
)
SELECT ROWNUM AS posicion, t.sede, t.tipo, t.generos_en_comun, t.promedio, t.resenas
FROM (
  SELECT e.name || CASE WHEN b.suffix IS NOT NULL THEN ' - ' || b.suffix END AS sede,
         bt.type AS tipo,
         COUNT(*) AS generos_en_comun,
         c.promedio AS promedio,
         COALESCE(c.resenas, 0) AS resenas
  FROM parametros p
  INNER JOIN CLIENT_MUSIC_PREFERENCES cp ON cp.CLIENT_id = p.client_id
  INNER JOIN BRANCH_MUSIC_GENRES bmg     ON bmg.MUSIC_GENRE_id = cp.MUSIC_GENRE_id
  INNER JOIN BRANCHS b                   ON b.id = bmg.BRANCH_id
  INNER JOIN ESTABLISHMENTS e            ON e.id = b.ESTABLISHMENT_id
  LEFT OUTER JOIN BRANCH_TYPES bt        ON bt.BRANCH_id = b.id
  LEFT OUTER JOIN calificaciones c       ON c.BRANCH_id = b.id
  GROUP BY b.id, e.name, b.suffix, bt.type, c.promedio, c.resenas
  ORDER BY generos_en_comun DESC, promedio DESC NULLS LAST, resenas DESC, b.id
) t
WHERE ROWNUM <= 10
ORDER BY posicion;
