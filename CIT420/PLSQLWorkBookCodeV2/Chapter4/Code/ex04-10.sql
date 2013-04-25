-- ex04-10.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Creation of User Defined Error Conditions
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  ln_order_total    number;
  ln_promotion_id   number := 1;
  ln_order_count    number;
  no_promo_found    exception;
BEGIN
  SELECT COUNT(*)
    INTO ln_order_count
    FROM oe.orders
   WHERE promotion_id = ln_promotion_id;

  IF ln_order_count > 0 THEN
    SELECT SUM ( order_total )
      INTO ln_order_total
      FROM oe.orders
     WHERE promotion_id = ln_promotion_id;
  ELSE
    raise no_promo_found;
  END IF;
EXCEPTION
  WHEN no_promo_found THEN
   DBMS_OUTPUT.PUT_LINE ( 'No Sales found for Promotion: '||ln_promotion_id);
END;
/
