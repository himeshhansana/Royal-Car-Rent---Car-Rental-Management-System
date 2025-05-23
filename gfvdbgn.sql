-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.40 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for royalcarrent
CREATE DATABASE IF NOT EXISTS `royalcarrent` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `royalcarrent`;

-- Dumping structure for table royalcarrent.activerinactivedrivers
CREATE TABLE IF NOT EXISTS `activerinactivedrivers` (
  `last_activity` text,
  `reason` text,
  `availabilty_id` int NOT NULL,
  `driver_nic` int NOT NULL,
  KEY `fk_ActiverInactiveDrivers_availabilty1_idx` (`availabilty_id`),
  KEY `fk_ActiverInactiveDrivers_driver1_idx` (`driver_nic`),
  CONSTRAINT `fk_ActiverInactiveDrivers_availabilty1` FOREIGN KEY (`availabilty_id`) REFERENCES `availabilty` (`id`),
  CONSTRAINT `fk_ActiverInactiveDrivers_driver1` FOREIGN KEY (`driver_nic`) REFERENCES `driver` (`nic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.assigned_vehicle
CREATE TABLE IF NOT EXISTS `assigned_vehicle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assign_date` date DEFAULT NULL,
  `assign_end_date` date DEFAULT NULL,
  `driver_nic` int NOT NULL,
  `vehicle_licene_no` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_assigned_vehicle_driver1_idx` (`driver_nic`),
  KEY `fk_assigned_vehicle_vehicle1_idx` (`vehicle_licene_no`),
  CONSTRAINT `fk_assigned_vehicle_driver1` FOREIGN KEY (`driver_nic`) REFERENCES `driver` (`nic`),
  CONSTRAINT `fk_assigned_vehicle_vehicle1` FOREIGN KEY (`vehicle_licene_no`) REFERENCES `vehicle` (`licene_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.availabilty
CREATE TABLE IF NOT EXISTS `availabilty` (
  `id` int NOT NULL AUTO_INCREMENT,
  `availabilty` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.cost
CREATE TABLE IF NOT EXISTS `cost` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cost_per_km` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.customer
CREATE TABLE IF NOT EXISTS `customer` (
  `nic` varchar(30) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `mobile` varchar(10) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`nic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.driver
CREATE TABLE IF NOT EXISTS `driver` (
  `nic` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `mobile` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `gender_id` int NOT NULL,
  PRIMARY KEY (`nic`),
  KEY `fk_driver_gender1_idx` (`gender_id`),
  CONSTRAINT `fk_driver_gender1` FOREIGN KEY (`gender_id`) REFERENCES `gender` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.employee
CREATE TABLE IF NOT EXISTS `employee` (
  `nic` varchar(30) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `mobile` varchar(10) DEFAULT NULL,
  `registered_date` datetime DEFAULT NULL,
  `gender_id` int NOT NULL,
  `employee_type_employee_type_id` int NOT NULL,
  PRIMARY KEY (`nic`),
  KEY `fk_employee_gender1_idx` (`gender_id`),
  KEY `fk_employee_employee_type1_idx` (`employee_type_employee_type_id`),
  CONSTRAINT `fk_employee_employee_type1` FOREIGN KEY (`employee_type_employee_type_id`) REFERENCES `employee_type` (`employee_type_id`),
  CONSTRAINT `fk_employee_gender1` FOREIGN KEY (`gender_id`) REFERENCES `gender` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.employee_type
CREATE TABLE IF NOT EXISTS `employee_type` (
  `employee_type_id` int NOT NULL AUTO_INCREMENT,
  `employee_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`employee_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.gender
CREATE TABLE IF NOT EXISTS `gender` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.maintenance
CREATE TABLE IF NOT EXISTS `maintenance` (
  `maintenance_id` int NOT NULL AUTO_INCREMENT,
  `maintenance_date` varchar(45) NOT NULL,
  `cost` double DEFAULT NULL,
  `description` text,
  `Garage_no` varchar(10) DEFAULT NULL,
  `Garage` varchar(45) DEFAULT NULL,
  `vehicle_licene_no` varchar(15) NOT NULL,
  PRIMARY KEY (`maintenance_id`),
  KEY `fk_maintenance_vehicle1_idx` (`vehicle_licene_no`),
  CONSTRAINT `fk_maintenance_vehicle1` FOREIGN KEY (`vehicle_licene_no`) REFERENCES `vehicle` (`licene_no`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.model
CREATE TABLE IF NOT EXISTS `model` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.payment
CREATE TABLE IF NOT EXISTS `payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payment_method_payment_method_id` int NOT NULL,
  `payment_date` datetime DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `payment_status_payment_status_id` int NOT NULL,
  `customer_nic` varchar(30) NOT NULL,
  `vehicle_licene_no` varchar(15) NOT NULL,
  `rental_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rent_payment_method1_idx` (`payment_method_payment_method_id`),
  KEY `fk_payment_payment_status1_idx` (`payment_status_payment_status_id`),
  KEY `fk_payment_customer1_idx` (`customer_nic`),
  KEY `fk_payment_vehicle1_idx` (`vehicle_licene_no`),
  KEY `fk_payment_rental1_idx` (`rental_id`),
  CONSTRAINT `fk_payment_customer1` FOREIGN KEY (`customer_nic`) REFERENCES `customer` (`nic`),
  CONSTRAINT `fk_payment_payment_status1` FOREIGN KEY (`payment_status_payment_status_id`) REFERENCES `payment_status` (`payment_status_id`),
  CONSTRAINT `fk_payment_rental1` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`id`),
  CONSTRAINT `fk_payment_vehicle1` FOREIGN KEY (`vehicle_licene_no`) REFERENCES `vehicle` (`licene_no`),
  CONSTRAINT `fk_rent_payment_method1` FOREIGN KEY (`payment_method_payment_method_id`) REFERENCES `payment_method` (`payment_method_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.payment_method
CREATE TABLE IF NOT EXISTS `payment_method` (
  `payment_method_id` int NOT NULL AUTO_INCREMENT,
  `payment_method_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`payment_method_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.payment_status
CREATE TABLE IF NOT EXISTS `payment_status` (
  `payment_status_id` int NOT NULL AUTO_INCREMENT,
  `payment_status_name` varchar(45) NOT NULL,
  PRIMARY KEY (`payment_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.rental
CREATE TABLE IF NOT EXISTS `rental` (
  `id` int NOT NULL AUTO_INCREMENT,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_meter` int DEFAULT NULL,
  `end_meter` int DEFAULT NULL,
  `customer_nic` varchar(30) NOT NULL,
  `vehicle_licene_no` varchar(15) NOT NULL,
  `cost_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rental_customer1_idx` (`customer_nic`),
  KEY `fk_rental_vehicle1_idx` (`vehicle_licene_no`),
  KEY `fk_rental_cost1_idx` (`cost_id`),
  CONSTRAINT `fk_rental_cost1` FOREIGN KEY (`cost_id`) REFERENCES `cost` (`id`),
  CONSTRAINT `fk_rental_customer1` FOREIGN KEY (`customer_nic`) REFERENCES `customer` (`nic`),
  CONSTRAINT `fk_rental_vehicle1` FOREIGN KEY (`vehicle_licene_no`) REFERENCES `vehicle` (`licene_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.vehicle
CREATE TABLE IF NOT EXISTS `vehicle` (
  `licene_no` varchar(15) NOT NULL,
  `model_id` int NOT NULL,
  `availabilty_id` int NOT NULL,
  `vehicle_type_id` int NOT NULL,
  `vehicle_brand_id` int NOT NULL,
  PRIMARY KEY (`licene_no`),
  KEY `fk_vehicle_model_idx` (`model_id`),
  KEY `fk_vehicle_availabilty1_idx` (`availabilty_id`),
  KEY `fk_vehicle_vehicle_type1_idx` (`vehicle_type_id`),
  KEY `fk_vehicle_vehicle_brand1_idx` (`vehicle_brand_id`),
  CONSTRAINT `fk_vehicle_availabilty1` FOREIGN KEY (`availabilty_id`) REFERENCES `availabilty` (`id`),
  CONSTRAINT `fk_vehicle_model` FOREIGN KEY (`model_id`) REFERENCES `model` (`id`),
  CONSTRAINT `fk_vehicle_vehicle_brand1` FOREIGN KEY (`vehicle_brand_id`) REFERENCES `vehicle_brand` (`id`),
  CONSTRAINT `fk_vehicle_vehicle_type1` FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicle_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.vehicle_brand
CREATE TABLE IF NOT EXISTS `vehicle_brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

-- Dumping structure for table royalcarrent.vehicle_type
CREATE TABLE IF NOT EXISTS `vehicle_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
