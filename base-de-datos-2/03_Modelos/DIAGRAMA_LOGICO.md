# DIAGRAMA LÓGICO RELACIONAL - QUINDIOFLIX

## Esquema de Relaciones

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      TABLAS MAESTRAS                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────┐     ┌──────────────────┐     ┌──────────┐ │
│  │      PLAN        │     │     GENERO       │     │ DEPART   │ │
│  ├──────────────────┤     ├──────────────────┤     ├──────────┤ │
│  │ PK plan_id       │     │ PK genero_id     │     │PK dep_id │ │
│  │    nombre        │     │    nombre        │     │  nombre  │ │
│  │    precio        │     └──────────────────┘     │FK jefe_id│ │
│  │    pantallas     │                              └──────────┘ │
│  │    calidad       │                              │            │
│  └──────────────   ─┘                              │            │
│      │                                           │            │
│      │FK                                         │            │
└──────┼────────────────────────────────────────────┼────────────┘
       │
       │ 1:N (suscribe)
          ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        TABLAS DE USUARIOS                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌────────────────────────────┐     ┌─────────────────────┐          │
│  │        USUARIO           │     │       PERFIL         │          │
│  ├────────────────────────┤     ├─────────────────────┤          │
│  │ PK usuario_id          │     │ PK perfil_id       │          │
│  │    nombre             │     │ FK usuario_id ─────┼──┐       │
│  │    email (UNIQUE)     │     │    nombre         │  │       │
│  │    telefono           │     │    avatar         │  │       │
│  │    fecha_nacimiento  │     │    tipo           │  │       │
│  │    ciudad_residencia│     └─────────────────────┘  │       │
│  │ FK plan_id ───��──────┼──────────────────────────────┘       │
│  │    fecha_registro    │                                        │
│  └─────────────────────┘                                        │
│       │                                                        │
│       │ 1:N (tiene), 1:N (genera), 1:N (recibe)               │
│       ▼                                                        │
│  ┌──────────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │     PERFIL       │  │    PAGO     │  │    FACTURA       │  │
│  ├──────────────────┤  ├────────────┤  ├──────────────────┤  │
│  │ PK perfil_id     │  │ PK pago_id  │  │ PK factura_id   │  │
│  │ FK usuario_id ───┼──│FK user_id  │  │ FK user_id ─────┼──┤  │
│  │    nombre       │  │    monto   │  │    periodo    │  │  │
│  │    avatar      │  │  fecha_pago│  │  monto_total  │  │  │
│  │    tipo        │  │ metodo_pago│  │    estado   │  │  │
│  └────────────────┘  │ referencia│  │ fch_emision  │  │  │
│       │             │ └───────────┘  │ fch_vencim  │  │  │
│       │                           └──────────────────┘  │  │
│       │ 1:N                                            │  │
│       ▼                                                │  │
│  ┌──────────────────┐  ┌──────────────┐                │  │
│  │   REPRODUCCION   │  │  FAVORITO    │                │  │
│  ├──────────────────┤  ├─────────────┤                │  │
│  │ PK reprod_id     │  │ PK fav_id    │                │  │
│  │ FK perfil_id ─────┼──│FK perfil_id │                │  │
│  │ FK contenido_id  │  │FK conten_id│                │  │
│  │ FK episodio_id │  │  fch_agreg │                │  │
│  │  fecha_inicio │  └────────────┘                │  │
│  │  fecha_fin    │                                 │  │
│  │ dispositivo  │                                 │  │
│  │  porcentaje  │                                 │  │
│  └──────────────────┘                                 │
│       │                                                 │
│       │ 1:N                                             │
│       ▼                                                 │
│  ┌──────────────────┐  ┌──────────────┐  ┌──────────────────┐
│  │    RESENA        │  │   REPORTE    │  │   REFERIDO      │
│  ├──────────────────┤  ├─────────────┤  ├──────────────────┤
│  │ PK resena_id     │  │ PK reporte_ │  │ PK referido_id
│  │ FK perfil_id ───┼──│FK perfil_id │  │ FK user_refd
│  │ FK contenido_id │  │FK contenido│  │ FK user_refdo
│  │  calificacion  │  │   motivo   │  │   beneficio
│  │    texto      │  │   estado   │  │    fecha
│  │  fch_public  │  │FK mod_id  │  └─────────────────���┘
│  └──────────────────┘  │ fch_report │
│                       │ fch_resol │
│                       └──────────┘
└─────────────────────────────────────────────────────────────────┘
       │
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                      TABLAS DE CONTENIDO                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────┐     ┌─────────────────┐          │
│  │      CONTENIDO       │     │    GENERO       │          │
│  ├──────────────────────┤     ├─────────────────┤          │
│  │ PK contenido_id     │     │ PK genero_id    │          │
│  │    titulo           │     │    nombre      │          │
│  │  anno_lanzamiento  │     └─────────────────┘          │
│  │    duracion        │            │                        │
│  │    sinopsis       │            │ N:M                   │
│  │ clasificacion_edad│◄──────────┼──────────┐           │
│  │  fecha_agregado   │           │         │            │
│  │    tipo          │           ▼         │            │
│  │  es_original    │    ┌───────────────┐  │            │
│  │FK conten_relac  │    │CONTENIDO_GENERO│  │            │
│  │  tipo_relacion  │    ├───────────────┤  │            │
│  │FK empleado_id  │    │PK cont_gen_id │  │            │
│  └─────────────────┘    │FK contenido_id│──┘            │
│       │                 │FK genero_id  │                 │
│       │ 1:N            └───────────────┘                 │
│       │                                               │
│       │ 1:1 (self)                                   │
│       ▼                                               │
│  ┌──────────────────┐     ┌─────────────────────┐      │
│  │ CONTENIDO        │     │    TEMPORADA        │      │
│  │ (relacionado)    │     ├─────────────────────┤      │
│  └──────────────────┘     │ PK temporada_id    │      │
│          │                 │ FK contenido_id   │◄─────┤  │
│          │                 │    numero       │      │  │
│          │                 └───────────────────┘      │  │
│          │                       │                 │  │
│          │                       │ 1:N           │  │
│          │                       ▼                 │  │
│          │                 ┌───────────────┐      │  │
│          │                 │  EPISODIO    │      │  │
│          │                 ├───────────────┤      │  │
│          │                 │PK episodio_id│      │  │
│          │                 │FK temporada │──────┘  │
│          │                 │  numero    │         │
│          │                 │  titulo    │         │
│          │                 │ duracion  │         │
│          │                 └──────────┘         │
│          │                                        │
│          │ 1:N (gestiona)                        │
│          ▼                                        │
│  ┌──────────────────┐     ┌─────────────────────┐
│  │    EMPLEADO       │     │    REPORTE (resuelve)│
│  ├──────────────────┤     ├─────────────────────┤
│  │ PK empleado_id   │     │ PK reporte_id
│  │    nombre       │     │ FK contenido_id
│  │    email (UNIQUE)│     │ FK perfil_id
│  │    telefono     │     │   motivo
│  │FK departamento│     │   estado
│  │FK supervisor  │     │FK empleado_id
│  │    cargo      │     │  fch_reporte
│  └────────────────┘     │  fch_resolución
│       │                └─────────────────────┘
│       │                                 
│       │ N:1 (trabaja en)              
│       ▼                                 
│  ┌──────────────────┐                   
│  │  DEPARTAMENTO    │                   
│  ├──────────────────┤                   
│  │ PK departamento│                   
│  │    nombre    │                   
│  │FK jefe_id    │                   
│  └─────────────┘                   
│       │                                 
│       │ 1:1 (jefe)              
│       ▼                                 
│  ┌──────────────────┐                   
│  │    EMPLEADO    │                   
│  │    (jefe)     │                   
│  ├──────────────────┤                   
│  │ PK empleado_id │                   
│  └───────────────┘                   
└────────────────────────────────────────────────────────────
```

## Leyenda

| Símbolo | Significado |
|---------|------------|
| PK | Primary Key (Llave Primaria) |
| FK | Foreign Key (Llave Foránea) |
| UNIQUE | Valor ÚNICO |
| N:M | Relación Muchos a Muchos |
| 1:N | Relación Uno a Muchos |
| 1:1 | Relación Uno a Uno |

## Tablas del Modelo

### 1. PLAN (Entidad Maestra)
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| plan_id | NUMBER(2) | PK |
| nombre | VARCHAR2(20) | NOT NULL, UNIQUE |
| precio | NUMBER(10,2) | NOT NULL |
| num_pantallas | NUMBER(1) | NOT NULL |
| calidad | VARCHAR2(10) | NOT NULL, CHECK (SD,HD,4K) |

### 2. GENERO (Entidad Maestra)
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| genero_id | NUMBER(3) | PK |
| nombre | VARCHAR2(50) | NOT NULL, UNIQUE |

### 3. DEPARTAMENTO (Entidad Maestra)
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| departamento_id | NUMBER(3) | PK |
| nombre | VARCHAR2(50) | NOT NULL, UNIQUE |
| jefe_id | NUMBER(5) | FK → EMPLEADO |

### 4. EMPLEADO
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| empleado_id | NUMBER(5) | PK |
| nombre | VARCHAR2(100) | NOT NULL |
| email | VARCHAR2(100) | NOT NULL, UNIQUE |
| telefono | VARCHAR2(20) | - |
| departamento_id | NUMBER(3) | FK → DEPARTAMENTO |
| supervisor_id | NUMBER(5) | FK → EMPLEADO (self) |
| cargo | VARCHAR2(50) | - |

### 5. CONTENIDO
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| contenido_id | NUMBER(5) | PK |
| titulo | VARCHAR2(200) | NOT NULL |
| anno_lanzamiento | NUMBER(4) | NOT NULL |
| duracion | NUMBER(5) | - |
| sinopsis | CLOB | - |
| clasificacion_edad | VARCHAR2(5) | NOT NULL, CHECK |
| fecha_agregado | DATE | NOT NULL |
| tipo | VARCHAR2(20) | NOT NULL, CHECK |
| es_original | NUMBER(1) | CHECK (0,1) |
| contenido_relacionado_id | NUMBER(5) | FK → CONTENIDO (self) |
| tipo_relacion | VARCHAR2(30) | - |
| empleado_id | NUMBER(5) | FK → EMPLEADO |

### 6. CONTENIDO_GENERO (Tabla asociativa N:M)
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| contenido_genero_id | NUMBER(5) | PK |
| contenido_id | NUMBER(5) | FK → CONTENIDO |
| genero_id | NUMBER(3) | FK → GENERO |

### 7. TEMPORADA
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| temporada_id | NUMBER(5) | PK |
| contenido_id | NUMBER(5) | FK → CONTENIDO |
| numero | NUMBER(2) | NOT NULL |

### 8. EPISODIO
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| episodio_id | NUMBER(5) | PK |
| temporada_id | NUMBER(5) | FK → TEMPORADA |
| numero | NUMBER(3) | NOT NULL |
| titulo | VARCHAR2(200) | NOT NULL |
| duracion | NUMBER(5) | NOT NULL |

### 9. USUARIO
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| usuario_id | NUMBER(5) | PK |
| nombre | VARCHAR2(100) | NOT NULL |
| email | VARCHAR2(100) | NOT NULL, UNIQUE |
| telefono | VARCHAR2(20) | - |
| fecha_nacimiento | DATE | NOT NULL |
| ciudad_residencia | VARCHAR2(100) | - |
| plan_id | NUMBER(2) | FK → PLAN |
| fecha_registro | DATE | NOT NULL |

### 10. PERFIL
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| perfil_id | NUMBER(5) | PK |
| usuario_id | NUMBER(5) | FK → USUARIO |
| nombre | VARCHAR2(50) | NOT NULL |
| avatar | VARCHAR2(200) | - |
| tipo | VARCHAR2(10) | NOT NULL, CHECK |

### 11. REFERIDO
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| referido_id | NUMBER(5) | PK |
| usuario_referidor_id | NUMBER(5) | FK → USUARIO |
| usuario_referido_id | NUMBER(5) | FK → USUARIO |
| beneficio | VARCHAR2(100) | - |
| fecha | DATE | NOT NULL |

### 12. REPRODUCCION
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| reproduccion_id | NUMBER(10) | PK |
| perfil_id | NUMBER(5) | FK → PERFIL |
| contenido_id | NUMBER(5) | FK → CONTENIDO |
| episodio_id | NUMBER(5) | FK → EPISODIO |
| fecha_inicio | TIMESTAMP | NOT NULL |
| fecha_fin | TIMESTAMP | - |
| dispositivo | VARCHAR2(20) | NOT NULL, CHECK |
| porcentaje_avance | NUMBER(5,2) | DEFAULT 0, CHECK 0-100 |

### 13. FAVORITO
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| favorito_id | NUMBER(10) | PK |
| perfil_id | NUMBER(5) | FK → PERFIL |
| contenido_id | NUMBER(5) | FK → CONTENIDO |
| fecha_agregado | DATE | NOT NULL |

### 14. RESENA
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| resena_id | NUMBER(10) | PK |
| perfil_id | NUMBER(5) | FK → PERFIL |
| contenido_id | NUMBER(5) | FK → CONTENIDO |
| calificacion | NUMBER(1) | NOT NULL, CHECK 1-5 |
| texto | CLOB | - |
| fecha_publicacion | DATE | NOT NULL |

### 15. REPORTE
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| reporte_id | NUMBER(10) | PK |
| contenido_id | NUMBER(5) | FK → CONTENIDO |
| perfil_id | NUMBER(5) | FK → PERFIL |
| motivo | VARCHAR2(500) | NOT NULL |
| estado | VARCHAR2(20) | DEFAULT PENDIENTE |
| empleado_id | NUMBER(5) | FK → EMPLEADO |
| fecha_reporte | DATE | NOT NULL |
| fecha_resolucion | DATE | - |

### 16. PAGO
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| pago_id | NUMBER(10) | PK |
| usuario_id | NUMBER(5) | FK → USUARIO |
| monto | NUMBER(10,2) | NOT NULL |
| fecha_pago | DATE | NOT NULL |
| metodo_pago | VARCHAR2(30) | - |
| referencia | VARCHAR2(100) | - |

### 17. FACTURA
| Atributo | Tipo | Restricciones |
|----------|------|--------------|
| factura_id | NUMBER(10) | PK |
| usuario_id | NUMBER(5) | FK → USUARIO |
| periodo | VARCHAR2(7) | NOT NULL |
| monto_total | NUMBER(10,2) | NOT NULL |
| estado | VARCHAR2(20) | DEFAULT PENDIENTE |
| fecha_emision | DATE | NOT NULL |
| fecha_vencimiento | DATE | NOT NULL |
