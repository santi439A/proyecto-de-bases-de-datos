-- =====================================================
-- QUINDIOFLIX - CARGA DE DATOS DE PRUEBA
-- Base de Datos II
-- Ejecutar despues de 01_CREACION_TABLESPACES_TABLAS.sql
-- =====================================================

-- =====================================================
-- 1. TABLAS MAESTRAS
-- =====================================================

BEGIN
    FOR i IN 1..25 LOOP
        INSERT INTO plan (plan_id, nombre, precio_mensual, num_pantallas, max_perfiles, calidad)
        VALUES (
            i,
            CASE
                WHEN i <= 9 THEN 'BASICO_' || LPAD(i, 2, '0')
                WHEN i <= 17 THEN 'ESTANDAR_' || LPAD(i - 9, 2, '0')
                ELSE 'PREMIUM_' || LPAD(i - 17, 2, '0')
            END,
            CASE
                WHEN i <= 9 THEN 14900
                WHEN i <= 17 THEN 24900
                ELSE 34900
            END,
            CASE
                WHEN i <= 9 THEN 1
                WHEN i <= 17 THEN 2
                ELSE 4
            END,
            CASE
                WHEN i <= 9 THEN 2
                WHEN i <= 17 THEN 3
                ELSE 5
            END,
            CASE
                WHEN i <= 9 THEN 'SD'
                WHEN i <= 17 THEN 'HD'
                ELSE '4K'
            END
        );
    END LOOP;
END;
/

INSERT INTO categoria (categoria_id, nombre) VALUES (1, 'PELICULA');
INSERT INTO categoria (categoria_id, nombre) VALUES (2, 'SERIE');
INSERT INTO categoria (categoria_id, nombre) VALUES (3, 'DOCUMENTAL');
INSERT INTO categoria (categoria_id, nombre) VALUES (4, 'MUSICA');
INSERT INTO categoria (categoria_id, nombre) VALUES (5, 'PODCAST');
INSERT INTO categoria (categoria_id, nombre) VALUES (6, 'PELICULA_CLASICA');
INSERT INTO categoria (categoria_id, nombre) VALUES (7, 'PELICULA_INDEPENDIENTE');
INSERT INTO categoria (categoria_id, nombre) VALUES (8, 'SERIE_CORTA');
INSERT INTO categoria (categoria_id, nombre) VALUES (9, 'SERIE_DRAMATICA');
INSERT INTO categoria (categoria_id, nombre) VALUES (10, 'DOCUMENTAL_CIENTIFICO');
INSERT INTO categoria (categoria_id, nombre) VALUES (11, 'DOCUMENTAL_SOCIAL');
INSERT INTO categoria (categoria_id, nombre) VALUES (12, 'MUSICA_EN_VIVO');
INSERT INTO categoria (categoria_id, nombre) VALUES (13, 'MUSICA_ESTUDIO');
INSERT INTO categoria (categoria_id, nombre) VALUES (14, 'PODCAST_ENTREVISTA');
INSERT INTO categoria (categoria_id, nombre) VALUES (15, 'PODCAST_TECNOLOGIA');
INSERT INTO categoria (categoria_id, nombre) VALUES (16, 'PELICULA_FAMILIAR');
INSERT INTO categoria (categoria_id, nombre) VALUES (17, 'PELICULA_LATINA');
INSERT INTO categoria (categoria_id, nombre) VALUES (18, 'SERIE_JUVENIL');
INSERT INTO categoria (categoria_id, nombre) VALUES (19, 'SERIE_POLICIAL');
INSERT INTO categoria (categoria_id, nombre) VALUES (20, 'DOCUMENTAL_HISTORICO');
INSERT INTO categoria (categoria_id, nombre) VALUES (21, 'DOCUMENTAL_DEPORTIVO');
INSERT INTO categoria (categoria_id, nombre) VALUES (22, 'MUSICA_URBANA');
INSERT INTO categoria (categoria_id, nombre) VALUES (23, 'MUSICA_FOLCLORICA');
INSERT INTO categoria (categoria_id, nombre) VALUES (24, 'PODCAST_EDUCATIVO');
INSERT INTO categoria (categoria_id, nombre) VALUES (25, 'PODCAST_CULTURAL');

