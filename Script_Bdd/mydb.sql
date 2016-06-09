-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Dim 05 Juin 2016 à 22:33
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `mydb`
--

-- --------------------------------------------------------

--
-- Structure de la table `demande`
--

CREATE TABLE IF NOT EXISTS `demande` (
  `IdUser` int(11) NOT NULL DEFAULT '0',
  `IdContact` int(11) NOT NULL DEFAULT '0',
  `dateDemande` date DEFAULT NULL,
  PRIMARY KEY (`IdUser`,`IdContact`),
  KEY `IdContact` (`IdContact`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `demande`
--

INSERT INTO `demande` (`IdUser`, `IdContact`, `dateDemande`) VALUES
(2, 1, '2016-05-23'),
(3, 38, '2016-05-24'),
(25, 1, '2016-05-23');

-- --------------------------------------------------------

--
-- Structure de la table `deplacement`
--

CREATE TABLE IF NOT EXISTS `deplacement` (
  `idHistorique` int(11) NOT NULL AUTO_INCREMENT,
  `idUser` int(11) NOT NULL,
  `pointDepart` varchar(45) DEFAULT NULL,
  `pointArrivee` varchar(45) DEFAULT NULL,
  `vitesseMoy` float DEFAULT NULL,
  `distancePar` float DEFAULT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`idHistorique`),
  KEY `fk_Historique_Users_idx` (`idUser`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Contenu de la table `deplacement`
--

INSERT INTO `deplacement` (`idHistorique`, `idUser`, `pointDepart`, `pointArrivee`, `vitesseMoy`, `distancePar`, `date`) VALUES
(6, 1, 'ESIR', 'INSA', 29.33, 2.9, '2016-05-01 00:00:00'),
(7, 1, 'ISTIC', 'BU', 23.69, 2, '2016-05-02 00:00:00'),
(8, 1, 'ESIR2', 'INSA2', 25.33, 2.96, '2016-05-01 10:00:00'),
(9, 1, 'ISTIC', 'RU', 23.69, 4, '2016-05-02 12:10:01');

-- --------------------------------------------------------

--
-- Structure de la table `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `idMessage` int(11) NOT NULL AUTO_INCREMENT,
  `sujetId` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  `message` text NOT NULL,
  `dateAjout` datetime NOT NULL,
  PRIMARY KEY (`idMessage`),
  KEY `fk_userM` (`idUser`),
  KEY `fk_ms` (`sujetId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=31 ;

--
-- Contenu de la table `message`
--

INSERT INTO `message` (`idMessage`, `sujetId`, `idUser`, `message`, `dateAjout`) VALUES
(1, 1, 1, 'Bonjour tout le monde je cherche de l''aide', '2016-05-07 00:00:00'),
(2, 1, 1, 'Bonjour tout le monde je cherche je suis ....', '0000-00-00 00:00:00'),
(4, 1, 1, 'Bonjour ceci est un test d''ajout d''un user', '2016-05-15 23:08:02'),
(6, 2, 1, 'Bonjour le suis le premier vrai message dans ce sujet', '2016-05-15 23:14:00'),
(21, 2, 1, 'Bonjour a tous comment ça va et toi tu vas vbien Bonjour a tous comment ça va et toi tu vas vbien Bonjour a tous comment ça va et toi tu vas vbien Bonjour a tous comment ça va et toi tu vas vbien ', '2016-05-17 09:02:14'),
(24, 2, 2, 'bbbbbbbbbbbbbbbb', '2016-05-17 09:40:17'),
(25, 2, 2, 'message de test', '2016-05-17 09:40:26'),
(26, 2, 2, 'un autre message de l''utisateur test un autre message de l''utisateur test un autre message de l''utisateur test un autre message de l''utisateur test un autre message de l''utisateur test ', '2016-05-17 09:40:56'),
(27, 1, 2, 'un autre message de l''utisateur test un autre message de l''utisateur test un autre message de l''utisateur test un autre message de l''utisateur test un autre message de l''utisateur test un autre message de l''utisateur test ', '2016-05-17 09:41:38'),
(28, 1, 2, ' je suis tjrs l''utilisateur test je suis tjrs l''utilisateur test je suis tjrs l''utilisateur test je suis tjrs l''utilisateur test je suis tjrs l''utilisateur test', '2016-05-17 09:42:05'),
(30, 2, 1, 'bonjour', '2016-05-28 14:10:02');

-- --------------------------------------------------------

--
-- Structure de la table `sujet`
--

CREATE TABLE IF NOT EXISTS `sujet` (
  `idSujet` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) NOT NULL,
  `dateAjout` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`idSujet`),
  KEY `fk_user` (`userId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Contenu de la table `sujet`
--

INSERT INTO `sujet` (`idSujet`, `titre`, `dateAjout`, `userId`) VALUES
(1, 'premier sujet', '2016-05-06 00:00:00', 1),
(2, 'Test sujet2', '2016-05-07 00:00:00', 1);

-- --------------------------------------------------------

--
-- Structure de la table `usercontact`
--

CREATE TABLE IF NOT EXISTS `usercontact` (
  `IdUser` int(11) NOT NULL DEFAULT '0',
  `IdContact` int(11) NOT NULL DEFAULT '0',
  `dateAmitie` date DEFAULT NULL,
  PRIMARY KEY (`IdUser`,`IdContact`),
  KEY `IdContact` (`IdContact`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `usercontact`
--

INSERT INTO `usercontact` (`IdUser`, `IdContact`, `dateAmitie`) VALUES
(1, 2, '2016-05-24'),
(1, 3, '2016-05-24'),
(1, 38, '2016-05-24'),
(1, 43, '2016-05-24'),
(3, 1, '2016-05-24'),
(43, 3, '2016-05-24'),
(44, 3, '2016-05-24'),
(44, 38, '2016-05-24');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `Id_User` int(11) NOT NULL AUTO_INCREMENT,
  `Login` varchar(45) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `Nom` varchar(45) DEFAULT NULL,
  `Prenom` varchar(45) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `dateInscription` datetime NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `mail` varchar(255) NOT NULL,
  PRIMARY KEY (`Id_User`),
  UNIQUE KEY `mail` (`mail`),
  UNIQUE KEY `Login_UNIQUE` (`Login`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=45 ;

--
-- Contenu de la table `users`
--

INSERT INTO `users` (`Id_User`, `Login`, `password`, `Nom`, `Prenom`, `Age`, `dateInscription`, `adresse`, `mail`) VALUES
(1, 'ali', '$2y$10$J8MqHdujAJeXQvyFtLE/GOIicxAgTAS/xiQ/10qcDFDGlTO4w0VB6', 'Mohamed Affizou', 'Ali ', 23, '0000-00-00 00:00:00', '39 AVENUE DU PROFESSEUR CHARLES FOULON RES UNIV BEAULIEU', 'alimohamedaffizou@mail.com'),
(2, 'test', '$2y$10$J8MqHdujAJeXQvyFtLE/GOIicxAgTAS/xiQ/10qcDFDGlTO4w0VB6', 'TestNom', 'TestPrenom', 25, '2016-05-15 00:00:00', 'ddddfvvvvvvv  ggh,,ffxf', 'test@mail.com'),
(3, 'log', '$2y$10$J8MqHdujAJeXQvyFtLE/GOIicxAgTAS/xiQ/10qcDFDGlTO4w0VB6', 'Nguetcheu', 'Salifou', 15, '2016-05-18 14:51:34', '', ''),
(25, 'log1', '$2y$10$J8MqHdujAJeXQvyFtLE/GOIicxAgTAS/xiQ/10qcDFDGlTO4w0VB6', 'Sylvain', 'Duarte', 15, '2016-05-18 15:35:09', '', 'test2@mail.com'),
(38, 'log121', '$2y$10$J8MqHdujAJeXQvyFtLE/GOIicxAgTAS/xiQ/10qcDFDGlTO4w0VB6', 'Gouro', 'Thomas', 15, '2016-05-18 16:11:08', '', 'test22@mail.com'),
(39, 'log1212', '$2y$10$D0f/Q39Ws.A8Zwqe.k1f1OxHvISzzWXZ3qE5sbcPeKR3dEtIHgBq.', 'Cotard', 'Guillaume', 15, '2016-05-18 16:11:29', '', 'test222@mail.com'),
(41, 'testlog1212', '$2y$10$pKJDsMK3UKKGeBgXSTYGuOmCKKo5jGL7PwXnQIOlGMZvSzv/FbXKG', 'Herbrecht', 'Gael', 15, '2016-05-18 16:12:21', '', 'Ttest222@mail.com'),
(42, 'testlog12121', '$2y$10$OYLe1GkB61.a/6OI9nc/4ufsPPZ/rWjlgJpO08WRmkFs6bH6cSCZe', 'Houchard', 'Corentin', 15, '2016-05-18 16:13:41', '', '11Ttest222@mail.com'),
(43, 'ilyass', '$2y$10$J8MqHdujAJeXQvyFtLE/GOIicxAgTAS/xiQ/10qcDFDGlTO4w0VB6', 'Azaroual', 'Ilyass', 15, '2016-05-18 16:15:04', '', 'AAA1Ttest222@mail.com'),
(44, 'Aliiitestlog12121', '$2y$10$J8MqHdujAJeXQvyFtLE/GOIicxAgTAS/xiQ/10qcDFDGlTO4w0VB6', 'Maîga', 'Youssouf', 15, '2016-05-18 16:16:34', '', 'AAA1iTtest222@mail.com');

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `demande`
--
ALTER TABLE `demande`
  ADD CONSTRAINT `demande_ibfk_1` FOREIGN KEY (`IdUser`) REFERENCES `users` (`Id_User`),
  ADD CONSTRAINT `demande_ibfk_2` FOREIGN KEY (`IdContact`) REFERENCES `users` (`Id_User`);

--
-- Contraintes pour la table `deplacement`
--
ALTER TABLE `deplacement`
  ADD CONSTRAINT `fk_Historique_Users` FOREIGN KEY (`idUser`) REFERENCES `users` (`Id_User`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `fk_ms` FOREIGN KEY (`sujetId`) REFERENCES `sujet` (`idSujet`),
  ADD CONSTRAINT `fk_userM` FOREIGN KEY (`idUser`) REFERENCES `users` (`Id_User`);

--
-- Contraintes pour la table `sujet`
--
ALTER TABLE `sujet`
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`userId`) REFERENCES `users` (`Id_User`);

--
-- Contraintes pour la table `usercontact`
--
ALTER TABLE `usercontact`
  ADD CONSTRAINT `usercontact_ibfk_1` FOREIGN KEY (`IdUser`) REFERENCES `users` (`Id_User`),
  ADD CONSTRAINT `usercontact_ibfk_2` FOREIGN KEY (`IdContact`) REFERENCES `users` (`Id_User`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
