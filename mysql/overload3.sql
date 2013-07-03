DELIMITER $$

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