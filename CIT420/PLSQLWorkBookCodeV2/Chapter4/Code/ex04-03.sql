-- ex04-03.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Referenced cursor object is out of scope
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  CURSOR c_emp IS
    SELECT  *
      FROM  hr.employees;
BEGIN
  FOR r_emp IN c_emp LOOP
    DBMS_OUTPUT.PUT_LINE ( c_emp.first_name );
  END LOOP;
END;
/
