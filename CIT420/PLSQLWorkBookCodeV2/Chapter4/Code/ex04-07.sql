-- ex04-07.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Encasing Within Loops
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
      FROM hr.employees;
BEGIN
  FOR r_employee IN c_employee LOOP
    ln_employee_id := r_employee.employee_id;

    DECLARE
      no_salesman_found   exception;
    BEGIN
      SELECT SUM ( order_total )
        INTO ln_order_total
        FROM oe.orders
       WHERE sales_rep_id = ln_employee_id;

      IF ln_order_total IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE ( ln_order_total );
      ELSE
        RAISE no_salesman_found;
      END IF;
    EXCEPTION
      WHEN no_salesman_found THEN
        DBMS_OUTPUT.PUT_LINE ( 'Caught NO_SALESMAN_FOUND' );
    END;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ( SQLERRM );
END;
/
