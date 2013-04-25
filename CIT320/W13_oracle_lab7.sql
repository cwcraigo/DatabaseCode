




@ CIT320_lab6.sql;

-- Open log file
SPOOL log\CIT320_lab7.txt

-- ------------------------------------------------------------
-- ------------------------------------------------------------
-- LAB 7 ------------------------------------------------------
-- ------------------------------------------------------------
-- ORACLE -----------------------------------------------------
-- ------------------------------------------------------------
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- STEP 1
--   CREATE transaction TABLE
-- 	 ADD UNIQUE INDEX ON: rental_id, transaction_type,
-- 						transaction_date, payment_method_type,
-- 						payment_account_number
--
-- 		transaction_s1 should start with the default value of 1
-- ------------------------------------------------------------

-- Drop all tables and sequences in this lab-------------------
BEGIN
  FOR i IN (SELECT TABLE_NAME
  			FROM user_tables
  			WHERE TABLE_NAME IN
  			('TRANSACTION', 'AIRPORT', 'ACCOUNT_LIST', 'TRANSACTION_UPLOAD'))
  			LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.TABLE_NAME||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
  			FROM user_sequences
  			WHERE sequence_name IN
  			('TRANSACTION_S1', 'AIRPORT_S1', 'ACCOUNT_LIST_S1'))
  			LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.SEQUENCE_NAME;
  END LOOP;
END;
/

-- Create transaction---------------------------------------------------
CREATE TABLE transaction
( transaction_id			NUMBER
, transaction_account		VARCHAR2(15)	CONSTRAINT nn_transaction_1 NOT NULL
, transaction_type			NUMBER
, transaction_date			DATE			CONSTRAINT nn_transaction_2 NOT NULL
, transaction_amount		FLOAT			CONSTRAINT nn_transaction_3 NOT NULL
, rental_id					NUMBER
, payment_method_type		NUMBER
, payment_account_number	VARCHAR2(19)	CONSTRAINT nn_transaction_4 NOT NULL
, created_by				NUMBER
, creation_date				DATE			CONSTRAINT nn_transaction_5 NOT NULL
, last_updated_by			NUMBER
, last_update_date			DATE			CONSTRAINT nn_transaction_6 NOT NULL
, CONSTRAINT	pk_transaction_1 PRIMARY KEY (transaction_id)
, CONSTRAINT fk_transaction_1 FOREIGN KEY (transaction_type)
	REFERENCES	common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_2 FOREIGN KEY (rental_id)
	REFERENCES	rental(rental_id)
, CONSTRAINT fk_transaction_3 FOREIGN KEY (payment_method_type)
	REFERENCES	common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_4 FOREIGN KEY (created_by)
	REFERENCES	system_user(system_user_id)
, CONSTRAINT fk_transaction_5 FOREIGN KEY (last_updated_by)
	REFERENCES	system_user(system_user_id)
);

	-- Create a sequence-------------------------------------------
CREATE SEQUENCE transaction_s1 START WITH 1;

	-- 	Unique indexs----------------------------------------
CREATE UNIQUE INDEX transaction_u1 ON transaction
	(transaction_account, rental_id, transaction_type, transaction_date, payment_method_type, payment_account_number);

-- ------------------------------------------------------------
-- STEP 2
--   INSERT 9 ROWS
-- 	 UPDATE rental_item_type IN rental_item WITH NEW cl_id's
-- ------------------------------------------------------------
	-- 	Insert into common_lookup----------------------------------
INSERT INTO common_lookup
SELECT
  common_lookup_s1.nextval
, lookup_type
, lookup_meaning
, 1
, SYSDATE
, 1
, SYSDATE
, lookup_table
, lookup_column
, lookup_code
FROM
(
(SELECT 'TRANSACTION' AS lookup_table
		,'TRANSACTION_TYPE' AS lookup_column
		,'CREDIT' AS lookup_type
		,'Credit' AS lookup_meaning
		,'CR' AS lookup_code
FROM dual) UNION ALL
(SELECT 'TRANSACTION','TRANSACTION_TYPE','DEBIT','Debit','DR'
FROM dual) UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','DISCOVER_CARD','Discover Card',NULL
FROM dual) UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','VISA_CARD','Visa Card',NULL
FROM dual) UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','MASTER_CARD','Master Card',NULL
FROM dual) UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','CASH','Cash',NULL
FROM dual) UNION ALL
(SELECT 'RENTAL_ITEM','RENTAL_ITEM_TYPE','1-DAY RENTAL','1-Day Rental',NULL
FROM dual) UNION ALL
(SELECT 'RENTAL_ITEM','RENTAL_ITEM_TYPE','3-DAY RENTAL','3-Day Rental',NULL
FROM dual) UNION ALL
(SELECT 'RENTAL_ITEM','RENTAL_ITEM_TYPE','5-DAY RENTAL','5-Day Rental',NULL
FROM dual)
);

