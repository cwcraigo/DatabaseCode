-- create_identity_db3.sql
-- PHP Identity Management & Cascading Style Sheets
-- by Michael McLaughlin
--
-- This creates and seeds the data model.

-- Open script output file.
SPOOL create_identity_db2.log

-- SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- ------------------------------------------------------------------
-- Create SYSTEM_USER table and sequence and seed data.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'SYSTEM_USER') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE system_user CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'SYSTEM_USER_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE system_user_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE system_user
( system_user_id              NUMBER       CONSTRAINT pk_su1 PRIMARY KEY
, system_user_name            VARCHAR2(20) CONSTRAINT nn_su1 NOT NULL
, system_user_password        VARCHAR2(40) CONSTRAINT nn_su2 NOT NULL
, system_user_group_id        NUMBER       CONSTRAINT nn_su3 NOT NULL
, start_date                  DATE         CONSTRAINT nn_su4 NOT NULL
, end_date                    DATE
, last_name                   VARCHAR2(20)
, first_name                  VARCHAR2(20)
, middle_initial              VARCHAR2(1)
, created_by                  NUMBER       CONSTRAINT nn_su5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_su6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_su7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_su8 NOT NULL);

-- Create sequence.
CREATE SEQUENCE system_user_s1 START WITH 1001;

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
( 1
,'administrator'
,'c0b137fe2d792459f26ff763cce44574a5b5ab03'
, 0
, SYSDATE
, 1
, SYSDATE
, 1
, SYSDATE);

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
( 2
,'guest'
,'35675e68f4b5af7b995d9205ad0fc43842f16450'
, 1
, SYSDATE
, 1
, SYSDATE
, 1
, SYSDATE);

-- ------------------------------------------------------------------
-- Create SYSTEM_USER table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'SYSTEM_SESSION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE system_session CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'SYSTEM_SESSION_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE system_session_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE system_session
( system_session_id           NUMBER       CONSTRAINT pk_ss1 PRIMARY KEY
, system_session_number       VARCHAR2(30) CONSTRAINT nn_ss1 NOT NULL
, system_remote_address       VARCHAR2(15) CONSTRAINT nn_ss2 NOT NULL
, system_user_id              NUMBER       CONSTRAINT nn_ss3 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_ss4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_ss5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_ss6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_ss7 NOT NULL);

-- Create sequence.
CREATE SEQUENCE system_session_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create INVALID_SESSION table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'INVALID_SESSION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE invalid_session CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'INVALID_SESSION_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE invalid_session_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE invalid_session
( invalid_session_id          NUMBER       CONSTRAINT pk_is1 PRIMARY KEY
, invalid_session_number      VARCHAR2(30) CONSTRAINT nn_is1 NOT NULL
, invalid_remote_address      VARCHAR2(15) CONSTRAINT nn_is2 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_is3 NOT NULL
, creation_date               DATE         CONSTRAINT nn_is4 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_is5 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_is6 NOT NULL);

-- Create sequence.
CREATE SEQUENCE invalid_session_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create ACTIVITY_HISTORY table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'ACTIVITY_HISTORY') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE activity_history CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'ACTIVITY_HISTORY_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE activity_history_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE activity_history
( activity_history_id         NUMBER       CONSTRAINT pk_ah1 PRIMARY KEY
, activity_module_name        VARCHAR2(30) CONSTRAINT nn_ah1 NOT NULL
, actual_module_id            NUMBER       CONSTRAINT nn_ah2 NOT NULL
, defined_module_id           NUMBER       CONSTRAINT nn_ah3 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_ah4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_ah5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_ah6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_ah7 NOT NULL);

-- Create sequence.
CREATE SEQUENCE activity_history_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create DEFINED_MODULE table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'DEFINED_MODULE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE defined_module CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'DEFINED_MODULE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE defined_module_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE defined_module
( defined_modual_id           NUMBER       CONSTRAINT pk_dm1 PRIMARY KEY
, defined_modual_name         VARCHAR2(30) CONSTRAINT nn_dm1 NOT NULL
, start_date                  DATE         CONSTRAINT nn_dm2 NOT NULL
, end_date                    DATE         CONSTRAINT nn_dm3 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_dm4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_dm5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_dm6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_dm7 NOT NULL);

-- Create sequence.
CREATE SEQUENCE defined_module_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create FORMAL_PARAMETER table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'FORMAL_PARAMETER') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE formal_parameter CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'FORMAL_PARAMETER_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE formal_parameter_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE formal_parameter
( formal_parameter_id         NUMBER       CONSTRAINT pk_fp1 PRIMARY KEY
, formal_parameter_name       VARCHAR2(30) CONSTRAINT nn_fp1 NOT NULL
, formal_parameter_type       VARCHAR2(30) CONSTRAINT nn_fp2 NOT NULL
, start_date                  DATE         CONSTRAINT nn_fp3 NOT NULL
, end_date                    DATE         CONSTRAINT nn_fp4 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_fp5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_fp6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_fp7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_fp8 NOT NULL);

