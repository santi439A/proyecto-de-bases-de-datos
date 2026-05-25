# Analisis de los diagramas actuales y correccion propuesta

## Resultado del analisis

Los diagramas ubicados en `02_Diagramas/` no cumplen completamente con el contexto de `Proyecto_QuindioFlix.docx` ni con una interpretacion consistente de normalizacion hasta 3FN. Su estado actual es de **cumplimiento parcial**.

## Hallazgos principales en los diagramas actuales

1. No existe una entidad `CATEGORIA`, aunque el documento del proyecto pide reportes, datos de prueba e indices por categoria.
2. La relacion de contenido relacionado se resolvio con `contenido_relacionado_id` dentro de `CONTENIDO`, lo que no representa correctamente una relacion multiple entre contenidos.
3. El diagrama actual sugiere esa relacion como `1:1`, cuando en realidad el negocio permite multiples relaciones como secuela, precuela, remake o spin-off.
4. `PAGO` no incluye el `estado del pago`, a pesar de que el contexto exige diferenciar pagos exitosos, fallidos, pendientes y reembolsados.
5. `USUARIO` no contempla atributos necesarios para soportar la regla de desactivacion por mora, como `estado_cuenta` y `fecha_ultimo_pago`.
6. Hay inconsistencias de nombres entre documentos, por ejemplo `pantalla` frente a `num_pantallas` y `moderado_id` frente a `empleado_id` o `moderador_id`.
7. Las tablas asociativas del modelo actual no muestran de forma clara su dependencia de una clave compuesta, lo que dificulta explicar la normalizacion del modelo.

## Revision frente a las reglas de normalizacion

### 1FN

La primera forma normal exige atributos atomicos y ausencia de grupos repetitivos. El principal problema detectado es la relacion de contenido relacionado dentro de `CONTENIDO`, ya que el negocio permite multiples relaciones por contenido y eso no debe comprimirse en un solo atributo autorreferenciado.

### 2FN

La segunda forma normal exige que los atributos no clave dependan de toda la clave primaria. En las relaciones muchos a muchos, como `CONTENIDO_GENERO`, `FAVORITO` y `CONTENIDO_RELACIONADO`, es mas claro y mas correcto para fines academicos representar la dependencia sobre la combinacion completa de claves participantes.

### 3FN

La tercera forma normal exige eliminar dependencias transitivas innecesarias. Para ajustarse mejor al proyecto:

1. Se separa `CATEGORIA` de `CONTENIDO`.
2. Se incorpora `FACTURA` como entidad del ciclo financiero y `PAGO` como registro de eventos de pago asociados a una factura.
3. Se agregan atributos de control en `USUARIO` para soportar reglas de negocio posteriores.
4. Se mueve la relacion entre contenidos a una tabla propia `CONTENIDO_RELACIONADO`.

## Decision de correccion

Se generan nuevos diagramas en `02_Diagramas/correcion/`:

1. `DIAGRAMA_MER_QUINDIOFLIX_CORREGIDO.png`
2. `DIAGRAMA_LOGICO_QUINDIOFLIX_CORREGIDO.png`

Estos diagramas corrigen la estructura conceptual y relacional del proyecto para que sea mas consistente con el enunciado, con lo que ya se ha documentado y con una explicacion defendible de 3FN.
