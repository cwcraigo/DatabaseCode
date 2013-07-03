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

DELIMITER ;