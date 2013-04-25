

-- Create a SQL VARRAY collection of strings.
CREATE OR REPLACE TYPE scalar_varray AS VARRAY(3) OF VARCHAR2(20);
/

-- Test the SQL VARRAY collection in a PL/SQL block.
DECLARE
  lv_coll1 SCALAR_VARRAY := scalar_varray('One','Two','Three');
  lv_coll2 SCALAR_VARRAY := scalar_varray();
BEGIN
  FOR i IN 1..lv_coll1.COUNT LOOP
    lv_coll2.EXTEND; -- Allocates space to the collection.
    lv_coll2(i) := lv_coll1(i); -- Assigns a value.
  END LOOP;
  FOR i IN 1..lv_coll2.count LOOP
    dbms_output.put_line('lv_coll2'||'('||i||'):['||lv_coll2(i)||']');
  END LOOP;
END;
/

-- Create or replace a function returning a collection.
CREATE OR REPLACE FUNCTION get_varray
( pv_one VARCHAR2 := NULL
, pv_two VARCHAR2 := NULL
, pv_three VARCHAR2 := NULL )
RETURN SCALAR_VARRAY IS
  lv_coll SCALAR_VARRAY := scalar_varray();
BEGIN
  FOR i IN 1..3 LOOP
    IF pv_one IS NOT NULL AND i = 1 THEN
      lv_coll.EXTEND;
      lv_coll(i) := pv_one;
    ELSIF pv_two IS NOT NULL AND i <= 2 THEN
      lv_coll.EXTEND;
      lv_coll(i) := pv_two;
    ELSIF pv_three IS NOT NULL THEN
      lv_coll.EXTEND;
      lv_coll(i) := pv_three;
    ELSE
      NULL; -- This can't happen but an ELSE says it wasn't forgotten.
    END IF;
  END LOOP;
  RETURN lv_coll;
END;
/

-- Query a scalar collection from a function that returns a SQL collection.
SELECT column_value
FROM TABLE(filter_varray(get_varray('Eine','Zwei','Drei')));

-- Create a function that receives a SQL collection as a formal parameter.
CREATE OR REPLACE FUNCTION filter_varray
( pv_scalar_varray IN OUT SCALAR_VARRAY)
RETURN BOOLEAN IS
  lv_return BOOLEAN := FALSE;
BEGIN
  pv_scalar_varray.TRIM(1);
  lv_return := TRUE;
RETURN lv_return;
END;
/

-- Anonymous block to test the function with a collection for a formal parameter.
DECLARE
  lv_scalar_varray SCALAR_VARRAY := scalar_varray('Eine','Zwei','Drei');
BEGIN
  IF filter_varray(lv_scalar_varray) THEN
    FOR i IN 1..lv_scalar_varray.LAST LOOP
      dbms_output.put_line('varray'||'('||i||'):'||lv_scalar_varray(i));
    END LOOP;
  END IF;
END;
/

-- Anonymous block to display a PL/SQL VARRAY collection.
DECLARE
  TYPE plsql_varray IS VARRAY(3) OF VARCHAR2(20);
  lv_coll1 PLSQL_VARRAY := plsql_varray('One','Two','Three');
  lv_coll2 PLSQL_VARRAY := plsql_varray();
BEGIN
  lv_coll2.EXTEND(lv_coll1.COUNT); -- Allocates space to the collection.
  FOR i IN 1..lv_coll1.COUNT LOOP
    lv_coll2(i) := lv_coll1(i); -- Assigns values one at a time.
  END LOOP;
  FOR i IN 1..lv_coll2.count LOOP
    dbms_output.put_line('lv_coll2'||'('||i||'):['||lv_coll2(i)||']');
  END LOOP;
END;
/

-- Create a package to hold a PL/SQL collection data type.
CREATE OR REPLACE PACKAGE coll_utility IS
  TYPE plsql_varray IS VARRAY(3) OF VARCHAR2(20);
END;
/

-- Query the data catalog.
COLUMN line FORMAT 999 HEADING "Line"
COLUMN text FORMAT A66 HEADING "Source Code"
SELECT line, text
FROM user_source
WHERE name = 'COLL_UTILITY';

-- Create or replace function that returns a package PL/SQL collection.
CREATE OR REPLACE FUNCTION get_varray
( pv_one VARCHAR2 := NULL
, pv_two VARCHAR2 := NULL
, pv_three VARCHAR2 := NULL )
RETURN COLL_UTILITY.PLSQL_VARRAY IS
  lv_coll COLL_UTILITY.PLSQL_VARRAY := COLL_UTILITY.PLSQL_VARRAY();
BEGIN
    FOR i IN 1..3 LOOP
      IF pv_one IS NOT NULL AND i = 1 THEN
        lv_coll.EXTEND;
        lv_coll(i) := pv_one;
      ELSIF pv_two IS NOT NULL AND i <= 2 THEN
        lv_coll.EXTEND;
        lv_coll(i) := pv_two;
      ELSIF pv_three IS NOT NULL THEN
        lv_coll.EXTEND;
        lv_coll(i) := pv_three;
      ELSE
        NULL; -- Can't ever happen but it wasn't forgotten.
      END IF;
    END LOOP;
  RETURN lv_coll;
END;
/

-- Create a TYPE of a scalar collection.
CREATE OR REPLACE TYPE scalar_varray AS TABLE OF VARCHAR2(20);
/

-- Anonymous block demonstrating an associative array. 
DECLARE
  TYPE plsql_table IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
  lv_coll1 PLSQL_TABLE;
  lv_coll2 PLSQL_TABLE;
BEGIN
  FOR i IN 1..3 LOOP
    lv_coll2(i) := 'This is '||i||'.'; -- Assigns one at a time.
  END LOOP;
  FOR i IN 1..3 LOOP
    dbms_output.put_line('lv_coll2'||'('||i||'):['||lv_coll2(i)||']');
  END LOOP;
END;
/
