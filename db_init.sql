DROP DATABASE Pinboard;
CREATE DATABASE IF NOT EXISTS Pinboard;
USE Pinboard;
CREATE TABLE IF NOT EXISTS `NewsObject`(`ID` INT NOT NULL AUTO_INCREMENT,`Title` VARCHAR(255) NOT NULL,`Date` VARCHAR(20) NOT NULL,`Filepath` VARCHAR(255) NOT NULL,`Link` VARCHAR(255) NOT NULL,PRIMARY KEY (`ID`, `Link`)) DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `Object_Tags`(`ID` INT NOT NULL AUTO_INCREMENT,`ID_News` INT NOT NULL,`Tag_Value` VARCHAR(10) NOT NULL,PRIMARY KEY (`ID`),FOREIGN KEY (`ID_News`) REFERENCES `NewsObject`(`ID`)) DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `Subscriber`(`UUID` NVARCHAR(64) NOT NULL,`Tags` VARCHAR(255),PRIMARY KEY (`UUID`)) DEFAULT CHARSET=utf8;