-- --------------------------------------------------------------------------------
--  Program Name:   apply_lab6_oracle.sql
--  Program Author: Nathan Waters, Pete Martins, Curtis Lange
--  Creation Date:  28-MAY-2013
-- --------------------------------------------------------------------------------

start c:\data\oracle\lab6\apply_lab6_oracle.sql

-- Open log file.
SPOOL c:\data\oracle\lab7\apply_lab7_oracle.txt


-- Point 1
-- ------------------------------------------------------------------
-- Create TRANSACTION table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TRANSACTION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE transaction CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TRANSACTION_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_s1';
  END LOOP;
END;
/

-- Create PRICE Table
CREATE TABLE transaction
  (	transaction_id			NUMBER
  ,	transaction_account		VARCHAR(15)    CONSTRAINT nn_transaction_1 NOT NULL
  ,	transaction_type		NUMBER		CONSTRAINT nn_transaction_2 NOT NULL
  ,	transaction_date		DATE		CONSTRAINT nn_transaction_3 NOT NULL
  ,	transaction_amount		FLOAT		CONSTRAINT nn_transaction_4 NOT NULL
  ,	rental_id				NUMBER		CONSTRAINT nn_transaction_5 NOT NULL
  ,	payment_method_type		NUMBER		CONSTRAINT nn_transaction_6 NOT NULL
  ,	payment_account_number	VARCHAR(19)    CONSTRAINT nn_transaction_7 NOT NULL
  ,	created_by			NUMBER
  ,	creation_date		DATE		CONSTRAINT nn_transaction_8 NOT NULL
  ,	last_updated_by		NUMBER
  ,	last_update_date	DATE		CONSTRAINT nn_transaction_9 NOT NULL
  ,	CONSTRAINT pk_transaction_1 PRIMARY KEY (transaction_id)
  ,	CONSTRAINT fk_transaction_1 FOREIGN KEY (transaction_type) REFERENCES common_lookup(common_lookup_id)
  ,	CONSTRAINT fk_transaction_2 FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
  ,	CONSTRAINT fk_transaction_3 FOREIGN KEY (payment_method_type) REFERENCES common_lookup(common_lookup_id)
  ,	CONSTRAINT fk_transaction_4 FOREIGN KEY (payment_method_type) REFERENCES common_lookup(common_lookup_id)
  ,	CONSTRAINT fk_transaction_5 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
  ,	CONSTRAINT fk_transaction_6 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id));
  
  
-- After you create the table, you need to add a UNIQUE INDEX on the following 
-- columns to the TRANSACTION table. This is necessary to minimize the 
-- run-time performance of the merge operations later in this lab.   
  CREATE UNIQUE INDEX transaction_u1 
	ON transaction (rental_id, transaction_type, transaction_date, payment_method_type, payment_account_number); 
  
-- Create a sequence.
CREATE SEQUENCE transaction_s1 START WITH 1;

-- Point 2
-- ------------------------------------------------------------------
-- Insert the following nine rows into the COMMON_LOOKUP table with 
-- valid who-audit column data. After you insert the 
-- RENTAL_ITEM_TYPE column values, update the existing values in the 
-- RENTAL_ITEM_TYPE column of the RENTAL_ITEM table to point to the 
-- new COMMON_LOOKUP_ID column values
-- ------------------------------------------------------------------

-- PLSQL Statement Insertion
CREATE OR REPLACE PROCEDURE insert_into_common_lookup
  (	pv_lookup_table			VARCHAR2
  ,	pv_lookup_column		VARCHAR2
  ,	pv_lookup_type			VARCHAR2
  , pv_lookup_meaning		VARCHAR2
  ,	pv_lookup_code			VARCHAR2
  , pv_created_by			NUMBER   := 1
  , pv_creation_date		DATE     := SYSDATE
  , pv_last_updated_by		NUMBER   := 1
  , pv_last_update_date		DATE     := SYSDATE) IS
  
