/*
 * order_comparison.sql
 * Chapter 10, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This builds an object type and body that implements a ORDER
 * MEMBER FUNCTION that returns a NUMBER. It also includes
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
            FROM   user_types
            WHERE  type_name = 'ORDER_SUBCOMP') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE order_subcomp';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_types
            WHERE  type_name = 'ORDER_COMP') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE order_comp';
  END LOOP;
END;
/

CREATE OR REPLACE TYPE order_comp IS OBJECT
( first_name  VARCHAR2(20)
, last_name   VARCHAR2(20)
, CONSTRUCTOR FUNCTION order_comp
  (first_name VARCHAR2
  ,last_name  VARCHAR2)
  RETURN SELF AS RESULT
, MEMBER FUNCTION to_string RETURN VARCHAR2
, ORDER MEMBER FUNCTION equals (object order_comp) RETURN NUMBER )
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY order_comp IS
  
  CONSTRUCTOR FUNCTION order_comp
  (first_name VARCHAR2, last_name VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    self.first_name := first_name;
    self.last_name := last_name;
    RETURN;
  END order_comp;

  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.last_name||', '||self.firsted_name||']';
  END to_string;
  
  ORDER MEMBER FUNCTION equals (object order_comp) RETURN NUMBER IS
  BEGIN
    IF self.last_name < object.last_name THEN
      RETURN 1;
    ELSIF self.last_name = object.last_name AND
          self.first_name < object.first_name THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END equals;
  
END;
/

DECLARE
  TYPE object_list IS TABLE OF ORDER_COMP; -- Define collection.
  
  -- Initialize one subtype.
  lv_object1 ORDER_SUBCOMP := order_subcomp('Severus','Snape','Professor');
  
  -- Initialize objects in mixed order.
  lv_object2 ORDER_COMP := order_comp('Ron','Weasley');
  lv_object3 ORDER_COMP := order_comp('James','Potter');
  lv_object4 ORDER_COMP := order_comp('Luna','Lovegood');
  lv_object5 ORDER_COMP := order_comp('Fred','Weasley');
  lv_object6 ORDER_COMP := order_comp('Hermione','Granger');
  lv_object7 ORDER_COMP := order_comp('Harry','Potter');
  lv_object8 ORDER_COMP := order_comp('Cedric','Diggory');
  lv_object9 ORDER_COMP := order_comp('Ginny','Weasley');

  -- Declare a collection.
  lv_objects OBJECT_LIST := object_list(lv_object1, lv_object2
                                       ,lv_object3, lv_object4
                                       ,lv_object5, lv_object6
                                       ,lv_object7, lv_object8
                                       ,lv_object9);

  -- Swaps A and B by reference.
  PROCEDURE swap (pv_a IN OUT ORDER_COMP, pv_b IN OUT ORDER_COMP) IS
    lv_c ORDER_COMP;
  BEGIN
    lv_c := pv_b;
    pv_b := pv_a;
    pv_a := lv_c;
  END swap;
  
BEGIN
  FOR i IN 1..lv_objects.COUNT LOOP          -- Bubble sort.
    FOR j IN 1..lv_objects.COUNT LOOP
      IF lv_objects(i).equals(lv_objects(j)) = 1 THEN
        swap(lv_objects(i),lv_objects(j));
      END IF;
    END LOOP;
  END LOOP;

  FOR i IN 1..lv_objects.COUNT LOOP          -- Print reordered records.
    dbms_output.put_line(lv_objects(i).to_string);
  END LOOP;
END;
/

CREATE OR REPLACE TYPE order_subcomp UNDER order_comp
( salutation  VARCHAR2(20)
, CONSTRUCTOR FUNCTION order_subcomp
  (first_name  VARCHAR2
  ,last_name   VARCHAR2
  ,salutation  VARCHAR2)
  RETURN SELF AS RESULT
, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY order_subcomp IS
  
  CONSTRUCTOR FUNCTION order_subcomp
  (first_name  VARCHAR2
  ,last_name   VARCHAR2
  ,salutation  VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.first_name := first_name;
    self.last_name := last_name;
    self.salutation := salutation;
    RETURN;
  END order_subcomp;

  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN (self as order_comp).to_string||', '||self.salutation;
  END to_string;
   
END;
/

DECLARE
  TYPE object_list IS TABLE OF ORDER_COMP; -- Define collection.
  
  -- Initialize one subtype.
  lv_object1 ORDER_SUBCOMP :=
    order_subcomp('Severus','Snape','Professor');
  
  -- Initialize objects in mixed order.
  lv_object2 ORDER_COMP := order_comp('Ron','Weasley');
  lv_object3 ORDER_COMP := order_comp('James','Potter');
  lv_object4 ORDER_COMP := order_comp('Luna','Lovegood');
  lv_object5 ORDER_COMP := order_comp('Fred','Weasley');
  lv_object6 ORDER_COMP := order_comp('Hermione','Granger');
  lv_object7 ORDER_COMP := order_comp('Harry','Potter');
  lv_object8 ORDER_COMP := order_comp('Cedric','Diggory');
  lv_object9 ORDER_COMP := order_comp('Ginny','Weasley');

  -- Declare a collection.
  lv_objects OBJECT_LIST := object_list(lv_object1, lv_object2
                                       ,lv_object3, lv_object4
                                       ,lv_object5, lv_object6
                                       ,lv_object7, lv_object8
                                       ,lv_object9);

  -- Swaps A and B by reference.
  PROCEDURE swap (pv_a IN OUT ORDER_COMP, pv_b IN OUT ORDER_COMP) IS
    lv_c ORDER_COMP;
  BEGIN
    lv_c := pv_b;
    pv_b := pv_a;
    pv_a := lv_c;
  END swap;
  
BEGIN
  FOR i IN 1..lv_objects.COUNT LOOP          -- Bubble sort.
    FOR j IN 1..lv_objects.COUNT LOOP
      IF lv_objects(i).equals(lv_objects(j)) = 1 THEN
        swap(lv_objects(i),lv_objects(j));
      END IF;
    END LOOP;
  END LOOP;

  FOR i IN 1..lv_objects.COUNT LOOP          -- Print reordered records.
    dbms_output.put_line(lv_objects(i).to_string);
  END LOOP;
END;
/