/*
 * parallel.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This creates and tests a parallel function.
 */

SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Creates the parallel enabled MERGE function.
CREATE OR REPLACE FUNCTION merge
( last_name VARCHAR2
, first_name VARCHAR2
, middle_name VARCHAR2 )
RETURN VARCHAR2 PARALLEL_ENABLE IS
BEGIN
RETURN last_name ||', '||first_name||' '||middle_name;
END;
/

-- Tests the parallel enabled function.
SELECT merge(c.last_name, c.first_name, c.middle_name) AS customer
FROM contact c;