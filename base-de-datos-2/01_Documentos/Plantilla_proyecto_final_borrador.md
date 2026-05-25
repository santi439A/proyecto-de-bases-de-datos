# QuindioFlix

## Documento de Definicion del Proyecto (DP)

**Version:** 0.1  
**Estado:** En construccion

**Preparado por:** Pendiente  
**Universidad:** Universidad del Quindio  
**Programa:** Ingenieria de Sistemas y Computacion  
**Curso:** Bases de Datos II

## Historial de revisiones

| Fecha | Version | Descripcion | Autor |
|-------|---------|-------------|-------|
| 2026-05-05 | 0.1 | Elaboracion inicial del documento y desarrollo de los primeros apartados | Grupo de trabajo |

## Objetivo

El objetivo de este documento es presentar el desarrollo del proyecto final de Bases de Datos II tomando como base el sistema QuindioFlix. A lo largo del trabajo se aplican los temas vistos durante el curso, entre ellos analisis del negocio, modelado de datos, normalizacion, implementacion en Oracle, consultas avanzadas, PL/SQL, transacciones, indices y control de acceso. Con esto se busca dejar sustentadas tanto las decisiones de diseno como la estructura final de la base de datos propuesta para el proyecto.

## 1. Descripcion de la empresa

QuindioFlix es una plataforma colombiana de streaming orientada a la distribucion de contenido multimedia por suscripcion. Su catalogo incluye peliculas, series, documentales, musica y podcasts, por lo que la empresa necesita una base de datos capaz de soportar tanto la operacion diaria del servicio como los procesos administrativos que hacen parte del negocio.

El catalogo constituye uno de los componentes principales del sistema. Cada contenido debe registrarse con datos como titulo, anio de lanzamiento, duracion, sinopsis, clasificacion por edad y fecha de ingreso a la plataforma. A esto se suma que un mismo contenido puede pertenecer a varios generos al tiempo y tambien puede relacionarse con otros contenidos, por ejemplo en casos de secuelas, precuelas, remakes, spin-off o versiones extendidas. Por esta razon, la informacion del catalogo no puede manejarse de forma aislada, sino como una estructura que permita clasificar, vincular y consultar el contenido de diferentes maneras.

Tambien es necesario diferenciar la forma en que se organiza cada tipo de contenido. Mientras que una pelicula se maneja como una unidad individual, las series y los podcasts requieren una estructura adicional por temporadas y episodios. Esta diferencia influye directamente en el modelo de datos, ya que no toda la informacion aplica por igual a todos los contenidos.

El acceso al servicio se realiza mediante cuentas de usuario asociadas a un plan de suscripcion. En el momento del registro, el usuario debe ingresar su nombre, correo electronico, telefono, fecha de nacimiento y ciudad de residencia, y luego seleccionar uno de los planes disponibles: Basico, Estandar o Premium. Cada plan define condiciones particulares del servicio, como la cantidad de pantallas simultaneas permitidas, la calidad de reproduccion y el numero maximo de perfiles que puede manejar una cuenta.

Dentro de cada cuenta pueden existir varios perfiles. Cada perfil tiene nombre, avatar y tipo, que puede ser adulto o infantil. Esta distincion es importante porque los perfiles infantiles solo pueden acceder a contenido clasificado como TP, +7 o +13. En consecuencia, la base de datos debe permitir representar esta regla de forma clara para que luego pueda aplicarse en validaciones y controles del sistema.

Ademas del registro de usuarios, la plataforma contempla un esquema de referidos. Un usuario puede invitar a otro a unirse al servicio y, si el nuevo usuario completa su registro, ambos reciben un beneficio. Esto implica llevar control de quien hizo la invitacion, quien fue referido, en que fecha se produjo el registro y si el beneficio ya fue aplicado.

