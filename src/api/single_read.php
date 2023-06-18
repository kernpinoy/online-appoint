<?php
include_once '../config/database.php';
include_once '../class/appointments.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$database = new Database();
$db = $database->get_connection();
$appointment = new Appointment($db);
$appointment->id = isset($_GET['id']) ? $_GET['id'] : die();

$appointment->get_single_appointment();

if ($appointment->full_name != null) {
    $appointment_arr = array(
        "id" => $appointment->id,
        "full_name" => $appointment->full_name,
        "office_to_visit" => $appointment->office_to_visit,
        "person_to_visit" => $appointment->person_to_visit,
        "with_vehicle" => $appointment->with_vehicle,
        "plate_num" => $appointment->plate_num,
        "time_of_visit" => $appointment->time_of_visit,
        "email_address" => $appointment->email_address
    );

    http_response_code(200);
    echo json_encode($appointment_arr);
} else {
    http_response_code(404);
    echo json_encode(array("message" => "Appointment not found."));
}
?>
