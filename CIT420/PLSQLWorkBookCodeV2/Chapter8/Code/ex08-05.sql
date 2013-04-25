-- ex08-05.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: The Use of Package Specification for Common Configurations
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE encryption_conf                          
  AS                                                               
  PRAGMA SERIALLY_REUSABLE;                                        
  lv_encryption_key#1a    CONSTANT  VARCHAR2(50) := 'NowIsTheTime';
  lv_encryption_key#1b              VARCHAR2(10);                  
END encryption_conf;                                               
/