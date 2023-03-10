-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`user_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  `user_types_id` INT NOT NULL,
  PRIMARY KEY (`id`, `user_types_id`),
  INDEX `fk_users_user_types_idx` (`user_types_id` ASC),
  CONSTRAINT `fk_users_user_types`
    FOREIGN KEY (`user_types_id`)
    REFERENCES `mydb`.`user_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;




-- -----------------------------------------------------
-- Table `mydb`.`medication`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`medication` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `cost` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`users_has_medication`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`users_has_medication` (
  `users_id` INT NOT NULL,
  `users_user_types_id` INT NOT NULL,
  `medication_id` INT NOT NULL,
  PRIMARY KEY (`users_id`, `users_user_types_id`, `medication_id`),
  INDEX `fk_users_has_medication_medication1_idx` (`medication_id` ASC),
  INDEX `fk_users_has_medication_users1_idx` (`users_id` ASC, `users_user_types_id` ASC),
  CONSTRAINT `fk_users_has_medication_users1`
    FOREIGN KEY (`users_id` , `users_user_types_id`)
    REFERENCES `mydb`.`users` (`id` , `user_types_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_medication_medication1`
    FOREIGN KEY (`medication_id`)
    REFERENCES `mydb`.`medication` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;







-- -----------------------------------------------------
-- Table `mydb`.`hospitals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`hospitals` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `address` VARCHAR(45) NULL,
  `phone_number` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`invoices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`invoices` (
  `id` INT NOT NULL,
  `total_amount` VARCHAR(45) NULL,
  `date_issued` VARCHAR(45) NULL,
  `users_id` INT NOT NULL,
  `hospitals_id` INT NOT NULL,
  PRIMARY KEY (`id`, `users_id`, `hospitals_id`),
  INDEX `fk_invoices_users1_idx` (`users_id` ASC),
  INDEX `fk_invoices_hospitals1_idx` (`hospitals_id` ASC),
  CONSTRAINT `fk_invoices_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoices_hospitals1`
    FOREIGN KEY (`hospitals_id`)
    REFERENCES `mydb`.`hospitals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;







-- -----------------------------------------------------
-- Table `mydb`.`employees_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`employees_info` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ssn` VARCHAR(45) NULL,
  `users_id` INT NOT NULL,
  `hospitals_id` INT NOT NULL,
  PRIMARY KEY (`id`, `users_id`, `hospitals_id`),
  INDEX `fk_employees_info_users1_idx` (`users_id` ASC),
  INDEX `fk_employees_info_hospitals1_idx` (`hospitals_id` ASC),
  CONSTRAINT `fk_employees_info_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_employees_info_hospitals1`
    FOREIGN KEY (`hospitals_id`)
    REFERENCES `mydb`.`hospitals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`department` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `building` VARCHAR(45) NULL,
  `floor` VARCHAR(45) NULL,
  `hospitals_id` INT NOT NULL,
  PRIMARY KEY (`id`, `hospitals_id`),
  INDEX `fk_department_hospitals1_idx` (`hospitals_id` ASC),
  CONSTRAINT `fk_department_hospitals1`
    FOREIGN KEY (`hospitals_id`)
    REFERENCES `mydb`.`hospitals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`patient_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`patient_info` (
  `id` INT NOT NULL,
  `blood_type` VARCHAR(45) NULL,
  `users_id` INT NOT NULL,
  PRIMARY KEY (`id`, `users_id`),
  INDEX `fk_patient_info_users1_idx` (`users_id` ASC),
  CONSTRAINT `fk_patient_info_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`rooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`rooms` (
  `id` INT NOT NULL,
  `room_number` VARCHAR(45) NULL,
  `is_vip` VARCHAR(45) NULL,
  `number_beds` VARCHAR(45) NULL,
  `floor_number` VARCHAR(45) NULL,
  `phone_number` VARCHAR(45) NULL,
  `cost_day` VARCHAR(45) NULL,
  `department_id` INT NOT NULL,
  PRIMARY KEY (`id`, `department_id`),
  INDEX `fk_rooms_department1_idx` (`department_id` ASC),
  CONSTRAINT `fk_rooms_department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `mydb`.`department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_rooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user_rooms` (
  `rooms_id` INT NOT NULL,
  `users_id` INT NOT NULL,
  `date_entered` VARCHAR(45) NULL,
  `date_left` VARCHAR(45) NULL,
  `bed_id` VARCHAR(45) NULL,
  PRIMARY KEY (`rooms_id`, `users_id`),
  INDEX `fk_rooms_has_users_users1_idx` (`users_id` ASC),
  INDEX `fk_rooms_has_users_rooms1_idx` (`rooms_id` ASC),
  UNIQUE INDEX `bed_id_UNIQUE` (`bed_id` ASC),
  CONSTRAINT `fk_rooms_has_users_rooms1`
    FOREIGN KEY (`rooms_id`)
    REFERENCES `mydb`.`rooms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rooms_has_users_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user_department` (
  `department_id` INT NOT NULL,
  `users_id` INT NOT NULL,
  `hospitals_id` INT NOT NULL,
  PRIMARY KEY (`department_id`, `users_id`, `hospitals_id`),
  INDEX `fk_department_has_users_users1_idx` (`users_id` ASC),
  INDEX `fk_department_has_users_department1_idx` (`department_id` ASC),
  INDEX `fk_department_has_users_hospitals1_idx` (`hospitals_id` ASC),
  CONSTRAINT `fk_department_has_users_department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `mydb`.`department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_department_has_users_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_department_has_users_hospitals1`
    FOREIGN KEY (`hospitals_id`)
    REFERENCES `mydb`.`hospitals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`hospital_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`hospital_users` (
  `users_id` INT NOT NULL,
  `hospitals_id` INT NOT NULL,
  `is_active` VARCHAR(45) NULL,
  `date_joined` VARCHAR(45) NULL,
  `date_left` VARCHAR(45) NULL,
  PRIMARY KEY (`users_id`, `hospitals_id`),
  INDEX `fk_users_has_hospitals_hospitals1_idx` (`hospitals_id` ASC),
  INDEX `fk_users_has_hospitals_users1_idx` (`users_id` ASC),
  CONSTRAINT `fk_users_has_hospitals_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_hospitals_hospitals1`
    FOREIGN KEY (`hospitals_id`)
    REFERENCES `mydb`.`hospitals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`services`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`services` (
  `patient_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  `department_id` INT NOT NULL,
  `description` VARCHAR(45) NULL,
  `id` VARCHAR(45) NULL,
  `cost` VARCHAR(45) NULL,
  PRIMARY KEY (`patient_id`, `employee_id`, `department_id`),
  INDEX `fk_services_users2_idx` (`employee_id` ASC),
  INDEX `fk_services_department1_idx` (`department_id` ASC),
  CONSTRAINT `fk_services_users1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_services_users2`
    FOREIGN KEY (`employee_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_services_department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `mydb`.`department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;