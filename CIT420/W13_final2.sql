

DELIMITER $$

DROP PROCEDURE IF EXISTS verify_db_login$$
CREATE PROCEDURE verify_db_login
(userid 							VARCHAR(20)
,passwd 							VARCHAR(40)
,INOUT sv_session_id  INT UNSIGNED
,INOUT sv_sessionid   INT UNSIGNED
,INOUT sv_db_userid   INT UNSIGNED
,OUT 	 sv_client_info INT UNSIGNED
,OUT 	 return_value   INT UNSIGNED
)
BEGIN

	DECLARE lv_system_user_id				INT UNSIGNED;
	DECLARE lv_system_user_group_id	INT UNSIGNED;
	DECLARE fetched 								INT UNSIGNED DEFAULT 1;

	DECLARE c CURSOR FOR
		SELECT system_user_id
		,      system_user_group_id
		FROM   system_user
		WHERE  system_user_name = userid
		AND    system_user_password = passwd
		AND    NOW() BETWEEN start_date
		AND 	 IFNULL(end_date,NOW());

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched := 0;

	SET return_value := 0;

	OPEN c;
	myLoop:LOOP

		FETCH c INTO lv_system_user_id, lv_system_user_group_id;

		IF (fetched = 1) THEN
			IF (sv_session_id IS NOT NULL) OR (isset_sessionid(sv_sessionid)) THEN
				SET sv_db_userid   := lv_system_user_id;
				SET sv_client_info := lv_system_user_group_id;
				CALL register_session(sv_db_userid,sv_sessionid);
			END IF;
			SET return_value := 1;
		ELSE
			LEAVE myLoop;
		END IF;

	END LOOP myLoop;
	CLOSE c;

END;
$$
DELIMITER ;








