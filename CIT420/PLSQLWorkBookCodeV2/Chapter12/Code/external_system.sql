/*
 * external_system.sql
 * Chapter 12, Oracle Database PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script requires you to run it as the privileged
 * SYSTEM user.
 * 
 * It must run before the following scripts:
 *
 *   1. create_external_plsql.sql
 *   2. create phyiscal directories that match these or define your own.
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
            WHERE  directory_name IN ('UPLOAD_LOG','UPLOAD_SOURCE')) LOOP
    EXECUTE IMMEDIATE 'DROP DIRECTORY '||i.directory_name;
  END LOOP;
END;
/

-- Create virtual directories.
CREATE DIRECTORY upload_source AS 'C:\upload\source';
CREATE DIRECTORY upload_log AS 'C:\upload\log';

-- Grant read or read/write permission on directories to PLSQL user.
GRANT READ ON DIRECTORY upload_source TO plsql;
GRANT READ, WRITE ON DIRECTORY upload_log TO plsql;

-- Create a wrapper program to correct file path delimiter.
CREATE OR REPLACE FUNCTION get_file_delimiter RETURN VARCHAR2 IS
  lv_return_value VARCHAR2(1);
BEGIN
  SELECT CASE
           WHEN REGEXP_LIKE(platform_name,'.(W|w)indows.')
           THEN '\'
           ELSE '/'
         END AS delimiter
  INTO   lv_return_value
  FROM   sys.v_$database;
  RETURN lv_return_value;
END;
/

-- Grant execute privileges on the function to the PLSQL user.
GRANT EXECUTE ON get_file_delimiter TO plsql;

-- Create a wrapper to get the absolute path.
CREATE OR REPLACE FUNCTION get_absolute_path
(lv_virtual_name  VARCHAR2) RETURN VARCHAR2 IS
  lv_return_value VARCHAR2(255);
BEGIN
  SELECT directory_path
  INTO   lv_return_value
  FROM   sys.dba_directories
  WHERE  directory_name = lv_virtual_name;
  RETURN lv_return_value;
END;
/

-- Grant execute privileges on the function the PL/SQL user.
GRANT EXECUTE ON get_absolute_path TO plsql;