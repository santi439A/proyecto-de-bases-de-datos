# Esquema de almacenamiento - QuindioFlix

## 3.1 Asignacion de tablas a tablespace

Para el proyecto se plantea la creacion de dos tablespaces principales: `ts_quindioflix_data` y `ts_quindioflix_indx`. La idea de esta separacion es distribuir la informacion segun su funcion dentro de la base de datos. Por un lado, se deja un espacio para almacenar las tablas y, por otro, un espacio para las estructuras de acceso.

### ts_quindioflix_data

- Datafile: `quindioflix_data01.dbf`
- Estado: `ONLINE`
- Tamano inicial: `100 MB`
- Autoextend: `50 MB`
- Tamano maximo: `500 MB`

Justificacion:

Este tablespace se crea para almacenar la informacion operativa del sistema. Se le asigna un tamano inicial mayor porque aqui quedan ubicadas las tablas del modelo y, especialmente, las que mas crecimiento pueden tener con el uso del sistema, como `REPRODUCCION`.

Tablas asignadas:

`PLAN`, `CATEGORIA`, `GENERO`, `DEPARTAMENTO`, `EMPLEADO`, `CONTENIDO`, `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO`, `TEMPORADA`, `EPISODIO`, `USUARIO`, `PERFIL`, `REFERIDO`, `REPRODUCCION`, `FAVORITO`, `RESENA`, `REPORTE`, `FACTURA`, `PAGO`.

### ts_quindioflix_indx

- Datafile: `quindioflix_indx01.dbf`
- Estado: `ONLINE`
- Tamano inicial: `50 MB`
- Autoextend: `25 MB`
- Tamano maximo: `200 MB`

Justificacion:

Este tablespace se crea para almacenar los indices del sistema. Su separacion respecto al tablespace de datos permite organizar mejor el almacenamiento, facilitar mantenimiento y optimizar el acceso a las columnas mas consultadas.

Estructuras asignadas:

Indices sobre contenido, usuario, perfil, reproduccion, resena, reporte, pago y factura.

## 3.2 Script de creacion de tablas y tablespace

El soporte fisico principal de este punto se encuentra en `04_Scripts_SQL/correciones/01_CREACION_TABLESPACES_TABLAS.sql`. En este script se plantea la creacion de los tablespaces con sus respectivos datafiles, la creacion de las tablas del sistema y la asignacion de dichas tablas al tablespace `ts_quindioflix_data`.

Ademas de la asignacion de tablespaces, el script contempla propiedades fisicas y logicas importantes para el modelo, por ejemplo:

1. llaves primarias y llaves foraneas para mantener integridad referencial
2. restricciones `UNIQUE` en atributos como correos y nombres de catalogos base
3. restricciones `CHECK` para controlar valores permitidos
4. secuencias para manejo de identificadores
5. indices almacenados en `ts_quindioflix_indx`
6. particion por rango en la tabla `REPRODUCCION`

La tabla `REPRODUCCION` se fragmenta por rango sobre `fecha_inicio`, con las particiones `p2025`, `p2026` y `p_max`, debido a que es la tabla con mayor crecimiento esperado dentro del sistema.

## 3.3 Prueba del modelo

Para la prueba del modelo se debe poblar la base de datos con suficientes registros que permitan validar tanto la estructura como las restricciones. Como criterio minimo de carga se propone registrar al menos 25 datos por cada tabla principal y 40 registros en cada tabla intermedia. Este criterio ya se tuvo en cuenta en el script `02_CARGA_DATOS_PRUEBA.sql`.

En este caso, las tablas intermedias o asociativas que deben recibir una carga suficiente son `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO` y `FAVORITO`. Ademas, la tabla `REPRODUCCION` debe poblarse con fechas distribuidas en distintos periodos para comprobar que la fragmentacion por rango funcione correctamente.

La informacion de prueba no debe ser uniforme. Es importante que existan usuarios en varias ciudades, planes diferentes, contenido variado y movimientos financieros diversos, para que posteriormente las consultas y reportes del proyecto generen resultados utiles y realistas.

El script de carga inicial para estas pruebas se encuentra en `04_Scripts_SQL/correciones/02_CARGA_DATOS_PRUEBA.sql`, mientras que las consultas de validacion se dejaron en `04_Scripts_SQL/correciones/03_VALIDACION_PUNTO3.sql`.

## 3.4 Soporte visual

Como apoyo de este punto se encuentra la grafica `ESQUEMA_ALMACENAMIENTO_QUINDIOFLIX.png`, junto con su archivo fuente `ESQUEMA_ALMACENAMIENTO_QUINDIOFLIX.dot`. Tambien se elaboro la guia `04_Scripts_SQL/correciones/GUIA_EJECUCION_PUNTO3.md` para ejecutar el proceso en SQL Developer y organizar las capturas de pantalla.
