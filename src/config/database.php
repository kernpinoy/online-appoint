<?php
    class Database {
        private string $server_name = "db";
        private string $db_name = "online_appoint";
        private string $user_name = "root";
        private string $password = "root";
        public PDO $conn;

        public function get_connection() {
            try {
                $this->conn = new PDO("mysql:host=$this->server_name;dbname=$this->db_name;", $this->user_name, $this->password);
                $this->conn->exec("set names utf8");
                
            } catch (PDOException $e) {
                echo "Cannot connect to the database: ", $e->getMessage();
            }

            return $this->conn;
        }
    }
?>