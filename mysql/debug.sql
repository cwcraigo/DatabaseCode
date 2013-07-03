/* ***************************************************************************************
* - This script shows that you can use session variables, without declaring them first, 
*   within the scope of the program.
* - Demonstrates how to use stripped views, when you want to use session variables in a 
*   view by using a function to SET and RETURN the session variable.
* ***************************************************************************************/
USE studentdb

DELIMITER $$

DROP PROCEDURE IF EXISTS debug_procedure$$

/* Debug remark! */
SELECT CONCAT("[",@sv_target,"]") AS "Session Target";

CREATE PROCEDURE debug_procedure()
BEGIN

    DECLARE lv_source  VARCHAR(12) DEFAULT "Hello World!";
    DECLARE lv_target VARCHAR(12);
    
    /* Debug remark! */
    SELECT CONCAT("[",lv_source,"]") AS "Source"
    ,      CONCAT("[",lv_target,"]") AS "Target";
    
    /* ASSIGNMENT RULES
    * --------------------------
    *   SET lv_source := lv_target;
    *   SET lv_source = lv_target;
    * --------------------------
    *   Use this when source comes from table
    *   SELECT lv INTO lv;
    */
    
    SET lv_target := lv_source;
    
    -- Export outside of the scope of the named program unit.
    SET @sv_target := lv_source;
    
    /* Debug remark! */
    SELECT CONCAT("[",lv_target,"]") AS "Local Target"
    ,      CONCAT("[",@sv_target,"]") AS "Session Target";

END;
$$

DELIMITER ;

CALL debug_procedure();

/* Debug remark! */
SELECT CONCAT("[",@sv_target,"]") AS "Session Target";


/* **************************************************************************************
* CANNOT USE SESSION VARIABLE IN CONTEXT OF A VIEW
* ***************************************************************************************
*           CREATE VIEW windmill AS
*               SELECT @sv_target;   -- cannot use sv like this.
* ***************************************************************************************
* SOLUTION: CREATE FUNCTION TO CREATE AND SET A SV THEN USE THE FUNCTION IN THE VIEW 
* **************************************************************************************/

DELIMITER $$
DROP FUNCTION IF EXISTS get_session_variable$$
CREATE FUNCTION get_session_variable() RETURNS VARCHAR(20)
BEGIN
    SET @sv_target := "Goodbye World!";
    RETURN @sv_target;
END;
$$
DELIMITER ;

/* Create view using the function to set and use the session variable */
DROP VIEW IF EXISTS windmill;
CREATE VIEW windmill AS SELECT get_session_variable();

/* View the VIEW */
SELECT * FROM windmill;

