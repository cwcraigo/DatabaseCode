-- ex09-03.sql
-- Chapter 9, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using Compound Triggers to Consolidate Multiple Trigger Types
-- Note: This should be run in the VIDEO_STORE schema.
---------------------------------------------------------------------------
SELECT  p.price_id
     ,  cl.common_lookup_type
     ,  i.item_title
     ,  p.amount
     ,  active_flag
  FROM  video_store.price p
     ,  video_store.common_lookup cl
     ,  video_store.item i
 WHERE  p.price_type = cl.common_lookup_id
   AND  p.item_id = i.item_id
   AND  p.active_flag = 'Y'
/

BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'INVALID_PRICE_MODIFICATION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

 CREATE TABLE video_store.invalid_price_modification
 ( price_id                NUMBER
 , amount_old              NUMBER
 , amount_new              NUMBER
 , active_flag_old         CHAR
 , active_flag_new         CHAR
 , update_timestamp        TIMESTAMP
 )
 /

CREATE OR REPLACE TRIGGER video_store.invalid_price_trg
  FOR UPDATE ON video_store.price
  COMPOUND TRIGGER
    TYPE tt_invalid_price IS
      TABLE OF video_store.invalid_price_modification%ROWTYPE
      INDEX BY BINARY_INTEGER;
  lr_invalid_price  tt_invalid_price;

  ln_index      BINARY_INTEGER := 0;
  lt_timestamp  TIMESTAMP := SYSTIMESTAMP;

  PROCEDURE forall_flush IS
  BEGIN
    FORALL i IN 1 .. lr_invalid_price.COUNT
      INSERT
        INTO  video_store.invalid_price_modification
      VALUES  lr_invalid_price ( i );
    lr_invalid_price.delete;
    ln_index := 0;
  END;
AFTER EACH ROW IS
  BEGIN
    IF :NEW.amount < 1 THEN
      ln_index := ln_index + 1;
      lr_invalid_price( ln_index ).price_id         := :NEW.price_id;
      lr_invalid_price( ln_index ).amount_old       := :OLD.amount;
      lr_invalid_price( ln_index ).amount_new       := :NEW.amount;
      lr_invalid_price( ln_index ).active_flag_old  := :OLD.active_flag;
      lr_invalid_price( ln_index ).active_flag_new  := :NEW.active_flag;
      lr_invalid_price( ln_index ).update_timestamp := lt_timestamp;
    END IF;

    IF MOD ( ln_index, 50 ) = 0
    THEN forall_flush;
    ELSIF ln_index = lr_invalid_price.COUNT
    THEN forall_flush;
    END IF;
  END AFTER EACH ROW;
AFTER STATEMENT IS
  BEGIN
    video_store.dml_log ( 'UPDATE'
                        , 'PRICE'
                        , 'AMOUNT'
                        , NULL
                        , NULL
                        );
  END AFTER STATEMENT;
END invalid_price_trg;
/

UPDATE  video_store.price p
   SET  p.amount = p.amount - .5
 WHERE  p.active_flag = 'Y'
/
COMMIT

SELECT  *
  FROM  video_store.invalid_price_modification
/

SELECT  *
  FROM  video_store.change_history
 WHERE  table_name = 'PRICE'
/