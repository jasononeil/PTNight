-- MySQL dump 10.13  Distrib 5.1.36, for suse-linux-gnu (i686)
--
-- Host: localhost    Database: hxbase
-- ------------------------------------------------------
-- Server version	5.1.36-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `hxbase`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hxbase` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `hxbase`;

--
-- Table structure for table `TodoItem`
--

DROP TABLE IF EXISTS `TodoItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TodoItem` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userId` int(10) unsigned NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `text` text COLLATE utf8_unicode_ci NOT NULL,
  `priority` smallint(5) unsigned DEFAULT NULL,
  `completion` float unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`,`priority`),
  CONSTRAINT `TodoItem_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TodoItem`
--

LOCK TABLES `TodoItem` WRITE;
/*!40000 ALTER TABLE `TodoItem` DISABLE KEYS */;
INSERT INTO `TodoItem` VALUES (11,2,'Todo number 1','You better get moving before number 2 comes along',5,0.53),(12,2,'Todo number 2','You better get moving before number 3 comes along',5,0.42),(13,2,'Todo number 3','You better get moving before number 4 comes along',5,0.31),(14,2,'Todo number 4','You better get moving before number 5 comes along',5,0.75),(15,2,'Todo number 5','You better get moving before number 6 comes along',5,0.94),(16,2,'Todo number 6','You better get moving before number 7 comes along',5,0.93),(17,2,'Todo number 7','You better get moving before number 8 comes along',5,0.87),(18,2,'Todo number 8','You better get moving before number 9 comes along',5,0.85),(19,2,'Todo number 9','You better get moving before number 10 comes along',5,0.63),(20,2,'Todo number 10','You better get moving before number 11 comes along',5,0.53),(21,2,'Todo number 11','You better get moving before number 12 comes along',5,0.4),(22,2,'Todo number 12','You better get moving before number 13 comes along',5,0.2),(23,2,'Todo number 13','You better get moving before number 14 comes along',5,0.33),(24,2,'Todo number 14','You better get moving before number 15 comes along',5,0.86),(25,2,'Todo number 15','You better get moving before number 16 comes along',5,0.81),(26,2,'Todo number 16','You better get moving before number 17 comes along',5,0.63),(27,2,'Todo number 17','You better get moving before number 18 comes along',5,0.97),(28,2,'Todo number 18','You better get moving before number 19 comes along',5,0.96),(29,2,'Todo number 19','You better get moving before number 20 comes along',5,0.03),(30,2,'Todo number 20','You better get moving before number 21 comes along',5,0.18),(31,2,'Todo number 21','You better get moving before number 22 comes along',5,0.48),(32,2,'Todo number 22','You better get moving before number 23 comes along',5,0),(33,2,'Todo number 22','You better get moving before number 23 comes along',5,0.49),(34,2,'Todo number 23','You better get moving before number 24 comes along',5,0.32),(35,2,'Todo number 24','You better get moving before number 25 comes along',5,0.2),(36,2,'Todo number 25','You better get moving before number 26 comes along',5,0.74),(37,2,'Todo number 26','You better get moving before number 27 comes along',5,0.4),(38,2,'Todo number 27','You better get moving before number 28 comes along',5,0.95),(39,2,'Todo number 28','You better get moving before number 29 comes along',5,0.55),(40,2,'Todo number 29','You better get moving before number 30 comes along',5,0.5),(41,2,'Todo number 30','You better get moving before number 31 comes along',5,0.92);
/*!40000 ALTER TABLE `TodoItem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (2,'jason','5f4dcc3b5aa765d61d8327deb882cf99');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-06-30 18:15:18
