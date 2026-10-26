-- Pruebas MySQL 8.0.16+; ejecutar en una base de pruebas después de mysql.sql.
START TRANSACTION;
INSERT INTO estudiante(nombre, apellido, correo, programa, semestre)
VALUES ('Ana','Prueba','ana.prueba@example.test','Ingeniería de Sistemas',3),
       ('Luis','Prueba','luis.prueba@example.test','Tecnología en Sistemas',5);
INSERT INTO perfil(id_estudiante, biografia, contacto, datos_extra)
SELECT id_estudiante, 'Perfil de prueba', 'ana@example.test',
       JSON_OBJECT('habilidades', JSON_ARRAY('SQL','Python'), 'ubicacion', JSON_OBJECT('latitud',6.24,'longitud',-75.58))
FROM estudiante WHERE correo='ana.prueba@example.test';
SELECT id_estudiante, nombre, correo FROM estudiante WHERE correo LIKE '%.prueba@example.test' ORDER BY id_estudiante;
SELECT p.id_estudiante, JSON_EXTRACT(p.datos_extra,'$.habilidades') AS habilidades,
       JSON_UNQUOTE(JSON_EXTRACT(p.datos_extra,'$.ubicacion.latitud')) AS latitud
FROM perfil p JOIN estudiante e ON e.id_estudiante=p.id_estudiante
WHERE e.correo='ana.prueba@example.test';
SELECT COUNT(*) AS tablas FROM information_schema.tables WHERE table_schema=DATABASE() AND table_type='BASE TABLE';
SELECT COUNT(*) AS claves_foraneas FROM information_schema.table_constraints
WHERE constraint_schema=DATABASE() AND constraint_type='FOREIGN KEY';
ROLLBACK;

-- Ejecutar por separado en una base de pruebas: cada instrucción debe ser rechazada.
-- INSERT INTO estudiante(nombre,apellido,correo,programa,semestre) VALUES ('X','Y','semestre-invalido@example.test','Sistemas',0); -- CHECK
-- INSERT INTO estudiante(nombre,apellido,correo,programa,semestre) VALUES ('X','Y','ana.prueba@example.test','Sistemas',2); -- UNIQUE, si el registro de prueba existe
-- INSERT INTO seguidor(id_seguidor,id_seguido) SELECT id_estudiante,id_estudiante FROM estudiante WHERE correo='ana.prueba@example.test'; -- CHECK
