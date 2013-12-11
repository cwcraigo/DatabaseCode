-- S13_final_oracle.sql
-- --------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------
--                                           GET_SESSION                                              --
-- -----------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_session
(sessionid          VARCHAR2
,userid             VARCHAR2
,passwd             VARCHAR2
,remote_address     VARCHAR2
,sv_userid      OUT VARCHAR2
,sv_client_info OUT NUMBER
,return_value   OUT NUMBER) IS

  PRAGMA AUTONOMOUS_TRANSACTION;

  lv_system_user_id         NUMBER;
  lv_system_user_name       VARCHAR(20);
  lv_system_user_group_id   NUMBER;
  lv_system_remote_address  VARCHAR(15);
  lv_system_session_id      NUMBER;

  CURSOR c IS
    SELECT   su.system_user_id
    ,        su.system_user_name
    ,        su.system_user_group_id
    ,        ss.system_remote_address
    ,        ss.system_session_id
    FROM     system_user su JOIN system_session ss
    ON       su.system_user_id = ss.system_user_id
    WHERE    ss.system_session_number = sessionid
    AND     (SYSDATE - ss.last_update_date) <= .003472222;

BEGIN

  OPEN c;
  FETCH c INTO lv_system_user_id
             , lv_system_user_name
             , lv_system_user_group_id
             , lv_system_remote_address
             , lv_system_session_id;

  IF c%FOUND THEN

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

  CLOSE c;

  COMMIT;

END;
$$

DELIMITER ;
