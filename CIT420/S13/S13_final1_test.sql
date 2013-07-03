USE idmgmtdb;

\. S13_final1.sql

DELIMITER $$

DROP PROCEDURE IF EXISTS get_session_test$$
CREATE PROCEDURE get_session_test()
MODIFIES SQL DATA
BEGIN

  -- Declare local variables used as actual parameters for get_session()
  DECLARE lv_sessionid      VARCHAR(30); -- PHP session id
  DECLARE lv_userid         VARCHAR(20); -- users sign in name
  DECLARE lv_passwd         VARCHAR(40); -- users password
  DECLARE lv_remote_address VARCHAR(15); -- IP address
  DECLARE lv_count          INT UNSIGNED DEFAULT 0;

  SET lv_sessionid      := '12345';
  SET lv_userid         := 'cwcraigo';
  SET lv_passwd         := 'Pa$$w0rd';
  SET lv_remote_address := '192.168.1.1';

  -- Creating session by inserting into system_user and system_session
  INSERT INTO system_user VALUES
  (NULL,lv_userid,lv_passwd,0,NOW(),NULL,NULL,NULL,NULL,1,NOW(),1,NOW());

  INSERT INTO system_session VALUES
  (NULL,lv_sessionid,lv_remote_address
   ,(SELECT system_user_id FROM system_user WHERE system_user_name = lv_userid)
   ,1,DATE_ADD(NOW(), INTERVAL 10 MINUTE),1,NOW());

  -- Execute get_session()
  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,@return_value);

  -- Check values modified by get_session()
  IF (@sv_userid      IS NULL) AND
     (@sv_client_info IS NULL) AND
     (@return_value   = 0)
  THEN
    SELECT 'SUCCESS' AS 'TEST CASE #1';
    SET lv_count := lv_count + 1;
  ELSE
    SELECT 'FAILED' AS 'TEST CASE #1';
  END IF;

  -- TEST CASE #2
  -- Verify last update was within the last 5 minutes.

  -- Update last_update_date to counter test case #1 mock
  UPDATE system_session
    SET  last_update_date = NOW()
    WHERE system_session_id = 1;

  -- Execute get_session()
  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,@return_value);

  -- Check values modified by get_session()
  IF (@sv_userid      = lv_userid) AND
     (@sv_client_info = 0) AND
     (@return_value   <> 0)
  THEN
    SELECT 'SUCCESS' AS 'TEST CASE #2';
    SET lv_count := lv_count + 1;
  ELSE
    SELECT 'FAILED' AS 'TEST CASE #2';
  END IF;

  -- TEST CASE #3
  -- Process an invalid host name (Remote Address, aka: IP Address)
  -- change from the last communication.
  SET lv_remote_address := '192.168.1.2';

  -- Execute get_session()
  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,@return_value);

  -- Check values modified by get_session()
  IF (@sv_userid      = lv_userid) AND
     (@sv_client_info = 0) AND
     (@return_value   = 0)
  THEN
    SELECT 'SUCCESS' AS 'TEST CASE #3';
    SET lv_count := lv_count + 1;
  ELSE
    SELECT 'FAILED' AS 'TEST CASE #3';
  END IF;

  -- TEST CASE #4
  -- Process and invalid change because more than 5 minutes
  -- elapsed from last communication.
  -- OR
  -- [Process an invalid change of user and more than 5 minutes
  -- have elapsed since last communication.]

  -- Modify local user info to mock invalid user change.
  SET lv_sessionid      := '67890';
  SET lv_userid         := NULL;
  SET lv_passwd         := NULL;
  SET lv_remote_address := '192.168.1.5';

  -- Execute get_session()
  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,@return_value);

  -- Check values modified by get_session()
  IF (@sv_userid      IS NULL) AND
     (@sv_client_info IS NULL) AND
     (@return_value   = 0)
  THEN
    SELECT 'SUCCESS' AS 'TEST CASE #4';
    SET lv_count := lv_count + 1;
  ELSE
    SELECT 'FAILED' AS 'TEST CASE #4';
  END IF;

  -- SELECT @sv_userid,@sv_client_info,@return_value;

  IF lv_count = 4 THEN
    SELECT 'SUCCESS!!!' AS 'STEP 1';
  ELSE
    SELECT 'FAILURE!' AS 'STEP 1';
  END IF;

