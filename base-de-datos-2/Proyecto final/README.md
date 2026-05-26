# QuindioFlix - Proyecto Final Base de Datos II

## Universidad del Quindío - Ingeniería de Sistemas y Computación

## Descripción

QuindioFlix es una plataforma de streaming de contenido multimedia con:

- **Backend PHP** - API RESTful en puerto 8080
- **Frontend React** - Aplicación web con Tailwind CSS
- **Base de Datos Oracle XE 21** - En Docker (puerto 1522)

## Estructura del Proyecto

```
Proyecto final/
├── docker-compose.yml           # Oracle XE 21
├── quindioflix-api/            # Backend PHP
│   ├── config/                 # Configuración BD
│   ├── public/
│   │   ├── index.php           # API REST
│   │   └── data.json           # Datos de prueba
│   ├── scripts/
│   │   ├── 01_crear_tablas.sql
│   │   └── 02_datos_prueba.sql
│   ├── src/
│   │   ├── middleware/
│   │   └── utils/
│   └── vendor/
│
└── quindioflix-frontend/        # Frontend React
    ├── src/
    │   ├── components/
    │   ├── context/
    │   ├── pages/
    │   └── services/
    ├── dist/                    # Production build
    └── package.json
```

## Quick Start

### 1. Oracle Docker
```bash
cd "Proyecto final"
docker-compose up -d
docker logs -f oracle-proyecto-final
```

### 2. Backend PHP (Puerto 8080)
```bash
cd quindioflix-api
php -S localhost:8080 -t public
```

### 3. Frontend React
```bash
cd quindioflix-frontend

# Development (puerto 3000)
npm run dev

# Production ya está en dist/ (puerto 1000)
```

### 4. Abrir navegador
- **Frontend:** http://localhost:1000
- **API:** http://localhost:8080/api/contenido

## Login de Prueba

**Email:** andres@mail.com  
**Password:** cualquier valor

## Endpoints Principales

- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/register` - Registro
- `GET /api/contenido` - Catálogo
- `GET /api/generos` - Géneros
- `GET /api/categorias` - Categorías
- `GET /api/planes` - Planes
- `GET /api/perfil/{id}/favoritos` - Favoritos
- `POST /api/favorito` - Agregar favorito
- `POST /api/resena` - Crear reseña
- `GET /api/admin/dashboard` - Dashboard admin

## Docker Oracle

El archivo `docker-compose.yml` configura:
- **Imagen:** gvenzl/oracle-xe:21-slim
- **Puerto:** 1522:1521
- **Password:** admin123
- **Usuario:** proyecto_final / proyecto123