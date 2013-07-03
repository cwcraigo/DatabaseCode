-- --------------------------------------------------------------------------------
--  Program Name:   apply_lab6_oracle.sql
--  Program Author: Nathan Waters, Pete Martins, Curtis Lange
--  Creation Date:  28-MAY-2013
-- --------------------------------------------------------------------------------

start c:\data\oracle\lab5\apply_lab5_oracle.sql

-- Open log file.
SPOOL c:\data\oracle\lab6\apply_lab6_oracle.txt

-- Point 1
ALTER TABLE item
	RENAME COLUMN item_release_date
	TO release_date
;

-- Point 2
-- ------------------------------------------------------------------
-- Create PRICE table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
/

-- Create PRICE Table
CREATE TABLE price
  (	price_id			NUMBER
  ,	item_id				NUMBER
  ,	price_type			NUMBER
  ,	active_flag			CHAR(1)		CONSTRAINT cc_price_1 CHECK	(active_flag IN ('Y','N'))
  ,	start_date			DATE		CONSTRAINT nn_price_1 NOT NULL
  ,	end_date			DATE
  ,	amount				NUMBER
  ,	created_by			NUMBER
  ,	creation_date		DATE		CONSTRAINT nn_price_2 NOT NULL
  ,	last_updated_by		NUMBER
  ,	last_update_date	DATE		CONSTRAINT nn_price_3 NOT NULL
  ,	CONSTRAINT pk_price_1 PRIMARY KEY (price_id)
  ,	CONSTRAINT fk_price_1 FOREIGN KEY (item_id) REFERENCES item(item_id)
  ,	CONSTRAINT fk_price_2 FOREIGN KEY (price_type) REFERENCES common_lookup(common_lookup_id)
  ,	CONSTRAINT fk_price_3 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
  ,	CONSTRAINT fk_price_4 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id)
  , CONSTRAINT cc_price_2 CHECK (end_date > start_date + 29))
  ;
  
-- Create a sequence.
CREATE SEQUENCE price_s1 START WITH 1001;

-- Point 3
-- A.) Insert three new DVD releases into the ITEM table.

-- PLSQL Statement Insertion
CREATE OR REPLACE PROCEDURE insert_item
  (	pv_item_barcode			VARCHAR2
  ,	pv_item_type			VARCHAR2
  , pv_item_title			VARCHAR2
  ,	pv_item_subtitle		VARCHAR2
  ,	pv_item_rating			VARCHAR2
  ,	pv_release_date			DATE
  , pv_created_by			NUMBER   := 1
  , pv_creation_date		DATE     := SYSDATE
  , pv_last_updated_by		NUMBER   := 1
  , pv_last_update_date		DATE     := SYSDATE) IS
  
BEGIN  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  INSERT INTO item
  ( item_id
  , item_barcode
  , item_type
  , item_title
  , item_subtitle
  ,	item_rating
  ,	release_date
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( item_s1.NEXTVAL
  ,	pv_item_barcode
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'ITEM'
    AND      common_lookup_type = pv_item_type)
  , pv_item_title
  , pv_item_subtitle
  ,	pv_item_rating
  ,	pv_release_date  
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_item;
/

EXECUTE insert_item('043396052765','DVD_WIDE_SCREEN','Monty Python and the Holy Grail','','PG',(SYSDATE - 15));
EXECUTE insert_item('024543160892','DVD_WIDE_SCREEN','Office Space','','R',(SYSDATE - 15));
EXECUTE insert_item('027616865731','DVD_WIDE_SCREEN','Princess Bride, The','','PG',(SYSDATE - 15));

-- Display any compilation errors.
SHOW ERRORS

-- B.) Insert a new member with three new related contacts.

