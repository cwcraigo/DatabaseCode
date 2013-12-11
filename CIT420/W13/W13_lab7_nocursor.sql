-- -------------------------------------------------------------
-- -------------------------------------------------------------
-- SELECT DATABASE
USE newstore;
TEE log_W13_lab7_nocursor.txt

-- -------------------------------------------------------------
-- CONDITIONAL DROP OF THE OBSOLETE_DATE COLUMN
SELECT "obsolete_date" AS "DROP COLUMN";
ALTER TABLE item
	DROP COLUMN obsolete_date;

-- -------------------------------------------------------------
-- ADD OBSOLETE_DATE COLUMN
SELECT "obsolete_date" AS "ADD COLUMN";
ALTER TABLE item
	ADD obsolete_date DATE;

-- -------------------------------------------------------------
-- CONDITIONAL DROP OF THE LOGGING TABLE
SELECT "logging" AS "DROP TABLE";
DROP TABLE IF EXISTS logging;

-- -------------------------------------------------------------
-- CREATE LOGGING TABLE
SELECT "logging" AS "CREATE TABLE";
CREATE TABLE logging
( item_title 		VARCHAR(60)
, obsolete_date DATE) ENGINE=MEMORY;

-- -------------------------------------------------------------
-- FUNCTION TO UPDATE AND INSERT
SELECT "lab7_insert_function" AS "FUNCTION";

-- SET DELIMITER
DELIMITER $$

-- CONDITIONAL DROP OF FUNCTION
DROP FUNCTION IF EXISTS lab7_insert_function$$

-- CREATE FUNCTION
CREATE FUNCTION lab7_insert_function
( pv_item_type VARCHAR(30) ) RETURNS INT
MODIFIES SQL DATA
BEGIN

	-- DECLARE LOCAL VARIABLES
	DECLARE lv_return INT DEFAULT 1;
	DECLARE lv_error INT DEFAULT 0;

	-- CONTINUE HANDLER TO SIGNIFY ERROR
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error := 1;

	-- UPDATE OBSOLETE_DATE IN ITEM TABLE
	UPDATE item i INNER JOIN common_lookup cl
	ON 	cl.common_lookup_id = i.item_type
	AND cl.common_lookup_type LIKE CONCAT('%',UPPER(pv_item_type),'%')
	SET i.obsolete_date = NOW();

	-- INSERT INTO LOGGING
	INSERT INTO logging
	(SELECT item_title, obsolete_date
		FROM 	item INNER JOIN common_lookup
		ON common_lookup_id = item_type
		WHERE common_lookup_type LIKE CONCAT('%',UPPER(pv_item_type),'%'));

	-- CHECK TO SEE IF ERROR OCCURED
	IF (lv_error = 1) THEN
		SET lv_return := 0;
	END IF;

	-- RETURN TRUE/FALSE
	RETURN lv_return;

END;
$$
-- DELIMITER BACK TO DEFAULT
DELIMITER ;

-- -------------------------------------------------------------
-- RUN FUNCTION
SELECT lab7_insert_function('vhs') AS 'FUNCTION RETURN VALUE';

-- -------------------------------------------------------------
-- CHECK LOGGING TABLE
SELECT * FROM logging;

-- -------------------------------------------------------------
-- CHECK OBSOLETE_DATE
SELECT COUNT(*) FROM item WHERE obsolete_date IS NOT NULL;

-- -------------------------------------------------------------
-- DELETE DATA IN LOGGING
TRUNCATE TABLE logging;

-- -------------------------------------------------------------
-- PROCEDURE TO UPDATE AND INSERT
SELECT "lab7_insert_procedure" AS "PROCEDURE";

-- SET DELIMITER
DELIMITER $$

-- CONDITIONAL DROP
DROP PROCEDURE IF EXISTS lab7_insert_procedure$$

-- CREATE PROCEDURE
CREATE PROCEDURE lab7_insert_procedure
(pv_item_type VARCHAR(60), OUT pv_return INT)
MODIFIES SQL DATA
BEGIN

	-- DECLARE LOCAL VARIABLES
	DECLARE lv_error INT DEFAULT 0;

	-- DECLARE CONTINUE HANDLER
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error := 1;

	-- UPDATE OBSOLETE_DATE
	UPDATE item i INNER JOIN common_lookup cl
	ON 	cl.common_lookup_id = i.item_type
	AND cl.common_lookup_type LIKE CONCAT('%',UPPER(pv_item_type),'%')
	SET i.obsolete_date = NOW();

	-- INSERT INTO LOGGING
	INSERT INTO logging
	(SELECT item_title, obsolete_date
		FROM 	item INNER JOIN common_lookup
		ON common_lookup_id = item_type
		WHERE common_lookup_type LIKE CONCAT('%',UPPER(pv_item_type),'%'));

	-- CHECK FOR ERRORS
	IF (lv_error = 0) THEN
		SET pv_return := 1;
	ELSE
		SET pv_return := 0;
	END IF;

END;
$$

-- SET DELIMITER TO DEFAULT
DELIMITER ;

-- -------------------------------------------------------------
-- RUN PROCEDURE
CALL lab7_insert_procedure('vhs', @sv_return);

-- -------------------------------------------------------------
-- CHECK LOGGING TABLE
SELECT * FROM logging;

-- -------------------------------------------------------------
-- CHECK OBSOLETE_DATE
SELECT COUNT(*) FROM item WHERE obsolete_date IS NOT NULL;

NOTEE
-- -------------------------------------------------------------
-- -------------------------------------------------------------