La operacion central de QuindioFlix esta relacionada con el consumo de contenido. Cada reproduccion debe almacenar el perfil que la realiza, el contenido reproducido, el episodio correspondiente cuando aplique, la fecha y hora de inicio, la fecha y hora de finalizacion, el dispositivo utilizado y el porcentaje de avance. A esto se suman otras interacciones importantes, como la opcion de marcar contenido como favorito, asignar una calificacion y escribir una resena.

La plataforma tambien debe contemplar procesos de control y moderacion. Los usuarios pueden reportar contenido inapropiado, y dichos reportes deben ser atendidos por personal responsable dentro de la empresa. Por ello se requiere registrar el motivo del reporte, su estado, la fecha en que fue creado, la fecha de resolucion y la persona encargada de revisarlo.

En la parte organizacional, QuindioFlix cuenta con empleados distribuidos en departamentos como Tecnologia, Contenido, Marketing, Soporte y Finanzas. Cada departamento tiene un jefe y, adicionalmente, algunos empleados pueden supervisar a otros dentro de la misma estructura. Los empleados del area de Contenido se encargan de la publicacion y administracion del catalogo, mientras que el area de Soporte interviene en la atencion de los reportes realizados por los usuarios.

Otro componente importante es el financiero. La empresa debe registrar pagos mensuales de suscripcion, indicando fecha, monto, metodo de pago y estado. Los medios de pago considerados en el contexto son tarjeta de credito, tarjeta debito, PSE, Nequi y Daviplata. De igual manera, es necesario manejar la facturacion periodica y la regla segun la cual una cuenta puede desactivarse si el usuario no realiza el pago dentro del tiempo establecido.

Finalmente, la empresa requiere informacion util para seguimiento y toma de decisiones. Se necesitan reportes de consumo por ciudad, categoria, genero, dispositivo, plan y periodo de tiempo, asi como reportes financieros y de rendimiento del personal. En este sentido, la base de datos no solo debe servir para almacenar la informacion del negocio, sino tambien para facilitar su consulta, analisis y administracion.

### Reglas de negocio identificadas en la descripcion de la empresa

1. Todo contenido debe registrarse con metadatos basicos de identificacion, clasificacion y fecha de ingreso al catalogo.
2. Un contenido puede pertenecer a uno o varios generos simultaneamente.
3. Solo las series y los podcasts pueden tener temporadas y episodios.
4. Un contenido puede estar relacionado con otro contenido mediante una relacion semantica como secuela, precuela, remake o spin-off.
5. Todo usuario debe registrarse con un unico correo electronico y seleccionar un plan de suscripcion.
6. Los planes determinan la cantidad de pantallas simultaneas y la calidad del servicio.
7. Cada cuenta puede tener varios perfiles, pero el maximo permitido depende del plan contratado.
8. Los perfiles infantiles solo pueden acceder a contenido clasificado como TP, +7 o +13.
9. Cada reproduccion debe registrar inicio, fin, dispositivo y porcentaje de avance.
10. Los reportes de contenido inapropiado deben quedar asociados a un estado y a un responsable de su revision.
11. Cada departamento tiene un jefe y los empleados pueden formar relaciones de supervision jerarquicas.
12. Los pagos de suscripcion deben registrarse con monto, fecha, metodo y estado.
13. Si un usuario no paga dentro del plazo definido por el negocio, su cuenta debe desactivarse.
14. Los usuarios vinculados por referidos pueden obtener beneficios aplicables a cobros futuros.
15. La informacion del sistema debe soportar reportes operativos, financieros y de desempeno del personal.

## 2. Modelo relacional

En este punto se presenta el diagrama MER del proyecto, ya que es el recurso visual que mejor resume la estructura general del sistema y facilita su lectura dentro del documento. A partir de este diagrama se puede entender como se organiza la informacion de QuindioFlix, cuales son las entidades principales del negocio y de que manera se relacionan entre si. Aunque la implementacion completa en base de datos requiere un modelo logico relacional, para efectos de la explicacion del proyecto el MER resulta mas claro y suficiente para mostrar la idea general del sistema. Como apoyo visual de este apartado se utiliza la imagen `03_Modelos/correciones/DIAGRAMA_MER_QUINDIOFLIX.png`.

