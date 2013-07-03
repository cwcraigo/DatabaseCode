-- ^ - beginning of string
-- . - single character
-- * - many
-- $ - end of string
-- (a|b) - a or b
-- .* - any number of characters


CREATE OR REPLACE TRIGGER insert_t1
BEFORE INSERT OR UPDATE ON item
FOR EACH ROW
	WHEN (REGEXP_LIKE(new.item_title,'(^|.*)(S|s)tar\s(W|w)ars(.*)'))
DECLARE
  lv_error  EXCEPTION;
  PRAGMA EXCEPTION_INIT(lv_error, -20001);
BEGIN
  RAISE_APPLICATION_ERROR(-20001,'No more Star Wars DVDs!');
END insert_t1;
/



BEGIN

	INSERT INTO item
		( item_id
		,	item_barcode
		, item_type
		, item_title
		, item_sub_title
		, item_desc
		, item_photo
		, item_rating
		, item_rating_agency
		, item_release_date
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES
    ( item_s1.NEXTVAL
    , '11111-11111'
    , 1011
    , 'No more Star Wars?'
    , 'Bantha Fodder'
    , EMPTY_CLOB()
    , NULL
    , 'R'
    , 'MPAA'
    , SYSDATE
    , 1
    , SYSDATE
    , 1
    , SYSDATE);

    UPDATE item
        SET item_title = 'Star Wars XXVXI'
        WHERE item_title = 'Hook';

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
END;
/






/*

This is an INDIVIDUAL assignment, and written exclusively in Oracle SQL and PL/SQL. You should submit the script file by pasting your code into the comments section of the assignment.

The online store has videos, DVDs, and Blu-rays. The store has too many Star Wars videos and your manager wants to make sure no employee can put another Start Wars video into your stock of videos, DVDs, and Blu-rays. The best solution to enforce that is a row-level database trigger on INSERT events.

Assignment:
Your manager has decided that you should write an insert_t1 trigger (see pages 494-499) that prevents the insertion of any Star Wars video, DVD, or Blu-rays into the INSERT table. Any attempt to insert a new record into the ITEM table should raise a user-defined statement (see pages 420-424) that says:

No more Star Wars DVDs.

You should also write a row-level trigger for an INSERT table that blocks the insert of any video, DVD, or Blu-ray that contains "Star Wars" in the ITEM_TITLE column or attempts to update the ITEM_TITLE column. (HINT: This requires two separate triggers - one for the INSERT event and another for the UPDATE event.) You should also write a test case that attempts to INSERT a record for a Star Wars VI video in the ITEM table and UPDATE a record's ITEM_TITLE column.

Test Case:

Write two test programs; one that tries to insert a Star Wars VI video into the ITEM table, and one that tries to update an existing ITEM_TITLE column with a Star Wars VI name.

Sample Code:

You may use these as examples of database triggers for this lab. You should note the regular expression handling of preceding and succeeding characters and the metasequence handling of the first letter in the WHEN clause. When the trigger fires, it always raises an exception.

CREATE OR REPLACE TRIGGER helper_t1
BEFORE INSERT OR UPDATE ON helper
FOR EACH ROW
WHEN (REGEXP_LIKE(new.helper_name,'(^|.*)(T|t)hing(.*)'))
DECLARE
  lv_error  EXCEPTION;
BEGIN
  RAISE lv_error;
END helper_t1;
/

*/