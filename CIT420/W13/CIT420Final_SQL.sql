USE IDMGMT;

\. create_identity_db3.sql

/* Creating session by inserting into system_session */
SELECT 'system_session (ADMIN)' AS 'INSERT INTO';
INSERT INTO system_session VALUES
( NULL
, connection_id()
, 'ABCD'
, (SELECT system_user_id FROM system_user WHERE system_user_name = 'administrator')
, 1, NOW(), 1, NOW());

SELECT 'system_session (USER)' AS 'INSERT INTO';
INSERT INTO system_session VALUES
( ULL
, connection_id()
, 'ABCD'
, (SELECT system_user_id FROM system_user WHERE system_user_name = 'guest')
, 1, NOW(), 1, NOW());

SELECT 'FUNCTIONS AND PROCEDURES' AS 'DROP';
DROP FUNCTION  IF EXISTS get_session;
DROP PROCEDURE IF EXISTS update_session;
DROP PROCEDURE IF EXISTS record_session;
DROP PROCEDURE IF EXISTS test_procedure;
DROP PROCEDURE IF EXISTS get_user_id;

DELIMITER $$

-- -------------------------------
-- get_user_id PROCEDURE
-- -------------------------------
SELECT 'get_user_id' AS 'CREATE PROCEDURE';
CREATE PROCEDURE get_user_id
(pv_user_name VARCHAR(20), OUT pv_completed INT)
BEGIN

  DECLARE lv_fetched INT DEFAULT 0;

  DECLARE c CURSOR FOR
    SELECT su.system_user_id
    FROM   system_user su
    WHERE  su.system_user_name = pv_user_name;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched := 1;

  /* Query for an existing new user, return ID or a zero. */
  OPEN c;
  FETCH c INTO pv_completed;
  IF lv_fetched = 1 THEN
    SET pv_completed := 0;
  END IF;
  CLOSE c;

END;
$$

-- -------------------------------
-- update_session PROCEDURE
-- -------------------------------

SELECT 'update_session' AS 'CREATE PROCEDURE';
CREATE PROCEDURE update_session
( pv_session_id       VARCHAR(60)
, pv_remote_address   VARCHAR(60) )
BEGIN

  IF pv_session_id IS NOT NULL OR pv_remote_address IS NOT NULL THEN
  
    UPDATE  system_session
      SET   last_update_date = NOW()
      WHERE system_session_number = pv_session_id
      AND   system_remote_address = pv_remote_address;

  END IF;

END;
$$

-- -------------------------------
-- record_session PROCEDURE
-- -------------------------------
SELECT 'record_session' AS 'CREATE PROCEDURE';
CREATE PROCEDURE record_session
( pv_session_id VARCHAR(60))
BEGIN
  
  DECLARE record_session_failed INT UNSIGNED;

  IF pv_session_id IS NOT NULL THEN

    INSERT INTO invalid_session VALUES
    ( NULL
    , pv_session_id
    , @sv_remote_address
    , 1
    , NOW()
    , 1
    , NOW()
    );


  END IF;

END;
$$

-- -------------------------------
-- get_session PROCEDURE
-- -------------------------------
SELECT 'get_session' AS 'CREATE PROCEDURE';
CREATE PROCEDURE get_session
( IN    pv_sessionid      VARCHAR(30)
, IN    pv_userid         VARCHAR(20)
, IN    pv_password       VARCHAR(40) 
, INOUT pv_remote_addr    VARCHAR(15)
, OUT   sv_userid         VARCHAR(20)
, OUT   sv_client_info    INT)
BEGIN

  /* Local variables for cursor */
  DECLARE lv_system_user_id         INT;
  DECLARE lv_system_user_name       VARCHAR(20);
  DECLARE lv_system_user_group_id   INT;
  DECLARE lv_system_remote_address  VARCHAR(15);
  DECLARE lv_system_session_id      INT;

  /* Handler variable */
  DECLARE lv_fetched                INT DEFAULT 0;

  DECLARE c CURSOR FOR
    SELECT su.system_user_id
    ,      su.system_user_name
    ,      su.system_user_group_id
    ,      ss.system_remote_address
    ,      ss.system_session_id
    FROM   system_user su JOIN system_session ss
    ON     su.system_user_id = ss.system_user_id
    WHERE  ss.system_session_number = pv_session_id
    AND    DATEDIFF(NOW(),ss.last_update_date) <= .003472222;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched := 1;

-- SET A LOCAL VAR FOR pv_remote_address

  OPEN c;
  FETCH c INTO lv_system_user_id, lv_system_user_name
             , lv_system_user_group_id, lv_system_remote_address
             , lv_system_session_id;

  IF lv_fetched = 1 THEN
    
    IF pv_user IS NULL AND pv_password IS NULL THEN
      CALL record_session(pv_session_id);
      CLOSE c;
      RETURN 0;
    END IF;

    CLOSE c;
    RETURN -1;

  END IF;

  SET @sv_user_id := lv_system_user_name;

  IF lv_system_user_group_id = 0 THEN
    SET pv_system_user_group_id = lv_system_user_group_id;
  ELSE
    SET pv_system_user_id = lv_system_user_id;
  END IF;

  IF @sv_remote_address = lv_system_remote_address THEN
    -- CALL update_session(pv_session_id,@sv_remote_address);
    UPDATE  system_session
      SET   last_update_date = NOW()
      WHERE system_session_number = pv_session_id
      AND   system_remote_address = pv_system_remote_address;

    CLOSE c;
    RETURN lv_system_session_id;
  ELSE
    CALL record_session(pv_session_id);
    CLOSE c;
    RETURN 0;
  END IF;

END;
$$

-- -------------------------------
-- test_procedure PROCEDURE
-- -------------------------------
SELECT 'test_procedure' AS 'CREATE PROCEDURE';
CREATE PROCEDURE test_procedure(pv_user_name VARCHAR(20))
BEGIN

  DECLARE lv_user_id         VARCHAR(20);
  DECLARE lv_password        VARCHAR(20);
  DECLARE lv_session         INT;
  DECLARE lv_authenticated   INT;

  -- SET lv_authenticated := 0;

  /* Variables set by php server and php session */
  SET @sv_session_id := connection_id();
  SET @sv_remote_address := 'ABCD';

  /* Name and password from SignOn form. */
  SELECT system_user_password INTO lv_password 
    FROM system_user WHERE system_user_name = pv_user_name;

  SET lv_session := get_session(@sv_session_id, pv_user_name, lv_password);  

  /* If different user or lv_user_id has not been set 
      then regenerate session_id 
      else authentication is true */
  -- IF lv_session = 0 OR 
  --   ((@sv_user_id <> lv_user_id) 
  --     AND (lv_user_id IS NOT NULL)) THEN
  --   SET @sv_session_id := '12345';
  -- ELSE
  --   SET lv_authenticated := 1;
  -- END IF;

  SELECT lv_session, @sv_client_info, pv_user_name, lv_password;

END;
$$

DELIMITER ;

SELECT 'test_procedure' AS 'CALL';
CALL test_procedure('administrator');
CALL test_procedure('guest');

