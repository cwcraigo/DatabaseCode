-- S13_final3.sql
-- --------------------------------------------------------------
USE idmgmtdb;

\. create_identity_db4_mysql.sql

DELIMITER $$
-- --------------------------------------------------------------
--                      IS_INSERTED                            --
-- --------------------------------------------------------------
DROP FUNCTION IF EXISTS is_inserted$$
CREATE FUNCTION is_inserted
(nuserid VARCHAR(20)) RETURNS INT UNSIGNED
BEGIN

  DECLARE lv_result INT UNSIGNED DEFAULT 0;

  SELECT   1 INTO lv_result
  FROM     system_user
  WHERE    system_user_name = nuserid;

  RETURN lv_result;

END;
$$
-- --------------------------------------------------------------
--                    CREATE_NEW_DB_USER                       --
-- --------------------------------------------------------------
DROP PROCEDURE IF EXISTS create_new_db_user$$
CREATE PROCEDURE create_new_db_user
(userid  INT UNSIGNED
,nuserid VARCHAR(20)
,npasswd VARCHAR(40)
,fname   VARCHAR(20)
,lname   VARCHAR(20)
,ugroup  INT UNSIGNED
,sv_client_info INT UNSIGNED
,OUT return_value INT UNSIGNED)
BEGIN

  DECLARE written INT UNSIGNED DEFAULT 0;
  DECLARE inserted INT UNSIGNED DEFAULT 1;

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET inserted := 0;

  IF (is_inserted(nuserid) = 0) AND (sv_client_info = 0) THEN

    INSERT INTO system_user
    ( system_user_name
    , system_user_password
    , first_name
    , last_name
    , system_user_group_id
    , start_date
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES
    (
     nuserid,npasswd,fname,lname,ugroup
     ,NOW(),userid,NOW(),userid,NOW());

    IF inserted = 1 THEN
      SET written := 1;
    END IF;

  END IF;

  SET return_value := written;

END;
$$
-- --------------------------------------------------------------
--               TEST_CREATE_NEW_DB_USER                       --
-- --------------------------------------------------------------
DROP PROCEDURE IF EXISTS test_create_new_db_user$$
CREATE PROCEDURE test_create_new_db_user()
BEGIN

  DECLARE userid         INT UNSIGNED DEFAULT 1;
  DECLARE nuserid        VARCHAR(20)  DEFAULT 'administrator';
  DECLARE npasswd        VARCHAR(40);
  DECLARE fname          VARCHAR(20);
  DECLARE lname          VARCHAR(20);
  DECLARE ugroup         INT UNSIGNED DEFAULT 1;
  DECLARE sv_client_info INT UNSIGNED DEFAULT 0;
  DECLARE lv_result      INT UNSIGNED;

  -- Test Case #1: Verify call to the new procedure with an existing user.
  CALL create_new_db_user(userid,nuserid,npasswd,fname,lname
                          ,ugroup,sv_client_info,lv_result);

  IF lv_result = 0 THEN
    SET @test1 := 1;
  END IF;

  -- Test Case #2: Verify call to the new procedure with a new user.
  SET nuserid := 'cwcraigo';
  SET npasswd := 'Pa$$w0rd';
  SET fname   := 'Craig';
  SET lname   := 'Christensen';

  CALL create_new_db_user(userid,nuserid,npasswd,fname,lname
                          ,ugroup,sv_client_info,lv_result);

  IF lv_result = 1 THEN
    SET @test2 := 1;
  END IF;

  SELECT IF(@test1=1,'SUCCESS!!','FAILURE!!') AS 'TEST CASE #1'
        ,IF(@test2=1,'SUCCESS!!','FAILURE!!') AS 'TEST CASE #2'
        ,IF(COUNT(*)=3,'COMPLETE!!','KEEP WORKING') AS 'STEP #3'
  FROM system_user;

END;
$$
DELIMITER ;

CALL test_create_new_db_user();