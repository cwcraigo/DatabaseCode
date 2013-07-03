-- ---------------------------------------------------------------------------------
-- Version 1
-- ---------------------------------------------------------------------------------

DELIMITER $$
 
-- Drop the procedure if it exists.
DROP PROCEDURE IF EXISTS set_session_var$$
 
-- Create the procedure.
CREATE PROCEDURE set_session_var
( pv_session_name   VARCHAR(32767)
, pv_session_value  VARCHAR(32767))
CONTAINS SQL
BEGIN
 
  /* Insert statement with auto commit enabled. */
  SET @SQL := concat('SET',' ','@',pv_session_name,' := ','?');
  SELECT @SQL AS "SQL String";
  PREPARE stmt FROM @SQL;
  SET @sv_session_value := pv_session_value;
  EXECUTE stmt USING @sv_session_value;
  DEALLOCATE PREPARE stmt;
 
END;
$$

CALL set_session_var('sv_filter1','One')$$
CALL set_session_var('sv_filter2','Two')$$
SELECT @sv_filter1, @sv_filter2$$

DROP PROCEDURE IF EXISTS deserialize$$

CREATE PROCEDURE deserialize
( pv_param_list VARCHAR(32767))
CONTAINS SQL
BEGIN
  DECLARE lv_name     VARCHAR(9) DEFAULT 'sv_filter';
  DECLARE lv_length   INT;
  DECLARE lv_start    INT DEFAULT 1;
  DECLARE lv_end      INT DEFAULT 1;
  DECLARE lv_counter  INT DEFAULT 1;
 
  /* Skip when call parameter list is null or empty. */	
  IF NOT (ISNULL(pv_param_list) OR LENGTH(pv_param_list) = 0) THEN
 
    /* Read line by line on a line return character. */
    parse: WHILE NOT (lv_end = 0) DO
 
      /* Check for line returns. */
      SET lv_end := LOCATE(',',pv_param_list,lv_start);
 
      /* Check whether line return has been read. */
      IF NOT lv_end = 0 THEN  /* Reset the ending substring value. */
        SET lv_end := LOCATE(',',pv_param_list,lv_start);
        CALL set_session_var(CONCAT(lv_name,lv_counter),SUBSTR(pv_param_list,lv_start,lv_end - lv_start));
      ELSE  /* Print the last substring with a semicolon. */
        CALL set_session_var(CONCAT(lv_name,lv_counter),SUBSTR(pv_param_list,lv_start,LENGTH(pv_param_list)));
      END IF;
 
      /* Reset the beginning of the string. */
      SET lv_start := lv_end + 1;      
	    SET lv_counter := lv_counter + 1;
 
    END WHILE parse;    
 
  END IF;
 
  /* Check for a temporary table that holds a control variable,
     create the table if it doesn't exist, and remove rows from
     the table. */
  IF EXISTS (SELECT   NULL
             FROM     information_schema.TABLES
             WHERE    TABLE_NAME = 'counter') THEN
    TRUNCATE TABLE counter;
  ELSE
    /* It would be ideal to use a temporary table here but then
       it's not recorded in the INFORMATION_SCHEMA and cleansing
       the temporary table is more tedious. */
    CREATE TABLE counter ( counter INT ) ENGINE=MEMORY;
  END IF;
 
  /* Insert the counter value for a list of parameters. */
  INSERT INTO counter VALUES ( lv_counter - 1 );  
 
END;
$$

CALL deserialize('Uno,Due,Tre,Quattro')$$
SELECT counter AS "Parameter #" FROM counter$$
SELECT @sv_filter1, @sv_filter2, @sv_filter3, @sv_filter4$$

DROP PROCEDURE IF EXISTS prepared_dml$$

