/*
 * deterministic.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This creates and tests a deterministic function.
 */

SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Create deterministic PV function.
CREATE OR REPLACE FUNCTION pv
( future_value NUMBER
, periods NUMBER
, interest NUMBER )
RETURN NUMBER DETERMINISTIC IS
BEGIN
  RETURN future_value / ((1 + interest/100)**periods);
END pv;
/

-- Call this program with the CALL method like this:
VARIABLE result NUMBER
CALL pv(10000,5,6) INTO :result;
COLUMN money_today FORMAT 99,999.90
SELECT :result AS money_today FROM dual;

-- Alternative query data as input values
WITH data_set AS
( SELECT 235000 AS principal
, 30 AS years
, 5.875 AS interest
FROM dual )
SELECT pv(principal,years,interest) AS money_today
FROM data_set;
