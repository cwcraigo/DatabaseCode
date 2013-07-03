-- --------------------------------------------------------------------------------
--  Program Name:   create_mysql_store_ri2.sql
--  Program Author: Michael McLaughlin
--  Creation Date:  12-FEB-2013
-- --------------------------------------------------------------------------------
--
-- This script demonstrates how to use SQL statements to build a DVD,
-- Game Cartridge and VHS tape store. It also highlights constraints
-- and compound check constraints and seeds the tables with data.

-- Choose the database.
USE studentdb;

-- Open log file.
TEE create_mysql_store.txt

-- This enables dropping tables with foreign key dependencies.
-- It is specific to the InnoDB Engine.
SET FOREIGN_KEY_CHECKS = 0;

-- Conditionally drop objects.
SELECT 'SYSTEM_USER' AS "Drop Table";
DROP TABLE IF EXISTS system_user;

-- ------------------------------------------------------------------
-- Create SYSTEM_USER table.
-- ------------------------------------------------------------------
SELECT 'SYSTEM_USER' AS "Create Table";

CREATE TABLE system_user
( system_user_id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, system_user_name            CHAR(20)     NOT NULL
, system_user_group_id        INT UNSIGNED NOT NULL
, system_user_type            INT UNSIGNED NOT NULL
, first_name                  CHAR(20)
, middle_name                 CHAR(20)
, last_name                   CHAR(20)
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY system_user_fk1 (created_by)
, CONSTRAINT system_user_fk1 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY system_user_fk2 (last_updated_by)
, CONSTRAINT system_user_fk2 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create SYSTEM_USER table.
SELECT 'SYSTEM_USER' AS "ALTER TABLE";
ALTER TABLE system_user AUTO_INCREMENT = 1001;

INSERT INTO system_user
( system_user_name
, system_user_group_id
, system_user_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
('SYSADMIN', 1, 1, 1, UTC_DATE(), 1, UTC_DATE());

-- Conditionally drop objects.
SELECT 'COMMON_LOOKUP' AS "Drop Table";
DROP TABLE IF EXISTS common_lookup;

-- ------------------------------------------------------------------
-- Create COMMON_LOOKUP table.
-- ------------------------------------------------------------------
SELECT 'COMMON_LOOKUP' AS "Create Table";

CREATE TABLE common_lookup
( common_lookup_id            INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, common_lookup_context       CHAR(30)     NOT NULL
, common_lookup_type          CHAR(30)     NOT NULL
, common_lookup_meaning       CHAR(30)     NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, CONSTRAINT common_lookup_u1 UNIQUE INDEX (common_lookup_context, common_lookup_type)
, KEY common_lookup_fk1 (created_by)
, CONSTRAINT common_lookup_fk1 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY common_lookup_fk2 (last_updated_by)
, CONSTRAINT common_lookup_fk2 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create COMMON_LOOKUP table.
SELECT 'COMMON_LOOKUP' AS "ALTER TABLE";
ALTER TABLE common_lookup AUTO_INCREMENT = 1001;

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('SYSTEM_USER','SYSTEM_ADMIN','System Administrator', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('SYSTEM_USER','DBA','Database Administrator', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('CONTACT','EMPLOYEE','Employee', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('CONTACT','CUSTOMER','Customer', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('MEMBER','INDIVIDUAL','Individual Membership', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('MEMBER','GROUP','Group Membership', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('MEMBER','DISCOVER_CARD','Discover Card', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('MEMBER','MASTER_CARD','Master Card', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('MEMBER','VISA_CARD','VISA Card', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('MULTIPLE','HOME','Home', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('MULTIPLE','WORK','Work', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ITEM','DVD_FULL_SCREEN','DVD: Full Screen', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ITEM','DVD_WIDE_SCREEN','DVD: Wide Screen', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ITEM','NINTENDO_GAMECUBE','Nintendo GameCube', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ITEM','PLAYSTATION2','PlayStation2', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ITEM','XBOX','XBOX', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ITEM','VHS_SINGLE_TAPE','VHS: Single Tape', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ITEM','VHS_DOUBLE_TAPE','VHS: Double Tape', 1, UTC_DATE(), 1, UTC_DATE());

-- Conditionally drop objects.
SELECT 'MEMBER' AS "Drop Table";
DROP TABLE IF EXISTS member;

-- ------------------------------------------------------------------
-- Create MEMBER table.
-- ------------------------------------------------------------------
SELECT 'MEMBER' AS "Create Table";

CREATE TABLE member
( member_id                   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, account_number              CHAR(10)     NOT NULL
, credit_card_number          CHAR(19)     NOT NULL
, credit_card_type            INT UNSIGNED NOT NULL
, member_type                 INT UNSIGNED
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY member_fk1 (credit_card_type)
, CONSTRAINT member_fk1 FOREIGN KEY (credit_card_type)
  REFERENCES common_lookup (common_lookup_id)
, KEY member_fk2 (member_type)
, CONSTRAINT member_fk2 FOREIGN KEY (member_type)
  REFERENCES common_lookup (common_lookup_id)
, KEY member_fk3 (created_by)
, CONSTRAINT member_fk3 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY member_fk4 (last_updated_by)
, CONSTRAINT member_fk4 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create MEMBER table.
SELECT 'MEMBER' AS "ALTER TABLE";
ALTER TABLE member AUTO_INCREMENT = 1001;

-- Conditionally drop objects.
SELECT 'CONTACT' AS "Drop Table";
DROP TABLE IF EXISTS contact;

-- ------------------------------------------------------------------
-- Create CONTACT table.
-- ------------------------------------------------------------------
SELECT 'CONTACT' AS "Create Table";

CREATE TABLE contact
( contact_id                  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, member_id                   INT UNSIGNED NOT NULL
, contact_type                INT UNSIGNED NOT NULL
, first_name                  CHAR(20)     NOT NULL
, middle_name                 CHAR(20)
, last_name                   CHAR(20)     NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY contact_fk1 (member_id)
, CONSTRAINT contact_fk1 FOREIGN KEY (member_id)
  REFERENCES member (member_id)
, KEY contact_fk2 (created_by)
, CONSTRAINT contact_fk2 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY contact_fk3 (last_updated_by)
, CONSTRAINT contact_fk3 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create CONTACT table.
SELECT 'CONTACT' AS "ALTER TABLE";
ALTER TABLE contact AUTO_INCREMENT = 1001;

-- Conditionally drop objects.
SELECT 'ADDRESS' AS "Drop Table";
DROP TABLE IF EXISTS address;

-- ------------------------------------------------------------------
-- Create ADDRESS table.
-- ------------------------------------------------------------------
SELECT 'ADDRESS' AS "Create Table";

CREATE TABLE address
( address_id                  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, contact_id                  INT UNSIGNED NOT NULL
, address_type                INT UNSIGNED NOT NULL
, city                        CHAR(30)     NOT NULL
, state_province              CHAR(30)     NOT NULL
, postal_code                 CHAR(20)     NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY address_fk1 (contact_id)
, CONSTRAINT address_fk1 FOREIGN KEY (contact_id)
  REFERENCES contact (contact_id)
, KEY address_fk2 (created_by)
, CONSTRAINT address_fk2 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY address_fk3 (last_updated_by)
, CONSTRAINT address_fk3 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create ADDRESS table.
SELECT 'ADDRESS' AS "ALTER TABLE";
ALTER TABLE address AUTO_INCREMENT = 1001;

-- Conditionally drop objects.
SELECT 'STREET_ADDRESS' AS "Drop Table";
DROP TABLE IF EXISTS street_address;

-- ------------------------------------------------------------------
-- Create STREET_ADDRESS table.
-- ------------------------------------------------------------------
SELECT 'STREET_ADDRESS' AS "Create Table";

CREATE TABLE street_address
( street_address_id           INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, address_id                  INT UNSIGNED NOT NULL
, street_address              CHAR(30)     NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY street_address_fk1 (address_id)
, CONSTRAINT street_address_fk1 FOREIGN KEY (address_id)
  REFERENCES address (address_id)
, KEY street_address_fk2 (created_by)
, CONSTRAINT street_address_fk2 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY street_address_fk3 (last_updated_by)
, CONSTRAINT street_address_fk3 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create STREET_ADDRESS table.
SELECT 'STREET_ADDRESS' AS "ALTER TABLE";
ALTER TABLE street_address AUTO_INCREMENT = 1001;

-- Conditionally drop objects.
SELECT 'TELEPHONE' AS "Drop Table";
DROP TABLE IF EXISTS telephone;

-- ------------------------------------------------------------------
-- Create TELEPHONE table.
-- ------------------------------------------------------------------
SELECT 'TELEPHONE' AS "Drop Table";

CREATE TABLE telephone
( telephone_id                INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, contact_id                  INT UNSIGNED NOT NULL
, address_id                  INT UNSIGNED
, telephone_type              INT UNSIGNED NOT NULL
, country_code                CHAR(3)      NOT NULL
, area_code                   CHAR(6)      NOT NULL
, telephone_number            CHAR(10)     NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY telephone_fk1 (contact_id)
, CONSTRAINT telephone_fk1 FOREIGN KEY (contact_id)
  REFERENCES contact (contact_id)
, KEY telephone_fk2 (address_id)
, CONSTRAINT telephone_fk2 FOREIGN KEY (address_id)
  REFERENCES address (address_id)
, KEY telephone_fk3 (created_by)
, CONSTRAINT telephone_fk3 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY telephone_fk4 (last_updated_by)
, CONSTRAINT telephone_fk4 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create TELEPHONE table.
SELECT 'TELEPHONE' AS "ALTER TABLE";
ALTER TABLE telephone AUTO_INCREMENT = 1001;

-- Conditionally drop objects.
SELECT 'RENTAL' AS "Drop Table";
DROP TABLE IF EXISTS rental;

-- ------------------------------------------------------------------
-- Create RENTAL table.
-- ------------------------------------------------------------------
SELECT 'RENTAL' AS "Create Table";

CREATE TABLE rental
( rental_id                   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, customer_id                 INT UNSIGNED NOT NULL
, check_out_date              DATE         NOT NULL
, return_date                 DATE         NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY rental_fk1 (customer_id)
, CONSTRAINT rental_fk1 FOREIGN KEY (customer_id)
  REFERENCES contact (contact_id)
, KEY rental_fk2 (created_by)
, CONSTRAINT rental_fk2 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY rental_fk3 (last_updated_by)
, CONSTRAINT rental_fk3 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create RENTAL table.
SELECT 'RENTAL' AS "ALTER TABLE";
ALTER TABLE rental AUTO_INCREMENT = 1001;

-- Conditionally drop objects.
SELECT 'RATING_AGENCY' AS "Drop Table";
DROP TABLE IF EXISTS rating_agency;

-- ------------------------------------------------------------------
-- Create RATING_AGENCY table.
-- ------------------------------------------------------------------
SELECT 'RATING_AGENCY' AS "Create Table";


CREATE TABLE rating_agency
( rating_agency_id    INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, rating              CHAR(5)      NOT NULL
, rating_agency       CHAR(4)      NOT NULL
, rating_agency_name  CHAR(50)     NOT NULL
, created_by          INT UNSIGNED NOT NULL
, creation_date       DATE         NOT NULL
, last_updated_by     INT UNSIGNED NOT NULL
, last_update_date    DATE         NOT NULL
, KEY rating_agency_fk1 (created_by)
, CONSTRAINT rating_agency_fk1 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY rating_agency_fk2 (last_updated_by)
, CONSTRAINT rating_agency_fk2 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB AUTO_INCREMENT = 1001 DEFAULT CHARSET=utf8;

-- ------------------------------------------------------------------
-- Create RATING_AGENCY table.
-- ------------------------------------------------------------------
SELECT 'RATING_AGENCY' AS "Seed Table";

INSERT INTO rating_agency
VALUES
 ( null
 , 'NR'
 ,'MPAA'
 ,'Motion Picture Association of America'
 , 1003, UTC_DATE(), 1003, UTC_DATE())
,( null
 , 'G'
 ,'MPAA'
 ,'Motion Picture Association of America'
 , 1003, UTC_DATE(), 1003, UTC_DATE())
,( null
 , 'PG'
 ,'MPAA'
 ,'Motion Picture Association of America'
 , 1003, UTC_DATE(), 1003, UTC_DATE())
,( null
 , 'PG-13'
 ,'MPAA'
 ,'Motion Picture Association of America'
 , 1003, UTC_DATE(), 1003, UTC_DATE())
,( null
 , 'R'
 ,'MPAA'
 ,'Motion Picture Association of America'
 , 1003, UTC_DATE(), 1003, UTC_DATE())
,( null
 , 'E'
 ,'ESRB'
 ,'Entertainment Software Rating Board'
 , 1003, UTC_DATE(), 1003, UTC_DATE())
,( null
 , 'M'
 ,'ESRB'
 ,'Entertainment Software Rating Board'
 , 1003, UTC_DATE(), 1003, UTC_DATE())
,( null
 , 'T'
 ,'ESRB'
 ,'Entertainment Software Rating Board'
 , 1003, UTC_DATE(), 1003, UTC_DATE());

-- Conditionally drop objects.
SELECT 'ITEM' AS "Drop Table";
DROP TABLE IF EXISTS item;

-- ------------------------------------------------------------------
-- Create ITEM table.
-- ------------------------------------------------------------------
SELECT 'ITEM' AS "Create Table";

CREATE TABLE item
( item_id                     INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, item_barcode                CHAR(18)     NOT NULL
, item_type                   INT UNSIGNED NOT NULL
, item_title                  CHAR(60)     NOT NULL
, item_subtitle               CHAR(60)
, item_rating_id              INT UNSIGNED NOT NULL
, item_release_date           DATE         NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY item_fk1 (item_type)
, CONSTRAINT item_fk1 FOREIGN KEY (item_type)
  REFERENCES common_lookup (common_lookup_id)
, KEY item_fk2 (item_rating_id)
, CONSTRAINT item_fk2 FOREIGN KEY (item_rating_id)
  REFERENCES rating_agency (rating_agency_id)
, KEY item_fk3 (created_by)
, CONSTRAINT item_fk3 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY item_fk4 (last_updated_by)
, CONSTRAINT item_fk4 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create ITEM table.
SELECT 'ITEM' AS "ALTER TABLE";
ALTER TABLE item AUTO_INCREMENT = 1001;

-- Conditionally drop objects.
SELECT 'RENTAL_ITEM' AS "Drop Table";
DROP TABLE IF EXISTS rental_item;

-- ------------------------------------------------------------------
-- Create RENTAL_ITEM table.
-- ------------------------------------------------------------------
SELECT 'RENTAL_ITEM' AS "Create Table";

CREATE TABLE rental_item
( rental_item_id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, rental_id                   INT UNSIGNED NOT NULL
, item_id                     INT UNSIGNED NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY rental_item_fk1 (rental_id)
, CONSTRAINT rental_item_fk1 FOREIGN KEY (rental_id)
  REFERENCES rental (rental_id)
, KEY rental_item_fk2 (item_id)
, CONSTRAINT rental_item_fk2 FOREIGN KEY (item_id)
  REFERENCES item (item_id)
, KEY rental_item_fk3 (created_by)
, CONSTRAINT rental_item_fk3 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, KEY rental_item_fk4 (last_updated_by)
, CONSTRAINT rental_item_fk4 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create RENTAL_ITEM table.
SELECT 'RENTAL_ITEM' AS "ALTER TABLE";
ALTER TABLE rental_item AUTO_INCREMENT = 1001;

-- Commit inserts.
COMMIT;

-- Display tables.
SHOW TABLES;

NOTEE