-- Create sequence.
CREATE SEQUENCE formal_parameter_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create ACTUAL_MODULE table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'ACTUAL_MODULE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE actual_module CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'ACTUAL_MODULE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE actual_module_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE actual_module
( actual_modual_id            NUMBER       CONSTRAINT pk_am1 PRIMARY KEY
, actual_modual_name          VARCHAR2(30) CONSTRAINT nn_am1 NOT NULL
, start_date                  DATE         CONSTRAINT nn_am2 NOT NULL
, end_date                    DATE         CONSTRAINT nn_am3 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_am4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_am5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_am6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_am7 NOT NULL);

-- Create sequence.
CREATE SEQUENCE actual_module_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create ACTUAL_PARAMETER table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'ACTUAL_PARAMETER') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE actual_parameter CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'ACTUAL_PARAMETER_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE actual_parameter_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE actual_parameter
( actual_parameter_id         NUMBER       CONSTRAINT pk_ap1 PRIMARY KEY
, actual_parameter_name       VARCHAR2(30) CONSTRAINT nn_ap1 NOT NULL
, actual_parameter_type       VARCHAR2(30) CONSTRAINT nn_ap2 NOT NULL
, start_date                  DATE         CONSTRAINT nn_ap3 NOT NULL
, end_date                    DATE         CONSTRAINT nn_ap4 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_ap5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_ap6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_ap7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_ap8 NOT NULL);

-- Create sequence.
CREATE SEQUENCE actual_parameter_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'COMMON_LOOKUP') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE common_lookup CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'COMMON_LOOKUP_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE common_lookup_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create ITEM_CATALOG table and sequence.
-- ------------------------------------------------------------------

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'ITEM_CATALOG') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE item_catalog CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'ITEM_CATALOG_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE item_catalog_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE item_catalog
( item_catalog_id             NUMBER       CONSTRAINT pk_ic1 PRIMARY KEY
, item_catalog_type           VARCHAR2(30) CONSTRAINT nn_ic1  NOT NULL
, item_name                   VARCHAR2(30) CONSTRAINT nn_ic2  NOT NULL
, item_description            VARCHAR2(80) CONSTRAINT nn_ic3  NOT NULL
, inventory_item_id           NUMBER       CONSTRAINT nn_ic4  NOT NULL
, start_date                  DATE         CONSTRAINT nn_ic5  NOT NULL
, end_date                    DATE         CONSTRAINT nn_ic6  NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_ic7  NOT NULL
, creation_date               DATE         CONSTRAINT nn_ic8  NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_ic9  NOT NULL
, last_update_date            DATE         CONSTRAINT nn_ic10 NOT NULL);

-- Create sequence.
CREATE SEQUENCE item_catalog_s1 START WITH 1001;


-- ------------------------------------------------------------------
-- Create COMMON_LOOKUP table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE common_lookup
( common_lookup_id            NUMBER       CONSTRAINT pk_cl1 PRIMARY KEY
, common_lookup_context       VARCHAR2(30) CONSTRAINT nn_cl1 NOT NULL
, common_lookup_type          VARCHAR2(30) CONSTRAINT nn_cl2 NOT NULL
, common_lookup_meaning       VARCHAR2(30) CONSTRAINT nn_cl3 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_cl4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_cl5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_cl6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_cl7 NOT NULL);

CREATE SEQUENCE common_lookup_s1 START WITH 1001;

INSERT INTO common_lookup VALUES
( 0,'SYSTEM_USER','SYSTEM_ADMIN','System Administrator'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( 1,'SYSTEM_USER','END_USER','System User'
, 1, SYSDATE, 1, SYSDATE);

CREATE OR REPLACE VIEW authorized_user AS
  SELECT   su.system_user_id AS user_id
  ,        su.system_user_name AS user_name
  ,        cl.common_lookup_meaning AS user_privilege
  ,        CASE
             WHEN su.first_name IS NOT NULL AND  su.last_name IS NOT NULL
             THEN su.last_name||', '|| su.first_name
             ELSE NULL
           END AS employee_name
  ,        su.system_user_group_id AS group_id
  FROM     system_user su JOIN common_lookup cl
  ON       su.system_user_group_id = cl.common_lookup_id
  WHERE    TO_NUMBER(NVL(SYS_CONTEXT('userenv','client_info'),-1)) = 0
  OR       su.system_user_id =
             TO_NUMBER(NVL(SYS_CONTEXT('userenv','client_info'),-1))
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
SPOOL OFF

-- Cleanup environment.
SET ECHO OFF
SET NULL ''
SET PAGESIZE 12
