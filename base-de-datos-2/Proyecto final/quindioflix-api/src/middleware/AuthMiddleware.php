<?php

class AuthMiddleware
{
    private $secretKey = 'quindioflix-secret-key-2025';
    private $algorithm = 'HS256';

    public function generateToken($user)
    {
        $header = base64_encode(json_encode(['typ' => 'JWT', 'alg' => 'HS256']));
        $payload = base64_encode(json_encode([
            'iss' => 'quindioflix',
            'aud' => 'quindioflix-api',
            'iat' => time(),
            'exp' => time() + (7 * 24 * 60 * 60),
            'user_id' => $user['usuario_id'] ?? $user['USUARIO_ID'] ?? null,
            'email' => $user['email'] ?? $user['EMAIL'] ?? null,
            'nombre' => $user['nombre'] ?? $user['NOMBRE'] ?? null
        ]));
        $signature = base64_encode(hash_hmac('sha256', "$header.$payload", $this->secretKey, true));
        
        return "$header.$payload.$signature";
    }

    public function validateToken($token)
    {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }
        
        list($header, $payload, $signature) = $parts;
        
        $expectedSignature = base64_encode(hash_hmac('sha256', "$header.$payload", $this->secretKey, true));
        if ($signature !== $expectedSignature) {
            return null;
        }
        
        $decoded = json_decode(base64_decode($payload), true);
        if (!$decoded) {
            return null;
        }
        
        if (isset($decoded['exp']) && $decoded['exp'] < time()) {
            return null;
        }
        
        return $decoded;
    }

    public function getAuthHeader()
    {
        $headers = getallheaders();
        return $headers['Authorization'] ?? $headers['authorization'] ?? null;
    }

    public function requireAuth()
    {
        $authHeader = $this->getAuthHeader();
        
        if (!$authHeader) {
            ResponseHelper::error('Token de autenticación requerido', 401);
            exit;
        }

        if (!preg_match('/^Bearer\s+(.+)$/i', $authHeader, $matches)) {
            ResponseHelper::error('Formato de token inválido', 401);
            exit;
        }

        $token = $matches[1];
        $decoded = $this->validateToken($token);

        if (!$decoded) {
            ResponseHelper::error('Token inválido o expirado', 401);
            exit;
        }

        return $decoded;
    }
}