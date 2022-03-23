CREATE DATABASE  IF NOT EXISTS `unisys` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `unisys`;
-- MySQL dump 10.13  Distrib 8.0.27, for Win64 (x86_64)
--
-- Host: localhost    Database: unisys
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `Course_ID` varchar(4) NOT NULL,
  `Name` varchar(55) NOT NULL,
  `Pass` smallint DEFAULT NULL,
  PRIMARY KEY (`Course_ID`),
  CONSTRAINT `courses_chk_1` CHECK ((`Course_ID` like _utf8mb4'C___')),
  CONSTRAINT `courses_chk_2` CHECK (((`Pass` >= 30) and (`Pass` <= 75)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES ('C001','Math',40),('C002','Psychology',50),('C003','IT',45),('C004','Statistics',40),('C005','Data Processing',45);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `detailexamrecords`
--

DROP TABLE IF EXISTS `detailexamrecords`;
/*!50001 DROP VIEW IF EXISTS `detailexamrecords`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `detailexamrecords` AS SELECT 
 1 AS `Exam_ID`,
 1 AS `Score`,
 1 AS `Date`,
 1 AS `Type`,
 1 AS `Resubmission`,
 1 AS `Weight`,
 1 AS `Student_ID`,
 1 AS `Student`,
 1 AS `Course_ID`,
 1 AS `Name`,
 1 AS `Lector_ID`,
 1 AS `CONCAT(LECTORS.Name, ' ', LECTORS.Surname)`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `exams`
--

DROP TABLE IF EXISTS `exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exams` (
  `Exam_ID` varchar(7) NOT NULL,
  `Course_ID` varchar(4) NOT NULL,
  `Type` enum('lector assessment','computer assessment') DEFAULT NULL,
  `Weight` tinyint DEFAULT NULL,
  `Resubmission` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Exam_ID`),
  KEY `Course_ID` (`Course_ID`),
  CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`Course_ID`) REFERENCES `courses` (`Course_ID`),
  CONSTRAINT `exams_chk_1` CHECK ((`Exam_ID` like _utf8mb4'E______')),
  CONSTRAINT `exams_chk_2` CHECK (((`Weight` >= 0) and (`Weight` <= 50)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exams`
--

LOCK TABLES `exams` WRITE;
/*!40000 ALTER TABLE `exams` DISABLE KEYS */;
INSERT INTO `exams` VALUES ('E01c001','c001','lector assessment',15,1),('E01c002','c002','lector assessment',10,1),('E01c003','c003','computer assessment',30,1),('E01c004','c004','computer assessment',30,0),('E01c005','c005','lector assessment',20,1),('E02c001','c001','lector assessment',10,1),('E02c002','c002','computer assessment',50,0),('E02c003','c003','computer assessment',10,1),('E02c004','c004','computer assessment',30,0),('E02c005','c005','computer assessment',10,0),('E03c001','c001','computer assessment',15,0),('E03c002','c002','computer assessment',20,1),('E03c003','c003','computer assessment',15,1),('E03c004','c004','lector assessment',40,1),('E03c005','c005','computer assessment',10,0),('E04c001','c001','computer assessment',15,0),('E04c002','c002','lector assessment',20,1),('E04c003','c003','computer assessment',15,0),('E04c005','c005','computer assessment',15,0),('E05c001','c001','lector assessment',45,1),('E05c003','c003','lector assessment',30,1),('E05c005','c005','lector assessment',30,1);
/*!40000 ALTER TABLE `exams` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Exams_Insert` AFTER INSERT ON `exams` FOR EACH ROW BEGIN
	DECLARE sumweight SMALLINT;
	SET sumweight = (SELECT SUM(weight) FROM EXAMS WHERE Course_ID=new.course_id GROUP BY Course_ID);
	IF sumweight <> 100 THEN
	INSERT INTO todo (task) VALUES (concat('warning - record of exams for the course ID ',new.course_id,' incomplete. Current sum of exam weights is ',sumweight,'.'));
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Exams_Update` AFTER UPDATE ON `exams` FOR EACH ROW BEGIN
	DECLARE sumweight SMALLINT;
	SET sumweight = (SELECT SUM(weight) FROM EXAMS WHERE Course_ID=new.course_id GROUP BY Course_ID);
	IF sumweight <> 100 THEN
	INSERT INTO todo (task) VALUES (concat('warning - record of exams for the course ID ',new.course_id,' incomplete. Current sum of exam weights is ',sumweight,'.'));
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Exams_Delete` AFTER DELETE ON `exams` FOR EACH ROW BEGIN
	DECLARE sumweight SMALLINT;
	SET sumweight = (SELECT SUM(weight) FROM EXAMS WHERE Course_ID=old.course_id GROUP BY Course_ID);
	IF sumweight <> 100 THEN
	INSERT INTO todo (task) VALUES (concat('warning - record of exams for the course ID ',old.course_id,' incomplete. Current sum of exam weights is ',sumweight,'.'));
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `geographical_overview`
--

DROP TABLE IF EXISTS `geographical_overview`;
/*!50001 DROP VIEW IF EXISTS `geographical_overview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `geographical_overview` AS SELECT 
 1 AS `City`,
 1 AS `amount_of_students`,
 1 AS `percentage_of_students`,
 1 AS `average_students_score`,
 1 AS `average_studying_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `lectors`
--

DROP TABLE IF EXISTS `lectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lectors` (
  `Lector_ID` varchar(4) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Surname` varchar(55) NOT NULL,
  `Email` varchar(55) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Lector_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lectors`
--

LOCK TABLES `lectors` WRITE;
/*!40000 ALTER TABLE `lectors` DISABLE KEYS */;
INSERT INTO `lectors` VALUES ('T123','Ailidh','McMillan','am@test-uni.ac.uk','07842594356'),('T321','Jack','MacMeechan','jm@test-uni.ac.uk','07941567844'),('T666','Ronan','Rae','rr@test-uni.ac.uk','07997541854');
/*!40000 ALTER TABLE `lectors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `lectors_view`
--

DROP TABLE IF EXISTS `lectors_view`;
/*!50001 DROP VIEW IF EXISTS `lectors_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `lectors_view` AS SELECT 
 1 AS `lector_id`,
 1 AS `Name`,
 1 AS `Student`,
 1 AS `Course_ID`,
 1 AS `Course`,
 1 AS `Student_course_score`,
 1 AS `Studying_Status`,
 1 AS `email`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `records`
--

DROP TABLE IF EXISTS `records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `records` (
  `Exam_ID` varchar(7) NOT NULL,
  `Student_ID` varchar(6) NOT NULL,
  `Score` smallint DEFAULT NULL,
  `Date` date DEFAULT (curdate()),
  `Resubmission` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`Exam_ID`,`Student_ID`),
  KEY `Student_ID` (`Student_ID`),
  CONSTRAINT `records_ibfk_1` FOREIGN KEY (`Exam_ID`) REFERENCES `exams` (`Exam_ID`),
  CONSTRAINT `records_ibfk_2` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`),
  CONSTRAINT `records_chk_1` CHECK (((`Score` >= 0) and (`Score` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES ('E01c001','S15408',80,'2022-03-01',1),('E01c001','S18437',70,'2022-03-01',0),('E01c001','s18600',80,'2022-04-01',0),('E01c001','S43007',80,'2022-04-01',1),('E01c002','S38487',55,'2022-06-15',0),('E01c002','S53638',62,'2022-04-15',0),('E01c002','S58919',61,'2022-04-15',1),('E01c003','S18301',55,'2022-04-01',0),('E01c003','s43007',28,'2022-04-03',0),('E01c003','S58919',58,'2022-04-01',0),('E01c003','S79857',65,'2022-04-01',1),('E01c004','S38487',57,'2022-07-01',0),('E01c004','S67745',55,'2022-08-01',0),('E01c004','S81181',70,'2022-08-01',0),('E01c005','S14352',80,'2022-04-01',1),('E01c005','S53638',70,'2022-06-01',0),('E02c001','S15408',80,'2022-04-01',1),('E02c001','S18437',80,'2022-04-01',1),('E02c001','S43007',55,'2022-04-03',0),('E02c002','S52294',70,'2022-05-01',0),('E02c002','S72778',67,'2022-05-01',0),('E02c002','S79857',57,'2022-05-01',0),('E02c003','S18301',35,'2022-05-01',0),('E02c003','S79857',62,'2022-05-01',1),('E02c004','S38487',29,'2022-08-01',0),('E02c004','S81181',58,'2022-09-01',0),('E02c005','S14352',80,'2022-05-01',0),('E02c005','S53638',80,'2022-07-01',0),('E03c001','S18437',80,'2022-05-01',0),('E03c001','s18600',70,'2022-06-01',0),('E03c002','S52294',58,'2022-06-01',1),('E03c002','S72778',97,'2022-06-01',1),('E03c002','S79857',70,'2022-06-01',1),('E03c003','S18301',70,'2022-06-01',0),('E03c003','S79857',61,'2022-06-01',0),('E03c004','S38487',56,'2022-09-01',1),('E03c005','S14352',28,'2022-06-01',0),('E03c005','S53638',80,'2022-08-01',0),('E04c001','S15408',55,'2022-06-01',0),('E04c002','S52294',23,'2022-07-01',0),('E04c002','S72778',65,'2022-07-01',0),('E04c002','S79857',56,'2022-07-01',0),('E04c003','S58919',67,'2022-07-01',0),('E04c003','S79857',47,'2022-07-01',0),('E04c005','S14352',55,'2022-07-01',0),('E05c001','S15408',35,'2022-07-01',0),('E05c003','S58919',97,'2022-08-01',1),('E05c005','S14352',35,'2022-08-01',1);
/*!40000 ALTER TABLE `records` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `End_study_INSERT` AFTER INSERT ON `records` FOR EACH ROW BEGIN
	DECLARE vpass SMALLINT;
  	DECLARE c_id VARCHAR (4);
    DECLARE notfinished TINYINT;
    SET c_id = substring(new.exam_id,4,4);
    SET vpass = (SELECT DISTINCT Pass FROM RECORDS LEFT JOIN EXAMS ON records.exam_id=exams.exam_id LEFT JOIN COURSES ON courses.course_id=exams.course_id WHERE exams.exam_id=new.exam_id);
    IF vpass < Student_course_score(new.student_id,c_id) 
		AND Studying_Status(new.student_id,c_id)=100
		THEN UPDATE STUDYING SET End_Date = new.date WHERE (new.student_id=studying.student_id AND c_id=studying.Course_ID);
	END IF;	
    SET notfinished = (SELECT count(course_id) from STUDYING WHERE (new.student_ID=studying.student_id AND End_Date is null));
	IF notfinished=0 
		THEN UPDATE STUDENTS SET End_Date = new.date WHERE (new.student_id=students.student_id);
    END IF;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Exams_Records_Insert` AFTER INSERT ON `records` FOR EACH ROW BEGIN
	DECLARE vname VARCHAR(55);
    DECLARE vemail VARCHAR(55);
    DECLARE vpass SMALLINT;
  	SET vname = (SELECT DISTINCT Student FROM RECORDS LEFT JOIN detailexamrecords ON (detailexamrecords.student_id=records.student_id) WHERE detailexamrecords.student_id=new.student_id);
	SET vemail = (SELECT DISTINCT Email FROM RECORDS LEFT JOIN STUDENTS ON (students.student_id=records.student_id) WHERE students.student_id=new.student_id);
    SET vpass = (SELECT DISTINCT Pass FROM RECORDS LEFT JOIN EXAMS ON records.exam_id=exams.exam_id LEFT JOIN COURSES ON courses.course_id=exams.course_id WHERE exams.exam_id=new.exam_id);
    IF new.score < vpass
		AND (SELECT exams.resubmission FROM RECORDS LEFT JOIN EXAMS ON records.exam_id=exams.exam_id WHERE exams.exam_id=new.exam_id) IS TRUE
    THEN
		INSERT INTO todo (task) 
				VALUES (concat
							('MAILTO: ', vemail,
                            '; Dear ', vname,
                            ', your last result of exam ', new.exam_id,
                            ' did not meet the course pass score requirement of ', vpass,
                            '. Please choose the option to take the exam again.'));
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `End_study` AFTER UPDATE ON `records` FOR EACH ROW BEGIN
	DECLARE vpass SMALLINT;
  	DECLARE c_id VARCHAR (4);
    DECLARE notfinished TINYINT;
    SET c_id = substring(new.exam_id,4,4);
    SET vpass = (SELECT DISTINCT Pass FROM RECORDS LEFT JOIN EXAMS ON records.exam_id=exams.exam_id LEFT JOIN COURSES ON courses.course_id=exams.course_id WHERE exams.exam_id=new.exam_id);
    IF vpass < Student_course_score(new.student_id,c_id) 
		AND Studying_Status(new.student_id,c_id)=100
		THEN UPDATE STUDYING SET End_Date = new.date WHERE (new.student_id=studying.student_id AND c_id=studying.Course_ID);
	END IF;	
    SET notfinished = (SELECT count(course_id) from STUDYING WHERE (new.student_ID=studying.student_id AND End_Date is null));
	IF notfinished=0 
		THEN UPDATE STUDENTS SET End_Date = new.date WHERE (new.student_id=students.student_id);
    END IF;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `scores_of_exams`
--

DROP TABLE IF EXISTS `scores_of_exams`;
/*!50001 DROP VIEW IF EXISTS `scores_of_exams`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `scores_of_exams` AS SELECT 
 1 AS `exam_id`,
 1 AS `type`,
 1 AS `course_id`,
 1 AS `name`,
 1 AS `Average_score`,
 1 AS `amount_completed`,
 1 AS `amount_to_pass`,
 1 AS `percentage_of_resubmissions`,
 1 AS `lector`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `Student_ID` varchar(6) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Surname` varchar(55) NOT NULL,
  `Address` varchar(55) DEFAULT NULL,
  `City` varchar(20) NOT NULL,
  `Email` varchar(55) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Start_Date` date NOT NULL,
  `End_Date` date DEFAULT NULL,
  PRIMARY KEY (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES ('S14352','Paris','Long','44 South Drive','Blackpool','jgmyers@sbcglobal.net','07738184619','2021-12-06','2022-08-01'),('S15408','Jaida','Newton','86 Highfield Close','Nottingham','bolow@gmail.com','07702282693','2022-01-20',NULL),('S18301','Dakota','Hawkins','83 Preston Road','Kingston upon Hull','rkobes@att.net','','2021-10-30','2022-11-01'),('S18437','Raquel','Stone','75 The Crescent','Exeter','bahwi@yahoo.ca','07898703829','2022-02-04',NULL),('S18600','Braxton','Reynolds','88 Abbey Street','London','dmbkiwi@att.net','','2022-05-25',NULL),('S38487','Matias','Thorne','37 Manor Gardens','Portsmouth','kingma@icloud.com','','2022-05-24',NULL),('S43007','Kelsie','Sherman','35 York Close','Swansea','rbarreira@sbcglobal.net','07530732583','2021-10-16',NULL),('S52294','Serena','Mcdonald','4 The Mount','Oxford','pereinar@me.com','07702491852','2021-12-31',NULL),('S53638','Dorian','Zimmerman','85 Richmond Road','Newcastle upon Tyne','portscan@comcast.net','07305611768','2022-03-24',NULL),('S58919','Madalynn','Strickland','40 St Andrews Close','Oxford','juerd@yahoo.com','07553097985','2022-03-29',NULL),('S67745','Rey','Holland','48 Oak Avenue','London','irving@sbcglobal.net','07706493193','2022-06-21',NULL),('S72778','Ean','Ferguson','81 Shaw Street','Glasgow','vmalik@hotmail.com','07742231567','2022-02-06',NULL),('S75463','Zak','Newbie','124 Orchard Lane','Glasgow','zak@gmail.com','07478648338','2022-03-01',NULL),('S79857','Iliana','O\'Reilly','','Dundee','keijser@live.com','07333868240','2021-10-11',NULL),('S80671','Kolten','Campos','62 Mill Hill','Stoke-on-Trent','stern@optonline.net','07470400475','2022-01-26',NULL),('S81181','Aliyah','Richardson','','London','uncle@att.net','07567129596','2022-06-20',NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `IDgenerator` BEFORE INSERT ON `students` FOR EACH ROW BEGIN
    SET new.student_id = concat('S',round(rand()*100000,0));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `students_view`
--

DROP TABLE IF EXISTS `students_view`;
/*!50001 DROP VIEW IF EXISTS `students_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `students_view` AS SELECT 
 1 AS `Student_ID`,
 1 AS `Name`,
 1 AS `Course_ID`,
 1 AS `Course_Name`,
 1 AS `Pass`,
 1 AS `Student_course_score`,
 1 AS `Studying_Status`,
 1 AS `End_Date`,
 1 AS `Lectors_Details_ID_Name_Email`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `studying`
--

DROP TABLE IF EXISTS `studying`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `studying` (
  `Student_ID` varchar(6) NOT NULL,
  `Course_ID` varchar(4) NOT NULL,
  `Start_Date` date DEFAULT NULL,
  `End_Date` date DEFAULT NULL,
  KEY `Student_ID` (`Student_ID`),
  KEY `Course_ID` (`Course_ID`),
  CONSTRAINT `studying_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`Student_ID`),
  CONSTRAINT `studying_ibfk_2` FOREIGN KEY (`Course_ID`) REFERENCES `courses` (`Course_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `studying`
--

LOCK TABLES `studying` WRITE;
/*!40000 ALTER TABLE `studying` DISABLE KEYS */;
INSERT INTO `studying` VALUES ('s18600','c001','2022-03-01',NULL),('s43007','c001','2022-03-01','2022-04-03'),('s43007','c003','2022-03-01',NULL),('S80671','c002','2022-03-01',NULL),('S15408','C001','2022-02-01',NULL),('S18437','C001','2022-02-15',NULL),('S52294','C001','2022-02-01',NULL),('S72778','C002','2022-02-06',NULL),('S38487','C002','2022-05-24',NULL),('S52294','C002','2022-01-01',NULL),('S53638','C002','2022-03-24',NULL),('S58919','C002','2022-03-29',NULL),('S79857','C002','2022-01-01',NULL),('S18301','C003','2022-03-01',NULL),('S58919','C003','2022-03-29',NULL),('S79857','C003','2022-03-01',NULL),('S38487','C004','2022-05-24','2022-09-01'),('S67745','C004','2022-06-21',NULL),('S81181','C004','2022-06-20',NULL),('S14352','C005','2022-03-01','2022-08-01'),('S53638','C005','2022-03-24',NULL),('S75463','C005','2022-03-24',NULL);
/*!40000 ALTER TABLE `studying` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `success_of_courses`
--

DROP TABLE IF EXISTS `success_of_courses`;
/*!50001 DROP VIEW IF EXISTS `success_of_courses`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `success_of_courses` AS SELECT 
 1 AS `course_id`,
 1 AS `name`,
 1 AS `Lector`,
 1 AS `amount_of_students`,
 1 AS `start_date`,
 1 AS `end_date`,
 1 AS `Students_Score`,
 1 AS `Studying_Status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `success_of_lectors`
--

DROP TABLE IF EXISTS `success_of_lectors`;
/*!50001 DROP VIEW IF EXISTS `success_of_lectors`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `success_of_lectors` AS SELECT 
 1 AS `Lector_id`,
 1 AS `Name`,
 1 AS `amount_of_courses`,
 1 AS `amount_of_students`,
 1 AS `Students_Score`,
 1 AS `Studying_Status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `success_of_students`
--

DROP TABLE IF EXISTS `success_of_students`;
/*!50001 DROP VIEW IF EXISTS `success_of_students`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `success_of_students` AS SELECT 
 1 AS `STUDENT_id`,
 1 AS `Name`,
 1 AS `amount_of_courses`,
 1 AS `Students_Score`,
 1 AS `Studying_Status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `support_view`
--

DROP TABLE IF EXISTS `support_view`;
/*!50001 DROP VIEW IF EXISTS `support_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `support_view` AS SELECT 
 1 AS `Student`,
 1 AS `Course_ID`,
 1 AS `Course_Name`,
 1 AS `Student_course_score`,
 1 AS `Pass`,
 1 AS `Studying_Status`,
 1 AS `Course_status`,
 1 AS `Lector`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `teaching`
--

DROP TABLE IF EXISTS `teaching`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teaching` (
  `Lector_ID` varchar(4) NOT NULL,
  `Course_ID` varchar(4) NOT NULL,
  `Start_Date` date NOT NULL,
  `End_Date` date NOT NULL,
  KEY `Lector_ID` (`Lector_ID`),
  KEY `Course_ID` (`Course_ID`),
  CONSTRAINT `teaching_ibfk_1` FOREIGN KEY (`Lector_ID`) REFERENCES `lectors` (`Lector_ID`),
  CONSTRAINT `teaching_ibfk_2` FOREIGN KEY (`Course_ID`) REFERENCES `courses` (`Course_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teaching`
--

LOCK TABLES `teaching` WRITE;
/*!40000 ALTER TABLE `teaching` DISABLE KEYS */;
INSERT INTO `teaching` VALUES ('T123','C002','2022-01-01','2022-07-15'),('T321','C001','2022-02-01','2022-10-01'),('T321','C004','2022-02-01','2022-12-15'),('T666','C003','2022-03-01','2022-09-01'),('T666','C005','2022-03-01','2022-09-01');
/*!40000 ALTER TABLE `teaching` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `todo`
--

DROP TABLE IF EXISTS `todo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `todo` (
  `Task` text,
  `Date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `todo`
--

LOCK TABLES `todo` WRITE;
/*!40000 ALTER TABLE `todo` DISABLE KEYS */;
INSERT INTO `todo` VALUES ('warning - record of exams for the course ID c002 incomplete. Current sum of exam weights is 60.','2022-03-17 21:19:10',0),('TEXT','2022-03-17 22:44:41',0),('TEXT','2022-03-17 22:45:46',0),(NULL,'2022-03-17 22:46:08',0),(NULL,'2022-03-17 22:47:02',0),(NULL,'2022-03-17 22:51:21',0),(NULL,'2022-03-17 22:51:50',0),('45','2022-03-17 22:57:02',0),('MAILTO: rbarreira@sbcglobal.net; Dear Kelsie Sherman, your last result of exam E01c003 did not meet the course pass score requirement of 45. Please choose the option to take the exam again.','2022-03-17 22:59:51',1),('c001 course 40 pass vs score 72 status 100 NOT FINISHED 2','2022-03-18 00:10:24',1),('c001 course 40 pass vs score 71 status 100 NOT FINISHED 1','2022-03-18 00:11:18',1),('c001 course 40 pass vs score 70 status 100 NOT FINISHED 1','2022-03-18 00:12:46',1),('Run monthly report - call proc_monthly_report;','2022-03-21 13:07:55',0),('Run monthly report - call proc_monthly_report;','2022-03-21 13:13:01',0),('Run monthly report - call proc_monthly_report;','2022-03-21 13:14:01',0),('Run monthly report - call proc_monthly_report;','2022-03-21 13:15:13',0),('Run monthly report - call proc_monthly_report;','2022-03-21 13:18:44',0),('warning - record of exams for the course ID c001 incomplete. Current sum of exam weights is 40.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c001 incomplete. Current sum of exam weights is 55.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c002 incomplete. Current sum of exam weights is 80.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c003 incomplete. Current sum of exam weights is 40.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c003 incomplete. Current sum of exam weights is 55.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c003 incomplete. Current sum of exam weights is 70.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c004 incomplete. Current sum of exam weights is 30.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c004 incomplete. Current sum of exam weights is 60.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c005 incomplete. Current sum of exam weights is 20.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c005 incomplete. Current sum of exam weights is 30.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c005 incomplete. Current sum of exam weights is 40.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c005 incomplete. Current sum of exam weights is 55.','2022-03-21 17:15:59',0),('warning - record of exams for the course ID c005 incomplete. Current sum of exam weights is 85.','2022-03-21 17:15:59',0),('MAILTO: bolow@gmail.com; Dear Jaida Newton, your last result of exam E05c001 did not meet the course pass score requirement of 40. Please choose the option to take the exam again.','2022-03-21 18:01:05',1),('MAILTO: pereinar@me.com; Dear Serena Mcdonald, your last result of exam E04c002 did not meet the course pass score requirement of 50. Please choose the option to take the exam again.','2022-03-21 18:01:05',1),('MAILTO: rkobes@att.net; Dear Dakota Hawkins, your last result of exam E02c003 did not meet the course pass score requirement of 45. Please choose the option to take the exam again.','2022-03-21 18:01:05',1),('MAILTO: jgmyers@sbcglobal.net; Dear Paris Long, your last result of exam E05c005 did not meet the course pass score requirement of 45. Please choose the option to take the exam again.','2022-03-21 18:01:05',1);
/*!40000 ALTER TABLE `todo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'unisys'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `event_monthly_report` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `event_monthly_report` ON SCHEDULE EVERY 1 MONTH STARTS '2022-03-21 13:18:44' ENDS '2027-03-21 13:18:44' ON COMPLETION PRESERVE ENABLE DO BEGIN
INSERT INTO TODO (task)
VALUES ('Run monthly report - call proc_monthly_report;');
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'unisys'
--
/*!50003 DROP FUNCTION IF EXISTS `Student_course_score` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `Student_course_score`(S_ID VARCHAR (6), C_ID VARCHAR (4)) RETURNS smallint
    DETERMINISTIC
BEGIN
    DECLARE Student_course_score SMALLINT;
    SET Student_course_score = (SELECT sum(score*weight)/sum(weight) FROM DetailExamRecords WHERE Student_ID=S_ID AND Course_ID=C_ID);
	SET Student_course_score = round(Student_course_score,2);
    return (Student_course_score);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `Studying_Status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `Studying_Status`(S_ID VARCHAR (6), C_ID VARCHAR (4)) RETURNS smallint
    DETERMINISTIC
BEGIN
    DECLARE Studying_Status SMALLINT;
    DECLARE Course_Exams TINYINT;
    DECLARE Student_Exams TINYINT;
    SET Student_Exams = 0;
    SET Student_Exams = (SELECT count(Exam_ID) FROM RECORDS WHERE Student_ID=S_ID AND instr(Exam_ID, C_ID)>0);
    SET Course_Exams = (SELECT count(Exam_ID) FROM exams WHERE Course_ID=C_ID);
    IF Student_Exams = 0
    THEN SET Studying_Status = 0;
    ELSE SET Studying_Status = round(Student_Exams/Course_Exams*100, 0);
    END IF;
    return (Studying_Status);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `tablesize` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `tablesize`(tname VARCHAR (25)) RETURNS mediumint
    DETERMINISTIC
BEGIN
 DECLARE tablesize MEDIUMINT;
 SET tablesize = (SELECT table_rows  FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_SCHEMA = 'unisys' AND TABLE_NAME=tname);
 RETURN (tablesize);
 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Exams_integrity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Exams_integrity`(IN c_id VARCHAR(4))
BEGIN
	IF c_id='all'
    THEN 
		SELECT 
			distinct exams.Course_ID, 
			courses.Name,
            SUM(weight), 
            IF (SUM(weight)<100, '!warning - record incomplete', 'OK') Status
        FROM EXAMS 
			LEFT JOIN courses ON (exams.course_id=courses.course_id)
		GROUP BY Course_ID;
    ELSE 
		SELECT 
			distinct exams.Course_ID, 
			courses.Name,
            SUM(weight), 
            IF (SUM(weight)<100, '!warning - record incomplete', 'OK') Status
        FROM EXAMS 
			LEFT JOIN courses ON (exams.course_id=courses.course_id)
		WHERE exams.course_id=c_id
        GROUP BY Course_ID;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_monthly_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_monthly_report`()
BEGIN
	CALL Exams_integrity('ALL');
	SELECT task, date FROM TODO WHERE STATUS IS TRUE;
	SELECT * FROM support_view;
	CALL Uni_report();
	UPDATE TODO SET Status = FALSE WHERE task LIKE 'Run monthly report%';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Uni_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Uni_report`()
BEGIN
	DECLARE vas SMALLINT;
    DECLARE vascs SMALLINT;
    DECLARE vascsas SMALLINT;
    DECLARE vassas SMALLINT;
    DECLARE vasela SMALLINT;
    DECLARE vaseca SMALLINT;
    DECLARE vre SMALLINT;
    SET vas = (SELECT COUNT(student_id) FROM STUDENTS WHERE End_Date IS NULL);
    SET vascs = (SELECT AVG(Student_course_score) FROM students_view);
    CREATE TEMPORARY TABLE active_students  AS (    
		SELECT students_view.Student_ID, students_view.Course_ID, students_view.Student_course_score, Studying_status(students_view.Student_ID, students_view.Course_ID) ss, students.End_Date
			FROM students_view 
				LEFT JOIN students ON students.student_id=students_view.student_id);
    SET vascsas = (SELECT AVG(Student_course_score) FROM active_students WHERE End_Date IS NULL);
    SET vassas = (SELECT AVG(ss) FROM active_students WHERE End_Date IS NULL);
    DROP TEMPORARY TABLE active_students;
	SET vasela = (SELECT AVG(Score) FROM detailexamrecords WHERE Type='lector assessment');
	SET vaseca = (SELECT AVG(Score) FROM detailexamrecords WHERE Type='computer assessment');
    SET vre = 100*(SELECT AVG(Resubmission) FROM Records);
    CREATE TEMPORARY TABLE uni_report_results
		(variable VARCHAR (55), status VARCHAR (255));
	INSERT INTO uni_report_results (variable, status)
    VALUES
		('Amount of students', tablesize('Students')),
        ('Amount of active students',vas),
        ('Amount of lectors', tablesize('Lectors')),
        ('Amount of courses', tablesize('Courses')), 
        ('Average Student course score',ROUND(vascs,1)), 
        ('Average Student course score of active students',ROUND(vascsas,1)),
        ('Average Studying status of active students', CONCAT(ROUND(vassas,0),'%')),
		('Average score of exam by types', CONCAT('lector assessment - ',ROUND(vasela,1),' // computer aseessment - ',ROUND(vaseca,1))),
        ('Percentage of repeated exams', CONCAT(ROUND(vre,0),'%'));
	SELECT * FROM uni_report_results;
    DROP TABLE uni_report_results;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `detailexamrecords`
--

/*!50001 DROP VIEW IF EXISTS `detailexamrecords`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `detailexamrecords` AS select `records`.`Exam_ID` AS `Exam_ID`,`records`.`Score` AS `Score`,`records`.`Date` AS `Date`,`exams`.`Type` AS `Type`,`records`.`Resubmission` AS `Resubmission`,`exams`.`Weight` AS `Weight`,`records`.`Student_ID` AS `Student_ID`,concat(`students`.`Name`,' ',`students`.`Surname`) AS `Student`,`exams`.`Course_ID` AS `Course_ID`,`courses`.`Name` AS `Name`,`teaching`.`Lector_ID` AS `Lector_ID`,concat(`lectors`.`Name`,' ',`lectors`.`Surname`) AS `CONCAT(LECTORS.Name, ' ', LECTORS.Surname)` from (((((`records` left join `exams` on((`records`.`Exam_ID` = `exams`.`Exam_ID`))) left join `students` on((`records`.`Student_ID` = `students`.`Student_ID`))) left join `courses` on((`exams`.`Course_ID` = `courses`.`Course_ID`))) left join `teaching` on((`teaching`.`Course_ID` = `exams`.`Course_ID`))) left join `lectors` on((`lectors`.`Lector_ID` = `teaching`.`Lector_ID`))) order by `records`.`Student_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `geographical_overview`
--

/*!50001 DROP VIEW IF EXISTS `geographical_overview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `geographical_overview` AS select `students`.`City` AS `City`,count(`students`.`City`) AS `amount_of_students`,concat(round(((count(`students`.`City`) / `tablesize`('students')) * 100),1),'%') AS `percentage_of_students`,round(avg(`success_of_students`.`Students_Score`),1) AS `average_students_score`,concat(round(avg(`success_of_students`.`Studying_Status`),1),'%') AS `average_studying_status` from (`students` left join `success_of_students` on((`success_of_students`.`STUDENT_id` = `students`.`Student_ID`))) group by `students`.`City` order by `amount_of_students` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `lectors_view`
--

/*!50001 DROP VIEW IF EXISTS `lectors_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `lectors_view` AS select `lectors`.`Lector_ID` AS `lector_id`,concat(`lectors`.`Name`,' ',`lectors`.`Surname`) AS `Name`,concat(`students`.`Student_ID`,' - ',`students`.`Name`,' ',`students`.`Surname`) AS `Student`,`teaching`.`Course_ID` AS `Course_ID`,`courses`.`Name` AS `Course`,`Student_course_score`(`studying`.`Student_ID`,`studying`.`Course_ID`) AS `Student_course_score`,concat(`studying_status`(`studying`.`Student_ID`,`studying`.`Course_ID`),'%') AS `Studying_Status`,`students`.`Email` AS `email` from ((((`lectors` left join `teaching` on((`teaching`.`Lector_ID` = `lectors`.`Lector_ID`))) left join `studying` on((`studying`.`Course_ID` = `teaching`.`Course_ID`))) left join `courses` on((`courses`.`Course_ID` = `teaching`.`Course_ID`))) left join `students` on((`students`.`Student_ID` = `studying`.`Student_ID`))) order by `lectors`.`Lector_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `scores_of_exams`
--

/*!50001 DROP VIEW IF EXISTS `scores_of_exams`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `scores_of_exams` AS select `exams`.`Exam_ID` AS `exam_id`,`exams`.`Type` AS `type`,`exams`.`Course_ID` AS `course_id`,`success_of_courses`.`name` AS `name`,avg(`detailexamrecords`.`Score`) AS `Average_score`,count(distinct `detailexamrecords`.`Student_ID`) AS `amount_completed`,(`success_of_courses`.`amount_of_students` - count(distinct `detailexamrecords`.`Student_ID`)) AS `amount_to_pass`,concat(round(((sum(`detailexamrecords`.`Resubmission`) / count(distinct `detailexamrecords`.`Student_ID`)) * 100),0),'%') AS `percentage_of_resubmissions`,`success_of_courses`.`Lector` AS `lector` from ((`exams` left join `detailexamrecords` on((`detailexamrecords`.`Exam_ID` = `exams`.`Exam_ID`))) left join `success_of_courses` on((`success_of_courses`.`course_id` = `exams`.`Course_ID`))) group by `exams`.`Exam_ID` order by `exams`.`Course_ID`,`exams`.`Exam_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `students_view`
--

/*!50001 DROP VIEW IF EXISTS `students_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `students_view` AS select `students`.`Student_ID` AS `Student_ID`,concat(`students`.`Name`,' ',`students`.`Surname`) AS `Name`,`studying`.`Course_ID` AS `Course_ID`,`courses`.`Name` AS `Course_Name`,`courses`.`Pass` AS `Pass`,`Student_course_score`(`studying`.`Student_ID`,`studying`.`Course_ID`) AS `Student_course_score`,concat(`studying_status`(`studying`.`Student_ID`,`studying`.`Course_ID`),'%') AS `Studying_Status`,`teaching`.`End_Date` AS `End_Date`,concat(`lectors`.`Lector_ID`,' - ',`lectors`.`Name`,' ',`lectors`.`Surname`,' - ',`lectors`.`Email`) AS `Lectors_Details_ID_Name_Email` from ((((`students` left join `studying` on((`studying`.`Student_ID` = `students`.`Student_ID`))) left join `courses` on((`courses`.`Course_ID` = `studying`.`Course_ID`))) left join `teaching` on((`teaching`.`Course_ID` = `courses`.`Course_ID`))) left join `lectors` on((`lectors`.`Lector_ID` = `teaching`.`Lector_ID`))) order by `students`.`Student_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `success_of_courses`
--

/*!50001 DROP VIEW IF EXISTS `success_of_courses`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `success_of_courses` AS select `courses`.`Course_ID` AS `course_id`,`courses`.`Name` AS `name`,`lectors_view`.`Name` AS `Lector`,count(`lectors_view`.`Student`) AS `amount_of_students`,`teaching`.`Start_Date` AS `start_date`,`teaching`.`End_Date` AS `end_date`,round(avg(`lectors_view`.`Student_course_score`),1) AS `Students_Score`,concat(round(avg(`lectors_view`.`Studying_Status`),0),'%') AS `Studying_Status` from ((`courses` left join `lectors_view` on((`courses`.`Course_ID` = `lectors_view`.`Course_ID`))) left join `teaching` on((`courses`.`Course_ID` = `teaching`.`Course_ID`))) group by `courses`.`Course_ID` order by `Students_Score` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `success_of_lectors`
--

/*!50001 DROP VIEW IF EXISTS `success_of_lectors`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `success_of_lectors` AS select `lectors_view`.`lector_id` AS `Lector_id`,`lectors_view`.`Name` AS `Name`,count(distinct `lectors_view`.`Course_ID`) AS `amount_of_courses`,count(`lectors_view`.`Student`) AS `amount_of_students`,round(avg(`lectors_view`.`Student_course_score`),1) AS `Students_Score`,concat(round(avg(`lectors_view`.`Studying_Status`),0),'%') AS `Studying_Status` from `lectors_view` group by `lectors_view`.`lector_id` order by `Students_Score` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `success_of_students`
--

/*!50001 DROP VIEW IF EXISTS `success_of_students`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `success_of_students` AS select `students_view`.`Student_ID` AS `STUDENT_id`,`students_view`.`Name` AS `Name`,count(`students_view`.`Course_ID`) AS `amount_of_courses`,avg(`Student_course_score`(`students_view`.`Student_ID`,`students_view`.`Course_ID`)) AS `Students_Score`,avg(`Studying_Status`(`students_view`.`Student_ID`,`students_view`.`Course_ID`)) AS `Studying_Status` from `students_view` group by `students_view`.`Student_ID` order by `Students_Score` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `support_view`
--

/*!50001 DROP VIEW IF EXISTS `support_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `support_view` AS select concat(`students_view`.`Student_ID`,' - ',`students_view`.`Name`) AS `Student`,`students_view`.`Course_ID` AS `Course_ID`,`students_view`.`Course_Name` AS `Course_Name`,`students_view`.`Student_course_score` AS `Student_course_score`,`students_view`.`Pass` AS `Pass`,`students_view`.`Studying_Status` AS `Studying_Status`,if((((to_days(curdate()) - to_days(`teaching`.`Start_Date`)) / (to_days(`teaching`.`End_Date`) - to_days(`teaching`.`Start_Date`))) < 1),concat(round((((to_days(curdate()) - to_days(`teaching`.`Start_Date`)) / (to_days(`teaching`.`End_Date`) - to_days(`teaching`.`Start_Date`))) * 100),0),'%'),'Course ended') AS `Course_status`,`students_view`.`Lectors_Details_ID_Name_Email` AS `Lector` from (`students_view` left join `teaching` on((`teaching`.`Course_ID` = `students_view`.`Course_ID`))) where ((`students_view`.`Student_course_score` < `students_view`.`Pass`) or ((((((to_days(curdate()) - to_days(`teaching`.`Start_Date`)) / (to_days(`teaching`.`End_Date`) - to_days(`teaching`.`Start_Date`))) * 100) - `students_view`.`Studying_Status`) > 20) and (`students_view`.`Studying_Status` < 100))) order by `students_view`.`Lectors_Details_ID_Name_Email` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-21 23:13:20