BEGIN  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  INSERT INTO common_lookup
  ( common_lookup_id
  , common_lookup_type
  , common_lookup_meaning
  , common_lookup_table
  ,	common_lookup_column
  ,	common_lookup_code
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( common_lookup_s1.NEXTVAL
  ,	pv_lookup_type
  , pv_lookup_meaning
  , pv_lookup_table
  ,	pv_lookup_column
  ,	pv_lookup_code  
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_into_common_lookup;
/

EXECUTE insert_into_common_lookup('TRANSACTION','TRANSACTION_TYPE','CREDIT','Credit','CR');
EXECUTE insert_into_common_lookup('TRANSACTION','TRANSACTION_TYPE','DEBIT','Debit','DR');
EXECUTE insert_into_common_lookup('TRANSACTION','PAYMENT_METHOD_TYPE','DISCOVER_CARD','Discover Card',NULL);
EXECUTE insert_into_common_lookup('TRANSACTION','PAYMENT_METHOD_TYPE','VISA_CARD','Visa Card',NULL);
EXECUTE insert_into_common_lookup('TRANSACTION','PAYMENT_METHOD_TYPE','MASTER_CARD','Master Card',NULL);
EXECUTE insert_into_common_lookup('TRANSACTION','PAYMENT_METHOD_TYPE','CASH','Cash',NULL);
EXECUTE insert_into_common_lookup('RENTAL_ITEM','RENTAL_ITEM_TYPE','1-DAY RENTAL','1-Day Rental',NULL);
EXECUTE insert_into_common_lookup('RENTAL_ITEM','RENTAL_ITEM_TYPE','3-DAY RENTAL','3-Day Rental',NULL);
EXECUTE insert_into_common_lookup('RENTAL_ITEM','RENTAL_ITEM_TYPE','5-DAY RENTAL','5-Day Rental',NULL);

-- Display any compilation errors.
SHOW ERRORS

-- Point 3
-- ------------------------------------------------------------------
-- Create the following AIRPORT and ACCOUNT_LIST tables as per the 
-- specification, but do so understanding the business logic of the 
-- model.
-- ------------------------------------------------------------------


-- ------------------------------------------------------------------
-- A.) You need to create the AIRPORT table and ACCOUNT_LIST tables.
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
-- Create AIRPORT table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'AIRPORT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE airport CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'AIRPORT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE airport_s1';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'AIPORT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE aiport_s1';
  END LOOP;  
END;
/

-- Create AIRPORT Table
CREATE TABLE airport
  (	airport_id				NUMBER
  ,	airport_code			VARCHAR(3)     CONSTRAINT nn_airport_1 NOT NULL
  ,	airport_city			VARCHAR(30)	CONSTRAINT nn_airport_2 NOT NULL
  ,	city					VARCHAR(30)	CONSTRAINT nn_airport_3 NOT NULL
  ,	state_province			VARCHAR(30)	CONSTRAINT nn_airport_4 NOT NULL
  ,	created_by				NUMBER
  ,	creation_date			DATE		CONSTRAINT nn_airport_5 NOT NULL
  ,	last_updated_by			NUMBER
  ,	last_update_date		DATE		CONSTRAINT nn_airport_6 NOT NULL
  ,	CONSTRAINT pk_airport_1 PRIMARY KEY (airport_id)
  ,	CONSTRAINT fk_airport_1 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
  ,	CONSTRAINT fk_airport_2 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id));
  
-- Create a sequence.
CREATE SEQUENCE airport_s1 START WITH 1;


-- ------------------------------------------------------------------
-- Create ACCOUNT_LIST table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'ACCOUNT_LIST') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE account_list CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'ACCOUNT_LIST_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE account_list_s1';
  END LOOP;
END;
/

-- Create ACCOUNT_LIST Table
CREATE TABLE account_list
  (	account_list_id				NUMBER
  ,	account_number				VARCHAR(10)    CONSTRAINT nn_account_list_1 NOT NULL
  ,	consumed_date				DATE
  ,	consumed_by					NUMBER
  ,	created_by					NUMBER                    
  ,	creation_date				DATE		CONSTRAINT nn_account_list_2 NOT NULL
  ,	last_updated_by				NUMBER 
  ,	last_update_date			DATE		CONSTRAINT nn_account_list_3 NOT NULL
  ,	CONSTRAINT pk_account_list_1 PRIMARY KEY (account_list_id)
  ,	CONSTRAINT fk_account_list_1 FOREIGN KEY (consumed_by) REFERENCES system_user(system_user_id)
  ,	CONSTRAINT fk_account_list_2 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
  ,	CONSTRAINT fk_account_list_3 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id));
  
-- Create a sequence.
CREATE SEQUENCE account_list_s1 START WITH 1;

-- ------------------------------------------------------------------
-- B.) You need to seed the AIRPORT table with at least these 
-- cities, and any others that you’ve used for inserted values in 
-- the CONTACT table.
-- ------------------------------------------------------------------


