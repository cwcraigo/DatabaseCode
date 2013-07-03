/* ************************************************************************
* AUTHOR:  Craig W. Christensen
* DATE:    December 9, 2012
* CONTENT: HASH_PASSWORD_INSERT_TRIGGER, HASH_PASSWORD_UPDATE_TRIGGER,
*           AUTHENTICATE_PASSWORD
* DESCRIPTION: Database structure for mealcalendar.cwcraigo.com.
************************************************************************ */

USE mealcalendar;

TEE mealcalendar/meal_calendar_programs.txt

DELIMITER $$
-- ----------------------------------------------------------------------
SELECT 'hash_password_insert_trigger' AS 'TRIGGER'$$
DROP TRIGGER IF EXISTS hash_password_insert_trigger$$
CREATE TRIGGER hash_password_insert_trigger
BEFORE INSERT ON client
FOR EACH ROW
BEGIN
  SET new.password = PASSWORD(new.password);
END;
$$

SELECT 'hash_password_update_trigger' AS 'TRIGGER'$$
DROP TRIGGER IF EXISTS hash_password_update_trigger$$
CREATE TRIGGER hash_password_update_trigger
BEFORE UPDATE ON client
FOR EACH ROW
BEGIN
  SET new.password = PASSWORD(new.password);
END;
$$
-- ----------------------------------------------------------------------
SELECT 'authenticate_password' AS 'FUNCTION'$$
DROP FUNCTION IF EXISTS authenticate_password$$
CREATE FUNCTION authenticate_password
( pv_password VARCHAR(60), pv_client_id INT) RETURNS INT
BEGIN
  DECLARE lv_result   INT DEFAULT 0;
  DECLARE lv_password VARCHAR(60);
  DECLARE lv_fetched  INT DEFAULT 0;
  DECLARE c CURSOR FOR
    SELECT password
    FROM client
    WHERE client_id = pv_client_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched = 1;
  OPEN c;
  FETCH c INTO lv_password;
  IF lv_fetched = 0 AND PASSWORD(pv_password) = lv_password THEN
    SET lv_result := 1;
  END IF;
  CLOSE c;
  RETURN lv_result;
END;
$$
-- ----------------------------------------------------------------------
-- SELECT 'get_all_system_users' AS 'PROCEDURE'$$
-- DROP PROCEDURE IF EXISTS get_all_system_users$$
-- CREATE PROCEDURE get_all_system_users()
-- BEGIN
--   SELECT * FROM system_user;
-- END;
-- $$

-- SELECT 'get_system_user_by_id' AS 'PROCEDURE'$$
-- DROP PROCEDURE IF EXISTS get_system_user_by_id$$
-- CREATE PROCEDURE get_system_user_by_id(pv_system_user_id INT)
-- BEGIN
--   DECLARE stmt VARCHAR(2000);
--   DECLARE lv_error_value INT DEFAULT 0;
--   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error_value := 1;
--   SET @SQL := 'SELECT * FROM system_user WHERE system_user_id = ?';
--   SET @id  := pv_system_user_id;
--   PREPARE stmt FROM @SQL;
--   EXECUTE stmt USING @id;
--   DEALLOCATE PREPARE stmt;
--   IF lv_error_value = 1 THEN
--     SELECT -1;
--   END IF;
-- END;
-- $$

-- SELECT 'get_system_users_by_group_id' AS 'PROCEDURE'$$
-- DROP PROCEDURE IF EXISTS get_system_users_by_group_id$$
-- CREATE PROCEDURE get_system_users_by_group_id(pv_system_user_group_id INT)
-- BEGIN
--   DECLARE stmt VARCHAR(2000);
--   DECLARE lv_error_value INT DEFAULT 0;
--   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error_value := 1;
--   SET @SQL := 'SELECT * FROM system_user WHERE system_user_group_id = ?';
--   SET @id  := pv_system_user_group_id;
--   PREPARE stmt FROM @SQL;
--   EXECUTE stmt USING @id;
--   DEALLOCATE PREPARE stmt;
--   IF lv_error_value = 1 THEN
--     SELECT -1;
--   END IF;
-- END;
-- $$
-- -- ----------------------------------------------------------------------
-- SELECT 'get_all_lookup' AS 'PROCEDURE'$$
-- DROP PROCEDURE IF EXISTS get_all_lookup$$
-- CREATE PROCEDURE get_all_lookup()
-- BEGIN
--   SELECT * FROM common_lookup;
-- END;
-- $$

-- SELECT 'get_lookup_by_context' AS 'PROCEDURE'$$
-- DROP PROCEDURE IF EXISTS get_lookup_by_context$$
-- CREATE PROCEDURE get_lookup_by_context(pv_common_lookup_context VARCHAR(30))
-- BEGIN
--   DECLARE stmt VARCHAR(2000);
--   DECLARE lv_error_value INT DEFAULT 0;
--   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error_value := 1;
--   SET @SQL := "SELECT *
--                 FROM common_lookup
--                 WHERE REPLACE(common_lookup_context,  REGEXP CONCAT('^.*',?,'.*')";
--   SET @id  := pv_common_lookup_context;
--   PREPARE stmt FROM @SQL;
--   EXECUTE stmt USING @id;
--   DEALLOCATE PREPARE stmt;
--   IF lv_error_value = 1 THEN
--     SELECT -1;
--   END IF;
-- END;
-- $$

-- SELECT 'get_lookup_by_type' AS 'PROCEDURE'$$
-- DROP PROCEDURE IF EXISTS get_lookup_by_type$$
-- CREATE PROCEDURE get_lookup_by_type(pv_common_lookup_type VARCHAR(30))
-- BEGIN
--   DECLARE stmt VARCHAR(2000);
--   DECLARE lv_error_value INT DEFAULT 0;
--   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error_value := 1;
--   SET @SQL := "SELECT *
--               FROM common_lookup
--               WHERE common_lookup_type REGEXP CONCAT('^.*',?,'.*')";
--   SET @id  := pv_common_lookup_type;
--   PREPARE stmt FROM @SQL;
--   EXECUTE stmt USING @id;
--   DEALLOCATE PREPARE stmt;
--   IF lv_error_value = 1 THEN
--     SELECT -1;
--   END IF;
-- END;
-- $$










-- ----------------------------------------------------------------------
SELECT 'main' AS 'FUNCTION'$$
DROP PROCEDURE IF EXISTS main$$
CREATE PROCEDURE main()
BEGIN

  -- SYSTEM_USER PROCEDURES
  -- CALL get_all_system_users();
  -- CALL get_system_user_by_id(1);
  -- CALL get_system_users_by_group_id(1);
  -- CALL get_lookup_by_context('meal time');
  -- CALL get_lookup_by_type('side dishes');


END;
$$

DELIMITER ;

CALL main();


-- TESTING CLIENT TABLE:

-- SELECT authenticate_password('cangetin',1) AS 'RESULT';

-- WHEN YOU UPDATE THE CLIENT TABLE IT WILL AUTOMATICALLY SET LAST_UPDATE_DATE TO CURRENT_TIMESTAMP
-- UPDATE client
--   SET last_update_date = NULL
--   WHERE client_id = 1;

-- SELECT * FROM client;

NOTEE