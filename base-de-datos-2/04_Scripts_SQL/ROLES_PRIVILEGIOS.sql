-- =====================================================
-- ROLES Y PRIVILEGIOS - QUINDIOFLIX
-- =====================================================

-- =====================================================
-- 1. CREAR USUARIOS
-- =====================================================

-- Crear usuario administrador
CREATE USER quindioflix_admin IDENTIFIED BY admin123
DEFAULT TABLESPACE ts_quindioflix_data
TEMPORARY TABLESPACE ts_quindioflix_temp;

-- Crear usuario desarrollador
CREATE USER quindioflix_dev IDENTIFIED BY dev123
DEFAULT TABLESPACE ts_quindioflix_data
TEMPORARY TABLESPACE ts_quindioflix_temp;

-- Crear usuario operador contenido
CREATE USER quindioflix_contenido IDENTIFIED BY contenido123
DEFAULT TABLESPACE ts_quindioflix_data
TEMPORARY TABLESPACE ts_quindioflix_temp;

-- Crear usuario moderador
CREATE USER quindioflix_moderador IDENTIFIED BY moderador123
DEFAULT TABLESPACE ts_quindioflix_data
TEMPORARY TABLESPACE ts_quindioflix_temp;

-- Crear usuario consulta reportes
CREATE USER quindioflix_reportes IDENTIFIED BY reportes123
DEFAULT TABLESPACE ts_quindioflix_data
TEMPORARY TABLESPACE ts_quindioflix_temp;

-- Crear usuario lectura
CREATE USER quindioflix_lectura IDENTIFIED BY lectura123
DEFAULT TABLESPACE ts_quindioflix_data
TEMPORARY TABLESPACE ts_quindioflix_temp;

-- =====================================================
-- 2. CREAR ROLES
-- =====================================================

-- Rol de administrador total
CREATE ROLE rol_administrador;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, 
      CREATE SEQUENCE, CREATE TRIGGER, CREATE INDEXTYPE, CREATE OPERATOR,
      DROP ANY TABLE, DROP ANY VIEW, DROP ANY PROCEDURE,
      DROP ANY SEQUENCE, DROP ANY TRIGGER, DROP ANY INDEX,
      ALTER ANY TABLE, ALTER ANY VIEW, ALTER ANY PROCEDURE,
      SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE
TO rol_administrador;

-- Rol de desarrollador
CREATE ROLE rol_desarrollador;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE,
      CREATE SEQUENCE, CREATE TRIGGER, CREATE INDEX, CREATE SYNONYM,
      ALTER ANY TABLE, ALTER ANY VIEW, DROP ANY TABLE, DROP ANY VIEW,
      SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE
TO rol_desarrollador;

-- Rol de gestión de contenido
CREATE ROLE rol_gestion_contenido;
GRANT CREATE SESSION,
      SELECT ON contenido TO rol_gestion_contenido,
      INSERT ON contenido TO rol_generacion_contenido,
      UPDATE ON contenido TO rol_gestion_contenido,
      DELETE ON contenido TO rol_gestion_contenido,
      SELECT ON contenido_genero TO rol_gestion_contenido,
      INSERT ON contenido_genero TO rol_gestion_contenido,
      UPDATE ON contenido_genero TO rol_gestion_contenido,
      DELETE ON contenido_genero TO rol_gestion_contenido,
      SELECT ON genero TO rol_gestion_contenido,
      INSERT ON genero TO rol_gestion_contenido,
      SELECT ON temporada TO rol_gestion_contenido,
      INSERT ON temporada TO rol_gestion_contenido,
      UPDATE ON temporada TO rol_gestion_contenido,
      SELECT ON episodio TO rol_gestion_contenido,
      INSERT ON episodio TO rol_gestion_contenido,
      UPDATE ON episodio TO rol_gestion_contenido,
      EXECUTE ON sp_agregar_contenido TO rol_gestion_contenido
TO rol_gestion_contenido;