-- PLSQL Statement Insertion
CREATE OR REPLACE PROCEDURE insert_into_airport
  (	pv_airport_code			VARCHAR2
  ,	pv_airport_city			VARCHAR2
  ,	pv_city					VARCHAR2
  , pv_state_province		VARCHAR2
  , pv_created_by			NUMBER   := 1
  , pv_creation_date		DATE     := SYSDATE
  , pv_last_updated_by		NUMBER   := 1
  , pv_last_update_date		DATE     := SYSDATE) IS
  
BEGIN  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  INSERT INTO airport
  ( airport_id
  ,	airport_code
  ,	airport_city
  ,	city
  ,	state_province
  ,	created_by
  ,	creation_date
  ,	last_updated_by
  ,	last_update_date )
  VALUES
  ( airport_s1.NEXTVAL
  ,	pv_airport_code
  ,	pv_airport_city
  ,	pv_city
  , pv_state_province
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date);

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_into_airport;
/

EXECUTE insert_into_airport('LAX','Los Angeles','Los Angeles','California');
EXECUTE insert_into_airport('SLC','Salt Lake City','Provo','Utah');
EXECUTE insert_into_airport('SLC','Salt Lake City','Spanish Fork','Utah');
EXECUTE insert_into_airport('SFO','San Francisco','San Francisco','California');
EXECUTE insert_into_airport('SJC','San Jose','San Jose','California');
EXECUTE insert_into_airport('SJC','San Jose','San Carlos','California');


-- Display any compilation errors.
SHOW ERRORS

-- ------------------------------------------------------------------
-- C.) You need to seed the ACCOUNT_LIST table.
-- ------------------------------------------------------------------

-- Create or replace seeding procedure.
CREATE OR REPLACE PROCEDURE seed_account_list IS
BEGIN
  /* Set savepoint. */
  SAVEPOINT all_or_none;
 
  FOR i IN (SELECT DISTINCT airport_code FROM airport) LOOP
    FOR j IN 1..50 LOOP
 
      INSERT INTO account_list
      VALUES
      ( account_list_s1.NEXTVAL
      , i.airport_code||'-'||LPAD(j,6,'0')
      , NULL
      , NULL
      , 2
      , SYSDATE
      , 2
      , SYSDATE);
    END LOOP;
  END LOOP;
 
  /* Commit the writes as a group. */
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

EXECUTE seed_account_list();

SELECT COUNT(*) AS "# Accounts"
FROM   account_list;

-- ------------------------------------------------------------------
-- D.)  The next seeding program and the import program rely on the 
-- use of a full state name.
-- ------------------------------------------------------------------

UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

-- ------------------------------------------------------------------
-- E.)  The rules for replacing ACCOUNT_NUMBER column values in 
-- the MEMBER table are complex. A single query can’t support 
-- the complete logic.
-- ------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE update_member_account IS
 
  /* Declare a local variable. */
  lv_account_number VARCHAR2(10);
 
  /* Declare a SQL cursor fabricated from local variables. */  
  CURSOR member_cursor IS
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
BEGIN
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  FOR i IN member_cursor LOOP
 
      /* Secure a unique account number as they're consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTR(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = i.city
      AND    ap.state_province = i.state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL
      AND    ROWNUM < 2;
 
      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = i.member_id;
 
      /* Mark consumed the last used account number. */      
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = SYSDATE
      WHERE  account_number = lv_account_number;
 
  END LOOP;
 
  /* Commit the writes as a group. */
  COMMIT;
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('You have an error in your AIRPORT table inserts.');
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED
EXECUTE update_member_account();

-- Format the SQL statement display.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A10    HEADING "Last|Name"
COLUMN account_number FORMAT A10 HEADING "Account|Number"
COLUMN city           FORMAT A16 HEADING "City"
COLUMN state_province FORMAT A10 HEADING "State or|Province"
 
-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city
,        a.state_province
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id
ORDER BY 1;

-- Point 4
-- ------------------------------------------------------------------
-- Create the following TRANSACTION_UPLOAD table as per the 
-- specification, but do so understanding the business logic of the 
-- model.
-- ------------------------------------------------------------------

-- Create TRANSACTION_UPLOAD Table
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TRANSACTION_UPLOAD') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE transaction_upload CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TRANSACTION_UPLOAD_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_upload_s1';
  END LOOP;
END;
/

