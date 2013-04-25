-- ex03-04.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Issuing a Commit with the Nowait and Batch Options
---------------------------------------------------------------------------
UPDATE  hr.employees
   SET  salary = salary * 1.03
 WHERE  department_id in ( 20, 30, 40 );

COMMIT WORK WRITE IMMEDIATE WAIT;
