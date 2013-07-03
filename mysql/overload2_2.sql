DELIMITER $$

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

DELIMITER ;

CALL deserialize('Uno,Due,Tre,Quattro');
SELECT @sv_filter1, @sv_filter2, @sv_filter3, @sv_filter4;