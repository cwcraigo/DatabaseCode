-- ex03-05.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Forcing Commit Statements and Writing Comments
---------------------------------------------------------------------------
INSERT
  INTO  oe.orders
        ( order_id, order_date, customer_id, order_status
        , order_total, sales_rep_id, promotion_id
        , gross_profit )
VALUES  ( 2459, systimestamp, 981, 10, 15395.12, 163, 1, 7697.56 );

COMMIT WRITE BATCH NOWAIT;