### 2.1 Estructura general del modelo

El modelo queda organizado en cinco bloques principales. El primero corresponde a las tablas maestras, donde se encuentran `PLAN`, `CATEGORIA`, `GENERO` y `DEPARTAMENTO`. El segundo bloque corresponde al equipo de trabajo, representado por la entidad `EMPLEADO`. El tercer bloque es el catalogo multimedia, formado por `CONTENIDO`, `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO`, `TEMPORADA` y `EPISODIO`. El cuarto bloque es el de usuarios y consumo, donde se ubican `USUARIO`, `PERFIL`, `REFERIDO`, `REPRODUCCION`, `FAVORITO`, `RESENA` y `REPORTE`. Finalmente, el quinto bloque corresponde a la parte financiera, compuesta por `FACTURA` y `PAGO`.

Esta organizacion permite separar la informacion segun la funcion que cumple dentro del sistema. De esta manera, el modelo no queda concentrado en una sola tabla con muchos datos mezclados, sino distribuido en relaciones que representan de forma mas clara cada proceso del negocio.

### 2.2 Entidades principales del diagrama

Dentro del diagrama, `PLAN` representa los tipos de suscripcion disponibles para los usuarios. `CATEGORIA` y `GENERO` permiten clasificar el contenido desde dos enfoques distintos: uno mas general y otro mas especifico. `CONTENIDO` es la entidad central del catalogo, ya que almacena la informacion principal de peliculas, series, documentales, musica y podcasts.

Las entidades `TEMPORADA` y `EPISODIO` complementan la parte del catalogo, ya que permiten representar correctamente los contenidos que tienen una estructura por entregas, como las series y los podcasts. En la parte de usuarios aparecen `USUARIO` y `PERFIL`, donde la cuenta principal queda separada de los perfiles individuales que hacen uso del servicio.

En la parte operativa del sistema se encuentran `REPRODUCCION`, `FAVORITO`, `RESENA` y `REPORTE`, que registran la interaccion de los perfiles con el contenido. `REFERIDO` permite modelar el beneficio entre usuarios cuando uno invita a otro a registrarse. Por otro lado, `EMPLEADO` y `DEPARTAMENTO` representan la estructura interna de la empresa. Finalmente, `FACTURA` y `PAGO` corresponden al componente financiero del sistema.

### 2.3 Relaciones mas importantes del modelo

Una de las relaciones principales del diagrama es la que existe entre `USUARIO` y `PERFIL`, ya que una cuenta puede tener varios perfiles. A su vez, cada perfil puede generar reproducciones, favoritos, resenas y reportes. Esto permite reflejar que el consumo dentro de la plataforma no se maneja solo a nivel de cuenta, sino tambien a nivel de cada perfil.

Otra relacion importante es la de `CONTENIDO` con `GENERO`, que es de muchos a muchos y se resuelve mediante `CONTENIDO_GENERO`. Tambien es clave la relacion reflexiva que se modela con `CONTENIDO_RELACIONADO`, porque permite representar secuelas, precuelas, remakes o spin-off dentro del mismo catalogo.

En el caso de los contenidos seriados, la relacion entre `CONTENIDO`, `TEMPORADA` y `EPISODIO` permite organizar de manera jerarquica la informacion. Esto diferencia los contenidos unitarios de aquellos que se dividen por temporadas y episodios.

En la parte administrativa se observa la relacion entre `DEPARTAMENTO` y `EMPLEADO`, asi como la relacion de supervision entre empleados. Ademas, `EMPLEADO` tambien se relaciona con `CONTENIDO`, porque cada contenido tiene un responsable de publicacion, y con `REPORTE`, porque los casos reportados deben ser atendidos por personal de soporte o moderacion.

Finalmente, la relacion entre `USUARIO`, `FACTURA` y `PAGO` representa el flujo financiero principal del sistema. Un usuario genera facturas periodicas y sobre esas facturas se registran los pagos realizados.

