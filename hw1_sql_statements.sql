CREATE TABLE `area` (
  `idArea` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nameArea` varchar(45) NOT NULL,
  `idCountry` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idArea`),
  KEY `fk_area_country_idCountry_idx` (`idCountry`),
  CONSTRAINT `fk_area_country_idCountry` FOREIGN KEY (`idCountry`) REFERENCES `country` (`idCountry`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `country` (
  `idCountry` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nameCountry` varchar(45) NOT NULL,
  PRIMARY KEY (`idCountry`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `town` (
  `idTown` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idArea` int(10) unsigned NOT NULL,
  `idDistrict` int(10) unsigned DEFAULT NULL,
  `nameTown` varchar(45) NOT NULL,
  PRIMARY KEY (`idTown`),
  KEY `fk_town_area_idAre_idx` (`idArea`),
  KEY `fk_town_district_idDistrict_idx` (`idDistrict`),
  CONSTRAINT `fk_town_area_idAre` FOREIGN KEY (`idArea`) REFERENCES `area` (`idArea`),
  CONSTRAINT `fk_town_district_idDistrict` FOREIGN KEY (`idDistrict`) REFERENCES `district` (`idDistrict`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `district` (
  `idDistrict` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idArea` int(11) unsigned NOT NULL,
  `nameDistrict` varchar(45) NOT NULL,
  PRIMARY KEY (`idDistrict`),
  KEY `fk_district_area_idArea_idx` (`idArea`),
  CONSTRAINT `fk_district_area_idArea` FOREIGN KEY (`idArea`) REFERENCES `area` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
