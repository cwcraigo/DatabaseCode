-- ex04setup.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: setup script
---------------------------------------------------------------------------
-- The merit_increase_type and compensation_history tables are used to
-- demonstrate both compiler and run-time errors. Random merit types and
-- amounts are assigned to each employee.
---------------------------------------------------------------------------
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name IN ('MERIT_INCREASE_TYPE','COMPENSATION_HISTORY') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

CREATE TABLE hr.merit_increase_type
( merit_type_id           number
, description             varchar2(50)
, update_timestamp        timestamp
)
/
INSERT INTO hr.merit_increase_type VALUES ( 1, 'Annual Merit Increase', systimestamp )
/
INSERT INTO hr.merit_increase_type VALUES ( 2, 'Promotion', systimestamp )
/
INSERT INTO hr.merit_increase_type VALUES ( 3, 'Performance Merit Increase', systimestamp )
/
INSERT INTO hr.merit_increase_type VALUES ( 4, 'Cost of Living', systimestamp )
/
CREATE TABLE hr.compensation_history
( employee_id             number
, merit_type_id           varchar2(50)
, merit_amount            number(3,2)
, increase_flag           char
, update_timestamp        timestamp
)
/
---------------------------------------------------------------------------
-- A simple block intended to populate the compensation_history table.
---------------------------------------------------------------------------
DECLARE
  ln_merit_type_id        NUMBER;
  ln_merit_amount         NUMBER;
  lv_increase_flag        CHAR;
  
  CURSOR c_emp IS
    SELECT employee_id
      FROM hr.employees;
BEGIN
  FOR r_emp IN c_emp LOOP
    FOR i IN 1 .. 10 LOOP
      ln_merit_type_id  := round ( dbms_random.value ( 01, 04 ) );
      ln_merit_amount   := round ( dbms_random.value ( .00, .25 ), 2);
      
      INSERT 
        INTO hr.compensation_history
      VALUES ( r_emp.employee_id
             , ln_merit_type_id
             , ln_merit_amount
             , null
             , systimestamp
             );
    END LOOP;
  END LOOP;
  COMMIT;
END;
/
---------------------------------------------------------------------------
-- Update 9 of the 10 rows per employee_id to 'N.' The 10th record should
-- be set to 'Y.'
---------------------------------------------------------------------------
update  hr.COMPENSATION_HISTORY
   set  increase_flag = 'N'
 where  rowid in (
select  rid
  from  ( select employee_id
               , rowid rid
               , rank() over  ( partition by EMPLOYEE_ID
                                    order by rowid
                              ) update_id
            from hr.compensation_history ch
        )
 where  update_id < 10)
/
update  hr.compensation_history
   set  increase_flag = 'Y'
 where  increase_flag is null
/
-- should have 107 records.
select  *
  from  hr.compensation_history ch
     ,  hr.merit_increase_type mit
 where  ch.MERIT_TYPE_ID = mit.MERIT_TYPE_ID
   and  ch.INCREASE_FLAG = 'Y'
/