CREATE TABLE transaction_upload
  (	account_number			VARCHAR(10)
  ,	first_name				VARCHAR(20)
  ,	middle_name				VARCHAR(20)
  ,	last_name				VARCHAR(20)
  ,	check_out_date			DATE
  ,	return_date				DATE
  ,	rental_item_type		VARCHAR(12)
  ,	transaction_type		VARCHAR(14)
  ,	transaction_amount		NUMBER
  ,	transaction_date		DATE
  ,	item_id					NUMBER
  ,	payment_method_type		VARCHAR(14)
  ,	payment_account_number	VARCHAR(19))
    ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY download
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'DOWNLOAD':'transaction_upload.bad'
      DISCARDFILE 'DOWNLOAD':'transaction_upload.dis'
      LOGFILE     'DOWNLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('transaction_upload.csv'))
REJECT LIMIT UNLIMITED;
  
-- Create a sequence.
CREATE SEQUENCE transaction_upload_s1 START WITH 1;

-- Point 5
-- ------------------------------------------------------------------
-- Create the following TRANSACTION_UPLOAD table as per the 
-- specification, but do so understanding the business logic of the 
-- model.
-- ------------------------------------------------------------------
SET ECHO OFF
CREATE OR REPLACE PROCEDURE upload_transactions IS 

	lv_rental_count 	 NUMBER;
	lv_rental_item_count NUMBER;
	lv_transaction_count NUMBER;
	
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;
 
  -- Merge into RENTAL table.
  MERGE INTO rental target
  USING (SELECT   DISTINCT
                  r.rental_id
         ,        c.contact_id AS customer_id
         ,        tu.check_out_date
		 ,        tu.return_date
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id
         INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name
         AND      m.account_number = tu.account_number 
         LEFT JOIN rental r
         ON       r.customer_id = c.contact_id
         AND      r.check_out_date = tu.check_out_date
         AND      r.return_date = tu.return_date) SOURCE
  ON (target.rental_id = SOURCE.rental_id)
  WHEN MATCHED THEN
  UPDATE SET last_update_date = SYSDATE
  ,  	 	 last_updated_by = 3
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_s1.NEXTVAL
  , SOURCE.customer_id
  , SOURCE.check_out_date
  , SOURCE.return_date
  , 1
  , SYSDATE
  , 1
  , SYSDATE);
		 
	SELECT COUNT(*) INTO lv_rental_count FROM rental;
	dbms_output.put_line('RENTAL_COUNT: '||lv_rental_count);
  -- ON (target.kingdom_id = SOURCE.kingdom_id)
  -- WHEN MATCHED THEN
  -- UPDATE SET kingdom_name = SOURCE.kingdom_name
  -- WHEN NOT MATCHED THEN
  -- INSERT VALUES
  -- ( kingdom_s1.NEXTVAL
  -- , SOURCE.kingdom_name
  -- , SOURCE.population);
 
  -- Merge into RENTAL_ITEM table.
  MERGE INTO rental_item target
  USING(SELECT    ri.rental_item_id
         ,        r.rental_id
         ,        tu.item_id
         ,        cl.common_lookup_id AS rental_item_type
         ,        (TRUNC(r.return_date) - TRUNC(r.check_out_date)) AS rental_item_price
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id
         INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name
         AND      m.account_number = tu.account_number 
         LEFT JOIN rental r
         ON       r.customer_id = c.contact_id
         AND      r.check_out_date = tu.check_out_date
         AND      r.return_date = tu.return_date
         INNER JOIN common_lookup cl
         ON       cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
         AND      cl.common_lookup_type = tu.rental_item_type
         LEFT JOIN rental_item ri
         ON       ri.item_id = tu.item_id
         AND      ri.rental_id = r.rental_id
		 AND 	  ri.rental_item_type = cl.common_lookup_id) SOURCE
  ON (target.rental_item_id = SOURCE.rental_item_id)
  WHEN MATCHED THEN
  UPDATE SET last_update_date = SYSDATE
  ,  	 	 last_updated_by = 3
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_item_s1.NEXTVAL
  , SOURCE.rental_id
  , SOURCE.item_id
  , 1
  , SYSDATE
  , 1
  , SYSDATE
  , SOURCE.rental_item_type
  , SOURCE.rental_item_price);
 
	SELECT COUNT(*) INTO lv_rental_item_count FROM rental_item;
	dbms_output.put_line('RENTAL_ITEM_COUNT: '||lv_rental_item_count);
 
  -- Merge into TRANSACTION table.
 MERGE INTO transaction target
 USING(SELECT 	 t.transaction_id
        ,        tu.payment_account_number AS transaction_account
        ,        cl1.common_lookup_id AS transaction_type
        ,        tu.transaction_date AS transaction_date
        ,        SUM(tu.transaction_amount) AS transaction_amount
        ,        r.rental_id
        ,        cl2.common_lookup_id AS payment_method_type
        ,        m.credit_card_number AS payment_account_number
        FROM     member m INNER JOIN contact c
        ON       m.member_id = c.member_id 
        INNER JOIN transaction_upload tu
        ON       c.first_name = tu.first_name
        AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
        AND      c.last_name = tu.last_name
        AND      m.account_number = tu.account_number 
        INNER JOIN rental r
        ON       r.customer_id = c.contact_id
        AND      r.check_out_date = tu.check_out_date
        AND      r.return_date = tu.return_date
        INNER JOIN common_lookup cl1
        ON      cl1.common_lookup_table = 'TRANSACTION'
        AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
        AND     cl1.common_lookup_type = tu.transaction_type
        INNER JOIN common_lookup cl2
        ON      cl2.common_lookup_table = 'TRANSACTION'
        AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
        AND     cl2.common_lookup_type = tu.payment_method_type
        LEFT JOIN transaction t
        ON  t.transaction_account    = tu.payment_account_number
        AND t.transaction_type		  = cl1.common_lookup_id		
        AND t.transaction_date 		  = tu.transaction_date
        AND t.rental_id				  = r.rental_id
        AND t.payment_method_type	  = cl2.common_lookup_id
        AND t.payment_account_number = m.credit_card_number
        GROUP BY t.transaction_id
        , tu.payment_account_number 
        , cl1.common_lookup_id
        , tu.transaction_date
        , r.rental_id
        , cl2.common_lookup_id
        , m.credit_card_number) SOURCE
 ON (target.transaction_id = SOURCE.transaction_id)
 WHEN MATCHED THEN
 UPDATE SET  transaction_account = SOURCE.transaction_account
 ,			 transaction_type = SOURCE.transaction_type
 ,			 transaction_date = SOURCE.transaction_date
 ,			 transaction_amount = SOURCE.transaction_amount
 ,			 rental_id = SOURCE.rental_id
 ,			 payment_method_type = SOURCE.payment_method_type
 ,			 payment_account_number = SOURCE.payment_account_number
 ,			 last_update_date = SYSDATE
 ,  	 	 last_updated_by = 3
 WHEN NOT MATCHED THEN
 INSERT VALUES
 ( transaction_s1.NEXTVAL
 , SOURCE.transaction_account
 , SOURCE.transaction_type
 , SOURCE.transaction_date
 , SOURCE.transaction_amount
 , SOURCE.rental_id
 , SOURCE.payment_method_type
 , SOURCE.payment_account_number
 , 1
 , SYSDATE
 , 1
 , SYSDATE);
 
	SELECT COUNT(*) INTO lv_transaction_count FROM transaction;
	dbms_output.put_line('TRANSACTION_COUNT: '||lv_transaction_count);
  -- Save the changes.
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    ROLLBACK TO starting_point;
    RETURN;
