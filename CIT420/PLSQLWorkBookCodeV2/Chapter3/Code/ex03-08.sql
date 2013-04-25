-- ex03-08.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Issuing a Lock Table Statement
---------------------------------------------------------------------------
LOCK TABLE hr.employees IN EXCLUSIVE MODE NOWAIT;

UPDATE hr.employees
   SET salary = salary * 1.025
 WHERE department_id = 10;

COMMIT;
