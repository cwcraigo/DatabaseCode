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

DELIMITER ;

CALL set_session_var('sv_filter1','One');
CALL set_session_var('sv_filter2','Two');
SELECT @sv_filter1, @sv_filter2;
