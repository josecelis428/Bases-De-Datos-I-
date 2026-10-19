CREATE TABLE estudiante (
    id_estudiante INT GENERATED ALWAYS AS IDENTITY,
    nombre        VARCHAR(50)  NOT NULL,
    apellido      VARCHAR(50)  NOT NULL,
    correo        VARCHAR(100) NOT NULL,
    programa      VARCHAR(80)  NOT NULL,
    semestre      SMALLINT     NOT NULL,

    CONSTRAINT pk_estudiante
        PRIMARY KEY (id_estudiante),

    CONSTRAINT uq_estudiante_correo
        UNIQUE (correo),

    CONSTRAINT ck_estudiante_semestre
        CHECK (semestre BETWEEN 1 AND 12)
);

CREATE TABLE interes (
    id_interes     INT GENERATED ALWAYS AS IDENTITY,
    nombre_interes VARCHAR(50) NOT NULL,
    descripcion    VARCHAR(200),

    CONSTRAINT pk_interes
        PRIMARY KEY (id_interes),

    CONSTRAINT uq_interes_nombre
        UNIQUE (nombre_interes)
);

CREATE TABLE perfil (
    id_perfil     INT GENERATED ALWAYS AS IDENTITY,
    id_estudiante INT NOT NULL,
    biografia     VARCHAR(300),
    foto          VARCHAR(150),
    contacto      VARCHAR(100),

    CONSTRAINT pk_perfil
        PRIMARY KEY (id_perfil),

    CONSTRAINT uq_perfil_estudiante
        UNIQUE (id_estudiante),

    CONSTRAINT fk_perfil_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE publicacion (
    id_publicacion INT GENERATED ALWAYS AS IDENTITY,
    id_estudiante  INT          NOT NULL,
    contenido      VARCHAR(500) NOT NULL,
    fecha_hora     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_publicacion
        PRIMARY KEY (id_publicacion),

    CONSTRAINT fk_publicacion_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE grupo (
    id_grupo              INT GENERATED ALWAYS AS IDENTITY,
    id_estudiante_creador INT         NOT NULL,
    nombre_grupo          VARCHAR(80) NOT NULL,
    descripcion           VARCHAR(300),
    fecha_creacion        DATE        NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT pk_grupo
        PRIMARY KEY (id_grupo),

    CONSTRAINT fk_grupo_creador
        FOREIGN KEY (id_estudiante_creador)
        REFERENCES estudiante (id_estudiante)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE evento (
    id_evento                 INT GENERATED ALWAYS AS IDENTITY,
    id_estudiante_organizador INT          NOT NULL,
    id_grupo                  INT,
    nombre_evento             VARCHAR(100) NOT NULL,
    descripcion               VARCHAR(300),
    fecha_hora                TIMESTAMP    NOT NULL,
    ubicacion                 VARCHAR(150) NOT NULL,

    CONSTRAINT pk_evento
        PRIMARY KEY (id_evento),

    CONSTRAINT fk_evento_organizador
        FOREIGN KEY (id_estudiante_organizador)
        REFERENCES estudiante (id_estudiante)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_evento_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE estudiante_grupo (
    id_estudiante INT NOT NULL,
    id_grupo      INT NOT NULL,

    CONSTRAINT pk_estudiante_grupo
        PRIMARY KEY (id_estudiante, id_grupo),

    CONSTRAINT fk_estudiante_grupo_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_estudiante_grupo_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE estudiante_evento (
    id_estudiante INT NOT NULL,
    id_evento     INT NOT NULL,

    CONSTRAINT pk_estudiante_evento
        PRIMARY KEY (id_estudiante, id_evento),

    CONSTRAINT fk_estudiante_evento_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_estudiante_evento_evento
        FOREIGN KEY (id_evento)
        REFERENCES evento (id_evento)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE estudiante_interes (
    id_estudiante INT NOT NULL,
    id_interes    INT NOT NULL,

    CONSTRAINT pk_estudiante_interes
        PRIMARY KEY (id_estudiante, id_interes),

    CONSTRAINT fk_estudiante_interes_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_estudiante_interes_interes
        FOREIGN KEY (id_interes)
        REFERENCES interes (id_interes)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE seguidor (
    id_seguidor INT NOT NULL,
    id_seguido  INT NOT NULL,

    CONSTRAINT pk_seguidor
        PRIMARY KEY (id_seguidor, id_seguido),

    CONSTRAINT ck_seguidor_no_propio
        CHECK (id_seguidor <> id_seguido),

    CONSTRAINT fk_seguidor_estudiante_seguidor
        FOREIGN KEY (id_seguidor)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_seguidor_estudiante_seguido
        FOREIGN KEY (id_seguido)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
