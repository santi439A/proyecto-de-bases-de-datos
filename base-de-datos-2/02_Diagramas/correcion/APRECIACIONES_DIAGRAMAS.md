# Apreciaciones breves para entender los diagramas corregidos

1. `CATEGORIA` se separa de `CONTENIDO` porque el proyecto exige consultas, datos de prueba e indices por categoria; por eso no se deja solo como un valor textual dentro del contenido.
2. `CONTENIDO_RELACIONADO` modela una relacion reflexiva N:M. Esto permite que un contenido tenga varias secuelas, precuelas o spin-off sin romper la primera forma normal.
3. `PLAN` incluye `max_perfiles` ademas de `num_pantallas`, porque el proyecto maneja reglas de negocio distintas para simultaneidad y cantidad de perfiles.
4. `USUARIO` incluye `estado_cuenta` y `fecha_ultimo_pago` para soportar reglas de mora, activacion de cuenta y triggers posteriores.
5. `PAGO` se relaciona con `FACTURA` para separar el documento de cobro del evento de pago, lo que mejora la trazabilidad financiera.
6. El moderador del reporte se representa como `EMPLEADO` del area de soporte. En el modelo se nombra `moderador_id` para que la funcion dentro del proceso quede clara.
7. Las tablas asociativas `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO` y `FAVORITO` usan claves compuestas para que la dependencia funcional sea evidente y el modelo sea mas facil de justificar en 3FN.
