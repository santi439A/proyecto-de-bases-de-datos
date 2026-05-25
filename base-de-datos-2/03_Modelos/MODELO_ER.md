# Modelo Entidad-Relación - Proyecto QuindioFlix

## 1. Entidades Identificadas

### CONTENIDO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| contenido_id | NUMBER | PK, NOT NULL |
| titulo | VARCHAR2(200) | NOT NULL |
| anno_lanzamiento | NUMBER(4) | NOT NULL |
| duracion | NUMBER | Minutos |
| sinopsis | CLOB | |
| clasificacion_edad | VARCHAR2(5) | NOT NULL, CHECK (TP,+7,+13,+16,+18) |
| fecha_agregado | DATE | NOT NULL |
| tipo | VARCHAR2(20) | ('PELICULA','SERIE','DOCUMENTAL','MUSICA','PODCAST') |
| es_original | NUMBER(1) | CHECK (0,1) |
| contenido_relacionado_id | NUMBER | FK (self-reference) |
| tipo_relacion | VARCHAR2(30) | ('SECUELA','PRECUELA','REMAKE','SPIN_OFF','VERSION_EXTENDIDA') |
| empleado_id | NUMBER | FK |

### GENERO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| genero_id | NUMBER | PK |
| nombre | VARCHAR2(50) | UNIQUE, NOT NULL |

### TEMPORADA
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| temporada_id | NUMBER | PK |
| numero | NUMBER | NOT NULL |
| contenido_id | NUMBER | FK -> CONTENIDO |

### EPISODIO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| episodio_id | NUMBER | PK |
| temporada_id | NUMBER | FK -> TEMPORADA |
| numero | NUMBER | NOT NULL |
| titulo | VARCHAR2(200) | NOT NULL |
| duracion | NUMBER | NOT NULL |

### USUARIO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| usuario_id | NUMBER | PK |
| nombre | VARCHAR2(100) | NOT NULL |
| email | VARCHAR2(100) | UNIQUE, NOT NULL |
| telefono | VARCHAR2(20) | |
| fecha_nacimiento | DATE | NOT NULL |
| ciudad_residencia | VARCHAR2(100) | |
| plan_id | NUMBER | FK -> PLAN |
| fecha_registro | DATE | NOT NULL |

### PLAN
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| plan_id | NUMBER | PK |
| nombre | VARCHAR2(20) | ('BASICO','ESTANDAR','PREMIUM') |
| precio | NUMBER | NOT NULL |
| pantalla | NUMBER | NOT NULL |
| calidad | VARCHAR2(10) | ('SD','HD','4K') |

### PERFIL
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| perfil_id | NUMBER | PK |
| usuario_id | NUMBER | FK -> USUARIO |
| nombre | VARCHAR2(50) | NOT NULL |
| avatar | VARCHAR2(200) | |
| tipo | VARCHAR2(10) | ('ADULTO','INFANTIL') |

### REFERIDO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| referido_id | NUMBER | PK |
| usuario_referidor_id | NUMBER | FK -> USUARIO |
| usuario_referido_id | NUMBER | FK -> USUARIO |
| beneficio | VARCHAR2(100) | |
| fecha | DATE | NOT NULL |

### REPRODUCCION
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| reproduccion_id | NUMBER | PK |
| perfil_id | NUMBER | FK -> PERFIL |
| contenido_id | NUMBER | FK -> CONTENIDO |
| episodio_id | NUMBER | FK -> EPISODIO (nullable) |
| fecha_inicio | TIMESTAMP | NOT NULL |
| fecha_fin | TIMESTAMP | |
| dispositivo | VARCHAR2(20) | ('CELULAR','TABLET','TV','COMPUTADOR') |
| porcentaje_avance | NUMBER | 0-100 |

### FAVORITO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| favorito_id | NUMBER | PK |
| perfil_id | NUMBER | FK -> PERFIL |
| contenido_id | NUMBER | FK -> CONTENIDO |
| fecha_agregado | DATE | NOT NULL |

### RESENA
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| resena_id | NUMBER | PK |
| perfil_id | NUMBER | FK -> PERFIL |
| contenido_id | NUMBER | FK -> CONTENIDO |
| calificacion | NUMBER | 1-5, NOT NULL |
| texto | CLOB | |
| fecha_publicacion | DATE | NOT NULL |

