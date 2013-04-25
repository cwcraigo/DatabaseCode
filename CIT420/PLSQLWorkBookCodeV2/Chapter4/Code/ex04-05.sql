-- ex04-05.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using PRAGMA EXCEPTION_INIT to Catch System Errors
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
CREATE TABLE hr.emergency_contact
  ( employee_id   NUMBER
  , full_name     VARCHAR2(50)
  , phone_home    VARCHAR2(15)
  , phone_cell    VARCHAR2(15)
  , phone_pager   VARCHAR2(15)
  );

ALTER TABLE hr.emergency_contact
  ADD ( CONSTRAINT ec_employee_id_unk
        UNIQUE ( employee_id, full_name ));

BEGIN
  FOR i IN 1 .. 2 LOOP
    INSERT
      INTO hr.emergency_contact
    VALUES ( 1
           , 'Jane Doe'
           , '+1.123.456.7890'
           , NULL
           , '+1.123.567.8901'
           );
  END LOOP;
END;
/

DECLARE
  unique_constraint exception;
  pragma exception_init (unique_constraint, -00001);
BEGIN
  INSERT
    INTO hr.emergency_contact
  VALUES ( 1
         , 'Jane Doe'
         , '+1.123.456.7890'
         , NULL
         , '+1.123.567.8901'
         );
EXCEPTION
  WHEN unique_constraint THEN
    DBMS_OUTPUT.PUT_LINE ( 'Oops! You just threw the unique_constraint error');
 END;
 /
