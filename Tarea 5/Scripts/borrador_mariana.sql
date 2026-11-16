
-- consulta 4
SELECT
    e.programa,
    COUNT(e.id_estudiante)       AS cantidad_estudiantes,
    ROUND(AVG(e.semestre), 1)    AS semestre_promedio
FROM estudiante e
GROUP BY e.programa
ORDER BY cantidad_estudiantes DESC, e.programa;


-- Consulta 5
SELECT
    i.nombre_interes                              AS interes_en_comun,
    mentor.nombre || ' ' || mentor.apellido       AS posible_mentor,
    mentor.semestre                               AS semestre_mentor,
    aprendiz.nombre || ' ' || aprendiz.apellido   AS estudiante_a_orientar,
    aprendiz.semestre                             AS semestre_aprendiz
FROM estudiante_interes im
INNER JOIN estudiante_interes ia
    ON  im.id_interes = ia.id_interes
    AND im.id_estudiante <> ia.id_estudiante
INNER JOIN estudiante mentor
    ON mentor.id_estudiante = im.id_estudiante
INNER JOIN estudiante aprendiz
    ON aprendiz.id_estudiante = ia.id_estudiante
INNER JOIN interes i
    ON i.id_interes = im.id_interes
WHERE mentor.semestre > aprendiz.semestre
ORDER BY i.nombre_interes, mentor.semestre DESC, aprendiz.semestre;


-- vista 3
CREATE OR REPLACE VIEW vista_actividad_estudiantes AS
SELECT
    e.id_estudiante,
    e.nombre || ' ' || e.apellido AS nombre_completo,
    e.programa,
    e.semestre,
    (SELECT COUNT(*) FROM estudiante_interes ei
      WHERE ei.id_estudiante = e.id_estudiante)   AS total_intereses,
    (SELECT COUNT(*) FROM estudiante_grupo eg
      WHERE eg.id_estudiante = e.id_estudiante)   AS total_grupos,
    (SELECT COUNT(*) FROM estudiante_evento ee
      WHERE ee.id_estudiante = e.id_estudiante)   AS total_eventos,
    (SELECT COUNT(*) FROM seguidor s
      WHERE s.id_seguido = e.id_estudiante)       AS total_seguidores
FROM estudiante e;

-- Consulta de prueba a la vista 3
SELECT *
FROM vista_actividad_estudiantes
ORDER BY total_grupos DESC, total_eventos DESC;

-- Ejemplo de uso analítico: estudiantes que aún no tienen seguidores (a quienes se podría
-- invitar a conectar con otros compañeros)
SELECT nombre_completo, programa, total_grupos, total_eventos
FROM vista_actividad_estudiantes
WHERE total_seguidores = 0;
