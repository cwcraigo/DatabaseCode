-- ex03-02.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Complex Savepoint and Rollback Logic
---------------------------------------------------------------------------
CREATE TABLE hr.sales_compensation
( sales_rep_id        NUMBER
, qtr_sales_period    VARCHAR2(5)
, qtr_order_total     NUMBER
, qtr_gross_profit    NUMBER
, qtr_salary_amount   NUMBER
, qtr_bonus_paid      NUMBER
, qtr_probation_flag  CHAR
, update_timestamp    TIMESTAMP
);

DECLARE
  ln_sales_bonus        NUMBER;
  lb_sales_probation    BOOLEAN;

  CURSOR c_sales IS
    WITH sales_quarter_31999 AS
    ( SELECT  oe.sales_rep_id
           ,  SUM ( oe.order_total ) qtr_order_total
           ,  SUM ( oe.gross_profit ) qtr_gross_profit
           ,  TO_CHAR ( oe.order_date, 'QYYYY' ) qtr_sales_period
        FROM  oe.orders oe
       WHERE  TO_CHAR ( oe.order_date, 'QYYYY' ) = '31999'
         AND  oe.sales_rep_id IS NOT NULL
    GROUP BY  oe.sales_rep_id
           ,  TO_CHAR ( oe.order_date, 'QYYYY' ) )
    SELECT  sq.*
         ,  e.salary * 3 qtr_salary_amount
         ,  e.commission_pct
      FROM  sales_quarter_31999 sq
         ,  hr.employees e
     WHERE  sq.sales_rep_id = e.employee_id;
BEGIN
  SAVEPOINT a;
  FOR r_sales IN c_sales LOOP
    IF    r_sales.qtr_gross_profit -
        ( r_sales.qtr_salary_amount +
          r_sales.qtr_gross_profit *
          r_sales.commission_pct ) > 1000
    THEN
      ln_sales_bonus := r_sales.qtr_salary_amount +
                        r_sales.qtr_gross_profit *
                        r_sales.commission_pct;
      INSERT
        INTO  hr.sales_compensation
      VALUES  ( r_sales.sales_rep_id
              , r_sales.qtr_sales_period
              , r_sales.qtr_order_total
              , r_sales.qtr_gross_profit
              , r_sales.qtr_salary_amount
              , ln_sales_bonus
              , 'N'
              , systimestamp
              );
    END IF;
  END LOOP;

  SAVEPOINT b;
  FOR r_sales IN c_sales LOOP
    IF    r_sales.qtr_gross_profit -
        ( r_sales.qtr_salary_amount +
          r_sales.qtr_gross_profit *
          r_sales.commission_pct ) < 1000
    AND   r_sales.qtr_gross_profit -
        ( r_sales.qtr_salary_amount +
          r_sales.qtr_gross_profit *
          r_sales.commission_pct ) > 500
    THEN
      INSERT
        INTO  hr.sales_compensation
      VALUES  ( r_sales.sales_rep_id
              , r_sales.qtr_sales_period
              , r_sales.qtr_order_total
              , r_sales.qtr_gross_profit
              , r_sales.qtr_salary_amount
              , 0
              , 'N'
              , systimestamp
              );
    END IF;
  END LOOP;

  SAVEPOINT c;
  FOR r_sales IN c_sales LOOP
    IF      r_sales.qtr_gross_profit -
        ( r_sales.qtr_salary_amount +
          r_sales.qtr_gross_profit *
          r_sales.commission_pct ) < 500
    THEN
      INSERT
        INTO  hr.sales_compensation
      VALUES  ( r_sales.sales_rep_id
              , r_sales.qtr_sales_period
              , r_sales.qtr_order_total
              , r_sales.qtr_gross_profit
              , r_sales.qtr_salary_amount
              , 0
              , 'Y'
              , systimestamp
              );
      lb_sales_probation := TRUE;
    END IF;
  END LOOP;
  -- Logic is purposefully set to throw SAVEPOINT. Rolling back to A
  -- retracts all updates.
  IF lb_sales_probation = TRUE THEN
    ROLLBACK TO SAVEPOINT A;
  END IF;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ( SQLERRM );
    ROLLBACK TO SAVEPOINT a;
END;
/