INSERT INTO genero (genero_id, nombre) VALUES (1, 'ACCION');
INSERT INTO genero (genero_id, nombre) VALUES (2, 'COMEDIA');
INSERT INTO genero (genero_id, nombre) VALUES (3, 'DRAMA');
INSERT INTO genero (genero_id, nombre) VALUES (4, 'SUSPENSO');
INSERT INTO genero (genero_id, nombre) VALUES (5, 'ROMANCE');
INSERT INTO genero (genero_id, nombre) VALUES (6, 'CIENCIA_FICCION');
INSERT INTO genero (genero_id, nombre) VALUES (7, 'TERROR');
INSERT INTO genero (genero_id, nombre) VALUES (8, 'INFANTIL');
INSERT INTO genero (genero_id, nombre) VALUES (9, 'AVENTURA');
INSERT INTO genero (genero_id, nombre) VALUES (10, 'BIOGRAFICO');
INSERT INTO genero (genero_id, nombre) VALUES (11, 'CRIMEN');
INSERT INTO genero (genero_id, nombre) VALUES (12, 'FANTASIA');
INSERT INTO genero (genero_id, nombre) VALUES (13, 'HISTORICO');
INSERT INTO genero (genero_id, nombre) VALUES (14, 'MUSICAL');
INSERT INTO genero (genero_id, nombre) VALUES (15, 'MISTERIO');
INSERT INTO genero (genero_id, nombre) VALUES (16, 'POLITICO');
INSERT INTO genero (genero_id, nombre) VALUES (17, 'DEPORTIVO');
INSERT INTO genero (genero_id, nombre) VALUES (18, 'ANIMACION');
INSERT INTO genero (genero_id, nombre) VALUES (19, 'FAMILIAR');
INSERT INTO genero (genero_id, nombre) VALUES (20, 'REALITY');
INSERT INTO genero (genero_id, nombre) VALUES (21, 'KIDS');
INSERT INTO genero (genero_id, nombre) VALUES (22, 'TECNOLOGIA');
INSERT INTO genero (genero_id, nombre) VALUES (23, 'EDUCATIVO');
INSERT INTO genero (genero_id, nombre) VALUES (24, 'SOCIAL');
INSERT INTO genero (genero_id, nombre) VALUES (25, 'CULTURAL');

BEGIN
    FOR i IN 1..25 LOOP
        INSERT INTO departamento (departamento_id, nombre, jefe_id)
        VALUES (
            i,
            CASE i
                WHEN 1 THEN 'TECNOLOGIA'
                WHEN 2 THEN 'CONTENIDO'
                WHEN 3 THEN 'MARKETING'
                WHEN 4 THEN 'SOPORTE'
                WHEN 5 THEN 'FINANZAS'
                ELSE 'DEPARTAMENTO_' || LPAD(i, 2, '0')
            END,
            NULL
        );
    END LOOP;
END;
/

-- =====================================================
-- 2. EMPLEADOS
-- =====================================================

BEGIN
    FOR i IN 1..25 LOOP
        INSERT INTO empleado (
            empleado_id,
            nombre,
            email,
            telefono,
            cargo,
            departamento_id,
            supervisor_id
        ) VALUES (
            i,
            'Empleado ' || i,
            'empleado' || i || '@quindioflix.com',
            '300555' || LPAD(i, 4, '0'),
            CASE
                WHEN i <= 5 THEN 'JEFE_DEPARTAMENTO'
                WHEN i BETWEEN 6 AND 10 THEN 'GESTOR_CONTENIDO'
                WHEN i BETWEEN 11 AND 15 THEN 'MODERADOR'
                WHEN i BETWEEN 16 AND 20 THEN 'DESARROLLADOR'
                ELSE 'ANALISTA'
            END,
            i,
            CASE
                WHEN i <= 5 THEN NULL
                WHEN i <= 10 THEN 2
                WHEN i <= 15 THEN 4
                WHEN i <= 20 THEN 1
                ELSE 5
            END
        );
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..25 LOOP
        UPDATE departamento
        SET jefe_id = i
        WHERE departamento_id = i;
    END LOOP;