-- 	Update rental_item_type----------------------------------------
UPDATE rental_item
	SET rental_item_type = CASE
			WHEN rental_item_type = 1021 THEN 1030
			WHEN rental_item_type = 1022 THEN 1031
			WHEN rental_item_type = 1023 THEN 1032
			ELSE rental_item_type
		END;

-- ------------------------------------------------------------
-- STEP 3
-- ------------------------------------------------------------
-- A CREATE airport AND account_list--------------------------
-- Create airport---------------------------------------------------
CREATE TABLE airport
( airport_id		NUMBER
, airport_code		VARCHAR2(3)		CONSTRAINT nn_airport_1 NOT NULL
, airport_city		VARCHAR2(30)	CONSTRAINT nn_airport_2 NOT NULL
, city				VARCHAR2(30)	CONSTRAINT nn_airport_3 NOT NULL
, state_province	VARCHAR2(30)	CONSTRAINT nn_airport_4 NOT NULL
, created_by		NUMBER
, creation_date		DATE			CONSTRAINT nn_airport_5 NOT NULL
, last_updated_by	NUMBER
, last_update_date	DATE			CONSTRAINT nn_airport_6 NOT NULL
, CONSTRAINT	pk_airport_1 PRIMARY KEY (airport_id)
, CONSTRAINT fk_airport_1 FOREIGN KEY (created_by)
	REFERENCES	system_user(system_user_id)
, CONSTRAINT fk_airport_2 FOREIGN KEY (last_updated_by)
	REFERENCES	system_user(system_user_id)
);

-- Create a sequence-------------------------------------------
CREATE SEQUENCE airport_s1 START WITH 1;

-- Create account_list---------------------------------------------------
CREATE TABLE account_list
( account_list_id	NUMBER
, account_number	VARCHAR2(10)	CONSTRAINT nn_account_list_1 NOT NULL
, consumed_date		DATE
, consumed_by		NUMBER
, created_by		NUMBER
, creation_date		DATE			CONSTRAINT nn_account_list_2 NOT NULL
, last_updated_by	NUMBER
, last_update_date	DATE			CONSTRAINT nn_account_list_3 NOT NULL
, CONSTRAINT	pk_account_list_1 PRIMARY KEY (account_list_id)
, CONSTRAINT fk_account_list_1 FOREIGN KEY (consumed_by)
	REFERENCES	system_user(system_user_id)
, CONSTRAINT fk_account_list_2 FOREIGN KEY (created_by)
	REFERENCES	system_user(system_user_id)
, CONSTRAINT fk_account_list_3 FOREIGN KEY (last_updated_by)
	REFERENCES	system_user(system_user_id)
);

-- Create a sequence-------------------------------------------
CREATE SEQUENCE account_list_s1 START WITH 1;

-- 	B SEED airport---------------------------------------------
INSERT INTO airport
SELECT
  airport_s1.nextval
, code
, airport_city
, city
, state
, 1
, SYSDATE
, 1
, SYSDATE
FROM
(
(SELECT  'LAX' AS code
		,'Los Angeles' AS airport_city
		,'Los Angeles' AS city
		,'California' AS state
FROM dual) UNION ALL
(SELECT 'SLC','Salt Lake City','Provo','Utah'
FROM dual) UNION ALL
(SELECT 'SLC','Salt Lake City','Spanish Fork','Utah'
FROM dual) UNION ALL
(SELECT 'SFO','San Francisco','San Francisco','California'
FROM dual) UNION ALL
(SELECT 'SJC','San Jose','San Jose','California'
FROM dual) UNION ALL
(SELECT 'SJC','San Jose','San Carlos','California'
FROM dual)
);

--
-- UPDATE contact
-- 	SET first_name = 'Lily'
-- 	WHERE first_name = 'Lila';
--
-- 	C SEED account_list----------------------------------------
	-- TO LOOK AT STORED PROCEDURES USE:
		-- SELECT object_name FROM user_procedures;
