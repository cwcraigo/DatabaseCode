-- ex04-08.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Savepoint Exception Retry
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  ln_employee_id          NUMBER := 1;
  unique_constraint       EXCEPTION;

  PRAGMA EXCEPTION_INIT ( unique_constraint, -00001 );
BEGIN
  FOR i IN 1 .. 10 LOOP   -- insert 10 rows
    FOR j IN 1 .. 15 LOOP -- try 10x before giving up.
      BEGIN
        SAVEPOINT my_savepoint;
        
        INSERT
          INTO hr.emergency_contact
        VALUES ( ln_employee_id
               , 'Jane Doe'
               , '+1.123.456.7890'
               , NULL
               , '+1.123.567.8901'
               );
        EXIT; -- exit block if successful... otherwise we would get a
              -- possible 10x10 inserts.
      EXCEPTION
        WHEN unique_constraint THEN
          ROLLBACK TO my_savepoint;
          ln_employee_id := ln_employee_id + 1;
      END;
    END LOOP j;
  END LOOP i;
END;
/
