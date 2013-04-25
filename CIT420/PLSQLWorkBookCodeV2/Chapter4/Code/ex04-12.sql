-- ex04-12.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using RAISE_APPLICATION_ERROR to Catch Error Conditions
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  CURSOR c_rental IS
    SELECT  c.member_id
         ,  c.first_name||' '||c.last_name full_name
         ,  t.transaction_amount
      FROM  video_store.transaction t
         ,  video_store.rental r
         ,  video_store.contact c
     WHERE  r.rental_id = t.rental_id
       AND  r.customer_id = c.contact_id;
BEGIN
  FOR r_rental IN c_rental LOOP
    IF r_rental.transaction_amount > 75 THEN
      RAISE_APPLICATION_ERROR ( -20001, 'No transaction may be more than $75', TRUE );
    END IF;
  END LOOP;
END;
/