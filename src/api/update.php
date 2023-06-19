<?php
include_once "../config/database.php";
include_once "../class/appointments.php";

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: PUT");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$database = new Database();
$db = $database->get_connection();
$appointments = new Appointment($db);
$data = json_decode(file_get_contents("php://input"));

// Map data to the appointment
$appointments->id = $data->id;
$appointments->full_name = $data->full_name;
$appointments->office_to_visit = $data->office_to_visit;
$appointments->person_to_visit = $data->person_to_visit;
$appointments->purpose = $data->purpose;
$appointments->with_vehicle = $data->with_vehicle;
$appointments->plate_num = $data->plate_num;
$appointments->time_of_visit = $data->time_of_visit;
$appointments->email_address = $data->email_address;

if (empty($appointments->id) || empty($appointments->full_name) || empty($appointments->office_to_visit) || empty($appointments->person_to_visit) || empty($appointments->purpose) || empty($appointments->with_vehicle) || empty($appointments->plate_num) || empty($appointments->time_of_visit) || empty($appointments->email_address)) {
    http_response_code(400);
    echo json_encode(array("message" => "Appointment data update failed. All fields are required."));
} else if ($appointments->update_appointment()) {
    http_response_code(200);
    echo json_encode(array("message" => "Appointment data updated successfully."));
} else {
    http_response_code(404);
    echo json_encode(array("message" => "Appointment data update failed."));
}
?>
