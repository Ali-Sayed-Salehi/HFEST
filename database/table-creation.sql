-- MySQL Script generated by MySQL Workbench
-- Sun Apr  9 13:37:44 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`address` ;

CREATE TABLE IF NOT EXISTS `mydb`.`address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(511) NOT NULL,
  `postalCodeId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_address_postalCode_idx` (`postalCodeId` ASC) VISIBLE,
  CONSTRAINT `FK_address_postalCode`
    FOREIGN KEY (`postalCodeId`)
    REFERENCES `mydb`.`postal_code` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`city` ;

CREATE TABLE IF NOT EXISTS `mydb`.`city` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(45) NOT NULL,
  `province` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`email_sent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`email_sent` ;

CREATE TABLE IF NOT EXISTS `mydb`.`email_sent` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `facility_id` INT NOT NULL,
  `sender` VARCHAR(255) NOT NULL,
  `receirver` VARCHAR(255) NOT NULL,
  `subject` VARCHAR(500) NOT NULL,
  `body` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_email_sent_facility1_idx` (`facility_id` ASC) VISIBLE,
  CONSTRAINT `fk_email_sent_facility1`
    FOREIGN KEY (`facility_id`)
    REFERENCES `mydb`.`facility` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`employee` ;

CREATE TABLE IF NOT EXISTS `mydb`.`employee` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(255) NOT NULL,
  `lastName` VARCHAR(255) NOT NULL,
  `dateOfBirth` DATE NOT NULL,
  `medicareCardNo` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(12) NOT NULL,
  `citizenship` VARCHAR(255) NOT NULL,
  `email` VARCHAR(320) NOT NULL,
  `roleId` INT NOT NULL,
  `addressId` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `medicareCardNo_UNIQUE` (`medicareCardNo` ASC) VISIBLE,
  INDEX `FK_employee_employee_role_idx` (`roleId` ASC) VISIBLE,
  INDEX `FK_employee_address_idx` (`addressId` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  CONSTRAINT `FK_employee_employee_role`
    FOREIGN KEY (`roleId`)
    REFERENCES `mydb`.`employee_role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_employee_address`
    FOREIGN KEY (`addressId`)
    REFERENCES `mydb`.`address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`employee_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`employee_role` ;

CREATE TABLE IF NOT EXISTS `mydb`.`employee_role` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `role` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`employment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`employment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`employment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `employeeId` INT NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` DATE NULL,
  `facilityId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_employment_employee_idx` (`employeeId` ASC) VISIBLE,
  INDEX `FK_employment_facility_idx` (`facilityId` ASC) VISIBLE,
  UNIQUE INDEX `UK_employee_startDate_facility` (`employeeId` ASC, `startDate` ASC, `facilityId` ASC) VISIBLE,
  CONSTRAINT `FK_employment_employee`
    FOREIGN KEY (`employeeId`)
    REFERENCES `mydb`.`employee` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_employment_facility`
    FOREIGN KEY (`facilityId`)
    REFERENCES `mydb`.`facility` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`facility`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`facility` ;

