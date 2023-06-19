USE `online_appoint`;

DELIMITER $$

CREATE DEFINER=`root`@`%` PROCEDURE `delete_appointment`(IN appointment_id INT)
BEGIN
    SET SQL_SAFE_UPDATES = 0;
    
    DELETE FROM `online_appoint`.`appointments` WHERE `id` = appointment_id;

    SET @count = 0;
    UPDATE `online_appoint`.`appointments` SET `id` = @count:= @count + 1;
    ALTER TABLE `online_appoint`.`appointments` AUTO_INCREMENT = 1;
    
    SET SQL_SAFE_UPDATES = 1;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `get_appointments`()
BEGIN
    SELECT * FROM `online_appoint`.`appointments`;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `get_single_appointment`(IN appointment_id INT)
BEGIN
    SELECT * FROM `online_appoint`.`appointments` WHERE `id` = appointment_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `update_appointment`(IN p_appointment_id INT, IN p_full_name VARCHAR(100), IN p_office_to_visit VARCHAR(50), IN p_person_to_visit VARCHAR(50), IN p_purpose VARCHAR(50), IN p_with_vehicle INT, IN p_plate_num VARCHAR(50), IN p_time_of_visit VARCHAR(100), IN p_email_address VARCHAR(50))
BEGIN
    UPDATE `online_appoint`.`appointments`
    SET `full_name` = p_full_name,
        `office_to_visit` = p_office_to_visit,
        `person_to_visit` = p_person_to_visit,
        `purpose` = p_purpose,
        `with_vehicle` = p_with_vehicle,
        `plate_num` = p_plate_num,
        `time_of_visit` = p_time_of_visit,
        `email_address` = p_email_address
    WHERE `id` = p_appointment_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `insert_appointment`(IN p_full_name VARCHAR(100), IN p_office_to_visit VARCHAR(50), IN p_person_to_visit VARCHAR(50), IN p_purpose VARCHAR(50), IN p_with_vehicle INT, IN p_plate_num VARCHAR(50), IN p_time_of_visit VARCHAR(100), IN p_email_address VARCHAR(50))
BEGIN
    DECLARE last_id INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error occurred during insertion
        SET last_id = 0;
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Failed to insert appointment.';
    END;

    START TRANSACTION;
    
    -- Insert the appointment
    INSERT INTO `online_appoint`.`appointments` (`full_name`, `office_to_visit`, `person_to_visit`, `purpose`, `with_vehicle`, `plate_num`, `time_of_visit`, `email_address`)
    VALUES (p_full_name, p_office_to_visit, p_person_to_visit, p_purpose, p_with_vehicle, p_plate_num, p_time_of_visit, p_email_address);
    
    -- Get the last inserted ID
    SET last_id = LAST_INSERT_ID();

    -- Check if an error occurred during insertion
    IF last_id = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Failed to insert appointment.';
    END IF;

    -- Commit the transaction
    COMMIT;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `car_count`()
BEGIN
	SELECT 
		COUNT(`with_vehicle`) AS vehicle_num
	FROM
		`online_appoint`.`appointments`
	WHERE
		`with_vehicle` = 1;
END$$

CREATE PROCEDURE `create_login`(IN p_username VARCHAR(50), IN p_password VARCHAR(50))
BEGIN
    INSERT INTO `login` (`username`, `password`)
    VALUES (p_username, p_password);
END $$

CREATE PROCEDURE `get_login_by_username`(IN p_username VARCHAR(50))
BEGIN
    SELECT * FROM `login` WHERE `username` = p_username;
END $$

CREATE PROCEDURE `update_login_password`(IN p_username VARCHAR(50), IN p_new_password VARCHAR(50))
BEGIN
    UPDATE `login` SET `password` = p_new_password WHERE `username` = p_username;
END $$

CREATE PROCEDURE `delete_login_by_username`(IN p_username VARCHAR(50))
BEGIN
    DELETE FROM `login` WHERE `username` = p_username;
END $$

DELIMITER ;