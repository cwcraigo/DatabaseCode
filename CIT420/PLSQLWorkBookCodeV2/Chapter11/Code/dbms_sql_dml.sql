/*
 * dbms_sql_dml.sql
 * Chapter 11, Oracle Database PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script NDS gluing strings together.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE insert_lookup
( table_name     VARCHAR2
, lookup_table   VARCHAR2
, lookup_column  VARCHAR2
, lookup_type    VARCHAR2
, lookup_code    VARCHAR2 := ''
, lookup_meaning VARCHAR2 ) IS

  -- Required variables for DBMS_SQL execution.
  c    INTEGER := dbms_sql.open_cursor;
  fdbk INTEGER;
  stmt VARCHAR2(2000);

BEGIN
  stmt := 'INSERT INTO '||dbms_assert.simple_sql_name(table_name)
       || ' VALUES '
       || '( common_lookup_s1.nextval '
       || ',:lookup_table '
       || ',:lookup_column '
       || ',:lookup_type '
       || ',:lookup_code '
       || ',:lookup_meaning '
       || ', 3, SYSDATE, 3, SYSDATE)';

  -- Parse the statement and assign it to a cursor.
  dbms_sql.parse(c,stmt,dbms_sql.native);
  
  -- Bind local scope variables to placeholders in the statement.
  dbms_sql.bind_variable(c,'lookup_table',lookup_table);
  dbms_sql.bind_variable(c,'lookup_column',lookup_column);
  dbms_sql.bind_variable(c,'lookup_type',lookup_type);
  dbms_sql.bind_variable(c,'lookup_code',lookup_code);
  dbms_sql.bind_variable(c,'lookup_meaning',lookup_meaning);
  
  -- Execute and close the cursor.
  fdbk := dbms_sql.execute(c);
  dbms_sql.close_cursor(c);

  -- Conditionally commit the record.  
  IF fdbk = 1 THEN
    COMMIT;
  END IF;
END insert_lookup;
/

show errors
BEGIN
  insert_lookup(table_name => 'COMMON_LOOKUP'
               ,lookup_table => 'CATALOG'
               ,lookup_column => 'CATALOG_TYPE'
               ,lookup_type => 'PAPERBACK_BINDING'
               ,lookup_meaning => 'Paperback Binding');
END;
/
