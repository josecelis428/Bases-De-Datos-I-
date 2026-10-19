SELECT table_name AS tabla
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT conrelid::regclass AS tabla,
       conname            AS restriccion,
       CASE contype WHEN 'p' THEN 'PRIMARY KEY'
                    WHEN 'f' THEN 'FOREIGN KEY'
                    WHEN 'u' THEN 'UNIQUE'
                    WHEN 'c' THEN 'CHECK' END AS tipo
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, contype, conname;

SELECT conrelid::regclass  AS tabla_hija,
       conname             AS restriccion,
       confrelid::regclass AS tabla_padre,
       CASE confdeltype WHEN 'c' THEN 'CASCADE' WHEN 'r' THEN 'RESTRICT'
                        WHEN 'a' THEN 'NO ACTION' WHEN 'n' THEN 'SET NULL' END AS on_delete,
       CASE confupdtype WHEN 'c' THEN 'CASCADE' WHEN 'r' THEN 'RESTRICT'
                        WHEN 'a' THEN 'NO ACTION' WHEN 'n' THEN 'SET NULL' END AS on_update
FROM pg_constraint
WHERE contype = 'f' AND connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, conname;

SELECT 'estudiante' AS tabla, count(*) AS filas FROM estudiante
UNION ALL SELECT 'perfil', count(*) FROM perfil
UNION ALL SELECT 'publicacion', count(*) FROM publicacion
UNION ALL SELECT 'grupo', count(*) FROM grupo
UNION ALL SELECT 'evento', count(*) FROM evento
UNION ALL SELECT 'interes', count(*) FROM interes
UNION ALL SELECT 'estudiante_grupo', count(*) FROM estudiante_grupo
UNION ALL SELECT 'estudiante_evento', count(*) FROM estudiante_evento
UNION ALL SELECT 'estudiante_interes', count(*) FROM estudiante_interes
UNION ALL SELECT 'seguidor', count(*) FROM seguidor;