### 2.4 Apreciaciones para entender mejor el diagrama

1. `CATEGORIA` se maneja como una entidad propia porque el proyecto pide consultas, reportes y datos de prueba organizados por categoria.
2. `CONTENIDO_RELACIONADO` permite que un contenido tenga varias relaciones con otros contenidos sin limitarse a un solo registro relacionado.
3. `PLAN` incluye tanto `num_pantallas` como `max_perfiles`, ya que son reglas distintas dentro del negocio.
4. `USUARIO` incluye `estado_cuenta` y `fecha_ultimo_pago`, porque estos datos se necesitan mas adelante para pagos, mora y validaciones de acceso.
5. `FACTURA` y `PAGO` se separan para diferenciar el cobro mensual del pago realizado por el usuario.
6. `REPORTE` se relaciona con `moderador_id` para dejar identificada la persona encargada de revisar el caso.
7. Las tablas asociativas como `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO` y `FAVORITO` ayudan a mantener el modelo organizado y facilitan la explicacion de la normalizacion hasta 3FN.

## 3. Esquema de almacenamiento

El esquema de almacenamiento de QuindioFlix fue planteado en Oracle con el fin de separar la informacion operativa de las estructuras de acceso. Esta decision permite un mejor control del crecimiento de la base de datos, facilita la administracion del almacenamiento y ayuda a optimizar el rendimiento de las consultas. Para este proyecto se definieron dos tablespaces principales: uno orientado a los datos del sistema y otro destinado a los indices.

### 3.1 Asignacion de tablas a tablespace

| Tablespace | Datafile | Estado | Tamano inicial | Autoextend | Tamano maximo | Justificacion |
|------------|----------|--------|----------------|------------|----------------|---------------|
| `ts_quindioflix_data` | `quindioflix_data01.dbf` | Online | 100 MB | 50 MB | 500 MB | Se utiliza para almacenar las tablas del sistema y toda la informacion operativa del negocio |
| `ts_quindioflix_indx` | `quindioflix_indx01.dbf` | Online | 50 MB | 25 MB | 200 MB | Se utiliza para almacenar los indices y separar las estructuras de acceso de los datos |

El tablespace `ts_quindioflix_data` concentra las tablas principales del sistema, ya que alli se almacena la informacion relacionada con usuarios, contenido, consumo, empleados y finanzas. Su tamano inicial es mayor porque soporta el volumen principal de datos del proyecto. Ademas, se configura con autoextend para permitir crecimiento progresivo sin necesidad de intervencion inmediata.

El tablespace `ts_quindioflix_indx` se reserva para los indices. La separacion entre datos e indices permite un mejor control del almacenamiento y un acceso mas ordenado a las estructuras utilizadas para acelerar consultas, busquedas y relaciones entre tablas.

Las tablas del sistema se asignan a `ts_quindioflix_data`, ya que corresponden a la informacion central del modelo. En este grupo se encuentran:

1. `PLAN`, `CATEGORIA`, `GENERO`, `DEPARTAMENTO`
2. `EMPLEADO`
3. `CONTENIDO`, `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO`, `TEMPORADA`, `EPISODIO`
4. `USUARIO`, `PERFIL`, `REFERIDO`
5. `REPRODUCCION`, `FAVORITO`, `RESENA`, `REPORTE`
6. `FACTURA`, `PAGO`

Por otra parte, en `ts_quindioflix_indx` se almacenan los indices creados sobre columnas de uso frecuente, por ejemplo las relacionadas con contenido, usuario, reproduccion, reporte, pago y factura. Esta asignacion permite que las tablas y los indices no compitan dentro del mismo espacio fisico de la misma manera, lo que favorece la administracion del sistema.

### 3.2 Script de Creacion de Tablas y Tablespace

El soporte fisico principal de este punto se encuentra en el archivo `04_Scripts_SQL/correciones/01_CREACION_TABLESPACES_TABLAS.sql`. En este script se plantea la creacion de los tablespaces con sus respectivos datafiles, la creacion de las tablas del sistema y la asignacion de dichas tablas al tablespace `ts_quindioflix_data`.

