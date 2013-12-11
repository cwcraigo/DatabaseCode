CREATE OR REPLACE get_session
(sessionid 					VARCHAR(30)
,userid 						VARCHAR(20)
,passwd 						VARCHAR(40)
,remote_address 		VARCHAR(15)
,sv_userid 			OUT VARCHAR(20)
,sv_client_info OUT NUMBER
,return_value 	OUT NUMBER) IS

	lv_system_user_id 				NUMBER;
	lv_system_user_name				VARCHAR2(60);
	lv_system_user_group_id		NUMBER;
	lv_system_remote_address 	VARCHAR2(60);
	lv_system_session_id 			NUMBER;

BEGIN

	SELECT   su.system_user_id
	,        su.system_user_name
	,        su.system_user_group_id
	,        ss.system_remote_address
	,        ss.system_session_id
	INTO 	   lv_system_user_id
	,        lv_system_user_name
	,        lv_system_user_group_id
	,        lv_system_remote_address
	,        lv_system_session_id
	FROM     system_user su JOIN system_session ss
	ON       su.system_user_id = ss.system_user_id
	WHERE    ss.system_session_number = sessionid
	AND     (ss.last_update_date - SYSDATE) <= .003472222;

	IF (SQL%FOUND) THEN

	  sv_userid := lv_system_user_name;

	  IF (lv_system_user_group_id == 0) THEN

	    sv_client_info := lv_system_user_group_id;

	  ELSE

	    sv_client_info = lv_system_user_id;

	  end if;

	  if (remote_address == lv_system_remote_address) then

	    UPDATE   system_session
		SET      last_update_date = SYSDATE
		WHERE    system_session_number = sessionid
		AND      system_remote_address = remote_address;

	    return lv_system_session_id;

	  else

	    INSERT INTO invalid_session VALUES
			(invalid_session_s1.nextval
			,sessionid,remote_address,-1,SYSDATE,-1,SYSDATE);

	    return 0;

	  end if;

	else

	  if (userid IS NULL AND passwd IS NULL) {
	    INSERT INTO invalid_session VALUES
		(invalid_session_s1.nextval
		,sessionid,remote_address,-1,SYSDATE,-1,SYSDATE);
	  end if;

	  return 0;

	end if;

  }








  // ----------------------------------------------------------------
verify_db_login(userid
			   ,passwd
			   ,sv_session_id
			   ,sv_sessionid
			   ,sv_db_userid
			   ,sv_client_info
			   ,remote_address)

     SELECT   system_user_id
     ,        system_user_group_id
     FROM     system_user
     WHERE    system_user_name = userid
     AND      system_user_password = passwd
     AND      SYSDATE BETWEEN start_date
     AND 	  NVL(end_date,SYSDATE)

    if (fetch)
    {
       if  ( sv_session_id IS NULL ) OR ( isset_sessionid(sv_sessionid) = false )
       {
         sv_db_userid = lv_system_user_id
         sv_client_info = lv_system_user_group_id

         	// instead of register_session(sv_db_userid,sv_sessionid)
         	INSERT INTO system_session VALUES
					(system_session_s1.nextval,sv_sessionid,remote_address
					,sv_db_userid,sv_db_userid,SYSDATE,sv_db_userid,SYSDATE)

			SELECT   system_session_id
			INTO 	 lv_system_session_id
			FROM     system_session
			WHERE    system_session_number = sv_sessionid
			AND      system_user_id = sv_db_userid

			if (SQL%FOUND)
			{
				sv_session_id = lv_system_session_id
			}
			else
			{
				sv_session_id = 0;
			}
       }
       return true;
    }
    else
    {
      return false;
    }

  } // end verify_db_login()



function isset_sessionid(sessionid)
	SELECT   NULL
	FROM     system_session
	WHERE    system_session_number = sessionid

	if (fetch)
		return true;
	else
		return false;
end isset_sessionid()























?>
