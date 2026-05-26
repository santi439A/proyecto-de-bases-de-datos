-- =====================================================
-- QUINDIOFLIX - CREACIÓN DE TABLAS (MODIFICADO)
-- Usando tablespace USERS por defecto
-- Base de Datos II
-- =====================================================

-- =====================================================
-- 1. TABLAS MAESTRAS
-- =====================================================

CREATE TABLE plan (
    plan_id NUMBER(2),
    nombre VARCHAR2(20) NOT NULL,
    precio_mensual NUMBER(10,2) NOT NULL,
    num_pantallas NUMBER(1) NOT NULL,
    max_perfiles NUMBER(1) NOT NULL,
    calidad VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_plan PRIMARY KEY (plan_id),
    CONSTRAINT uq_plan_nombre UNIQUE (nombre),
    CONSTRAINT chk_plan_pantallas CHECK (num_pantallas IN (1,2,4)),
    CONSTRAINT chk_plan_perfiles CHECK (max_perfiles IN (2,3,5)),
    CONSTRAINT chk_plan_calidad CHECK (calidad IN ('SD','HD','4K'))
);

CREATE TABLE categoria (
    categoria_id NUMBER(2),
    nombre VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (categoria_id),
    CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
);

CREATE TABLE genero (
    genero_id NUMBER(3),
    nombre VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_genero PRIMARY KEY (genero_id),
    CONSTRAINT uq_genero_nombre UNIQUE (nombre)
);

CREATE TABLE departamento (
    departamento_id NUMBER(3),
    nombre VARCHAR2(50) NOT NULL,
    jefe_id NUMBER(5),
    CONSTRAINT pk_departamento PRIMARY KEY (departamento_id),
    CONSTRAINT uq_departamento_nombre UNIQUE (nombre)
);

-- =====================================================
-- 2. EQUIPO DE TRABAJO
-- =====================================================

CREATE TABLE empleado (
    empleado_id NUMBER(5),
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(20),
    cargo VARCHAR2(50) NOT NULL,
    departamento_id NUMBER(3) NOT NULL,
    supervisor_id NUMBER(5),
    CONSTRAINT pk_empleado PRIMARY KEY (empleado_id),
    CONSTRAINT uq_empleado_email UNIQUE (email),
    CONSTRAINT fk_empleado_departamento FOREIGN KEY (departamento_id)
        REFERENCES departamento(departamento_id),
    CONSTRAINT fk_empleado_supervisor FOREIGN KEY (supervisor_id)
        REFERENCES empleado(empleado_id)
);

ALTER TABLE departamento
    ADD CONSTRAINT fk_departamento_jefe
    FOREIGN KEY (jefe_id)
    REFERENCES empleado(empleado_id);

-- =====================================================
-- 3. USUARIOS
-- =====================================================

CREATE TABLE usuario (
    usuario_id NUMBER(5),
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(20),
    fecha_nacimiento DATE NOT NULL,
    ciudad_residencia VARCHAR2(100) NOT NULL,
    plan_id NUMBER(2) NOT NULL,
    fecha_registro DATE NOT NULL,
    estado_cuenta VARCHAR2(12) DEFAULT 'ACTIVO' NOT NULL,
    fecha_ultimo_pago DATE,
    CONSTRAINT pk_usuario PRIMARY KEY (usuario_id),
    CONSTRAINT uq_usuario_email UNIQUE (email),
    CONSTRAINT chk_usuario_estado CHECK (estado_cuenta IN ('ACTIVO','SUSPENDIDO','INACTIVO')),
    CONSTRAINT fk_usuario_plan FOREIGN KEY (plan_id)
        REFERENCES plan(plan_id)
);

CREATE TABLE perfil (
    perfil_id NUMBER(5),
    usuario_id NUMBER(5) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    avatar VARCHAR2(200),
    tipo VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_perfil PRIMARY KEY (perfil_id),
    CONSTRAINT chk_perfil_tipo CHECK (tipo IN ('ADULTO','INFANTIL')),
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuario(usuario_id)
);

