-- =====================================================
-- SCRIPT DE CREACIÓN DE TABLAS - QUINDIOFLIX
-- Base de Datos II - Universidad del Quindío
-- =====================================================

-- Tablespaces
CREATE TABLESPACE ts_quindioflix_data 
    DATAFILE 'quindioflix_data01.dbf' 
    SIZE 100M
    AUTOEXTEND ON NEXT 50M
    MAXSIZE 500M;
    
CREATE TABLESPACE ts_quindioflix_indx 
    DATAFILE 'quindioflix_indx01.dbf' 
    SIZE 50M
    AUTOEXTEND ON NEXT 25M
    MAXSIZE 200M;

-- =====================================================
-- 1. TABLAS MAESTRAS
-- =====================================================

-- PLAN
CREATE TABLE plan (
    plan_id NUMBER(2) PRIMARY KEY,
    nombre VARCHAR2(20) NOT NULL UNIQUE,
    precio NUMBER(10,2) NOT NULL,
    num_pantallas NUMBER(1) NOT NULL,
    calidad VARCHAR2(10) NOT NULL,
    CONSTRAINT chk_plan_calidad CHECK (calidad IN ('SD','HD','4K'))
) TABLESPACE ts_quindioflix_data;

-- GENERO
CREATE TABLE genero (
    genero_id NUMBER(3) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
) TABLESPACE ts_quindioflix_data;

-- DEPARTAMENTO
CREATE TABLE departamento (
    departamento_id NUMBER(3) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    jefe_id NUMBER(5)
) TABLESPACE ts_quindioflix_data;

-- =====================================================
-- 2. TABLAS DE CONTENIDO
-- =====================================================

-- CONTENIDO
CREATE TABLE contenido (
    contenido_id NUMBER(5) PRIMARY KEY,
    titulo VARCHAR2(200) NOT NULL,
    anno_lanzamiento NUMBER(4) NOT NULL,
    duracion NUMBER(5),
    sinopsis CLOB,
    clasificacion_edad VARCHAR2(5) NOT NULL,
    fecha_agregado DATE NOT NULL,
    tipo VARCHAR2(20) NOT NULL,
    es_original NUMBER(1) DEFAULT 0,
    contenido_relacionado_id NUMBER(5),
    tipo_relacion VARCHAR2(30),
    empleado_id NUMBER(5),
    CONSTRAINT chk_clasificacion CHECK (clasificacion_edad IN ('TP','+7','+13','+16','+18')),
    CONSTRAINT chk_tipo_contenido CHECK (tipo IN ('PELICULA','SERIE','DOCUMENTAL','MUSICA','PODCAST')),
    CONSTRAINT chk_original CHECK (es_original IN (0,1)),
    CONSTRAINT fk_contenido_relacionado FOREIGN KEY (contenido_relacionado_id) 
        REFERENCES contenido(contenido_id),
    CONSTRAINT fk_empleado_contenido FOREIGN KEY (empleado_id) 
        REFERENCES empleado(empleado_id)
) TABLESPACE ts_quindioflix_data;

-- CONTENIDO_GENERO (Relación N:N)
CREATE TABLE contenido_genero (
    contenido_genero_id NUMBER(5) PRIMARY KEY,
    contenido_id NUMBER(5) NOT NULL,
    genero_id NUMBER(3) NOT NULL,
    CONSTRAINT fk_cg_contenido FOREIGN KEY (contenido_id) REFERENCES contenido(contenido_id),
    CONSTRAINT fk_cg_genero FOREIGN KEY (genero_id) REFERENCES genero(genero_id),
    CONSTRAINT uq_contenido_genero UNIQUE (contenido_id, genero_id)
) TABLESPACE ts_quindioflix_data;

-- TEMPORADA (Solo series/podcasts)
CREATE TABLE temporada (
    temporada_id NUMBER(5) PRIMARY KEY,
    contenido_id NUMBER(5) NOT NULL,
    numero NUMBER(2) NOT NULL,
    CONSTRAINT fk_temporada_contenido FOREIGN KEY (contenido_id) REFERENCES contenido(contenido_id),
    CONSTRAINT uq_contenido_numero UNIQUE (contenido_id, numero)
) TABLESPACE ts_quindioflix_data;

-- EPISODIO
CREATE TABLE episodio (
    episodio_id NUMBER(5) PRIMARY KEY,
    temporada_id NUMBER(5) NOT NULL,
    numero NUMBER(3) NOT NULL,
    titulo VARCHAR2(200) NOT NULL,
    duracion NUMBER(5) NOT NULL,
    CONSTRAINT fk_episodio_temporada FOREIGN KEY (temporada_id) REFERENCES temporada(temporada_id),
    CONSTRAINT uq_temporada_episodio UNIQUE (temporada_id, numero)
) TABLESPACE ts_quindioflix_data;

