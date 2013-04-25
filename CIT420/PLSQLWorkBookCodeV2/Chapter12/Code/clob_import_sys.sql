/*
 * clob_import_sys.sql
 * Chapter 12, Oracle Database 11g PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script requires you to run it as the privileged
 * SYS user.
 * 
 * It must run before the following scripts:
 *
 *   1. clob_import_system.sql
 *   2. clob_import_plsql.sql
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Conditionally drop virtual directories.
BEGIN
  DBMS_JAVA.GRANT_PERMISSION('PLSQL'
                             ,'SYS:java.io.FilePermission'
                             ,'C:\WINDOWS\TEMP'
                             ,'read');
  END;
/