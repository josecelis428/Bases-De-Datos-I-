-- Red Social Estudiantil Pascualina | Microsoft SQL Server
-- Ejecutar dentro de una base de datos vacía, con SQL Server 2016+.
CREATE TABLE dbo.estudiante (
 id_estudiante INT IDENTITY(1,1) NOT NULL,
 nombre VARCHAR(50) NOT NULL, apellido VARCHAR(50) NOT NULL,
 correo VARCHAR(100) NOT NULL, programa VARCHAR(80) NOT NULL,
 semestre SMALLINT NOT NULL,
 CONSTRAINT pk_estudiante PRIMARY KEY (id_estudiante),
 CONSTRAINT uq_estudiante_correo UNIQUE (correo),
 CONSTRAINT chk_estudiante_semestre CHECK (semestre BETWEEN 1 AND 12)
);
CREATE TABLE dbo.interes (
 id_interes INT IDENTITY(1,1) NOT NULL, nombre_interes VARCHAR(50) NOT NULL,
 descripcion VARCHAR(200), CONSTRAINT pk_interes PRIMARY KEY (id_interes),
 CONSTRAINT uq_interes_nombre UNIQUE (nombre_interes)
);
CREATE TABLE dbo.perfil (
 id_perfil INT IDENTITY(1,1) NOT NULL, id_estudiante INT NOT NULL,
 biografia VARCHAR(300), foto VARCHAR(150), contacto VARCHAR(100),
 datos_extra NVARCHAR(MAX) NOT NULL CONSTRAINT df_perfil_datos_extra DEFAULT N'{}',
 CONSTRAINT pk_perfil PRIMARY KEY (id_perfil), CONSTRAINT uq_perfil_estudiante UNIQUE (id_estudiante),
 CONSTRAINT ck_perfil_datos_extra_json CHECK (ISJSON(datos_extra)=1),
 CONSTRAINT fk_perfil_estudiante FOREIGN KEY (id_estudiante) REFERENCES dbo.estudiante(id_estudiante) ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE dbo.publicacion (
 id_publicacion INT IDENTITY(1,1) NOT NULL, id_estudiante INT NOT NULL,
 contenido VARCHAR(500) NOT NULL, fecha_hora DATETIME2 NOT NULL CONSTRAINT df_publicacion_fecha DEFAULT SYSDATETIME(),
 CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
 CONSTRAINT fk_publicacion_estudiante FOREIGN KEY (id_estudiante) REFERENCES dbo.estudiante(id_estudiante) ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE dbo.grupo (
 id_grupo INT IDENTITY(1,1) NOT NULL, id_estudiante_creador INT NOT NULL,
 nombre_grupo VARCHAR(80) NOT NULL, descripcion VARCHAR(300), fecha_creacion DATE NOT NULL CONSTRAINT df_grupo_fecha DEFAULT CONVERT(date, GETDATE()),
 CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
 CONSTRAINT fk_grupo_creador FOREIGN KEY (id_estudiante_creador) REFERENCES dbo.estudiante(id_estudiante) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE dbo.evento (
 id_evento INT IDENTITY(1,1) NOT NULL, id_estudiante_organizador INT NOT NULL, id_grupo INT NULL,
 nombre_evento VARCHAR(100) NOT NULL, descripcion VARCHAR(300), fecha_hora DATETIME2 NOT NULL, ubicacion VARCHAR(150) NOT NULL,
 CONSTRAINT pk_evento PRIMARY KEY (id_evento),
 CONSTRAINT fk_evento_organizador FOREIGN KEY (id_estudiante_organizador) REFERENCES dbo.estudiante(id_estudiante) ON DELETE NO ACTION ON UPDATE NO ACTION,
 CONSTRAINT fk_evento_grupo FOREIGN KEY (id_grupo) REFERENCES dbo.grupo(id_grupo) ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE dbo.estudiante_grupo (
 id_estudiante INT NOT NULL, id_grupo INT NOT NULL, CONSTRAINT pk_estudiante_grupo PRIMARY KEY (id_estudiante,id_grupo),
 CONSTRAINT fk_estudiante_grupo_estudiante FOREIGN KEY (id_estudiante) REFERENCES dbo.estudiante(id_estudiante) ON DELETE CASCADE ON UPDATE NO ACTION,
 CONSTRAINT fk_estudiante_grupo_grupo FOREIGN KEY (id_grupo) REFERENCES dbo.grupo(id_grupo) ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE dbo.estudiante_evento (
 id_estudiante INT NOT NULL, id_evento INT NOT NULL, CONSTRAINT pk_estudiante_evento PRIMARY KEY (id_estudiante,id_evento),
 CONSTRAINT fk_estudiante_evento_estudiante FOREIGN KEY (id_estudiante) REFERENCES dbo.estudiante(id_estudiante) ON DELETE CASCADE ON UPDATE NO ACTION,
 CONSTRAINT fk_estudiante_evento_evento FOREIGN KEY (id_evento) REFERENCES dbo.evento(id_evento) ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE dbo.estudiante_interes (
 id_estudiante INT NOT NULL, id_interes INT NOT NULL, CONSTRAINT pk_estudiante_interes PRIMARY KEY (id_estudiante,id_interes),
 CONSTRAINT fk_estudiante_interes_estudiante FOREIGN KEY (id_estudiante) REFERENCES dbo.estudiante(id_estudiante) ON DELETE CASCADE ON UPDATE NO ACTION,
 CONSTRAINT fk_estudiante_interes_interes FOREIGN KEY (id_interes) REFERENCES dbo.interes(id_interes) ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE dbo.seguidor (
 id_seguidor INT NOT NULL, id_seguido INT NOT NULL, CONSTRAINT pk_seguidor PRIMARY KEY (id_seguidor,id_seguido),
 CONSTRAINT chk_seguidor_no_propio CHECK (id_seguidor <> id_seguido),
 CONSTRAINT fk_seguidor_seguidor FOREIGN KEY (id_seguidor) REFERENCES dbo.estudiante(id_estudiante) ON DELETE NO ACTION ON UPDATE NO ACTION,
 CONSTRAINT fk_seguidor_seguido FOREIGN KEY (id_seguido) REFERENCES dbo.estudiante(id_estudiante) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- SQL Server no ofrece un tipo JSON dedicado en estas versiones: se valida NVARCHAR(MAX) con ISJSON.
-- Excepción documentada: seguidor usa NO ACTION en ambas FK para evitar múltiples rutas de cascada hacia la misma tabla; al eliminar un estudiante, borre primero sus filas de seguidor dentro de una transacción.