EXECUTE seed_account_list();

SELECT COUNT(DISTINCT airport_code) AS "# Airports"
FROM   airport;

SELECT COUNT(*) AS "# Accounts"
FROM   account_list;

-- 	D UPDATE state_province IN address-------------------------
UPDATE address
	SET state_province = CASE
			WHEN state_province = 'CA' THEN 'California'
			WHEN state_province = 'UT' THEN 'Utah'
			ELSE state_province
		END;

-- 	E FIXING account_number COLUMN IN member-------------------
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

-- execute stored procedure
SET SERVEROUTPUT ON SIZE UNLIMITED
EXECUTE update_member_account();

-- Validation for update_member_account
	-- Format the SQL statement display.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A10    HEADING "Last|Name"
COLUMN account_number FORMAT A10 	HEADING "Account|Number"
COLUMN city           FORMAT A16 	HEADING "City"
COLUMN state_province FORMAT A10 	HEADING "State or|Province"
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


-- ------------------------------------------------------------
-- STEP 4
-- 		CREATE EXTERNAL TABLE transaction_upload
-- ------------------------------------------------------------
-- Create external table transaction_upload.
CREATE TABLE transaction_upload
( account_number        	VARCHAR2(10)
, first_name            	VARCHAR2(20)
, middle_name           	VARCHAR2(20)
, last_name					VARCHAR2(20)
, check_out_date   			DATE
, return_date				DATE
, rental_item_type			VARCHAR2(12)
, transaction_type			VARCHAR2(14)
, transaction_amount		FLOAT
, transaction_date			DATE
, item_id					NUMBER
, payment_method_type		VARCHAR2(14)
, payment_account_number	VARCHAR2(19)
)
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

-- ------------------------------------------------------------
-- STEP 5
-- 		CREATE UPLOAD PROCEDURE
-- 			NEEDS TO BE RERUNNABLE AND VALIDATE PROPORLY
-- ------------------------------------------------------------
-- Create a procedure to wrap the transaction.
CREATE OR REPLACE PROCEDURE upload_transaction_log IS
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;

  -- Insert or update rental table,
  -- Rerunnable when the file hasn't been updated.
MERGE INTO rental target
  USING (SELECT   DISTINCT
  				  r.rental_id
  		   ,	c.contact_id
         ,  tu.check_out_date
         ,  tu.return_date
         ,	r.last_updated_by
         ,  r.last_update_date
		 FROM 	member m INNER JOIN contact c
		 ON 	m.member_id = c.member_id
	INNER JOIN transaction_upload tu
		 ON 	m.account_number = tu.account_number
		 AND 	c.first_name = tu.first_name
		 AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
		 AND	c.last_name = tu.last_name
	LEFT JOIN rental r
		 ON 	r.customer_id = c.contact_id
		 AND	r.check_out_date = tu.check_out_date
		 AND 	r.return_date = tu.return_date) SOURCE
  ON (target.rental_id = SOURCE.rental_id)
  WHEN MATCHED THEN
		UPDATE SET target.last_updated_by = SOURCE.last_updated_by
		,          target.last_update_date = SOURCE.last_update_date
  WHEN NOT MATCHED THEN
  	INSERT
  	( rental_id
  	, customer_id
  	, check_out_date
  	, return_date
  	, created_by
  	, creation_date
  	, last_updated_by
  	, last_update_date)
  	VALUES
  	( rental_s1.NEXTVAL
  	, SOURCE.contact_id
  	, SOURCE.check_out_date
  	, SOURCE.return_date
  	, 1
  	, SYSDATE
  	, 1
  	, SYSDATE);


  -- Insert or update rental_item table,
