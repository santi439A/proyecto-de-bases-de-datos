# Guia de ejecucion - Punto 3

## Objetivo

Esta guia explica el orden en que se deben ejecutar los scripts del punto 3 en SQL Developer y que evidencias conviene capturar para incluir en el documento del proyecto.

## Archivos a utilizar

1. `01_CREACION_TABLESPACES_TABLAS.sql`
2. `02_CARGA_DATOS_PRUEBA.sql`
3. `03_VALIDACION_PUNTO3.sql`

## Recomendaciones antes de ejecutar

1. Verificar que el usuario con el que se va a trabajar tenga privilegios para crear tablespaces, tablas, secuencias e indices.
2. Revisar si Oracle necesita ruta completa para los datafiles. Si es asi, se debe ajustar en `01_CREACION_TABLESPACES_TABLAS.sql`.
3. Ejecutar los scripts en una conexion limpia para evitar errores por objetos ya existentes.

## Paso a paso en SQL Developer

### Paso 1. Crear tablespaces, tablas, secuencias e indices

Ejecutar el archivo `01_CREACION_TABLESPACES_TABLAS.sql` con la opcion `Run Script`.

Capturas sugeridas:

1. Resultado final del script sin errores.
2. Parte del script donde se vean los `CREATE TABLESPACE`.
3. Parte del script donde se vea la creacion de la tabla `REPRODUCCION` con su particion por rango.

### Paso 2. Cargar datos de prueba

Ejecutar el archivo `02_CARGA_DATOS_PRUEBA.sql`.

Este script inserta datos suficientes para probar la estructura general del modelo. Incluye registros para tablas maestras, usuarios, perfiles, contenido, relaciones intermedias, reproducciones, reportes, facturas y pagos.

La carga fue preparada para cumplir con el criterio solicitado en el punto 3.3: minimo 25 registros por tabla y minimo 40 registros en las tablas intermedias.

Para lograr ese minimo, algunas tablas de referencia fueron ampliadas con registros de prueba adicionales. Esto no cambia la estructura del modelo, sino que permite cumplir el criterio de cantidad exigido para la validacion del esquema.

Capturas sugeridas:

1. Resultado del script al finalizar correctamente.
2. Fragmento donde se observe la insercion de datos o el `COMMIT` final.

### Paso 3. Validar el esquema de almacenamiento y la carga

Ejecutar el archivo `03_VALIDACION_PUNTO3.sql`.

Este script permite comprobar:

1. que los tablespaces fueron creados
2. que los datafiles tienen las propiedades esperadas
3. que las tablas estan creadas y asignadas al tablespace correcto
4. que la tabla `REPRODUCCION` tiene sus particiones
5. que los indices existen
6. que la base de datos fue poblada con registros de prueba

Capturas sugeridas:

1. Consulta de `DBA_TABLESPACES`.
2. Consulta de `DBA_DATA_FILES`.
3. Consulta de `USER_TABLES` mostrando nombre de tabla y tablespace.
4. Consulta de `USER_TAB_PARTITIONS` para `REPRODUCCION`.
5. Consulta de conteo por tabla.
6. Consulta de conteo para las tablas intermedias.
7. Consulta de verificacion de minimos exigidos.

## Evidencias minimas recomendadas para el documento

1. Captura del script de creacion de tablespaces y tablas ejecutado sin errores.
2. Captura de los tablespaces con su estado.
3. Captura de los datafiles con tamano inicial, autoextend y maximo.
4. Captura de la asignacion de tablas al tablespace.
5. Captura de la fragmentacion de `REPRODUCCION`.
6. Captura del conteo de registros por tabla.
7. Captura del conteo de las tablas intermedias.
8. Captura de la verificacion final de cumplimiento de minimos.

## Observacion final

Los datos cargados en `02_CARGA_DATOS_PRUEBA.sql` sirven como evidencia inicial del funcionamiento del esquema. Mas adelante se puede complementar con un script de carga masivo si el proyecto requiere ampliar la cantidad de registros para pruebas de consultas o reportes.
