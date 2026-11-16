
-- 1. Estudiantes (6)
INSERT INTO estudiante (nombre, apellido, correo, programa, semestre) VALUES
('David',  'Prueba',  'david.prueba@ejemplo.com',   'Ingeniería de Sistemas', 3),
('Maria',  'Gomez',   'maria.gomez@ejemplo.com',    'Ingeniería de Sistemas', 6),
('Andres', 'Lopez',   'andres.lopez@ejemplo.com',   'Ingeniería de Sistemas', 8),
('Carlos', 'Perez',   'carlos.perez@ejemplo.com',   'Diseño Industrial',      4),
('Daniel', 'Ramirez', 'daniel.ramirez@ejemplo.com', 'Tecnología en Sistemas', 2),
('Laura',  'Torres',  'laura.torres@ejemplo.com',   'Diseño Industrial',      7);

-- 2. Perfiles (uno por estudiante)
INSERT INTO perfil (id_estudiante, biografia, foto, contacto)
SELECT e.id_estudiante, v.bio, v.foto, v.correo
FROM (VALUES
 ('david.prueba@ejemplo.com',   'Me gusta programar y los videojuegos.',        'david.jpg'),
 ('maria.gomez@ejemplo.com',    'Estudiante de sistemas, apasionada por el código y la seguridad.', 'maria.jpg'),
 ('andres.lopez@ejemplo.com',   'Semestre avanzado, disponible para dar mentoría.', 'andres.jpg'),
 ('carlos.perez@ejemplo.com',   'Diseñador y jugador de videojuegos.',          'carlos.jpg'),
 ('daniel.ramirez@ejemplo.com', 'Empezando en programación, con ganas de aprender.', 'daniel.jpg'),
 ('laura.torres@ejemplo.com',   'Diseño, deporte y ciberseguridad.',            'laura.jpg')
) AS v(correo, bio, foto)
JOIN estudiante e ON e.correo = v.correo;

-- 3. Intereses (5)
INSERT INTO interes (nombre_interes, descripcion) VALUES
('Programacion',   'Desarrollo de software'),
('Videojuegos',    'Juegos y torneos'),
('Ciberseguridad', 'Seguridad informática'),
('Diseno',         'Diseño gráfico e industrial'),
('Deportes',       'Actividad deportiva');

-- 4. Estudiante - interés (14 filas: Programacion 4, Videojuegos 3, Ciberseguridad 3, Diseno 2, Deportes 2)
INSERT INTO estudiante_interes (id_estudiante, id_interes)
SELECT e.id_estudiante, i.id_interes
FROM (VALUES
 ('david.prueba@ejemplo.com',   'Programacion'),
 ('maria.gomez@ejemplo.com',    'Programacion'),
 ('andres.lopez@ejemplo.com',   'Programacion'),
 ('daniel.ramirez@ejemplo.com', 'Programacion'),
 ('david.prueba@ejemplo.com',   'Videojuegos'),
 ('carlos.perez@ejemplo.com',   'Videojuegos'),
 ('daniel.ramirez@ejemplo.com', 'Videojuegos'),
 ('maria.gomez@ejemplo.com',    'Ciberseguridad'),
 ('andres.lopez@ejemplo.com',   'Ciberseguridad'),
 ('laura.torres@ejemplo.com',   'Ciberseguridad'),
 ('carlos.perez@ejemplo.com',   'Diseno'),
 ('laura.torres@ejemplo.com',   'Diseno'),
 ('andres.lopez@ejemplo.com',   'Deportes'),
 ('daniel.ramirez@ejemplo.com', 'Deportes')
) AS v(correo, interes)
JOIN estudiante e ON e.correo = v.correo
JOIN interes i    ON i.nombre_interes = v.interes;

-- 5. Publicaciones
INSERT INTO publicacion (id_estudiante, contenido)
SELECT e.id_estudiante, v.contenido
FROM (VALUES
 ('maria.gomez@ejemplo.com',    'Busco compañeros para estudiar bases de datos.'),
 ('andres.lopez@ejemplo.com',   'Comparto una guía de buenas prácticas en SQL.'),
 ('carlos.perez@ejemplo.com',   '¿Quién se anima al torneo de videojuegos?'),
 ('daniel.ramirez@ejemplo.com', 'Tengo una duda con la tarea de programación.')
) AS v(correo, contenido)
JOIN estudiante e ON e.correo = v.correo;

-- 6. Grupos (3)
INSERT INTO grupo (id_estudiante_creador, nombre_grupo, descripcion, fecha_creacion)
SELECT e.id_estudiante, v.nombre, v.descr, DATE '2026-11-13'
FROM (VALUES
 ('maria.gomez@ejemplo.com',  'Programadores Pascualina',    'Grupo de estudiantes interesados en programación'),
 ('andres.lopez@ejemplo.com', 'Comunidad de Ciberseguridad', 'Grupo dedicado a la seguridad informática'),
 ('carlos.perez@ejemplo.com', 'Gamers Pascualina',           'Grupo de estudiantes interesados en videojuegos')
) AS v(correo, nombre, descr)
JOIN estudiante e ON e.correo = v.correo;