MERGE INTO rental_item target
  USING (SELECT
            ri.rental_item_id
  		   ,	r.rental_id
         ,  tu.item_id
         ,  TRUNC(tu.return_date) - TRUNC(r.check_out_date) AS rental_item_price
         ,	cl.common_lookup_id AS rental_item_type
         ,	3 AS created_by
         ,  TRUNC(ri.creation_date) AS creation_date
         ,	3 AS last_updated_by
         ,	TRUNC(ri.last_update_date) AS last_update_date
	FROM member m INNER JOIN contact c
		 ON 	m.member_id = c.member_id
	INNER JOIN transaction_upload tu
		 ON 	m.account_number = tu.account_number
		 AND 	c.first_name = tu.first_name
		 AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
		 AND	c.last_name = c.last_name
	LEFT JOIN rental r
		 ON 	r.customer_id = c.contact_id
		 AND	r.check_out_date = tu.check_out_date
		 AND 	r.return_date = tu.return_date
	INNER JOIN common_lookup cl
		 ON		tu.rental_item_type = cl.common_lookup_type
		 AND	cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
	LEFT JOIN rental_item ri
		 ON		ri.rental_id = r.rental_id
		 AND	ri.item_id = tu.item_id
		 AND	ri.rental_item_type = cl.common_lookup_id) SOURCE
  ON (target.rental_item_id = SOURCE.rental_item_id)
  WHEN MATCHED THEN
		UPDATE SET target.last_updated_by = SOURCE.last_updated_by
		,          target.last_update_date = SOURCE.last_update_date
  WHEN NOT MATCHED THEN
  	INSERT
  	( rental_item_id
  	, rental_id
  	, item_id
  	, created_by
  	, creation_date
  	, last_updated_by
  	, last_update_date
  	, rental_item_type
  	, rental_item_price)
  	VALUES
  	( rental_item_s1.NEXTVAL
  	, SOURCE.rental_id
  	, SOURCE.item_id
  	, 3
  	, SYSDATE
  	, 3
  	, SYSDATE
  	, SOURCE.rental_item_type
  	, SOURCE.rental_item_price
  	);


  -- Insert or update transaction table,
MERGE INTO transaction target
  USING ((SELECT
  				t.transaction_id
  		 ,		tu.payment_account_number AS transaction_account
         ,      cl1.common_lookup_id AS transaction_type
         ,      tu.transaction_date
         ,		SUM(tu.transaction_amount) AS transaction_amount
         ,		r.rental_id
         ,		cl2.common_lookup_id AS payment_method_type
         ,		m.credit_card_number AS payment_account_number
         ,		3 AS created_by
         ,		TRUNC(t.creation_date) AS creation_date
         ,		3 AS last_updated_by
         ,		TRUNC(t.last_update_date) AS last_update_date
	FROM 	member m INNER JOIN contact c
		ON 	m.member_id = c.member_id
	INNER JOIN transaction_upload tu
		ON 	m.account_number = tu.account_number
		AND c.first_name = tu.first_name
		AND NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
		AND	c.last_name = c.last_name
	INNER JOIN rental r
		ON 	r.customer_id = c.contact_id
		AND	r.check_out_date = tu.check_out_date
		AND r.return_date = tu.return_date
	INNER JOIN common_lookup cl1
		ON  cl1.common_lookup_table = 'TRANSACTION'
		AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
		AND cl1.common_lookup_type = 'DEBIT'
	INNER JOIN common_lookup cl2
		ON  cl2.common_lookup_table = 'TRANSACTION'
		AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
		AND cl2.common_lookup_type = 'DISCOVER_CARD'
	LEFT JOIN transaction t
		ON  t.transaction_account = tu.account_number
		AND t.transaction_amount = tu.transaction_amount
		AND t.transaction_type = cl1.common_lookup_id
		AND t.transaction_date = tu.transaction_date
		AND t.payment_method_type = cl2.common_lookup_id
		AND t.payment_account_number = m.credit_card_number
	GROUP BY  t.transaction_id
			, tu.payment_account_number
			, cl1.common_lookup_id
			, tu.transaction_date
			, r.rental_id
			, cl2.common_lookup_id
			, m.credit_card_number
			, 3
			, t.creation_date
			, 3
			, t.last_update_date)) SOURCE
  ON (target.rental_id = SOURCE.rental_id)
  WHEN MATCHED THEN
		UPDATE SET target.last_updated_by = SOURCE.last_updated_by
		,          target.last_update_date = SOURCE.last_update_date
  WHEN NOT MATCHED THEN
  	INSERT
  	( transaction_id
	 ,transaction_account
	 ,transaction_type
	 ,transaction_date
	 ,transaction_amount
	 ,rental_id
	 ,payment_method_type
	 ,payment_account_number
	 ,created_by
	 ,creation_date
	 ,last_updated_by
	 ,last_update_date)
  	VALUES
  	( transaction_s1.NEXTVAL
 	, SOURCE.transaction_account
  	, SOURCE.transaction_type
	, SOURCE.transaction_date
  	, SOURCE.transaction_amount
  	, SOURCE.rental_id
  	, SOURCE.payment_method_type
  	, SOURCE.payment_account_number
  	, 3
  	, SYSDATE
  	, 3
  	, SYSDATE);



   -- Save the changes.
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/

