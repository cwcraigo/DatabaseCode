-- This is an INDIVIDUAL assignment, and written exclusively in MySQL SQL and SQL/PSM.
-- You should submit the script file by pasting your code into the comments section of the assignment.

-- The on line store carried different types of VHS tapes but nobody is buying them anymore.
-- The store is going to remove them from inventory but must retain the information about them to
-- correspond to historical purchases and accounting transactions. The decision was made to add
-- anobsolete_date column to the ITEM table. The column should have a DATE data type, and it should
-- contain the date that an item was removed from inventory.

-- While solving the problem, please note that all product information is stored in uppercase strings,
-- which is meaningless in MySQL unless you perform binary comparisons.
-- This simplifies how you use a wild card operator. You have the LIKE or REGEXP wild cards available
-- and they can simplify how you solve the problem.

-- Assignment:
-- Your manager has decided that you should write one function and one procedure to solve this problem
-- because the manager wants you to test both await and no wait approach to solving the problem.
-- (A wait approach calls a function or procedure in line [or in the same swim lane],
    -- and a no wait approach calls a function or procedure that runs in an external scope [a different swim lane].)
-- The function and procedure should simultaneously perform two tasks, and they should be called the
-- insert_function and insert_procedure respectively. One task updates theobsolete_date column in
-- the item table with the date it is removed from inventory.
-- The other task inserts a list of updated items into a logging temporary table.
-- (This solution differs from the Oracle solution because MySQL doesn't support arrays.)
-- You should insert the both the item_title and obsolete_date columns from rows changed by
-- the function or procedure. The function should take only one parameter while
-- the procedure takes one IN mode parameter and an OUT mode parameter, which is the item_type description
-- found in thecommon_lookup table's common_lookup_type column.

-- (Note: You will need to map, or join, the item table's item_type column value
-- to the common_lookup table's common_lookup_id value. There are a number of ways
-- to solve this problem and you're free to choose which approach works best for you.
-- Check the Multiple-Table Update Statement on Page 258-259.)

-- Please note that MySQL procedures are always processed in line and treated as wait approach programming solutions;
-- and the same is true of functions because they can't be autonomous.
-- The difference between functions and procedures is that a pass-by-value function can return a value
-- that signifies success or failure, while a pass-by-value procedure can't.
-- A procedure must use a pass-by-reference parameter to implement an equivalent outcome like

-- Create a logging temporary table, where you set the engine = memory;
-- the table should contain two columns and, unlike Oracle you don't need to
-- create a structure and then a list or array of the structure because tables are
-- already list structures of their column list definition:item_title and obsolete_date columns.
-- A formal pv_item_type parameter of a variable length string, which is equivalent to
-- the common_lookup_type column's size in thecommon_lookup table.
-- A formal return parameter of an int for the function, and a formal parameter that uses an OUT mode for the procedure.
-- That means you have one IN mode formal parameter for the function,
-- and two formal parameters for the procedure - one uses IN mode and the other OUT mode.
-- The function should returns a 0 when the program fails and a 1 when the program succeeds.
-- The procedure OUT mode parameter should return a zero when it fails and a one when it succeeds.
-- By way of example, you may use a cursor with the SELECT-INTO style that uses the formal parameter
-- as the lookup value in a WHEREclause but there are better solutions.

-- Test Case:
-- The function will be wrapping in a testing procedure because it's required to test function.
-- The procedure is a stand alone unit, which you can call with the EXECUTE command.
-- That means you're writing one function, one comparative procedure (like the function),
-- and a separate test procedure for the function.
-- Use a query to call the insert_function with a valid common_lookup_type value,
-- and then display the results in the logging temporary table.
-- After the test, truncate the values from the logging table. This is managed inside a procedure.
-- Use a CALL statement to run the insert_procedure with a valid common_lookup_type value,
-- and then display the results from the logging temporary table.
-- -------------------------------------------------------------------------------
use studentdb;

ALTER TABLE item
  DROP COLUMN obsolete_date;

ALTER TABLE item
  ADD (obsolete_date DATE);

DROP TABLE IF EXISTS logging;
CREATE TABLE logging
 (item_title VARCHAR(60)
 ,obsolete_date DATE) ENGINE=MEMORY;

-- -------------------------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_procedure$$
CREATE PROCEDURE insert_procedure(pv_item_type VARCHAR(60),OUT pv_return INT)
MODIFIES SQL DATA
BEGIN

  DECLARE fetched       INT DEFAULT 0;
  DECLARE lv_item_type  INT;
  DECLARE lv_item_title VARCHAR(60);
  DECLARE lv_return     INT DEFAULT 1;

  DECLARE c CURSOR FOR
    SELECT item_type, item_title
    FROM item INNER JOIN common_lookup
    ON item_type = common_lookup_id
    WHERE common_lookup_type LIKE CONCAT(pv_item_type,'%');

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
      SET fetched = 1;
      SET lv_return = 0;
    END;

  OPEN c;
  myLoop:LOOP

    FETCH c INTO lv_item_type, lv_item_title;

    IF fetched = 1 THEN
      LEAVE myloop;
    END IF;

    UPDATE item
      SET obsolete_date = NOW()
      WHERE item_type = lv_item_type
      AND item_title = lv_item_title;

    INSERT INTO logging VALUES (lv_item_title, NOW());

  END LOOP myLoop;
  CLOSE c;

  SET pv_return = lv_return;

END;
$$

-- -------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS insert_function$$
CREATE FUNCTION insert_function(pv_item_type VARCHAR(60)) RETURNS INT UNSIGNED
MODIFIES SQL DATA
BEGIN

  DECLARE fetched       INT DEFAULT 0;
  DECLARE lv_item_type  INT;
  DECLARE lv_item_title VARCHAR(60);
  DECLARE lv_return     INT DEFAULT 1;

  DECLARE c CURSOR FOR
    SELECT item_type, item_title
    FROM item INNER JOIN common_lookup
    ON item_type = common_lookup_id
    WHERE common_lookup_type LIKE CONCAT(pv_item_type,'%');

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
      SET fetched = 1;
      SET lv_return = 0;
    END;

  OPEN c;
  myLoop:LOOP

    FETCH c INTO lv_item_type, lv_item_title;

    IF fetched = 1 THEN
      LEAVE myloop;
    END IF;

    UPDATE item
      SET obsolete_date = NOW()
      WHERE item_type = lv_item_type
      AND item_title = lv_item_title;

    INSERT INTO logging VALUES (lv_item_title, NOW());

  END LOOP myLoop;

  CLOSE c;

  RETURN lv_return;

END;
$$

-- -------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS test_insert_function$$
CREATE PROCEDURE test_insert_function(pv_message VARCHAR(60))
MODIFIES SQL DATA
BEGIN

  DECLARE lv_truth INT DEFAULT 0;

  START TRANSACTION;

  SAVEPOINT before_transaction;

  SET lv_truth := insert_function(pv_message);

  IF lv_truth = TRUE THEN
    COMMIT;
  ELSE
    ROLLBACK TO before_transaction;
  END IF;

END;
$$
DELIMITER ;

CALL insert_procedure('VHS',@sv_return);
SELECT @sv_return AS 'PROCEDURE RESULT';
SELECT * FROM logging;
TRUNCATE TABLE logging;

CALL test_insert_function('VHS');
SELECT * FROM logging;