-- 7. Estudiante - grupo (3 integrantes por grupo)
INSERT INTO estudiante_grupo (id_estudiante, id_grupo)
SELECT e.id_estudiante, g.id_grupo
FROM (VALUES
 ('david.prueba@ejemplo.com',   'Programadores Pascualina'),
 ('maria.gomez@ejemplo.com',    'Programadores Pascualina'),
 ('daniel.ramirez@ejemplo.com', 'Programadores Pascualina'),
 ('maria.gomez@ejemplo.com',    'Comunidad de Ciberseguridad'),
 ('andres.lopez@ejemplo.com',   'Comunidad de Ciberseguridad'),
 ('laura.torres@ejemplo.com',   'Comunidad de Ciberseguridad'),
 ('carlos.perez@ejemplo.com',   'Gamers Pascualina'),
 ('daniel.ramirez@ejemplo.com', 'Gamers Pascualina'),
 ('david.prueba@ejemplo.com',   'Gamers Pascualina')
) AS v(correo, grupo)
JOIN estudiante e ON e.correo = v.correo
JOIN grupo g      ON g.nombre_grupo = v.grupo;

-- 8. Eventos (4). La hackatón no pertenece a ningún grupo (id_grupo es opcional).
INSERT INTO evento (id_estudiante_organizador, id_grupo, nombre_evento, descripcion, fecha_hora, ubicacion)
SELECT e.id_estudiante, g.id_grupo, v.nombre, v.descr, v.fecha::timestamp, v.lugar
FROM (VALUES
 ('maria.gomez@ejemplo.com',  'Programadores Pascualina',    'Taller de Programacion',       'Práctica de programación',      '2026-11-20 09:00', 'Laboratorio 1'),
 ('andres.lopez@ejemplo.com', NULL,                          'Hackaton Universitaria',       'Maratón de desarrollo',         '2026-11-22 08:00', 'Auditorio'),
 ('carlos.perez@ejemplo.com', 'Gamers Pascualina',           'Torneo de Videojuegos',        'Torneo entre estudiantes',      '2026-11-25 14:00', 'Sala de sistemas'),
 ('andres.lopez@ejemplo.com', 'Comunidad de Ciberseguridad', 'Conferencia de Ciberseguridad','Charla sobre seguridad',        '2026-11-28 10:00', 'Salon 301')
) AS v(correo, grupo, nombre, descr, fecha, lugar)
JOIN estudiante e ON e.correo = v.correo
LEFT JOIN grupo g ON g.nombre_grupo = v.grupo;

-- 9. Estudiante - evento (Hackaton 5, Taller 3, Conferencia 2, Torneo 2)
INSERT INTO estudiante_evento (id_estudiante, id_evento)
SELECT e.id_estudiante, ev.id_evento
FROM (VALUES
 ('david.prueba@ejemplo.com',   'Hackaton Universitaria'),
 ('maria.gomez@ejemplo.com',    'Hackaton Universitaria'),
 ('andres.lopez@ejemplo.com',   'Hackaton Universitaria'),
 ('carlos.perez@ejemplo.com',   'Hackaton Universitaria'),
 ('laura.torres@ejemplo.com',   'Hackaton Universitaria'),
 ('david.prueba@ejemplo.com',   'Taller de Programacion'),
 ('maria.gomez@ejemplo.com',    'Taller de Programacion'),
 ('daniel.ramirez@ejemplo.com', 'Taller de Programacion'),
 ('maria.gomez@ejemplo.com',    'Conferencia de Ciberseguridad'),
 ('andres.lopez@ejemplo.com',   'Conferencia de Ciberseguridad'),
 ('carlos.perez@ejemplo.com',   'Torneo de Videojuegos'),
 ('daniel.ramirez@ejemplo.com', 'Torneo de Videojuegos')
) AS v(correo, evento)
JOIN estudiante e ON e.correo = v.correo
JOIN evento ev    ON ev.nombre_evento = v.evento;

-- 10. Seguidores (nadie se sigue a sí mismo)
INSERT INTO seguidor (id_seguidor, id_seguido)
SELECT s1.id_estudiante, s2.id_estudiante
FROM (VALUES
 ('david.prueba@ejemplo.com',   'maria.gomez@ejemplo.com'),
 ('andres.lopez@ejemplo.com',   'maria.gomez@ejemplo.com'),
 ('carlos.perez@ejemplo.com',   'maria.gomez@ejemplo.com'),
 ('daniel.ramirez@ejemplo.com', 'maria.gomez@ejemplo.com'),
 ('david.prueba@ejemplo.com',   'andres.lopez@ejemplo.com'),
 ('maria.gomez@ejemplo.com',    'andres.lopez@ejemplo.com'),
 ('daniel.ramirez@ejemplo.com', 'andres.lopez@ejemplo.com'),
 ('laura.torres@ejemplo.com',   'andres.lopez@ejemplo.com'),
 ('david.prueba@ejemplo.com',   'laura.torres@ejemplo.com'),
 ('carlos.perez@ejemplo.com',   'david.prueba@ejemplo.com')
) AS v(seguidor, seguido)
JOIN estudiante s1 ON s1.correo = v.seguidor
JOIN estudiante s2 ON s2.correo = v.seguido;

-- Verificación rápida: cantidad de filas por tabla
SELECT 'estudiante' AS tabla, COUNT(*) AS filas FROM estudiante
UNION ALL SELECT 'perfil', COUNT(*) FROM perfil
UNION ALL SELECT 'interes', COUNT(*) FROM interes
UNION ALL SELECT 'estudiante_interes', COUNT(*) FROM estudiante_interes
UNION ALL SELECT 'publicacion', COUNT(*) FROM publicacion
UNION ALL SELECT 'grupo', COUNT(*) FROM grupo
UNION ALL SELECT 'estudiante_grupo', COUNT(*) FROM estudiante_grupo
UNION ALL SELECT 'evento', COUNT(*) FROM evento
UNION ALL SELECT 'estudiante_evento', COUNT(*) FROM estudiante_evento
UNION ALL SELECT 'seguidor', COUNT(*) FROM seguidor;
