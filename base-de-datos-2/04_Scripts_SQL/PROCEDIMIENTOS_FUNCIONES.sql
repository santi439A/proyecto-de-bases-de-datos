-- =====================================================
-- PROCEDIMIENTOS Y FUNCIONES - QUINDIOFLIX
-- =====================================================

-- =====================================================
-- 1. PROCEDIMIENTOS DE GESTIÓN DE CONTENIDO
-- =====================================================

-- Procedimiento: Agregar nuevo contenido
CREATE OR REPLACE PROCEDURE sp_agregar_contenido(
    p_titulo            IN VARCHAR2,
    p_anno             IN NUMBER,
    p_duracion         IN NUMBER,
    p_sinopsis         IN CLOB,
    p_clasificacion     IN VARCHAR2,
    p_tipo             IN VARCHAR2,
    p_es_original      IN NUMBER DEFAULT 0,
    p_contenido_id     OUT NUMBER,
    p_resultado        OUT VARCHAR2
) IS
    v_contenido_id NUMBER;
BEGIN
    SELECT seq_contenido.NEXTVAL INTO v_contenido_id FROM DUAL;
    
    INSERT INTO contenido (
        contenido_id, titulo, anno_lanzamiento, duracion, sinopsis,
        clasificacion_edad, fecha_agregado, tipo, es_original
    ) VALUES (
        v_contenido_id, p_titulo, p_anno, p_duracion, p_sinopsis,
        p_clasificacion, SYSDATE, p_tipo, p_es_original
    );
    
    p_contenido_id := v_contenido_id;
    p_resultado := 'CONTENIDO_AGREGADO';
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_agregar_contenido;
/

-- =====================================================
-- 2. PROCEDIMIENTOS DE GESTIÓN DE USUARIOS
-- =====================================================

-- Procedimiento: Registrar usuario
CREATE OR REPLACE PROCEDURE sp_registrar_usuario(
    p_nombre            IN VARCHAR2,
    p_email             IN VARCHAR2,
    p_telefono         IN VARCHAR2,
    p_fecha_nac        IN DATE,
    p_ciudad           IN VARCHAR2,
    p_plan_id          IN NUMBER,
    p_usuario_id       OUT NUMBER,
    p_resultado        OUT VARCHAR2
) IS
    v_usuario_id NUMBER;
BEGIN
    SELECT seq_usuario.NEXTVAL INTO v_usuario_id FROM DUAL;
    
    INSERT INTO usuario (
        usuario_id, nombre, email, telefono, fecha_nacimiento,
        ciudad_residencia, plan_id, fecha_registro
    ) VALUES (
        v_usuario_id, p_nombre, p_email, p_telefono, p_fecha_nac,
        p_ciudad, p_plan_id, SYSDATE
    );
    
    p_usuario_id := v_usuario_id;
    p_resultado := 'USUARIO_REGISTRADO';
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_resultado := 'ERROR: EMAIL_YA_EXISTE';
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_registrar_usuario;
/

-- Procedimiento: Crear perfil
CREATE OR REPLACE PROCEDURE sp_crear_perfil(
    p_usuario_id       IN NUMBER,
    p_nombre          IN VARCHAR2,
    p_avatar          IN VARCHAR2,
    p_tipo            IN VARCHAR2,
    p_perfil_id       OUT NUMBER,
    p_resultado       OUT VARCHAR2
) IS
    v_count NUMBER;
    v_max_perfiles NUMBER;
BEGIN
    SELECT p.num_pantallas INTO v_max_perfiles
    FROM usuario u
    JOIN plan p ON u.plan_id = p.plan_id
    WHERE u.usuario_id = p_usuario_id;
    
    SELECT COUNT(*) INTO v_count FROM perfil WHERE usuario_id = p_usuario_id;
    
    IF v_count >= v_max_perfiles THEN
        p_resultado := 'ERROR: LIMITE_PERFILES_ALCANZADO';
        RETURN;
    END IF;
    
    SELECT seq_perfil.NEXTVAL INTO p_perfil_id FROM DUAL;
    
    INSERT INTO perfil (perfil_id, usuario_id, nombre, avatar, tipo)
    VALUES (p_perfil_id, p_usuario_id, p_nombre, p_avatar, p_tipo);
    
    p_resultado := 'PERFIL CREADO';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_crear_perfil;
/

-- =====================================================
-- 3. PROCEDIMIENTOS DE REPRODUCCIÓN
-- =====================================================

