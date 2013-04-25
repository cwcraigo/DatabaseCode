TEE W13_lab11.txt
USE newstore

SELECT "ITEM_LOG" AS "DROP";
DROP TABLE IF EXISTS contact_log;

SELECT "ITEM_LOG" AS "CREATE";
CREATE TABLE contact_log ( dml VARCHAR(6), title VARCHAR(60));

-- SELECT "TRIGGERS" AS "DROP";
DROP TRIGGER IF EXISTS contact_t1;
DROP TRIGGER IF EXISTS contact_t2;

DELIMITER $$

-- SELECT "INSERT" AS "TRIGGER"$$
CREATE TRIGGER contact_t1
BEFORE INSERT ON contact
FOR EACH ROW
BEGIN
  IF new.last_name REGEXP '^.*-.*' THEN
    INSERT INTO contact_log VALUES ('INSERT', new.last_name);
    SET new.last_name = REPLACE(new.last_name, '-', ' ');
  END IF;
END;
$$

-- SELECT "UPDATE" AS "TRIGGER"$$
CREATE TRIGGER contact_t2
BEFORE UPDATE ON contact
FOR EACH ROW
BEGIN
  IF new.last_name REGEXP '^.*-.*' THEN
    INSERT INTO contact_log VALUES ('UPDATE', new.last_name);
    SET new.last_name = REPLACE(new.last_name, '-', ' ');
  END IF;
END;
$$

DELIMITER ;

UPDATE contact
  SET last_name = 'Billy-Bob'
  WHERE last_name = 'Billy Bob';

NOTEE
-- SELECT * FROM contact\G
SELECT * FROM contact_log\G










/*


This is an INDIVIDUAL assignment, and written in MySQL and SQL/PSM. You should submit the script file by pasting your code into the comments section of the assignment.

The online store has videos, DVDs, and Blu-rays. The store has too many Star Wars videos and your manager wants to make sure no employee can put another Start Wars video into your stock of videos, DVDs, and Blu-rays. The best solution to enforce that is a row-level database trigger on INSERT events.

Assignment:
Your manager has decided that you should write an insert_t1 trigger (see pages 499-504) that prevents the insertion of any Star Wars video, DVD, or Blu-rays into the INSERT table. Any attempt to insert a new record into the ITEM table should raise a user-defined statement (see the books errata for the SIGNAL statement) that says:

No more Star Wars DVDs.

You should also write a row-level trigger for an INSERT table that blocks the insert of any video, DVD, or Blu-ray that contains "Star Wars" in the ITEM_TITLE column or attempts to update the ITEM_TITLE column. (HINT: This requires two separate triggers - one for the INSERT event and another for the UPDATE event.) You should also write a test case that attempts to INSERT a record for a Star Wars VI video in the ITEM table and UPDATE a record's ITEM_TITLE column.

Test Case:

Write two test programs; one that tries to insert a Star Wars VI video into the ITEM table, and one that tries to update an existing ITEM_TITLE column with a Star Wars VI name.

Sample Code:

You may use these as examples of database triggers for this lab. This sample MySQL trigger traps the insertion or update of a column value when the value uses a title or lower case word "Thing". You should note the regular expression handling of preceding and succeeding characters and the metasequence handling of the first letter in the IF statement. They always raise exceptions when they fire.

DROP TRIGGER IF EXISTS helper_t1;
DROP TRIGGER IF EXISTS helper_t2;

DELIMITER $$

CREATE TRIGGER helper_t1
BEFORE INSERT ON helper
FOR EACH ROW
BEGIN
  DECLARE helper_name INT UNSIGNED;
  IF new.helper_name REGEXP '(^|.*)(T|t)hing(.*)' THEN
    SET helper_name = -1;
  END IF;
END;
$$

CREATE TRIGGER helper_t2
BEFORE UPDATE ON helper
FOR EACH ROW
BEGIN
  DECLARE helper_name INT UNSIGNED;
  IF new.helper_name REGEXP '(^|.*)(T|t)hing(.*)' THEN
    SET helper_name = -1;
  END IF;
END;
$$

DELIMITER ;



*/