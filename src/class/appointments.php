<?php
class Appointment
{
    private PDO $conn;
    
    public $id;
    public $full_name;
    public $office_to_visit;
    public $person_to_visit;
    public $with_vehicle;
    public $plate_num;
    public $time_of_visit;
    public $email_address;

    public function __construct(PDO $db)
    {
        $this->conn = $db;
    }

    public function get_appointments()
    {
        $sql = "CALL get_appointments()";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();

        return $stmt;
    }

    public function get_single_appointment()
    {
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
                $this->with_vehicle = $data_row['with_vehicle'];
                $this->plate_num = $data_row['plate_num'];
                $this->time_of_visit = $data_row['time_of_visit'];
                $this->email_address = $data_row['email_address'];
            } else {
                $this->id = null;
                $this->full_name = null;
                $this->office_to_visit = null;
                $this->person_to_visit = null;
                $this->with_vehicle = null;
                $this->plate_num = null;
                $this->time_of_visit = null;
                $this->email_address = null;
            }
        }
    }

    public function insert_appointment()
    {
        $sql = "CALL insert_appointment(?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->conn->prepare($sql);

        $this->full_name = htmlspecialchars(strip_tags($this->full_name));
        $this->office_to_visit = htmlspecialchars(strip_tags($this->office_to_visit));
        $this->person_to_visit = htmlspecialchars(strip_tags($this->person_to_visit));
        $this->with_vehicle = htmlspecialchars(strip_tags($this->with_vehicle));
        $this->plate_num = htmlspecialchars(strip_tags($this->plate_num));
        $this->time_of_visit = htmlspecialchars(strip_tags($this->time_of_visit));
        $this->email_address = htmlspecialchars(strip_tags($this->email_address));

        $stmt->bindParam(1, $this->full_name);
        $stmt->bindParam(2, $this->office_to_visit);
        $stmt->bindParam(3, $this->person_to_visit);
        $stmt->bindParam(4, $this->with_vehicle);
        $stmt->bindParam(5, $this->plate_num);
        $stmt->bindParam(6, $this->time_of_visit);
        $stmt->bindParam(7, $this->email_address);

        if ($stmt->execute()) {
            return true;
        }

        return false;
    }

    public function update_appointment()
    {
        $sql = "CALL update_appointment(?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->conn->prepare($sql);

        $this->id = htmlspecialchars(strip_tags($this->id));
        $this->full_name = htmlspecialchars(strip_tags($this->full_name));
        $this->office_to_visit = htmlspecialchars(strip_tags($this->office_to_visit));
        $this->person_to_visit = htmlspecialchars(strip_tags($this->person_to_visit));
        $this->with_vehicle = htmlspecialchars(strip_tags($this->with_vehicle));
        $this->plate_num = htmlspecialchars(strip_tags($this->plate_num));
        $this->time_of_visit = htmlspecialchars(strip_tags($this->time_of_visit));
        $this->email_address = htmlspecialchars(strip_tags($this->email_address));

        $stmt->bindParam(1, $this->id);
        $stmt->bindParam(2, $this->full_name);
        $stmt->bindParam(3, $this->office_to_visit);
        $stmt->bindParam(4, $this->person_to_visit);
        $stmt->bindParam(5, $this->with_vehicle);
        $stmt->bindParam(6, $this->plate_num);
        $stmt->bindParam(7, $this->time_of_visit);
        $stmt->bindParam(8, $this->email_address);

        if ($stmt->execute()) {
            return true;
        }

        return false;
    }

    public function delete_appointment()
    {
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
