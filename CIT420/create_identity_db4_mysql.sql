
-- create_identity_db4_mysql.sql
-- OTN PHP Identity Management, Part 1
-- by Michael McLaughlin
--
-- This creates and seeds the data model.

-- Open script output file.
TEE create_identity_db4.txt

USE idmgmtdb;

-- ------------------------------------------------------------------
-- Create SYSTEM_USER table and sequence and seed data.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE system_user' AS "Statement Processed";
DROP TABLE IF EXISTS system_user;

-- Create table.
SELECT 'CREATE TABLE system_user' AS "Statement Processed";
CREATE TABLE system_user
( system_user_id        INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, system_user_name      VARCHAR(20)   NOT NULL
, system_user_password  VARCHAR(40)   NOT NULL
, system_user_group_id  INT UNSIGNED  NOT NULL
, start_date            DATE          NOT NULL
, end_date              DATE
, last_name             VARCHAR(20)
, first_name            VARCHAR(20)
, middle_initial        VARCHAR(1)
, created_by            INT UNSIGNED  NOT NULL
, creation_date         DATETIME      NOT NULL
, last_updated_by       INT UNSIGNED  NOT NULL
, last_update_date      DATETIME      NOT NULL);

-- Seed an authorized user.
SELECT 'INSERT INTO system_user' AS "Statement Processed";
INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_password
, system_user_group_id
, start_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1
,'administrator'
,'c0b137fe2d792459f26ff763cce44574a5b5ab03'
, 1
, UTC_DATE()
, 1
, NOW()
, 1
, NOW());

-- Seed an authorized user.
SELECT 'INSERT INTO system_user' AS "Statement Processed";
INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_password
, system_user_group_id
, start_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 2
,'guest'
,'35675e68f4b5af7b995d9205ad0fc43842f16450'
, 2
, UTC_DATE()
, 1
, NOW()
, 1
, NOW());

-- ------------------------------------------------------------------
-- Create SYSTEM_SESSION table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE system_session' AS "Statement Processed";
DROP TABLE IF EXISTS system_session;

