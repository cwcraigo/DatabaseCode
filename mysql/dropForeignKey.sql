DELIMITER $$

DROP PROCEDURE IF EXISTS dropForeignKeys$$

CREATE PROCEDURE dropForeignKeys
( pv_constraint_name VARCHAR(64)
, pv_referenced_table VARCHAR(64)
, pv_database VARCHAR(64) )
READS SQL DATA SQL SECURITY INVOKER
BEGIN

    /* Declare local statement variables. */
    DECLARE lv_stmt VARCHAR(1024);
    
    /* Declare local cursor variables. */
    DECLARE lv_table_name VARCHAR(64);
    DECLARE lv_constraint_name VARCHAR(64);
    
    /* Declare control variable for handler. */
    DECLARE fetched INT DEFAULT 0;
    
    /* Declare local cursor. */
    DECLARE foreign_key_cursor CURSOR FOR
        SELECT rc.table_name
        ,      rc.constraint_name
        FROM information_schema.referential_constraints rc
        WHERE rc.constraint_schema = pv_database
        AND rc.referenced_table_name
            REGEXP CONCAT('(^|^.+)',pv_referenced_table,'(.+$|$)')
        AND rc.constraint_name
            REGEXP CONCAT('(^|^.+)',pv_constraint_name,'(.+$|$)')
        ORDER BY rc.table_name
        ,        rc.constraint_name;
        
    /* Declare a not found record handler to close a cursor loop */
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
    
    /* Open a local cursor. */
    OPEN foreign_key_cursor;
    cursor_foreign_key: LOOP
    
        FETCH foreign_key_cursor 
        INTO  lv_table_name
            , lv_constraint_name;
        
        /* Place the catch handler for no more rows found 
           immediately after the fetch operation. */
        IF fetched = 1 THEN LEAVE cursor_foreign_key; END IF;
        
        /* Set a SQL statement by using concatenation. */
        SET @SQL := CONCAT('ALTER TABLE ', lv_table_name
                        , ' DROP FOREIGN KEY ', lv_constraint_name);
                        
        /* Prepare, fun, and deallocate statement. */
        PREPARE lv_stmt FROM @SQL;
        EXECUTE lv_stmt;
        DEALLOCATE PREPARE lv_stmt;
    
    END LOOP cursor_foreign_key;
    CLOSE foreign_key_cursor;
    
END;
$$

DELIMITER ;
