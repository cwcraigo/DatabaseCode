-- ex08-01.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Package Body Parsed Size Is 0
-- -----------------------------------------------------------------------
SELECT  name
     ,  type
     ,  source_size
     ,  parsed_size
     ,  code_size
  FROM  user_object_size
 WHERE  name IN ( 'DBL_AUDIT', 'TO_BASE' );
