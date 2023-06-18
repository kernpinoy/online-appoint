-- create root user and grant rights
CREATE USER 'root' IDENTIFIED BY 'root';
GRANT ALL ON *.* TO 'root';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';

-- Create schema for the appointment
CREATE SCHEMA `online_appoint`;

USE `online_appoint`;

CREATE TABLE `appointments` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `full_name` VARCHAR(100) NOT NULL,
    `office_to_visit` VARCHAR(50) NOT NULL,
    `person_to_visit` VARCHAR(50) NOT NULL,
    `with_vehicle` INT NOT NULL,
    `plate_num` VARCHAR(50) NOT NULL,
    `time_of_visit` VARCHAR(100) NOT NULL,
    `email_address` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`id`),
    CHECK (`full_name` <> ''),
    CHECK (`office_to_visit` <> ''),
    CHECK (`person_to_visit` <> ''),
    CHECK (`with_vehicle` IN (0, 1)),
    CHECK (`plate_num` <> ''),
    CHECK (`email_address` <> ''),
    CHECK (`time_of_visit` <> ''),
    CONSTRAINT `unique_full_name` UNIQUE (`full_name`),
    CONSTRAINT `unique_email` UNIQUE (`email_address`),
    CONSTRAINT `unique_plate_num` UNIQUE (`plate_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create stored procedure for the appointments table
DELIMITER //

USE `online_appoint` //

CREATE PROCEDURE `delete_appointment` (IN appointment_id INT)
BEGIN
    SET SQL_SAFE_UPDATES = 0;
    
    DELETE FROM `online_appoint`.`appointments` WHERE `id` = appointment_id;

    SET @count = 0;
    UPDATE `online_appoint`.`appointments` SET `id` = @count:= @count + 1;
    ALTER TABLE `online_appoint`.`appointments` AUTO_INCREMENT = 1;
    
    SET SQL_SAFE_UPDATES = 1;
END //

CREATE PROCEDURE `get_appointments` ()
BEGIN
    SELECT * FROM `online_appoint`.`appointments`;
END //

CREATE PROCEDURE `get_single_appointment` (IN appointment_id INT)
BEGIN
    SELECT * FROM `online_appoint`.`appointments` WHERE `id` = appointment_id;
END //

CREATE PROCEDURE `insert_appointment` (IN p_full_name VARCHAR(100), IN p_office_to_visit VARCHAR(50), IN p_person_to_visit VARCHAR(50), IN p_with_vehicle INT, IN p_plate_num VARCHAR(50), IN p_time_of_visit VARCHAR(100), IN p_email_address VARCHAR(50))
BEGIN
    INSERT INTO `online_appoint`.`appointments` (`full_name`, `office_to_visit`, `person_to_visit`, `with_vehicle`, `plate_num`, `time_of_visit`, `email_address`)
    VALUES (p_full_name, p_office_to_visit, p_person_to_visit, p_with_vehicle, p_plate_num, p_time_of_visit, p_email_address);
END //

CREATE PROCEDURE `update_appointment` (IN p_appointment_id INT, IN p_full_name VARCHAR(100), IN p_office_to_visit VARCHAR(50), IN p_person_to_visit VARCHAR(50), IN p_with_vehicle INT, IN p_plate_num VARCHAR(50), IN p_time_of_visit VARCHAR(100), IN p_email_address VARCHAR(50))
BEGIN
    UPDATE `online_appoint`.`appointments`
    SET `full_name` = p_full_name,
        `office_to_visit` = p_office_to_visit,
        `person_to_visit` = p_person_to_visit,
        `with_vehicle` = p_with_vehicle,
        `plate_num` = p_plate_num,
        `time_of_visit` = p_time_of_visit,
        `email_address` = p_email_address
    WHERE `id` = p_appointment_id;
END //

DELIMITER ;