-- Procedimiento: Iniciar reproducción
CREATE OR REPLACE PROCEDURE sp_iniciar_reproduccion(
    p_perfil_id        IN NUMBER,
    p_contenido_id     IN NUMBER,
    p_episodio_id    IN NUMBER,
    p_dispositivo    IN VARCHAR2,
    p_reproduccion_id OUT NUMBER,
    p_resultado      OUT VARCHAR2
) IS
    v_tiene_perfil_activo NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_tiene_perfil_activo
    FROM reproduccion
    WHERE perfil_id = p_perfil_id
      AND contenido_id = p_contenido_id
      AND fecha_fin IS NULL;
    
    IF v_tiene_perfil_activo > 0 THEN
        p_resultado := 'ERROR: YA_TIENE_REPRODUCCION_ACTIVA';
        RETURN;
    END IF;
    
    SELECT seq_reproduccion.NEXTVAL INTO p_reproduccion_id FROM DUAL;
    
    INSERT INTO reproduccion (
        reproduccion_id, perfil_id, contenido_id, episodio_id,
        fecha_inicio, dispositivo, porcentaje_avance
    ) VALUES (
        p_reproduccion_id, p_perfil_id, p_contenido_id, p_episodio_id,
        SYSTIMESTAMP, p_dispositivo, 0
    );
    
    p_resultado := 'REPRODUCCION_INICIADA';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_iniciar_reproduccion;
/

-- Procedimiento: Finalizar reproducción
CREATE OR REPLACE PROCEDURE sp_finalizar_reproduccion(
    p_reproduccion_id  IN NUMBER,
    p_porcentaje      IN NUMBER,
    p_resultado       OUT VARCHAR2
) IS
BEGIN
    UPDATE reproduccion
    SET fecha_fin = SYSTIMESTAMP,
        porcentaje_avance = p_porcentaje
    WHERE reproduccion_id = p_reproduccion_id;
    
    p_resultado := 'REPRODUCCION_FINALIZADA';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_finalizar_reproduccion;
/

-- =====================================================
-- 4. FUNCIONES
-- =====================================================

-- Función: Verificar acceso de perfil a contenido
CREATE OR REPLACE FUNCTION fn_verificar_acceso_contenido(
    p_perfil_id     IN NUMBER,
    p_contenido_id  IN NUMBER
) RETURN VARCHAR2 IS
    v_tipo_perfil VARCHAR2(10);
    v_clasificacion VARCHAR2(5);
    v_acceso VARCHAR2(5) := 'SI';
BEGIN
    SELECT tipo INTO v_tipo_perfil FROM perfil WHERE perfil_id = p_perfil_id;
    SELECT clasificacion_edad INTO v_clasificacion FROM contenido WHERE contenido_id = p_contenido_id;
    
    IF v_tipo_perfil = 'INFANTIL' AND v_clasificacion IN ('+16', '+18') THEN
        v_acceso := 'NO';
    END IF;
    
    RETURN v_acceso;
END fn_verificar_acceso_contenido;
/

-- Función: Calcular tiempo total visto por perfil
CREATE OR REPLACE FUNCTION fn_tiempo_visto_perfil(
    p_perfil_id IN NUMBER
) RETURN NUMBER IS
    v_minutos NUMBER;
BEGIN
    SELECT NVL(SUM(
        ROUND((fecha_fin - fecha_inicio) * 24 * 60)
    ), 0) INTO v_minutos
    FROM reproduccion
    WHERE perfil_id = p_perfil_id
      AND fecha_fin IS NOT NULL;
    
    RETURN v_minutos;
END fn_tiempo_visto_perfil;
/

-- Función: Contar reproducciones por contenido
CREATE OR REPLACE FUNCTION fn_vistas_contenido(
    p_contenido_id IN NUMBER
) RETURN NUMBER IS
    v_vistas NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_vistas
    FROM reproduccion
    WHERE contenido_id = p_contenido_id;
    
    RETURN v_vistas;
END fn_vistas_contenido;
/

-- Función: Obtener plan de usuario
CREATE OR REPLACE FUNCTION fnObtenerPlanUsuario(
    p_usuario_id IN NUMBER
) RETURN VARCHAR2 IS
    v_plan VARCHAR2(20);
BEGIN
    SELECT pl.nombre INTO v_plan
    FROM usuario u
    JOIN plan pl ON u.plan_id = pl.plan_id
    WHERE u.usuario_id = p_usuario_id;
    
    RETURN v_plan;
END fnObtenerPlanUsuario;
/

-- Función: Calcular descuento por referido
CREATE OR REPLACE FUNCTION fn_calcular_descuento(
    p_usuario_id IN NUMBER,
    p_monto IN NUMBER
) RETURN NUMBER IS
    v_tiene_ref NUMBER;
    v_descuento NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_tiene_ref
    FROM referido
    WHERE usuario_referido_id = p_usuario_id;
    
    IF v_tiene_ref > 0 THEN
        v_descuento := p_monto * 0.10;
    END IF;
    
    RETURN v_descuento;
