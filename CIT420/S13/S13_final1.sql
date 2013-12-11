-- S13_final1.sql
-- --------------------------------------------------------------
USE idmgmtdb;

\. create_identity_db4_mysql.sql

-- -----------------------------------------------------------------------------------------------------
--                                           GET_SESSION                                              --
-- -----------------------------------------------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS get_session$$
CREATE PROCEDURE get_session
(sessionid          VARCHAR(30)
,userid             VARCHAR(20)
,passwd             VARCHAR(40)
,remote_address     VARCHAR(15)
,OUT sv_userid      VARCHAR(20)
,OUT sv_client_info INT UNSIGNED
,OUT return_value   INT UNSIGNED)
MODIFIES SQL DATA
BEGIN

  -- DECLARE LOCAL VARIABLES FOR SELECT INTO AND HANDLER VARIABLE
  DECLARE lv_system_user_id         INT UNSIGNED;
  DECLARE lv_system_user_name       VARCHAR(20);
  DECLARE lv_system_user_group_id   INT UNSIGNED;
  DECLARE lv_system_remote_address  VARCHAR(15);
  DECLARE lv_system_session_id      INT UNSIGNED;
  DECLARE lv_fetched                INT UNSIGNED DEFAULT 1;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched := 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK TO here;
      SELECT 'INSERT OR UPDATE' AS 'ERROR';
    END;

  SELECT   su.system_user_id
  ,        su.system_user_name
  ,        su.system_user_group_id
  ,        ss.system_remote_address
  ,        ss.system_session_id
  INTO     lv_system_user_id
  ,        lv_system_user_name
  ,        lv_system_user_group_id
  ,        lv_system_remote_address
  ,        lv_system_session_id
  FROM     system_user su JOIN system_session ss
  ON       su.system_user_id = ss.system_user_id
  WHERE    ss.system_session_number = sessionid
  AND      ss.last_update_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 5 MINUTE);

  START TRANSACTION;
  SAVEPOINT here;

  IF lv_fetched = 1 THEN

    SET sv_userid := lv_system_user_name;

    IF lv_system_user_group_id = 0 THEN
      SET sv_client_info := lv_system_user_group_id;
    ELSE
      SET sv_client_info := lv_system_user_id;
    END IF;

    IF remote_address = lv_system_remote_address THEN

      SELECT 'UPDATE_SESSION' AS 'VALID SESSION';
      UPDATE  system_session
        SET   last_update_date = NOW()
        WHERE system_session_number = sessionid
        AND   system_remote_address = remote_address;

      SET return_value := lv_system_session_id;

    ELSE

      SELECT 'INVALID REMOTE ADDRESS' AS 'INVALID_SESSION';
      INSERT INTO invalid_session VALUES (NULL,sessionid,remote_address,1,NOW(),1,NOW());

      SET return_value := 0;

    END IF;

  ELSE

    IF (userid IS NULL) AND (passwd IS NULL) THEN

      SELECT 'INVALID USERID/PASSWD CHANGE' AS 'INVALID_SESSION';
      INSERT INTO invalid_session VALUES (NULL,sessionid,remote_address,1,NOW(),1,NOW());

    END IF;

    SELECT '5+ MINUTE TIMEOUT' AS 'INVALID_SESSION';
    SET return_value := 0;

  END IF;

  COMMIT;

END;
$$


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


-- --------------------------------------------------------------
--                       ISSET_SESSIONID                       --
-- --------------------------------------------------------------
DELIMITER $$
DROP FUNCTION IF EXISTS isset_sessionid$$
CREATE FUNCTION isset_sessionid
(sessionid VARCHAR(30)) RETURNS INT UNSIGNED
BEGIN

  DECLARE lv_result INT DEFAULT 0;

  SELECT   1 INTO lv_result
  FROM     system_session
  WHERE    system_session_number = sessionid;

  RETURN lv_result;

END;
$$
-- --------------------------------------------------------------
--                    REGISTER_SESSION                         --
-- --------------------------------------------------------------
DROP PROCEDURE IF EXISTS register_session$$
CREATE PROCEDURE register_session
(userid            INT UNSIGNED -- system_user_id
,remote_address    VARCHAR(15)  -- system_remote_address
,sessionid         VARCHAR(30)  -- system_session_number
,OUT sv_session_id INT UNSIGNED)
BEGIN

  DECLARE lv_fetched  INT UNSIGNED DEFAULT 1;
  DECLARE lv_inserted INT UNSIGNED DEFAULT 1;
  DECLARE lv_system_session_id INT UNSIGNED;

  DECLARE c CURSOR FOR
    SELECT   system_session_id
    FROM     system_session
    WHERE    system_session_number = sessionid
    AND      system_user_id = userid;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched := 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_inserted := 0;

  INSERT INTO system_session VALUES
  (NULL,sessionid,remote_address,userid,userid,NOW(),userid,NOW());

  IF lv_inserted = 1 THEN
    OPEN c;
    FETCH c INTO lv_system_session_id;
    CLOSE c;
    IF lv_fetched = 1 THEN
      SET sv_session_id = lv_system_session_id;
    ELSE
      SET sv_session_id = 0;
    END IF;
  END IF;

  COMMIT;