### REPORTE
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| reporte_id | NUMBER | PK |
| contenido_id | NUMBER | FK -> CONTENIDO |
| perfil_id | NUMBER | FK -> PERFIL |
| motivo | VARCHAR2(500) | NOT NULL |
| estado | VARCHAR2(20) | ('PENDIENTE','REVISADO','APROBADO','RECHAZADO') |
| moderado_id | NUMBER | FK -> EMPLEADO |
| fecha_reporte | DATE | NOT NULL |
| fecha_resolucion | DATE | |

### EMPLEADO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| empleado_id | NUMBER | PK |
| nombre | VARCHAR2(100) | NOT NULL |
| email | VARCHAR2(100) | UNIQUE |
| telefono | VARCHAR2(20) | |
| departamento_id | NUMBER | FK -> DEPARTAMENTO |
| supervisor_id | NUMBER | FK -> EMPLEADO |
| cargo | VARCHAR2(50) | |

### DEPARTAMENTO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| departamento_id | NUMBER | PK |
| nombre | VARCHAR2(50) | UNIQUE |
| jefe_id | NUMBER | FK -> EMPLEADO |

### PAGO
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| pago_id | NUMBER | PK |
| usuario_id | NUMBER | FK -> USUARIO |
| monto | NUMBER | NOT NULL |
| fecha_pago | DATE | NOT NULL |
| metodo | VARCHAR2(30) | |
| referencia | VARCHAR2(100) | |

### FACTURA
| Atributo | Tipo | Restricciones |
|----------|------|----------------|
| factura_id | NUMBER | PK |
| usuario_id | NUMBER | FK -> USUARIO |
| periodo | VARCHAR2(10) | ('YYYY-MM') |
| monto_total | NUMBER | NOT NULL |
| estado | VARCHAR2(20) | ('PENDIENTE','PAGADA','VENCIDA') |
| fecha_emision | DATE | NOT NULL |
| fecha_vencimiento | DATE | NOT NULL |

## 2. Relaciones

| Relación | Entidad A | Entidad B | Cardinalidad |
|----------|----------|----------|-------------|
| tiene | CONTENIDO | GENERO | N:M |
| tiene | CONTENIDO | TEMPORADA | 1:N |
| tiene | TEMPORADA | EPISODIO | 1:N |
| tiene | CONTENIDO | CONTENIDO (relacionado) | N:M (self) |
| ofrece | PLAN | - | Entidad débil |
| tiene | USUARIO | PERFIL | 1:N |
| suscrita | USUARIO | PLAN | N:1 |
| tiene | USUARIO | REFERIDO | N:M |
| registra | PERFIL | REPRODUCCION | 1:N |
| belonging | PERFIL | FAVORITO | 1:N |
| escribe | PERFIL | RESENA | 1:N |
| reporta | PERFIL | REPORTE | 1:N |
| resuelve | EMPLEADO | REPORTE | 1:N |
| trabaja | EMPLEADO | DEPARTAMENTO | N:1 |
| supervisa | EMPLEADO | EMPLEADO | 1:N (self) |
| jefe | DEPARTAMENTO | EMPLEADO | 1:1 |
| responsable | EMPLEADO | CONTENIDO | 1:N |
| genera | USUARIO | PAGO | 1:N |

## 3. Reglas de Negocio

1. **Perfiles infantiles**: Solo pueden acceder contenido con clasificación TP, +7 o +13
2. **Planes**: Básico=1 pantalla, Estándar=2 pantallas, Premium=4 pantallas
3. **Reproducciones**: Registrar inicio, fin, dispositivo y porcentaje de avance
4. **Referidos**:both usuarios recebem benefício when referrado registra
5. **Reportes**: Deben ser revisados por un moderador (empleado con rol especial)
6. **Empleados**: Cada departamento tiene un jefe, hay jerarquía de supervisión

## 4. Notas de Diseño

- Las entidades TEMPORADA y EPISODIO solo aplican para series y podcasts
- La relación contenido-relacionado es auto-referencial para sequel/prequel/etc.
- La clasificación de edad sigue normativa colombiana
- Los empleados de Contenido gestionan el catálogo
- Los empleados de Soporte atienden reportes