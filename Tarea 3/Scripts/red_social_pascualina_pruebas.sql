INSERT INTO estudiante (nombre, apellido, correo, programa, semestre) VALUES
    ('Ana',    'Gomez', 'ana.gomez@ejemplo.edu.co',   'Ingenieria de Software', 3),
    ('Luis',   'Perez', 'luis.perez@ejemplo.edu.co',  'Ingenieria de Sistemas', 5),
    ('Camila', 'Rios',  'camila.rios@ejemplo.edu.co', 'Ingenieria de Software', 2);

INSERT INTO interes (nombre_interes, descripcion) VALUES
    ('Programacion', 'Interes por programar'),
    ('Musica',       'Interes por la musica'),
    ('Videojuegos',  'Interes por los videojuegos');

INSERT INTO perfil (id_estudiante, biografia, foto, contacto) VALUES
    (1, 'Estudiante de software', 'ana.jpg',  '3001234567'),
    (2, 'Me gusta la musica',     'luis.jpg', 'https://ejemplo.com/luis');

INSERT INTO publicacion (id_estudiante, contenido) VALUES
    (1, 'Alguien tiene apuntes de Bases de Datos?'),
    (2, 'Comparto un recurso sobre PostgreSQL.');

INSERT INTO grupo (id_estudiante_creador, nombre_grupo, descripcion) VALUES
    (1, 'Estudio de Bases de Datos', 'Repaso semanal de SQL'),
    (2, 'Club de videojuegos',       'Torneos y juegos de mesa');

INSERT INTO evento (id_estudiante_organizador, id_grupo, nombre_evento, descripcion, fecha_hora, ubicacion) VALUES
    (1, 1,    'Taller de SQL',    'Practica de DDL',      '2026-11-05 14:00', 'Bloque 1'),
    (2, NULL, 'Torneo de futbol', 'Evento independiente', '2026-11-25 10:00', 'Cancha');

INSERT INTO estudiante_grupo   (id_estudiante, id_grupo)   VALUES (1, 1), (2, 1), (3, 2);
INSERT INTO estudiante_evento  (id_estudiante, id_evento)  VALUES (1, 1), (2, 1);
INSERT INTO estudiante_interes (id_estudiante, id_interes) VALUES (1, 1), (1, 3), (2, 2);
INSERT INTO seguidor           (id_seguidor, id_seguido)   VALUES (1, 2), (2, 1), (3, 1);

DO $$
BEGIN
    INSERT INTO estudiante (nombre, apellido, correo, programa, semestre)
    VALUES ('Otro', 'Usuario', 'ana.gomez@ejemplo.edu.co', 'Ingenieria de Software', 1);
    RAISE NOTICE 'PRUEBA 1 FALLO: se acepto un correo duplicado';
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'PRUEBA 1 OK (correo duplicado rechazado): %', SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO estudiante (nombre, apellido, correo, programa, semestre)
    VALUES ('Pedro', 'Mora', 'pedro.mora@ejemplo.edu.co', 'Ingenieria de Software', 15);
    RAISE NOTICE 'PRUEBA 2 FALLO: se acepto el semestre 15';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'PRUEBA 2 OK (semestre fuera de rango rechazado): %', SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO perfil (id_estudiante, biografia)
    SELECT id_estudiante, 'Segundo perfil' FROM estudiante WHERE correo = 'ana.gomez@ejemplo.edu.co';
    RAISE NOTICE 'PRUEBA 3 FALLO: se acepto un segundo perfil';
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'PRUEBA 3 OK (segundo perfil rechazado): %', SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO publicacion (id_estudiante, contenido) VALUES (999, 'Autor inexistente');
    RAISE NOTICE 'PRUEBA 4 FALLO: se acepto un autor inexistente';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'PRUEBA 4 OK (autor inexistente rechazado): %', SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO seguidor (id_seguidor, id_seguido)
    SELECT id_estudiante, id_estudiante FROM estudiante WHERE correo = 'ana.gomez@ejemplo.edu.co';
    RAISE NOTICE 'PRUEBA 5 FALLO: un estudiante pudo seguirse a si mismo';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'PRUEBA 5 OK (auto-seguimiento rechazado): %', SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO seguidor (id_seguidor, id_seguido)
    SELECT a.id_estudiante, b.id_estudiante
    FROM estudiante a, estudiante b
    WHERE a.correo = 'ana.gomez@ejemplo.edu.co' AND b.correo = 'luis.perez@ejemplo.edu.co';
    RAISE NOTICE 'PRUEBA 6 FALLO: se acepto un seguimiento repetido';
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'PRUEBA 6 OK (seguimiento repetido rechazado): %', SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO estudiante (id_estudiante, nombre, apellido, correo, programa, semestre)
    VALUES (100, 'Manual', 'Id', 'manual@ejemplo.edu.co', 'Ingenieria de Software', 1);
    RAISE NOTICE 'PRUEBA 7 FALLO: se acepto un id escrito a mano';
EXCEPTION
    WHEN SQLSTATE '428C9' THEN
        RAISE NOTICE 'PRUEBA 7 OK (id manual rechazado): %', SQLERRM;
END $$;

DO $$
BEGIN
    DELETE FROM estudiante WHERE correo = 'ana.gomez@ejemplo.edu.co';
    RAISE NOTICE 'PRUEBA 8 FALLO: se borro a un estudiante que creo grupos';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'PRUEBA 8 OK (borrado de creador bloqueado por RESTRICT): %', SQLERRM;
END $$;

DO $$
DECLARE
    antes_grupo INT;
    antes_seguidor INT;
    despues_grupo INT;
    despues_seguidor INT;
BEGIN
    SELECT count(*) INTO antes_grupo FROM estudiante_grupo
    WHERE id_estudiante = (SELECT id_estudiante FROM estudiante WHERE correo = 'camila.rios@ejemplo.edu.co');
    SELECT count(*) INTO antes_seguidor FROM seguidor
    WHERE id_seguidor = (SELECT id_estudiante FROM estudiante WHERE correo = 'camila.rios@ejemplo.edu.co');

    DELETE FROM estudiante WHERE correo = 'camila.rios@ejemplo.edu.co';

    SELECT count(*) INTO despues_grupo FROM estudiante_grupo WHERE id_estudiante = 3;
    SELECT count(*) INTO despues_seguidor FROM seguidor WHERE id_seguidor = 3;

    RAISE NOTICE 'PRUEBA 9 OK (borrado en cascada): estudiante_grupo % -> %, seguidor % -> %',
        antes_grupo, despues_grupo, antes_seguidor, despues_seguidor;
END $$;