-- PLSQL Statement Insertion
CREATE OR REPLACE PROCEDURE insert_three_contacts
  (	pv_member_type         VARCHAR2
  , pv_account_number      VARCHAR2
  ,	pv_credit_card_number  VARCHAR2
  ,	pv_credit_card_type    VARCHAR2
  ,	pv_first_name          VARCHAR2
  ,	pv_middle_name         VARCHAR2 := ''
  ,	pv_last_name           VARCHAR2
  ,	pv_first_name_2        VARCHAR2
  ,	pv_middle_name_2       VARCHAR2 := ''
  ,	pv_last_name_2         VARCHAR2
  ,	pv_first_name_3        VARCHAR2
  ,	pv_middle_name_3       VARCHAR2 := ''
  ,	pv_last_name_3         VARCHAR2
  ,	pv_contact_type        VARCHAR2
  ,	pv_address_type        VARCHAR2
  ,	pv_city                VARCHAR2
  ,	pv_state_province      VARCHAR2
  ,	pv_postal_code         VARCHAR2
  ,	pv_street_address      VARCHAR2
  ,	pv_telephone_type      VARCHAR2
  ,	pv_country_code        VARCHAR2
  ,	pv_area_code           VARCHAR2
  ,	pv_telephone_number    VARCHAR2
  ,	pv_created_by          NUMBER   := 1
  ,	pv_creation_date       DATE     := SYSDATE
  ,	pv_last_updated_by     NUMBER   := 1
  ,	pv_last_update_date    DATE     := SYSDATE) IS

  -- Local variables, to leverage subquery assignments in INSERT statements.
	lv_address_type        VARCHAR2(30);
	lv_contact_type        VARCHAR2(30);
	lv_credit_card_type    VARCHAR2(30);
	lv_member_type         VARCHAR2(30);
	lv_telephone_type      VARCHAR2(30);
  
BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
	lv_address_type := pv_address_type;
	lv_contact_type := pv_contact_type;
	lv_credit_card_type := pv_credit_card_type;
	lv_member_type := pv_member_type;
	lv_telephone_type := pv_telephone_type;
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = lv_member_type)
  , pv_account_number
  , pv_credit_card_number
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = lv_credit_card_type)
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = lv_contact_type)
  , pv_first_name
  , pv_middle_name
  , pv_last_name
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );
  
    INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , pv_street_address
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  
  dbms_output.put_line('c5');
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = lv_contact_type)
  , pv_first_name_2
  , pv_middle_name_2
  , pv_last_name_2
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , pv_street_address
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  
  dbms_output.put_line('c5');
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = lv_contact_type)
  , pv_first_name_3
  , pv_middle_name_3
  , pv_last_name_3
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , pv_street_address
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  
  dbms_output.put_line('c5');
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE  
  
  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_three_contacts;
/

EXECUTE insert_three_contacts('GROUP','R11-514-44','8675-0309-8675-0309','VISA_CARD','Harry','','Potter','Ginny','','Potter','Lily','Luna','Potter','CUSTOMER','HOME','Provo','Utah','84602','24 Grosvenor Square','HOME','001','773','202-5862');

-- Display any compilation errors.
SHOW ERRORS

-- C.) Insert three new rows in the RENTAL and RENTAL_ITEM tables.

SELECT * FROM rental;

-- PLSQL Statement Insertion
CREATE OR REPLACE PROCEDURE checkout_item
  (	pv_first_name			VARCHAR2
  ,	pv_last_name			VARCHAR2
  , pv_item_title			VARCHAR2
  , pv_rental_length		VARCHAR2
  , pv_created_by			NUMBER   := 1
  , pv_creation_date		DATE     := SYSDATE
  , pv_last_updated_by		NUMBER   := 1
  , pv_last_update_date		DATE     := SYSDATE) IS
  
