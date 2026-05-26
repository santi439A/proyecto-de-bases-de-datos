<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/../src/utils/ResponseHelper.php';
require_once __DIR__ . '/../src/middleware/AuthMiddleware.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];

$authMiddleware = new AuthMiddleware();

$dataFile = __DIR__ . '/data.json';

function loadData($file) {
    if (!file_exists($file)) {
        return [
            'usuarios' => [],
            'perfiles' => [],
            'contenido' => [],
            'generos' => [],
            'categorias' => [],
            'favoritos' => [],
            'resenas' => [],
            'reproducciones' => [],
            'reportes' => [],
            'planes' => [
                ['plan_id' => 1, 'nombre' => 'BASICO', 'precio_mensual' => 14900, 'num_pantallas' => 1, 'max_perfiles' => 2, 'calidad' => 'SD'],
                ['plan_id' => 2, 'nombre' => 'ESTANDAR', 'precio_mensual' => 24900, 'num_pantallas' => 2, 'max_perfiles' => 3, 'calidad' => 'HD'],
                ['plan_id' => 3, 'nombre' => 'PREMIUM', 'precio_mensual' => 34900, 'num_pantallas' => 4, 'max_perfiles' => 5, 'calidad' => '4K']
            ],
            'empleados' => [],
            'departamentos' => []
        ];
    }
    return json_decode(file_get_contents($file), true);
}

function saveData($file, $data) {
    file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT));
}

$data = loadData($dataFile);

if ($method === 'POST' && $uri === '/api/auth/login') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['email'])) {
        ResponseHelper::error('Email es requerido', 400);
    }
    
    $user = null;
    foreach ($data['usuarios'] as $u) {
        if ($u['email'] === $input['email']) {
            $user = $u;
            break;
        }
    }
    
    if (!$user) {
        ResponseHelper::error('Credenciales inválidas', 401);
    }
    
    $plan = null;
    foreach ($data['planes'] as $p) {
        if ($p['plan_id'] == $user['plan_id']) {
            $plan = $p;
            break;
        }
    }
    
    $token = $authMiddleware->generateToken($user);
    
    ResponseHelper::success([
        'token' => $token,
        'user' => [
            'id' => $user['usuario_id'],
            'nombre' => $user['nombre'],
            'email' => $user['email'],
            'plan' => $plan ? $plan['nombre'] : 'BASICO'
        ]
    ]);
}

if ($method === 'POST' && $uri === '/api/auth/register') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $required = ['nombre', 'email', 'telefono', 'fecha_nacimiento', 'ciudad_residencia', 'plan_id'];
    foreach ($required as $field) {
        if (empty($input[$field])) {
            ResponseHelper::error("Campo $field es requerido", 400);
        }
    }
    
    foreach ($data['usuarios'] as $u) {
        if ($u['email'] === $input['email']) {
            ResponseHelper::error('El email ya está registrado', 409);
        }
    }
    
    $usuario_id = count($data['usuarios']) + 1;
    $newUser = [
        'usuario_id' => $usuario_id,
        'nombre' => $input['nombre'],
        'email' => $input['email'],
        'telefono' => $input['telefono'],
        'fecha_nacimiento' => $input['fecha_nacimiento'],
        'ciudad_residencia' => $input['ciudad_residencia'],
        'plan_id' => (int)$input['plan_id'],
        'fecha_registro' => date('Y-m-d'),
        'estado_cuenta' => 'ACTIVO'
    ];
    
    $data['usuarios'][] = $newUser;
    
    $perfil_id = count($data['perfiles']) + 1;
    $data['perfiles'][] = [
        'perfil_id' => $perfil_id,
        'usuario_id' => $usuario_id,
        'nombre' => $input['nombre'],
        'avatar' => 'avatar_default.png',
        'tipo' => 'ADULTO'
    ];
    
    saveData($dataFile, $data);
    
    $token = $authMiddleware->generateToken($newUser);
    
    ResponseHelper::success([
        'message' => 'Usuario registrado exitosamente',
        'token' => $token,
        'user' => [
            'id' => $usuario_id,
            'nombre' => $input['nombre'],
            'email' => $input['email']
        ]
    ], 201);
}

