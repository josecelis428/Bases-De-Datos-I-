-- Pruebas SQL Server 2016+; ejecutar en una base de pruebas después de sql_server.sql.
BEGIN TRANSACTION;
INSERT INTO dbo.estudiante(nombre, apellido, correo, programa, semestre)
VALUES ('Ana','Prueba','ana.prueba@example.test','Ingeniería de Sistemas',3),
       ('Luis','Prueba','luis.prueba@example.test','Tecnología en Sistemas',5);
INSERT INTO dbo.perfil(id_estudiante, biografia, contacto, datos_extra)
SELECT id_estudiante, 'Perfil de prueba', 'ana@example.test',
       N'{"habilidades":["SQL","Python"],"ubicacion":{"latitud":6.24,"longitud":-75.58}}'
FROM dbo.estudiante WHERE correo='ana.prueba@example.test';
SELECT id_estudiante, nombre, correo FROM dbo.estudiante WHERE correo LIKE '%.prueba@example.test' ORDER BY id_estudiante;
SELECT p.id_estudiante, JSON_QUERY(p.datos_extra,'$.habilidades') AS habilidades,
       JSON_VALUE(p.datos_extra,'$.ubicacion.latitud') AS latitud
FROM dbo.perfil p JOIN dbo.estudiante e ON e.id_estudiante=p.id_estudiante
WHERE e.correo='ana.prueba@example.test';
SELECT COUNT(*) AS tablas FROM sys.tables;
SELECT COUNT(*) AS claves_foraneas FROM sys.foreign_keys;
ROLLBACK TRANSACTION;

-- Ejecutar por separado en una base de pruebas: cada instrucción debe ser rechazada.
-- INSERT INTO dbo.estudiante(nombre,apellido,correo,programa,semestre) VALUES ('X','Y','semestre-invalido@example.test','Sistemas',0); -- CHECK
-- INSERT INTO dbo.estudiante(nombre,apellido,correo,programa,semestre) VALUES ('X','Y','ana.prueba@example.test','Sistemas',2); -- UNIQUE, si el registro de prueba existe
-- INSERT INTO dbo.seguidor(id_seguidor,id_seguido) SELECT id_estudiante,id_estudiante FROM dbo.estudiante WHERE correo='ana.prueba@example.test'; -- CHECK
