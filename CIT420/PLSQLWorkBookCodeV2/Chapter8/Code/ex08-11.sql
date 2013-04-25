-- ex08-11.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Wrapping Package Bodies
---------------------------------------------------------------------------
ALTER TABLE video_store.member                         
  ADD     ( credit_card_last4 varchar2(20))            
/                                                      
ALTER TABLE video_store.member               
  MODIFY ( credit_card_number varchar2(250) )
/                                            
CREATE OR REPLACE PACKAGE                           
  video_store.encryption                            
  AUTHID CURRENT_USER                               
  AS                                                
                                                    
  PROCEDURE cc_encrypt  ( pi_key        in  varchar2
                        , pi_clear_txt  in  varchar2
                        , po_encrypted  out varchar2
                        );                          
END encryption;                                     
/                                                   
CREATE OR REPLACE PACKAGE body video_store.encryption                     
  AS                                                                      
  PROCEDURE cc_encrypt  ( pi_key        in  varchar2                      
                        , pi_clear_txt  in  varchar2                      
                        , po_encrypted  out varchar2                      
                        )                                                 
  IS                                                                      
    lv_data             varchar2(50);                                     
  BEGIN                                                                   
    lv_data :=  RPAD  ( pi_clear_txt                                      
                      , ( TRUNC ( LENGTH ( pi_clear_txt ) / 8 ) +  1 ) * 8
                      ,   CHR(0) );                                       
                                                                          
    DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT ( input_string     => lv_data     
                                        , key_string       => pi_key      
                                        , encrypted_string => po_encrypted
                                        );                                
  END cc_encrypt;                                                         
END encryption;                                                           
/                                                  
  
-- wrap iname=encryption.sql oname=encryption.plb                       
  
SELECT line                 
     , text                 
  FROM all_source           
 WHERE name = 'ENCRYPTION'  
   AND type = 'PACKAGE BODY'
/                           
 
SELECT  member_id         
     ,  credit_card_number
     ,  credit_card_last4 
  FROM  video_store.member
/  