if ($method === 'GET' && $uri === '/api/contenido') {
    $generosMap = [
        1 => 'ACCION', 2 => 'COMEDIA', 3 => 'DRAMA', 4 => 'SUSPENSO', 5 => 'ROMANCE',
        6 => 'CIENCIA_FICCION', 7 => 'TERROR', 8 => 'INFANTIL'
    ];
    
    foreach ($data['contenido'] as &$c) {
        $c['generos'] = [$generosMap[($c['contenido_id'] % 8) + 1] ?? 'DRAMA'];
        $c['categoria'] = $c['categoria_nombre'] ?? 'PELICULA';
    }
    
    ResponseHelper::success($data['contenido']);
}

if ($method === 'GET' && preg_match('#^/api/contenido/(\d+)$#', $uri, $matches)) {
    $id = (int)$matches[1];
    $item = null;
    foreach ($data['contenido'] as $c) {
        if ($c['contenido_id'] === $id) {
            $item = $c;
            break;
        }
    }
    
    if (!$item) {
        ResponseHelper::error('Contenido no encontrado', 404);
    }
    
    $item['generos'] = [['genero_id' => 1, 'nombre' => 'ACCION']];
    $item['categoria'] = $item['categoria_nombre'] ?? 'PELICULA';
    $item['responsable'] = 'Empleado Admin';
    
    ResponseHelper::success($item);
}

if ($method === 'GET' && $uri === '/api/generos') {
    $generos = [
        ['genero_id' => 1, 'nombre' => 'ACCION'],
        ['genero_id' => 2, 'nombre' => 'COMEDIA'],
        ['genero_id' => 3, 'nombre' => 'DRAMA'],
        ['genero_id' => 4, 'nombre' => 'SUSPENSO'],
        ['genero_id' => 5, 'nombre' => 'ROMANCE'],
        ['genero_id' => 6, 'nombre' => 'CIENCIA_FICCION'],
        ['genero_id' => 7, 'nombre' => 'TERROR'],
        ['genero_id' => 8, 'nombre' => 'INFANTIL']
    ];
    ResponseHelper::success($generos);
}

if ($method === 'GET' && $uri === '/api/categorias') {
    $categorias = [
        ['categoria_id' => 1, 'nombre' => 'PELICULA'],
        ['categoria_id' => 2, 'nombre' => 'SERIE'],
        ['categoria_id' => 3, 'nombre' => 'DOCUMENTAL'],
        ['categoria_id' => 4, 'nombre' => 'MUSICA'],
        ['categoria_id' => 5, 'nombre' => 'PODCAST']
    ];
    ResponseHelper::success($categorias);
}

if ($method === 'GET' && $uri === '/api/planes') {
    ResponseHelper::success($data['planes']);
}

if ($method === 'GET' && preg_match('#^/api/usuario/(\d+)/perfiles$#', $uri, $matches)) {
    $usuario_id = (int)$matches[1];
    $perfiles = array_filter($data['perfiles'], function($p) use ($usuario_id) {
        return $p['usuario_id'] === $usuario_id;
    });
    ResponseHelper::success(array_values($perfiles));
}

if ($method === 'GET' && preg_match('#^/api/perfil/(\d+)/favoritos$#', $uri, $matches)) {
    $perfil_id = (int)$matches[1];
    $favContenidos = array_filter($data['contenido'], function($c) use ($perfiles, $perfil_id) {
        foreach ($data['favoritos'] as $f) {
            if ($f['perfil_id'] === $perfil_id && $f['contenido_id'] === $c['contenido_id']) {
                return true;
            }
        }
        return false;
    });
    ResponseHelper::success(array_values($favContenidos));
}

if ($method === 'POST' && $uri === '/api/favorito') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $existe = false;
    foreach ($data['favoritos'] as $f) {
        if ($f['perfil_id'] == $input['perfil_id'] && $f['contenido_id'] == $input['contenido_id']) {
            $existe = true;
            break;
        }
    }
    
    if (!$existe) {
        $data['favoritos'][] = [
            'perfil_id' => (int)$input['perfil_id'],
            'contenido_id' => (int)$input['contenido_id'],
            'fecha_agregado' => date('Y-m-d')
        ];
        saveData($dataFile, $data);
    }
    
    ResponseHelper::success(['message' => 'Agregado a favoritos'], 201);
}

if ($method === 'DELETE' && preg_match('#^/api/favorito/(\d+)/(\d+)$#', $uri, $matches)) {
    $perfil_id = (int)$matches[1];
    $contenido_id = (int)$matches[2];
    
    $data['favoritos'] = array_filter($data['favoritos'], function($f) use ($perfil_id, $contenido_id) {
        return !($f['perfil_id'] === $perfil_id && $f['contenido_id'] === $contenido_id);
    });
    $data['favoritos'] = array_values($data['favoritos']);
    saveData($dataFile, $data);
    
    ResponseHelper::success(['message' => 'Eliminado de favoritos']);
}

