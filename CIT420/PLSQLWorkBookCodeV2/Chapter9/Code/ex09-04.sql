-- ex09-04.sql
-- Chapter 9, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using DDL Triggers to Enforce Coding Standards
-- Note: This should be run in the VIDEO_STORE schema.
---------------------------------------------------------------------------
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'AUDIT_CREATION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

CREATE TABLE video_store.audit_creation
( object_owner          varchar2(30)
, object_name           varchar2(30)
, created_by            varchar2(30)
, created_date          date
)
/

CREATE OR REPLACE TRIGGER video_store.audit_ddl
  BEFORE CREATE ON SCHEMA
BEGIN
  INSERT
    INTO  video_store.audit_creation
  VALUES  ( ORA_DICT_OBJ_OWNER
          , ORA_DICT_OBJ_NAME
          , SYS_CONTEXT ('USERENV', 'SESSION_USER')
          , SYSDATE
          );
END;
/

select *
  from video_store.audit_creation
/