END fn_calcular_descuento;
/

-- Función: Promedio de calificación de contenido
CREATE OR REPLACE FUNCTION fn_promedio_calificacion(
    p_contenido_id IN NUMBER
) RETURN NUMBER IS
    v_promedio NUMBER;
BEGIN
    SELECT NVL(AVG(calificacion), 0) INTO v_promedio
    FROM resena
    WHERE contenido_id = p_contenido_id;
    
    RETURN ROUND(v_promedio, 2);
END fn_promedio_calificacion;
/

-- =====================================================
-- 5. PROCEDIMIENTOS DE REPORTES
-- =====================================================

-- Procedimiento: Reportar contenido
CREATE OR REPLACE PROCEDURE sp_reportar_contenido(
    p_contenido_id    IN NUMBER,
    p_perfil_id      IN NUMBER,
    p_motivo         IN VARCHAR2,
    p_reporte_id    OUT NUMBER,
    p_resultado     OUT VARCHAR2
) IS
BEGIN
    SELECT seq_reporte.NEXTVAL INTO p_reporte_id FROM DUAL;
    
    INSERT INTO reporte (
        reporte_id, contenido_id, perfil_id, motivo, fecha_reporte
    ) VALUES (
        p_reporte_id, p_contenido_id, p_perfil_id, p_motivo, SYSDATE
    );
    
    p_resultado := 'REPORTE_ENVIADO';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_reportar_contenido;
/

-- Procedimiento: Resolver reporte (moderador)
CREATE OR REPLACE PROCEDURE sp_resolver_reporte(
    p_reporte_id     IN NUMBER,
    p_empleado_id   IN NUMBER,
    p_estado        IN VARCHAR2,
    p_resultado    OUT VARCHAR2
) IS
BEGIN
    UPDATE reporte
    SET estado = p_estado,
        empleado_id = p_empleado_id,
        fecha_resolucion = SYSDATE
    WHERE reporte_id = p_reporte_id;
    
    p_resultado := 'REPORTE_RESUELTO';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_resolver_reporte;
/

-- =====================================================
-- 6. PROCEDIMIENTOS DE PAGOS
-- =====================================================

-- Procedimiento: Registrar pago
CREATE OR REPLACE PROCEDURE sp_registrar_pago(
    p_usuario_id    IN NUMBER,
    p_monto      IN NUMBER,
    p_metodo     IN VARCHAR2,
    p_referencia IN VARCHAR2,
    p_pago_id   OUT NUMBER,
    p_resultado  OUT VARCHAR2
) IS
BEGIN
    SELECT seq_pago.NEXTVAL INTO p_pago_id FROM DUAL;
    
    INSERT INTO pago (
        pago_id, usuario_id, monto, fecha_pago, metodo_pago, referencia
    ) VALUES (
        p_pago_id, p_usuario_id, p_monto, SYSDATE, p_metodo, p_referencia
    );
    
    p_resultado := 'PAGO_REGISTRADO';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_registrar_pago;
/

-- Procedimiento: Generar factura mensual
CREATE OR REPLACE PROCEDURE sp_generar_factura(
    p_usuario_id    IN NUMBER,
    p_periodo     IN VARCHAR2,
    p_resultado   OUT VARCHAR2
) IS
    v_monto NUMBER;
    v_plan_id NUMBER;
    v_existe NUMBER;
BEGIN
    SELECT plan_id INTO v_plan_id FROM usuario WHERE usuario_id = p_usuario_id;
    SELECT precio INTO v_monto FROM plan WHERE plan_id = v_plan_id;
    
    SELECT COUNT(*) INTO v_existe
    FROM factura
    WHERE usuario_id = p_usuario_id AND periodo = p_periodo;
    
    IF v_existe > 0 THEN
        p_resultado := 'ERROR: FACTURA_YA_EXISTE';
        RETURN;
    END IF;
    
    INSERT INTO factura (
        factura_id, usuario_id, periodo, monto_total, estado,
        fecha_emision, fecha_vencimiento
    ) VALUES (
        seq_factura.NEXTVAL, p_usuario_id, p_periodo, v_monto, 'PENDIENTE',
        SYSDATE, ADD_MONTHS(SYSDATE, 1)
    );
    
    p_resultado := 'FACTURA_GENERADA';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_generar_factura;
/

-- =====================================================
-- 7. PROCEDIMIENTOS DE REFERIDOS
-- =====================================================