-- =====================================================
-- 3. TABLAS DE USUARIOS
-- =====================================================

-- USUARIO
CREATE TABLE usuario (
    usuario_id NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    telefono VARCHAR2(20),
    fecha_nacimiento DATE NOT NULL,
    ciudad_residencia VARCHAR2(100),
    plan_id NUMBER(2) NOT NULL,
    fecha_registro DATE NOT NULL,
    CONSTRAINT fk_usuario_plan FOREIGN KEY (plan_id) REFERENCES plan(plan_id)
) TABLESPACE ts_quindioflix_data;

-- PERFIL
CREATE TABLE perfil (
    perfil_id NUMBER(5) PRIMARY KEY,
    usuario_id NUMBER(5) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    avatar VARCHAR2(200),
    tipo VARCHAR2(10) NOT NULL,
    CONSTRAINT chk_perfil_tipo CHECK (tipo IN ('ADULTO','INFANTIL')),
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
) TABLESPACE ts_quindioflix_data;

-- REFERIDO
CREATE TABLE referido (
    referido_id NUMBER(5) PRIMARY KEY,
    usuario_referidor_id NUMBER(5) NOT NULL,
    usuario_referido_id NUMBER(5) NOT NULL,
    beneficio VARCHAR2(100),
    fecha_referido DATE NOT NULL,
    CONSTRAINT fk_ref_usuario1 FOREIGN KEY (usuario_referidor_id) REFERENCES usuario(usuario_id),
    CONSTRAINT fk_ref_usuario2 FOREIGN KEY (usuario_referido_id) REFERENCES usuario(usuario_id),
    CONSTRAINT uq_referido UNIQUE (usuario_referido_id)
) TABLESPACE ts_quindioflix_data;

-- =====================================================
-- 4. TABLAS DE CONSUMO
-- =====================================================

-- REPRODUCCION
CREATE TABLE reproduccion (
    reproduccion_id NUMBER(10) PRIMARY KEY,
    perfil_id NUMBER(5) NOT NULL,
    contenido_id NUMBER(5) NOT NULL,
    episodio_id NUMBER(5),
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP,
    dispositivo VARCHAR2(20) NOT NULL,
    porcentaje_avance NUMBER(5,2) DEFAULT 0,
    CONSTRAINT chk_dispositivo CHECK (dispositivo IN ('CELULAR','TABLET','TV','COMPUTADOR')),
    CONSTRAINT chk_avance CHECK (porcentaje_avance >= 0 AND porcentaje_avance <= 100),
    CONSTRAINT fk_reproduccion_perfil FOREIGN KEY (perfil_id) REFERENCES perfil(perfil_id),
    CONSTRAINT fk_reproduccion_contenido FOREIGN KEY (contenido_id) REFERENCES contenido(contenido_id),
    CONSTRAINT fk_reproduccion_episodio FOREIGN KEY (episodio_id) REFERENCES episodio(episodio_id)
) TABLESPACE ts_quindioflix_data
PARTITION BY RANGE (fecha_inicio) (
    PARTITION p2025 VALUES LESS THAN (TO_DATE('2026-01-01','YYYY-MM-DD')),
    PARTITION p2026 VALUES LESS THAN (TO_DATE('2027-01-01','YYYY-MM-DD')),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);

-- FAVORITO
CREATE TABLE favorito (
    favorito_id NUMBER(10) PRIMARY KEY,
    perfil_id NUMBER(5) NOT NULL,
    contenido_id NUMBER(5) NOT NULL,
    fecha_agregado DATE NOT NULL,
    CONSTRAINT fk_fav_perfil FOREIGN KEY (perfil_id) REFERENCES perfil(perfil_id),
    CONSTRAINT fk_fav_contenido FOREIGN KEY (contenido_id) REFERENCES contenido(contenido_id),
    CONSTRAINT uq_perfil_contenido UNIQUE (perfil_id, contenido_id)
) TABLESPACE ts_quindioflix_data;

-- RESENA
CREATE TABLE resena (
    resena_id NUMBER(10) PRIMARY KEY,
    perfil_id NUMBER(5) NOT NULL,
    contenido_id NUMBER(5) NOT NULL,
    calificacion NUMBER(1) NOT NULL,
    texto CLOB,
    fecha_publicacion DATE NOT NULL,
    CONSTRAINT chk_calificacion CHECK (calificacion BETWEEN 1 AND 5),
    CONSTRAINT fk_resena_perfil FOREIGN KEY (perfil_id) REFERENCES perfil(perfil_id),
    CONSTRAINT fk_resena_contenido FOREIGN KEY (contenido_id) REFERENCES contenido(contenido_id)
) TABLESPACE ts_quindioflix_data;

