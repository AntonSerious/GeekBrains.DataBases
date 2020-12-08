ALTER TABLE `geodata`.`_countries` 
DROP COLUMN `title_cz`,
DROP COLUMN `title_lv`,
DROP COLUMN `title_lt`,
DROP COLUMN `title_ja`,
DROP COLUMN `title_pl`,
DROP COLUMN `title_it`,
DROP COLUMN `title_fr`,
DROP COLUMN `title_de`,
DROP COLUMN `title_pt`,
DROP COLUMN `title_es`,
DROP COLUMN `title_en`,
DROP COLUMN `title_be`,
DROP COLUMN `title_ua`,
DROP COLUMN `title_ru`,
ADD COLUMN `title` VARCHAR(150) NOT NULL AFTER `id`,
CHANGE COLUMN `country_id` `id` INT NOT NULL AUTO_INCREMENT ,
ADD PRIMARY KEY (`id`),
ADD INDEX `title_idx` (`title` ASC);
;

ALTER TABLE `geodata`.`_regions` 
DROP COLUMN `title_cz`,
DROP COLUMN `title_lv`,
DROP COLUMN `title_lt`,
DROP COLUMN `title_ja`,
DROP COLUMN `title_pl`,
DROP COLUMN `title_it`,
DROP COLUMN `title_fr`,
DROP COLUMN `title_de`,
DROP COLUMN `title_pt`,
DROP COLUMN `title_es`,
DROP COLUMN `title_en`,
DROP COLUMN `title_be`,
DROP COLUMN `title_ua`,
DROP COLUMN `title_ru`,
ADD COLUMN `title` VARCHAR(150) NOT NULL AFTER `country_id`,
CHANGE COLUMN `region_id` `id` INT NOT NULL AUTO_INCREMENT ,
ADD PRIMARY KEY (`id`),
ADD INDEX `title_idx` (`title` ASC),
ADD INDEX `fk_regions_countries_idx` (`country_id` ASC);
;
ALTER TABLE `geodata`.`_regions` 
ADD CONSTRAINT `fk_regions_countries`
  FOREIGN KEY (`country_id`)
  REFERENCES `geodata`.`_countries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;


update geodata._cities
set region_id = 0 
where region_id is null

INSERT INTO geodata._countries VALUES 
(0,'Uknown country')   --я попытался добавить id = 0 , но изза автоинкремента добавился id=236

INSERT INTO geodata._regions VALUES 
(0,236,'Uknown Territory') -- аналогично, добавился id = 5468687

--исправил
update geodata._cities
set region_id = 5468687
where region_id = 0

--и наконец делаем
ALTER TABLE `geodata`.`_cities` 
DROP COLUMN `region_cz`,
DROP COLUMN `area_cz`,
DROP COLUMN `title_cz`,
DROP COLUMN `region_lv`,
DROP COLUMN `area_lv`,
DROP COLUMN `title_lv`,
DROP COLUMN `region_lt`,
DROP COLUMN `area_lt`,
DROP COLUMN `title_lt`,
DROP COLUMN `region_ja`,
DROP COLUMN `area_ja`,
DROP COLUMN `title_ja`,
DROP COLUMN `region_pl`,
DROP COLUMN `area_pl`,
DROP COLUMN `title_pl`,
DROP COLUMN `region_it`,
DROP COLUMN `area_it`,
DROP COLUMN `title_it`,
DROP COLUMN `region_fr`,
DROP COLUMN `area_fr`,
DROP COLUMN `title_fr`,
DROP COLUMN `region_de`,
DROP COLUMN `area_de`,
DROP COLUMN `title_de`,
DROP COLUMN `region_pt`,
DROP COLUMN `area_pt`,
DROP COLUMN `title_pt`,
DROP COLUMN `region_es`,
DROP COLUMN `area_es`,
DROP COLUMN `title_es`,
DROP COLUMN `region_en`,
DROP COLUMN `area_en`,
DROP COLUMN `title_en`,
DROP COLUMN `region_be`,
DROP COLUMN `area_be`,
DROP COLUMN `title_be`,
DROP COLUMN `region_ua`,
DROP COLUMN `area_ua`,
DROP COLUMN `title_ua`,
DROP COLUMN `region_ru`,
DROP COLUMN `area_ru`,
CHANGE COLUMN `city_id` `id` INT NOT NULL AUTO_INCREMENT ,
CHANGE COLUMN `region_id` `region_id` INT NOT NULL ,
CHANGE COLUMN `title_ru` `title` VARCHAR(150) NOT NULL ,
ADD PRIMARY KEY (`id`),
ADD INDEX `title_idx` (`title` ASC),
ADD INDEX `fk_cities_countries_idx` (`country_id` ASC),
ADD INDEX `fk_cities_regions_idx` (`region_id` ASC);
;
ALTER TABLE `geodata`.`_cities` 
ADD CONSTRAINT `fk_cities_countries`
  FOREIGN KEY (`country_id`)
  REFERENCES `geodata`.`_countries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT,
ADD CONSTRAINT `fk_cities_regions`
  FOREIGN KEY (`region_id`)
  REFERENCES `geodata`.`_regions` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
