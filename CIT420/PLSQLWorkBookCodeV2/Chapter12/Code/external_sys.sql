/*
 * external_sys.sql
 * Chapter 12, Oracle Database PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script requires you to run it as the privileged
 * SYS user, please connect like this or have your DBA
 * do so:
 *
 *   C:\Data> sqlplus sys as sysdba
 * 
 * It must run before the following scripts:
 *
 *   1. create_external_system.sql
 *   2. create_external_plsql.sql
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Grant SELECT privileges on restricted VIEWS.
-- The SYSTEM user has access through a ROLE but can't reference them
-- without an explicit grant of SELECT privilege.
GRANT SELECT ON v_$database TO SYSTEM;
GRANT SELECT ON dba_directories TO SYSTEM;

-- Provide external privileges to the internal Java permission file.
BEGIN
  DBMS_JAVA.GRANT_PERMISSION('PLSQL'
                            ,'SYS:java.io.FilePermission'
                            ,'C:\upload\source'
                            ,'read,write,delete');
END;
/
