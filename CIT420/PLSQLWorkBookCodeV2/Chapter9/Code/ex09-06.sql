-- ex09-06.sql
-- Chapter 9, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using FGA to Audit Events
-- -----------------------------------------------------------------------
BEGIN
  DBMS_FGA.ADD_POLICY ( object_schema     =>  'VIDEO_STORE'
                      , object_name       =>  'PRICE'
                      , policy_name       =>  'AUDIT_PRICE_MODXML'
                      , audit_condition   =>  'VIDEO_STORE.PRICE.AMOUNT < 1'
                      , audit_column      =>  'AMOUNT'
                      , handler_schema    =>  NULL
                      , handler_module    =>  NULL
                      , enable            =>  TRUE
                      , statement_types   =>  'INSERT, UPDATE'
                      , audit_trail       =>  DBMS_FGA.XML + DBMS_FGA.EXTENDED
                      , audit_column_opts =>  DBMS_FGA.ANY_COLUMNS
                      );
END;
/
UPDATE  video_store.price
   SET  amount = .25
 WHERE  active_flag = 'Y'
   AND  rownum <= 5
/
ROLLBACK
SELECT os_user
     , os_host
     , object_schema
     , object_name
     , policy_name
     , sql_bind
     , sql_text
  FROM V$XML_AUDIT_TRAIL
/

show parameter audit_file

cd /u01/app/oracle/product/11107/db_01/admin/t001/adump
oracle@ldsslcll21:/u01/app/oracle/product/11107/db_01/admin/t001/adump> ls *.xml
ora_8126.xml
