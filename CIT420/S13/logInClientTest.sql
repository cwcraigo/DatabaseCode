DELIMITER $$

SELECT 'logInClient' AS 'PROCEDURE'$$
DROP PROCEDURE IF EXISTS logInClient$$
CREATE PROCEDURE logInClient
( pv_user_name 					VARCHAR(60)
, pv_password 					VARCHAR(60))
BEGIN
	DECLARE client_id 				INT UNSIGNED;
	DECLARE system_user_id 		INT UNSIGNED;
	DECLARE first_name 				VARCHAR(20);
	DECLARE middle_name 			VARCHAR(20);
	DECLARE last_name 				VARCHAR(40);
	DECLARE user_name 				VARCHAR(50);
	DECLARE password 					VARCHAR(60);
	DECLARE email 						VARCHAR(60);
	DECLARE creation_date 		DATE;
	DECLARE last_update_date 	TIMESTAMP;
	DECLARE active_flag 			VARCHAR(10);
	DECLARE date_removed 			DATE;

  DECLARE lv_fetched  INT UNSIGNED DEFAULT 0;
  DECLARE c CURSOR FOR
    SELECT c.client_id,c.system_user_id
					,c.first_name,c.middle_name,c.last_name
					,c.user_name,c.password,c.email
					,c.creation_date,c.last_update_date
					,c.active_flag,c.date_removed
    FROM client c
    WHERE c.user_name = pv_user_name
    AND c.password = PASSWORD(pv_password);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched = 1;
  OPEN c;
  FETCH c INTO client_id,system_user_id
  						,first_name,middle_name,last_name
  						,user_name,password,email
  						,creation_date,last_update_date
  						,active_flag,date_removed;
  IF lv_fetched = 0 THEN
  	SELECT client_id,system_user_id
					,first_name,middle_name,last_name
					,user_name,password,email
					,creation_date,last_update_date
					,active_flag,date_removed;
  END IF;
  CLOSE c;
END;
$$

SELECT 'logInClientTest' AS 'PROCEDURE'$$
DROP PROCEDURE IF EXISTS logInClientTest$$
CREATE PROCEDURE logInClientTest()
BEGIN
	DECLARE pv_user_name 			VARCHAR(60);
	DECLARE pv_password 			VARCHAR(60);
	DECLARE client_id 				INT UNSIGNED;
	DECLARE system_user_id 		INT UNSIGNED;
	DECLARE first_name 				VARCHAR(20);
	DECLARE middle_name 			VARCHAR(20);
	DECLARE last_name 				VARCHAR(40);
	DECLARE user_name 				VARCHAR(50);
	DECLARE password 					VARCHAR(60);
	DECLARE email 						VARCHAR(60);
	DECLARE creation_date 		DATE;
	DECLARE last_update_date 	TIMESTAMP;
	DECLARE active_flag 			VARCHAR(10);
	DECLARE date_removed 			DATE;

	SET pv_user_name := "administrator";
	SET pv_password  := "administrator";

	CALL logInClient(pv_user_name,pv_password);

END;
$$

DELIMITER ;

SELECT logInClient('administrator','administrator');