END;
/

-- Display any compilation errors.
SHOW ERRORS

EXECUTE upload_transactions();

-- Test the MERGE
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;
		
EXECUTE upload_transactions();

-- Test the MERGE
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;
SET ECHO ON	
-- Point 6
-- ------------------------------------------------------------------
-- Create a query that prints the following types of data for the 
-- year 2010.
-- ------------------------------------------------------------------

SELECT    TO_CHAR(t.transaction_date, 'MON-YYYY') as "MONTH"
,		  TO_CHAR(SUM(t.transaction_amount),'$9,999,999.00') AS "BASE_REVENUE"
,		  TO_CHAR(SUM(t.transaction_amount * 1.1),'$9,999,999.00') AS "10_PLUS"
,		  TO_CHAR(SUM(t.transaction_amount * 1.2),'$9,999,999.00') AS "20_PLUS"
,		  TO_CHAR(SUM(t.transaction_amount * 0.1),'$9,999,999.00') AS "10_PLUS_LESS_B"
,		  TO_CHAR(SUM(t.transaction_amount * 0.2),'$9,999,999.00') AS "20_PLUS_LESS_B"
		FROM transaction t
         WHERE    EXTRACT(YEAR FROM transaction_date) = '2009'
         GROUP BY TO_CHAR(transaction_date, 'MON-YYYY')
		 ORDER BY MIN(transaction_date);

SPOOL OFF