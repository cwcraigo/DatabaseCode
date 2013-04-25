-- ex09-02.sql
-- Chapter 9, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using FOLLOWS to Determine Firing Order
-- Note: This should be run in the VIDEO_STORE schema.
---------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER video_store.some_trigger1
  BEFORE INSERT ON video_store.contact
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE ( 'I fired first' );
END;
/

CREATE OR REPLACE TRIGGER video_store.some_trigger2
  BEFORE INSERT on video_store.contact
  FOR EACH ROW
  FOLLOWS video_store.some_trigger1
BEGIN
  DBMS_OUTPUT.PUT_LINE ( 'I fired second' );
END;
/

CREATE OR REPLACE TRIGGER video_store.some_trigger3
  BEFORE INSERT on video_store.contact
  FOR EACH ROW
  FOLLOWS video_store.some_trigger2
BEGIN
  DBMS_OUTPUT.PUT_LINE ( 'I fired second' );
END;
/