-- ex09-01.sql
-- Chapter 9, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Use of Triggers for DML Auditing
-- Note: This should be run in the VIDEO_STORE schema.
---------------------------------------------------------------------------
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables 
            WHERE  table_name = 'CHANGE_HISTORY') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

CREATE TABLE video_store.change_history
( dml_type            VARCHAR2(50)
, table_name          VARCHAR2(30)
, column_name         VARCHAR2(30)
, db_user             VARCHAR2(50)
, os_user             VARCHAR2(50)
, os_host             VARCHAR2(100)
, old_value           VARCHAR2(100)
, new_value           VARCHAR2(100)
, update_ts           TIMESTAMP
)
/

CREATE OR REPLACE PROCEDURE video_store.dml_log
( pi_dml_type         IN  VARCHAR2
, pi_table_name       IN  VARCHAR2
, pi_column_name      IN  VARCHAR2
, pi_old_value        IN  VARCHAR2
, pi_new_value        IN  VARCHAR2
)
IS
BEGIN
  INSERT
    INTO  video_store.change_history
  VALUES  ( pi_dml_type
          , pi_table_name
          , pi_column_name
          , SYS_CONTEXT ( 'USERENV', 'SESSION_USER' )
          , SYS_CONTEXT ( 'USERENV', 'OS_USER' )
          , SYS_CONTEXT ( 'USERENV', 'HOST' )||': '||
            SYS_CONTEXT ( 'USERENV', 'IP_ADDRESS' )
          , pi_old_value
          , pi_new_value
          , SYSTIMESTAMP
          );
END;
/

CREATE OR REPLACE TRIGGER video_store.member_change_history_trg
  BEFORE  INSERT
      OR  UPDATE
      ON  video_store.member
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  IF INSERTING THEN
  video_store.dml_log ( 'INSERT'
                      , 'MEMBER'
                      , 'CREDIT_CARD_NUMBER'
                      , :NEW.credit_card_number
                      , :OLD.credit_card_number
                      );
  ELSIF UPDATING THEN
  video_store.dml_log ( 'UPDATE'
                      , 'MEMBER'
                      , 'CREDIT_CARD_NUMBER'
                      , :NEW.credit_card_number
                      , :OLD.credit_card_number
                      );
  END IF;
END;
  
-- after inserting and updating two customers
SELECT  dml_type
     ,  db_user
     ,  os_user
     ,  os_host
     ,  old_value
     ,  new_value
     ,  update_ts
  FROM video_store.change_history
/