-- ex09-05.sql
-- Chapter 9, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using Triggers to Aid in Flashback Recovery
-- Note: This should be run in the SYS schema and you should manually
--       drop the tables where necessary.
---------------------------------------------------------------------------
CREATE TABLE hr.employees_fb
( employee_id             NUMBER(10,0)
, first_name              VARCHAR2(20)
, last_name               VARCHAR2(25)
, email                   VARCHAR2(25)
, phone_number            VARCHAR2(20)
, hire_date               DATE
, job_id                  VARCHAR2(10)
, salary                  NUMBER(10,2)
, commission_pct          NUMBER(2,2)
, manager_id              NUMBER(10,0)
, department_id           NUMBER(5,0)
, termination_flag        VARCHAR2(10)
)
/
CREATE TABLE sys.testbed_fb
( fb_name                 VARCHAR2(50)
, session_user            VARCHAR2(30)
, update_timestamp        TIMESTAMP
)
/
CREATE OR REPLACE PROCEDURE sys.set_flashback_testbed
AUTHID DEFINER
AS
  lv_timestring           VARCHAR2(20);
BEGIN
  lv_timestring := TO_CHAR ( SYSTIMESTAMP, 'MMDDYYYYSSFF');
  EXECUTE IMMEDIATE ' CREATE RESTORE POINT before_test'||lv_timestring;

  INSERT
    INTO  sys.testbed_fb
  VALUES  (  'BEFORE_TEST'||lv_timestring
          ,  SYS_CONTEXT ( 'USERENV', 'SESSION_USER' )
          ,  systimestamp
          );
  COMMIT;
END;
/

CREATE OR REPLACE TRIGGER sys.logon_fb
  AFTER LOGON
     ON DATABASE
BEGIN
  IF ora_login_user = 'HR' THEN
   set_flashback_testbed;
  END IF;
END;
/
ALTER TABLE hr.employees_fb
  ENABLE ROW MOVEMENT
/
INSERT
  INTO hr.employees_fb
SELECT *
  FROM hr.employees
/

select * from sys.testbed_fb;

FLASHBACK TABLE hr.employees_fb TO
RESTORE POINT BEFORE_TEST0620200949947000000;
SELECT  employee_id
     ,  first_name||' '||last_name full_name
  FROM  hr.employees_fb
 WHERE  rownum <= 3
/
