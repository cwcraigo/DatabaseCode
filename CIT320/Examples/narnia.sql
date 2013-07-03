-- Conditionally drop tables and sequences.
BEGIN
  FOR i IN (SELECT TABLE_NAME
            FROM   user_tables
            WHERE  TABLE_NAME IN ('KINGDOM','KNIGHT','KINGDOM_KNIGHT_IMPORT')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.TABLE_NAME||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
            FROM   user_sequences
            WHERE  sequence_name IN ('KINGDOM_S1','KNIGHT_S1')) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.sequence_name;
  END LOOP;
END;
/

-- Create normalized kingdom table.
CREATE TABLE kingdom
( kingdom_id    NUMBER
, kingdom_name  VARCHAR2(20)
, population    NUMBER);

-- Create a sequence for the kingdom table.
CREATE SEQUENCE kingdom_s1;

-- Create normalized knight table.
CREATE TABLE knight
( knight_id             NUMBER
, knight_name           VARCHAR2(24)
, kingdom_allegiance_id NUMBER
, allegiance_start_date DATE
, allegiance_end_date   DATE);

-- Create a sequence for the knight table.
CREATE SEQUENCE knight_s1;

-- Create external import table.
CREATE TABLE kingdom_knight_import
( kingdom_name          VARCHAR2(20)
, population            NUMBER
, knight_name           VARCHAR2(24)
, allegiance_start_date DATE
, allegiance_end_date   DATE)
  ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY download
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     CHARACTER
      DISCARDFILE CHARACTER
      LOGFILE     CHARACTER
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('kingdom_import.csv'))
REJECT LIMIT UNLIMITED;


-- Create a procedure to wrap the transaction.
CREATE OR REPLACE PROCEDURE upload_kingdom IS
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO kingdom target
  USING (SELECT   DISTINCT
                  k.kingdom_id
         ,        kki.kingdom_name
         ,        kki.population
         FROM     kingdom_knight_import kki LEFT JOIN kingdom k
         ON       kki.kingdom_name = k.kingdom_name
         AND      kki.population = k.population) SOURCE
  ON (target.kingdom_id = SOURCE.kingdom_id)
  WHEN MATCHED THEN
  UPDATE SET kingdom_name = SOURCE.kingdom_name
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( kingdom_s1.NEXTVAL
  , SOURCE.kingdom_name
  , SOURCE.population);

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO knight target
  USING (SELECT   kn.knight_id
    ,        kki.knight_name
    ,        k.kingdom_id
    ,        kki.allegiance_start_date AS start_date
    ,        kki.allegiance_end_date AS end_date
    FROM     kingdom_knight_import kki INNER JOIN kingdom k
    ON       kki.kingdom_name = k.kingdom_name
    AND      kki.population = k.population LEFT JOIN knight kn
    ON       k.kingdom_id = kn.kingdom_allegiance_id
    AND      kki.knight_name = kn.knight_name
    AND      kki.allegiance_start_date = kn.allegiance_start_date
    AND      kki.allegiance_end_date = kn.allegiance_end_date) SOURCE
  ON (target.kingdom_allegiance_id = SOURCE.kingdom_id)
  WHEN MATCHED THEN
  UPDATE SET allegiance_start_date = SOURCE.start_date
  ,          allegiance_end_date = SOURCE.end_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( knight_s1.NEXTVAL
  , SOURCE.knight_name
  , SOURCE.kingdom_id
  , SOURCE.start_date
  , SOURCE.end_date);

  -- Save the changes.
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    dbms_output.put_line('Error: '||SQLERRM);
    RETURN;
END;
/