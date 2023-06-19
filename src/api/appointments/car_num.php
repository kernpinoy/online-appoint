<?php
include_once "../../config/database.php";
include_once "../../class/appointments.php";

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$database = new Database();
$db = $database->get_connection();
$appointments = new Appointment($db);

http_response_code(201);
echo json_encode(array("vehicle_count" => $appointments->car_count()));
?>