-- Create table.
SELECT 'CREATE TABLE system_session' AS "Statement Processed";
CREATE TABLE system_session
( system_session_id      INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, system_session_number  VARCHAR(30)   NOT NULL
, system_remote_address  VARCHAR(15)   NOT NULL
, system_user_id         INT UNSIGNED  NOT NULL
, created_by             INT UNSIGNED  NOT NULL
, creation_date          DATETIME      NOT NULL
, last_updated_by        INT UNSIGNED  NOT NULL
, last_update_date       DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create INVALID_SESSION table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE invalid_session' AS "Statement Processed";
DROP TABLE IF EXISTS invalid_session;

-- Create table.
SELECT 'CREATE TABLE invalid_session' AS "Statement Processed";
CREATE TABLE invalid_session
( invalid_session_id      INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, invalid_session_number  VARCHAR(30)   NOT NULL
, invalid_remote_address  VARCHAR(15)   NOT NULL
, created_by              INT UNSIGNED  NOT NULL
, creation_date           DATETIME      NOT NULL
, last_updated_by         INT UNSIGNED  NOT NULL
, last_update_date        DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create ACTIVITY_HISTORY table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE activity_history' AS "Statement Processed";
DROP TABLE IF EXISTS activity_history;

-- Create table.
SELECT 'CREATE TABLE activity_history' AS "Statement Processed";
CREATE TABLE activity_history
( activity_history_id   INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, activity_module_name  VARCHAR(30)   NOT NULL
, actual_module_id      INT UNSIGNED  NOT NULL
, defined_module_id     INT UNSIGNED  NOT NULL
, created_by            INT UNSIGNED  NOT NULL
, creation_date         DATETIME      NOT NULL
, last_updated_by       INT UNSIGNED  NOT NULL
, last_update_date      DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create DEFINED_MODULE table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE defined_module' AS "Statement Processed";
DROP TABLE IF EXISTS defined_module;

-- Create table.
SELECT 'CREATE TABLE defined_module' AS "Statement Processed";
CREATE TABLE defined_module
( defined_modual_id    INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, defined_modual_name  VARCHAR(30)   NOT NULL
, start_date           DATE          NOT NULL
, end_date             DATE          NOT NULL
, created_by           INT UNSIGNED  NOT NULL
, creation_date        DATETIME      NOT NULL
, last_updated_by      INT UNSIGNED  NOT NULL
, last_update_date     DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create FORMAL_PARAMETER table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE formal_parameter' AS "Statement Processed";
DROP TABLE IF EXISTS formal_parameter;

-- Create table.
SELECT 'CREATE TABLE formal_parameter' AS "Statement Processed";
CREATE TABLE formal_parameter
( formal_parameter_id    INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, formal_parameter_name  VARCHAR(30)   NOT NULL
, formal_parameter_type  VARCHAR(30)   NOT NULL
, start_date             DATE          NOT NULL
, end_date               DATE          NOT NULL
, created_by             INT UNSIGNED  NOT NULL
, creation_date          DATETIME      NOT NULL
, last_updated_by        INT UNSIGNED  NOT NULL
, last_update_date       DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create ACTUAL_MODULE table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE actual_module' AS "Statement Processed";
DROP TABLE IF EXISTS actual_module;

-- Create table.
SELECT 'CREATE TABLE actual_module' AS "Statement Processed";
CREATE TABLE actual_module
( actual_modual_id    INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, actual_modual_name  VARCHAR(30)   NOT NULL
, start_date          DATE          NOT NULL
, end_date            DATE          NOT NULL
, created_by          INT UNSIGNED  NOT NULL
, creation_date       DATETIME      NOT NULL
, last_updated_by     INT UNSIGNED  NOT NULL
, last_update_date    DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create ACTUAL_PARAMETER table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE actual_parameter' AS "Statement Processed";
DROP TABLE IF EXISTS actual_parameter;

-- Create table.
SELECT 'CREATE TABLE actual_parameter' AS "Statement Processed";
CREATE TABLE actual_parameter
( actual_parameter_id    INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, actual_parameter_name  VARCHAR(30)   NOT NULL
, actual_parameter_type  VARCHAR(30)   NOT NULL
, start_date             DATE          NOT NULL
, end_date               DATE          NOT NULL
, created_by             INT UNSIGNED  NOT NULL
, creation_date          DATETIME      NOT NULL
, last_updated_by        INT UNSIGNED  NOT NULL
, last_update_date       DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create ITEM_CATALOG table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE item_catalog' AS "Statement Processed";
DROP TABLE IF EXISTS item_catalog;

-- Create table.
SELECT 'CREATE TABLE item_catalog' AS "Statement Processed";
CREATE TABLE item_catalog
( item_catalog_id    INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, item_catalog_type  VARCHAR(30)   NOT NULL
, item_name          VARCHAR(30)   NOT NULL
, item_description   VARCHAR(80)   NOT NULL
, inventory_item_id  INT UNSIGNED  NOT NULL
, start_date         DATE          NOT NULL
, end_date           DATE          NOT NULL
, created_by         INT UNSIGNED  NOT NULL
, creation_date      DATETIME      NOT NULL
, last_updated_by    INT UNSIGNED  NOT NULL
, last_update_date   DATETIME      NOT NULL);

-- ------------------------------------------------------------------
-- Create COMMON_LOOKUP table and sequence and seed data.
-- ------------------------------------------------------------------

-- Conditionally drop table.
SELECT 'DROP TABLE common_lookup' AS "Statement Processed";
DROP TABLE IF EXISTS common_lookup;

-- Create table.
SELECT 'CREATE TABLE common_lookup' AS "Statement Processed";
CREATE TABLE common_lookup
( common_lookup_id       INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, common_lookup_context  VARCHAR(30)   NOT NULL
, common_lookup_type     VARCHAR(30)   NOT NULL
, common_lookup_meaning  VARCHAR(30)   NOT NULL
, created_by             INT UNSIGNED  NOT NULL
, creation_date          DATETIME      NOT NULL
, last_updated_by        INT UNSIGNED  NOT NULL
, last_update_date       DATETIME      NOT NULL);

-- Insert into COMMON_LOOKUP table.
SELECT 'INSERT INTO common_lookup' AS "Statement Processed";
INSERT INTO common_lookup VALUES
( null,'SYSTEM_USER','SYSTEM_ADMIN','System Administrator'
, 1, NOW(), 1, NOW());

-- Insert into COMMON_LOOKUP table.
SELECT 'INSERT INTO common_lookup' AS "Statement Processed";
INSERT INTO common_lookup VALUES
( null,'SYSTEM_USER','END_USER','System User'
, 1, NOW(), 1, NOW());

-- Set delimiter to compile a stored program.
DELIMITER $$

-- Conditionally drop the SET_LOGIN function.
SELECT 'DROP FUNCTION set_login' AS "Statement Processed"$$
DROP FUNCTION IF EXISTS set_login$$

-- Create a SET_LOGIN function.
SELECT 'CREATE FUNCTION set_login' AS "Statement Processsed"$$
CREATE FUNCTION set_login(pv_user_name VARCHAR(20)) RETURNS INT UNSIGNED
BEGIN

  /* Declare a local variable to verify completion of the task. */
  DECLARE  lv_success_flag  INT UNSIGNED  DEFAULT FALSE;
  DECLARE  lv_login_id      INT UNSIGNED;
  DECLARE  lv_group_id      INT UNSIGNED;

  /* Declare a cursor to return an authorized user id. */
  DECLARE authorize_cursor CURSOR FOR
    SELECT   su.system_user_id
    ,        su.system_user_group_id
    FROM     system_user su
    WHERE    su.system_user_name = pv_user_name;

  /* Check whether the input value is something other than a null value. */
  IF pv_user_name IS NOT NULL THEN

    OPEN  authorize_cursor;
    FETCH authorize_cursor INTO lv_login_id, lv_group_id;
    CLOSE authorize_cursor;

    /* Set the success flag. */
    SET @sv_login_id := lv_login_id;
    SET @sv_group_id := lv_group_id;
    SET lv_success_flag := TRUE;

  END IF;

  /* Return the success flag. */
  RETURN lv_success_flag;
END;
$$

-- Conditionally drop SET_LOGIN_ID function.
SELECT 'DROP FUNCTION get_login_id' AS "Statement Processed"$$
DROP FUNCTION IF EXISTS get_login_id$$

-- Create a SET_LOGIN_ID function.
SELECT 'CREATE FUNCTION get_login_id()' AS "Statement Processsed"$$
CREATE FUNCTION get_login_id() RETURNS INT UNSIGNED
BEGIN
  /* Return the success flag. */
  RETURN @sv_login_id;
END;
$$

-- Conditionally drop SET_GROUP_ID function.
SELECT 'DROP FUNCTION get_group_id' AS "Statement Processed"$$
DROP FUNCTION IF EXISTS get_group_id$$

-- Create a GET_GROUP_ID function.
SELECT 'CREATE FUNCTION get_group_id()' AS "Statement Processsed"$$
CREATE FUNCTION get_group_id() RETURNS INT UNSIGNED
BEGIN
  /* Return the success flag. */
  RETURN @sv_group_id;
END;
$$

-- Reset DELIMITER value.
DELIMITER ;

-- Conditionally drop the AUTHORIZED_USER view.
DROP VIEW IF EXISTS authorized_user;

-- Create the AUTHORIZED_USER view.
SELECT 'CREATE VIEW authorized_user' AS "Statement Processed";
CREATE VIEW authorized_user AS
  SELECT   su.system_user_id AS user_id
  ,        su.system_user_name AS user_name
  ,        cl.common_lookup_meaning AS user_privilege
  ,        CASE
             WHEN su.first_name IS NOT NULL AND  su.last_name IS NOT NULL
             THEN CONCAT(su.last_name,', ',su.first_name)
             ELSE NULL
           END AS employee_name
  ,        su.system_user_group_id AS group_id
  FROM     system_user su JOIN common_lookup cl
  ON       su.system_user_group_id = cl.common_lookup_id
  WHERE    IFNULL(get_group_id(),-1) = su.system_user_group_id
  OR       IFNULL(get_login_id(),-1) = su.system_user_id
  ORDER BY CASE
             WHEN first_name IS NULL
             THEN 0
             ELSE 1
           END
  ,        su.last_name
  ,        su.first_name
  ,        su.system_user_id;

-- Commit the records.
COMMIT;

-- Test the SET_LOGIN function.
SELECT set_login('administrator');

-- Query results of the SET_LOGIN function by querying GET_LOGIN_ID
-- and GET_GROUP_ID functions.
SELECT get_login_id() AS "User ID"
,      get_group_id() AS "Group ID";

-- Query the authorized user.
SELECT user_id AS "User ID"
,      group_id AS "Group ID"
,      user_name AS "User Name"
,      user_privilege "User Privilege"
FROM   authorized_user;

-- Query the set of authorized users.
SELECT system_user_id AS "User ID"
,      system_user_group_id AS "Group ID"
,      system_user_name AS "User Name"
FROM   system_user;

-- Close script output file.
NOTEE