-- S13_final1.sql
-- --------------------------------------------------------------
USE idmgmtdb;

\. create_identity_db4_mysql.sql

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



-- DROP PROCEDURE IF EXISTS test_verify_db_login$$
-- CREATE PROCEDURE test_verify_db_login()
-- BEGIN

--   SET @remote_address := '192.168.1.1';                -- system_remote_address
--   SET @sv_sessionid := '12345';                        -- system_session_number
--   SET @userid := 'administrator';                      -- system_user_name
--   SET @password := (SELECT system_user_password
--                     FROM system_user
--                     WHERE system_user_name = @userid); -- system_user_password

--   CALL verify_db_login(@userid,@password,@remote_address,@sv_session_id
--                 ,@sv_sessionid,@sv_db_userid,@sv_client_info,@return_value);

--   SELECT IF(COUNT(*)=1 AND @return_value=1,'SUCCESS','FAILURE') AS 'TEST CASE #1'
--   FROM system_session;

-- END;
-- $$
-- DELIMITER ;

-- CALL test_verify_db_login();