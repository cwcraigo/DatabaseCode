/*
 * result_cache.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This creates and tests a result_cache function and it's necessary structures.
 * This only works in Oracle 11g forward.
 */

SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION get_common_lookup
( table_name VARCHAR2, column_name VARCHAR2 ) RETURN LOOKUP
RESULT_CACHE RELIES_ON(common_lookup) IS
  -- A local variable of the user-defined scalar collection type.
  lookups LOOKUP;

  -- A cursor to concatenate the columns into one string with a delimiter.
  CURSOR c (table_name_in VARCHAR2, table_column_name_in VARCHAR2) IS
    SELECT common_lookup_id||'|'
    || common_lookup_type||'|'
    || common_lookup_meaning
    FROM common_lookup
    WHERE common_lookup_table = UPPER(table_name_in)
    AND common_lookup_column = UPPER(table_column_name_in);
BEGIN
  OPEN c(table_name, column_name);
  LOOP
    FETCH c BULK COLLECT INTO lookups;
    EXIT WHEN c%NOTFOUND;
  END LOOP;
  RETURN lookups;
END get_common_lookup;
/