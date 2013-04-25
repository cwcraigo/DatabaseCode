/*
 * create_item_object.sql
 * Chapter 7, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This builds and demonstrates object types and tables of object types as
 * collections in PL/SQL, while also demonstrating SQL and PL/SQL context
 * limits.
 */

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON
COLUMN statement FORMAT A79

-- Conditionally drop functions causing dependencies.
BEGIN
  FOR i IN (SELECT   object_name
            FROM     user_objects
            WHERE    object_name IN ('GET_OBJECT_TABLE','PROCESS_COLLECTION')
            AND      object_type = 'FUNCTION'
            ORDER BY 1 DESC) LOOP
    EXECUTE IMMEDIATE 'DROP FUNCTION '||i.object_name;
  END LOOP;
END;
/

-- Unconditionally drop types.
DROP TYPE common_lookup_object_table;
DROP TYPE common_lookup_object;

-- Create or replace COMMON_LOOKUP_OBJECT.
CREATE OR REPLACE TYPE common_lookup_object IS OBJECT
( lookup_id      NUMBER
, lookup_type    VARCHAR2(30)
, lookup_meaning VARCHAR2(255));
/

-- Create or replace COMMON_LOOKUP_OBJECT_TABLE collection.
CREATE OR REPLACE TYPE common_lookup_object_table
IS TABLE OF common_lookup_object;
/

-- Create or replace GET_OBJECT_TABLE functions.
CREATE OR REPLACE FUNCTION get_object_table
( pv_table_name  VARCHAR2
, pv_column_name VARCHAR2 )
RETURN common_lookup_object_table IS
  -- Define a dynamic cursor that takes two formal parameters.
  CURSOR c (table_name_in VARCHAR2, table_column_name_in VARCHAR2) IS
    SELECT   common_lookup_id AS lookup_id
    ,        common_lookup_type AS lookup_type
    ,        common_lookup_meaning AS lookup_meaning
    FROM     common_lookup
    WHERE    common_lookup_table = UPPER(table_name_in)
    AND      common_lookup_column = UPPER(table_column_name_in);
    -- Declare a counter variable.
  lv_counter INTEGER := 1;
  -- Declare a collection data type as a SQL scope table return type.
  lv_list COMMON_LOOKUP_OBJECT_TABLE := common_lookup_object_table();
BEGIN
  -- Assign the cursor return values to a record collection.
  FOR i IN c(pv_table_name, pv_column_name) LOOP
    lv_list.extend;
    lv_list(lv_counter) := common_lookup_object(i.lookup_id
                                               ,i.lookup_type
                                               ,i.lookup_meaning);
    lv_counter := lv_counter + 1;
  END LOOP;
  -- Return the record collection.
  RETURN lv_list;
END get_object_table;
/

COLUMN common_lookup_id      FORMAT 9999 HEADING "ID"
COLUMN common_lookup_type    FORMAT A16  HEADING "Lookup Type"
COLUMN common_lookup_meaning FORMAT A30  HEADING "Lookup Meaning"

-- Query GET_OBJECT_TABLE collection from GET_OBJECT_TABLE function.
SELECT 'Test select of object type table.' AS "Statement Processed" FROM dual;
SELECT   *
FROM     TABLE(get_object_table('ITEM','ITEM_TYPE'));

-- Create or replace PROCESS_COLLECTION function.
CREATE OR REPLACE FUNCTION process_collection
( pv_composite_coll COMMON_LOOKUP_OBJECT_TABLE )
RETURN SYS_REFCURSOR IS
  lv_sample_set SYS_REFCURSOR;
BEGIN
  OPEN lv_sample_set FOR
    SELECT * FROM TABLE(pv_composite_coll);
  RETURN lv_sample_set;
END;
/

-- Query PROCESS_COLLECTION function, which is a weakly typed cursor from an object type table.
SELECT 'Select of weakly typed cursor from object type table.' AS "Statement Processed" FROM dual;
SELECT process_collection(get_object_table('ITEM','ITEM_TYPE'))
FROM dual;

-- Create or replace package specification with data types.
CREATE OR REPLACE PACKAGE sample IS
  TYPE plsql_table IS TABLE OF common_lookup_object;
END sample;
/

-- Create or replace GET_PLSAL_TABLE function.
CREATE OR REPLACE FUNCTION get_plsql_table
( pv_table_name  VARCHAR2
, pv_column_name VARCHAR2 )
RETURN sample.plsql_table IS
  -- Define a dynamic cursor that takes two formal parameters.
  CURSOR c (table_name_in VARCHAR2, table_column_name_in VARCHAR2) IS
    SELECT   common_lookup_id AS lookup_id
    ,        common_lookup_type AS lookup_type
    ,        common_lookup_meaning AS lookup_meaning
    FROM     common_lookup
    WHERE    common_lookup_table = UPPER(table_name_in)
    AND      common_lookup_column = UPPER(table_column_name_in);
    -- Declare a counter variable.
  lv_counter INTEGER := 1;
  -- Declare a collection data type as a SQL scope table return type.
  lv_list SAMPLE.PLSQL_TABLE := sample.plsql_table();
