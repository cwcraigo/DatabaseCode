/*
 * clob_import_plsql.sql
 * Chapter 12, Oracle Database 11g PL/SQL Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This script requires you to run it as the privileged
 * SYSTEM user.
 * 
 * It must run the clob_import_sys.sql and clob_import_system.sql before
 * you run this script. This also requires the load_clob_from_file.sql
 * script, which is assumed to be in the same working directory.
 */
 
-- Call other script file.
@load_clob_from file.sql

set serveroutput on
BEGIN
  FOR i IN (SELECT dbms_java.longname(object_name) AS name
            FROM   user_objects
            WHERE  dbms_java.longname(object_name) = 'ListVirtualDirectory'
            AND    object_type = 'JAVA SOURCE') LOOP
            dbms_output.put_line('"'||i.name||'"');
    EXECUTE IMMEDIATE 'DROP JAVA SOURCE "'||i.name||'"';
  END LOOP;
END;
/

-- Create Java utility to read external files.
CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "ListVirtualDirectory" AS
 
  // Import required classes.
  import java.io.*;
  import java.security.AccessControlException;
  import java.sql.*;
  import java.util.Arrays;
  import oracle.sql.driver.*;
  import oracle.sql.ArrayDescriptor;
  import oracle.sql.ARRAY;
 
  // Define the class.
  public class ListVirtualDirectory {
 
    // Define the method.
    public static ARRAY getList(String path) throws SQLException {
 
    // Declare variable as a null, required because of try-catch block.
    ARRAY listed = null;
 
    // Define a connection (this is for Oracle 11g).
    Connection conn = DriverManager.getConnection("jdbc:default:connection:");
 
    // Use a try-catch block to trap a Java permission error on the directory.
    try {
      // Declare a class with the file list.
      File directory = new File(path);
 
      // Declare a mapping to the schema-level SQL collection type.
      ArrayDescriptor arrayDescriptor = new ArrayDescriptor("FILE_LIST",conn);
 
      // Translate the Java String[] to the Oracle SQL collection type.
      listed = new ARRAY(arrayDescriptor,conn,((Object[]) directory.list())); }
    catch (AccessControlException e) {}
  return listed; }}
/

-- Create the PL/SQL wrapper to the Java source.
CREATE OR REPLACE FUNCTION list_files(path VARCHAR2) RETURN FILE_LIST IS
LANGUAGE JAVA NAME 
'ListVirtualDirectory.getList(java.lang.String) return oracle.sql.ARRAY';
/

-- Remove column so the master script doesn't need to be re-run.
BEGIN
  FOR i IN (SELECT column_name
            FROM   all_tab_columns
            WHERE  column_name IN ('FILE_DIR','FILE_NAME')
            AND    table_name = 'ITEM') LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE ITEM DROP COLUMN '||i.column_name;
  END LOOP;
END;
/

-- Add the column.
ALTER TABLE item
ADD (file_dir  VARCHAR2(255))
ADD (file_name VARCHAR2(255));

-- Insert description in all matching rows.
UPDATE item
SET    file_dir = 'GENERIC'
,      file_name = 'LOTRFellowship.txt'  
WHERE  item_title = 'The Lord of the Rings - Fellowship of the Ring'
AND    item_type IN
        (SELECT common_lookup_id
         FROM   common_lookup
         WHERE  common_lookup_table = 'ITEM'
         AND    common_lookup_column = 'ITEM_TYPE'
         AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs)*','i'));

-- Insert description in all matching rows.
BEGIN
  FOR i IN (SELECT item_id
            ,      file_dir
            ,      file_name
            FROM   item
            WHERE  file_dir IS NOT NULL
            AND    file_name IS NOT NULL) LOOP
    FOR j IN (SELECT m.file_name
              FROM  (SELECT column_value AS file_name
                     FROM   TABLE(list_files(
                                    get_absolute_path(i.file_dir)))) m
              WHERE  m.file_name = i.file_name) LOOP
            
    -- Call procedure for matching rows.
    load_clob_from_file( src_file_name     => j.file_name
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_DESC'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id));
    END LOOP;
  END LOOP;
END;
/

-- Check after load.
SELECT item_id
,      item_title
,      dbms_lob.getlength(item_desc) AS "SIZE"
FROM   item
WHERE  dbms_lob.getlength(item_desc) > 0;
