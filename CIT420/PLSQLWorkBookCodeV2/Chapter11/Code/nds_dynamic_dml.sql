/*
 * nds_dynamic_dml.sql
 * Chapter 11, Oracle Database 11g PL/SQL Workbook
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

  stmt VARCHAR2(2000);

BEGIN
  stmt := 'INSERT INTO common_lookup '
       || ' VALUES '
       || '( common_lookup_s1.nextval '
       || ',:lookup_table '
       || ',:lookup_column '
       || ',:lookup_type '
       || ',:lookup_code '
       || ',:lookup_meaning '
       || ', 3, SYSDATE, 3, SYSDATE)';

  EXECUTE IMMEDIATE stmt
  USING lookup_table, lookup_column, lookup_type, lookup_code, lookup_meaning;

END insert_lookup;
/

DELETE FROM common_lookup
WHERE common_lookup_type = 'CROSS_REFERENCE';

BEGIN
  insert_lookup(table_name => 'COMMON_LOOKUP'
               ,lookup_table => 'CATALOG'
               ,lookup_column => 'CATALOG_TYPE'
               ,lookup_type => 'CROSS_REFERENCE'
               ,lookup_meaning => 'Cross Reference');
END;
/
