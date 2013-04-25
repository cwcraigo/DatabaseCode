-- ex08-10.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Creation of Two Overloaded Functions                           
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE                              
  number_converter                                     
  AS                                                   
  FUNCTION translated ( pi_number_value IN VARCHAR2 )  
  RETURN VARCHAR2;                                     
                                                       
  FUNCTION translated ( pi_number_value IN NUMBER )    
  RETURN VARCHAR2;                                     
END number_converter;                                  
/

 CREATE OR REPLACE PACKAGE BODY
  number_converter
  AS
---------------------------------------------------------------------------
  FUNCTION translated ( pi_number_value IN VARCHAR2 )
  RETURN VARCHAR2
  IS
    lv_string       VARCHAR2(250);
    ln_number       NUMBER;
    lv_hex          VARCHAR2(50) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  BEGIN
    IF pi_number_value < 0
    OR pi_number_value IS NULL
    THEN
      RAISE PROGRAM_ERROR;
    END IF;

    ln_number := pi_number_value;

    WHILE ln_number > 0 LOOP
      lv_string := SUBSTR ( lv_hex, MOD ( ln_number, 2 ) + 1, 1 )||
                   lv_string;
      ln_number := TRUNC ( ln_number / 2 );
    END LOOP;

    RETURN lv_string;
  END translated;
---------------------------------------------------------------------------
  FUNCTION translated ( pi_number_value IN NUMBER )
  RETURN VARCHAR2
  IS
    lv_string       VARCHAR2(250);
    ln_number       NUMBER;
    lv_hex          VARCHAR2(50) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  BEGIN
    IF pi_number_value < 0
    OR pi_number_value IS NULL
    THEN
      RAISE PROGRAM_ERROR;
    END IF;

    ln_number := pi_number_value;

    WHILE ln_number > 0 LOOP
      lv_string := SUBSTR ( lv_hex, MOD ( ln_number, 10 ) + 1, 1 )||
                   lv_string;
      ln_number := TRUNC ( ln_number / 10 );
    END LOOP;

    RETURN lv_string;
  END translated;
---------------------------------------------------------------------------
END number_converter;
/

SELECT  number_converter.translated ( '1234567890' ) base2
     ,  number_converter.translated (  1234567890  ) base10
  FROM  dual
/