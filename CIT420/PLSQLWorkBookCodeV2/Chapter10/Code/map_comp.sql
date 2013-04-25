/*
 * map_comparison.sql
 * Chapter 10, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This builds an object type and body that implements a MAP
 * MEMBER FUNCTION that returns a VARCHAR2. It also includes
 * a test program.
 */

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'PERSISTENT_OBJECT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE persistent_object CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'PERSISTENT_OBJECT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE persistent_object_s1';
  END LOOP;
END;
/

CREATE OR REPLACE TYPE map_comp IS OBJECT
( who VARCHAR2(30)
, CONSTRUCTOR FUNCTION map_comp (who VARCHAR2) RETURN SELF AS RESULT
, MAP MEMBER FUNCTION equals RETURN VARCHAR2 )
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY map_comp IS
  CONSTRUCTOR FUNCTION map_comp (who VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    self.who := who;
    RETURN;
  END map_comp;
  MAP MEMBER FUNCTION equals RETURN VARCHAR2 IS
  BEGIN
    RETURN self.who;
  END equals;
END;
/

DECLARE
  TYPE object_list IS TABLE OF MAP_COMP; -- Define a collection

  -- Initialize object instances in jumbled order.
  lv_object1 MAP_COMP := map_comp('Ron Weasley');
  lv_object2 MAP_COMP := map_comp('Harry Potter');
  lv_object3 MAP_COMP := map_comp('Luna Lovegood');
  lv_object4 MAP_COMP := map_comp('Ginny Weasley');
  lv_object5 MAP_COMP := map_comp('Hermione Granger');
  
  -- Declare a collection.
  lv_objects OBJECT_LIST := object_list(lv_object1, lv_object2
                                       ,lv_object3, lv_object4
                                       ,lv_object5);
  
  -- Swaps A and B by reference.
  PROCEDURE swap (pv_a IN OUT MAP_COMP, pv_b IN OUT MAP_COMP) IS
    lv_c MAP_COMP;
  BEGIN
    lv_c := pv_b;
    pv_b := pv_a;
    pv_a := lv_c;
  END swap;
  
BEGIN
  FOR i IN 1..lv_objects.COUNT LOOP     -- Bubble sort
    FOR j IN 1..lv_objects.COUNT LOOP
      IF lv_objects(i).equals =
  	    LEAST(lv_objects(i).equals,lv_objects(j).equals) THEN
        swap(lv_objects(i),lv_objects(j));
      END IF;
    END LOOP;
  END LOOP;

  FOR i IN 1..lv_objects.COUNT LOOP     -- Print reordered set.
    dbms_output.put_line(lv_objects(i).equals);
  END LOOP;
END;
/

CREATE TABLE persistent_object
( persistent_object_id NUMBER
, mapping_object       MAP_COMP );

CREATE SEQUENCE persistent_object_s1;

-- Insert instances of objects.
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Frodo Baggins'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Sam "Wise" Gamgee'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Meriadoc Brandybuck'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Perigrin Took'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Legolas son of Thranduil'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Aragorn son of Arathorn'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Boromir son of Denthor'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Gandolf the Gray'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Gimli the Drawf'));

COLUMN primary_key FORMAT 9999999 HEADING "Primary|Key ID"
COLUMN fellowship  FORMAT A30     HEADING "Fellowship Member"

SELECT   persistent_object_id AS primary_key
,        TREAT(mapping_object AS map_comp).equals() AS fellowship
FROM     persistent_object
WHERE    mapping_object IS OF (map_comp)
ORDER BY 2;
