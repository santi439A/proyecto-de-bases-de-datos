# QuindioFlix - Proyecto Final Base de Datos II

## Universidad del Quindío - Ingeniería de Sistemas y Computación

## Descripción

QuindioFlix es una plataforma de streaming de contenido multimedia desarrollada como proyecto final del curso de Bases de Datos II. Incluye un backend PHP REST API y un frontend React con Tailwind CSS.

## Estructura del Proyecto

```
proyecto-de-bases-de-datos/
├── quindioflix-api/           # Backend PHP
│   ├── config/
│   │   └── database.php       # Conexión Oracle (OCI8)
│   ├── public/
│   │   ├── index.php          # API REST Endpoint
│   │   ├── data.json          # Datos de prueba (JSON)
│   │   └── .htaccess          # Rewrite rules
│   ├── src/
│   │   ├── middleware/
│   │   │   └── AuthMiddleware.php  # JWT Authentication
│   │   └── utils/
│   │       └── ResponseHelper.php   # JSON Response helpers
│   ├── scripts/
│   │   ├── 01_crear_tablas.sql       # DDL Oracle
│   │   └── 02_datos_prueba.sql       # Datos de prueba
│   ├── composer.json
│   └── vendor/                 # Dependencias PHP
│
├── quindioflix-frontend/      # Frontend React
│   ├── src/
│   │   ├── components/        # Componentes reutilizables
│   │   ├── context/           # React Context (Auth)
│   │   ├── pages/             # Páginas de la app
│   │   ├── services/          # API client (Axios)
│   │   ├── App.jsx             # Router principal
│   │   └── main.jsx           # Entry point
│   ├── dist/                   # Production build
│   ├── node_modules/           # Dependencias npm
│   ├── package.json
│   ├── tailwind.config.js
│   └── vite.config.js
│
└── base-de-datos-2/             # Documentación y scripts SQL del curso
    ├── 01_Documentos/
    ├── 02_Diagramas/
    ├── 03_Modelos/
    ├── 04_Scripts_SQL/
    └── 05_Referencia/
```

## Requisitos

- **PHP:** 8.1+ (configurado en Laragon)
- **Node.js:** 18+ (para React development)
- **Docker:** Para Oracle XE 21
- **Laragon:** Servidor web Apache
- **Oracle Instant Client:** Para conexión OCI8 (opcional si usa JSON)

## Instalación y Ejecución

### 1. Base de Datos Oracle (Docker)

```bash
# Verificar que Docker esté corriendo
docker ps

# Iniciar contenedor Oracle (si no está corriendo)
docker run -d --name oracle-proyecto-final -p 1522:1521 \
  -e ORACLE_PASSWORD=admin123 \
  -e APP_USER=proyecto_final \
  -e APP_USER_PASSWORD=proyecto123 \
  gvenzl/oracle-xe:21-slim

# Esperar a que esté listo (~2 minutos)
docker logs oracle-proyecto-final
```

### 2. Backend PHP

```bash
# Ubicación: E:\proyecto-de-bases-de-datos\quindioflix-api\

# El backend usa un archivo JSON para datos (más simple sin OCI8)
# Para cambiar a Oracle, editar config/database.php

# Puerto: 8080
# URL: http://localhost:8080/api/
```

### 3. Frontend React

```bash
# Ubicación: E:\proyecto-de-bases-de-datos\quindioflix-frontend\

# Development mode (puerto 3000):
cd quindioflix-frontend
npm run dev

# Production build:
npm run build
```

### 4. Configuración de VirtualHost en Laragon

Los archivos de configuración ya están en:
- `E:\laragon\etc\apache2\sites-enabled\quindioflix-api.conf` (puerto 8080)
- `E:\laragon\etc\apache2\sites-enabled\quindioflix-frontend.conf` (puerto 1000)

**Reiniciar Apache en Laragon para aplicar cambios.**

## Endpoints API

### Autenticación
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/auth/login` | Iniciar sesión (email) |
| POST | `/api/auth/register` | Registrar nuevo usuario |

### Contenido
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/contenido` | Listar todo el contenido |
| GET | `/api/contenido/{id}` | Detalle de contenido |
| GET | `/api/generos` | Listar géneros |
| GET | `/api/categorias` | Listar categorías |
| GET | `/api/planes` | Listar planes de suscripción |

