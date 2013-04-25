-- ex04-14.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: An Instrumented PL/SQL Program
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  ln_nohint       NUMBER := DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS_NOHINT;
  ln_rindex       NUMBER := DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS_NOHINT;
  ln_slo          NUMBER;
  ln_target       NUMBER := 55334;
  lv_opname       VARCHAR2(30) := 'Update Customer Credit';
  lv_target_desc  VARCHAR2(30) := 'updating row:';
  ln_total_work   NUMBER := 0;
  ln_sofar        NUMBER := 0;

  
  CURSOR c_cust IS
    SELECT  customer_id
      FROM  customers
     WHERE  nls_territory in ( 'CHINA', 'JAPAN', 'THAILAND' );


BEGIN
  SELECT  count(*)
    INTO  ln_total_work
    FROM  customers
   WHERE  nls_territory in ( 'CHINA', 'JAPAN', 'THAILAND' );

  PLS_LOGGER  ( pi_program_name   => 'Update Customer Credit'
              , pi_log_level      => 'INFO'
              , pi_write_to       => 'SCREEN'
              , pi_error_message  => 'Updating '||ln_total_work||' rows.'
              );

  SAVEPOINT default_credit_limit
  FOR r_cust IN c_cust LOOP
    ln_sofar := ln_sofar + 1;
    
    UPDATE  customers
       SET  credit_limit = credit_limit * .95
     WHERE  customer_id = r_cust.customer_id;
     
    DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS
      ( rindex  => ln_rindex
      , slno    => ln_slo
      , op_name => lv_opname
      , target  => ln_target
      , target_desc => lv_target_desc
      , context     => 0
      , sofar       => ln_sofar
      , totalwork   => ln_total_work
      , units       => 'row updates'
      );
      
  END LOOP;
  COMMIT;
EXCEPTION
  WHEN others THEN
    ROLLBACK to default_credit_limit -- you must do this first
    
    PLS_LOGGER  ( pi_program_name   => 'Update Customer Credit'
                , pi_log_level      => 'FATAL'
                , pi_write_to       => 'ALL'
                , pi_error_message  => SQLERRM
                );
    COMMIT;
END;
/
