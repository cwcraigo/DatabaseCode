-- SUDO CODE FOR CIT420 FINAL

VERIFY_DB_LOGIN
(userid
,passwd
,sv_session_id IN OUT
,sv_sessionid  IN OUT
,sv_db_userid  IN OUT
,sv_client_info 	OUT
,return_value 	OUT
)

SELECT system_user_id
,      system_user_group_id
FROM   system_user
WHERE  system_user_name = userid
AND    system_user_password = passwd
AND    SYSDATE BETWEEN start_date
AND 	 NVL(end_date,SYSDATE);

if fetches then
	if (sv_session_id is not null
		 OR isset_sessionid(sv_sessionid) ) then
		sv_db_userid = system_user_id
		sv_client_info = system_user_group_id
		register_session(sv_db_userid,sv_sessionid)
	endif
	return_value = true
else
	return_value = false
endif