-- Rol de moderador
CREATE ROLE rol_moderador;
GRANT CREATE SESSION,
      SELECT ON reporte TO rol_moderador,
      UPDATE ON reporte TO rol_moderador,
      SELECT ON contenido TO rol_moderador,
      SELECT ON perfil TO rol_moderador,
      SELECT ON empleado TO rol_moderador,
      EXECUTE ON sp_resolver_reporte TO rol_moderador
TO rol_moderador;

-- Rol de reportes
CREATE ROLE rol_reportes;
GRANT CREATE SESSION,
      SELECT ON v_mejores_contenido TO rol_reportes,
      SELECT ON v_contenido_mas_visto TO rol_reportes,
      SELECT ON v_usuarios_activos TO rol_reportes,
      SELECT ON reproduccion TO rol_reportes,
      SELECT ON contenido TO rol_reportes,
      SELECT ON usuario TO rol_reportes,
      SELECT ON resena TO rol_reportes,
      SELECT ON pago TO rol_reportes,
      SELECT ON factura TO rol_reportes
TO rol_reportes;

-- Rol de lectura
CREATE ROLE rol_lectura;
GRANT CREATE SESSION,
      SELECT ON plan TO rol_lectura,
      SELECT ON genero TO rol_lectura,
      SELECT ON contenido TO rol_lectura,
      SELECT ON contenido_genero TO rol_lectura,
      SELECT ON temporada TO rol_lectura,
      SELECT ON episodio TO rol_lectura,
      SELECT ON usuario TO rol_lectura,
      SELECT ON perfil TO rol_lectura,
      SELECT ON reproduccion TO rol_lectura
TO rol_lectura;

-- =====================================================
-- 3. ASIGNAR ROLES A USUARIOS
-- =====================================================

GRANT rol_administrador TO quindioflix_admin;
GRANT rol_desarrollador TO quindioflix_dev;
GRANT rol_gestion_contenido TO quindioflix_contenido;
GRANT rol_moderador TO quindioflix_moderador;
GRANT rol_reportes TO quindioflix_reportes;
GRANT rol_lectura TO quindioflix_lectura;

-- =====================================================
-- 4. PRIVILEGIOS ESPECÍFICOS
-- =====================================================

-- Otorgar quota en tablespace
ALTER USER quindioflix_admin QUOTA UNLIMITED ON ts_quindioflix_data;
ALTER USER quindioflix_dev QUOTA UNLIMITED ON ts_quindioflix_data;
ALTER USER quindioflix_admin QUOTA UNLIMITED ON ts_quindioflix_indx;

-- Otorgar privilegios de ejecución
GRANT EXECUTE ON DBMS_OUTPUT TO quindioflix_dev;
GRANT EXECUTE ON DBMS_LOCK TO quindioflix_dev;
GRANT EXECUTE ON DBMS_SESSION TO quindioflix_dev;
GRANT EXECUTE ON DBMS_JOB TO quindioflix_admin;

-- Privilegios de flashback
GRANT FLASHBACK ANY TABLE TO quindioflix_admin;

-- Privilegios de utl_file
GRANT CREATE ANY DIRECTORY TO quindioflix_admin;

-- =====================================================
-- 5. MATRIZ DE PRIVILEGIOS (CRUD)
-- =====================================================

-- =====================================================
-- | Tabla           | Admin | Desar | Cont | Mod  | Reportes | Lectura |
-- =================|======|======|======|======|=========|========|
-- | contenido      | CRUD | CRU  | CRU  | R    | R       | R      |
-- | genero        | CRUD | CRU  | RU   | -    | -       | R      |
-- | temporada     | CRUD | CRU  | CRU  | -    | R       | R      |
-- | episodio     | CRUD | CRU  | CRU  | -    | R       | R      |
-- | usuario       | CRUD | R    | R    | R    | R       | R      |
-- | perfil        | CRUD | R    | R    | R    | R       | R      |
-- | reproduc     | R    | R    | R    | R    | R       | R      |
-- | resena        | CRUD| RU   | R    | R    | R       | R      |
-- | reporte       | CRUD| R    | C    | RU   | R       | -      |
-- | pago          | CRUD| R    | -    | -    | R       | -      |
-- | factura       | CRUD| R    | -    | -    | R       | -      |
-- | empleado     | CRUD| R    | R    | R    | R       | R      |
-- | departamento | CRUD| R    | -    | -    | R       | R      |
-- =====================================================