Ademas de la asignacion de tablespaces, el script contempla propiedades fisicas y logicas importantes para el modelo, por ejemplo llaves primarias, llaves foraneas, restricciones `UNIQUE`, restricciones `CHECK`, secuencias, indices almacenados en `ts_quindioflix_indx` y la particion por rango de la tabla `REPRODUCCION`.

### 3.3 Fragmentacion y crecimiento de datos

La tabla `REPRODUCCION` se considera la de mayor crecimiento en QuindioFlix, ya que cada vez que un perfil consume contenido se genera un nuevo registro. Por esta razon, se definio una fragmentacion por rango sobre el atributo `fecha_inicio`.

Las particiones contempladas son:

1. `p2025`, para registros anteriores al anio 2026.
2. `p2026`, para registros anteriores al anio 2027.
3. `p_max`, para registros posteriores a esos rangos.

Esta fragmentacion permite organizar mejor la informacion historica, facilitar consultas por periodos de tiempo y preparar la base de datos para un crecimiento continuo, especialmente en una tabla que por naturaleza tiende a aumentar rapidamente.

### 3.4 Prueba del modelo

Para la prueba del modelo se debe poblar la base de datos con suficientes registros que permitan validar tanto la estructura como las restricciones. Como criterio minimo de carga se propone registrar al menos 25 datos por cada tabla principal y 40 registros en cada tabla intermedia. Este criterio ya fue tenido en cuenta en el script de carga preparado para esta etapa.

En este caso, las tablas intermedias o asociativas que deben recibir una carga suficiente son `CONTENIDO_GENERO`, `CONTENIDO_RELACIONADO` y `FAVORITO`. Ademas, la tabla `REPRODUCCION` debe poblarse con fechas distribuidas en distintos periodos para comprobar que la fragmentacion por rango funcione correctamente.

La informacion de prueba no debe ser uniforme. Es importante que existan usuarios en varias ciudades, planes diferentes, contenido variado y movimientos financieros diversos, para que posteriormente las consultas y reportes del proyecto generen resultados utiles y realistas. Para esta etapa se dejaron como apoyo los archivos `04_Scripts_SQL/correciones/02_CARGA_DATOS_PRUEBA.sql` y `04_Scripts_SQL/correciones/03_VALIDACION_PUNTO3.sql`.

### 3.5 Grafica del esquema de almacenamiento

Como apoyo visual del punto 3 se elaboro la grafica `03_Modelos/correciones/ESQUEMA_ALMACENAMIENTO_QUINDIOFLIX.png`, donde se muestran los tablespaces creados, sus datafiles, las propiedades principales de almacenamiento, la asignacion general de tablas y la fragmentacion de `REPRODUCCION`. Adicionalmente, se preparo la guia `04_Scripts_SQL/correciones/GUIA_EJECUCION_PUNTO3.md` para documentar el paso a paso de la ejecucion en SQL Developer y la toma de capturas.

### 3.6 Relacion con el script fisico

La implementacion de este esquema se encuentra sustentada en el archivo `04_Scripts_SQL/correciones/01_CREACION_TABLESPACES_TABLAS.sql`, donde se definen los tablespaces, los datafiles, la creacion de tablas, las restricciones, las secuencias y los indices. Dentro de este mismo script tambien se incluye la particion por rango de la tabla `REPRODUCCION`, lo que conecta directamente el diseno del almacenamiento con la implementacion fisica propuesta para la base de datos.

## 4. Analisis de vistas (CRUD)

Pendiente de desarrollar.

## 5. Analisis de roles y privilegios

Pendiente de desarrollar.

## 6. Consultas para reportes

Pendiente de desarrollar.

## 7. Metodos, funciones, procedimientos y disparadores implementados

Pendiente de desarrollar.

## 8. Conclusiones

Pendiente de desarrollar.
