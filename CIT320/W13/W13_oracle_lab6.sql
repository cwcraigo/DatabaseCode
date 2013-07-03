
-- Run lab 5
@ ..\lib\create_oracle_store.sql
@ ..\lib\seed_oracle_store.sql

-- Open log file
SPOOL W13_oracle_lab6.txt

-- --------------------
-- 1
-- --------------------

-- Change ITEM_RELEASE_DATE to RELEASE_DATE
ALTER TABLE item RENAME COLUMN item_release_date TO release_date;

-- --------------------
-- 2
-- --------------------

-- Conditionally drop table and sequence.-------------------------
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
/

-- Create price---------------------------------------------------
CREATE TABLE price
(price_id			NUMBER
,item_id			NUMBER		CONSTRAINT nn_price_1 NOT NULL
,price_type			NUMBER		-- CONSTRAINT nn_price_2 NOT NULL
,active_flag		VARCHAR2(1)	CONSTRAINT nn_price_3 NOT NULL
,start_date			DATE		CONSTRAINT nn_price_4 NOT NULL
,end_date			DATE
,amount				NUMBER
,created_by			NUMBER		CONSTRAINT nn_price_5 NOT NULL
,creation_date		DATE		CONSTRAINT nn_price_6 NOT NULL
,last_updated_by	NUMBER		CONSTRAINT nn_price_7 NOT NULL
,last_update_date	DATE		CONSTRAINT nn_price_8 NOT NULL
,CONSTRAINT	pk_price_1 PRIMARY KEY (price_id)
,CONSTRAINT fk_price_1 FOREIGN KEY (item_id)
	REFERENCES	item(item_id)
-- price_type fk_price_2-----put in after step 7.
,CONSTRAINT cc_price_1 CHECK (active_flag IN ('Y', 'N'))
,CONSTRAINT fk_price_3 FOREIGN KEY (created_by)
	REFERENCES	system_user(system_user_id)
,CONSTRAINT fk_price_4 FOREIGN KEY (last_updated_by)
	REFERENCES	system_user(system_user_id)
,CONSTRAINT cc_price_2 CHECK (end_date = (start_date + 30))
);

-- Create a sequence-------------------------------------------
CREATE SEQUENCE price_s1 START WITH 1001;

-- ------------------------------------------------------------
-- STEP 3
-- ------------------------------------------------------------

-- 	 Insert into ITEM table
--   	three new DVD's
-- 		release_date LESS THAN 15 days from lab due date
INSERT INTO item
VALUES
( item_s1.nextval
,'9999-00000-1'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Craig W. Christensen','Defender of Catan','R'
, SYSDATE - 15
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item
VALUES
( item_s1.nextval
,'9999-00000-2'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Claire Brielle Christensen','My Daughter','G'
, SYSDATE - 15
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item
VALUES
( item_s1.nextval
,'9999-00000-3'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Kimberly A. Christensen','My Wife','PG-13'
, SYSDATE - 15
, 3, SYSDATE, 3, SYSDATE);

-- 	 Insert into MEMBER table------------------------------------
--   	Harry, Ginny, Lily Luna Potter.--------------------------
-- 		Address is Provo,Utah------------------------------------

-- Harry Potter--------------------------------------------------
INSERT INTO member
VALUES
( member_s1.nextval
, (SELECT   common_lookup_id
   FROM     common_lookup
   WHERE    common_lookup_type = 'CUSTOMER')
,'A111-00000'
,'2222-3333-4444-5555'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Harry','','Potter'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Ginny','','Potter'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Lily','Luna','Potter'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','84604'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'123 Mormon Ave.'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','555-5555'
, 2, SYSDATE, 2, SYSDATE);

-- Ginny Potter-------------------------------------------------
INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','84604'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'123 Mormon Ave.'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','555-5555'
, 2, SYSDATE, 2, SYSDATE);

-- Lila Luna Potter--------------------------------------------------------
INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','84604'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'123 Mormon Ave.'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','555-5555'
, 2, SYSDATE, 2, SYSDATE);

-- 	 Insert into RENTAL and RENTAL_ITEM--------------------
--  	They are renting your 3 DVD's --------------------
-- 		One rent for 1-day, another for 3-day, last for 5-days

-- Inserts into rental----------------------------------------
INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, SYSDATE, SYSDATE + 1
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, SYSDATE, SYSDATE + 3
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

