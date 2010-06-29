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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TodoItem`
--

LOCK TABLES `TodoItem` WRITE;
/*!40000 ALTER TABLE `TodoItem` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
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

-- Dump completed on 2010-06-29 15:19:36
