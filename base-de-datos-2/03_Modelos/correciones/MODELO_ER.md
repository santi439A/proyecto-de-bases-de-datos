# Modelo Entidad-Relacion - QuindioFlix

## 1. Entidades del modelo

### PLAN
| Atributo       | Descripcion                          | Restricciones    |
|----------------|--------------------------------------|---------------   |
| plan_id        | Identificador del plan               | PK               |
| nombre         | Nombre del plan                      | UNIQUE, NOT NULL |
| precio_mensual | Valor mensual de la suscripcion      | NOT NULL         |
| num_pantallas  | Numero de pantallas simultaneas      | NOT NULL         |
| max_perfiles   | Numero maximo de perfiles por cuenta | NOT NULL         |
| calidad        | Calidad de reproduccion              | NOT NULL         |

### CATEGORIA
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| categoria_id | Identificador de la categoria | PK |
| nombre | Nombre de la categoria | UNIQUE, NOT NULL |

### GENERO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| genero_id | Identificador del genero | PK |
| nombre | Nombre del genero | UNIQUE, NOT NULL |

### DEPARTAMENTO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| departamento_id | Identificador del departamento | PK |
| nombre | Nombre del departamento | UNIQUE, NOT NULL |
| jefe_id | Empleado que lidera el departamento | FK |

### EMPLEADO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| empleado_id | Identificador del empleado | PK |
| nombre | Nombre del empleado | NOT NULL |
| email | Correo institucional | UNIQUE, NOT NULL |
| telefono | Telefono de contacto | |
| cargo | Cargo desempenado | NOT NULL |
| departamento_id | Departamento al que pertenece | FK |
| supervisor_id | Supervisor directo | FK |

### CONTENIDO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| contenido_id | Identificador del contenido | PK |
| categoria_id | Categoria principal del contenido | FK |
| titulo | Titulo del contenido | NOT NULL |
| anno_lanzamiento | Anio de lanzamiento | NOT NULL |
| duracion_minutos | Duracion en minutos | |
| sinopsis | Descripcion general | |
| clasificacion_edad | Clasificacion por edad | NOT NULL |
| fecha_agregado | Fecha de ingreso al catalogo | NOT NULL |
| es_original | Indica si es produccion propia | |
| empleado_responsable_id | Responsable de publicacion | FK |

### CONTENIDO_GENERO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| contenido_id | Contenido asociado | PK, FK |
| genero_id | Genero asociado | PK, FK |

### CONTENIDO_RELACIONADO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| contenido_origen_id | Contenido base | PK, FK |
| contenido_relacionado_id | Contenido vinculado | PK, FK |
| tipo_relacion | Tipo de relacion entre contenidos | NOT NULL |

### TEMPORADA
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| temporada_id | Identificador de la temporada | PK |
| contenido_id | Contenido al que pertenece | FK |
| numero | Numero de la temporada | NOT NULL |

### EPISODIO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| episodio_id | Identificador del episodio | PK |
| temporada_id | Temporada a la que pertenece | FK |
| numero | Numero del episodio | NOT NULL |
| titulo | Titulo del episodio | NOT NULL |
| duracion_minutos | Duracion del episodio | NOT NULL |

### USUARIO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| usuario_id | Identificador del usuario | PK |
| nombre | Nombre del usuario | NOT NULL |
| email | Correo del usuario | UNIQUE, NOT NULL |
| telefono | Telefono de contacto | |
| fecha_nacimiento | Fecha de nacimiento | NOT NULL |
| ciudad_residencia | Ciudad de residencia | NOT NULL |
| plan_id | Plan de suscripcion asociado | FK |
| fecha_registro | Fecha de creacion de la cuenta | NOT NULL |
| estado_cuenta | Estado actual de la cuenta | |
| fecha_ultimo_pago | Fecha del ultimo pago valido | |

### PERFIL
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| perfil_id | Identificador del perfil | PK |
| usuario_id | Cuenta a la que pertenece | FK |
| nombre | Nombre del perfil | NOT NULL |
| avatar | Imagen o referencia del avatar | |
| tipo | Tipo de perfil | NOT NULL |

### REFERIDO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| referido_id | Identificador del registro de referido | PK |
| usuario_referidor_id | Usuario que invita | FK |
| usuario_referido_id | Usuario invitado | FK |
| beneficio | Beneficio asignado | |
| estado_beneficio | Estado del beneficio | |
| fecha_referido | Fecha del registro del referido | NOT NULL |