CREATE PROCEDURE prepared_dml
( pv_query   VARCHAR(32767)
, pv_filter  VARCHAR(32767))
CONTAINS SQL
BEGIN
 
  /* Declare a local variable for the SQL statement. */
  DECLARE dynamic_stmt  VARCHAR(32767);
  DECLARE lv_counter    INT DEFAULT 0;
 
  /* Cleanup the message passing table when a case is not found. */
  DECLARE EXIT HANDLER FOR 1339
    BEGIN
      /* Step #5: */
      DEALLOCATE PREPARE dynamic_stmt;
 
      /* Cleanup the temporary table that exchanges data between
         procedures. */
      DROP TABLE IF EXISTS counter;
    END;
 
  /* Step #1:
     ========
     Set a session variable with two parameter markers. */
  SET @SQL := pv_query;
 
  /* Verify query is not empty. */
  IF NOT ISNULL(@SQL) THEN
 
    /* Step #2:
       ========
       Dynamically allocated and run statement. */
    PREPARE dynamic_stmt FROM @SQL;
 
    /* Step #3:
       ========
       Assign the formal parameters to session variables
       because prepared statements require them. */
    CALL deserialize(pv_filter);
 
    /* Secure the parameter count from a temporary table that
       exchanges data between procedures. */
    SELECT counter INTO lv_counter FROM counter;
 
    /* Step #4:
       ========
       Choose the appropriate overloaded prepared statement. */
    CASE
      WHEN lv_counter = 0 THEN
        EXECUTE dynamic_stmt;      
      WHEN lv_counter = 1 THEN
        EXECUTE dynamic_stmt USING @sv_filter1;
      WHEN lv_counter = 2 THEN
        EXECUTE dynamic_stmt USING @sv_filter1,@sv_filter2;
    END CASE;
 
    /* Step #5: */
    DEALLOCATE PREPARE dynamic_stmt;
 
    /* Cleanup the temporary table that exchanges data between
       procedures. */
    DROP TEMPORARY TABLE IF EXISTS counter; 
 
  END IF;
 
END;
$$

DELIMITER ;

SELECT 'Test Case #1 ...' AS "Statement";
SET @param1 := 'SELECT "Hello World"';
SET @param2 := '';
CALL prepared_dml(@param1,@param2);
 
SELECT 'Test Case #2 ...' AS "Statement";
SET @param1 := 'SELECT item_title FROM item i WHERE item_title REGEXP ?';
SET @param2 := '^.*war.*$';
CALL prepared_dml(@param1,@param2);
 
SELECT 'Test Case #3 ...' AS "Statement";
SET @param1 := 'SELECT common_lookup_type FROM common_lookup cl WHERE common_lookup_table REGEXP ? AND common_lookup_column REGEXP ?';
SET @param2 := 'item,item_type';
CALL prepared_dml(@param1,@param2);

-- ---------------------------------------------------------------------------------
-- Version 2
-- ---------------------------------------------------------------------------------

DELIMITER $$
 
-- Drop the procedure if it exists.
DROP PROCEDURE IF EXISTS set_session_var$$
 
-- Create the procedure.
CREATE PROCEDURE set_session_var
( pv_session_name   VARCHAR(32767)
, pv_session_value  VARCHAR(32767))
CONTAINS SQL
BEGIN
 
  /* Insert statement with auto commit enabled. */
  SET @SQL := concat('SET',' ','@',pv_session_name,' := ','?');
  SELECT @SQL AS "SQL String";
  PREPARE stmt FROM @SQL;
  SET @sv_session_value := pv_session_value;
  EXECUTE stmt USING @sv_session_value;
  DEALLOCATE PREPARE stmt;
 
END;
$$

CALL set_session_var('sv_filter1','One')$$
CALL set_session_var('sv_filter2','Two')$$
SELECT @sv_filter1, @sv_filter2$$

DROP PROCEDURE IF EXISTS deserialize$$

CREATE PROCEDURE deserialize
( pv_param_list VARCHAR(32767))
CONTAINS SQL
BEGIN
  DECLARE lv_name     VARCHAR(9) DEFAULT 'sv_filter';
  DECLARE lv_length   INT;
  DECLARE lv_start    INT DEFAULT 1;
	DECLARE lv_end      INT DEFAULT 1;
	DECLARE lv_counter  INT DEFAULT 1;
 
  DECLARE CONTINUE HANDLER FOR 1146
    BEGIN
      /* Create a temporary table. */
      CREATE TEMPORARY TABLE counter ( counter INT ) ENGINE=MEMORY;
    END;
 
  /* Skip when call parameter list is null or empty. */	
  IF NOT (ISNULL(pv_param_list) OR LENGTH(pv_param_list) = 0) THEN
 
    /* Read line by line on a line return character. */
    parse: WHILE NOT (lv_end = 0) DO
 
      /* Check for line returns. */
      SET lv_end := LOCATE(',',pv_param_list,lv_start);
 
      /* Check whether line return has been read. */
      IF NOT lv_end = 0 THEN  /* Reset the ending substring value. */
        SET lv_end := LOCATE(',',pv_param_list,lv_start);
        CALL set_session_var(CONCAT(lv_name,lv_counter),SUBSTR(pv_param_list,lv_start,lv_end - lv_start));
      ELSE  /* Print the last substring with a semicolon. */
        CALL set_session_var(CONCAT(lv_name,lv_counter),SUBSTR(pv_param_list,lv_start,LENGTH(pv_param_list)));
		  END IF;
 
      /* Reset the beginning of the string. */
      SET lv_start := lv_end + 1;      
	    SET lv_counter := lv_counter + 1;
 
    END WHILE parse;    
 
  END IF;
 
  /* Truncate existing table. */
  TRUNCATE TABLE counter;
 
  /* Insert the counter value for a list of parameters. */
  INSERT INTO counter VALUES ( lv_counter - 1 );  
 
