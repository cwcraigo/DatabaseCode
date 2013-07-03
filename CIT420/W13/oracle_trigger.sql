
-- lab 10 Oracle
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE TRIGGER helper_t1
BEFORE INSERT OR UPDATE ON item
FOR EACH ROW
  WHEN (REGEXP_LIKE(new.item_title,'(^|.*)(S|s)tar (W|w)ars(.*)'))
BEGIN
  RAISE_APPLICATION_ERROR(-20001, 'No more Star Wars DVDs!!!');
END helper_t1;
/

-- anonymous block to re-raise error.
DECLARE
  lv_error  EXCEPTION;
  PRAGMA EXCEPTION_INIT(lv_error,-20001);
BEGIN
  
  UPDATE item
    SET item_title = 'Star Wars';


  INSERT INTO item VALUES
  ( item_s1.NEXTVAL
  , '1010-1010-1010'
  , 1011
  , 'Star Wars XXVIII'
  , NULL
  , 'PG-11'
  , SYSDATE
  , 1, SYSDATE, 1, SYSDATE);

  EXCEPTION
    WHEN lv_error THEN
      dbms_output.put_line('TRIGGER Error: '||SQLERRM);
    WHEN OTHERS THEN
      dbms_output.put_line('OTHERS Error: '||SQLERRM);

END;
/
