-- ex08-07.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Subprograms Become Invalid
---------------------------------------------------------------------------
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'EMPLOYEE_SUGGESTIONS') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
            FROM   user_sequences
            WHERE  sequence_name = 'ES_SUGGESTION_ID_SEQ') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.sequence_name;
  END LOOP;
END;
/

CREATE TABLE employee_suggestions
( employee_id             NUMBER(25)
, suggestion_id           NUMBER(25)
, summary                 VARCHAR2(100)
, description             VARCHAR2(500)
, approved_flag           CHAR
, savings                 NUMBER(10,2)
, bonus_paid              NUMBER(10,2)
, bonus_paid_date         DATE
)
/

CREATE SEQUENCE es_suggestion_id_seq
  START WITH 1
  INCREMENT BY 1
  NOCYCLE
  NOCACHE
/

CREATE OR REPLACE PROCEDURE hr.give_bonus
( pi_employee_id          IN NUMBER
, pi_savings              IN NUMBER
, pi_bonus_paid           IN NUMBER
, pi_bonus_paid_date      IN DATE
)
AS
  lv_termination_flag     CHAR := 'Y';
BEGIN
  SELECT  termination_flag
    INTO  lv_termination_flag
    FROM  hr.employees
   WHERE  employee_id = pi_employee_id;
  
  
  IF  lv_termination_flag = 'N'
  AND pi_bonus_paid > 50
  AND pi_bonus_paid < pi_savings * .1
  THEN
    INSERT
      INTO  employee_suggestions
    VALUES  ( pi_employee_id
            , es_suggestion_id_seq.nextval
            , 'A Summary about something neat.'
            , 'Make sure you use packages when programming PL/SQL.'
            , 'Y'
            , pi_savings
            , pi_bonus_paid
            , pi_bonus_paid_date
            );
  ELSE
    INSERT
      INTO  employee_suggestions
            ( employee_id
            , suggestion_id
            , summary
            , description
            , approved_flag
            )
    VALUES  ( pi_employee_id
            , es_suggestion_id_seq.nextval
            , 'A Summary about something neat.'
            , 'Make sure you use packages when programming PL/SQL.'
            , 'N'
            );
  END IF;
END give_bonus;
/

SELECT  owner
     ,  object_name
     ,  status
  FROM  all_objects
 WHERE  object_name = 'GIVE_BONUS';
 
SELECT  name
     ,  type
     ,  referenced_owner as r_owner
     ,  referenced_name  as r_name
     ,  referenced_type  as r_type
     ,  dependency_type  as d_type
  FROM  user_dependencies
 WHERE  name = 'GIVE_BONUS';
 
ALTER TABLE hr.employees
  MODIFY ( termination_flag CHAR );

SELECT  owner
     ,  object_name
     ,  status
  FROM  all_objects
 WHERE  object_name = 'GIVE_BONUS'
    OR  object_name = 'DO_IT';