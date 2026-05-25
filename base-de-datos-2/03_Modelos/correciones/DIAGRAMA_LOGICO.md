# Diagrama Logico Relacional - QuindioFlix

## 1. Estructura general

El modelo logico relacional de QuindioFlix se organiza en cinco grupos de tablas:

1. Tablas maestras: `PLAN`, `CATEGORIA`, `GENERO`, `DEPARTAMENTO`.
2. Equipo de trabajo: `EMPLEADO`.
3. Catalogo multimedia: `CONTENIDO`, `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO`, `TEMPORADA`, `EPISODIO`.
4. Usuarios y consumo: `USUARIO`, `PERFIL`, `REFERIDO`, `REPRODUCCION`, `FAVORITO`, `RESENA`, `REPORTE`.
5. Componente financiero: `FACTURA`, `PAGO`.

## 2. Tablas del modelo

### PLAN
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| plan_id | NUMBER(2) | PK |
| nombre | VARCHAR2(20) | NOT NULL, UNIQUE |
| precio_mensual | NUMBER(10,2) | NOT NULL |
| num_pantallas | NUMBER(1) | NOT NULL |
| max_perfiles | NUMBER(1) | NOT NULL |
| calidad | VARCHAR2(10) | CHECK ('SD','HD','4K') |

### CATEGORIA
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| categoria_id | NUMBER(2) | PK |
| nombre | VARCHAR2(30) | NOT NULL, UNIQUE |

### GENERO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| genero_id | NUMBER(3) | PK |
| nombre | VARCHAR2(50) | NOT NULL, UNIQUE |

### DEPARTAMENTO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| departamento_id | NUMBER(3) | PK |
| nombre | VARCHAR2(50) | NOT NULL, UNIQUE |
| jefe_id | NUMBER(5) | FK -> EMPLEADO |

### EMPLEADO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| empleado_id | NUMBER(5) | PK |
| nombre | VARCHAR2(100) | NOT NULL |
| email | VARCHAR2(100) | NOT NULL, UNIQUE |
| telefono | VARCHAR2(20) | |
| cargo | VARCHAR2(50) | NOT NULL |
| departamento_id | NUMBER(3) | FK -> DEPARTAMENTO |
| supervisor_id | NUMBER(5) | FK -> EMPLEADO |

### CONTENIDO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| contenido_id | NUMBER(5) | PK |
| categoria_id | NUMBER(2) | FK -> CATEGORIA |
| titulo | VARCHAR2(200) | NOT NULL |
| anno_lanzamiento | NUMBER(4) | NOT NULL |
| duracion_minutos | NUMBER(5) | |
| sinopsis | CLOB | |
| clasificacion_edad | VARCHAR2(5) | CHECK ('TP','+7','+13','+16','+18') |
| fecha_agregado | DATE | NOT NULL |
| es_original | NUMBER(1) | CHECK (0,1) |
| empleado_responsable_id | NUMBER(5) | FK -> EMPLEADO |

### CONTENIDO_GENERO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| contenido_id | NUMBER(5) | PK, FK -> CONTENIDO |
| genero_id | NUMBER(3) | PK, FK -> GENERO |

### CONTENIDO_RELACIONADO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| contenido_origen_id | NUMBER(5) | PK, FK -> CONTENIDO |
| contenido_relacionado_id | NUMBER(5) | PK, FK -> CONTENIDO |
| tipo_relacion | VARCHAR2(30) | NOT NULL |

### TEMPORADA
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| temporada_id | NUMBER(5) | PK |
| contenido_id | NUMBER(5) | FK -> CONTENIDO |
| numero | NUMBER(2) | NOT NULL |

### EPISODIO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| episodio_id | NUMBER(5) | PK |
| temporada_id | NUMBER(5) | FK -> TEMPORADA |
| numero | NUMBER(3) | NOT NULL |
| titulo | VARCHAR2(200) | NOT NULL |
| duracion_minutos | NUMBER(5) | NOT NULL |

### USUARIO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| usuario_id | NUMBER(5) | PK |
| nombre | VARCHAR2(100) | NOT NULL |
| email | VARCHAR2(100) | NOT NULL, UNIQUE |
| telefono | VARCHAR2(20) | |
| fecha_nacimiento | DATE | NOT NULL |
| ciudad_residencia | VARCHAR2(100) | NOT NULL |
| plan_id | NUMBER(2) | FK -> PLAN |
| fecha_registro | DATE | NOT NULL |
| estado_cuenta | VARCHAR2(12) | CHECK ('ACTIVO','SUSPENDIDO','INACTIVO') |
| fecha_ultimo_pago | DATE | |

### PERFIL
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| perfil_id | NUMBER(5) | PK |
| usuario_id | NUMBER(5) | FK -> USUARIO |
| nombre | VARCHAR2(50) | NOT NULL |
| avatar | VARCHAR2(200) | |
| tipo | VARCHAR2(10) | CHECK ('ADULTO','INFANTIL') |

