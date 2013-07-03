-- to debug procedures and functions -> debugging mysql procedures
USE studentdb

DROP FUNCTION IF EXISTS unary;

DELIMITER $$

CREATE FUNCTION unary(pv_input INT) RETURNS INT
BEGIN
    RETURN IFNULL(pv_input,0) + 1;
END;
$$

DELIMITER ;

SELECT unary(0);

SET @holding := unary(unary(0));

SELECT @holding;