END;
/

-- =====================================================
-- 3. USUARIOS, PERFILES Y REFERIDOS
-- =====================================================

BEGIN
    FOR i IN 1..30 LOOP
        INSERT INTO usuario (
            usuario_id,
            nombre,
            email,
            telefono,
            fecha_nacimiento,
            ciudad_residencia,
            plan_id,
            fecha_registro,
            estado_cuenta,
            fecha_ultimo_pago
        ) VALUES (
            i,
            'Usuario ' || i,
            'usuario' || i || '@mail.com',
            '311444' || LPAD(i, 4, '0'),
            DATE '1990-01-01' + MOD(i * 23, 8000),
            CASE MOD(i - 1, 5)
                WHEN 0 THEN 'Armenia'
                WHEN 1 THEN 'Bogota'
                WHEN 2 THEN 'Medellin'
                WHEN 3 THEN 'Cali'
                ELSE 'Pereira'
            END,
            MOD(i - 1, 3) + 1,
            DATE '2025-01-01' + i,
            CASE WHEN MOD(i, 10) = 0 THEN 'SUSPENDIDO' ELSE 'ACTIVO' END,
            ADD_MONTHS(DATE '2025-12-01', -MOD(i, 3))
        );
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..60 LOOP
        INSERT INTO perfil (
            perfil_id,
            usuario_id,
            nombre,
            avatar,
            tipo
        ) VALUES (
            i,
            CEIL(i / 2),
            'Perfil ' || i,
            'avatar_' || i || '.png',
            CASE
                WHEN MOD(i, 4) = 0 THEN 'INFANTIL'
                ELSE 'ADULTO'
            END
        );
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..25 LOOP
        INSERT INTO referido (
            referido_id,
            usuario_referidor_id,
            usuario_referido_id,
            beneficio,
            estado_beneficio,
            fecha_referido
        ) VALUES (
            i,
            i,
            i + 5,
            'DESCUENTO 10 POR CIENTO',
            CASE MOD(i, 3)
                WHEN 0 THEN 'APLICADO'
                WHEN 1 THEN 'PENDIENTE'
                ELSE 'VENCIDO'
            END,
            DATE '2025-02-01' + i
        );
    END LOOP;
END;
/

-- =====================================================
-- 4. CONTENIDO Y CLASIFICACIONES
-- =====================================================

BEGIN
    FOR i IN 1..40 LOOP
        INSERT INTO contenido (
            contenido_id,
            categoria_id,
            titulo,
            anno_lanzamiento,
            duracion_minutos,
            sinopsis,
            clasificacion_edad,
            fecha_agregado,
            es_original,
            empleado_responsable_id
        ) VALUES (
            i,
            MOD(i - 1, 5) + 1,
            'Contenido ' || i,
            2010 + MOD(i, 15),
            CASE
                WHEN MOD(i - 1, 5) + 1 = 4 THEN 5 + MOD(i, 10)
                WHEN MOD(i - 1, 5) + 1 = 5 THEN 30 + MOD(i, 25)
                ELSE 80 + MOD(i, 60)
            END,
            'Sinopsis del contenido ' || i,
            CASE MOD(i, 5)
                WHEN 0 THEN 'TP'
                WHEN 1 THEN '+7'
                WHEN 2 THEN '+13'
                WHEN 3 THEN '+16'
                ELSE '+18'
            END,
            DATE '2025-01-10' + i,
            CASE WHEN MOD(i, 3) = 0 THEN 1 ELSE 0 END,
            6 + MOD(i - 1, 10)
        );
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..40 LOOP
        INSERT INTO contenido_genero (contenido_id, genero_id)
        VALUES (i, MOD(i - 1, 8) + 1);

        INSERT INTO contenido_genero (contenido_id, genero_id)
        VALUES (i, MOD(i + 2, 8) + 1);
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..40 LOOP
        INSERT INTO contenido_relacionado (
            contenido_origen_id,
            contenido_relacionado_id,
            tipo_relacion
        ) VALUES (
            i,
            CASE WHEN i = 40 THEN 1 ELSE i + 1 END,
            CASE MOD(i, 5)
                WHEN 0 THEN 'SECUELA'
                WHEN 1 THEN 'PRECUELA'
                WHEN 2 THEN 'REMAKE'
                WHEN 3 THEN 'SPIN_OFF'
                ELSE 'VERSION_EXTENDIDA'
            END
        );
    END LOOP;
