# Analisis de los modelos actuales

## Resultado general

Los archivos actuales de `03_Modelos/` no reflejan de forma completa el modelo que se adopto en el proyecto. Su nivel de cumplimiento es parcial, ya que conservan varias decisiones del esquema anterior y presentan diferencias frente al diagrama MER final y al diagrama logico relacional de referencia.

## Principales diferencias encontradas

1. No incluyen la entidad `CATEGORIA`.
2. Mantienen `tipo`, `contenido_relacionado_id` y `tipo_relacion` dentro de `CONTENIDO`, en lugar de usar la tabla `CONTENIDO_RELACIONADO`.
3. `PLAN` aun no contempla `max_perfiles`.
4. `USUARIO` no incluye `estado_cuenta` ni `fecha_ultimo_pago`.
5. `REFERIDO` no incluye `estado_beneficio`.
6. `REPORTE` usa nombres distintos para el responsable de moderacion.
7. `PAGO` sigue relacionado directamente con `USUARIO`, cuando en el modelo adoptado se relaciona con `FACTURA`.
8. Las tablas asociativas todavia aparecen con llaves artificiales en varios casos, mientras que el modelo final usa claves compuestas en `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO` y `FAVORITO`.

## Decision tomada

Se generan versiones corregidas en este directorio para dejar la documentacion del modelo alineada con los diagramas finales y con la estructura adoptada para el resto del proyecto.
