-- =====================================================
-- TRIGGERS Y TRANSACCIONES - QUINDIOFLIX
-- =====================================================

-- =====================================================
-- 1. TRIGGERS DE VALIDACIÓN
-- =====================================================

-- Trigger: Validar clasificación de edad
CREATE OR REPLACE TRIGGER tr_valida_clasificacion
BEFORE INSERT OR UPDATE ON contenido
FOR EACH ROW
BEGIN
    IF :NEW.clasificacion_edad NOT IN ('TP', '+7', '+13', '+16', '+18') THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Clasificación inválida. Use: TP, +7, +13, +16, +18');
    END IF;
END tr_valida_clasificacion;
/

-- Trigger: Validar que perfil infantil no acceda a contenido restringido
CREATE OR REPLACE TRIGGER tr_valida_acceso_perfil
BEFORE INSERT ON reproduccion
FOR EACH ROW
DECLARE
    v_tipo_perfil VARCHAR2(10);
    v_clasificacion VARCHAR2(5);
BEGIN
    SELECT tipo INTO v_tipo_perfil FROM perfil WHERE perfil_id = :NEW.perfil_id;
    SELECT clasificacion_edad INTO v_clasificacion 
    FROM contenido WHERE contenido_id = :NEW.contenido_id;
    
    IF v_tipo_perfil = 'INFANTIL' AND v_clasificacion IN ('+16', '+18') THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Perfil infantil no puede reproducir contenido +16 o +18');
    END IF;
END tr_valida_acceso_perfil;
/

-- Trigger: Validar tipo de contenido para episodio
CREATE OR REPLACE TRIGGER tr_valida_episodio
BEFORE INSERT ON episodio
FOR EACH ROW
DECLARE
    v_tipo_contenido VARCHAR2(20);
BEGIN
    SELECT c.tipo INTO v_tipo_contenido
    FROM contenido c
    JOIN temporada t ON c.contenido_id = t.contenido_id
    WHERE t.temporada_id = :NEW.temporada_id;
    
    IF v_tipo_contenido NOT IN ('SERIE', 'PODCAST') THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Solo series y podcasts tienen episodios');
    END IF;
END tr_valida_episodio;
/

-- Trigger: Validar límite de perfiles por plan
CREATE OR REPLACE TRIGGER tr_valida_limite_perfiles
BEFORE INSERT ON perfil
FOR EACH ROW
DECLARE
    v_perfiles_actuales NUMBER;
    v_max_perfiles NUMBER;
BEGIN
    SELECT COUNT(*), MAX(p.num_pantallas)
    INTO v_perfiles_actuales, v_max_perfiles
    FROM perfil f
    JOIN usuario u ON f.usuario_id = u.usuario_id
    JOIN plan p ON u.plan_id = p.plan_id
    WHERE f.usuario_id = :NEW.usuario_id
    GROUP BY p.num_pantallas;
    
    IF v_perfiles_actuales >= v_max_perfiles THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Límite de perfiles alcanzado para este plan');
    END IF;
END tr_valida_limite_perfiles;
/

-- =====================================================
-- 2. TRIGGERS DE AUDITORÍA
-- =====================================================

-- Tabla de auditoría
CREATE TABLE auditoria (
    auditoria_id NUMBER(10) PRIMARY KEY,
    tabla VARCHAR2(50) NOT NULL,
    operacion VARCHAR2(10) NOT NULL,
    usuario VARCHAR2(50) NOT NULL,
    fecha DATE NOT NULL,
    datos_anteriores CLOB,
    datos_nuevos CLOB
);

CREATE SEQUENCE seq_auditoria START WITH 1 INCREMENT BY 1;

-- Trigger: Auditoría de usuario
CREATE OR REPLACE TRIGGER tr_audita_usuario
AFTER INSERT OR UPDATE OR DELETE ON usuario
FOR EACH ROW
DECLARE
    v_datos CLOB;