END;
$$
-- --------------------------------------------------------------
--                    VERIFY_DB_LOGIN                          --
-- --------------------------------------------------------------
DROP PROCEDURE IF EXISTS verify_db_login$$
CREATE PROCEDURE verify_db_login
(userid              VARCHAR(20)    -- system_user_name
,passwd              VARCHAR(40)    -- system_user_password
,remote_address      VARCHAR(15)    -- system_remote_address
,INOUT sv_session_id INT UNSIGNED   -- system_session_id
,INOUT sv_sessionid  VARCHAR(30)    -- system_session_number
,INOUT sv_db_userid  INT UNSIGNED   -- system_user_id
,OUT sv_client_info  INT UNSIGNED   -- system_user_group_id
,OUT return_value    INT UNSIGNED)
BEGIN

  DECLARE lv_system_user_id       INT UNSIGNED;
  DECLARE lv_system_user_group_id INT UNSIGNED;
  DECLARE lv_fetched              INT UNSIGNED DEFAULT 1;

  DECLARE c CURSOR FOR
    SELECT   system_user_id
    ,        system_user_group_id
    FROM     system_user
    WHERE    system_user_name = userid
    AND      system_user_password = passwd
    AND      NOW() BETWEEN start_date AND IFNULL(end_date,NOW());

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched := 0;

  OPEN c;
  FETCH c INTO lv_system_user_id, lv_system_user_group_id;
  CLOSE c;

  IF lv_fetched = 1 THEN
    IF (sv_sessionid IS NULL) OR
       (isset_sessionid(sv_sessionid) = 0)
    THEN
      SET sv_db_userid := lv_system_user_id;
      SET sv_client_info := lv_system_user_group_id;
      CALL register_session(sv_db_userid,remote_address,sv_sessionid,sv_session_id);
    END IF;
    SET return_value := 1;
  ELSE
    SET return_value := 0;
  END IF;

END;
$$
-- --------------------------------------------------------------
--                   TEST_VERIFY_DB_LOGIN                      --
-- --------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS test_verify_db_login$$
CREATE PROCEDURE test_verify_db_login()
BEGIN

  DECLARE stmt VARCHAR(2000);

  SET @remote_address='192.168.1.14';
  SET @sv_sessionid='1231234';

  SELECT system_user_name
  ,      system_user_password
  INTO   @userid
  ,      @passwd
  FROM   system_user
  WHERE  system_user_id = 1;

  SET @SQL = 'TRUNCATE TABLE system_session';
  PREPARE stmt FROM @SQL;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  CALL verify_db_login(@userid,@passwd,@remote_address
                      ,@sv_session_id,@sv_sessionid,@sv_db_userid
                      ,@sv_client_info,@return_value);

  SELECT COUNT(*) INTO @count FROM system_session;

  IF  @sv_db_userid   IS NOT NULL
  AND @sv_client_info IS NOT NULL
  AND @sv_session_id  IS NOT NULL
  AND @count > 0
  AND @return_value = 1
  THEN
    SELECT 'SUCCESS!' AS 'TEST 1';
  ELSE
    SELECT 'FAILURE!' AS 'TEST 1';
  END IF;

END;
$$
DELIMITER ;
CALL test_verify_db_login();

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

  SELECT system_user_name INTO @nuserid FROM system_user LIMIT 1;
  SET @sv_client_info = 0;

  -- Test Case #1: Verify call to the new procedure with an existing user.
  CALL create_new_db_user(@userid,@nuserid,@npasswd,@fname,@lname
                         ,@ugroup,@sv_client_info,@lv_result);

  IF lv_result = 0 THEN
    SET @test1 := 1;
  END IF;

  -- Test Case #2: Verify call to the new procedure with a new user.
  SET @userid = 1;
  SET @ugroup = 1;
  SET @nuserid := 'cwcraigo';
  SET @npasswd := 'Pa$$w0rd';
  SET @fname   := 'Craig';
  SET @lname   := 'Christensen';

  CALL create_new_db_user(@userid,@nuserid,@npasswd,@fname,@lname
                          ,@ugroup,@sv_client_info,@lv_result);

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
