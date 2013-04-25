-- ex04-04.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: An Iterative Coding Approach Prevents Unnecessary Debugging
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  ln_year                 NUMBER := 2000;
  ln_total_salary         NUMBER;

  CURSOR c_orders IS
    with sales_by_quarter as
    (   SELECT o.sales_rep_id
             , TO_CHAR ( o.order_date, '"Q-"Q" "YYYY' ) sales_quarter
             , SUM ( o.gross_profit ) gross_profit
          FROM oe.orders o
         WHERE TO_CHAR ( o.order_date, 'YYYY' ) = ln_year
      GROUP BY o.sales_rep_id
           , TO_CHAR ( o.order_date, '"Q-"Q" "YYYY' )
    )
    SELECT e.first_name||' '||e.last_name full_name
         , e.salary
         , e.commission_pct
         , sbq.*
      FROM hr.employees e
         , sales_by_quarter sbq
     WHERE e.employee_id = sbq.sales_rep_id
       AND rownum <= 3;
BEGIN
  FOR r_orders IN c_orders LOOP
    dbms_output.put_line  ( r_orders.full_name||' '||
                            r_orders.sales_quarter||' '||
                            r_orders.gross_profit
                          );
  END LOOP;
END;
/
-- phase 2
DECLARE
  ln_year                 NUMBER := 2000;
  ln_total_salary         NUMBER;

  CURSOR c_orders IS
    with sales_by_quarter as
    (   SELECT o.sales_rep_id
             , TO_CHAR ( o.order_date, '"Q-"Q" "YYYY' ) sales_quarter
             , SUM ( o.gross_profit ) gross_profit
          FROM oe.orders o
         WHERE TO_CHAR ( o.order_date, 'YYYY' ) = ln_year
      GROUP BY o.sales_rep_id
           , TO_CHAR ( o.order_date, '"Q-"Q" "YYYY' )
    )
    SELECT e.first_name||' '||e.last_name full_name
         , e.salary
         , e.commission_pct
         , sbq.*
      FROM hr.employees e
         , sales_by_quarter sbq
     WHERE e.employee_id = sbq.sales_rep_id
       AND rownum <= 3;
BEGIN
  FOR r_orders IN c_orders LOOP
    IF r_orders.gross_profit >= 10000
    THEN
      ln_total_salary := ln_total_salary + r_orders.gross_profit * .05;
      lv_bonus_achieved := 'Y';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE  ( r_orders.full_name||' '||
                            r_orders.sales_quarter||' '||
                            r_orders.gross_profit||' '||
                            r_orders.salary||' '||
                            r_orders.commission_pct||' '||
                            ln_total_salary||' '||
                            ( r_orders.gross_profit - ln_total_salary )||' '||
                            lv_bonus_achieved
                          );

    lv_bonus_achieved := 'N';
  END LOOP;
END;
/