CREATE TABLE referido (
    referido_id NUMBER(5),
    usuario_referidor_id NUMBER(5) NOT NULL,
    usuario_referido_id NUMBER(5) NOT NULL,
    beneficio VARCHAR2(100),
    estado_beneficio VARCHAR2(15) DEFAULT 'PENDIENTE' NOT NULL,
    fecha_referido DATE NOT NULL,
    CONSTRAINT pk_referido PRIMARY KEY (referido_id),
    CONSTRAINT uq_referido_usuario UNIQUE (usuario_referido_id),
    CONSTRAINT chk_referido_estado CHECK (estado_beneficio IN ('PENDIENTE','APLICADO','VENCIDO')),
    CONSTRAINT fk_referido_referidor FOREIGN KEY (usuario_referidor_id)
        REFERENCES usuario(usuario_id),
    CONSTRAINT fk_referido_referido FOREIGN KEY (usuario_referido_id)
        REFERENCES usuario(usuario_id)
);

-- =====================================================
-- 4. CATALOGO MULTIMEDIA
-- =====================================================

CREATE TABLE contenido (
    contenido_id NUMBER(5),
    categoria_id NUMBER(2) NOT NULL,
    titulo VARCHAR2(200) NOT NULL,
    anno_lanzamiento NUMBER(4) NOT NULL,
    duracion_minutos NUMBER(5),
    sinopsis CLOB,
    clasificacion_edad VARCHAR2(5) NOT NULL,
    fecha_agregado DATE NOT NULL,
    es_original NUMBER(1) DEFAULT 0 NOT NULL,
    empleado_responsable_id NUMBER(5) NOT NULL,
    CONSTRAINT pk_contenido PRIMARY KEY (contenido_id),
    CONSTRAINT chk_contenido_clasif CHECK (clasificacion_edad IN ('TP','+7','+13','+16','+18')),
    CONSTRAINT chk_contenido_original CHECK (es_original IN (0,1)),
    CONSTRAINT fk_contenido_categoria FOREIGN KEY (categoria_id)
        REFERENCES categoria(categoria_id),
    CONSTRAINT fk_contenido_empleado FOREIGN KEY (empleado_responsable_id)
        REFERENCES empleado(empleado_id)
);

CREATE TABLE contenido_genero (
    contenido_id NUMBER(5) NOT NULL,
    genero_id NUMBER(3) NOT NULL,
    CONSTRAINT pk_contenido_genero PRIMARY KEY (contenido_id, genero_id),
    CONSTRAINT fk_cg_contenido FOREIGN KEY (contenido_id)
        REFERENCES contenido(contenido_id),
    CONSTRAINT fk_cg_genero FOREIGN KEY (genero_id)
        REFERENCES genero(genero_id)
);

CREATE TABLE contenido_relacionado (
    contenido_origen_id NUMBER(5) NOT NULL,
    contenido_relacionado_id NUMBER(5) NOT NULL,
    tipo_relacion VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_contenido_rel PRIMARY KEY (contenido_origen_id, contenido_relacionado_id),
    CONSTRAINT chk_contenido_rel_diff CHECK (contenido_origen_id <> contenido_relacionado_id),
    CONSTRAINT chk_contenido_tipo_rel CHECK (tipo_relacion IN ('SECUELA','PRECUELA','REMAKE','SPIN_OFF','VERSION_EXTENDIDA')),
    CONSTRAINT fk_cr_origen FOREIGN KEY (contenido_origen_id)
        REFERENCES contenido(contenido_id),
    CONSTRAINT fk_cr_relacionado FOREIGN KEY (contenido_relacionado_id)
        REFERENCES contenido(contenido_id)
);

CREATE TABLE temporada (
    temporada_id NUMBER(5),
    contenido_id NUMBER(5) NOT NULL,
    numero NUMBER(2) NOT NULL,
    CONSTRAINT pk_temporada PRIMARY KEY (temporada_id),
    CONSTRAINT uq_temporada_num UNIQUE (contenido_id, numero),
    CONSTRAINT fk_temporada_contenido FOREIGN KEY (contenido_id)
        REFERENCES contenido(contenido_id)
);