BEGIN
  -- Assign the cursor return values to a record collection.
  FOR i IN c(pv_table_name, pv_column_name) LOOP
    lv_list.extend;
    lv_list(lv_counter) := common_lookup_object(i.lookup_id
                                               ,i.lookup_type
                                               ,i.lookup_meaning);
    lv_counter := lv_counter + 1;
  END LOOP;
  -- Return the record collection.
  RETURN lv_list;
END get_plsql_table;
/

-- Query GET_PLSQL_TABLE function, which is an associative array from a PL/SQL record type..
SELECT 'Fails because a PL/SQL record structure can''t be converted to SQL Context.' AS "Statement Processed" FROM dual;
SELECT *
FROM   TABLE(get_plsql_table('ITEM','ITEM_TYPE'));

-- Create or replace PRINT_COLLECTION function.
CREATE OR REPLACE FUNCTION print_collection
( pv_composite_coll SAMPLE.PLSQL_TABLE )
RETURN BOOLEAN IS
  lv_counter NUMBER := 0;
  lv_result  BOOLEAN := FALSE;
BEGIN
  WHILE lv_counter < pv_composite_coll.COUNT LOOP
    lv_counter := lv_counter + 1;
    IF NOT lv_result THEN
      lv_result := TRUE;
    END IF;
    dbms_output.put_line(pv_composite_coll(lv_counter).lookup_meaning);
  END LOOP;
  RETURN lv_result;
END;
/

SET SERVEROUTPUT ON

/* Anonymous block call to get_plsql_table function. */
BEGIN
  IF NOT print_collection(get_plsql_table('ITEM','ITEM_TYPE')) THEN
    dbms_output.put_line('Not populated!');
  END IF;
END;
/

CREATE OR REPLACE PACKAGE sample IS
  TYPE common_lookup_record IS RECORD
  ( lookup_id      NUMBER
  , lookup_type    VARCHAR2(30)
  , lookup_meaning VARCHAR2(255));
  TYPE plsql_table IS TABLE OF common_lookup_record
  INDEX BY PLS_INTEGER;
END sample;
/

SET ECHO ON

-- Create or replace GET_PLSQL_TABLE function.
CREATE OR REPLACE FUNCTION get_plsql_table
( pv_table_name  VARCHAR2
, pv_column_name VARCHAR2 )
RETURN sample.plsql_table IS
  -- Define a dynamic cursor that takes two formal parameters.
  CURSOR c (table_name_in VARCHAR2, table_column_name_in VARCHAR2) IS
    SELECT   common_lookup_id AS lookup_id
    ,        common_lookup_type AS lookup_type
    ,        common_lookup_meaning AS lookup_meaning
    FROM     common_lookup
    WHERE    common_lookup_table = UPPER(table_name_in)
    AND      common_lookup_column = UPPER(table_column_name_in);
    -- Declare a counter variable.
  lv_counter INTEGER := 1;
  -- Declare a collection data type as a PL/SQL scope table return type.
  lv_list SAMPLE.PLSQL_TABLE;
BEGIN
  -- Assign the cursor return values to a record collection.
  FOR i IN c(pv_table_name, pv_column_name) LOOP
    lv_list(lv_counter) := i;
    lv_counter := lv_counter + 1;
  END LOOP;
  -- Return the record collection.
  RETURN lv_list;
END get_plsql_table;
/

-- Create or replace PRINT_COLLECTION function processing a PL/SQL table.
CREATE OR REPLACE FUNCTION print_collection
( pv_composite_coll SAMPLE.PLSQL_TABLE )
RETURN BOOLEAN IS
  lv_counter NUMBER := 0;
  lv_result  BOOLEAN := FALSE;
BEGIN
  WHILE lv_counter < pv_composite_coll.COUNT LOOP
    lv_counter := lv_counter + 1;
    IF NOT lv_result THEN
      lv_result := TRUE;
    END IF;
    dbms_output.put_line(pv_composite_coll(lv_counter).lookup_meaning);
  END LOOP;
  RETURN lv_result;
END;
/

SET SERVEROUTPUT ON

-- Anonymous block to test the wrapper and pipelined table function.
BEGIN
  IF NOT print_collection(get_plsql_table('ITEM','ITEM_TYPE')) THEN
    dbms_output.put_line('Not populated!');
  END IF;
END;
/

CREATE OR REPLACE FUNCTION print_collection
( pv_composite_coll SAMPLE.PLSQL_TABLE )
RETURN NUMBER IS
  lv_counter NUMBER := 0;
  lv_result  NUMBER := 0;
BEGIN
  WHILE lv_counter < pv_composite_coll.COUNT LOOP
    lv_counter := lv_counter + 1;
    IF lv_result = 0 THEN
      lv_result := 1;
    END IF;
    dbms_output.put_line(pv_composite_coll(lv_counter).lookup_meaning);
  END LOOP;
  RETURN lv_result;
END;
/

-- Query GET_PLSQL_TABLE function, which is an associative array from a PL/SQL record type..
SELECT 'Fails because of a PL/SQL call parameter in a SQL Context.' AS "Statement Processed" FROM dual;
SELECT print_collection(get_plsql_table('ITEM','ITEM_TYPE')) FROM dual;