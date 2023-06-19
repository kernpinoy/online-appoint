<?php
class Appointment
{
    private PDO $conn;
    
    public $id;
    public $full_name;
    public $office_to_visit;
    public $person_to_visit;
    public $purpose;
    public $with_vehicle;
    public $plate_num;
    public $time_of_visit;
    public $email_address;

    public function __construct(PDO $db)
    {
        $this->conn = $db;
    }

    public function get_appointments() {
        $sql = "CALL get_appointments()";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();

        return $stmt;
    }

    public function get_single_appointment() {
        $sql = "CALL get_single_appointment(?)";
        $stmt = $this->conn->prepare($sql);
        $stmt->bindParam(1, $this->id);

        if ($stmt->execute()) {
            $data_row = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($data_row) {
                $this->id = $data_row['id'];
                $this->full_name = $data_row['full_name'];
                $this->office_to_visit = $data_row['office_to_visit'];
                $this->person_to_visit = $data_row['person_to_visit'];
                $this->purpose = $data_row['purpose'];
                $this->with_vehicle = $data_row['with_vehicle'];
                $this->plate_num = $data_row['plate_num'];
                $this->time_of_visit = $data_row['time_of_visit'];
                $this->email_address = $data_row['email_address'];
            } else {
                $this->id = null;
                $this->full_name = null;
                $this->office_to_visit = null;
                $this->person_to_visit = null;
                $this->purpose = null;
                $this->with_vehicle = null;
                $this->plate_num = null;
                $this->time_of_visit = null;
                $this->email_address = null;
            }
        }
    }

    public function insert_appointment() {
        // Check if the appointment already exists based on full_name or email_address
        $existingAppointmentSql = "SELECT COUNT(*) as count FROM `appointments` WHERE `full_name` = ? OR `email_address` = ?";
        $existingAppointmentStmt = $this->conn->prepare($existingAppointmentSql);
        $existingAppointmentStmt->bindValue(1, $this->full_name, PDO::PARAM_STR);
        $existingAppointmentStmt->bindValue(2, $this->email_address, PDO::PARAM_STR);
        $existingAppointmentStmt->execute();
        $existingAppointmentResult = $existingAppointmentStmt->fetch(PDO::FETCH_ASSOC);

        if ($existingAppointmentResult['count'] > 0) {
            throw new Exception("Appointment already exists. Duplicate insertion not allowed.");
        }

        // Perform the insertion using the stored procedure
        $insertSql = "CALL insert_appointment(?, ?, ?, ?, ?, ?, ?, ?)";
        $insertStmt = $this->conn->prepare($insertSql);
        $insertStmt->bindValue(1, $this->full_name, PDO::PARAM_STR);
        $insertStmt->bindValue(2, $this->office_to_visit, PDO::PARAM_STR);
        $insertStmt->bindValue(3, $this->person_to_visit, PDO::PARAM_STR);
        $insertStmt->bindValue(4, $this->purpose, PDO::PARAM_STR);
        $insertStmt->bindValue(5, $this->with_vehicle, PDO::PARAM_INT);
        $insertStmt->bindValue(6, $this->plate_num, PDO::PARAM_STR);
        $insertStmt->bindValue(7, $this->time_of_visit, PDO::PARAM_STR);
        $insertStmt->bindValue(8, $this->email_address, PDO::PARAM_STR);

        try {
            if ($insertStmt->execute()) {
                return true;
            } else {
                throw new Exception("Appointment creation failed.");
            }
        } catch (PDOException $e) {
            throw new Exception("Database error: " . $e->getMessage());
        }
    }

    public function update_appointment() {
        $sql = "CALL update_appointment(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->conn->prepare($sql);

        $this->id = htmlspecialchars(strip_tags($this->id));
        $this->full_name = htmlspecialchars(strip_tags($this->full_name));
        $this->office_to_visit = htmlspecialchars(strip_tags($this->office_to_visit));
        $this->person_to_visit = htmlspecialchars(strip_tags($this->person_to_visit));
        $this->purpose = htmlspecialchars(strip_tags($this->purpose));
        $this->with_vehicle = htmlspecialchars(strip_tags($this->with_vehicle));
        $this->plate_num = htmlspecialchars(strip_tags($this->plate_num));
        $this->time_of_visit = htmlspecialchars(strip_tags($this->time_of_visit));
        $this->email_address = htmlspecialchars(strip_tags($this->email_address));

        $stmt->bindParam(1, $this->id);
        $stmt->bindParam(2, $this->full_name);
        $stmt->bindParam(3, $this->office_to_visit);
        $stmt->bindParam(4, $this->person_to_visit);
        $stmt->bindParam(5, $this->purpose);
        $stmt->bindParam(6, $this->with_vehicle);
        $stmt->bindParam(7, $this->plate_num);
        $stmt->bindParam(8, $this->time_of_visit);
        $stmt->bindParam(9, $this->email_address);

        if ($stmt->execute()) {
            return true;
        }

        return false;
    }

    public function delete_appointment() {
        $sql = "CALL delete_appointment(?)";
        $stmt = $this->conn->prepare($sql);

        $this->id = htmlspecialchars(strip_tags($this->id));
        $stmt->bindParam(1, $this->id);

        if ($stmt->execute()) {
            return true;
        }

        return false;
    }
}
?>