-- =====================================================
-- QUINDIOFLIX - VALIDACION DEL PUNTO 3
-- Base de Datos II
-- Ejecutar despues de:
-- 01_CREACION_TABLESPACES_TABLAS.sql
-- 02_CARGA_DATOS_PRUEBA.sql
-- =====================================================

SET PAGESIZE 200;
SET LINESIZE 220;

PROMPT
PROMPT ===== TABLESPACES =====

SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name IN ('TS_QUINDIOFLIX_DATA', 'TS_QUINDIOFLIX_INDX')
ORDER BY tablespace_name;

PROMPT
PROMPT ===== DATAFILES =====

SELECT tablespace_name,
       file_name,
       ROUND(bytes / 1024 / 1024, 2) AS tamano_mb,
       autoextensible,
       ROUND(maxbytes / 1024 / 1024, 2) AS max_mb
FROM dba_data_files
WHERE tablespace_name IN ('TS_QUINDIOFLIX_DATA', 'TS_QUINDIOFLIX_INDX')
ORDER BY tablespace_name, file_name;

PROMPT
PROMPT ===== TABLAS CREADAS Y TABLESPACE ASIGNADO =====

SELECT table_name, tablespace_name, partitioned
FROM user_tables
ORDER BY table_name;

PROMPT
PROMPT ===== PARTICIONES DE REPRODUCCION =====

SELECT table_name,
       partition_name,
       partition_position,
       tablespace_name
FROM user_tab_partitions
WHERE table_name = 'REPRODUCCION'
ORDER BY partition_position;

PROMPT
PROMPT ===== INDICES CREADOS =====

SELECT index_name, table_name, tablespace_name, uniqueness
FROM user_indexes
ORDER BY table_name, index_name;

PROMPT
PROMPT ===== CANTIDAD DE REGISTROS POR TABLA =====

SELECT 'CATEGORIA' AS tabla, COUNT(*) AS total FROM categoria
UNION ALL SELECT 'CONTENIDO', COUNT(*) FROM contenido
UNION ALL SELECT 'CONTENIDO_GENERO', COUNT(*) FROM contenido_genero
UNION ALL SELECT 'CONTENIDO_RELACIONADO', COUNT(*) FROM contenido_relacionado
UNION ALL SELECT 'DEPARTAMENTO', COUNT(*) FROM departamento
UNION ALL SELECT 'EMPLEADO', COUNT(*) FROM empleado
UNION ALL SELECT 'EPISODIO', COUNT(*) FROM episodio
UNION ALL SELECT 'FACTURA', COUNT(*) FROM factura
UNION ALL SELECT 'FAVORITO', COUNT(*) FROM favorito
UNION ALL SELECT 'GENERO', COUNT(*) FROM genero
UNION ALL SELECT 'PAGO', COUNT(*) FROM pago
UNION ALL SELECT 'PERFIL', COUNT(*) FROM perfil
UNION ALL SELECT 'PLAN', COUNT(*) FROM plan
UNION ALL SELECT 'REFERIDO', COUNT(*) FROM referido
UNION ALL SELECT 'REPORTE', COUNT(*) FROM reporte
UNION ALL SELECT 'REPRODUCCION', COUNT(*) FROM reproduccion
UNION ALL SELECT 'RESENA', COUNT(*) FROM resena
UNION ALL SELECT 'TEMPORADA', COUNT(*) FROM temporada
UNION ALL SELECT 'USUARIO', COUNT(*) FROM usuario
ORDER BY tabla;

PROMPT
PROMPT ===== VALIDACION DE TABLAS INTERMEDIAS =====

SELECT 'CONTENIDO_GENERO' AS tabla, COUNT(*) AS total FROM contenido_genero
UNION ALL SELECT 'CONTENIDO_RELACIONADO', COUNT(*) FROM contenido_relacionado
UNION ALL SELECT 'FAVORITO', COUNT(*) FROM favorito
ORDER BY tabla;

PROMPT
PROMPT ===== MUESTRA DE REPRODUCCION POR PARTICION =====

SELECT 'P2025' AS particion, COUNT(*) AS total
FROM reproduccion PARTITION (p2025)
UNION ALL
SELECT 'P2026', COUNT(*)
FROM reproduccion PARTITION (p2026)
UNION ALL
SELECT 'P_MAX', COUNT(*)
FROM reproduccion PARTITION (p_max);

PROMPT
PROMPT ===== VERIFICACION DE MINIMOS EXIGIDOS =====

WITH conteos AS (
    SELECT 'CATEGORIA' tabla, COUNT(*) total, 25 minimo FROM categoria
    UNION ALL SELECT 'CONTENIDO', COUNT(*), 25 FROM contenido
    UNION ALL SELECT 'CONTENIDO_GENERO', COUNT(*), 40 FROM contenido_genero
    UNION ALL SELECT 'CONTENIDO_RELACIONADO', COUNT(*), 40 FROM contenido_relacionado
    UNION ALL SELECT 'DEPARTAMENTO', COUNT(*), 25 FROM departamento
    UNION ALL SELECT 'EMPLEADO', COUNT(*), 25 FROM empleado
    UNION ALL SELECT 'EPISODIO', COUNT(*), 25 FROM episodio
    UNION ALL SELECT 'FACTURA', COUNT(*), 25 FROM factura
    UNION ALL SELECT 'FAVORITO', COUNT(*), 40 FROM favorito
    UNION ALL SELECT 'GENERO', COUNT(*), 25 FROM genero
    UNION ALL SELECT 'PAGO', COUNT(*), 25 FROM pago
    UNION ALL SELECT 'PERFIL', COUNT(*), 25 FROM perfil
    UNION ALL SELECT 'PLAN', COUNT(*), 25 FROM plan
    UNION ALL SELECT 'REFERIDO', COUNT(*), 25 FROM referido
    UNION ALL SELECT 'REPORTE', COUNT(*), 25 FROM reporte
    UNION ALL SELECT 'REPRODUCCION', COUNT(*), 25 FROM reproduccion
    UNION ALL SELECT 'RESENA', COUNT(*), 25 FROM resena
    UNION ALL SELECT 'TEMPORADA', COUNT(*), 25 FROM temporada
    UNION ALL SELECT 'USUARIO', COUNT(*), 25 FROM usuario
)
SELECT tabla,
       total,
       minimo,
       CASE WHEN total >= minimo THEN 'CUMPLE' ELSE 'NO CUMPLE' END AS estado
FROM conteos
ORDER BY tabla;

PROMPT
PROMPT ===== VALIDACION COMPLETADA =====
