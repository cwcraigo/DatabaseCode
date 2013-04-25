-- ex08-02.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Declaring Variables and Cursors Within the Specification
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE
  employee_benefits
  AUTHID CURRENT_USER
  AS
---------------------------------------------------------------------------
  ln_max_raise_percentage   CONSTANT NUMBER := .1;
  ln_employee_id            NUMBER;
  ln_department_id          NUMBER;
  ln_max_salary             NUMBER;
  ln_min_salary             NUMBER;
  ln_new_salary             NUMBER;
  lv_job_id                 VARCHAR2(50);
  lv_full_name              VARCHAR2(100);
---------------------------------------------------------------------------
  CURSOR c_employees_by_eid IS
    SELECT  *
      FROM  hr.employees
     WHERE  employee_id = ln_employee_id;

  CURSOR c_employees_by_dpt IS
    SELECT  *
      FROM  hr.employees
     WHERE  department_id = ln_department_id;

  CURSOR c_jobs IS
    SELECT  *
      FROM  hr.jobs
     WHERE  job_id = lv_job_id;
  e_compensation_too_high   EXCEPTION;
---------------------------------------------------------------------------
  PROCEDURE give_raise  ( pi_department_id      IN  NUMBER
                        , pi_raise_percentage   IN  NUMBER
                        , po_status             OUT NUMBER
                        , po_sqlerrm            OUT VARCHAR2
                        );
---------------------------------------------------------------------------
END employee_benefits;
/