-- Inserts into rental item-----------------------------------
INSERT INTO rental_item
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r, contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i, common_lookup cl
  WHERE    i.item_title = 'Craig W. Christensen'
  AND      i.item_subtitle = 'Defender of Catan'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r, contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Ginny')
,(SELECT   i.item_id
  FROM     item i, common_lookup cl
  WHERE    i.item_title = 'Kimberly A. Christensen'
  AND      i.item_subtitle = 'My Wife'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r, contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Lily')
,(SELECT   i.item_id
  FROM     item i, common_lookup cl
  WHERE    i.item_title = 'Claire Brielle Christensen'
  AND      i.item_subtitle = 'My Daughter'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_FULL_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------
-- STEP 4 - MODIFY COMMON_LOOKUP
-- ------------------------------------------------------------

-- 	Drop unique indexs----------------------------------------
DROP INDEX common_lookup_u2;

-- 	Add 3 new columns to COMMON_LOOKUP
ALTER TABLE common_lookup
   ADD    (common_lookup_table   VARCHAR2(30))
   ADD    (common_lookup_column  VARCHAR2(30))
   ADD    (common_lookup_code    VARCHAR2(30));

-- 	Migrate data and seed new columns---------------------------
UPDATE common_lookup
	SET common_lookup_table =
	    CASE
			WHEN common_lookup_context='MULTIPLE' THEN 'TELEPHONE'
			ELSE common_lookup_context
		END
	, common_lookup_column =
		CASE
			WHEN common_lookup_context='MULTIPLE' THEN 'TELEPHONE_TYPE'
			ELSE CONCAT(common_lookup_context, '_TYPE')
		END;

-- 	NOT NULL on appropriate columns-----------------------------
ALTER TABLE common_lookup
	ADD CONSTRAINT nn_clookup_8
		CHECK (common_lookup_table IS NOT NULL)
	ADD CONSTRAINT nn_clookup_9
		CHECK (common_lookup_column IS NOT NULL);

-- 	Unique indexs----------------------------------------
CREATE INDEX common_lookup_u2
	ON common_lookup
	(common_lookup_table,common_lookup_column,common_lookup_type);

-- 	Drop not used column----------------------------------------
ALTER TABLE common_lookup
	DROP COLUMN common_lookup_context;

-- Add ADDRESS to COMMON_LOOKUP---------------------------------
INSERT INTO common_lookup
SELECT
  common_lookup_s1.nextval
, t
, m
, 1
, SYSDATE
, 1
, SYSDATE
,'ADDRESS'
,'ADDRESS_TYPE'
, null
FROM
(select 'HOME' as t, 'Home' as m from dual
union all
select 'WORK', 'Work' from dual);

-- Update address table to point to correct common_lookup------
UPDATE   address
	SET		address_type = 1017
	WHERE   address_type = 1008;

UPDATE   address
	SET		address_type = 1018
	WHERE   address_type = 1009;

-- ------------------------------------------------------------
-- STEP 5
-- ------------------------------------------------------------

-- Insert 2 rows into common_lookup for active_flag------------
INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
,'YES'
,'Yes'
, 1
, SYSDATE
, 1
, SYSDATE
,'PRICE'
,'ACTIVE_FLAG'
, 'Y'
);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
,'NO'
,'No'
, 1
, SYSDATE
, 1
, SYSDATE
,'PRICE'
,'ACTIVE_FLAG'
, 'N'
);

-- ------------------------------------------------------------
-- 6
-- ------------------------------------------------------------

-- Insert 3 rows into common_lookup table
INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
,'1-DAY RENTAL'
,'1-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
,'PRICE'
,'PRICE_TYPE'
, '1'
);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
,'3-DAY RENTAL'
,'3-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
,'PRICE'
,'PRICE_TYPE'
, '3'
);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
,'5-DAY RENTAL'
,'5-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
,'PRICE'
,'PRICE_TYPE'
, '5'
);

-- ------------------------------------------------------------
-- 7
-- ------------------------------------------------------------

-- Add columns to RENTAL_ITEM
ALTER TABLE rental_item
	ADD (rental_item_type NUMBER)
	ADD (rental_item_price NUMBER)
	ADD CONSTRAINT fk_rental_item_5 FOREIGN KEY (rental_item_type)
		REFERENCES common_lookup(common_lookup_id);

-- Update rental_item_type
UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   CAST(r.return_date - r.check_out_date AS VARCHAR2(30))
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id));

