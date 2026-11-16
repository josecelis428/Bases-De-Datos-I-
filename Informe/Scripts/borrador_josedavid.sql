
-- CONSULTA 1:


SELECT
    i.nombre_interes AS interes,
    COUNT(ei.id_estudiante) AS cantidad_estudiantes
FROM interes i
LEFT JOIN estudiante_interes ei
    ON i.id_interes = ei.id_interes
GROUP BY i.id_interes, i.nombre_interes
ORDER BY cantidad_estudiantes DESC;



-- CONSULTA 2:
SELECT
    e.id_estudiante,
    e.nombre,
    e.apellido,
    COUNT(s.id_seguidor) AS cantidad_seguidores
FROM estudiante e
LEFT JOIN seguidor s
    ON e.id_estudiante = s.id_seguido
GROUP BY
    e.id_estudiante,
    e.nombre,
    e.apellido
ORDER BY cantidad_seguidores DESC;



-- CONSULTA 3:
SELECT
    ev.id_evento,
    ev.nombre_evento,
    ev.fecha_hora,
    ev.ubicacion,
    COUNT(ee.id_estudiante) AS cantidad_participantes
FROM evento ev
LEFT JOIN estudiante_evento ee
    ON ev.id_evento = ee.id_evento
GROUP BY
    ev.id_evento,
    ev.nombre_evento,
    ev.fecha_hora,
    ev.ubicacion
ORDER BY cantidad_participantes DESC;


-- VISTA 1:


CREATE OR REPLACE VIEW vista_perfiles_estudiantes AS
SELECT
    e.id_estudiante,
    e.nombre,
    e.apellido,
    e.correo,
    e.programa,
    e.semestre,
    p.biografia,
    p.foto,
    p.contacto
FROM estudiante e
INNER JOIN perfil p
    ON e.id_estudiante = p.id_estudiante;


-- vista 1

SELECT * FROM vista_perfiles_estudiantes;



--VISTA 2:



CREATE OR REPLACE VIEW vista_resumen_grupos AS
SELECT
    g.id_grupo,
    g.nombre_grupo,
    g.descripcion,
    g.fecha_creacion,
    COUNT(eg.id_estudiante) AS cantidad_integrantes
FROM grupo g
LEFT JOIN estudiante_grupo eg
    ON g.id_grupo = eg.id_grupo
GROUP BY
    g.id_grupo,
    g.nombre_grupo,
    g.descripcion,
    g.fecha_creacion;


-- vista 2

SELECT *
FROM vista_resumen_grupos
ORDER BY cantidad_integrantes DESC;