-- RUN UPLOAD PROCEDURE
EXECUTE upload_transaction_log();

-- RUN SECOND TIME TO CHECK FOR RERUNNABILITY
-- EXECUTE upload_transaction_log();

-- VALIDATION OF upload_kingdom PROCEDURE ----------------------------
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"

SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;

-- SHOULD LOOK LIKE THIS

--          Rental
--  Rental    Item TRANSACTION
--   COUNT   COUNT       COUNT
-- ------- ------- -----------
--   4,689  11,532       4,681




-- ------------------------------------------------------------
-- STEP 6
-- ------------------------------------------------------------
COLUMN mon FORMAT A10 HEADING "MONTH"
COLUMN base FORMAT $99,999.00 HEADING "BASE_REVENUE"
COLUMN ten FORMAT $99,999.00 HEADING "10_PLUS"
COLUMN twenty FORMAT $99,999.00 HEADING "20_PLUS"
COLUMN ten_plus FORMAT $99,999.00 HEADING "10_PLUS_LESS_B"
COLUMN twenty_plus FORMAT $99,999.00 HEADING "20_PLUS_LESS_B"

SELECT DISTINCT
	 TO_CHAR(transaction_date, 'MON-YYYY') AS mon
	,SUM(transaction_amount) AS base
	,(SUM(transaction_amount) * 1.1) AS ten
	,(SUM(transaction_amount) * 1.2) AS twenty
	,(SUM(transaction_amount) * 0.1) AS ten_plus
	,(SUM(transaction_amount) * 0.2) AS twenty_plus
FROM transaction
WHERE EXTRACT(YEAR FROM transaction_date) = 2009
GROUP BY
   TO_CHAR(transaction_date, 'MON-YYYY')
ORDER BY CASE
           WHEN mon = 'JAN-2009'  THEN 0
           WHEN mon = 'FEB-2009'  THEN 1
           WHEN mon = 'MAR-2009'  THEN 2
           WHEN mon = 'APR-2009'  THEN 3
           WHEN mon = 'MAY-2009'  THEN 4
           WHEN mon = 'JUN-2009'  THEN 5
           WHEN mon = 'JUL-2009'  THEN 6
           WHEN mon = 'AUG-2009'  THEN 7
           WHEN mon = 'SEP-2009'  THEN 8
           WHEN mon = 'OCT-2009'  THEN 9
    	   WHEN mon = 'NOV-2009'  THEN 10
    	   WHEN mon = 'DEC-2009'  THEN 11
         END;


-- SHOULD LOOK LIKE THIS

-- MONTH      BASE_REVENUE   10_PLUS        20_PLUS        10_PLUS_LESS_B 20_PLUS_LESS_B
-- ---------- -------------- -------------- -------------- -------------- --------------
-- JAN-2009        $2,671.20      $2,938.32      $3,205.44        $267.12        $534.24
-- FEB-2009        $4,270.74      $4,697.81      $5,124.89        $427.07        $854.15
-- MAR-2009        $5,371.02      $5,908.12      $6,445.22        $537.10      $1,074.20
-- APR-2009        $4,932.18      $5,425.40      $5,918.62        $493.22        $986.44
-- MAY-2009        $2,216.46      $2,438.11      $2,659.75        $221.65        $443.29
-- JUN-2009        $1,208.40      $1,329.24      $1,450.08        $120.84        $241.68
-- JUL-2009        $2,404.08      $2,644.49      $2,884.90        $240.41        $480.82
-- AUG-2009        $2,241.90      $2,466.09      $2,690.28        $224.19        $448.38
-- SEP-2009        $2,197.38      $2,417.12      $2,636.86        $219.74        $439.48
-- OCT-2009        $3,275.40      $3,602.94      $3,930.48        $327.54        $655.08
-- NOV-2009        $3,125.94      $3,438.53      $3,751.13        $312.59        $625.19
-- DEC-2009        $2,340.48      $2,574.53      $2,808.58        $234.05        $468.10





-- Close log file.---------------------------------------------
SPOOL OFF





















