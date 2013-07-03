-- SUDO CODE FOR CIT 420 FINAL - PART 2

-- --------------------------------------------------------------
VERIFY_DB_LOGIN -- (LINE 607)
  ( userid
  , passwd
  , sv_session_id
  , sv_sessionid
  , sv_db_userid
  , sv_client_info
  , remote_address)

  SELECT   system_user_id
  ,        system_user_group_id
  INTO     lv_system_user_id
  ,        lv_system_user_group_id
  FROM     system_user
  WHERE    system_user_name = userid
  AND      system_user_password = passwd
  AND      NOW() BETWEEN start_date
                   AND IFNULL(end_date,NOW());

  IF fetched THEN

    IF (sv_sessionid IS NULL) OR
       (isset_sessionid(sv_sessionid) = FALSE)
    THEN
      sv_db_userid = system_user_id
      sv_client_info = system_user_group_id
      register_session(sv_db_userid,sv_sessionid,remote_address)
    END IF;

    RETURN TRUE;

  ELSE

    RETURN FALSE;

  END IF;

-- --------------------------------------------------------------

-- --------------------------------------------------------------
ISSET_SESSIONID
(sessionid)

lv_result INT DEFAULT 0;

SELECT   1 INTO lv_result
FROM     system_session
WHERE    system_session_number = sessionid;

RETURN lv_result;


-- --------------------------------------------------------------

-- --------------------------------------------------------------
REGISTER_SESSION
(userid
,remote_address
,sessionid
,sv_session_id)

INSERT INTO system_session VALUES
(NULL,sessionid,remote_address,userid,userid,NOW(),userid,NOW());

IF inserted THEN

  SELECT   system_session_id
  FROM     system_session
  WHERE    system_session_number = sessionid
  AND      system_user_id = userid;

  IF fetched THEN
    sv_session_id = system_session_id;
  ELSE
    sv_session_id = 0;
  END IF;

END IF;



-- --------------------------------------------------------------

-- Test Case #1: Verify the submission of valid credentials.