BEGIN
    SELECT seq_auditoria.NEXTVAL INTO v_datos FROM DUAL;
    
    IF INSERTING THEN
        INSERT INTO auditoria (auditoria_id, tabla, operacion, usuario, fecha, datos_nuevos)
        VALUES (seq_auditoria.CURRVAL, 'USUARIO', 'INSERT', USER, SYSDATE,
            :NEW.nombre || '|' || :NEW.email || '|' || :NEW.ciudad_residencia);
    ELSIF UPDATING THEN
        INSERT INTO auditoria (auditoria_id, tabla, operacion, usuario, fecha, datos_anteriores, datos_nuevos)
        VALUES (seq_auditoria.CURRVAL, 'USUARIO', 'UPDATE', USER, SYSDATE,
            :OLD.nombre || '|' || :OLD.email,
            :NEW.nombre || '|' || :NEW.email);
    ELSIF DELETING THEN
        INSERT INTO auditoria (auditoria_id, tabla, operacion, usuario, fecha, datos_anteriores)
        VALUES (seq_auditoria.CURRVAL, 'USUARIO', 'DELETE', USER, SYSDATE,
            :OLD.nombre || '|' || :OLD.email);
    END IF;
END tr_audita_usuario;
/

-- Trigger: Auditoría de contenido
CREATE OR REPLACE TRIGGER tr_audita_contenido
AFTER INSERT OR UPDATE OR DELETE ON contenido
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO auditoria (auditoria_id, tabla, operacion, usuario, fecha, datos_nuevos)
        VALUES (seq_auditoria.NEXTVAL, 'CONTENIDO', 'INSERT', USER, SYSDATE,
            :NEW.titulo || '|' || :NEW.tipo);
    ELSIF UPDATING THEN
        INSERT INTO auditoria (auditoria_id, tabla, operacion, usuario, fecha, datos_nuevos)
        VALUES (seq_auditoria.NEXTVAL, 'CONTENIDO', 'UPDATE', USER, SYSDATE,
            :NEW.titulo || '|' || :NEW.clasificacion_edad);
    END IF;
END tr_audita_contenido;
/

-- =====================================================
-- 3. TRIGGERS DE INTEGRIDAD REFERENCIAL
-- =====================================================

-- Tabla de estadísticas
CREATE TABLE estadisticas_contenido (
    estadistica_id NUMBER(5) PRIMARY KEY,
    contenido_id NUMBER(5),
    tipo_stats VARCHAR2(50),
    valor NUMBER,
    periodo DATE,
    FOREIGN KEY (contenido_id) REFERENCES contenido(contenido_id)
);

-- Trigger Compound: Actualizar estadísticas de contenido
CREATE OR REPLACE TRIGGER tr_actualiza_estadisticas
FOR INSERT OR UPDATE OR DELETE ON contenido
COMPOUND TRIGGER
    TYPE t_estados IS TABLE OF NUMBER INDEX BY VARCHAR2(10);
    v_conteos t_estados;
BEGIN
    FOR EACH ROW
    BEGIN
        v_conteos(:NEW.clasificacion_edad) := 
            NVL(v_conteos(:NEW.clasificacion_edad), 0) + 1;
        IF UPDATING OR DELETING THEN
            v_conteos(:OLD.clasificacion_edad) := 
                NVL(v_conteos(:OLD.clasificacion_edad), 0) - 1;
        END IF;
    END;
    
    AFTER STATEMENT IS
    BEGIN
        FOR tipo IN v_conteos.FIRST .. v_conteos.LAST LOOP
            IF v_conteos.EXISTS(tipo) AND v_conteos(tipo) != 0 THEN
                UPDATE estadisticas_contenido
                SET valor = valor + v_conteos(tipo)
                WHERE tipo_stats = tipo;
            END IF;
        END LOOP;
    END;
END tr_actualiza_estadisticas;
/

