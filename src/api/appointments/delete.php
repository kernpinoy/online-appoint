<?php
include_once "../../config/database.php";
include_once "../../class/appointments.php";

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$database = new Database();
$db = $database->get_connection();
$appointments = new Appointment($db);
$data = json_decode(file_get_contents("php://input"));

$appointments->id = $data->id;

if (empty($appointments->id)) {
    http_response_code(400);
    echo json_encode(array("message" => "Appointment ID is required."));
} else if ($appointments->delete_appointment()) {
    http_response_code(200);
    echo json_encode(array("message" => "Appointment deleted successfully."));
} else {
    http_response_code(404);
    echo json_encode(array("message" => "Appointment not found or cannot be deleted."));
}
?>