-- Procedimiento: Registrar referido
CREATE OR REPLACE PROCEDURE sp_registrar_referido(
    p_usuario_ref    IN NUMBER,
    p_email_ref    IN VARCHAR2,
    p_resultado   OUT VARCHAR2
) IS
    v_usuario_ref_id NUMBER;
    v_ref_id NUMBER;
    v_usuario_existe NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_usuario_existe 
    FROM usuario WHERE email = p_email_ref;
    
    IF v_usuario_existe = 0 THEN
        p_resultado := 'ERROR: USUARIO_NO_EXISTE';
        RETURN;
    END IF;
    
    SELECT usuario_id INTO v_usuario_ref_id 
    FROM usuario WHERE email = p_email_ref;
    
    SELECT seq_referido.NEXTVAL INTO v_ref_id FROM DUAL;
    
    INSERT INTO referido (
        referido_id, usuario_referidor_id, usuario_referido_id, fecha_referido
    ) VALUES (
        v_ref_id, p_usuario_ref, v_usuario_ref_id, SYSDATE
    );
    
    p_resultado := 'REFERIDO_REGISTRADO';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_registrar_referido;
/

-- =====================================================
-- 8. PROCEDIMIENTOS DE RESEÑAS
-- =====================================================

-- Procedimiento: Agregar reseña
CREATE OR REPLACE PROCEDURE sp_agregar_resena(
    p_perfil_id      IN NUMBER,
    p_contenido_id   IN NUMBER,
    p_calificacion IN NUMBER,
    p_texto       IN CLOB,
    p_resena_id   OUT NUMBER,
    p_resultado   OUT VARCHAR2
) IS
BEGIN
    SELECT seq_resena.NEXTVAL INTO p_resena_id FROM DUAL;
    
    INSERT INTO resena (
        resena_id, perfil_id, contenido_id, calificacion, texto, fecha_publicacion
    ) VALUES (
        p_resena_id, p_perfil_id, p_contenido_id, p_calificacion, p_texto, SYSDATE
    );
    
    p_resultado := 'RESENA_AGREGADA';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END sp_agregar_resena;
/

-- =====================================================
-- 9. CURSORES COMO FUNCIONES
-- =====================================================

-- Función que retorna cursor: Contenido por género
CREATE OR REPLACE FUNCTION fn_cursor_contenido_genero(
    p_genero_id IN NUMBER
) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT c.contenido_id, c.titulo, c.anno_lanzamiento, c.duracion, c.clasificacion_edad
        FROM contenido c
        JOIN contenido_genero cg ON c.contenido_id = cg.contenido_id
        WHERE cg.genero_id = p_genero_id
        ORDER BY c.fecha_agregado DESC;
    
    RETURN v_cursor;
END fn_cursor_contenido_genero;
/

-- =====================================================
-- 10. CONSULTAS PARAMETRIZADAS (VISTAS)
-- =====================================================

-- Vista: Mejores contenido por calificación
CREATE OR REPLACE VIEW v_mejores_contenido AS
SELECT 
    c.contenido_id,
    c.titulo,
    c.tipo,
    c.clasificacion_edad,
    ROUND(AVG(r.calificacion), 2) AS promedio,
    COUNT(r.resena_id) AS total_resenas
FROM contenido c
LEFT JOIN resena r ON c.contenido_id = r.contenido_id
GROUP BY c.contenido_id, c.titulo, c.tipo, c.clasificacion_edad
HAVING AVG(r.calificacion) >= 4
ORDER BY promedio DESC;

-- Vista: Contenido más visto
CREATE OR REPLACE VIEW v_contenido_mas_visto AS
SELECT 
    c.contenido_id,
    c.titulo,
    c.tipo,
    COUNT(r.reproduccion_id) AS reproducciones,
    SUM(ROUND((r.fecha_fin - r.fecha_inicio) * 24 * 60)) AS minutos_vistos
FROM contenido c
LEFT JOIN reproduccion r ON c.contenido_id = r.contenido_id
GROUP BY c.contenido_id, c.titulo, c.tipo
ORDER BY reproducciones DESC;

-- Vista: Usuarios con más perfiles
CREATE OR REPLACE VIEW v_usuarios_activos AS
SELECT 
    u.usuario_id,
    u.nombre,
    u.email,
    p.nombre AS plan,
    COUNT(per.perfil_id) AS num_perfiles,
    COUNT(DISTINCT r.reproduccion_id) AS reproducciones
FROM usuario u
JOIN plan p ON u.plan_id = p.plan_id
LEFT JOIN perfil per ON u.usuario_id = per.usuario_id
LEFT JOIN reproduccion r ON per.perfil_id = r.perfil_id
GROUP BY u.usuario_id, u.nombre, u.email, p.nombre
ORDER BY reproducciones DESC;