-- Trigger: Actualizar contador de reproducciones
CREATE OR REPLACE TRIGGER tr_actualiza_vistas
AFTER INSERT ON reproduccion
FOR EACH ROW
DECLARE
    v_existe NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM estadisticas_contenido
    WHERE contenido_id = :NEW.contenido_id
      AND tipo_stats = 'VISTAS';
    
    IF v_existe > 0 THEN
        UPDATE estadisticas_contenido
        SET valor = valor + 1
        WHERE contenido_id = :NEW.contenido_id
          AND tipo_stats = 'VISTAS';
    ELSE
        INSERT INTO estadisticas_contenido (estadistica_id, contenido_id, tipo_stats, valor)
        VALUES (seq_auditoria.NEXTVAL, :NEW.contenido_id, 'VISTAS', 1);
    END IF;
END tr_actualiza_vistas;
/

-- =====================================================
-- 4. TRIGGERS DE HISTÓRICO
-- =====================================================

-- Tabla de histórico de cambios
CREATE TABLE historico_clasificacion (
    historico_id NUMBER(10) PRIMARY KEY,
    contenido_id NUMBER(5) NOT NULL,
    clasificacion_anterior VARCHAR2(5),
    clasificacion_nueva VARCHAR2(5),
    fecha_cambio DATE NOT NULL,
    usuario VARCHAR2(50) NOT NULL
);

-- Trigger: Guardar histórico de clasificación
CREATE OR REPLACE TRIGGER tr_historico_clasificacion
BEFORE UPDATE OF clasificacion_edad ON contenido
FOR EACH ROW
WHEN (NEW.clasificacion_edad != OLD.clasificacion_edad)
BEGIN
    INSERT INTO historico_clasificacion 
        (historico_id, contenido_id, clasificacion_anterior, clasificacion_nueva, fecha_cambio, usuario)
    VALUES (seq_auditoria.NEXTVAL, :NEW.contenido_id, 
            :OLD.clasificacion_edad, :NEW.clasificacion_edad, SYSDATE, USER);
END tr_historico_clasificacion;
/

-- =====================================================
-- 5. TRIGGERS DE ESTADO
-- =====================================================

-- Trigger: Autocierre de reproducciones pendientes
CREATE OR REPLACE TRIGGER tr_auto_cierre_reproduccion
AFTER INSERT ON reproduccion
FOR EACH ROW
DECLARE
    v_dias_cierre NUMBER := 7;
BEGIN
    -- La lógica de cierre automático se maneja con job programable
    NULL;
END tr_auto_cierre_reproduccion;
/

-- Trigger: Validar reporte duplicado
CREATE OR REPLACE TRIGGER tr_evitar_reporte_dup
BEFORE INSERT ON reporte
FOR EACH ROW
DECLARE
    v_existe NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM reporte
    WHERE contenido_id = :NEW.contenido_id
      AND perfil_id = :NEW.perfil_id
      AND estado = 'PENDIENTE';
    
    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20005,
            'Ya existe un reporte pendiente para este contenido');
    END IF;
END tr_evitar_reporte_dup;
/

-- =====================================================
-- 6. TRIGGERS INSTEAD OF
-- =====================================================

-- Trigger INSTEAD OF para vista
CREATE OR REPLACE TRIGGER tr_instead_of_vista
INSTEAD OF INSERT ON v_mejores_contenido
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Use los procedimientos para insertar contenido');
END tr_instead_of_vista;
/

-- =====================================================
-- 7. EJEMPLOS DE TRANSACCIONES
-- =====================================================

-- Transacción 1: Registro completo de nuevo usuario con perfil
CREATE OR REPLACE PROCEDURE sp_registro_completo(
    p_nombre        IN VARCHAR2,
    p_email         IN VARCHAR2,
    p_telefono     IN VARCHAR2,
    p_fecha_nac    IN DATE,
    p_ciudad       IN VARCHAR2,
    p_plan_id      IN NUMBER,
    p_nombre_perfil IN VARCHAR2,
    p_tipo_perfil  IN VARCHAR2,
    p_resultado    OUT VARCHAR2
) IS
    v_usuario_id NUMBER;
    v_perfil_id NUMBER;
