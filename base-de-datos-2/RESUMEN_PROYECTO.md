# RESUMEN DEL PROYECTO - QUINDIOFLIX

## Información General

**Proyecto**: QuindioFlix - Plataforma de Streaming de Contenido Multimedia  
**Curso**: Bases de Datos II  
**Universidad**: Universidad del Quindío - Ingeniería de Sistemas y Computación  
**Modalidad**: Oracle Database

---

## Descripción del Sistema

QuindioFlix es una plataforma de streaming similar a Netflix que opera en Colombia. Ofrece:
- Películas
- Series
- Documentales
- Música
- Podcasts

---

## Modelo de Datos (17 Tablas)

### Entidades Principales:

| # | Entidad | Descripción |
|---|---------|-------------|
| 1 | PLAN | Planes de suscripción (Básico, Estándar, Premium) |
| 2 | GENERO | Géneros de contenido |
| 3 | DEPARTAMENTO | Departamentos de la empresa |
| 4 | EMPLEADO | Empleados con jerarquía de supervisión |
| 5 | CONTENIDO | Películas, series, documentales, música, podcasts |
| 6 | CONTENIDO_GENERO | Relación N:M contenido-género |
| 7 | TEMPORADA | Temporadas de series/podcasts |
| 8 | EPISODIO | Episodios individuales |
| 9 | USUARIO | Usuarios registrados |
| 10 | PERFIL | Perfiles de usuario (adulto/infantil) |
| 11 | REFERIDO | Sistema de referidos entre usuarios |
| 12 | REPRODUCCION | Historial de reproducciones |
| 13 | FAVORITO | Lista de favoritos por perfil |
| 14 | RESENA | Reseñas y calificaciones |
| 15 | REPORTE | Reportes de contenido inapropiado |
| 16 | PAGO | Registro de pagos |
| 17 | FACTURA | Facturas mensuales |

---

## Reglas de Negocio Importantes

1. **Perfiles infantiles**: Solo pueden acceder contenido con clasificación TP, +7 o +13
2. **Planes**: Básico=1 pantalla, Estándar=2 pantallas, Premium=4 pantallas
3. **Reproducciones**: Registrar inicio, fin, dispositivo y porcentaje de avance
4. **Referidos**: Ambos usuarios reciben beneficio cuando el referido se registra
5. **Reportes**: Deben ser revisados por un moderador (empleado)
6. **Empleados**: Cada departamento tiene un jefe, hay jerarquía de supervisión

---

## Archivos del Proyecto

### Estructura de Carpetas:

```
/base-de-datos-2/
├── 01_Documentos/
│   ├── Proyecto_QuindioFlix.docx
│   └── Plantilla proyecto final.docx
├── 02_Diagramas/
│   ├── DIAGRAMA_MER_QUINDIOFLIX.png
│   ├── DIAGRAMA_LOGICO_QUINDIOFLIX.png
│   ├── diagrama_mer_quindioflix.dot
│   └── diagrama_logico_quindioflix.dot
├── 03_Modelos/
│   ├── MODELO_ER.md
│   └── DIAGRAMA_LOGICO.md
├── 04_Scripts_SQL/
│   ├── TABLAS_PLSQL.sql
│   ├── PROCEDIMIENTOS_FUNCIONES.sql
│   ├── TRIGGERS_TRANSACCIONES.sql
│   └── ROLES_PRIVILEGIOS.sql
└── 05_Referencia/
    └── PLSQL_REFERENCIA.md
```

---

## Contenido de Cada Archivo

### 01_Documentos/
- **Proyecto_QuindioFlix.docx**: Documento original con los requisitos del proyecto
- **Plantilla proyecto final.docx**: Plantilla oficial de entrega

### 02_Diagramas/
- **DIAGRAMA_MER_QUINDIOFLIX.png**: Modelo Entidad-Relación (solo nombres atributos, sin tipos de datos)
- **DIAGRAMA_LOGICO_QUINDIOFLIX.png**: Diagrama Lógico Relacional (con tipos Oracle y restricciones CHECK)
- **.dot**: Archivos fuente para regenerar los diagramas

### 03_Modelos/
- **MODELO_ER.md**: Documentación del modelo entidad-relación
- **DIAGRAMA_LOGICO.md**: Documentación del modelo lógico

### 04_Scripts_SQL/
- **TABLAS_PLSQL.sql**: Creación de tablas, tablespaces, secuencias, índices
- **PROCEDIMIENTOS_FUNCIONES.sql**: Store procedures y funciones
- **TRIGGERS_TRANSACCIONES.sql**: Triggers y manejo de transacciones
- **ROLES_PRIVILEGIOS.sql**: Esquema de seguridad

### 05_Referencia/
- **PLSQL_REFERENCIA.md**: Guía de referencia PL/SQL

---

## Características de los Diagramas

### DIAGRAMA MER (Modelo Entidad-Relación)
- Solo nombres de atributos (sin tipos de datos Oracle)
- Llaves primarias subrayadas
- FK indicadas como (FK)
- Cardinalidades: 1:N, 1:1, N:M
- Organizado en 5 capas según dependencias

### DIAGRAMA LÓGICO RELACIONAL (3FN)
- Tipos de datos Oracle completos (NUMBER, VARCHAR2, DATE, TIMESTAMP, CLOB)
- Restricciones NOT NULL
- Restricciones UNIQUE
- Restricciones CHECK (ej: CHECK(IN('TP','+7','+13','+16','+18')))
- PK y FK claramente identificadas
- Ya transformado a 3FN

---

## Temas del Curso Incluidos

1. ✅ Modelo MER
2. ✅ Transformación al modelo relacional
3. ✅ Normalización hasta 3FN
4. ✅ Tablespaces y fragmentación
5. ✅ PL/SQL (cursores, procedimientos, funciones)
6. ✅ Triggers
7. ✅ Transacciones y concurrencia
8. ✅ Índices y EXPLAIN PLAN
9. ✅ Usuarios, roles y privilegios

---

## Notas para Siguiente IA

### Cosas que funcionaron bien:
- El modelo de datos está bien estructurado en 3FN
- Los diagramas se generaron usando Graphviz (DOT)
- Los scripts SQL están listos para ejecutar en Oracle

### Problemas encontrados:
- Las líneas de cardinalidad se superponían inicialmente - se arregló aumentando el espaciado
- No existen skills especializadas disponibles en el sistema para Oracle PL/SQL

### Pendiente:
- Ejecutar los scripts en una base de datos Oracle real
- Pruebas de funcionamiento
- Datos de prueba (mínimo 25 registros por tabla)

---

## Comandos Útiles

### Generar diagramas:
```bash
dot -Tpng -Gdpi=150 diagrama_mer_quindioflix.dot -o DIAGRAMA_MER_QUINDIOFLIX.png
dot -Tpng -Gdpi=150 diagrama_logico_quindioflix.dot -o DIAGRAMA_LOGICO_QUINDIOFLIX.png
```

### Ejecutar scripts SQL en Oracle:
```sql
@04_Scripts_SQL/TABLAS_PLSQL.sql
@04_Scripts_SQL/PROCEDIMIENTOS_FUNCIONES.sql
@04_Scripts_SQL/TRIGGERS_TRANSACCIONES.sql
@04_Scripts_SQL/ROLES_PRIVILEGIOS.sql
```

---

**Fecha de creación**: 2026-04-09  
**Última actualización**: 2026-04-09