### REPRODUCCION
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| reproduccion_id | Identificador de la reproduccion | PK |
| perfil_id | Perfil que reproduce | FK |
| contenido_id | Contenido reproducido | FK |
| episodio_id | Episodio reproducido cuando aplica | FK |
| fecha_inicio | Inicio de la reproduccion | NOT NULL |
| fecha_fin | Fin de la reproduccion | |
| dispositivo | Dispositivo utilizado | |
| porcentaje_avance | Porcentaje reproducido | |

### FAVORITO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| perfil_id | Perfil asociado | PK, FK |
| contenido_id | Contenido marcado | PK, FK |
| fecha_agregado | Fecha de adicion a favoritos | NOT NULL |

### RESENA
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| resena_id | Identificador de la resena | PK |
| perfil_id | Perfil autor | FK |
| contenido_id | Contenido resenado | FK |
| calificacion | Puntaje asignado | NOT NULL |
| texto | Comentario del usuario | |
| fecha_publicacion | Fecha de publicacion | NOT NULL |

### REPORTE
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| reporte_id | Identificador del reporte | PK |
| contenido_id | Contenido reportado | FK |
| perfil_id | Perfil que reporta | FK |
| moderador_id | Empleado que revisa el caso | FK |
| motivo | Motivo del reporte | NOT NULL |
| estado | Estado del reporte | |
| fecha_reporte | Fecha de creacion | NOT NULL |
| fecha_resolucion | Fecha de cierre | |

### FACTURA
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| factura_id | Identificador de la factura | PK |
| usuario_id | Usuario facturado | FK |
| periodo | Periodo de facturacion | NOT NULL |
| monto_total | Valor total del cobro | NOT NULL |
| estado_factura | Estado de la factura | |
| fecha_emision | Fecha de emision | NOT NULL |
| fecha_vencimiento | Fecha de vencimiento | NOT NULL |

### PAGO
| Atributo | Descripcion | Restricciones |
|----------|-------------|---------------|
| pago_id | Identificador del pago | PK |
| factura_id | Factura asociada | FK |
| fecha_pago | Fecha del intento o pago realizado | NOT NULL |
| monto_pagado | Valor pagado | NOT NULL |
| metodo_pago | Medio de pago utilizado | |
| estado_pago | Estado del pago | |
| referencia | Codigo o referencia externa | |

## 2. Relaciones principales

1. Un `PLAN` puede estar asociado a muchos `USUARIO`.
2. Una `CATEGORIA` puede clasificar muchos `CONTENIDO`.
3. Un `CONTENIDO` puede pertenecer a muchos `GENERO`, y un genero puede clasificar muchos contenidos; esta relacion se resuelve con `CONTENIDO_GENERO`.
4. Un `CONTENIDO` puede relacionarse con otros contenidos mediante `CONTENIDO_RELACIONADO`.
5. Un `CONTENIDO` puede tener muchas `TEMPORADA`, y cada temporada puede tener muchos `EPISODIO`.
6. Un `USUARIO` puede tener muchos `PERFIL`.
7. Un `PERFIL` puede generar muchas `REPRODUCCION`, `RESENA`, `REPORTE` y marcar muchos `FAVORITO`.
8. Un `USUARIO` puede participar en relaciones de `REFERIDO` tanto como referidor como referido.
9. Un `EMPLEADO` pertenece a un `DEPARTAMENTO` y puede supervisar a otros empleados.
10. Un `EMPLEADO` puede ser responsable de muchos contenidos y tambien atender reportes como moderador.
11. Un `USUARIO` puede tener muchas `FACTURA`.
12. Una `FACTURA` puede tener uno o varios `PAGO` asociados.

## 3. Notas de diseno

1. `CATEGORIA` se separa de `CONTENIDO` para facilitar consultas y reportes por tipo general de contenido.
2. `CONTENIDO_RELACIONADO` evita limitar el catalogo a una sola relacion entre contenidos.
3. `PLAN` diferencia `num_pantallas` de `max_perfiles` porque representan reglas distintas del negocio.
4. `USUARIO` incluye atributos de control para soportar reglas de mora y suspension.
5. `FACTURA` y `PAGO` se manejan como entidades separadas para reflejar mejor el proceso financiero.
