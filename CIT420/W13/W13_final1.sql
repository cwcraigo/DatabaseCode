USE idmgmtdb;

\. create_identity_db4_mysql.sql

DELIMITER $$
-- --------------------------------------------------------------
DROP PROCEDURE IF EXISTS get_session$$
CREATE PROCEDURE get_session
( sessionid 	 					INT UNSIGNED
, userid 								VARCHAR(20)
, passwd 								VARCHAR(40)
, INOUT sv_remote_addr	VARCHAR(15)
, OUT sv_userid 				VARCHAR(20)
, OUT sv_client_info 		INT UNSIGNED
, OUT return_value 			INT UNSIGNED)
BEGIN

DECLARE lv_system_user_id 				INT UNSIGNED;
DECLARE lv_system_user_name 			VARCHAR(20);
DECLARE lv_system_user_group_id 	INT UNSIGNED;
DECLARE lv_system_remote_address 	VARCHAR(15);
DECLARE lv_system_session_id 			INT UNSIGNED;
DECLARE lv_check 									INT UNSIGNED DEFAULT 0;

DECLARE fetched INT UNSIGNED DEFAULT 1;

DECLARE c CURSOR FOR
	SELECT   su.system_user_id
	,        su.system_user_name
	,        su.system_user_group_id
	,        ss.system_remote_address
	,        ss.system_session_id
	FROM     system_user su JOIN system_session ss
	ON       su.system_user_id = ss.system_user_id
	WHERE    ss.system_session_number = sessionid
	AND 		 ss.last_update_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 5 MINUTE);

DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched := 0;


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
	AND 		 ss.last_update_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 5 MINUTE);

OPEN c;
myLoop:LOOP
	FETCH c INTO lv_system_user_id
						 , lv_system_user_name
						 , lv_system_user_group_id
						 , lv_system_remote_address
						 , lv_system_session_id;
	IF (fetched = 1) THEN
		SET lv_check := 1;
		SET sv_userid := lv_system_user_name;
		IF (lv_system_user_group_id = 0) THEN
			SET sv_client_info := lv_system_user_group_id;
		ELSE
			SET sv_client_info := lv_system_user_id;
		END IF;
		IF (sv_remote_addr = lv_system_remote_address) THEN
			UPDATE   system_session
			SET      last_update_date = NOW()
			WHERE    system_session_number = sessionid
			AND      system_remote_address = sv_remote_addr;
			SET return_value := lv_system_session_id;
		ELSE
			INSERT INTO invalid_session VALUES
			(NULL,sessionid,sv_remote_addr,1,NOW(),1,NOW());
			SET return_value := 0;
		END IF;
	ELSE
		IF (lv_check = 0) THEN
			IF (userid IS NOT NULL) AND (passwd IS NOT NULL) THEN
				INSERT INTO invalid_session VALUES
				(NULL,sessionid,sv_remote_addr,1,NOW(),1,NOW());
				SET return_value := 0;
			END IF;
		END IF;
		LEAVE myLoop;
	END IF;
END LOOP myLoop;
CLOSE c;

END;
$$
-- --------------------------------------------------------------
DELIMITER ;


-- --------------------------------------------------------------
-- TEST CASE #1:
-- Verify a timeout due to more than a 5 minute lapse since the last client communication.
-- --------------------------------------------------------------
SET @userid := 'administrator';
SET @passwd := 'c0b137fe2d792459f26ff763cce44574a5b5ab03';
SET @sessionid := connection_id();
SET @sv_remote_addr := '192.168.1.1';

-- Creating session by inserting into system_session
INSERT INTO system_session VALUES
( NULL, @sessionid, @sv_remote_addr
, (SELECT system_user_id FROM system_user WHERE system_user_name = 'administrator')
, 1, NOW(), 1, NOW());

SET @system_session_id := last_insert_id();

-- RUN THE TEST PROCEDURE
CALL get_session(@sessionid, @userid, @passwd, @sv_remote_addr, @sv_userid, @sv_client_info, @return_value);

-- UPDATE LAST_UPDATE_DATE TO MOCK 5+ MIN TIMEOUT
UPDATE system_session
	SET  last_update_date = DATE_ADD(NOW(), INTERVAL 10 MINUTE)
	WHERE system_session_id = @system_session_id;