END;
/

BEGIN
    DECLARE
        v_temporada_id NUMBER := 1;
        v_extra NUMBER := 0;
    BEGIN
        FOR i IN 1..40 LOOP
            IF MOD(i - 1, 5) + 1 IN (2, 5) THEN
                INSERT INTO temporada (temporada_id, contenido_id, numero)
                VALUES (v_temporada_id, i, 1);
                v_temporada_id := v_temporada_id + 1;
            END IF;
        END LOOP;

        FOR i IN 1..40 LOOP
            IF MOD(i - 1, 5) + 1 IN (2, 5) AND v_extra < 9 THEN
                INSERT INTO temporada (temporada_id, contenido_id, numero)
                VALUES (v_temporada_id, i, 2);
                v_temporada_id := v_temporada_id + 1;
                v_extra := v_extra + 1;
            END IF;
        END LOOP;
    END;
END;
/

BEGIN
    DECLARE
        v_episodio_id NUMBER := 1;
    BEGIN
        FOR t IN 1..25 LOOP
            FOR n IN 1..2 LOOP
                INSERT INTO episodio (
                    episodio_id,
                    temporada_id,
                    numero,
                    titulo,
                    duracion_minutos
                ) VALUES (
                    v_episodio_id,
                    t,
                    n,
                    'Episodio ' || n || ' Temporada ' || t,
                    20 + MOD(v_episodio_id, 40)
                );
                v_episodio_id := v_episodio_id + 1;
            END LOOP;
        END LOOP;
    END;
END;
/

-- =====================================================
-- 5. CONSUMO Y MODERACION
-- =====================================================

BEGIN
    FOR i IN 1..200 LOOP
        DECLARE
            v_inicio TIMESTAMP;
            v_fin TIMESTAMP;
            v_episodio NUMBER;
        BEGIN
            IF i <= 80 THEN
                v_inicio := TO_TIMESTAMP('2025-01-01 08:00:00','YYYY-MM-DD HH24:MI:SS')
                          + NUMTODSINTERVAL(i, 'DAY');
            ELSIF i <= 160 THEN
                v_inicio := TO_TIMESTAMP('2026-01-01 08:00:00','YYYY-MM-DD HH24:MI:SS')
                          + NUMTODSINTERVAL(i - 80, 'DAY');
            ELSE
                v_inicio := TO_TIMESTAMP('2027-01-01 08:00:00','YYYY-MM-DD HH24:MI:SS')
                          + NUMTODSINTERVAL(i - 160, 'DAY');
            END IF;

            IF MOD(i, 10) = 0 THEN
                v_fin := NULL;
            ELSE
                v_fin := v_inicio + NUMTODSINTERVAL(25 + MOD(i, 95), 'MINUTE');
            END IF;

            IF MOD(i, 4) = 0 THEN
                v_episodio := MOD(i - 1, 50) + 1;
            ELSE
                v_episodio := NULL;
            END IF;

            INSERT INTO reproduccion (
                reproduccion_id,
                perfil_id,
                contenido_id,
                episodio_id,
                fecha_inicio,
                fecha_fin,
                dispositivo,
                porcentaje_avance
            ) VALUES (
                i,
                MOD(i - 1, 60) + 1,
                MOD(i - 1, 40) + 1,
                v_episodio,
                v_inicio,
                v_fin,
                CASE MOD(i, 4)
                    WHEN 0 THEN 'CELULAR'
                    WHEN 1 THEN 'TABLET'
                    WHEN 2 THEN 'TV'
                    ELSE 'COMPUTADOR'
                END,
                CASE
                    WHEN MOD(i, 6) = 0 THEN 100
                    ELSE 20 + MOD(i * 7, 81)
                END
            );
        END;
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..60 LOOP
        INSERT INTO favorito (perfil_id, contenido_id, fecha_agregado)
        VALUES (i, MOD(i - 1, 40) + 1, DATE '2025-03-01' + i);
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..60 LOOP
        INSERT INTO resena (
            resena_id,
            perfil_id,
            contenido_id,
            calificacion,
            texto,
            fecha_publicacion
        ) VALUES (
            i,
            i,
            MOD(i - 1, 40) + 1,
            MOD(i - 1, 5) + 1,
            'Resena de prueba ' || i,
            DATE '2025-04-01' + i
        );
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..30 LOOP
        INSERT INTO reporte (
            reporte_id,
            contenido_id,
            perfil_id,
            moderador_id,
            motivo,
            estado,
            fecha_reporte,
            fecha_resolucion
        ) VALUES (
            i,
            MOD(i - 1, 40) + 1,
            MOD(i - 1, 60) + 1,
            16 + MOD(i - 1, 5),
            'Motivo de prueba ' || i,
            CASE MOD(i, 4)
                WHEN 0 THEN 'PENDIENTE'
                WHEN 1 THEN 'EN_REVISION'
                WHEN 2 THEN 'APROBADO'
                ELSE 'RECHAZADO'
            END,
            DATE '2025-05-01' + i,
            CASE WHEN MOD(i, 4) IN (2, 3) THEN DATE '2025-05-15' + i ELSE NULL END
        );
    END LOOP;
