-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Recipes
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Recipes` ;

-- -----------------------------------------------------
-- Schema Recipes
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Recipes` DEFAULT CHARACTER SET utf8 ;
USE `Recipes` ;

-- -----------------------------------------------------
-- Table `Recipes`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Recipes`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `pw` CHAR(60) NULL,
  `created_at` DATETIME NULL DEFAULT now(),
  `updated_at` DATETIME NULL DEFAULT now() on update now(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Recipes`.`Recipes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Recipes`.`Recipes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NULL,
  `under_time_limit` VARCHAR(3) NULL,
  `description` VARCHAR(255) NULL,
  `instructions` VARCHAR(255) NULL,
  `date_made` DATE NULL,
  `created_at` DATETIME NULL DEFAULT now(),
  `updated_at` DATETIME NULL DEFAULT now() on update now(),
  `users_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Recipes_users_idx` (`users_id` ASC) VISIBLE,
  CONSTRAINT `fk_Recipes_users`
    FOREIGN KEY (`users_id`)
    REFERENCES `Recipes`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
