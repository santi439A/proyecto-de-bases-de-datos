# Guía de Referencia PL/SQL para Proyecto QuindioFlix

## 1. Cursores

### Cursor Explícito Básico
```sql
DECLARE
    CURSOR c_contenido IS
        SELECT contenido_id, titulo, anno_lanzamiento
        FROM contenido
        WHERE clasificacion_edad <= 13;
BEGIN
    FOR rec IN c_contenido LOOP
        DBMS_OUTPUT.PUT_LINE(rec.titulo);
    END LOOP;
END;
```

### Cursor con Parámetro
```sql
CREATE OR REPLACE PROCEDURE sp_listar_contenido_por_genero(
    p_genero IN VARCHAR2
) IS
    CURSOR c_gen (g VARCHAR2) IS
        SELECT c.contenido_id, c.titulo, c.anno_lanzamiento
        FROM contenido c
        JOIN contenido_genero cg ON c.contenido_id = cg.contenido_id
        JOIN genero ge ON cg.genero_id = ge.genero_id
        WHERE UPPER(ge.nombre) = UPPER(g);
BEGIN
    FOR rec IN c_gen(p_genero) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.contenido_id || ' - ' || rec.titulo);
    END LOOP;
END;
```

### Cursor con FOR UPDATE
```sql
DECLARE
    CURSOR c_reproduccion IS
        SELECT reproduccion_id, porcentaje_avance
        FROM reproduccion
        WHERE estado = 'ACTIVA'
        FOR UPDATE OF porcentaje_avance;
BEGIN
    FOR rec IN c_reproduccion LOOP
        UPDATE reproduccion
        SET porcentaje_avance = rec.porcentaje_avance + 10
        WHERE CURRENT OF c_reproduccion;
    END LOOP;
END;
```

## 2. Procedimientos Almacenados

### Procedure con Parameters IN, OUT, IN OUT
```sql
CREATE OR REPLACE PROCEDURE sp_registrar_usuario(
    p_nombre        IN  VARCHAR2,
    p_email         IN  VARCHAR2,
    p_telefono      IN  VARCHAR2,
    p_fecha_nac     IN  DATE,
    p_ciudad        IN  VARCHAR2,
    p_plan_id       IN  NUMBER,
    p_usuario_id    OUT NUMBER,
    p_resultado     OUT VARCHAR2
) IS
BEGIN
    INSERT INTO usuario (nombre, email, telefono, fecha_nacimiento, ciudad_residencia, plan_id, fecha_registro)
    VALUES (p_nombre, p_email, p_telefono, p_fecha_nac, p_ciudad, p_plan_id, SYSDATE)
    RETURNING usuario_id INTO p_usuario_id;
    
    p_resultado := 'USUARIO_REGISTRADO';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_resultado := 'ERROR: EMAIL_YA_EXISTE';
    WHEN OTHERS THEN
        p_resultado := 'ERROR: ' || SQLERRM;
END;
```

## 3. Funciones

### Función que Retorna Valor
```sql
CREATE OR REPLACE FUNCTION fn_calcular_descuento(
    p_usuario_id IN NUMBER,
    p_monto IN NUMBER
) RETURN NUMBER IS
    v_tiene_referido NUMBER;
    v_descuento NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_tiene_referido
    FROM referido
    WHERE usuario_referido_id = p_usuario_id;
    
    IF v_tiene_referido > 0 THEN
        v_descuento := p_monto * 0.10;
    END IF;
    
    RETURN v_descuento;
END;
```

### Función Determinística
```sql
CREATE OR REPLACE FUNCTION fn_contenido_activo(
    p_contenido_id IN NUMBER
) RETURN VARCHAR2 DETERMINISTIC IS
    v_estado VARCHAR2(20);
BEGIN
    SELECT DECODE(COUNT(*), 1, 'ACTIVO', 'INACTIVO')
    INTO v_estado
    FROM contenido
    WHERE contenido_id = p_contenido_id;
    
    RETURN v_estado;
END;
```

## 4. Triggers

### Trigger BEFORE INSERT - Validar Clasificación
```sql
CREATE OR REPLACE TRIGGER tr_validar_contenido
BEFORE INSERT ON contenido
FOR EACH ROW
DECLARE
    v_clasificaciones VALIDADAS := ('TP', '+7', '+13', '+16', '+18');
BEGIN
    IF :NEW.clasificacion_edad NOT IN v_clasificaciones THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Clasificación inválida. Valores permitidos: TP, +7, +13, +16, +18');
    END IF;
END;
```