CREATE TABLE episodio (
    episodio_id NUMBER(5),
    temporada_id NUMBER(5) NOT NULL,
    numero NUMBER(3) NOT NULL,
    titulo VARCHAR2(200) NOT NULL,
    duracion_minutos NUMBER(5) NOT NULL,
    CONSTRAINT pk_episodio PRIMARY KEY (episodio_id),
    CONSTRAINT uq_episodio_num UNIQUE (temporada_id, numero),
    CONSTRAINT fk_episodio_temporada FOREIGN KEY (temporada_id)
        REFERENCES temporada(temporada_id)
);

-- =====================================================
-- 5. CONSUMO Y MODERACION
-- =====================================================

CREATE TABLE reproduccion (
    reproduccion_id NUMBER(10),
    perfil_id NUMBER(5) NOT NULL,
    contenido_id NUMBER(5) NOT NULL,
    episodio_id NUMBER(5),
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP,
    dispositivo VARCHAR2(20) NOT NULL,
    porcentaje_avance NUMBER(5,2) DEFAULT 0 NOT NULL,
    CONSTRAINT pk_reproduccion PRIMARY KEY (reproduccion_id),
    CONSTRAINT chk_reproduccion_disp CHECK (dispositivo IN ('CELULAR','TABLET','TV','COMPUTADOR')),
    CONSTRAINT chk_reproduccion_avance CHECK (porcentaje_avance BETWEEN 0 AND 100),
    CONSTRAINT fk_reproduccion_perfil FOREIGN KEY (perfil_id)
        REFERENCES perfil(perfil_id),
    CONSTRAINT fk_reproduccion_contenido FOREIGN KEY (contenido_id)
        REFERENCES contenido(contenido_id),
    CONSTRAINT fk_reproduccion_episodio FOREIGN KEY (episodio_id)
        REFERENCES episodio(episodio_id)
);

CREATE TABLE favorito (
    perfil_id NUMBER(5) NOT NULL,
    contenido_id NUMBER(5) NOT NULL,
    fecha_agregado DATE NOT NULL,
    CONSTRAINT pk_favorito PRIMARY KEY (perfil_id, contenido_id),
    CONSTRAINT fk_favorito_perfil FOREIGN KEY (perfil_id)
        REFERENCES perfil(perfil_id),
    CONSTRAINT fk_favorito_contenido FOREIGN KEY (contenido_id)
        REFERENCES contenido(contenido_id)
);

CREATE TABLE resena (
    resena_id NUMBER(10),
    perfil_id NUMBER(5) NOT NULL,
    contenido_id NUMBER(5) NOT NULL,
    calificacion NUMBER(1) NOT NULL,
    texto CLOB,
    fecha_publicacion DATE NOT NULL,
    CONSTRAINT pk_resena PRIMARY KEY (resena_id),
    CONSTRAINT uq_resena_perfil_contenido UNIQUE (perfil_id, contenido_id),
    CONSTRAINT chk_resena_calif CHECK (calificacion BETWEEN 1 AND 5),
    CONSTRAINT fk_resena_perfil FOREIGN KEY (perfil_id)
        REFERENCES perfil(perfil_id),
    CONSTRAINT fk_resena_contenido FOREIGN KEY (contenido_id)
        REFERENCES contenido(contenido_id)
);

