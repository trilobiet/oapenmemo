-- MySQL dump 10.13  Distrib 8.0.31, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: oapen_memo
-- ------------------------------------------------------
-- Server version	8.0.31-0ubuntu0.20.04.2

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
-- Table structure for table `classification`
--

DROP TABLE IF EXISTS `classification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classification` (
  `id` varchar(7) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contributor`
--

DROP TABLE IF EXISTS `contributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contributor` (
  `name` varchar(100) NOT NULL,
  `orcid` char(19) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dc_contributor_role`
--

DROP TABLE IF EXISTS `dc_contributor_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dc_contributor_role` (
  `name` varchar(100) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  `type` varchar(10) NOT NULL,
  `id_institution` varchar(36) DEFAULT NULL,
  KEY `part_of_name` (`name`),
  KEY `part_of_id_title` (`id_title`),
  KEY `FK_dc_contributor_role__id_institution` (`id_institution`),
  CONSTRAINT `FK_dc_contributor_role__id_institution` FOREIGN KEY (`id_institution`) REFERENCES `institution` (`id`),
  CONSTRAINT `FK_dc_contributor_role__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`),
  CONSTRAINT `FK_dc_contributor_role__name` FOREIGN KEY (`name`) REFERENCES `contributor` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dc_date_accessioned`
--

DROP TABLE IF EXISTS `dc_date_accessioned`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dc_date_accessioned` (
  `date` datetime NOT NULL,
  `id_title` varchar(36) NOT NULL,
  PRIMARY KEY (`date`,`id_title`),
  KEY `FK_dc_date_accessioned__id_title` (`id_title`),
  CONSTRAINT `FK_dc_date_accessioned__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dc_identifier`
--

DROP TABLE IF EXISTS `dc_identifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dc_identifier` (
  `identifier` varchar(50) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  PRIMARY KEY (`identifier`),
  KEY `part_of_id_title` (`id_title`),
  CONSTRAINT `FK_dc_identifier__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dc_language`
--

DROP TABLE IF EXISTS `dc_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dc_language` (
  `language` varchar(10) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  PRIMARY KEY (`language`,`id_title`),
  KEY `FK_dc_language__id_title` (`id_title`),
  CONSTRAINT `FK_dc_language__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dc_subject_classification`
--

DROP TABLE IF EXISTS `dc_subject_classification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dc_subject_classification` (
  `id_classification` varchar(5) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  PRIMARY KEY (`id_classification`,`id_title`),
  KEY `FK_dc_subject_classification__id_title` (`id_title`),
  CONSTRAINT `FK_dc_subject_classification__id_classification` FOREIGN KEY (`id_classification`) REFERENCES `classification` (`id`),
  CONSTRAINT `FK_dc_subject_classification__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dc_subject_other`
--

DROP TABLE IF EXISTS `dc_subject_other`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dc_subject_other` (
  `subject` varchar(100) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  PRIMARY KEY (`subject`),
  KEY `part_of_id_title` (`id_title`),
  CONSTRAINT `FK_dc_subject_other__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `export_chunk`
--

DROP TABLE IF EXISTS `export_chunk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `export_chunk` (
  `type` varchar(10) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`type`,`id_title`),
  KEY `FK_export_chunk__id_title` (`id_title`),
  CONSTRAINT `FK_export_chunk__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `funder`
--

DROP TABLE IF EXISTS `funder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funder` (
  `id` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `funder_name`
--

DROP TABLE IF EXISTS `funder_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funder_name` (
  `name` varchar(255) NOT NULL,
  `id_funder` varchar(25) NOT NULL,
  PRIMARY KEY (`name`),
  KEY `part_of_id_funder` (`id_funder`),
  CONSTRAINT `FK_funder_name__id_funder` FOREIGN KEY (`id_funder`) REFERENCES `funder` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `identifier_isbn`
--

DROP TABLE IF EXISTS `identifier_isbn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `identifier_isbn` (
  `isbn` varchar(15) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  PRIMARY KEY (`isbn`),
  KEY `part_of_id_title` (`id_title`),
  CONSTRAINT `FK_identifier_isbn__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `institution`
--

DROP TABLE IF EXISTS `institution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `institution` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oapen_relation_isfundedby`
--

DROP TABLE IF EXISTS `oapen_relation_isfundedby`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oapen_relation_isfundedby` (
  `grant_number` varchar(100) NOT NULL,
  `grant_program` varchar(255) DEFAULT NULL,
  `grant_project` varchar(255) DEFAULT NULL,
  `grant_acronym` varchar(100) DEFAULT NULL,
  `id_funder` varchar(25) NOT NULL,
  `id_title` varchar(36) NOT NULL,
  PRIMARY KEY (`grant_number`),
  KEY `part_of_id_funder` (`id_funder`),
  KEY `part_of_id_title` (`id_title`),
  CONSTRAINT `FK_oapen_relation_isfundedby__id_funder` FOREIGN KEY (`id_funder`) REFERENCES `funder` (`id`),
  CONSTRAINT `FK_oapen_relation_isfundedby__id_title` FOREIGN KEY (`id_title`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `id` varchar(25) NOT NULL,
  `name` varchar(100) NOT NULL,
  `website` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `title`
--

DROP TABLE IF EXISTS `title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `title` (
  `id` varchar(36) NOT NULL,
  `handle` varchar(25) NOT NULL,
  `collection_no` varchar(25) DEFAULT NULL,
  `download_url` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(100) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `webshop_url` varchar(255) DEFAULT NULL,
  `dc_date_available` datetime NOT NULL,
  `dc_date_issued` date DEFAULT NULL,
  `dc_description` text,
  `dc_description_abstract` text,
  `dc_description_provenance` text,
  `dc_identifier_issn` varchar(255) DEFAULT NULL,
  `dc_relation_ispartofseries` varchar(100) DEFAULT NULL,
  `dc_title` varchar(100) NOT NULL,
  `dc_title_alternative` varchar(100) DEFAULT NULL,
  `dc_type` varchar(10) NOT NULL,
  `dc_terms_abstract` text,
  `oapen_abstractotherlanguage` text,
  `oapen_chapternumber` varchar(4) DEFAULT NULL,
  `oapen_description_otherlanguage` text,
  `oapen_embargo` varchar(255) DEFAULT NULL,
  `oapen_identifier` varchar(255) DEFAULT NULL,
  `oapen_identifier_doi` varchar(255) DEFAULT NULL,
  `oapen_identifier_ocn` varchar(15) DEFAULT NULL,
  `oapen_imprint` varchar(100) DEFAULT NULL,
  `oapen_pages` varchar(10) DEFAULT NULL,
  `oapen_placepublication` varchar(100) DEFAULT NULL,
  `oapen_relation_partofbook` varchar(36) NOT NULL,
  `oapen_relation_ispublishedby` varchar(25) DEFAULT NULL,
  `oapen_seriesnumber` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `part_of_oapen_relation_partofbook` (`oapen_relation_partofbook`),
  KEY `part_of_oapen_relation_ispublishedby` (`oapen_relation_ispublishedby`),
  CONSTRAINT `FK_title__oapen_relation_ispublishedby` FOREIGN KEY (`oapen_relation_ispublishedby`) REFERENCES `publisher` (`id`),
  CONSTRAINT `FK_title__oapen_relation_partofbook` FOREIGN KEY (`oapen_relation_partofbook`) REFERENCES `title` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-01-24 10:58:51
