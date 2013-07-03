DELIMITER $$

-- Drop the procedure if it exists.
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

DELIMITER ;

CALL deserialize('Uno,Due,Tre,Quattro');
SELECT counter AS "Parameter #" FROM counter;
SELECT @sv_filter1, @sv_filter2, @sv_filter3, @sv_filter4;