if ($method === 'POST' && $uri === '/api/resena') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['perfil_id']) || !isset($input['contenido_id']) || !isset($input['calificacion'])) {
        ResponseHelper::error('Campos requeridos', 400);
    }
    
    $resena_id = count($data['resenas']) + 1;
    $data['resenas'][] = [
        'resena_id' => $resena_id,
        'perfil_id' => (int)$input['perfil_id'],
        'contenido_id' => (int)$input['contenido_id'],
        'calificacion' => (int)$input['calificacion'],
        'texto' => $input['texto'] ?? '',
        'fecha_publicacion' => date('Y-m-d')
    ];
    saveData($dataFile, $data);
    
    ResponseHelper::success(['message' => 'Reseña creada', 'resena_id' => $resena_id], 201);
}

if ($method === 'POST' && $uri === '/api/reproduccion/iniciar') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $reproduccion_id = count($data['reproducciones']) + 1;
    $data['reproducciones'][] = [
        'reproduccion_id' => $reproduccion_id,
        'perfil_id' => (int)$input['perfil_id'],
        'contenido_id' => (int)$input['contenido_id'],
        'dispositivo' => $input['dispositivo'] ?? 'COMPUTADOR',
        'fecha_inicio' => date('Y-m-d H:i:s'),
        'fecha_fin' => null,
        'porcentaje_avance' => 0
    ];
    saveData($dataFile, $data);
    
    ResponseHelper::success(['message' => 'Reproducción iniciada', 'reproduccion_id' => $reproduccion_id], 201);
}

if ($method === 'PUT' && preg_match('#^/api/reproduccion/(\d+)/finalizar$#', $uri, $matches)) {
    $reproduccion_id = (int)$matches[1];
    $input = json_decode(file_get_contents('php://input'), true);
    $porcentaje = $input['porcentaje'] ?? 100;
    
    foreach ($data['reproducciones'] as &$r) {
        if ($r['reproduccion_id'] === $reproduccion_id) {
            $r['fecha_fin'] = date('Y-m-d H:i:s');
            $r['porcentaje_avance'] = $porcentaje;
            break;
        }
    }
    saveData($dataFile, $data);
    
    ResponseHelper::success(['message' => 'Reproducción finalizada']);
}

if ($method === 'GET' && $uri === '/api/admin/dashboard') {
    ResponseHelper::success([
        'total_usuarios' => count($data['usuarios']),
        'total_contenido' => count($data['contenido']),
        'total_reproducciones' => count($data['reproducciones']),
        'reportes_pendientes' => count(array_filter($data['reportes'], function($r) { return $r['estado'] === 'PENDIENTE'; }))
    ]);
}

if ($method === 'GET' && $uri === '/api/admin/reportes') {
    $reportes = [];
    foreach ($data['reportes'] as $r) {
        $contenido = null;
        foreach ($data['contenido'] as $c) {
            if ($c['contenido_id'] === $r['contenido_id']) {
                $contenido = $c['titulo'];
                break;
            }
        }
        $r['contenido_titulo'] = $contenido ?? 'Desconocido';
        $r['perfil_nombre'] = 'Usuario';
        $r['moderador_nombre'] = null;
        $reportes[] = $r;
    }
    ResponseHelper::success($reportes);
}

if ($method === 'GET' && $uri === '/api/admin/empleados') {
    $empleados = [];
    foreach ($data['empleados'] as $emp) {
        $dept = null;
        foreach ($data['departamentos'] as $d) {
            if ($d['departamento_id'] === $emp['departamento_id']) {
                $dept = $d['nombre'];
                break;
            }
        }
        $emp['departamento_nombre'] = $dept ?? 'General';
        $emp['supervisor_nombre'] = null;
        $empleados[] = $emp;
    }
    ResponseHelper::success($empleados);
}

if ($method === 'GET' && $uri === '/api/admin/departamentos') {
    $deptos = [];
    foreach ($data['departamentos'] as $d) {
        $jefe = null;
        foreach ($data['empleados'] as $emp) {
            if ($emp['empleado_id'] === $d['jefe_id']) {
                $jefe = $emp['nombre'];
                break;
            }
        }
        $d['jefe_nombre'] = $jefe;
        $deptos[] = $d;
    }
    ResponseHelper::success($deptos);
}

ResponseHelper::error('Endpoint no encontrado', 404);