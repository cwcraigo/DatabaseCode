/*
 * nds_dynamic_types.sql
 * Chapter 11, Oracle Database PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script NDS using placeholders or bind variables to 
 * return values from a query.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  TYPE lookup_record IS RECORD           -- Record structure
  ( lookup_type     VARCHAR2(30)
  , lookup_code     VARCHAR2(5)
  , lookup_meaning  VARCHAR2(255));

  lookup_cursor     SYS_REFCURSOR;
  lookup_row        LOOKUP_RECORD;
  stmt              VARCHAR2(2000);
BEGIN
  stmt := 'SELECT  common_lookup_type '
       || ',       common_lookup_code '
       || ',       common_lookup_meaning '
       || 'FROM    common_lookup '
       || 'WHERE   REGEXP_LIKE(common_lookup_type,:input)';
  
  OPEN lookup_cursor FOR stmt USING '(CR|D)E(D|B)IT';
  LOOP
    FETCH lookup_cursor INTO lookup_row;
    EXIT WHEN lookup_cursor%NOTFOUND;
    dbms_output.put_line(
      '['||lookup_row.lookup_type||']['||lookup_row.lookup_code||']');
  END LOOP;
  CLOSE lookup_cursor;
END;
/

CREATE OR REPLACE TYPE lookup_record IS OBJECT
  ( lookup_type     VARCHAR2(30)
  , lookup_code     VARCHAR2(5)
  , lookup_meaning  VARCHAR2(255));
/

CREATE OR REPLACE PACKAGE lib IS
  TYPE lookup_record IS RECORD
  ( lookup_type     VARCHAR2(30)
  , lookup_code     VARCHAR2(5)
  , lookup_meaning  VARCHAR2(255));

  TYPE lookup_assoc_table IS TABLE OF lookup_record
  INDEX BY BINARY_INTEGER;

  TYPE lookup_table IS TABLE OF lookup_record;
  
END lib;
/

CREATE OR REPLACE PROCEDURE set_dynamic_table
( pv_lookup_type  IN     VARCHAR2
, pv_lookup_table IN OUT lib.LOOKUP_ASSOC_TABLE ) IS
  lv_counter           NUMBER := 1;
  lv_lookup_cursor     SYS_REFCURSOR;
  lv_lookup_row        lib.LOOKUP_RECORD;
  lv_stmt              VARCHAR2(2000);
BEGIN
  lv_stmt := 'SELECT  common_lookup_type '
          || ',       common_lookup_code '
          || ',       common_lookup_meaning '
          || 'FROM    common_lookup '
          || 'WHERE   REGEXP_LIKE(common_lookup_type,:input)';
  
  OPEN lv_lookup_cursor FOR lv_stmt USING pv_lookup_type;
  LOOP
    FETCH lv_lookup_cursor INTO lv_lookup_row;
    EXIT WHEN lv_lookup_cursor%NOTFOUND;
    pv_lookup_table(lv_counter) := lv_lookup_row;
    lv_counter := lv_counter + 1;
  END LOOP;
  CLOSE lv_lookup_cursor;
END set_dynamic_table;
/

CREATE OR REPLACE PROCEDURE set_dynamic_table
( pv_lookup_type  IN     VARCHAR2
, pv_lookup_table IN OUT lib.LOOKUP_ASSOC_TABLE ) IS
  lv_lookup_cursor     SYS_REFCURSOR;
  lv_stmt              VARCHAR2(2000);
BEGIN
  lv_stmt := 'SELECT  common_lookup_type '
          || ',       common_lookup_code '
          || ',       common_lookup_meaning '
          || 'FROM    common_lookup '
          || 'WHERE   REGEXP_LIKE(common_lookup_type,:input)';
  
  OPEN lv_lookup_cursor FOR lv_stmt USING pv_lookup_type;
  FETCH lv_lookup_cursor BULK COLLECT INTO pv_lookup_table;
  CLOSE lv_lookup_cursor;
  dbms_output.put_line('This two');
END set_dynamic_table;
/

show errors

CREATE OR REPLACE FUNCTION get_dynamic_table
( pv_lookup_type VARCHAR2 ) RETURN lib.lookup_table
PIPELINED IS
  lv_lookup_cursor     SYS_REFCURSOR;
  lv_lookup_row        lib.LOOKUP_RECORD;
  lv_lookup_assoc      lib.LOOKUP_ASSOC_TABLE;
  lv_lookup_table      lib.LOOKUP_TABLE := lib.lookup_table();
  lv_stmt              VARCHAR2(2000);
BEGIN
  set_dynamic_table(pv_lookup_type, lv_lookup_assoc);  
  FOR i IN 1..lv_lookup_assoc.COUNT LOOP
    lv_lookup_table.EXTEND;
    lv_lookup_table(i) := lv_lookup_assoc(i);
    PIPE ROW(lv_lookup_table(i));
  END LOOP;
  RETURN;
END get_dynamic_table;
/
set echo on
COLUMN lookup_type    FORMAT A12
COLUMN lookup_code    FORMAT A12
COLUMN lookup_meaning FORMAT A14

SELECT *
FROM TABLE(get_dynamic_table('(CR|D)E(D|B)IT'));

DROP FUNCTION get_dynamic_obj_table;
DROP TYPE lookup_list;
DROP TYPE lookup_set;

CREATE OR REPLACE TYPE lookup_set IS OBJECT
( common_lookup_type    VARCHAR2(30)
, common_lookup_code    VARCHAR2(5)
, common_lookup_meaning VARCHAR2(255));
/

CREATE OR REPLACE TYPE lookup_list IS TABLE OF lookup_set;
/

CREATE OR REPLACE FUNCTION get_dynamic_obj_table
( pv_lookup_type  IN      VARCHAR2 ) RETURN lookup_list IS
  lv_lookup_cursor        SYS_REFCURSOR;
  lv_lookup_list          LOOKUP_LIST := lookup_list();
  lv_stmt                 VARCHAR2(2000);
BEGIN
  lv_stmt := 'SELECT  common_lookup_type '
          || ',       common_lookup_code '
          || ',       common_lookup_meaning '
          || 'FROM    common_lookup '
          || 'WHERE   REGEXP_LIKE(common_lookup_type,:input)';
  
  OPEN lv_lookup_cursor FOR lv_stmt USING pv_lookup_type;
  FETCH lv_lookup_cursor BULK COLLECT INTO lv_lookup_list;
  CLOSE lv_lookup_cursor;
  RETURN lv_lookup_list;
END get_dynamic_obj_table;
/

SELECT *
FROM TABLE(get_dynamic_obj_table('(CR|D)E(D|B)IT'));
