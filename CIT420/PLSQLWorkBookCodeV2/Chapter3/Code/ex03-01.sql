-- ex03-01.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Creating a Simple Savepoint in PL/SQL
-- -----------------------------------------------------------------------
DECLARE
  CURSOR c_sales_promo IS
    SELECT  order_id
      FROM  oe.orders
     WHERE  promotion_id IS NULL
       AND  to_char( order_date, 'MMYYYY') = '081999';
BEGIN
  SAVEPOINT assign_promo_id;
  FOR r_sales_promo IN c_sales_promo LOOP
    UPDATE  oe.orders
       SET  promotion_id = 2
     WHERE  order_id = r_sales_promo.order_id;
  END LOOP;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO assign_promo_id;
END;
/
