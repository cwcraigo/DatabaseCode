/*
 * dbms_sql_query.sql
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

DECLARE
  -- The traditional DBMS_SQL variables.
  c           INTEGER := dbms_sql.open_cursor;
  fdbk        INTEGER;
  stmt        VARCHAR2(2000);
  
  -- Local variables.
  lv_lookup_id     NUMBER;
  lv_lookup_type   VARCHAR2(30) := 'DEBIT';
  lv_lookup_code   VARCHAR2(30);
  
BEGIN
  -- Create dynamic statement with placeholder.
  stmt := 'SELECT common_lookup_id '
       || ',      common_lookup_code '
       || 'FROM   common_lookup '
       || 'WHERE  common_lookup_type = :lookup_type';

  -- Parse the statement.
  dbms_sql.parse(c,stmt,dbms_sql.native);
  
  -- Define query return columns.
  dbms_sql.define_column(c,1,lv_lookup_id);
  dbms_sql.define_column(c,2,lv_lookup_code,5);
  
  -- Bind a local variable to a placeholder.
  dbms_sql.bind_variable(c,'lookup_type',lv_lookup_type); 

  -- Assign output values when execute and fetch works.
  IF dbms_sql.execute_and_fetch(c) = 1 THEN  
    -- Assign query outputs to local variables.
    dbms_sql.column_value(c,1,lv_lookup_id);
    dbms_sql.column_value(c,2,lv_lookup_code);
  END IF;
  
  -- Close open cursor.
  dbms_sql.close_cursor(c);

  -- Print the output retrieved.  
  dbms_output.put_line('['||lv_lookup_id||']['||lv_lookup_code||']');
END;
/

DECLARE
  -- The traditional DBMS_SQL variables.
  c           INTEGER := dbms_sql.open_cursor;
  fdbk        INTEGER;
  stmt        VARCHAR2(2000);
  
  -- Local variables.
  lv_lookup_id     NUMBER;
  lv_lookup_type   VARCHAR2(30) := '(CR|D)E(D|B)IT';
  lv_lookup_code   VARCHAR2(30);
  
BEGIN
  -- Create dynamic statement with placeholder.
  stmt := 'SELECT common_lookup_id '
       || ',      common_lookup_code '
       || 'FROM   common_lookup '
       || 'WHERE  REGEXP_LIKE(common_lookup_type,:lookup_type)';

  -- Parse the statement.
  dbms_sql.parse(c,stmt,dbms_sql.native);
  
  -- Define query return columns.
  dbms_sql.define_column(c,1,lv_lookup_id);
  dbms_sql.define_column(c,2,lv_lookup_code,5);
  
  -- Bind a local variable to a placeholder.
  dbms_sql.bind_variable(c,'lookup_type',lv_lookup_type); 

  -- Assign output values when execute and fetch works.
  IF dbms_sql.execute(c) = 0 THEN
    LOOP
      -- Exit when no more rows found.
      EXIT WHEN dbms_sql.fetch_rows(c) = 0;
      
      -- Assign query outputs to local variables.
      dbms_sql.column_value(c,1,lv_lookup_id);
      dbms_sql.column_value(c,2,lv_lookup_code);
      
      -- Print the output retrieved.  
      dbms_output.put_line('['||lv_lookup_id||']['||lv_lookup_code||']');
    END LOOP;
  END IF;
  
  -- Close open cursor.
  dbms_sql.close_cursor(c);

END;
/
 