-- Part of step 2
ALTER TABLE price
	ADD CONSTRAINT fk_price_2 FOREIGN KEY (price_type)
	REFERENCES	common_lookup(common_lookup_id);

-- ------------------------------------------------------------------
-- STEP 8:
-- ------------------------------------------------------------------

INSERT
INTO	price
(price_id
,item_id
,price_type
,active_flag
,amount
,start_date
,end_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
SELECT
   price_s1.NEXTVAL					-- price_id
 , i.item_id						-- item_id
 , pt.lookup_type						-- price_type
 , af.active_flag						-- active_flag
 , (SELECT
 	CASE                   			-- amount
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
			AND pt.lookup_type = 1021 AND af.active_flag = 'Y'
				THEN 3
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
			AND pt.lookup_type = 1022 AND af.active_flag = 'Y'
				THEN 10
        WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
			AND pt.lookup_type = 1023 AND af.active_flag = 'Y'
				THEN 15
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
			AND pt.lookup_type = 1021 AND af.active_flag = 'N'
				THEN 1
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
			AND pt.lookup_type = 1022 AND af.active_flag = 'N'
				THEN 3
        WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
			AND pt.lookup_type = 1023 AND af.active_flag = 'N'
				THEN 5
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
			AND pt.lookup_type = 1021 AND af.active_flag = 'Y'
				THEN 1
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
			AND pt.lookup_type = 1022 AND af.active_flag = 'Y'
				THEN 3
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
			AND pt.lookup_type = 1023 AND af.active_flag = 'Y'
				THEN 5
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
			AND pt.lookup_type = 1021 AND af.active_flag = 'N'
				THEN 3
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
			AND pt.lookup_type = 1022 AND af.active_flag = 'N'
				THEN 10
		WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
			AND pt.lookup_type = 1023 AND af.active_flag = 'N'
				THEN 15
        ELSE TO_NUMBER(cl.common_lookup_code)
    END
   FROM   common_lookup cl
   WHERE   cl.common_lookup_id = pt.lookup_type
   )
 , CASE                            						-- start_date
     WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
       THEN i.release_date
       ELSE i.release_date + 31
   END
 , CASE
    WHEN af.active_flag = 'Y' THEN NULL
    WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
     	AND af.active_flag = 'N'
     		THEN i.release_date + 30
    WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
     	AND af.active_flag = 'N'
     		THEN i.release_date + 61
END
 , 1									-- created_by
 , SYSDATE								-- creation_date
 , 1									-- last_updated_by
 , SYSDATE								-- last_update_date
 FROM
(SELECT common_lookup_id  AS lookup_type FROM common_lookup WHERE common_lookup_column='PRICE_TYPE') pt CROSS JOIN
(SELECT common_lookup_code AS active_flag FROM common_lookup WHERE common_lookup_column='ACTIVE_FLAG') af CROSS JOIN
item i WHERE NOT ( (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31 AND af.active_flag='N');


-- VALIDATION QUERY
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

-- ------------------------------------------------------------
-- 9
-- ------------------------------------------------------------

-- Add not null on price_type in price
ALTER TABLE price
	ADD CONSTRAINT nn_price_2
		CHECK (price_type IS NOT NULL);

-- update all dates
UPDATE price
SET start_date = TRUNC(start_date)
, end_date = TRUNC(end_date);

-- ------------------------------------------------------------
-- 10
-- ------------------------------------------------------------

-- Update rental_item
UPDATE   rental_item ri
SET      rental_item_price =
           (SELECT   p.amount
            FROM     price p CROSS JOIN rental r
            WHERE    p.item_id = ri.item_id
            AND      ri.rental_id = r.rental_id
            AND      TRUNC(r.check_out_date)
                       BETWEEN p.start_date AND NVL(p.end_date, TRUNC(SYSDATE))
            AND   p.price_type = ri.rental_item_type);

-- Validation of above update
SELECT   ri.rental_item_id, ri.rental_item_price, p.amount
FROM     price p JOIN rental_item ri
ON       p.item_id = ri.item_id AND p.price_type = ri.rental_item_type
JOIN     rental r ON ri.rental_id = r.rental_id
WHERE    r.check_out_date BETWEEN p.start_date AND NVL(p.end_date, SYSDATE)
ORDER BY 1;

-- Add not null to rental_item_price in step 7
ALTER TABLE rental_item
	ADD CONSTRAINT nn_rental_item_7
		CHECK (rental_item_price IS NOT NULL);


-- Close log file.---------------------------------------------
SPOOL OFF