### Perfiles y Favoritos
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/usuario/{id}/perfiles` | Perfiles del usuario |
| GET | `/api/perfil/{id}/favoritos` | Favoritos del perfil |
| POST | `/api/favorito` | Agregar a favoritos |
| DELETE | `/api/favorito/{perfil}/{contenido}` | Eliminar de favoritos |

### Reseñas y Reproducción
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/resena` | Crear reseña |
| POST | `/api/reproduccion/iniciar` | Iniciar reproducción |
| PUT | `/api/reproduccion/{id}/finalizar` | Finalizar reproducción |

### Admin
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/admin/dashboard` | Métricas generales |
| GET | `/api/admin/reportes` | Gestión de reportes |
| GET | `/api/admin/empleados` | Gestión de empleados |
| GET | `/api/admin/departamentos` | Gestión de departamentos |

## Credenciales de Prueba

| Email | Nombre | Plan | Perfiles |
|-------|--------|------|----------|
| andres@mail.com | Andres Perez | BASICO | Andres (Adulto), Niña Andres (Infantil) |
| carmen@mail.com | Carmen Torres | ESTANDAR | Carmen (Adulto) |
| roberto@mail.com | Roberto Silva | PREMIUM | Roberto (Adulto), Hijo Roberto (Infantil) |
| elena@mail.com | Elena Vargas | BASICO | Elena (Adulto) |
| patricia@mail.com | Patricia Rojas | PREMIUM | Patricia (Adulto), Hijo Patricia (Infantil) |

**Password:** Cualquier valor (sistema simplificado sin validación de password)

## Funcionalidades

### Usuario
- [x] Registro con selección de plan
- [x] Login con autenticación JWT
- [x] Gestión de perfiles (adulto/infantil)
- [x] Cambio de perfil activo

### Catálogo
- [x] Grid de contenido con cards
- [x] Filtros: género, categoría, clasificación de edad
- [x] Búsqueda por título
- [x] Detalle de contenido con información completa

### Reproducción
- [x] Iniciar reproducción (registra timestamp)
- [x] Finalizar con porcentaje de avance
- [x] Historial de reproducciones

### Interacción Social
- [x] Agregar/eliminar favoritos
- [x] Crear reseñas con calificación (1-5 estrellas)
- [x] Ver reseñas de otros usuarios

### Panel de Administración
- [x] Dashboard con métricas (usuarios, contenido, reproducciones, reportes)
- [x] Gestión de reportes de contenido
- [x] Lista de empleados por departamento
- [x] Lista de departamentos con jefe asignado

## Modelo de Datos (Oracle)

El proyecto incluye scripts SQL completos para Oracle:

- **19 tablas** según el modelo entidad-relación
- **Secuencias** para generación de IDs
- **Índices** para optimizar consultas
- **Constraints** de integridad referencial

Ver: `quindioflix-api/scripts/01_crear_tablas.sql`

## Tecnologías

### Backend
- **PHP 8.3** con servidor built-in
- **Slim Framework 4** (opcional, API vanilla también funciona)
- **JWT** para autenticación

### Frontend
- **React 18** con Vite
- **Tailwind CSS** para estilos
- **React Router** para navegación
- **Axios** para HTTP client

### Base de Datos
- **Oracle XE 21** (Docker)
- **JSON file** como alternativa sin Oracle

## Screenshots

El frontend tiene un diseño estilo Netflix:
- Fondo oscuro (#141414)
- Colores primarios rojos (#E50914)
- Cards de contenido con hover effects
- Sidebar para filtros
- Responsive design

## Notas de Desarrollo

1. **API sin Oracle OCI8:** El backend usa `data.json` para datos porque la extensión OCI8 no está disponible en Laragon. Esto permite desarrollo sin configuración de Oracle.

2. **Proxy Vite:** En desarrollo, Vite hace proxy de `/api/*` a `localhost:8080`.

3. **CORS:** El backend permite todos los orígenes (`Access-Control-Allow-Origin: *`).

4. **JWT:** Los tokens expiran en 7 días.

## Próximos Pasos (Mejoras Futuras)

- [ ] Implementar conexión real a Oracle con OCI8
- [ ] Agregar validación de password con hash
- [ ] Implementar WebSocket para notificaciones en tiempo real
- [ ] Agregar paginación al catálogo
- [ ] Implementar planes de suscripción reales
- [ ] Agregar sistema de pagos
- [ ] Implementar reproducciones de video reales
- [ ] Agregar上传 de contenido (admin)
- [ ] Implementar chat o comentarios

## Licencia

Proyecto académico - Universidad del Quindío