BEGIN  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  INSERT INTO rental
  ( rental_id
  , customer_id
  , check_out_date
  , return_date
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( rental_s1.NEXTVAL
  ,(SELECT   contact_id
    FROM     contact
    WHERE    last_name = pv_last_name
    AND      first_name = pv_first_name)
  , pv_creation_date
  , pv_creation_date + pv_rental_length
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date);
  
  INSERT INTO rental_item
  ( rental_item_id
  , rental_id
  , item_id
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( rental_item_s1.NEXTVAL
  ,	rental_s1.CURRVAL
  ,(SELECT   item_id
    FROM     item
    WHERE    item_title = pv_item_title) 
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END checkout_item;
/

EXECUTE checkout_item('Harry','Potter','Monty Python and the Holy Grail','1');
EXECUTE checkout_item('Ginny','Potter','Office Space','3');
EXECUTE checkout_item('Lily','Potter','Princess Bride, The','5');


-- Display any compilation errors.
SHOW ERRORS

SELECT * FROM rental;

-- Point 4
-- Modify the design of the COMMON_LOOKUP table, insert new data into the 
-- model, and update old non-compliant design data in the model.

-- Point 4.1
ALTER TABLE common_lookup
	ADD (common_lookup_table VARCHAR(30))
	ADD (common_lookup_column VARCHAR(30))
	ADD (common_lookup_code VARCHAR(30))
;

-- Point 4.2
UPDATE   common_lookup
SET      common_lookup_table = 'SYSTEM_USER'
,        common_lookup_column = 'SYSTEM_USER_GROUP_ID'
WHERE    common_lookup_context = 'SYSTEM_USER'
;

UPDATE   common_lookup
SET      common_lookup_table = 'CONTACT'
,        common_lookup_column = 'CONTACT_TYPE'
WHERE    common_lookup_context = 'CONTACT'
;

UPDATE   common_lookup
SET      common_lookup_table = 'MEMBER'
,        common_lookup_column = 'MEMBER_TYPE'
WHERE    common_lookup_context = 'MEMBER' AND common_lookup_type = 'INDIVIDUAL' OR common_lookup_type = 'GROUP'
;

UPDATE   common_lookup
SET      common_lookup_table = 'MEMBER'
,        common_lookup_column = 'CREDIT_CARD_TYPE'
WHERE    common_lookup_context = 'MEMBER' AND common_lookup_type LIKE '%_CARD'
;

UPDATE   common_lookup
SET      common_lookup_table = 'ADDRESS'
,        common_lookup_column = 'ADDRESS_TYPE'
WHERE    common_lookup_context = 'MULTIPLE'
;

UPDATE   common_lookup
SET      common_lookup_table = 'ITEM'
,        common_lookup_column = 'ITEM_TYPE'
WHERE    common_lookup_context = 'ITEM'
;

-- Point 4.3
-- Drop the unique index on COMMON_LOOKUP_CONTEXT and COMMON_LOOKUP_TYPE 
-- columns.

DROP INDEX common_lookup_u2
;

-- Point 4.4
-- Add two new rows to the COMMON_LOOKUP table to support the 
-- TELEPHONE_TYPE column, which should no longer reference the rows 
-- previously shared with the ADDRESS table.

  INSERT INTO common_lookup
  SELECT 	common_lookup_s1.NEXTVAL
  ,			common_lookup_context
  ,			common_lookup_type
  ,			common_lookup_meaning
  ,			1
  ,			SYSDATE
  ,			1
  ,			SYSDATE
  ,			'TELEPHONE'
  ,			'TELEPHONE_TYPE'
  ,			NULL
  FROM		common_lookup
  WHERE		common_lookup_table = 'ADDRESS'
  ;
  
-- Point 4.5

  UPDATE telephone
	SET telephone_type = (
		SELECT common_lookup_id
		FROM common_lookup
		WHERE common_lookup_type = 'HOME' AND common_lookup_table = 'TELEPHONE')
	WHERE telephone_type = ( 
		SELECT common_lookup_id
		FROM common_lookup
		WHERE common_lookup_type = 'HOME' AND common_lookup_table = 'ADDRESS');

-- Point 4.6  
  ALTER TABLE common_lookup
	DROP COLUMN common_lookup_context
  ;

-- Point 4.7  
  ALTER TABLE common_lookup
	MODIFY (common_lookup_table CONSTRAINT nn_clookup_8 NOT NULL)
	MODIFY (common_lookup_column CONSTRAINT nn_clookup_9 NOT NULL)
  ;

-- Point 4.8
  CREATE UNIQUE INDEX common_lookup_u1 
	ON common_lookup (common_lookup_table, common_lookup_column, common_lookup_type)
  ;
  
-- Point 5
-- Insert two new rows into the COMMON_LOOKUP table to support the 
-- ACTIVE_FLAG column in the PRICE table.

  INSERT INTO common_lookup
  (	common_lookup_id
  ,	common_lookup_type
  ,	common_lookup_meaning
  ,	created_by
  ,	creation_date
  ,	last_updated_by
  ,	last_update_date
  ,	common_lookup_table
  ,	common_lookup_column
  ,	common_lookup_code )
  VALUES
  (	common_lookup_s1.NEXTVAL
  ,	'YES'
  ,	'Yes'
  ,	1
  ,	SYSDATE
  ,	1
  ,	SYSDATE
  ,	'PRICE'
  ,	'ACTIVE_FLAG'
  ,	'Y' )
  ;
  
  INSERT INTO common_lookup
  (	common_lookup_id
  ,	common_lookup_type
  ,	common_lookup_meaning
  ,	created_by
  ,	creation_date
  ,	last_updated_by
  ,	last_update_date
  ,	common_lookup_table
  ,	common_lookup_column
  ,	common_lookup_code )
  VALUES
  (	common_lookup_s1.NEXTVAL
  ,	'NO'
  ,	'No'
  ,	1
  ,	SYSDATE
  ,	1
  ,	SYSDATE
  ,	'PRICE'
  ,	'ACTIVE_FLAG'
  ,	'N' )
  ;

-- Point 6
-- Insert three new rows into the COMMON_LOOKUP table to support the 
-- PRICE_TYPE column in the PRICE table.
  
  INSERT INTO common_lookup
  (	common_lookup_id
  ,	common_lookup_type
  ,	common_lookup_meaning
  ,	created_by
  ,	creation_date
  ,	last_updated_by
  ,	last_update_date
  ,	common_lookup_table
  ,	common_lookup_column
  ,	common_lookup_code )
  VALUES
  (	common_lookup_s1.NEXTVAL
  ,	'1-DAY RENTAL'
  ,	'1-Day Rental'
  ,	1
  ,	SYSDATE
  ,	1
  ,	SYSDATE
  ,	'PRICE'
  ,	'PRICE_TYPE'
  ,	'1' )
  ;

  INSERT INTO common_lookup
  (	common_lookup_id
  ,	common_lookup_type
  ,	common_lookup_meaning
  ,	created_by
  ,	creation_date
  ,	last_updated_by
  ,	last_update_date
  ,	common_lookup_table
  ,	common_lookup_column
  ,	common_lookup_code )
  VALUES
  (	common_lookup_s1.NEXTVAL
  ,	'3-DAY RENTAL'
  ,	'3-Day Rental'
  ,	1
  ,	SYSDATE
  ,	1
  ,	SYSDATE
  ,	'PRICE'
  ,	'PRICE_TYPE'
  ,	'3' )
  ;
	
  INSERT INTO common_lookup
  (	common_lookup_id
  ,	common_lookup_type
  ,	common_lookup_meaning
  ,	created_by
  ,	creation_date
  ,	last_updated_by
  ,	last_update_date
  ,	common_lookup_table
  ,	common_lookup_column
  ,	common_lookup_code )
  VALUES
  (	common_lookup_s1.NEXTVAL
  ,	'5-DAY RENTAL'
  ,	'5-Day Rental'
  ,	1
  ,	SYSDATE
  ,	1
  ,	SYSDATE
  ,	'PRICE'
  ,	'PRICE_TYPE'
  ,	'5' )
  ;
  
-- Point 7
-- Add the following two columns to the RENTAL_ITEM table to support 
-- linking the price of rentals to the number of days an item is rented.

  ALTER TABLE rental_item
	ADD (rental_item_type NUMBER)
	ADD (rental_item_price NUMBER)
	ADD CONSTRAINT fk_rental_item_5 FOREIGN KEY (rental_item_type) REFERENCES common_lookup(common_lookup_id)
  ;
	
  UPDATE   rental_item ri
  SET      rental_item_type =
  (	SELECT   cl.common_lookup_id
	FROM     common_lookup cl
	WHERE    cl.common_lookup_code = CAST (
    (	SELECT   r.return_date - r.check_out_date
		FROM     rental r
		WHERE    r.rental_id = ri.rental_id) AS CHAR(1)))
  ;
  
  ALTER TABLE rental_item  
	MODIFY (rental_item_type CONSTRAINT nn_rental_item_7 NOT NULL)
  ;
  
-- Point 8
-- You need to insert all price records with a single subquery to an 
-- INSERT statement.

   INSERT
	INTO    price
	(SELECT   price_s1.NEXTVAL         -- PRICE_ID
		 , i.item_id                       -- ITEM_ID
		 ,CASE
			WHEN fab2.rental_item_type = '1-DAY RENTAL'
				THEN
				  (SELECT   cl.common_lookup_id    -- PRICE_TYPE
				   FROM     common_lookup cl
				   WHERE    cl.common_lookup_type = '1-DAY RENTAL')
			WHEN fab2.rental_item_type = '3-DAY RENTAL'
				THEN
				  (SELECT   cl.common_lookup_id    -- PRICE_TYPE
				   FROM     common_lookup cl
				   WHERE    cl.common_lookup_type = '3-DAY RENTAL')
			WHEN fab2.rental_item_type = '5-DAY RENTAL'
				THEN
				  (SELECT   cl.common_lookup_id    -- PRICE_TYPE
				   FROM     common_lookup cl
				   WHERE    cl.common_lookup_type = '5-DAY RENTAL')
		  END
		 ,  CASE                            -- ACTIVE_FLAG
				WHEN fab.active_flag = 'Y'
					THEN 'Y'
				ELSE 'N'
			END
		 , CASE                   -- START_DATE
			WHEN fab.active_flag = 'Y'
				THEN
					CASE
						WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
							THEN TRUNC(i.release_date)
						ELSE TRUNC(i.release_date) + 31	
					END
			WHEN fab.active_flag = 'N'
				THEN
					CASE
						WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
							THEN TRUNC(i.release_date) + 31
						ELSE TRUNC(i.release_date)
					END
		   END
		 , CASE                   -- END_DATE
				WHEN fab.active_flag = 'Y'
					THEN NULL
				WHEN fab.active_flag = 'N'
					THEN TRUNC(i.release_date) + 30
			END
		 ,CASE
			WHEN fab2.rental_item_type = '1-DAY RENTAL'
				THEN
					(SELECT   
						CASE                   -- AMOUNT
							WHEN fab.active_flag = 'Y'
								THEN
									CASE
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
											THEN 3
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 31
											THEN TO_NUMBER(cl.common_lookup_code)
									END
							WHEN fab.active_flag = 'N'
								THEN
									CASE
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
											THEN TO_NUMBER(cl.common_lookup_code)
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 31
											THEN 3
									END		
						END
					FROM   common_lookup cl
					WHERE   cl.common_lookup_type = '1-DAY RENTAL')
			WHEN fab2.rental_item_type = '3-DAY RENTAL'
				THEN
					(SELECT   
						CASE                   -- AMOUNT
							WHEN fab.active_flag = 'Y'
								THEN
									CASE
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
											THEN 10
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 31
											THEN TO_NUMBER(cl.common_lookup_code)
									END
							WHEN fab.active_flag = 'N'
								THEN
									CASE
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
											THEN TO_NUMBER(cl.common_lookup_code)
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 31
											THEN 10
									END		
						END
					FROM   common_lookup cl
					WHERE   cl.common_lookup_type = '3-DAY RENTAL')
			WHEN fab2.rental_item_type = '5-DAY RENTAL'
				THEN
					(SELECT   
						CASE                   -- AMOUNT
							WHEN fab.active_flag = 'Y'
								THEN
									CASE
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
											THEN 15
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 31
											THEN TO_NUMBER(cl.common_lookup_code)
									END
							WHEN fab.active_flag = 'N'
								THEN
									CASE
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
											THEN TO_NUMBER(cl.common_lookup_code)
										WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 31
											THEN 15
									END		
						END
					FROM   common_lookup cl
					WHERE   cl.common_lookup_type = '5-DAY RENTAL')
		  END
		 , 1                               -- CREATED_BY
		 , SYSDATE                         -- CREATION_DATE
		 , 1                               -- LAST_UPDATED_BY
		 , SYSDATE                         -- LAST_UPDATE_DATE
	 FROM   
		item i 
			CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
			UNION ALL
         SELECT 'N' AS active_flag FROM dual) fab  
			CROSS JOIN
        (SELECT '1-DAY RENTAL' AS rental_item_type FROM dual
			UNION ALL
         SELECT '3-DAY RENTAL' AS rental_item_type FROM dual
			UNION ALL
		 SELECT '5-DAY RENTAL' AS rental_item_type FROM dual) fab2
	 WHERE fab.active_flag = 'N' 
		AND (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30 
		OR fab.active_flag = 'Y' 
	 )
	 ;
	 
-- Verify the INSERT
	SELECT  'OLD Y' AS "Type"
	,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
	,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
	,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
	,        COUNT(*) AS "TOTAL"
	FROM     price p , item i
	WHERE    active_flag = 'Y'
	AND      i.item_id = p.item_id
	AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
	AND      end_date IS NULL
	UNION ALL
	SELECT  'OLD N' AS "Type"
	,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
	,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
	,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
	,        COUNT(*) AS "TOTAL"
	FROM     price p , item i
	WHERE    active_flag = 'N'
	AND      i.item_id = p.item_id
	AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
	AND NOT (end_date IS NULL)
	UNION ALL
	SELECT  'NEW Y' AS "Type"
	,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
	,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
	,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
	,        COUNT(*) AS "TOTAL"
	FROM     price p , item i
	WHERE    active_flag = 'Y'
	AND      i.item_id = p.item_id
	AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
	AND      end_date IS NULL
	UNION ALL
	SELECT  'NEW N' AS "Type"
	,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
	,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
	,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
	,        COUNT(*) AS "TOTAL"
	FROM     price p , item i
	WHERE    active_flag = 'N'
	AND      i.item_id = p.item_id
	AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
	AND NOT (end_date IS NULL);

-- Point 9
-- Add the NOT NULL constraint on the PRICE_TYPE column in the PRICE table.

  ALTER TABLE price  
	MODIFY (price_type CONSTRAINT nn_price_4 NOT NULL)
  ;
  
-- Point 10
-- The following query should update twelve rows in the RENTAL_ITEM table.

	UPDATE   rental_item ri
	SET      ri.rental_item_price =
           (SELECT   p.amount
            FROM     price p CROSS JOIN rental r
            WHERE    p.item_id = ri.item_id
			AND      p.price_type = ri.rental_item_type
            AND      r.rental_id = ri.rental_id
            AND      r.check_out_date
                       BETWEEN p.start_date
					   AND NVL(p.end_date, SYSDATE));
					   
	COMMIT;
	
	ALTER TABLE rental_item  
		MODIFY (rental_item_price CONSTRAINT nn_rental_item_8 NOT NULL)
	;	
					   
	SELECT   ri.rental_item_id, ri.rental_item_price, p.amount
	FROM     price p JOIN rental_item ri 
	ON       p.item_id = ri.item_id AND p.price_type = ri.rental_item_type
	JOIN     rental r ON ri.rental_id = r.rental_id
	WHERE    r.check_out_date BETWEEN p.start_date AND NVL(p.end_date, SYSDATE)
	ORDER BY 1;
	
	


SPOOL OFF