END;
/

-- =====================================================
-- 6. FACTURACION Y PAGOS
-- =====================================================

BEGIN
    DECLARE
        v_factura_id NUMBER := 1;
    BEGIN
        FOR u IN 1..30 LOOP
            INSERT INTO factura (
                factura_id,
                usuario_id,
                periodo,
                monto_total,
                estado_factura,
                fecha_emision,
                fecha_vencimiento
            ) VALUES (
                v_factura_id,
                u,
                '2025-01',
                CASE MOD(u - 1, 3) + 1
                    WHEN 1 THEN 14900
                    WHEN 2 THEN 24900
                    ELSE 34900
                END,
                CASE WHEN MOD(u, 7) = 0 THEN 'VENCIDA' ELSE 'PAGADA' END,
                DATE '2025-01-01',
                DATE '2025-01-31'
            );
            v_factura_id := v_factura_id + 1;

            INSERT INTO factura (
                factura_id,
                usuario_id,
                periodo,
                monto_total,
                estado_factura,
                fecha_emision,
                fecha_vencimiento
            ) VALUES (
                v_factura_id,
                u,
                '2025-02',
                CASE MOD(u - 1, 3) + 1
                    WHEN 1 THEN 14900
                    WHEN 2 THEN 24900
                    ELSE 34900
                END,
                CASE WHEN MOD(u, 5) = 0 THEN 'PENDIENTE' ELSE 'PAGADA' END,
                DATE '2025-02-01',
                DATE '2025-02-28'
            );
            v_factura_id := v_factura_id + 1;
        END LOOP;
    END;
END;
/

BEGIN
    FOR i IN 1..80 LOOP
        INSERT INTO pago (
            pago_id,
            factura_id,
            fecha_pago,
            monto_pagado,
            metodo_pago,
            estado_pago,
            referencia
        ) VALUES (
            i,
            CASE WHEN i <= 60 THEN i ELSE i - 60 END,
            DATE '2025-01-05' + i,
            CASE MOD(i - 1, 3) + 1
                WHEN 1 THEN 14900
                WHEN 2 THEN 24900
                ELSE 34900
            END,
            CASE MOD(i, 5)
                WHEN 0 THEN 'TCREDITO'
                WHEN 1 THEN 'TDEBITO'
                WHEN 2 THEN 'PSE'
                WHEN 3 THEN 'NEQUI'
                ELSE 'DAVIPLATA'
            END,
            CASE MOD(i, 6)
                WHEN 0 THEN 'FALLIDO'
                WHEN 1 THEN 'PENDIENTE'
                WHEN 2 THEN 'REEMBOLSADO'
                ELSE 'EXITOSO'
            END,
            'REF-' || LPAD(i, 5, '0')
        );
    END LOOP;
END;
/

COMMIT;

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