END;
$$

DELIMITER ;

CALL get_session_test();













/*
-- -----------------------------------------------------------------------------------------------------
--                                           Test Cases                                               --
-- -----------------------------------------------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS test_get_session$$
CREATE PROCEDURE test_get_session()
BEGIN

  DECLARE lv_sessionid      VARCHAR(30); -- PHP session id
  DECLARE lv_userid         VARCHAR(20); -- users sign in name
  DECLARE lv_passwd         VARCHAR(40); -- users password
  DECLARE lv_remote_address VARCHAR(15); -- IP address
  DECLARE lv_return_value   INT UNSIGNED;

  SET lv_sessionid      := '12345';
  SET lv_userid         := 'cwcraigo';
  SET lv_passwd         := 'Pa$$w0rd';
  SET lv_remote_address := '192.168.1.1';

  -- Creating session by inserting into system_session
  INSERT INTO system_session VALUES
  ( NULL, '12345', '192.168.1.1'
  ,(SELECT system_user_id FROM system_user WHERE system_user_name = 'administrator')
  ,1, NOW(), 1, NOW());

  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,lv_return_value);

  SELECT @sv_userid, @sv_client_info, lv_return_value AS '1';

END;
$$

-- -----------------------------------------------------------------------------------------------------
--                                      Test Case #1:                                                 --
-- -----------------------------------------------------------------------------------------------------
-- Verify a timeout due to more than a 5 minute lapse since the last client communication.            --
-- -----------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS test_case1$$
CREATE PROCEDURE test_case1()
BEGIN

  DECLARE lv_sessionid      VARCHAR(30); -- PHP session id
  DECLARE lv_userid         VARCHAR(20); -- users sign in name
  DECLARE lv_passwd         VARCHAR(40); -- users password
  DECLARE lv_remote_address VARCHAR(15); -- IP address
  DECLARE lv_return_value   INT UNSIGNED;

  SET lv_sessionid      := '12345';
  SET lv_userid         := 'cwcraigo';
  SET lv_passwd         := 'Pa$$w0rd';
  SET lv_remote_address := '192.168.1.1';

  -- Update last_update_date to mock 5+ min timeout
  UPDATE system_session
    SET  last_update_date = DATE_ADD(NOW(), INTERVAL 10 MINUTE)
    WHERE system_session_id = 1;

  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,lv_return_value);

  -- SELECT COUNT(*) AS '1', lv_return_value AS '0' FROM invalid_session;

  SELECT IF(ss.system_session=1 AND inv.invalid_session=1,1,0) INTO @test1
  FROM (SELECT COUNT(*) AS 'SYSTEM_SESSION' FROM system_session) ss
  CROSS JOIN (SELECT COUNT(*) AS 'INVALID_SESSION' FROM invalid_session) inv;

END;
$$

-- -----------------------------------------------------------------------------------------------------
--                                      Test Case #2:                                                 --
-- -----------------------------------------------------------------------------------------------------
--   Verify last update was within the last 5 minutes.                                                --
-- -----------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS test_case2$$
CREATE PROCEDURE test_case2()
BEGIN

  DECLARE lv_sessionid      VARCHAR(30); -- PHP session id
  DECLARE lv_userid         VARCHAR(20); -- users sign in name
  DECLARE lv_passwd         VARCHAR(40); -- users password
  DECLARE lv_remote_address VARCHAR(15); -- IP address
  DECLARE lv_return_value   INT UNSIGNED;

  SET lv_sessionid      := '12345';
  SET lv_userid         := 'cwcraigo';
  SET lv_passwd         := 'Pa$$w0rd';
  SET lv_remote_address := '192.168.1.1';

  -- Update last_update_date to counter test case #1 mock
  UPDATE system_session
    SET  last_update_date = NOW()
    WHERE system_session_id = 1;

  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,lv_return_value);

  -- SELECT @sv_userid, @sv_client_info, lv_return_value;

  SELECT IF(ss.system_session=1 AND inv.invalid_session=1,1,0) INTO @test2
  FROM (SELECT COUNT(*) AS 'SYSTEM_SESSION' FROM system_session) ss
  CROSS JOIN (SELECT COUNT(*) AS 'INVALID_SESSION' FROM invalid_session) inv;

END;
$$

-- -----------------------------------------------------------------------------------------------------
--                                      Test Case #3:                                                 --
-- -----------------------------------------------------------------------------------------------------
--  Process an invalid host name (Remote Address, aka: IP Address) change from the last communication.                                  --
-- -----------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS test_case3$$
CREATE PROCEDURE test_case3()
BEGIN

  DECLARE lv_sessionid      VARCHAR(30); -- PHP session id
  DECLARE lv_userid         VARCHAR(20); -- users sign in name
  DECLARE lv_passwd         VARCHAR(40); -- users password
  DECLARE lv_remote_address VARCHAR(15); -- IP address
  DECLARE lv_return_value   INT UNSIGNED;

  SET lv_sessionid      := '12345';
  SET lv_userid         := 'cwcraigo';
  SET lv_passwd         := 'Pa$$w0rd';
  SET lv_remote_address := '192.168.1.2';

  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,lv_return_value);

  -- SELECT COUNT(*) AS '2', lv_return_value AS '0' FROM invalid_session;

  SELECT IF(ss.system_session=1 AND inv.invalid_session=2,1,0) INTO @test3
  FROM (SELECT COUNT(*) AS 'SYSTEM_SESSION' FROM system_session) ss
  CROSS JOIN (SELECT COUNT(*) AS 'INVALID_SESSION' FROM invalid_session) inv;

END;
$$

-- -----------------------------------------------------------------------------------------------------
--                                      Test Case #4:                                                 --
-- -----------------------------------------------------------------------------------------------------
-- Process and invalid change because more than 5 minutes elapsed from last communication.            --
-- -----------------------------------------------------------------------------------------------------
-- [Process an invalid change of user and more than 5 minutes have elapsed since last communication.] --
-- -----------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS test_case4$$
CREATE PROCEDURE test_case4()
BEGIN

  DECLARE lv_sessionid      VARCHAR(30); -- PHP session id
  DECLARE lv_userid         VARCHAR(20); -- users sign in name
  DECLARE lv_passwd         VARCHAR(40); -- users password
  DECLARE lv_remote_address VARCHAR(15); -- IP address
  DECLARE lv_return_value   INT UNSIGNED;

  SET lv_sessionid      := '12345';
  SET lv_userid         := 'cwcraigo';
  SET lv_passwd         := 'Pa$$w0rd';
  SET lv_remote_address := '192.168.1.1';

  -- Update last_update_date to mock 5+ min timeout
  UPDATE system_session
    SET  last_update_date = DATE_ADD(NOW(), INTERVAL 10 MINUTE)
    WHERE system_session_id = 1;

  CALL get_session(lv_sessionid,lv_userid,lv_passwd,lv_remote_address
                   ,@sv_userid,@sv_client_info,lv_return_value);

  -- SELECT COUNT(*) AS '2', lv_return_value AS '0' FROM invalid_session;

  SELECT IF(ss.system_session=1 AND inv.invalid_session=3,1,0) INTO @test4
  FROM (SELECT COUNT(*) AS 'SYSTEM_SESSION' FROM system_session) ss
  CROSS JOIN (SELECT COUNT(*) AS 'INVALID_SESSION' FROM invalid_session) inv;

END;
$$

DELIMITER ;

CALL test_get_session();
CALL test_case1();
CALL test_case2();
CALL test_case3();
CALL test_case4();

SELECT IF(@test1=1,'SUCCESS!!!','FAILURE') AS 'TEST CASE #1'
,      IF(@test2=1,'SUCCESS!!!','FAILURE') AS 'TEST CASE #2'
,      IF(@test3=1,'SUCCESS!!!','FAILURE') AS 'TEST CASE #3'
,      IF(@test4=1,'SUCCESS!!!','FAILURE') AS 'TEST CASE #4';
*/