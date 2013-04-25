-- ex03-07.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using FOR UPDATE Within Cursors
---------------------------------------------------------------------------
DECLARE
  CURSOR c_employees IS
    SELECT  *
      FROM  hr.employees
    FOR UPDATE WAIT 10;
BEGIN
  FOR r_employees IN c_employees LOOP
    UPDATE  hr.employees
       SET  salary = salary * 1.025
     WHERE  CURRENT OF C_employees;
  END LOOP;
END;
/
