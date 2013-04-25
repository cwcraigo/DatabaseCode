-- ex03-03.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Savepoint Destruction
---------------------------------------------------------------------------
BEGIN
  SAVEPOINT create_job;
  INSERT
    INTO  hr.jobs
  VALUES  ( 'GrandPumba'
          , 'The grand owner of the business.'
          , 20000
          , 99999
          );

  SAVEPOINT create_employee;
  INSERT
    INTO  hr.employees
  VALUES  ( 999
          , 'Jane'
          , 'Doe'
          , 'doeja@oracle.com'
          , '+1 (123) 456-7890'
          , trunc ( sysdate )
          , 'GrandPumba'
          , 9999
          , .5
          , null
          , 90
          );

  SAVEPOINT add_job_history;
  INSERT
    INTO  hr.job_history
  VALUES  ( 999
          , trunc ( sysdate )
          , trunc ( sysdate + 2000 )
          , 'GrandPumba'
          , 90
          );

  ROLLBACK TO SAVEPOINT create_job;
  ROLLBACK TO SAVEPOINT add_job_history;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ( sqlerrm );
END;
/
