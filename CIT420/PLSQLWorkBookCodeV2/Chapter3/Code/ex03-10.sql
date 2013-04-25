-- ex03-09.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Issuing Invoker Rights (pseudo code)
---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION hr.give_raise
( pi_employee_id in number )
AUTHID CURRENT_USER
AS
... declarative code goes here ...
BEGIN
... do something here and return ...
EXCEPTION
... handle the exception here and return ...
END;
/