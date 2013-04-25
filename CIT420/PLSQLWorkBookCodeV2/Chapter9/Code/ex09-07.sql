-- ex09-07.sql
-- Chapter 9, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Distributed Transaction Triggers
-- Note: Dependency of the VIDEO_STORE schema.
-- -----------------------------------------------------------------------
ALTER TABLE video_store.item
  ADD ( customer_score  number CHECK ( customer_score BETWEEN 1 AND 5 ))
/

CREATE DATABASE LINK test_link
  CONNECT TO video_store
  IDENTIFIED BY abc123
  USING 'T001A'
/

CREATE MATERIALIZED VIEW item_corporate
  REFRESH FORCE
  START WITH TRUNC ( SYSDATE )
  NEXT TRUNC ( SYSDATE ) + 1
  AS
  SELECT  item_id
       ,  item_barcode
       ,  item_type
       ,  item_title
       ,  item_subtitle
       ,  item_rating
       ,  customer_score
       ,  last_updated_by
       ,  last_update_date
    FROM  video_store.item@test_link
/

CREATE VIEW item
  AS
  SELECT * FROM item_corporate
/

CREATE TABLE item_rating_cache
( item_id             NUMBER
, customer_score      NUMBER
, distributed_error   VARCHAR2(500)
)
/

CREATE OR REPLACE PROCEDURE distributed_dml
( pi_item_id          NUMBER
, pi_customer_score   NUMBER
)
AS
  ln_userid           NUMBER;
  lv_sqlerrm          VARCHAR2(500);
BEGIN
  UPDATE  video_store.item@test_link
     SET  customer_score = pi_customer_score
   WHERE  item_id = pi_item_id;
EXCEPTION
  WHEN OTHERS THEN
    lv_sqlerrm := SUBSTR ( SQLERRM,1,500 );
    INSERT
      INTO  item_rating_cache
    VALUES  ( pi_item_id
            , pi_customer_score
            , lv_sqlerrm
            );
END;
/

CREATE OR REPLACE TRIGGER item_corporate_trg
  INSTEAD OF UPDATE
  ON item
  FOR EACH ROW
BEGIN
  distributed_dml ( :NEW.item_id
                  , :NEW.customer_score
                  );
END;
/

UPDATE  item
   SET  customer_score = 3.5
 WHERE  item_id = 1040
/