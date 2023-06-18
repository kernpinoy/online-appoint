<?php
include_once "../config/database.php";
include_once "../class/appointments.php";

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$database = new Database();
$db = $database->get_connection();
$appointments = new Appointment($db);
$stmt = $appointments->get_appointments();
$appointment_count = $stmt->rowCount();

// Construct the JSON
if ($appointment_count > 0) {
    $appointments_arr = array();
    $appointments_arr["body"] = array();
    $appointments_arr["appointment_count"] = $appointment_count;

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);
        $appointment_item = array(
            "id" => $id,
            "full_name" => $full_name,
            "office_to_visit" => $office_to_visit,
            "person_to_visit" => $person_to_visit,
            "with_vehicle" => $with_vehicle,
            "plate_num" => $plate_num,
            "time_of_visit" => $time_of_visit,
            "email_address" => $email_address
        );
        array_push($appointments_arr["body"], $appointment_item);
    }

    http_response_code(200);
    echo json_encode($appointments_arr);
} else {
    http_response_code(404);

    echo json_encode(
        array("message" => "No appointments found.")
    );
}
?>
