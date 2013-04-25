/*
 * pipelined.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This creates and tests a pipelined function and it's necessary structures.
 */

SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Create a package specification with only structures to support pipelined functions.
CREATE OR REPLACE PACKAGE pipelining_library IS

  -- Create a record structure.
  TYPE common_lookup_record IS RECORD
  ( common_lookup_id NUMBER
  , common_lookup_type VARCHAR2(30)
  , common_lookup_meaning VARCHAR2(255));

  -- Create a PL/SQL collection type.
  TYPE common_lookup_table IS TABLE OF common_lookup_record;

  END pipelining_library;
/

-- Create a pipelined function for a row of data.
CREATE OR REPLACE FUNCTION get_common_lookup_record_table
( pv_table_name VARCHAR2, pv_column_name VARCHAR2 )
RETURN pipelining_library.common_lookup_table
PIPELINED IS

 -- Declare a local variables.
 lv_counter INTEGER := 1;
 lv_table PIPELINING_LIBRARY.COMMON_LOOKUP_TABLE := pipelining_library.common_lookup_table();

  -- Define a dynamic cursor that takes two formal parameters.
  CURSOR c (table_name_in VARCHAR2, table_column_name_in VARCHAR2) IS
    SELECT common_lookup_id
    , common_lookup_type
    , common_lookup_meaning
    FROM common_lookup
    WHERE common_lookup_table = UPPER(table_name_in)
    AND common_lookup_column = UPPER(table_column_name_in);

BEGIN
  FOR i IN c (pv_table_name, pv_column_name) LOOP
    lv_table.EXTEND;
    lv_table(lv_counter) := i;
    PIPE ROW(lv_table(lv_counter));
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

COLUMN common_lookup_id FORMAT 9999 HEADING "ID"
COLUMN common_lookup_type FORMAT A16 HEADING "Lookup Type"
COLUMN common_lookup_meaning FORMAT A30 HEADING "Lookup Meaning"

-- Query the values from the table.
SELECT *
FROM TABLE(get_common_lookup_record_table('ITEM','ITEM_TYPE'));

-- Showing how to leverage a pipelined function return in a PL/SQL context.
DECLARE
  CURSOR cv_sample IS
    SELECT *
    FROM TABLE(get_common_lookup_record_table('ITEM','ITEM_TYPE'));
BEGIN
  FOR i IN cv_sample LOOP
    dbms_output.put('['||i.common_lookup_id||']');
    dbms_output.put('['||i.common_lookup_type||']');
    dbms_output.put_line('['||i.common_lookup_meaning||']');
  END LOOP;
END;
/