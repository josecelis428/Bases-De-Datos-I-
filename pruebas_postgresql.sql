-- Ejecutar DESPUÉS del DDL PostgreSQL en una base de pruebas. Revierte datos al final.
BEGIN;
INSERT INTO estudiante(nombre,apellido,correo,programa,semestre) VALUES
('Ana','Prueba','ana.prueba@ejemplo.com','Ingeniería de Sistemas',3),
('Luis','Prueba','luis.prueba@ejemplo.com','Tecnología en Sistemas',5);
INSERT INTO perfil(id_estudiante,biografia,contacto,datos_extra) VALUES
(1,'Perfil de prueba','ana@ejemplo.com','{"habilidades":["SQL","Python"],"deportes":["fútbol"],"ubicacion":{"latitud":6.24,"longitud":-75.58}}'::jsonb);
SELECT id_estudiante,nombre,correo FROM estudiante ORDER BY id_estudiante;
SELECT id_estudiante,datos_extra->'habilidades' AS habilidades,datos_extra->'ubicacion'->>'latitud' AS latitud FROM perfil;
SELECT count(*) AS tablas FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';
SELECT count(*) AS claves_foraneas FROM information_schema.table_constraints WHERE constraint_schema='public' AND constraint_type='FOREIGN KEY';
-- Las siguientes pruebas negativas deben ejecutarse individualmente y se espera que fallen:
-- INSERT INTO estudiante(nombre,apellido,correo,programa,semestre) VALUES ('X','Y','x@ejemplo.com','Sistemas',0); -- CHECK
-- INSERT INTO seguidor(id_seguidor,id_seguido) VALUES (1,1); -- CHECK no seguirse a sí mismo
-- INSERT INTO estudiante(nombre,apellido,correo,programa,semestre) VALUES ('Duplicado','Correo','ana.prueba@ejemplo.com','Sistemas',2); -- UNIQUE
ROLLBACK;
