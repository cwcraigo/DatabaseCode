/*
 * clob_import_system.sql
 * Chapter 12, Oracle Database 11g PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script requires you to run it as the privileged
 * SYSTEM user.
 * 
 * It must run before the following scripts:
 *
 *   1. clob_import_plsql.sql
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Conditionally drop virtual directories.
BEGIN
  FOR i IN (SELECT directory_name
            FROM   sys.dba_directories
            WHERE  directory_name IN ('GENERIC')) LOOP
    EXECUTE IMMEDIATE 'DROP DIRECTORY '||i.directory_name;
  END LOOP;
END;
/

-- Create virtual directories.
CREATE DIRECTORY generic AS 'C:\windows\temp';

-- Grant read permissions to PL/SQL
GRANT READ ON DIRECTORY generic TO plsql;