### Trigger AFTER INSERT - Registrar Auditoría
```sql
CREATE OR REPLACE TRIGGER tr_auditoria_usuario
AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (tabla, operacion, usuario, fecha, datos_anteriores, datos_nuevos)
    VALUES ('USUARIO', 'INSERT', USER, SYSDATE, NULL, 
            :NEW.nombre || '|' || :NEW.email);
END;
```

### Trigger Compound - Resolver Mutating Table
```sql
CREATE OR REPLACE TRIGGER tr_actualizar_estadisticas
FOR UPDATE ON contenido
COMPOUND TRIGGER
    TYPE t_stats IS TABLE OF NUMBER INDEX BY VARCHAR2(50);
    v_stats t_stats;
BEGIN
    FOR EACH ROW
    WHEN NEW.clasificacion_edad IS NOT NULL
    BEGIN
        v_stats(:OLD.clasificacion_edad) := NVL(v_stats(:OLD.clasificacion_edad), 0) - 1;
        v_stats(:NEW.clasificacion_edad) := NVL(v_stats(:NEW.clasificacion_edad), 0) + 1;
    END;
    
    AFTER STATEMENT IS
    BEGIN
        FOR tipo IN v_stats.FIRST .. v_stats.LAST LOOP
            IF v_stats.EXISTS(tipo) THEN
                UPDATE estadisticas_contenido
                SET cantidad = cantidad + v_stats(tipo)
                WHERE clasificacion = tipo;
            END IF;
        END LOOP;
    END;
END;
```

## 5. Excepciones

### Manejo de Excepciones
```sql
BEGIN
    DELETE FROM usuario WHERE usuario_id = p_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Usuario no encontrado');
        RAISE_APPLICATION_ERROR(-20002, 'Usuario no existe');
    WHEN CHILD_RECORD_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('No se puede eliminar - tiene datos relacionados');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE;
END;
```

### Excepción Personalizada
```sql
DECLARE
    e_perfil_infantil EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_perfil_infantil, -20010);
BEGIN
    IF p_tipo_perfil = 'INFANTIL' AND p_clasificacion > 13 THEN
        RAISE_APPLICATION_ERROR(-20010, 
            'Perfil infantil no puede acceder a contenido +16');
    END IF;
END;
```

## 6. Packages

### Package básico
```sql
CREATE OR REPLACE PACKAGE pkg_contenido AS
    PROCEDURE sp_agregar_contenido(p_titulo VARCHAR2, p_tipo VARCHAR2);
    FUNCTION fn_verificar_disponibilidad(p_id NUMBER) RETURN VARCHAR2;
END pkg_contenido;
/

CREATE OR REPLACE PACKAGE BODY pkg_contenido AS
    PROCEDURE sp_agregar_contenido(p_titulo VARCHAR2, p_tipo VARCHAR2) IS
    BEGIN
        INSERT INTO contenido (titulo, tipo, fecha_agregado)
        VALUES (p_titulo, p_tipo, SYSDATE);
    END;
    
    FUNCTION fn_verificar_disponibilidad(p_id NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN 'DISPONIBLE';
    END;
END pkg_contenido;
```

## 7. Transacciones y Concurrencia

### Transacción con Savepoint
```sql
BEGIN
    SAVEPOINT sp_inicio;
    
    INSERT INTO usuario VALUES (...);
    INSERT INTO perfil VALUES (...);
    
    IF v_error THEN
        ROLLBACK TO sp_inicio;
    ELSE
        COMMIT;
    END IF;
END;
```

### Bloqueo de Filas
```sql
SELECT * FROM reproduccion
WHERE reproduccion_id = p_id
FOR UPDATE WAIT 10;
```

## 8. Índices y EXPLAIN PLAN

### Crear Índice
```sql
CREATE INDEX idx_contenido_genero ON contenido_genero(contenido_id);
CREATE INDEX idx_reproduccion_fecha ON reproduccion(fecha_inicio);
CREATE INDEX idx_usuario_email ON usuario(email) UNIQUE;
```

### Analizar Query
```sql
EXPLAIN PLAN FOR
SELECT c.titulo, r.fecha_inicio
FROM contenido c
JOIN reproduccion r ON c.contenido_id = r.contenido_id
WHERE r.fecha_inicio >= SYSDATE - 30;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```