-- Hausarzt-Informationssystem | Datenbankstruktur
-- MySQL 8.0.16+ | InnoDB | UTF8MB4
-- 21 Tabellen in 2 Schemas; keine Beispieldaten.
-- ACHTUNG: CREATE DATABASE / CREATE TABLE veraendern den verbundenen Server.
-- Zuerst in MySQL Workbench pruefen; erst danach bewusst ausfuehren.
-- Kein DROP DATABASE / DROP TABLE enthalten.
-- Fachliche Regeln (Rollen, Zeitabfolge, Berichtsvollstaendigkeit,
-- Vermeidung doppelter Laborparameter, aktive Katalogeintraege) in Python pruefen.

CREATE DATABASE IF NOT EXISTS `patient_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `medical_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ==================== patient_db (10 Tabellen) ====================
CREATE TABLE `patient_db`.`Sex` (
  `sex_id` INT NOT NULL AUTO_INCREMENT,
  `designation` VARCHAR(50) NOT NULL,
  `code` VARCHAR(20) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`sex_id`), UNIQUE KEY `uq_sex_code` (`code`)
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`Religion` (
  `religion_id` INT NOT NULL AUTO_INCREMENT,
  `designation` VARCHAR(150) NOT NULL,
  `code` VARCHAR(30) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`religion_id`),
  UNIQUE KEY `uq_religion_designation` (`designation`),
  UNIQUE KEY `uq_religion_code` (`code`)
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`InsuranceProvider` (
  `provider_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`provider_id`), UNIQUE KEY `uq_insurance_provider_name` (`name`)
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`UserRole` (
  `role_id` INT NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(50) NOT NULL,
  `designation` VARCHAR(100) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`role_id`), UNIQUE KEY `uq_user_role_name` (`role_name`)
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`Patient` (
  `patient_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(50) NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `second_first_name` VARCHAR(150) NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `sex_id` INT NOT NULL,
  `religion_id` INT NOT NULL,
  `phone_number` VARCHAR(30) NULL,
  `email` VARCHAR(254) NULL,
  `social_security_number` CHAR(10) NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `uq_patient_svnr` (`social_security_number`),
  CONSTRAINT `chk_patient_svnr_format` CHECK (`social_security_number` IS NULL OR `social_security_number` REGEXP '^[0-9]{10}$'),
  CONSTRAINT `fk_patient_sex` FOREIGN KEY (`sex_id`) REFERENCES `patient_db`.`Sex` (`sex_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_patient_religion` FOREIGN KEY (`religion_id`) REFERENCES `patient_db`.`Religion` (`religion_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`Address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `street` VARCHAR(150) NOT NULL,
  `house_number` VARCHAR(20) NOT NULL,
  `postal_code` VARCHAR(20) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`address_id`),
  UNIQUE KEY `uq_address_patient` (`patient_id`),
  CONSTRAINT `fk_address_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient_db`.`Patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`Insurance` (
  `insurance_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `provider_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`insurance_id`),
  UNIQUE KEY `uq_insurance_patient` (`patient_id`),
  CONSTRAINT `fk_insurance_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient_db`.`Patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_insurance_provider` FOREIGN KEY (`provider_id`) REFERENCES `patient_db`.`InsuranceProvider` (`provider_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`User` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `title` VARCHAR(50) NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `role_id` INT NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_user_username` (`username`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `patient_db`.`UserRole` (`role_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `patient_db`.`ServiceCatalog` (
  `service_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB;

-- ServiceRecord wird spaeter erstellt, da es auf medical_db.Encounter verweist.

-- ==================== medical_db (11 Tabellen) ====================
CREATE TABLE `medical_db`.`MedicalSpecialty` (
  `specialty_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`specialty_id`), UNIQUE KEY `uq_specialty_name` (`name`)
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`LabParameter` (
  `parameter_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `unit` VARCHAR(30) NOT NULL,
  `reference_range` VARCHAR(100) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`parameter_id`), UNIQUE KEY `uq_lab_parameter_name` (`name`)
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`LabPanel` (
  `panel_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`panel_id`), UNIQUE KEY `uq_lab_panel_name` (`name`)
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`Encounter` (
  `encounter_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `doctor_user_id` INT NOT NULL,
  `created_by_user_id` INT NOT NULL,
  `encounter_date` DATETIME NOT NULL,
  PRIMARY KEY (`encounter_id`),
  CONSTRAINT `fk_encounter_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient_db`.`Patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_encounter_doctor` FOREIGN KEY (`doctor_user_id`) REFERENCES `patient_db`.`User` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_encounter_creator` FOREIGN KEY (`created_by_user_id`) REFERENCES `patient_db`.`User` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- ==================== patient_db.ServiceRecord (abhaengig von Encounter) ====================
CREATE TABLE `patient_db`.`ServiceRecord` (
  `record_id` INT NOT NULL AUTO_INCREMENT,
  `encounter_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `performed_at` DATETIME NOT NULL,
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `uq_service_record_encounter_service` (`encounter_id`, `service_id`),
  CONSTRAINT `fk_service_record_encounter` FOREIGN KEY (`encounter_id`) REFERENCES `medical_db`.`Encounter` (`encounter_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_service_record_service` FOREIGN KEY (`service_id`) REFERENCES `patient_db`.`ServiceCatalog` (`service_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- ==================== medical_db (Fortsetzung) ====================
CREATE TABLE `medical_db`.`LabOrder` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `encounter_id` INT NOT NULL,
  `ordered_by_user_id` INT NOT NULL,
  `order_date` DATETIME NOT NULL,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uq_lab_order_encounter` (`encounter_id`),
  CONSTRAINT `fk_lab_order_encounter` FOREIGN KEY (`encounter_id`) REFERENCES `medical_db`.`Encounter` (`encounter_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_lab_order_user` FOREIGN KEY (`ordered_by_user_id`) REFERENCES `patient_db`.`User` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`LabPanelParameter` (
  `panel_id` INT NOT NULL,
  `parameter_id` INT NOT NULL,
  PRIMARY KEY (`panel_id`, `parameter_id`),
  CONSTRAINT `fk_panel_parameter_panel` FOREIGN KEY (`panel_id`) REFERENCES `medical_db`.`LabPanel` (`panel_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_panel_parameter_parameter` FOREIGN KEY (`parameter_id`) REFERENCES `medical_db`.`LabParameter` (`parameter_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`LabOrderPanel` (
  `order_id` INT NOT NULL,
  `panel_id` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`order_id`),
  CONSTRAINT `fk_order_panel_order` FOREIGN KEY (`order_id`) REFERENCES `medical_db`.`LabOrder` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_panel_panel` FOREIGN KEY (`panel_id`) REFERENCES `medical_db`.`LabPanel` (`panel_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`LabOrderParameter` (
  `order_id` INT NOT NULL,
  `parameter_id` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`order_id`, `parameter_id`),
  CONSTRAINT `fk_order_parameter_order` FOREIGN KEY (`order_id`) REFERENCES `medical_db`.`LabOrder` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_parameter_parameter` FOREIGN KEY (`parameter_id`) REFERENCES `medical_db`.`LabParameter` (`parameter_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`LabResult` (
  `result_id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `parameter_id` INT NOT NULL,
  `value` DECIMAL(12,4) NOT NULL,
  `unit` VARCHAR(30) NOT NULL,
  `reference_range` VARCHAR(100) NULL,
  `entered_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`result_id`),
  UNIQUE KEY `uq_lab_result_order_parameter` (`order_id`, `parameter_id`),
  CONSTRAINT `fk_lab_result_order` FOREIGN KEY (`order_id`) REFERENCES `medical_db`.`LabOrder` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_lab_result_parameter` FOREIGN KEY (`parameter_id`) REFERENCES `medical_db`.`LabParameter` (`parameter_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`MedicalReport` (
  `report_id` INT NOT NULL AUTO_INCREMENT,
  `encounter_id` INT NOT NULL,
  `doctor_user_id` INT NOT NULL,
  `assessment` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`report_id`),
  UNIQUE KEY `uq_medical_report_encounter` (`encounter_id`),
  CONSTRAINT `fk_medical_report_encounter` FOREIGN KEY (`encounter_id`) REFERENCES `medical_db`.`Encounter` (`encounter_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_medical_report_doctor` FOREIGN KEY (`doctor_user_id`) REFERENCES `patient_db`.`User` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_db`.`Referral` (
  `referral_id` INT NOT NULL AUTO_INCREMENT,
  `encounter_id` INT NOT NULL,
  `specialty_id` INT NOT NULL,
  `reason` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`referral_id`),
  CONSTRAINT `fk_referral_encounter` FOREIGN KEY (`encounter_id`) REFERENCES `medical_db`.`Encounter` (`encounter_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_referral_specialty` FOREIGN KEY (`specialty_id`) REFERENCES `medical_db`.`MedicalSpecialty` (`specialty_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- Ende der Struktur. Referenzdaten und Testdaten werden separat angelegt.
