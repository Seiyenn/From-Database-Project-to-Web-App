-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.3 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for parsu_smart
CREATE DATABASE IF NOT EXISTS `parsu_smart` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `parsu_smart`;

-- Dumping structure for table parsu_smart.academic_term
CREATE TABLE IF NOT EXISTS `academic_term` (
  `term_id` int NOT NULL AUTO_INCREMENT,
  `academic_year` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `semester` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  PRIMARY KEY (`term_id`),
  UNIQUE KEY `academic_year` (`academic_year`,`semester`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.academic_term: ~1 rows (approximately)
INSERT INTO `academic_term` (`term_id`, `academic_year`, `semester`, `start_date`, `end_date`) VALUES
	(1, '2026-2027', '1st Semester', '2026-08-01', '2026-12-31');

-- Dumping structure for table parsu_smart.applications
CREATE TABLE IF NOT EXISTS `applications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `scholarship_id` int NOT NULL,
  `term_id` int NOT NULL,
  `assigned_staff_id` int DEFAULT NULL,
  `submission_date` datetime NOT NULL,
  `current_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`application_id`),
  KEY `student_id` (`student_id`),
  KEY `scholarship_id` (`scholarship_id`),
  KEY `term_id` (`term_id`),
  KEY `assigned_staff_id` (`assigned_staff_id`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`scholarship_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `applications_ibfk_3` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`term_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `applications_ibfk_4` FOREIGN KEY (`assigned_staff_id`) REFERENCES `osas_staff` (`staff_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.applications: ~2 rows (approximately)
INSERT INTO `applications` (`application_id`, `student_id`, `scholarship_id`, `term_id`, `assigned_staff_id`, `submission_date`, `current_status`) VALUES
	(1, 1, 1, 1, 1, '2026-11-19 19:53:05', 'Under Review'),
	(2, 1, 2, 1, 1, '2026-11-19 19:53:05', 'Under Review');

-- Dumping structure for table parsu_smart.application_status_history
CREATE TABLE IF NOT EXISTS `application_status_history` (
  `application_id` int NOT NULL,
  `history_no` int NOT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci,
  `updated_by` int NOT NULL,
  `status_date` datetime NOT NULL,
  PRIMARY KEY (`application_id`,`history_no`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `application_status_history_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `application_status_history_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `osas_staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.application_status_history: ~4 rows (approximately)
INSERT INTO `application_status_history` (`application_id`, `history_no`, `status`, `remarks`, `updated_by`, `status_date`) VALUES
	(1, 1, 'Pending', 'Application submitted successfully', 1, '2026-11-19 19:54:58'),
	(1, 2, 'Under Review', 'Documents are being checked', 1, '2026-11-19 19:54:58'),
	(2, 1, 'Pending', 'Application submitted successfully', 1, '2026-11-19 19:54:58'),
	(2, 2, 'Under Review', 'Documents are being checked', 1, '2026-11-19 19:54:58');

-- Dumping structure for table parsu_smart.osas_staff
CREATE TABLE IF NOT EXISTS `osas_staff` (
  `staff_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.osas_staff: ~1 rows (approximately)
INSERT INTO `osas_staff` (`staff_id`, `first_name`, `last_name`, `position`, `email`, `username`, `password_hash`, `role`) VALUES
	(1, 'Alex', 'Reyes', 'Scholarship Coordinator', 'alex.reyes@example.com', 'alexreyes', 'sample_hash_123', 'Staff');

-- Dumping structure for table parsu_smart.requirement_type
CREATE TABLE IF NOT EXISTS `requirement_type` (
  `requirement_id` int NOT NULL AUTO_INCREMENT,
  `requirement_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`requirement_id`),
  UNIQUE KEY `requirement_name` (`requirement_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.requirement_type: ~3 rows (approximately)
INSERT INTO `requirement_type` (`requirement_id`, `requirement_name`, `description`) VALUES
	(1, 'Certificate of Registration', 'Proof of current enrollment'),
	(2, 'Grades or Report of Grades', 'Academic record of the student'),
	(3, 'Certificate of Indigency', 'Proof of financial need');

-- Dumping structure for table parsu_smart.scholarships
CREATE TABLE IF NOT EXISTS `scholarships` (
  `scholarship_id` int NOT NULL AUTO_INCREMENT,
  `scholarship_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `eligibility_criteria` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `application_start_date` date NOT NULL,
  `application_end_date` date NOT NULL,
  PRIMARY KEY (`scholarship_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.scholarships: ~2 rows (approximately)
INSERT INTO `scholarships` (`scholarship_id`, `scholarship_name`, `description`, `eligibility_criteria`, `application_start_date`, `application_end_date`) VALUES
	(1, 'Academic Scholarship', 'Sample scholarship for academic performance', 'Open', '2023-07-01', '2023-08-01'),
	(2, 'Student Assistance Scholarship', 'Sample scholarship for student assistance', 'Open', '2023-07-15', '2023-08-10');

-- Dumping structure for table parsu_smart.scholarship_requirement
CREATE TABLE IF NOT EXISTS `scholarship_requirement` (
  `scholarship_id` int NOT NULL,
  `requirement_id` int NOT NULL,
  `is_mandatory` tinyint(1) NOT NULL,
  PRIMARY KEY (`scholarship_id`,`requirement_id`),
  KEY `requirement_id` (`requirement_id`),
  CONSTRAINT `scholarship_requirement_ibfk_1` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`scholarship_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scholarship_requirement_ibfk_2` FOREIGN KEY (`requirement_id`) REFERENCES `requirement_type` (`requirement_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.scholarship_requirement: ~4 rows (approximately)
INSERT INTO `scholarship_requirement` (`scholarship_id`, `requirement_id`, `is_mandatory`) VALUES
	(1, 1, 1),
	(1, 2, 1),
	(2, 1, 1),
	(2, 3, 1);

-- Dumping structure for table parsu_smart.students
CREATE TABLE IF NOT EXISTS `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `student_number` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `course` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year_level` int NOT NULL,
  `registration_date` date DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `student_number` (`student_number`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `chk_year_level` CHECK ((`year_level` between 1 and 6))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.students: ~3 rows (approximately)
INSERT INTO `students` (`student_id`, `student_number`, `first_name`, `middle_name`, `last_name`, `email`, `contact_number`, `course`, `year_level`, `registration_date`, `created_date`) VALUES
	(1, 'SAMPLE-2026-001', 'Alex', NULL, 'Reyes', 'alex.reyes@example.com', NULL, 'BS Information Technology', 2, NULL, '2026-10-29 06:11:27'),
	(2, 'SAMPLE-2026-002', 'Jose', NULL, 'Fortuna', 'jamie.santos@example.com', NULL, 'BS Information Technology', 3, NULL, '2026-10-29 06:11:27'),
	(3, '2026-0001', 'Jamie', 'Santos', 'Cruz', 'jamie.cruz@example.com', '09123456789', 'BS Information Technology', 2, '2026-08-01', '2026-11-19 11:46:28');

-- Dumping structure for table parsu_smart.submitted_document
CREATE TABLE IF NOT EXISTS `submitted_document` (
  `document_id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `requirement_id` int NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `submission_date` datetime NOT NULL,
  `verification_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `verified_by` int DEFAULT NULL,
  PRIMARY KEY (`document_id`),
  KEY `application_id` (`application_id`),
  KEY `requirement_id` (`requirement_id`),
  KEY `verified_by` (`verified_by`),
  CONSTRAINT `submitted_document_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `submitted_document_ibfk_2` FOREIGN KEY (`requirement_id`) REFERENCES `requirement_type` (`requirement_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `submitted_document_ibfk_3` FOREIGN KEY (`verified_by`) REFERENCES `osas_staff` (`staff_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table parsu_smart.submitted_document: ~4 rows (approximately)
INSERT INTO `submitted_document` (`document_id`, `application_id`, `requirement_id`, `file_name`, `submission_date`, `verification_status`, `verified_by`) VALUES
	(1, 1, 1, 'COR_Jamie.pdf', '2026-11-19 19:53:51', 'Verified', 1),
	(2, 1, 2, 'Grades_Jamie.pdf', '2026-11-19 19:53:51', 'Pending', NULL),
	(3, 2, 1, 'COR_Jamie.pdf', '2026-11-19 19:53:51', 'Verified', 1),
	(4, 2, 3, 'Indigency_Jamie.pdf', '2026-11-19 19:53:51', 'Pending', NULL);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
