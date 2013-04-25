-- create_identity_db3.sql
-- PHP Identity Management & Cascading Style Sheets
-- by Michael McLaughlin
--
-- This creates and seeds the data model.

USE IDMGMT;

-- Open script output file.
TEE create_identity_db2.log


-- ------------------------------------------------------------------
-- Create SYSTEM_USER table and sequence and seed data.
-- ------------------------------------------------------------------

-- Conditionally drop objects.

DROP TABLE IF EXISTS system_user;
-- Create table.
CREATE TABLE system_user
( system_user_id              INT          PRIMARY KEY AUTO_INCREMENT
, system_user_name            VARCHAR(20)  NOT NULL
, system_user_password        VARCHAR(40)  NOT NULL
, system_user_group_id        INT          NOT NULL
, start_date                  TIMESTAMP    NOT NULL
, end_date                    TIMESTAMP
, last_name                   VARCHAR(20)
, first_name                  VARCHAR(20)
, middle_initial              VARCHAR(1)
, created_by                  INT         NOT NULL
, creation_date               TIMESTAMP   NOT NULL
, last_updated_by             INT         NOT NULL
, last_update_date            TIMESTAMP   NOT NULL);


-- Seed an authorized user.
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
( null
,'administrator'
,'c0b137fe2d792459f26ff763cce44574a5b5ab03'
, 0
, NOW()
, 1
, NOW()
, 1
, NOW());

-- Seed an authorized user.
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
( null
,'guest'
,'35675e68f4b5af7b995d9205ad0fc43842f16450'
, 1
, NOW()
, 1
, NOW()
, 1
, NOW());

-- ------------------------------------------------------------------
-- Create SYSTEM_USER table and sequence.
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS system_session;

-- Create table.
CREATE TABLE system_session
( system_session_id           INT          PRIMARY KEY AUTO_INCREMENT
, system_session_number       VARCHAR(30)    NOT NULL
, system_remote_address       VARCHAR(15) NOT NULL
, system_user_id              INT          NOT NULL
, created_by                  INT          NOT NULL
, creation_date               TIMESTAMP         NOT NULL
, last_updated_by             INT          NOT NULL
, last_update_date            TIMESTAMP         NOT NULL);


-- ------------------------------------------------------------------
-- Create INVALID_SESSION table and sequence.
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS invalid_session;

-- Create table.
CREATE TABLE invalid_session
( invalid_session_id          INT           PRIMARY KEY AUTO_INCREMENT
, invalid_session_INT         VARCHAR(30)  NOT NULL
, invalid_remote_address      VARCHAR(15)  NOT NULL
, created_by                  INT           NOT NULL
, creation_date               TIMESTAMP          NOT NULL
, last_updated_by             INT           NOT NULL
, last_update_date            TIMESTAMP          NOT NULL);


-- ------------------------------------------------------------------
-- Create ACTIVITY_HISTORY table and sequence.
-- ------------------------------------------------------------------


DROP TABLE IF EXISTS activity_history;

-- Create table.
CREATE TABLE activity_history
( activity_history_id         INT           PRIMARY KEY AUTO_INCREMENT
, activity_module_name        VARCHAR(30)  NOT NULL
, actual_module_id            INT              NOT NULL
, defined_module_id           INT           NOT NULL
, created_by                  INT           NOT NULL
, creation_date               TIMESTAMP          NOT NULL
, last_updated_by             INT           NOT NULL
, last_update_date            TIMESTAMP          NOT NULL);


-- ------------------------------------------------------------------
-- Create DEFINED_MODULE table and sequence.
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS defined_module;

-- Create table.
CREATE TABLE defined_module
( defined_modual_id           INT           PRIMARY KEY AUTO_INCREMENT
, defined_modual_name         VARCHAR(30)     NOT NULL
, start_date                  TIMESTAMP          NOT NULL
, end_date                    TIMESTAMP          NOT NULL
, created_by                  INT           NOT NULL
, creation_date               TIMESTAMP          NOT NULL
, last_updated_by             INT           NOT NULL
, last_update_date            TIMESTAMP          NOT NULL);

-- ------------------------------------------------------------------
-- Create FORMAL_PARAMETER table and sequence.
-- ------------------------------------------------------------------
DROP TABLE IF EXISTS formal_parameter;

