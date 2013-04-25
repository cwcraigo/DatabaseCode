-- ex04-11.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Shortening Error Code by Using Oracle Defined Conditions
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  ln_order_total    number;
  ln_promotion_id   number := 1;
BEGIN
  SELECT order_total
    INTO ln_order_total
    FROM oe.orders
   WHERE promotion_id = ln_promotion_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('No Sales found for Promotion: '||ln_promotion_id);
END;
/
