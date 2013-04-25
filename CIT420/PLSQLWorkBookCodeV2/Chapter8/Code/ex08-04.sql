-- ex08-04.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Creating a Slimmed-down GIVE_RAISE Procedure
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY                               
  employee_benefits                                          
  AS                                                         
                                                             
  PROCEDURE give_raise  ( pi_department_id      IN  NUMBER   
                        , pi_raise_percentage   IN  NUMBER   
                        , po_status             OUT NUMBER   
                        , po_sqlerrm            OUT VARCHAR2 
                        )                                    
  IS                                                         
  BEGIN                                                      
    FOR r_employees_by_dpt IN c_employees_by_dpt LOOP        
      SELECT  min_salary                                     
           ,  max_salary                                     
        INTO  ln_min_salary                                  
           ,  ln_max_salary                                  
        FROM  hr.jobs                                        
       WHERE  job_id = r_employees_by_dpt.job_id;            
                                                             
      ln_new_salary :=  r_employees_by_dpt.salary +          
                        r_employees_by_dpt.salary *          
                        pi_raise_percentage;                 
                                                             
      IF  ln_new_salary < ln_max_salary                      
      AND ln_new_salary > ln_min_salary                      
      AND ln_new_salary < r_employees_by_dpt.salary +        
                          r_employees_by_dpt.salary *        
                          ln_max_raise_percentage            
      THEN                                                   
        UPDATE  hr.employees                                 
           SET  salary = ln_new_salary                       
         WHERE  employee_id = r_employees_by_dpt.employee_id;
      ELSE                                                   
        RAISE e_compensation_too_high;                       
      END IF;                                                
    END LOOP;                                                
  END give_raise;                                            
END;                                                         
/           