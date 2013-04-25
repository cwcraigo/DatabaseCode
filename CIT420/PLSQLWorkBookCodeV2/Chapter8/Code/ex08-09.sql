-- ex08-09.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Reuse via Modularization
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE
  error_handling
  AS
---------------------------------------------------------------------------
  gn_status               NUMBER;
  gn_sqlerrm              VARCHAR2(500);
  gd_timestamp            TIMESTAMP := SYSTIMESTAMP;
  gf_file                 UTL_FILE.FILE_TYPE;
---------------------------------------------------------------------------
  PROCEDURE printf  ( pi_program_name   IN VARCHAR2
                    , pi_directory      IN VARCHAR2
                    , pi_file           IN VARCHAR2
                    , pi_log_level      IN VARCHAR2
                    , pi_status         IN NUMBER
                    , pi_error_message  IN VARCHAR2
                    );

  PROCEDURE prints  ( pi_program_name   IN VARCHAR2
                    , pi_log_level      IN VARCHAR2
                    , pi_status         IN NUMBER
                    , pi_error_message  IN VARCHAR2
                    );
---------------------------------------------------------------------------
END error_handling;
/
CREATE OR REPLACE PACKAGE BODY                                             
  error_handling                                                           
  AS                                                                       
---------------------------------------------------------------------------
  PROCEDURE printf  ( pi_program_name   IN VARCHAR2                        
                    , pi_directory      IN VARCHAR2                        
                    , pi_file           IN VARCHAR2                        
                    , pi_log_level      IN VARCHAR2                        
                    , pi_status         IN NUMBER                          
                    , pi_error_message  IN VARCHAR2                        
                    )                                                      
  IS                                                                       
  BEGIN                                                                    
    gf_file := UTL_FILE.FOPEN                                              
      ( pi_directory                                                       
      , pi_file                                                            
      , 'a' -- appends to the file.                                        
      );                                                                   
                                                                           
    UTL_FILE.PUT_LINE                                                      
      ( gf_file                                                            
      , TO_CHAR( gd_timestamp,'HH:MM:SS.FF MON DD, YYYY' ) ||' ['||        
        pi_log_level ||'] '||                                              
        pi_program_name ||' '||                                            
        pi_error_message                                                   
      );                                                                   
                                                                           
    UTL_FILE.FCLOSE( gf_file );                                            
  END printf;                                                              
---------------------------------------------------------------------------
  PROCEDURE prints  ( pi_program_name   IN VARCHAR2                        
                    , pi_log_level      IN VARCHAR2                        
                    , pi_status         IN NUMBER                          
                    , pi_error_message  IN VARCHAR2                        
                    )                                                      
  IS                                                                       
  BEGIN                                                                    
    DBMS_OUTPUT.PUT_LINE                                                   
      ( TO_CHAR( gd_timestamp,'HH:MM:SS.FF MON DD, YYYY' ) ||' ['||        
        pi_log_level ||'] '||                                              
        pi_program_name ||' '||                                            
        pi_error_message                                                   
      );                                                                   
  END prints;                                                              
---------------------------------------------------------------------------
END error_handling;                                                        
/