CREATE TABLE IF NOT EXISTS `mydb`.`facility` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(12) NOT NULL,
  `webAddress` VARCHAR(1000) NOT NULL,
  `typeId` INT NOT NULL,
  `capacity` INT NOT NULL,
  `addressId` INT NOT NULL,
  `generalManagerId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_facility_facility_type_idx` (`typeId` ASC) VISIBLE,
  INDEX `FK_facility_address_idx` (`addressId` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE,
  UNIQUE INDEX `webAddress_UNIQUE` (`webAddress` ASC) VISIBLE,
  UNIQUE INDEX `addressId_UNIQUE` (`addressId` ASC) VISIBLE,
  INDEX `FK_facility_employee_idx` (`generalManagerId` ASC) VISIBLE,
  UNIQUE INDEX `generalManagerId_UNIQUE` (`generalManagerId` ASC) VISIBLE,
  CONSTRAINT `FK_facility_facility_type`
    FOREIGN KEY (`typeId`)
    REFERENCES `mydb`.`facility_type` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_facility_address`
    FOREIGN KEY (`addressId`)
    REFERENCES `mydb`.`address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_facility_employee`
    FOREIGN KEY (`generalManagerId`)
    REFERENCES `mydb`.`employee` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`facility_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`facility_type` ;

CREATE TABLE IF NOT EXISTS `mydb`.`facility_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`infection`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`infection` ;

CREATE TABLE IF NOT EXISTS `mydb`.`infection` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `employeeId` INT NOT NULL,
  `date` DATE NOT NULL,
  `infectionTypeId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_infection_infection_type_idx` (`infectionTypeId` ASC) VISIBLE,
  INDEX `FK_infection_employee_idx` (`employeeId` ASC) VISIBLE,
  UNIQUE INDEX `UK_employee_startDate_infectionType` (`employeeId` ASC, `date` ASC, `infectionTypeId` ASC) VISIBLE,
  CONSTRAINT `FK_infection_infection_type`
    FOREIGN KEY (`infectionTypeId`)
    REFERENCES `mydb`.`infection_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_infection_employee`
    FOREIGN KEY (`employeeId`)
    REFERENCES `mydb`.`employee` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`infection_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`infection_type` ;

CREATE TABLE IF NOT EXISTS `mydb`.`infection_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`postal_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`postal_code` ;

CREATE TABLE IF NOT EXISTS `mydb`.`postal_code` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `postalCode` VARCHAR(45) NOT NULL,
  `cityId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_postalCode_city_idx` (`cityId` ASC) VISIBLE,
  CONSTRAINT `FK_postalCode_city`
    FOREIGN KEY (`cityId`)
    REFERENCES `mydb`.`city` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`schedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`schedule` ;

CREATE TABLE IF NOT EXISTS `mydb`.`schedule` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `startTime` TIME NOT NULL,
  `endTime` TIME NOT NULL,
  `isCancelled` TINYINT NOT NULL,
  `employmentId` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UK_date_startTime_endTime_employee` (`date` ASC, `startTime` ASC, `endTime` ASC) VISIBLE,
  INDEX `FK_schedule_employment_idx` (`employmentId` ASC) VISIBLE,
  UNIQUE INDEX `UK_date_startTime_endTime_employmentId_isCanceled` (`date` ASC, `startTime` ASC, `endTime` ASC, `employmentId` ASC, `isCancelled` ASC) VISIBLE,
  CONSTRAINT `FK_schedule_employment`
    FOREIGN KEY (`employmentId`)
    REFERENCES `mydb`.`employment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vaccination`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vaccination` ;

CREATE TABLE IF NOT EXISTS `mydb`.`vaccination` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `employeeId` INT NOT NULL,
  `dose` INT NOT NULL,
  `typeId` INT NOT NULL,
  `date` DATE NOT NULL,
  `facilityId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_vaccination_employee_idx` (`employeeId` ASC) VISIBLE,
  INDEX `FK_vaccination_vaccination_type_idx` (`typeId` ASC) VISIBLE,
  INDEX `FK_vaccination_facility_idx` (`facilityId` ASC) VISIBLE,
  UNIQUE INDEX `UK_employee_dose_vaccinationType` (`employeeId` ASC, `dose` ASC, `typeId` ASC) VISIBLE,
  UNIQUE INDEX `UK_employee_date_vaccinationType` (`employeeId` ASC, `date` ASC, `typeId` ASC) VISIBLE,
  CONSTRAINT `FK_vaccination_employee`
    FOREIGN KEY (`employeeId`)
    REFERENCES `mydb`.`employee` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_vaccination_vaccination_type`
    FOREIGN KEY (`typeId`)
    REFERENCES `mydb`.`vaccination_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_vaccination_facility`
    FOREIGN KEY (`facilityId`)
    REFERENCES `mydb`.`facility` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vaccination_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vaccination_type` ;

CREATE TABLE IF NOT EXISTS `mydb`.`vaccination_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
