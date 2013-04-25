/*
 * external_plsql.sql
 * Chapter 12, Oracle Database PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script requires you to run it as the privileged
 * PLSQL user; alternatively, you need the following
 * permissions:
 *
 * - CONNECT, RESOURCE, CREATE ANY SYNONYM, CREATE ANY VIEW
 *
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000


-- This cleans up any objects that previously existed, and
-- makes the script re-runnable.
BEGIN
  -- Conditionally cleanup tables and synonyms.
  FOR i IN (SELECT   object_name
            ,        object_type
            FROM     user_objects
            WHERE    object_name IN ('ITEM_LOAD'
                                    ,'ITEM_SOURCE_FILE'
                                    ,'ITEM_TARGET'
                                    ,'GET_FILE_DELIMITER'
                                    ,'GET_ABSOLUTE_PATH')) LOOP
    EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
  END LOOP;
  -- Conditionally cleanup Java source and classes.
  FOR i IN (SELECT   object_name
            FROM     user_objects
            WHERE    object_name IN ('DeleteFile')
            AND      object_type = 'JAVA SOURCE') LOOP
    EXECUTE IMMEDIATE 'DROP JAVA SOURCE "'||i.object_name||'"';
  END LOOP;
  -- Conditionally cleanup object types.
  FOR i IN (SELECT   type_name
            FROM     user_types
            WHERE    type_name IN ('ITEM_LOAD_OBJ','ITEM_LOAD_OBJ_TABLE')
            ORDER BY 1 DESC) LOOP
    EXECUTE IMMEDIATE 'DROP TYPE '||i.type_name;
  END LOOP;
END;
/

-- Create synonyms to data catalog functions.
CREATE SYNONYM get_file_delimiter FOR system.get_file_delimiter;
CREATE SYNONYM get_absolute_path FOR system.get_absolute_path;

-- Format output.
COLUMN owner          FORMAT A10
COLUMN directory_name FORMAT A30
COLUMN directory_path FORMAT A30

-- Confirm the existence of virtual directories.
SELECT *
FROM   dba_directories
WHERE  directory_name IN ('UPLOAD_SOURCE','UPLOAD_LOG');

-- Create the external table.
CREATE TABLE item_load
( item_title    VARCHAR2(60)
, item_subtitle VARCHAR2(60)
, release_date  DATE)
  ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY upload_source
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD_LOG':'item_load.bad'
      DISCARDFILE 'UPLOAD_LOG':'item_load.dis'
      LOGFILE     'UPLOAD_LOG':'item_load.log'
      LOAD WHEN (item_title != 'Harry Potter and the Order of the Phoenix')
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
      LOCATION ('item_load.csv'))
REJECT LIMIT UNLIMITED;

-- Create the SQL record structure.
CREATE OR REPLACE TYPE item_load_obj IS OBJECT
( item_title     VARCHAR2(60)
, item_subtitle  VARCHAR2(60)
, release_date   DATE );
/

-- Create the container or table of the object type.
CREATE OR REPLACE TYPE item_load_obj_table IS TABLE OF item_load_obj;
/

-- Create a wrapper to the external table.
CREATE OR REPLACE FUNCTION item_source_file
RETURN item_load_obj_table IS
  lv_c          NUMBER := 1;
  lv_collection ITEM_LOAD_OBJ_TABLE := item_load_obj_table();
BEGIN
  FOR i IN (SELECT * FROM item_load) LOOP
    lv_collection.EXTEND;
    lv_collection(lv_c) := item_load_obj( i.item_title
                                        , i.item_subtitle
                                        , i.release_date);
    lv_c := lv_c + 1;
  END LOOP;
  RETURN lv_collection;
EXCEPTION
  WHEN OTHERS THEN
    RETURN lv_collection;
END;
/

-- Select data from the wrapper function.
COLUMN item_title    FORMAT A30
COLUMN item_subtitle FORMAT A30
COLUMN release_date  FORMAT A11

-- Select any data from the external table through the wrapper.
SELECT * FROM TABLE(item_source_file);

-- Create the importing target table.
CREATE TABLE item_target
( item_title    VARCHAR2(60)
, item_subtitle VARCHAR2(60)
, release_date  DATE);

-- Create an insertion function to the target table.
CREATE OR REPLACE FUNCTION insert_items
( pv_item_list ITEM_LOAD_OBJ_TABLE ) RETURN BOOLEAN IS
  lv_return_value BOOLEAN := FALSE;
BEGIN
  FOR i IN 1..pv_item_list.COUNT LOOP
    INSERT INTO item_target VALUES
    ( pv_item_list(i).item_title
    , pv_item_list(i).item_subtitle
    , pv_item_list(i).release_date );
  END LOOP;
  IF SQL%ROWCOUNT > 0 THEN
    lv_return_value := TRUE;
  END IF;
  RETURN lv_return_value;
END;
/

-- The Java resolver can be confused, so dropping this avoids the error.
BEGIN
  FOR i IN (SELECT dbms_java.longname(object_name) AS name
            FROM   user_objects
            WHERE  dbms_java.longname(object_name) = 'DeleteFile'
            AND    object_type = 'JAVA SOURCE') LOOP
            dbms_output.put_line('"'||i.name||'"');
    EXECUTE IMMEDIATE 'DROP JAVA SOURCE "'||i.name||'"';
  END LOOP;
END;
/

-- Set the ampersand to off to run and compile Java.
SET DEFINE OFF

-- Create and compile Java source.
CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "DeleteFile" AS
  // Java import statements
  import java.io.File;
  import java.security.AccessControlException;

  // Class definition.
  public class DeleteFile {

    // Define variable(s).
    private static File file;

    // Define copyTextFile() method.
    public static void deleteFile(String fileName)
      throws AccessControlException {

      // Create files from canonical file names.
      file = new File(fileName);
 
      // Delete file(s).
      if (file.isFile() && file.delete()) {}}}
 /

-- Set the ampersand to on to process nomral SQL and PL/SQL.
SET DEFINE ON

-- Create the PL/SQL wrapper to the Java library.
CREATE OR REPLACE PROCEDURE delete_file (dfile VARCHAR2) IS
LANGUAGE JAVA
NAME 'DeleteFile.deleteFile(java.lang.String)';
/

-- Set external output on.
SET SERVEROUTPUT ON SIZE 1000000

-- Create the master import process.
CREATE OR REPLACE FUNCTION manage_import
( pv_external_table VARCHAR2 ) RETURN BOOLEAN IS
  lv_absolute_path  VARCHAR2(4000);
  lv_delimiter      VARCHAR2(1);
  lv_return_value BOOLEAN := FALSE;
  CURSOR lv_file_name ( cv_virtual_name VARCHAR2 ) IS
    SELECT   location
    ,        directory_name
    FROM     user_external_locations
    WHERE    table_name = cv_virtual_name;
BEGIN
  IF insert_items(item_source_file) THEN
    FOR i IN lv_file_name(pv_external_table) LOOP
      lv_absolute_path := get_absolute_path(i.directory_name);
      lv_delimiter := get_file_delimiter;
      delete_file(lv_absolute_path||lv_delimiter||i.location);
    END LOOP;
    lv_return_value := TRUE;
  ELSE
    lv_return_value := FALSE;
  END IF;
  RETURN lv_return_value;
END;
/

-- Run the master process.
BEGIN IF manage_import('ITEM_LOAD') THEN NULL; END IF; END;
/

-- Display the uploaded data when the file has data.
SELECT * FROM item_target;