BEGIN
    SAVEPOINT sp_inicio_registro;
    
    BEGIN
        SELECT seq_usuario.NEXTVAL INTO v_usuario_id FROM DUAL;
        
        INSERT INTO usuario (usuario_id, nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro)
        VALUES (v_usuario_id, p_nombre, p_email, p_telefono, p_fecha_nac, p_ciudad, p_plan_id, SYSDATE);
        
        SELECT seq_perfil.NEXTVAL INTO v_perfil_id FROM DUAL;
        
        INSERT INTO perfil (perfil_id, usuario_id, nombre, tipo)
        VALUES (v_perfil_id, v_usuario_id, p_nombre_perfil, p_tipo_perfil);
        
        COMMIT;
        p_resultado := 'REGISTRO_COMPLETO|USUARIO:' || v_usuario_id || '|PERFIL:' || v_perfil_id;
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK TO sp_inicio_registro;
            p_resultado := 'ERROR: EMAIL_YA_EXISTE';
        WHEN OTHERS THEN
            ROLLBACK TO sp_inicio_registro;
            p_resultado := 'ERROR: ' || SQLERRM;
    END;
END sp_registro_completo;
/

-- Transacción 2: Procesar reproducción completa
CREATE OR REPLACE PROCEDURE sp_procesar_reproduccion(
    p_perfil_id    IN NUMBER,
    p_contenido_id IN NUMBER,
    p_dispositivo IN VARCHAR2,
    p_resultado   OUT VARCHAR2
) IS
    v_reproduccion_id NUMBER;
    v_acceso VARCHAR2(5);
BEGIN
    SAVEPOINT sp_inicio_reproc;
    
    v_acceso := fn_verificar_acceso_contenido(p_perfil_id, p_contenido_id);
    
    IF v_acceso = 'NO' THEN
        p_resultado := 'ERROR: ACCESO_DENEGADO';
        RETURN;
    END IF;
    
    sp_iniciar_reproduccion(p_perfil_id, p_contenido_id, NULL, p_dispositivo, v_reproduccion_id, p_resultado);
    
    IF p_resultado LIKE 'ERROR%' THEN
        ROLLBACK TO sp_inicio_reproc;
        RETURN;
    END IF;
    
    COMMIT;
    p_resultado := 'REPRODUCCION_INICIADA|' || v_reproduccion_id;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO sp_inicio_reproc;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_procesar_reproduccion;
/

-- Transacción 3: Transferencia de usuario entre planes
CREATE OR REPLACE PROCEDURE sp_cambiar_plan(
    p_usuario_id   IN NUMBER,
    p_nuevo_plan_id IN NUMBER,
    p_resultado     OUT VARCHAR2
) IS
    v_plan_actual NUMBER;
    v_pago_pendiente NUMBER;
BEGIN
    SAVEPOINT sp_cambio_plan;
    
    SELECT plan_id INTO v_plan_actual FROM usuario WHERE usuario_id = p_usuario_id;
    
    IF v_plan_actual = p_nuevo_plan_id THEN
        p_resultado := 'ERROR: MISMO_PLAN';
        RETURN;
    END IF;
    
    SELECT COUNT(*) INTO v_pago_pendiente
    FROM factura
    WHERE usuario_id = p_usuario_id AND estado = 'PENDIENTE';
    
    IF v_pago_pendiente > 0 THEN
        p_resultado := 'ERROR: TIENE_FACTURA_PENDIENTE';
        RETURN;
    END IF;
    
    UPDATE usuario SET plan_id = p_nuevo_plan_id WHERE usuario_id = p_usuario_id;
    
    COMMIT;
    p_resultado := 'PLAN_ACTUALIZADO';
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO sp_cambio_plan;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_cambiar_plan;
/

-- =====================================================
-- 8. ESCENARIOS DE CONCURRENCIA
-- =====================================================

-- Escenario 1:two usuarios reproducen simultáneamente
CREATE OR REPLACE PROCEDURE sp_simular_concurrencia(
    p_perfil_id_1 IN NUMBER,
    p_perfil_id_2 IN NUMBER,
    p_contenido_id IN NUMBER
) IS
    v_lock_obtenido_1 BOOLEAN := FALSE;
    v_lock_obtenido_2 BOOLEAN := FALSE;
