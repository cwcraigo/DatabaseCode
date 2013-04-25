-- ex04-09.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Savepoint Redirection
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  ln_employee_id          NUMBER;
  ln_order_total          NUMBER;
    
  CURSOR c_employee IS
    SELECT *
      FROM hr.employees
     WHERE commission_pct IS NOT NULL;
BEGIN
  FOR r_employee IN c_employee LOOP
    ln_employee_id := r_employee.employee_id;
    <<try_again>>
    BEGIN
      SELECT SUM ( order_total )
        INTO ln_order_total
        FROM oe.orders
       WHERE sales_rep_id = ln_employee_id;

      DBMS_OUTPUT.PUT_LINE ( ln_order_total );
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        GOTO try_again;
    END;
  END LOOP;
END;
/
