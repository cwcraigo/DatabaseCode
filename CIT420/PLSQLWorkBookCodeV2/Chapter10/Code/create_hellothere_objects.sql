/*
 * create_hellothere_objects.sql
 * Chapter 10, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This builds an object type and body, then a test program.
 */

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

BEGIN
  FOR i IN (SELECT type_name
            FROM   user_types
            WHERE  type_name IN ('HELLO_THERE')) LOOP
    EXECUTE IMMEDIATE 'DROP TYPE '||i.type_name;
  END LOOP;
END;
/

CREATE OR REPLACE TYPE hello_there IS OBJECT
( iv_who VARCHAR2(20)
, CONSTRUCTOR FUNCTION hello_there
  RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION hello_there
  ( iv_who VARCHAR2 )
  RETURN SELF AS RESULT
, MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY hello_there IS
  
  CONSTRUCTOR FUNCTION hello_there
  RETURN SELF AS RESULT IS
    hello HELLO_THERE := hello_there('Generic Object.');
  BEGIN
    self := hello;
    RETURN;
  END hello_there;
  
  CONSTRUCTOR FUNCTION hello_there (iv_who VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.iv_who := iv_who;
    RETURN;
  END hello_there;
  
  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Hello '||self.iv_who;
  END to_string;
  
END;
/

CREATE OR REPLACE TYPE hello_there IS OBJECT
( iv_who VARCHAR2(20)
, CONSTRUCTOR FUNCTION hello_there
  RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION hello_there
  ( iv_who VARCHAR2 )
  RETURN SELF AS RESULT
, MEMBER FUNCTION get_who RETURN VARCHAR2
, MEMBER PROCEDURE set_who (pv_who VARCHAR2)
, MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY hello_there IS
  
  CONSTRUCTOR FUNCTION hello_there
  RETURN SELF AS RESULT IS
    hello HELLO_THERE := hello_there('Generic Object.');
  BEGIN
    self := hello;
    RETURN;
  END hello_there;
  
  CONSTRUCTOR FUNCTION hello_there (iv_who VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.iv_who := iv_who;
    RETURN;
  END hello_there;

  MEMBER FUNCTION get_who RETURN VARCHAR2 IS
  BEGIN
    RETURN self.iv_who;
  END get_who;

  MEMBER PROCEDURE set_who (pv_who VARCHAR2) IS
  BEGIN
    self.iv_who := pv_who;
  END set_who;
  
  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Hello '||self.iv_who;
  END to_string;
  
END;
/