-- Create table.
CREATE TABLE formal_parameter
( formal_parameter_id         INT              PRIMARY KEY AUTO_INCREMENT
, formal_parameter_name       VARCHAR(30)   NOT NULL
, formal_parameter_type       VARCHAR(30)   NOT NULL
, start_date                  TIMESTAMP          NOT NULL
, end_date                    TIMESTAMP          NOT NULL
, created_by                  INT           NOT NULL
, creation_date               TIMESTAMP          NOT NULL
, last_updated_by             INT           NOT NULL
, last_update_date            TIMESTAMP          NOT NULL);


-- ------------------------------------------------------------------
-- Create ACTUAL_MODULE table and sequence.
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS actual_module;

-- Create table.
CREATE TABLE actual_module
( actual_modual_id            INT             PRIMARY KEY AUTO_INCREMENT
, actual_modual_name          VARCHAR(30)     NOT NULL
, start_date                  TIMESTAMP            NOT NULL
, end_date                    TIMESTAMP            NOT NULL
, created_by                  INT             NOT NULL
, creation_date               TIMESTAMP            NOT NULL
, last_updated_by             INT             NOT NULL
, last_update_date            TIMESTAMP            NOT NULL);


-- ------------------------------------------------------------------
-- Create ACTUAL_PARAMETER table and sequence.
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS actual_parameter;

-- Create table.
CREATE TABLE actual_parameter
( actual_parameter_id         INT         PRIMARY KEY AUTO_INCREMENT
, actual_parameter_name       VARCHAR(30) NOT NULL
, actual_parameter_type       VARCHAR(30) NOT NULL
, start_date                  TIMESTAMP        NOT NULL
, end_date                    TIMESTAMP        NOT NULL
, created_by                  INT         NOT NULL
, creation_date               TIMESTAMP        NOT NULL
, last_updated_by             INT         NOT NULL
, last_update_date            TIMESTAMP        NOT NULL);


-- ------------------------------------------------------------------
-- Create ITEM_CATALOG table and sequence.
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS item_catalog;

-- Create table.
CREATE TABLE item_catalog
( item_catalog_id             INT         PRIMARY KEY AUTO_INCREMENT
, item_catalog_type           VARCHAR(30) NOT NULL
, item_name                   VARCHAR(30) NOT NULL
, item_description            VARCHAR(80) NOT NULL
, inventory_item_id           INT         NOT NULL
, start_date                  TIMESTAMP        NOT NULL
, end_date                    TIMESTAMP        NOT NULL
, created_by                  INT         NOT NULL
, creation_date               TIMESTAMP        NOT NULL
, last_updated_by             INT         NOT NULL
, last_update_date            TIMESTAMP        NOT NULL);


-- ------------------------------------------------------------------
-- Create COMMON_LOOKUP table and sequence and seed data.
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS common_lookup;

CREATE TABLE common_lookup
( common_lookup_id            INT         NOT NULL -- PRIMARY KEY AUTO_INCREMENT
, common_lookup_context       VARCHAR(30) NOT NULL
, common_lookup_type          VARCHAR(30) NOT NULL
, common_lookup_meaning       VARCHAR(30) NOT NULL
, created_by                  INT         NOT NULL
, creation_date               TIMESTAMP        NOT NULL
, last_updated_by             INT         NOT NULL
, last_update_date            TIMESTAMP        NOT NULL);

INSERT INTO common_lookup VALUES
( 0,'SYSTEM_USER','SYSTEM_ADMIN','System Administrator'
, 1, NOW(), 1, NOW());

INSERT INTO common_lookup VALUES
( 1,'SYSTEM_USER','END_USER','System User'
, 1, NOW(), 1, NOW());

CREATE OR REPLACE VIEW authorized_user AS
  SELECT   su.system_user_id AS user_id
  ,        su.system_user_name AS user_name
  ,        cl.common_lookup_meaning AS user_privilege
  ,        CASE
             WHEN su.first_name IS NOT NULL AND su.last_name IS NOT NULL
             THEN CONCAT(su.last_name,', ',su.first_name)
             ELSE NULL
           END AS employee_name
  ,        su.system_user_group_id AS group_id
  FROM     system_user su JOIN common_lookup cl
  ON       su.system_user_group_id = cl.common_lookup_id
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

-- Close script output file.

NOTEE

