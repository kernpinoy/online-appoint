-- Schema for the database
CREATE SCHEMA IF NOT EXISTS `online_appoint`;

USE `online_appoint`;
CREATE TABLE `appointments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `office_to_visit` varchar(50) NOT NULL,
  `person_to_visit` varchar(50) NOT NULL,
  `purpose` varchar(50) NOT NULL,
  `with_vehicle` int NOT NULL,
  `plate_num` varchar(50) NOT NULL,
  `time_of_visit` varchar(100) NOT NULL,
  `email_address` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_full_name` (`full_name`),
  UNIQUE KEY `unique_email` (`email_address`),
  CONSTRAINT `appointments_chk_1` CHECK ((`full_name` <> _utf8mb4'')),
  CONSTRAINT `appointments_chk_2` CHECK ((`office_to_visit` <> _utf8mb4'')),
  CONSTRAINT `appointments_chk_3` CHECK ((`person_to_visit` <> _utf8mb4'')),
  CONSTRAINT `appointments_chk_4` CHECK ((`purpose` <> _utf8mb4'')),
  CONSTRAINT `appointments_chk_5` CHECK ((`with_vehicle` in (0,1))),
  CONSTRAINT `appointments_chk_6` CHECK ((`plate_num` <> _utf8mb4'')),
  CONSTRAINT `appointments_chk_7` CHECK ((`email_address` <> _utf8mb4'')),
  CONSTRAINT `appointments_chk_8` CHECK ((`time_of_visit` <> _utf8mb4''))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci