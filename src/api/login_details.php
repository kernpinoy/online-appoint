<?php
include_once "../config/database.php";

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$username = "";
$password = "";

$data = json_decode(file_get_contents("php://input"));
$database = new Database();
$db = $database->get_connection();
$sql = "SELECT * FROM login_info WHERE username = ? AND password = ?";
$stmt = $db->prepare($sql);

if (isset($data)) {
    $username = $data->username;
    $password = $data->password;
}

$stmt->bindParam(1, $username);
$stmt->bindParam(2, $password);

if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(array("message" => "Cannot login!"));
    exit;
}

$login["body"] = array();
$rows = $stmt->fetch(PDO::FETCH_ASSOC);

if (!is_array($rows)) {
    http_response_code(500);
    echo json_encode(array("message" => "Cannot login!"));
    exit;
}

extract($rows);

// details
$details = array(
    "id" => $id,
    "username" => $username,
    "password" => $password
);
$login["auth"] = 1;

array_push($login["body"], $details);

http_response_code(201);
echo json_encode($login);
?>