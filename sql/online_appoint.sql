-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db:3306
-- Generation Time: Jun 20, 2023 at 05:51 AM
-- Server version: 8.0.33
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `online_appoint`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`%` PROCEDURE `car_count` ()   BEGIN
	SELECT 
		COUNT(`with_vehicle`) AS vehicle_num
	FROM
		`online_appoint`.`appointments`
	WHERE
		`with_vehicle` = 1;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `create_login` (IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(50))   BEGIN
    INSERT INTO `login` (`username`, `password`)
    VALUES (p_username, p_password);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `delete_appointment` (IN `appointment_id` INT)   BEGIN
    SET SQL_SAFE_UPDATES = 0;
    
    DELETE FROM `online_appoint`.`appointments` WHERE `id` = appointment_id;

    SET @count = 0;
    UPDATE `online_appoint`.`appointments` SET `id` = @count:= @count + 1;
    ALTER TABLE `online_appoint`.`appointments` AUTO_INCREMENT = 1;
    
    SET SQL_SAFE_UPDATES = 1;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `delete_login_by_username` (IN `p_username` VARCHAR(50))   BEGIN
    DELETE FROM `login` WHERE `username` = p_username;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `get_appointments` ()   BEGIN
    SELECT * FROM `online_appoint`.`appointments`;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `get_login_by_username` (IN `p_username` VARCHAR(50))   BEGIN
    SELECT * FROM `login` WHERE `username` = p_username;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `get_single_appointment` (IN `appointment_id` INT)   BEGIN
    SELECT * FROM `online_appoint`.`appointments` WHERE `id` = appointment_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `insert_appointment` (IN `p_full_name` VARCHAR(100), IN `p_office_to_visit` VARCHAR(50), IN `p_person_to_visit` VARCHAR(50), IN `p_purpose` VARCHAR(50), IN `p_with_vehicle` INT, IN `p_plate_num` VARCHAR(50), IN `p_time_of_visit` VARCHAR(100), IN `p_email_address` VARCHAR(50))   BEGIN
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

CREATE DEFINER=`root`@`%` PROCEDURE `update_appointment` (IN `p_appointment_id` INT, IN `p_full_name` VARCHAR(100), IN `p_office_to_visit` VARCHAR(50), IN `p_person_to_visit` VARCHAR(50), IN `p_purpose` VARCHAR(50), IN `p_with_vehicle` INT, IN `p_plate_num` VARCHAR(50), IN `p_time_of_visit` VARCHAR(100), IN `p_email_address` VARCHAR(50))   BEGIN
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

CREATE DEFINER=`root`@`%` PROCEDURE `update_login_password` (IN `p_username` VARCHAR(50), IN `p_new_password` VARCHAR(50))   BEGIN
    UPDATE `login` SET `password` = p_new_password WHERE `username` = p_username;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `office_to_visit` varchar(50) NOT NULL,
  `person_to_visit` varchar(50) NOT NULL,
  `purpose` varchar(50) NOT NULL,
  `with_vehicle` int NOT NULL,
  `plate_num` varchar(50) NOT NULL,
  `time_of_visit` varchar(100) NOT NULL,
  `email_address` varchar(50) NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `login_info`
--

CREATE TABLE `login_info` (
  `id` int NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `login_info`
--

INSERT INTO `login_info` (`id`, `username`, `password`) VALUES
(1, 'slsu', 'slsu');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_full_name` (`full_name`),
  ADD UNIQUE KEY `unique_email` (`email_address`);

--
-- Indexes for table `login_info`
--
ALTER TABLE `login_info`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login_info`
--
ALTER TABLE `login_info`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