-- REPORTE
CREATE TABLE reporte (
    reporte_id NUMBER(10) PRIMARY KEY,
    contenido_id NUMBER(5) NOT NULL,
    perfil_id NUMBER(5) NOT NULL,
    motivo VARCHAR2(500) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'PENDIENTE',
    empleado_id NUMBER(5),
    fecha_reporte DATE NOT NULL,
    fecha_resolucion DATE,
    CONSTRAINT chk_estado_reporte CHECK (estado IN ('PENDIENTE','REVISADO','APROBADO','RECHAZADO')),
    CONSTRAINT fk_reporte_contenido FOREIGN KEY (contenido_id) REFERENCES contenido(contenido_id),
    CONSTRAINT fk_reporte_perfil FOREIGN KEY (perfil_id) REFERENCES perfil(perfil_id),
    CONSTRAINT fk_reporte_empleado FOREIGN KEY (empleado_id) REFERENCES empleado(empleado_id)
) TABLESPACE ts_quindioflix_data;

-- =====================================================
-- 5. TABLAS DE EMPLEADOS
-- =====================================================

-- EMPLEADO
CREATE TABLE empleado (
    empleado_id NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    telefono VARCHAR2(20),
    departamento_id NUMBER(3),
    supervisor_id NUMBER(5),
    cargo VARCHAR2(50),
    CONSTRAINT fk_emp_departamento FOREIGN KEY (departamento_id) REFERENCES departamento(departamento_id),
    CONSTRAINT fk_emp_supervisor FOREIGN KEY (supervisor_id) REFERENCES empleado(empleado_id)
) TABLESPACE ts_quindioflix_data;

-- Actualizar jefe de departamento después de crear empleados
ALTER TABLE departamento 
    ADD CONSTRAINT fk_departamento_jefe 
    FOREIGN KEY (jefe_id) REFERENCES empleado(empleado_id);

-- =====================================================
-- 6. TABLAS DE PAGOS
-- =====================================================

-- PAGO
CREATE TABLE pago (
    pago_id NUMBER(10) PRIMARY KEY,
    usuario_id NUMBER(5) NOT NULL,
    monto NUMBER(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    metodo_pago VARCHAR2(30),
    referencia VARCHAR2(100),
    CONSTRAINT fk_pago_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
) TABLESPACE ts_quindioflix_data;

-- FACTURA
CREATE TABLE factura (
    factura_id NUMBER(10) PRIMARY KEY,
    usuario_id NUMBER(5) NOT NULL,
    periodo VARCHAR2(7) NOT NULL,
    monto_total NUMBER(10,2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'PENDIENTE',
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    CONSTRAINT chk_estado_factura CHECK (estado IN ('PENDIENTE','PAGADA','VENCIDA')),
    CONSTRAINT fk_factura_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id),
    CONSTRAINT uq_usuario_periodo UNIQUE (usuario_id, periodo)
) TABLESPACE ts_quindioflix_data;

-- =====================================================
-- 7. SECUENCIAS
-- =====================================================

CREATE SEQUENCE seq_contenido START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_genero START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_temporada START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_episodio START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_perfil START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_referido START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reproduccion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_favorito START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_resena START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reporte START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_empleado START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_departamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pago START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_factura START WITH 1 INCREMENT BY 1;

-- =====================================================
-- 8. ÍNDICES
-- =====================================================

CREATE INDEX idx_contenido_tipo ON contenido(tipo) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_contenido_clasif ON contenido(clasificacion_edad) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_contenido_fecha ON contenido(fecha_agregado) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_contenido_genero ON contenido_genero(contenido_id, genero_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_temporada_contenido ON temporada(contenido_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_episodio_temporada ON episodio(temporada_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_usuario_email ON usuario(email) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_usuario_plan ON usuario(plan_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_perfil_usuario ON perfil(usuario_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_reproduccion_perfil ON reproduccion(perfil_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_reproduccion_fecha ON reproduccion(fecha_inicio) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_resena_contenido ON resena(contenido_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_reporte_estado ON reporte(estado) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_empleado_dept ON empleado(departamento_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_pago_usuario ON pago(usuario_id) TABLESPACE ts_quindioflix_indx;
CREATE INDEX idx_factura_usuario ON factura(usuario_id, periodo) TABLESPACE ts_quindioflix_indx;