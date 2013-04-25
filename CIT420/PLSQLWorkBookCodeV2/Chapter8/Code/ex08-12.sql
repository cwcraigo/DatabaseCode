-- ex08-12.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Package Execution as Definer
---------------------------------------------------------------------------                       
CREATE OR REPLACE PACKAGE hr.employee_benefits
  AUTHID DEFINER
  AS
---------------------------------------------------------------------------
  ln_max_raise_amount     CONSTANT NUMBER := .1;
---------------------------------------------------------------------------
  PROCEDURE give_raise  ( pi_employee_id        IN NUMBER
                        , pi_raise_percentage   IN NUMBER
                        );
---------------------------------------------------------------------------
END employee_benefits;
/
show err

CREATE OR REPLACE PACKAGE BODY hr.employee_benefits
  AS
---------------------------------------------------------------------------
  PROCEDURE give_raise  ( pi_employee_id        IN NUMBER
                        , pi_raise_percentage   IN NUMBER
                        )
  IS
  BEGIN
    IF  pi_raise_percentage <= ln_max_raise_amount
    AND pi_raise_percentage IS NOT NULL
    AND pi_employee_id IS NOT NULL
    THEN
      UPDATE  hr.employees
         SET  salary = salary + ( salary * pi_raise_percentage )
       WHERE  employee_id = pi_employee_id;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE ('That employee does not exist.');
  END give_raise;
---------------------------------------------------------------------------
END employee_benefits;
/
CREATE USER jane_doe IDENTIFIED BY abc123;
GRANT CONNECT TO jane_doe;
GRANT EXECUTE ON hr.employee_benefits TO jane_doe;

SELECT SYS_CONTEXT ('USERENV','CURRENT_USER') who_am_i
  FROM dual;
CONNECT hr/hr;
SELECT  employee_id
     ,  first_name||' '||last_name full_name
     ,  salary
  FROM  hr.employees
 WHERE  employee_id = 100;
CONNECT jane_doe/abc123;
EXEC hr.employee_benefits.give_raise ( 100, .1 );
commit;

CONNECT hr/hr;
SELECT  employee_id
     ,  first_name||' '||last_name full_name
     ,  salary
  FROM  hr.employees
 WHERE  employee_id = 100;

CREATE OR REPLACE PACKAGE hr.employee_benefits
  AUTHID CURRENT_USER
  AS
---------------------------------------------------------------------------
  ln_max_raise_amount     CONSTANT NUMBER := .1;
---------------------------------------------------------------------------
  PROCEDURE give_raise  ( pi_employee_id        IN NUMBER
                        , pi_raise_percentage   IN NUMBER
                        );
---------------------------------------------------------------------------
END employee_benefits;
/
ALTER PACKAGE hr.employee_benefits COMPILE PACKAGE
/
EXEC hr.employee_benefits.give_raise ( 100, .1 );