-- RUN TEST PROCEDURE
CALL get_session(@sessionid, @userid, @passwd, @sv_remote_addr, @sv_userid, @sv_client_info, @return_value);

SELECT IF(SS.SYSTEM_SESSION=1 AND INV.INVALID_SESSION=1,"SUCCESS!!!","FAILURE") AS "TEST CASE #1"
FROM
(SELECT COUNT(*) AS "SYSTEM_SESSION" FROM system_session) SS
CROSS JOIN
(SELECT COUNT(*) AS "INVALID_SESSION" FROM invalid_session) INV;
-- --------------------------------------------------------------

-- --------------------------------------------------------------
-- TEST CASE #2:
-- Verify last update was within the last 5 minutes.
-- --------------------------------------------------------------
SET @userid := 'administrator';
SET @passwd := 'c0b137fe2d792459f26ff763cce44574a5b5ab03';
SET @sessionid := connection_id() + 1;
SET @sv_remote_addr := '192.168.1.2';

-- Creating new session by inserting into system_session
INSERT INTO system_session VALUES
( NULL, @sessionid, @sv_remote_addr
, (SELECT system_user_id FROM system_user WHERE system_user_name = 'administrator')
, 1, NOW(), 1, NOW());

-- RUN TEST PROCEDURE
CALL get_session(@sessionid, @userid, @passwd, @sv_remote_addr, @sv_userid, @sv_client_info, @return_value);
-- RUN TEST PROCEDURE
CALL get_session(@sessionid, @userid, @passwd, @sv_remote_addr, @sv_userid, @sv_client_info, @return_value);

SELECT IF(SS.SYSTEM_SESSION=2 AND INV.INVALID_SESSION=1,"SUCCESS!!!","FAILURE") AS "TEST CASE #2"
FROM
(SELECT COUNT(*) AS "SYSTEM_SESSION" FROM system_session) SS
CROSS JOIN
(SELECT COUNT(*) AS "INVALID_SESSION" FROM invalid_session) INV;
-- --------------------------------------------------------------


-- --------------------------------------------------------------
-- TEST CASE #3:
-- Process an invalid host name change from the last communication.
-- --------------------------------------------------------------
SET @sv_remote_addr := '192.168.1.0';
-- RUN TEST PROCEDURE
CALL get_session(@sessionid, @userid, @passwd, @sv_remote_addr, @sv_userid, @sv_client_info, @return_value);

SELECT IF(SS.SYSTEM_SESSION=2 AND INV.INVALID_SESSION=2,"SUCCESS!!!","FAILURE") AS "TEST CASE #3"
FROM
(SELECT COUNT(*) AS "SYSTEM_SESSION" FROM system_session) SS
CROSS JOIN
(SELECT COUNT(*) AS "INVALID_SESSION" FROM invalid_session) INV;
-- --------------------------------------------------------------

-- --------------------------------------------------------------
-- TEST CASE #4:
-- Process an invalid change because more than 5 minutes elapsed from last communication.
-- --------------------------------------------------------------








-- SELECT COUNT(*) AS "SYSTEM_SESSION" FROM system_session;
-- SELECT COUNT(*) AS "INVALID_SESSION" FROM invalid_session;

/*
TEST CASE #1:
	Verify a timeout due to more than a 5 minute lapse since the last client communication.
TEST CASE #2:
	Verify last update was within the last 5 minutes.
TEST CASE #3:
	Process an invalid host name change from the last communication.
TEST CASE #4:
	Process and invalid change because more than 5 minutes elapsed from last communication.
*/






/*

MINI PHP GLOSSORY FOR CIT420 FINAL

------------------------------------------------
									$c
------------------------------------------------
	$c in Bro. McLaughlin's code is the php
connection object





------------------------------------------------
									$s
------------------------------------------------


------------------------------------------------
							@oci_ececute
------------------------------------------------


------------------------------------------------
								oci_fetch
------------------------------------------------


------------------------------------------------
								oci_result
------------------------------------------------


------------------------------------------------
							$_SESSION['xxxx']
------------------------------------------------


------------------------------------------------
										!
------------------------------------------------


------------------------------------------------
									isset()
------------------------------------------------


------------------------------------------------
								{} vs no {}
------------------------------------------------



------------------------------------------------
		php functions vs user-defined functions
------------------------------------------------



*/
