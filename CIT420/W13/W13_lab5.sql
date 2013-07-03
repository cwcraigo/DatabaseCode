-- RUN ONCE THE LAB5_POST_SEED_ORACLE.SQL SCRIPT TO INSERT 7 ROWS OF VHS TAPES.
-- @lab5_post_seed_oracle.sql

-- ----------------------------------------------------------------------------------------------
-- DROP PARENT OBJECT->(ITEM_TABLE) BEFORE YOU CAN REPLACE CHILD->(ITEM_SET)
DROP TYPE item_table;

CREATE OR REPLACE TYPE item_set IS OBJECT
(item_title VARCHAR2(60), obsolete_date DATE);
/

-- DECLARE A SQL LIST_OF_TITLES DATA TYPE OF A TABLE OF THE ITEM_TITLE COLUMN.
CREATE OR REPLACE TYPE item_table IS TABLE OF item_set;
/
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
-- DROP COLUMN 'REMOVED_DATE' FOR RERUN-ABILITY
ALTER TABLE item
  DROP COLUMN obsolete_date;

-- ADD A REMOVED_DATE COLUMN OF THE DATE DATA TYPE TO THE ITEM TABLE.
ALTER TABLE item
  ADD (obsolete_date DATE);
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION obsolete_item
(pv_item_type VARCHAR2) RETURN ITEM_TABLE IS --  RESULT_CACHE RELIES_ON(item)
PRAGMA AUTONOMOUS_TRANSACTION;

  -- DECLARE A PL/SQL LV_ITEMS VARIABLE OF THE LIST_OF_TITLES DATA TYPE
    -- (DON'T FORGET TO INITIALIZE OR CONSTRUCT AN INSTANCE OF THE DATA TYPE).
  lv_items ITEM_TABLE := ITEM_TABLE();
  -- LV_ITEM_TYPE NUMBER; -- STORES CL_ID FROM SELECT-INTO
  lv_counter PLS_INTEGER := 1; -- COUNTER TO USE FOR LV_ITEMS.

  CURSOR c IS
  	SELECT 	item_type, item_title
  	FROM 	common_lookup INNER JOIN item
  	ON 		common_lookup_id = item_type
  	WHERE common_lookup_type LIKE '%'||UPPER(pv_item_type)||'%';

BEGIN

  FOR x IN c LOOP

    -- UPDATE THE ITEM TABLE'S REMOVED_DATE COLUMN WITH THE TRUNCATED SYSDATE VALUE
    UPDATE item
      SET   obsolete_date = TRUNC(SYSDATE)
      WHERE item_title = x.item_title
      AND   item_type = x.item_type;

    -- ASSIGN THE ITEM_TITLE RETURNED BY THE CURSOR TO THE LOCAL LV_ITEMS LIST VARIABLE.
    lv_items.EXTEND; -- ALLOCATE MEMORY FOR LV_ITEMS.
    lv_items(lv_counter) := item_set(x.item_title, TRUNC(SYSDATE));
    lv_counter := lv_counter + 1; -- INCREMENT COUNTER.

    -- COMMIT WITHIN THE DISPATCHED SUB-SHELL.
    COMMIT;

  END LOOP;

  -- RETURN THE LV_ITEMS COLLECTION FROM THE FUNCTION BY USING THE TABLE FUNCTION IN A QUERY.
  RETURN lv_items;

END;
/

-- PRINT FUNCTION WITH LINE NUMBERS
LIST
-- PRINT ERRORS OF RECENT PL/SQL PROGRAM
SHOW ERRORS
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
-- RUN OBSOLETE_ITEM USING THE TABLE() FUNCTION WHICH ENABLES THE UDT YOU CREATED TO BE DISPLAYED.
SELECT * FROM TABLE(obsolete_item('VhS'));
-- ----------------------------------------------------------------------------------------------






