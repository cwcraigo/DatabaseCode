-- ex08-08.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: %TYPE Usage
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE hr.employee_perks
  AUTHID
  CURRENT_USER
  AS
  PROCEDURE give_bonus
  ( pi_employee_id          IN hr.employee_suggestions.employee_id%TYPE
  , pi_savings              IN hr.employee_suggestions.savings%TYPE
  , pi_bonus_paid           IN hr.employee_suggestions.bonus_paid%TYPE
  , pi_bonus_paid_date      IN hr.employee_suggestions.bonus_paid_date%TYPE
  );
END employee_perks;
/

CREATE OR REPLACE PACKAGE BODY hr.employee_perks                           
  AS                                                                       
  PROCEDURE give_bonus                                                     
  ( pi_employee_id          IN hr.employee_suggestions.employee_id%TYPE    
  , pi_savings              IN hr.employee_suggestions.savings%TYPE        
  , pi_bonus_paid           IN hr.employee_suggestions.bonus_paid%TYPE     
  , pi_bonus_paid_date      IN hr.employee_suggestions.bonus_paid_date%TYPE
  )                                                                        
  IS                                                                       
    lv_termination_flag     hr.employees.termination_flag%TYPE := 'Y';     
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
END employee_perks;
/