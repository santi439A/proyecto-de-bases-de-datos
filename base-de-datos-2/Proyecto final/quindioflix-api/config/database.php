<?php

class Database
{
    private static $instance = null;
    private $conn;

    private $host = 'localhost';
    private $port = '1521';
    private $dbname = 'XEPDB1';
    private $username = 'proyecto_final';
    private $password = 'proyecto123';

    private function __construct()
    {
        $this->connect();
    }

    public static function getInstance(): Database
    {
        if (self::$instance === null) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    private function connect()
    {
        $connectionString = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={$this->host})(PORT={$this->port}))(CONNECT_DATA=(SERVICE_NAME={$this->dbname})))";
        
        $this->conn = oci_connect($this->username, $this->password, $connectionString);
        
        if (!$this->conn) {
            $e = oci_error();
            throw new Exception("Error de conexión: " . $e['message']);
        }
    }

    public function getConnection()
    {
        return $this->conn;
    }

    private function __clone() {}

    public function __wakeup()
    {
        throw new Exception("No se puede deserializar singleton");
    }
}