END;
$$

CALL deserialize('Uno,Due,Tre,Quattro')$$
SELECT counter AS "Parameter #" FROM counter$$
SELECT @sv_filter1, @sv_filter2, @sv_filter3, @sv_filter4$$

DROP PROCEDURE IF EXISTS prepared_dml$$

CREATE PROCEDURE prepared_dml
( pv_query   VARCHAR(32767)
, pv_filter  VARCHAR(32767))
CONTAINS SQL
BEGIN
 
  /* Declare a local variable for the SQL statement. */
  DECLARE dynamic_stmt  VARCHAR(32767);
  DECLARE lv_counter    INT DEFAULT 0;
 
  /* Cleanup the message passing table when a case is not found. */
  DECLARE EXIT HANDLER FOR 1339
    BEGIN
      /* Step #5: */
      DEALLOCATE PREPARE dynamic_stmt;
 
      /* Cleanup the temporary table that exchanges data between
         procedures. */
      DROP TABLE IF EXISTS counter;
    END;
 
  /* Step #1:
     ========
     Set a session variable with two parameter markers. */
  SET @SQL := pv_query;
 
  /* Verify query is not empty. */
  IF NOT ISNULL(@SQL) THEN
 
    /* Step #2:
       ========
       Dynamically allocated and run statement. */
    PREPARE dynamic_stmt FROM @SQL;
 
    /* Step #3:
       ========
       Assign the formal parameters to session variables
       because prepared statements require them. */
    CALL deserialize(pv_filter);
 
    /* Secure the parameter count from a temporary table that
       exchanges data between procedures. */
    SELECT counter INTO lv_counter FROM counter;
 
    /* Step #4:
       ========
       Choose the appropriate overloaded prepared statement. */
    CASE
      WHEN lv_counter = 0 THEN
        EXECUTE dynamic_stmt;      
      WHEN lv_counter = 1 THEN
        EXECUTE dynamic_stmt USING @sv_filter1;
      WHEN lv_counter = 2 THEN
        EXECUTE dynamic_stmt USING @sv_filter1,@sv_filter2;
    END CASE;
 
    /* Step #5: */
    DEALLOCATE PREPARE dynamic_stmt;
 
    /* Cleanup the temporary table that exchanges data between
       procedures. */
    DROP TEMPORARY TABLE IF EXISTS counter; 
 
  END IF;
 
END;
$$

DELIMITER ;

SELECT 'Test Case #1 ...' AS "Statement";
SET @param1 := 'SELECT "Hello World"';
SET @param2 := '';
CALL prepared_dml(@param1,@param2);
 
SELECT 'Test Case #2 ...' AS "Statement";
SET @param1 := 'SELECT item_title FROM item i WHERE item_title REGEXP ?';
SET @param2 := '^.*war.*$';
CALL prepared_dml(@param1,@param2);
 
SELECT 'Test Case #3 ...' AS "Statement";
SET @param1 := 'SELECT common_lookup_type FROM common_lookup cl WHERE common_lookup_table REGEXP ? AND common_lookup_column REGEXP ?';
SET @param2 := 'item,item_type';
CALL prepared_dml(@param1,@param2);

-- ---------------------------------------------------------------------------------
-- Version 3
-- ---------------------------------------------------------------------------------

DELIMITER $$
 
-- Drop the procedure if it exists.
DROP PROCEDURE IF EXISTS set_session_var$$
 
-- Create the procedure.
CREATE PROCEDURE set_session_var
( pv_session_name   VARCHAR(32767)
, pv_session_value  VARCHAR(32767))
CONTAINS SQL
BEGIN
 
  /* Insert statement with auto commit enabled. */
  SET @SQL := concat('SET',' ','@',pv_session_name,' := ','?');
  SELECT @SQL AS "SQL String";
  PREPARE stmt FROM @SQL;
  SET @sv_session_value := pv_session_value;
  EXECUTE stmt USING @sv_session_value;
  DEALLOCATE PREPARE stmt;
 
END;
$$

CALL set_session_var('sv_filter1','One')$$
CALL set_session_var('sv_filter2','Two')$$
SELECT @sv_filter1, @sv_filter2$$

