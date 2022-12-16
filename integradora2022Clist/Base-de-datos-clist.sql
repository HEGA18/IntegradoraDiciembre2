-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: clist
-- ------------------------------------------------------
-- Server version	8.0.28

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
-- Table structure for table `citas`
--

DROP TABLE IF EXISTS `citas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_clinica` int NOT NULL,
  `id_consultorio` int NOT NULL,
  `id_empleado` int NOT NULL,
  `fecha_y_hora` datetime DEFAULT NULL,
  `nombre_paciente` varchar(30) DEFAULT NULL,
  `telefono` varchar(20) NOT NULL,
  `tipo_servicio` varchar(20) DEFAULT NULL,
  `estado_servicio` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_clinica` (`id_clinica`),
  KEY `id_consultorio` (`id_consultorio`),
  KEY `id_empleado` (`id_empleado`),
  CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`id_clinica`) REFERENCES `clinicas` (`id`),
  CONSTRAINT `citas_ibfk_2` FOREIGN KEY (`id_consultorio`) REFERENCES `consultorios` (`id`),
  CONSTRAINT `citas_ibfk_3` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citas`
--

LOCK TABLES `citas` WRITE;
/*!40000 ALTER TABLE `citas` DISABLE KEYS */;
INSERT INTO `citas` VALUES (7,1,1,1,'2022-08-22 17:30:00','Erick Diaz','7771236789','1','aceptada'),(8,1,1,1,'2022-08-22 18:18:00','kkk','8989898','caries','aceptada'),(10,1,1,1,'2022-08-23 15:53:00','Max well','1234567890','caries','rechazada'),(12,1,1,1,'2022-08-24 11:13:00','jose perez','123456789','caries',NULL),(13,1,1,1,'2022-08-24 11:31:00','jjjjj','123456789','muela',NULL),(14,1,1,1,'2022-08-24 11:35:00','mmmm','123456789','muela',NULL),(15,1,1,1,'2022-08-24 11:36:00','msnnq','123456789','caries',NULL),(16,1,1,1,'2022-08-24 11:40:00','cccc','12345678','muela',NULL),(17,1,1,1,'2022-08-24 11:42:00','ssss','123456789','muela',NULL),(18,1,1,1,'2022-08-24 12:06:00','wwww','123456789','muela','aceptada'),(20,1,1,1,'2022-08-24 13:29:00','alejandro fernandez','7779998881','muelas',NULL),(24,1,1,6,'2022-08-24 18:50:00','maria diaz','777878766','carillas','aceptada');
/*!40000 ALTER TABLE `citas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinicas`
--

DROP TABLE IF EXISTS `clinicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinicas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ubicacion` varchar(50) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinicas`
--

LOCK TABLES `clinicas` WRITE;
/*!40000 ALTER TABLE `clinicas` DISABLE KEYS */;
INSERT INTO `clinicas` VALUES (1,'Camino Serrano 62','Clinica 1');
/*!40000 ALTER TABLE `clinicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultorios`
--

DROP TABLE IF EXISTS `consultorios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultorios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_horario` int NOT NULL,
  `id_empleado` int NOT NULL,
  `id_clinica` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_horario` (`id_horario`),
  KEY `id_empleado` (`id_empleado`),
  KEY `id_clinica` (`id_clinica`),
  CONSTRAINT `consultorios_ibfk_1` FOREIGN KEY (`id_horario`) REFERENCES `horario` (`id`),
  CONSTRAINT `consultorios_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`),
  CONSTRAINT `consultorios_ibfk_3` FOREIGN KEY (`id_clinica`) REFERENCES `clinicas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultorios`
--

LOCK TABLES `consultorios` WRITE;
/*!40000 ALTER TABLE `consultorios` DISABLE KEYS */;
INSERT INTO `consultorios` VALUES (1,1,1,1);
/*!40000 ALTER TABLE `consultorios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_rol` int NOT NULL,
  `nombre_empleado` varchar(30) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `usuario` varchar(20) NOT NULL,
  `contrasenia` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
INSERT INTO `empleados` VALUES (1,2,'Jose Martinez Ocampo','7772348991','josemartinez','josemartinez'),(2,1,'Emiliano Garcia','12345678','emilianogarcia','emilianogarcia'),(3,3,'Cristian Jimenez','7773334445','cristianjimenez','cristianjimenez'),(4,3,'Cesar Garcia Medina','777345678','cesargarcia','cesargarcia'),(5,2,'cesar aranda','7773087189','cesararanda','cesararanda'),(6,2,'Omar ','7776668989','omar','omar');
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario`
--

DROP TABLE IF EXISTS `horario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_horario` varchar(50) NOT NULL,
  `hora_inicio` varchar(10) NOT NULL,
  `hora_fin` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario`
--

LOCK TABLES `horario` WRITE;
/*!40000 ALTER TABLE `horario` DISABLE KEYS */;
INSERT INTO `horario` VALUES (1,'matutino','9:00','13:00'),(2,'vespertino','15:00','17:00');
/*!40000 ALTER TABLE `horario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_rol` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'administrador'),(2,'medico'),(3,'asistente');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio`
--

DROP TABLE IF EXISTS `servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_servicio` varchar(50) NOT NULL,
  `costo` decimal(10,0) NOT NULL,
  `duracion` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` VALUES (1,'carillas',1000,'1 hora'),(2,'coronas',1500,'1 hora'),(3,'caries',500,'30 mins'),(4,'rehabilitacion bucal',1000,'1 hora');
/*!40000 ALTER TABLE `servicio` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-24 22:25:15
