-- ex08-03.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using Public Cursors
---------------------------------------------------------------------------
BEGIN
  employee_benefits.ln_employee_id := 100;

  FOR r_employees_by_eid IN employee_benefits.c_employees_by_eid LOOP
    employee_benefits.lv_full_name := r_employees_by_eid.first_name||' '||
                                      r_employees_by_eid.last_name;

    DBMS_OUTPUT.PUT_LINE ( employee_benefits.lv_full_name );
  END LOOP;
END;
/