DROP PROCEDURE IF EXISTS deserialize$$

CREATE PROCEDURE deserialize
( pv_param_list VARCHAR(32767))
CONTAINS SQL
BEGIN
  DECLARE lv_name     VARCHAR(9) DEFAULT 'sv_filter';
  DECLARE lv_length   INT;
  DECLARE lv_start    INT DEFAULT 1;
	DECLARE lv_end      INT DEFAULT 1;
 
  /* Set a session variable to enable a calling scope to
     read it without a function return. */
  SET @sv_counter := 1;
 
  /* Skip when call parameter list is null or empty. */	
  IF NOT (ISNULL(pv_param_list) OR LENGTH(pv_param_list) = 0) THEN
 
    /* Read line by line on a line return character. */
    parse: WHILE NOT (lv_end = 0) DO
 
      /* Check for line returns. */
      SET lv_end := LOCATE(',',pv_param_list,lv_start);
 
      /* Check whether line return has been read. */
      IF NOT lv_end = 0 THEN  /* Reset the ending substring value. */
        SET lv_end := LOCATE(',',pv_param_list,lv_start);
        CALL set_session_var(CONCAT(lv_name,@sv_counter),SUBSTR(pv_param_list,lv_start,lv_end - lv_start));
      ELSE  /* Print the last substring with a semicolon. */
        CALL set_session_var(CONCAT(lv_name,@sv_counter),SUBSTR(pv_param_list,lv_start,LENGTH(pv_param_list)));
		  END IF;
 
      /* Reset the beginning of the string. */
      SET lv_start := lv_end + 1;      
	    SET @sv_counter := @sv_counter + 1;
 
    END WHILE parse;    
 
  END IF;
 
  /* Reduce by one for 1-based numbering of name elements. */
  SET @sv_counter := @sv_counter - 1;
 
END;
$$

CALL deserialize('Uno,Due,Tre,Quattro')$$
SELECT @sv_filter1, @sv_filter2, @sv_filter3, @sv_filter4$$

DROP PROCEDURE IF EXISTS prepared_dml$$

CREATE PROCEDURE prepared_dml
( pv_query   VARCHAR(32767)
, pv_filter  VARCHAR(32767))
CONTAINS SQL
BEGIN
 
  /* Declare a local variable for the SQL statement. */
  DECLARE dynamic_stmt  VARCHAR(32767);
  DECLARE lv_counter    INT DEFAULT 0;
 
  /* Cleanup the message passing table when a case is not found. */
  DECLARE EXIT HANDLER FOR 1339
    BEGIN
      /* Step #5: */
      DEALLOCATE PREPARE dynamic_stmt;
    END;
 
  /* Step #1:
     ========
     Set a session variable with two parameter markers. */
  SET @SQL := pv_query;
 
  /* Verify query is not empty. */
  IF NOT ISNULL(@SQL) THEN
 
    /* Step #2:
       ========
       Dynamically allocated and run statement. */
    PREPARE dynamic_stmt FROM @SQL;
 
    /* Step #3:
       ========
       Assign the formal parameters to session variables
       because prepared statements require them. */
    CALL deserialize(pv_filter);
 
     /* Step #4:
       ========
       Choose the appropriate overloaded prepared statement. */
    CASE
      WHEN @sv_counter = 0 THEN
        EXECUTE dynamic_stmt;      
      WHEN @sv_counter = 1 THEN
        EXECUTE dynamic_stmt USING @sv_filter1;
      WHEN @sv_counter = 2 THEN
        EXECUTE dynamic_stmt USING @sv_filter1,@sv_filter2;
    END CASE;
 
    /* Step #5: */
    DEALLOCATE PREPARE dynamic_stmt;
 
  END IF;
 
END;
$$

DELIMITER ;

SELECT 'Test Case #1 ...' AS "Statement";
SET @param1 := 'SELECT "Hello World"';
SET @param2 := '';
CALL prepared_dml(@param1,@param2);
 
SELECT 'Test Case #2 ...' AS "Statement";
SET @param1 := 'SELECT item_title FROM item i WHERE item_title REGEXP ?';
SET @param2 := '^.*war.*$';
CALL prepared_dml(@param1,@param2);
 
SELECT 'Test Case #3 ...' AS "Statement";
SET @param1 := 'SELECT common_lookup_type FROM common_lookup cl WHERE common_lookup_table REGEXP ? AND common_lookup_column REGEXP ?';
SET @param2 := 'item,item_type';
CALL prepared_dml(@param1,@param2);
