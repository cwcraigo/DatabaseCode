-- ex04-02.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Multiple Error Stack
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  lv_full_name VARCHAR2(50);

  CURSOR c_emp IS
    SELECT  *
      FROM  hr.employees;
BEGIN
  FOR r_emp IN c_emp LOOP
    lv_full_name = r_emp.first_name||' '||r_emp.last_name;

    IF r_emp.department_id := 50 THEN
      DBMS_OUTPUT.PUT_LINE ( lv_full_name );
    END IF;
  END LOOP;
END;
/