CREATE TABLE reporte (
    reporte_id NUMBER(10),
    contenido_id NUMBER(5) NOT NULL,
    perfil_id NUMBER(5) NOT NULL,
    moderador_id NUMBER(5),
    motivo VARCHAR2(500) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'PENDIENTE' NOT NULL,
    fecha_reporte DATE NOT NULL,
    fecha_resolucion DATE,
    CONSTRAINT pk_reporte PRIMARY KEY (reporte_id),
    CONSTRAINT chk_reporte_estado CHECK (estado IN ('PENDIENTE','EN_REVISION','APROBADO','RECHAZADO')),
    CONSTRAINT fk_reporte_contenido FOREIGN KEY (contenido_id)
        REFERENCES contenido(contenido_id),
    CONSTRAINT fk_reporte_perfil FOREIGN KEY (perfil_id)
        REFERENCES perfil(perfil_id),
    CONSTRAINT fk_reporte_moderador FOREIGN KEY (moderador_id)
        REFERENCES empleado(empleado_id)
);

-- =====================================================
-- 6. FACTURACION Y PAGOS
-- =====================================================

CREATE TABLE factura (
    factura_id NUMBER(10),
    usuario_id NUMBER(5) NOT NULL,
    periodo VARCHAR2(7) NOT NULL,
    monto_total NUMBER(10,2) NOT NULL,
    estado_factura VARCHAR2(15) DEFAULT 'PENDIENTE' NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    CONSTRAINT pk_factura PRIMARY KEY (factura_id),
    CONSTRAINT uq_factura_usuario_periodo UNIQUE (usuario_id, periodo),
    CONSTRAINT chk_factura_estado CHECK (estado_factura IN ('PENDIENTE','PAGADA','VENCIDA','ANULADA')),
    CONSTRAINT fk_factura_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuario(usuario_id)
);

CREATE TABLE pago (
    pago_id NUMBER(10),
    factura_id NUMBER(10) NOT NULL,
    fecha_pago DATE NOT NULL,
    monto_pagado NUMBER(10,2) NOT NULL,
    metodo_pago VARCHAR2(20) NOT NULL,
    estado_pago VARCHAR2(15) DEFAULT 'PENDIENTE' NOT NULL,
    referencia VARCHAR2(100),
    CONSTRAINT pk_pago PRIMARY KEY (pago_id),
    CONSTRAINT chk_pago_metodo CHECK (metodo_pago IN ('TCREDITO','TDEBITO','PSE','NEQUI','DAVIPLATA')),
    CONSTRAINT chk_pago_estado CHECK (estado_pago IN ('EXITOSO','FALLIDO','PENDIENTE','REEMBOLSADO')),
    CONSTRAINT fk_pago_factura FOREIGN KEY (factura_id)
        REFERENCES factura(factura_id)
);

-- =====================================================
-- 7. SECUENCIAS
-- =====================================================

CREATE SEQUENCE seq_plan START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_categoria START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_genero START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_departamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_empleado START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_perfil START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_referido START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_contenido START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_temporada START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_episodio START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reproduccion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_resena START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reporte START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_factura START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pago START WITH 1 INCREMENT BY 1;

-- =====================================================
-- 8. INDICES ADICIONALES
-- =====================================================

CREATE INDEX idx_contenido_categoria_anno
    ON contenido(categoria_id, anno_lanzamiento);

CREATE INDEX idx_contenido_clasif
    ON contenido(clasificacion_edad);

CREATE INDEX idx_contenido_genero_genero
    ON contenido_genero(genero_id);

CREATE INDEX idx_temporada_contenido
    ON temporada(contenido_id);

CREATE INDEX idx_episodio_temporada
    ON episodio(temporada_id);

CREATE INDEX idx_usuario_plan_ciudad
    ON usuario(plan_id, ciudad_residencia);

CREATE INDEX idx_perfil_usuario
    ON perfil(usuario_id);

CREATE INDEX idx_referido_referidor
    ON referido(usuario_referidor_id);

CREATE INDEX idx_reproduccion_perfil_fecha
    ON reproduccion(perfil_id, fecha_inicio);

CREATE INDEX idx_reproduccion_contenido
    ON reproduccion(contenido_id);

CREATE INDEX idx_resena_contenido
    ON resena(contenido_id);

CREATE INDEX idx_reporte_estado
    ON reporte(estado);

CREATE INDEX idx_pago_factura_fecha
    ON pago(factura_id, fecha_pago);

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================