### REFERIDO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| referido_id | NUMBER(5) | PK |
| usuario_referidor_id | NUMBER(5) | FK -> USUARIO |
| usuario_referido_id | NUMBER(5) | FK -> USUARIO, UNIQUE |
| beneficio | VARCHAR2(100) | |
| estado_beneficio | VARCHAR2(15) | CHECK ('PENDIENTE','APLICADO','VENCIDO') |
| fecha_referido | DATE | NOT NULL |

### REPRODUCCION
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| reproduccion_id | NUMBER(10) | PK |
| perfil_id | NUMBER(5) | FK -> PERFIL |
| contenido_id | NUMBER(5) | FK -> CONTENIDO |
| episodio_id | NUMBER(5) | FK -> EPISODIO |
| fecha_inicio | TIMESTAMP | NOT NULL |
| fecha_fin | TIMESTAMP | |
| dispositivo | VARCHAR2(20) | CHECK ('CELULAR','TABLET','TV','COMPUTADOR') |
| porcentaje_avance | NUMBER(5,2) | CHECK (0-100) |

### FAVORITO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| perfil_id | NUMBER(5) | PK, FK -> PERFIL |
| contenido_id | NUMBER(5) | PK, FK -> CONTENIDO |
| fecha_agregado | DATE | NOT NULL |

### RESENA
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| resena_id | NUMBER(10) | PK |
| perfil_id | NUMBER(5) | FK -> PERFIL |
| contenido_id | NUMBER(5) | FK -> CONTENIDO |
| calificacion | NUMBER(1) | CHECK (1-5) |
| texto | CLOB | |
| fecha_publicacion | DATE | NOT NULL |

### REPORTE
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| reporte_id | NUMBER(10) | PK |
| contenido_id | NUMBER(5) | FK -> CONTENIDO |
| perfil_id | NUMBER(5) | FK -> PERFIL |
| moderador_id | NUMBER(5) | FK -> EMPLEADO |
| motivo | VARCHAR2(500) | NOT NULL |
| estado | VARCHAR2(20) | CHECK ('PENDIENTE','EN_REVISION','APROBADO','RECHAZADO') |
| fecha_reporte | DATE | NOT NULL |
| fecha_resolucion | DATE | |

### FACTURA
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| factura_id | NUMBER(10) | PK |
| usuario_id | NUMBER(5) | FK -> USUARIO |
| periodo | VARCHAR2(7) | NOT NULL |
| monto_total | NUMBER(10,2) | NOT NULL |
| estado_factura | VARCHAR2(15) | CHECK ('PENDIENTE','PAGADA','VENCIDA','ANULADA') |
| fecha_emision | DATE | NOT NULL |
| fecha_vencimiento | DATE | NOT NULL |

### PAGO
| Atributo | Tipo | Restricciones |
|----------|------|---------------|
| pago_id | NUMBER(10) | PK |
| factura_id | NUMBER(10) | FK -> FACTURA |
| fecha_pago | DATE | NOT NULL |
| monto_pagado | NUMBER(10,2) | NOT NULL |
| metodo_pago | VARCHAR2(20) | CHECK ('TCREDITO','TDEBITO','PSE','NEQUI','DAVIPLATA') |
| estado_pago | VARCHAR2(15) | CHECK ('EXITOSO','FALLIDO','PENDIENTE','REEMBOLSADO') |
| referencia | VARCHAR2(100) | |

## 3. Relaciones clave

1. `PLAN` 1:N `USUARIO`
2. `USUARIO` 1:N `PERFIL`
3. `USUARIO` 1:N `FACTURA`
4. `FACTURA` 1:N `PAGO`
5. `CATEGORIA` 1:N `CONTENIDO`
6. `CONTENIDO` N:M `GENERO` mediante `CONTENIDO_GENERO`
7. `CONTENIDO` N:M `CONTENIDO` mediante `CONTENIDO_RELACIONADO`
8. `CONTENIDO` 1:N `TEMPORADA`
9. `TEMPORADA` 1:N `EPISODIO`
10. `PERFIL` 1:N `REPRODUCCION`, `RESENA` y `REPORTE`
11. `PERFIL` N:M `CONTENIDO` mediante `FAVORITO`
12. `EMPLEADO` 1:N `CONTENIDO` como responsable
13. `EMPLEADO` 1:N `REPORTE` como moderador
14. `DEPARTAMENTO` 1:N `EMPLEADO`
15. `EMPLEADO` 1:N `EMPLEADO` como relacion de supervision

## 4. Observaciones del modelo

1. El modelo se mantiene normalizado hasta 3FN separando informacion operativa, administrativa y financiera.
2. Las relaciones muchos a muchos se resuelven mediante tablas asociativas.
3. La parte financiera queda mejor representada al separar `FACTURA` de `PAGO`.
4. Los atributos de control de `USUARIO` ayudan a soportar reglas de suspension, mora y reactivacion.
