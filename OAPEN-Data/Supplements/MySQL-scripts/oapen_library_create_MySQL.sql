CREATE DATABASE  IF NOT EXISTS `oapen_library` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `oapen_library`;
-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: 104.248.34.253    Database: oapen_library
-- ------------------------------------------------------
-- Server version	8.0.40-0ubuntu0.20.04.1

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
-- Table structure for table `affiliation`
--

DROP TABLE IF EXISTS `affiliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliation` (
  `id` int NOT NULL,
  `id_institution` int NOT NULL,
  `orcid` char(19) COLLATE utf8mb4_bin NOT NULL,
  `from_date` date NOT NULL,
  `until_date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_institution` (`id_institution`,`orcid`,`from_date`,`until_date`),
  KEY `FK_affiliation__orcid` (`orcid`),
  CONSTRAINT `FK_affiliation__id_institution` FOREIGN KEY (`id_institution`) REFERENCES `institution` (`id`),
  CONSTRAINT `FK_affiliation__orcid` FOREIGN KEY (`orcid`) REFERENCES `contributor` (`orcid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `classification`
--

DROP TABLE IF EXISTS `classification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classification` (
  `code` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection` (
  `collection` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`collection`,`handle_title`),
  KEY `FK_collection__handle_title` (`handle_title`),
  CONSTRAINT `FK_collection__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contribution`
--

DROP TABLE IF EXISTS `contribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contribution` (
  `role` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `name_contributor` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`role`,`name_contributor`,`handle_title`),
  KEY `FK_contribution__handle_title` (`handle_title`),
  KEY `FK_contribution__name_contributor` (`name_contributor`),
  CONSTRAINT `FK_contribution__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE,
  CONSTRAINT `FK_contribution__name_contributor` FOREIGN KEY (`name_contributor`) REFERENCES `contributor` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contributor`
--

DROP TABLE IF EXISTS `contributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contributor` (
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `orcid` char(19) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `orcid` (`orcid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `export_chunk`
--

DROP TABLE IF EXISTS `export_chunk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `export_chunk` (
  `type` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `content` mediumtext COLLATE utf8mb4_bin,
  `url` text COLLATE utf8mb4_bin,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`type`,`handle_title`),
  KEY `FK_export_chunk__handle_title` (`handle_title`),
  CONSTRAINT `FK_export_chunk__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `funder`
--

DROP TABLE IF EXISTS `funder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funder` (
  `handle` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `name` text COLLATE utf8mb4_bin NOT NULL,
  `acronyms` text COLLATE utf8mb4_bin,
  `number` text COLLATE utf8mb4_bin,
  PRIMARY KEY (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `funding`
--

DROP TABLE IF EXISTS `funding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funding` (
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `handle_funder` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`handle_title`,`handle_funder`),
  KEY `FK_funding__handle_funder` (`handle_funder`),
  CONSTRAINT `FK_funding__handle_funder` FOREIGN KEY (`handle_funder`) REFERENCES `funder` (`handle`) ON DELETE RESTRICT,
  CONSTRAINT `FK_funding__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grant_data`
--

DROP TABLE IF EXISTS `grant_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grant_data` (
  `property` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`property`,`value`,`handle_title`),
  KEY `FK_grant_data__handle_title` (`handle_title`),
  CONSTRAINT `FK_grant_data__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `identifier`
--

DROP TABLE IF EXISTS `identifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `identifier` (
  `identifier` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `identifier_type` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`identifier`,`handle_title`,`identifier_type`),
  KEY `part_of_handle_title` (`handle_title`),
  CONSTRAINT `FK_identifier__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `institution`
--

DROP TABLE IF EXISTS `institution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `institution` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `alt_names` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `language` (
  `language` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`language`,`handle_title`),
  KEY `FK_language__handle_title` (`handle_title`),
  CONSTRAINT `FK_language__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `handle` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `name` text COLLATE utf8mb4_bin NOT NULL,
  `website` text COLLATE utf8mb4_bin,
  PRIMARY KEY (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_classification`
--

DROP TABLE IF EXISTS `subject_classification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_classification` (
  `code_classification` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`code_classification`,`handle_title`),
  KEY `FK_subject_classification__handle_title` (`handle_title`),
  CONSTRAINT `FK_subject_classification__code_classification` FOREIGN KEY (`code_classification`) REFERENCES `classification` (`code`),
  CONSTRAINT `FK_subject_classification__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_other`
--

DROP TABLE IF EXISTS `subject_other`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_other` (
  `subject` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `handle_title` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`subject`,`handle_title`),
  KEY `FK_subject_other__handle_title` (`handle_title`),
  FULLTEXT KEY `idx_fulltext_subject` (`subject`),
  CONSTRAINT `FK_subject_other__handle_title` FOREIGN KEY (`handle_title`) REFERENCES `title` (`handle`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `title`
--

DROP TABLE IF EXISTS `title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `title` (
  `handle` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `sysid` varchar(36) COLLATE utf8mb4_bin DEFAULT NULL,
  `handle_publisher` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `part_of_book` varchar(36) COLLATE utf8mb4_bin DEFAULT NULL,
  `type` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `year_available` int DEFAULT NULL,
  `download_url` text COLLATE utf8mb4_bin,
  `thumbnail` text COLLATE utf8mb4_bin,
  `license` text COLLATE utf8mb4_bin,
  `webshop_url` text COLLATE utf8mb4_bin,
  `description_abstract` text COLLATE utf8mb4_bin,
  `is_part_of_series` text COLLATE utf8mb4_bin,
  `title` text COLLATE utf8mb4_bin,
  `title_alternative` text COLLATE utf8mb4_bin,
  `terms_abstract` text COLLATE utf8mb4_bin,
  `abstract_other_language` text COLLATE utf8mb4_bin,
  `description_other_language` text COLLATE utf8mb4_bin,
  `chapter_number` text COLLATE utf8mb4_bin,
  `imprint` text COLLATE utf8mb4_bin,
  `pages` text COLLATE utf8mb4_bin,
  `place_publication` text COLLATE utf8mb4_bin,
  `series_number` text COLLATE utf8mb4_bin,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`handle`),
  KEY `part_of_handle_publisher` (`handle_publisher`),
  KEY `year_available_timestamp` (`year_available`,`timestamp`),
  FULLTEXT KEY `idx_fulltext_title` (`title`,`title_alternative`),
  FULLTEXT KEY `idx_fulltext_description` (`description_abstract`),
  FULLTEXT KEY `idx_fulltext_partofseries` (`is_part_of_series`),
  FULLTEXT KEY `idx_fulltext_abstract_ol` (`abstract_other_language`),
  FULLTEXT KEY `idx_fulltext_description_ol` (`description_other_language`),
  CONSTRAINT `FK_title__handle_publisher` FOREIGN KEY (`handle_publisher`) REFERENCES `publisher` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `title_combined_fields`
--

DROP TABLE IF EXISTS `title_combined_fields`;
/*!50001 DROP VIEW IF EXISTS `title_combined_fields`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `title_combined_fields` AS SELECT 
 1 AS `handle_title`,
 1 AS `publisher`,
 1 AS `authors`,
 1 AS `editors`,
 1 AS `othercontributors`,
 1 AS `advisors`,
 1 AS `subject_classifications`,
 1 AS `collections`,
 1 AS `languages`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'oapen_library'
--

--
-- Dumping routines for database 'oapen_library'
--

--
-- Final view structure for view `title_combined_fields`
--

/*!50001 DROP VIEW IF EXISTS `title_combined_fields`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trilobiet`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `title_combined_fields` AS select `title`.`handle` AS `handle_title`,`publisher`.`name` AS `publisher`,group_concat(distinct `author`.`name_contributor` separator '; ') AS `authors`,group_concat(distinct `editor`.`name_contributor` separator '; ') AS `editors`,group_concat(distinct `other`.`name_contributor` separator '; ') AS `othercontributors`,group_concat(distinct `advisor`.`name_contributor` separator '; ') AS `advisors`,group_concat(distinct `subject_classification`.`code_classification` separator '; ') AS `subject_classifications`,group_concat(distinct `collection`.`collection` separator '; ') AS `collections`,group_concat(distinct `language`.`language` separator '; ') AS `languages` from ((((((((`title` left join `publisher` on((`title`.`handle_publisher` = `publisher`.`handle`))) left join `contribution` `author` on(((`title`.`handle` = `author`.`handle_title`) and (`author`.`role` = 'author')))) left join `contribution` `editor` on(((`title`.`handle` = `editor`.`handle_title`) and (`editor`.`role` = 'editor')))) left join `contribution` `other` on(((`title`.`handle` = `other`.`handle_title`) and (`editor`.`role` = 'other')))) left join `contribution` `advisor` on(((`title`.`handle` = `advisor`.`handle_title`) and (`advisor`.`role` = 'advisor')))) left join `subject_classification` on((`subject_classification`.`handle_title` = `title`.`handle`))) left join `collection` on((`collection`.`handle_title` = `title`.`handle`))) left join `language` on((`language`.`handle_title` = `title`.`handle`))) group by `title`.`handle` */;
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

-- Dump completed on 2024-11-25 15:29:56
