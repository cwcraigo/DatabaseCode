-- -------------------------------------------------------------
-- -------------------------------------------------------------
-- SELECT DATABASE
USE newstore;
TEE log_W13_lab7.txt

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
	DECLARE lv_item_title VARCHAR(60);
	DECLARE lv_item_type 	INT;
	DECLARE lv_return 		INT DEFAULT 1;
	DECLARE lv_fetched 		INT DEFAULT 0;

	DECLARE lab7_function_cursor CURSOR FOR
		SELECT 	item_type, item_title
			FROM 	item INNER JOIN common_lookup
			ON   	item_type = common_lookup_id
			WHERE common_lookup_type LIKE CONCAT('%',UPPER(pv_item_type),'%');

	-- CONTINUE HANDLER TO SIGNIFY ERROR
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched := 1;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_return := 0;

	OPEN lab7_function_cursor;
	lab7_function_loop:LOOP

		FETCH lab7_function_cursor INTO lv_item_type, lv_item_title;

		IF (lv_fetched = 1) THEN
			LEAVE lab7_function_loop;
		END IF;

		UPDATE item
		SET obsolete_date = NOW()
		WHERE item_type = lv_item_type
		AND item_title = lv_item_title;

		INSERT INTO logging VALUES (lv_item_title, NOW());

		IF (lv_return = 0) THEN
			LEAVE lab7_function_loop;
		END IF;

	END LOOP lab7_function_loop;
	CLOSE lab7_function_cursor;

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
	DECLARE lv_item_title VARCHAR(60);
	DECLARE lv_item_type 	INT;
	DECLARE lv_error 			INT DEFAULT 0;
	DECLARE lv_fetched 		INT DEFAULT 0;

	DECLARE lab7_procedure_cursor CURSOR FOR
		SELECT item_type, item_title
			FROM item INNER JOIN common_lookup
			ON item_type = common_lookup_id
			WHERE common_lookup_type LIKE CONCAT('%',UPPER(pv_item_type),'%');

	-- CONTINUE HANDLER TO SIGNIFY ERROR
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched := 1;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error := 1;

	SET pv_return := 0;

	OPEN lab7_procedure_cursor;
	lab7_procedure_loop:LOOP

		FETCH lab7_procedure_cursor INTO lv_item_type, lv_item_title;

		IF (lv_fetched = 1) THEN
			LEAVE lab7_procedure_loop;
		ELSE
			SET pv_return := 1;
		END IF;

		UPDATE item
		SET 	 obsolete_date = NOW()
		WHERE  item_type 		 = lv_item_type
		AND    item_title    = lv_item_title;

		INSERT INTO logging VALUES (lv_item_title, NOW());

		IF (lv_error = 1) THEN
			SET pv_return := -1;
			LEAVE lab7_procedure_loop;
		END IF;

	END LOOP lab7_procedure_loop;
	CLOSE lab7_procedure_cursor;

END;
$$

-- SET DELIMITER TO DEFAULT
DELIMITER ;

-- -------------------------------------------------------------
-- RUN PROCEDURE
CALL lab7_insert_procedure('vhs', @sv_return);

-- -------------------------------------------------------------
-- CHECK PROCEDURE
SELECT @sv_return AS "PROCEDURE RETURN VALUE";

-- -------------------------------------------------------------
-- CHECK LOGGING TABLE
SELECT * FROM logging;

-- -------------------------------------------------------------
-- CHECK OBSOLETE_DATE
SELECT COUNT(*) FROM item WHERE obsolete_date IS NOT NULL;

NOTEE
-- -------------------------------------------------------------
-- -------------------------------------------------------------