-- =====================================================
-- 6. SEGURIDAD A NIVEL DE FILAS (RLS)
-- =====================================================

-- Agregar columna de seguridad
ALTER TABLE contenido ADD (seguridad VARCHAR2(10) DEFAULT 'PUBLICO');
ALTER TABLE usuario ADD (seguridad VARCHAR2(10) DEFAULT 'PUBLICO');

-- Crear contexto de aplicación
CREATE OR REPLACE CONTEXT ctx_quindioflix USING seg_set_context;

-- Procedure para establecer contexto
CREATE OR REPLACE PROCEDURE seg_set_context(
    p_usuario_id IN NUMBER,
    p_rol IN VARCHAR2
) IS
BEGIN
    DBMS_SESSION.SET_CONTEXT('ctx_quindioflix', 'usuario_id', p_usuario_id);
    DBMS_SESSION.SET_CONTEXT('ctx_quindioflix', 'rol', p_rol);
END seg_set_context;
/

-- Política RLS para contenido sensible
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'QUINDIOFLIX',
        object_name   => 'contenido',
        policy_name   => 'politica_contenido',
        function_schema => 'QUINDIOFLIX',
        policy_function => 'seg_contenido_policy',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE'
    );
END;
/

-- =====================================================
-- 7. VISTAS PARA CONTROL DE ACCESO
-- =====================================================

-- Vista para contenidos por clasificación
CREATE OR REPLACE VIEW v_contenido_todos AS
SELECT 
    contenido_id, titulo, anno_lanzamiento, duracion, 
    clasificacion_edad, tipo
FROM contenido
WHERE seguridad = 'PUBLICO';

-- Vista para usuarios por perfil de acceso
CREATE OR REPLACE VIEW v_datos_usuario AS
SELECT 
    usuario_id, nombre, email, ciudad_residencia
FROM usuario
WHERE seguridad = 'PUBLICO';

-- =====================================================
-- 8. AUDITORÍA DE SEGURIDAD
-- =====================================================

-- Habilitar auditing
AUDIT INSERT, UPDATE, DELETE ON contenido BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON usuario BY ACCESS;
AUDIT DELETE ON reporte BY ACCESS;

-- Ver registros de auditoría
SELECT * FROM dba_stmt_audit_policy 
WHERE object_name IN ('CONTENIDO', 'USUARIO');

-- =====================================================
-- 9. EJEMPLOS DE USO
-- =====================================================

-- Conexión como usuario de contenido
-- CONNECT quindioflix_contenido/contenido123

-- Ver contenido disponible
-- SELECT * FROM contenido;

-- Insertar nuevo contenido
-- EXEC sp_agregar_contenido('Nueva Pelicula', 2025, 120, 'Sinopsis...', 'TP', 'PELICULA', 0, :id, :res);

-- Conexión como moderador
-- CONNECT quindioflix_moderador/moderador123

-- Ver reportes pendientes
-- SELECT * FROM reporte WHERE estado = 'PENDIENTE';

-- Resolver reporte
-- EXEC sp_resolver_reporte(1, 5, 'APROBADO', :res);

-- =====================================================
-- 10. SCRIPT DE Revocación
-- =====================================================

-- Revocar privilegios
REVOKE ALL ON contenido FROM quindioflix_lectura;
REVOKE rol_moderador FROM quindioflix_moderador;

-- Eliminar usuario
DROP USER quindioflix_lectura CASCADE;

-- Eliminar rol
DROP ROLE rol_lectura;