BEGIN
    -- Intentar obtener lock con wait de 5 segundos
    BEGIN
        SELECT porcentaje_avance INTO v_lock_obtenido_1
        FROM reproduccion
        WHERE perfil_id = p_perfil_id_1
          AND contenido_id = p_contenido_id
        FOR UPDATE WAIT 5;
        v_lock_obtenido_1 := TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Lock no obtenido por perfil 1');
    END;
    
    -- El segundo perfil puede estar en diferente sesión
    -- En producción, usar DBMS_LOCK
    NULL;
END sp_simular_concurrencia;
/

-- =====================================================
-- 9. MANEJO DE EXCEPCIONES EN TRANSACCIONES
-- =====================================================

-- Procedure con manejo de excepciones complexo
CREATE OR REPLACE PROCEDURE sp_operacion_segura(
    p_operacion IN VARCHAR2,
    p_id        IN NUMBER,
    p_resultado OUT VARCHAR2
) IS
    e_no_encontrado EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_no_encontrado, -20010);
    e_restriccion EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_restriccion, -2292);
BEGIN
    IF p_operacion = 'BORRAR' THEN
        DELETE FROM usuario WHERE usuario_id = p_id;
    ELSIF p_operacion = 'ACTUALIZAR' THEN
        UPDATE usuario SET nombre = 'ACTUALIZADO' WHERE usuario_id = p_id;
    END IF;
    
    p_resultado := 'OPERACION_EXITOSA';
    
EXCEPTION
    WHEN e_no_encontrado THEN
        p_resultado := 'ERROR: REGISTRO_NO_ENCONTRADO';
    WHEN e_restriccion THEN
        p_resultado := 'ERROR: DATOS_RELACIONADOS';
    WHEN OTHERS THEN
        p_resultado := 'ERROR: ' || SQLERRM;
        RAISE;
END sp_operacion_segura;
/

-- =====================================================
-- 10. VISTAS MATERIALIZAS
-- =====================================================

-- Vista materializada: Contenido popular por mes
CREATE MATERIALIZED VIEW mv_contenido_popular_mes
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT 
    c.contenido_id,
    c.titulo,
    c.tipo,
    COUNT(r.reproduccion_id) AS reproducciones,
    TRUNC(r.fecha_inicio, 'MM') AS mes
FROM contenido c
LEFT JOIN reproduccion r ON c.contenido_id = r.contenido_id
WHERE r.fecha_inicio >= ADD_MONTHS(SYSDATE, -1)
GROUP BY c.contenido_id, c.titulo, c.tipo, TRUNC(r.fecha_inicio, 'MM');

-- Vista materializada: Usuarios por ciudad
CREATE MATERIALIZED VIEW mv_usuarios_ciudad
BUILD IMMEDIATE
REFRESH FAST
AS
SELECT 
    ciudad_residencia,
    COUNT(*) AS total_usuarios,
    SUM(CASE WHEN SYSDATE - fecha_registro <= 30 THEN 1 ELSE 0 END) AS nuevos
FROM usuario
WHERE ciudad_residencia IS NOT NULL
GROUP BY ciudad_residencia;

-- =====================================================
-- 11. INDEXANDO Y EXPLAIN PLAN
-- =====================================================

-- Índices para mejorar rendimiento
CREATE INDEX idx_reproduccion_perfil_fecha ON reproduccion(perfil_id, fecha_inicio);
CREATE INDEX idx_contenido_tipo_clasif ON contenido(tipo, clasificacion_edad);
CREATE INDEX idx_resena_calificacion ON resena(calificacion);

-- Análisis de queries con EXPLAIN PLAN
EXPLAIN PLAN FOR
SELECT c.titulo, COUNT(r.reproduccion_id) AS reproducciones
FROM contenido c
LEFT JOIN reproduccion r ON c.contenido_id = r.contenido_id
WHERE r.fecha_inicio >= SYSDATE - 30
GROUP BY c.contenido_id, c.titulo
ORDER BY reproducciones DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);