




-- Run lab 5
\. ../lib/W13_create_mysql_store.sql
\. ../lib/W13_seed_mysql_store.sql

-- Open log file
TEE W13_mysql_lab6.txt

-- --------------------
-- 1
-- --------------------

SELECT 'release_date' AS 'CHANGE COLUMN';
-- Change ITEM_RELEASE_DATE to RELEASE_DATE
ALTER TABLE item
  CHANGE COLUMN item_release_date release_date DATE;

-- --------------------
-- 2
-- --------------------
SELECT 'PRICE' AS 'DROP/CREATE TABLE';
-- Conditionally drop table and sequence.-------------------------
DROP TABLE IF EXISTS price;

-- Create price---------------------------------------------------
CREATE TABLE price
(price_id         INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
,item_id          INT UNSIGNED  NOT NULL
,price_type       INT UNSIGNED
,active_flag      VARCHAR(1)    NOT NULL
,start_date       DATE          NOT NULL
,end_date         DATE
,amount           INT UNSIGNED
,created_by       INT UNSIGNED  NOT NULL
,creation_date    DATE          NOT NULL
,last_updated_by  INT UNSIGNED  NOT NULL
,last_update_date DATE          NOT NULL
,CONSTRAINT fk_price_1 FOREIGN KEY (item_id)
  REFERENCES  item(item_id)
,CONSTRAINT fk_price_3 FOREIGN KEY (created_by)
  REFERENCES  system_user(system_user_id)
,CONSTRAINT fk_price_4 FOREIGN KEY (last_updated_by)
  REFERENCES  system_user(system_user_id));

-- ------------------------------------------------------------
-- STEP 3
-- ------------------------------------------------------------
SELECT 'item' AS 'INSERTS';
--   Insert into ITEM table
--    three new DVD's
--    release_date LESS THAN 15 days from lab due date
INSERT INTO item
(item_id
,item_barcode
,item_type
,item_title
,item_subtitle
,item_rating_id
,release_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
( NULL
,'9999-00000-1'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Craig W. Christensen','Defender of Catan'
,(SELECT rating_agency_id
  FROM rating_agency
  WHERE rating = 'R')
, DATE_SUB(NOW(), INTERVAL 15 DAY)
, 3, NOW(), 3, NOW());

INSERT INTO item
VALUES
( NULL
,'9999-00000-2'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Claire Brielle Christensen','My Daughter'
,(SELECT rating_agency_id
  FROM rating_agency
  WHERE rating = 'G')
, DATE_SUB(NOW(), INTERVAL 15 DAY)
, 3, NOW(), 3, NOW());

INSERT INTO item
VALUES
( NULL
,'9999-00000-3'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Kimberly A. Christensen','My Wife'
,(SELECT rating_agency_id
  FROM rating_agency
  WHERE rating = 'PG-13')
, DATE_SUB(NOW(), INTERVAL 15 DAY)
, 3, NOW(), 3, NOW());

--   Insert into MEMBER table------------------------------------
--    Harry, Ginny, Lily Luna Potter.--------------------------
--    Address is Provo,Utah------------------------------------

SELECT 'member' AS 'INSERT';
-- Harry Potter--------------------------------------------------
INSERT INTO member
VALUES
( NULL
,'A111-00000'
,'2222-3333-4444-5555'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, (SELECT   common_lookup_id
   FROM     common_lookup
   WHERE    common_lookup_type = 'CUSTOMER')
, 2, NOW(), 2, NOW());

SET @lv_member_id := last_insert_id();

SELECT 'contact - Harry' AS 'INSERT';
INSERT INTO contact VALUES
( NULL
, @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Harry','','Potter'
, 2, NOW(), 2, NOW());

SET @lv_harry_id := last_insert_id();

SELECT 'contact - Ginny' AS 'INSERT';
INSERT INTO contact VALUES
( NULL
, @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Ginny','','Potter'
, 2, NOW(), 2, NOW());

SET @lv_ginny_id := last_insert_id();

SELECT 'contact - Lily' AS 'INSERT';
INSERT INTO contact VALUES
( NULL
, @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Lily','Luna','Potter'
, 2, NOW(), 2, NOW());

SET @lv_lily_id := last_insert_id();

SELECT 'address - Harry' AS 'INSERT';
-- Harry Potter-------------------------------------------------
INSERT INTO address VALUES
( NULL
, @lv_harry_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','84604'
, 2, NOW(), 2, NOW());

SET @lv_address_id := last_insert_id();

SELECT 'street_address - Harry' AS 'INSERT';
INSERT INTO street_address VALUES
( NULL
, @lv_address_id
,'123 Mormon Ave.'
, 2, NOW(), 2, NOW());

SELECT 'telephone - Harry' AS 'INSERT';
INSERT INTO telephone VALUES
( NULL
, @lv_address_id
, @lv_harry_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','555-5555'
, 2, NOW(), 2, NOW());

-- Ginny Potter-------------------------------------------------
SELECT 'address - Ginny' AS 'INSERT';
INSERT INTO address VALUES
( NULL
, @lv_ginny_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','84604'
, 2, NOW(), 2, NOW());

SET @lv_address_id := last_insert_id();

SELECT 'street_address - Ginny' AS 'INSERT';
INSERT INTO street_address VALUES
( NULL
, @lv_address_id
,'123 Mormon Ave.'
, 2, NOW(), 2, NOW());

SELECT 'telephone - Ginny' AS 'INSERT';
INSERT INTO telephone VALUES
( NULL
, @lv_address_id
, @lv_ginny_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','555-5555'
, 2, NOW(), 2, NOW());

-- Lila Luna Potter--------------------------------------------------------
SELECT 'address - Lily' AS 'INSERT';
INSERT INTO address VALUES
( NULL
, @lv_lily_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','84604'
, 2, NOW(), 2, NOW());

SET @lv_address_id := last_insert_id();

SELECT 'street_address - Lily' AS 'INSERT';
INSERT INTO street_address VALUES
( NULL
, @lv_address_id
,'123 Mormon Ave.'
, 2, NOW(), 2, NOW());

SELECT 'telephone - Lily' AS 'INSERT';
INSERT INTO telephone VALUES
( NULL
, @lv_address_id
, @lv_lily_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','555-5555'
, 2, NOW(), 2, NOW());

--   Insert into RENTAL and RENTAL_ITEM--------------------
--    They are renting your 3 DVD's --------------------
--    One rent for 1-day, another for 3-day, last for 5-days

-- Inserts into rental----------------------------------------
SELECT 'rental - Harry' AS 'INSERT';
INSERT INTO rental VALUES
( NULL
, @lv_harry_id
, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)
, 3, NOW(), 3, NOW());

SELECT 'rental - Ginny' AS 'INSERT';
INSERT INTO rental VALUES
( NULL
, @lv_ginny_id
, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)
, 3, NOW(), 3, NOW());

SELECT 'rental - Lily' AS 'INSERT';
INSERT INTO rental VALUES
( NULL
, @lv_lily_id
, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY)
, 3, NOW(), 3, NOW());

-- Inserts into rental item-----------------------------------
SELECT 'rental_item - Harry' AS 'INSERT';
INSERT INTO rental_item
VALUES
( NULL
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
, 3, NOW(), 3, NOW());

SELECT 'rental_item - Ginny' AS 'INSERT';
INSERT INTO rental_item
VALUES
( NULL
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
, 3, NOW(), 3, NOW());

SELECT 'rental_item - Lily' AS 'INSERT';
INSERT INTO rental_item
VALUES
( NULL
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
, 3, NOW(), 3, NOW());

-- ------------------------------------------------------------
-- STEP 4 - MODIFY COMMON_LOOKUP
-- ------------------------------------------------------------
SELECT 'common_lookup_u2' AS 'DROP INDEX';
--  Drop unique indexs----------------------------------------
DROP INDEX common_lookup_u1 ON common_lookup;

SELECT 'common_lookup' AS 'ALTER TABLE';
--  Add 3 new columns to COMMON_LOOKUP
ALTER TABLE common_lookup
   ADD COLUMN common_lookup_table   VARCHAR(30)
  ,ADD COLUMN common_lookup_column  VARCHAR(30)
  ,ADD COLUMN common_lookup_code    VARCHAR(30);

--  Migrate data and seed new columns---------------------------
SELECT 'common_lookup' AS 'UPDATE';
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

--  NOT NULL on appropriate columns-----------------------------
SELECT 'common_lookup' AS 'ALTER';
ALTER TABLE common_lookup
  CHANGE COLUMN common_lookup_table common_lookup_table   VARCHAR(30) NOT NULL
 ,CHANGE COLUMN common_lookup_column common_lookup_column VARCHAR(30) NOT NULL;

--  Unique indexs----------------------------------------
SELECT 'common_lookup_u2' AS 'CREATE UNIQUE INDEX';
CREATE UNIQUE INDEX common_lookup_u2
  ON common_lookup
  (common_lookup_table,common_lookup_column,common_lookup_type);

--  Drop not used column----------------------------------------
SELECT 'common_lookup_context' AS 'DROP COLUMN';
ALTER TABLE common_lookup
  DROP COLUMN common_lookup_context;

-- Add ADDRESS to COMMON_LOOKUP---------------------------------
SELECT 'common_lookup' AS 'INSERT';
INSERT INTO common_lookup
(SELECT
  NULL
, t
, m
, 1
, NOW()
, 1
, NOW()
,'ADDRESS'
,'ADDRESS_TYPE'
, null
FROM
(select 'HOME' as t, 'Home' as m
union all
select 'WORK', 'Work') fab);

-- Update address table to point to correct common_lookup------
SELECT 'address' AS 'UPDATE';
UPDATE   address
  SET   address_type =
    CASE
      WHEN address_type = 1008 THEN 1017
      WHEN address_type = 1009 THEN 1018
      ELSE address_type
    END;

-- ------------------------------------------------------------
-- STEP 5 & 6
-- ------------------------------------------------------------

-- Insert 2 rows into common_lookup for active_flag------------
SELECT 'common_lookup' AS 'INSERT';
INSERT INTO common_lookup
(SELECT
  NULL
, cl_type
, cl_meaning
, 1
, NOW()
, 1
, NOW()
, cl_tab
, cl_col
, cl_code
FROM ((SELECT 'YES' AS cl_type
      ,      'Yes' AS cl_meaning
      ,      'PRICE' AS cl_tab
      ,      'ACTIVE_FLAG' AS cl_col
      ,      'Y' AS cl_code)
  UNION ALL
     (SELECT 'NO' AS cl_type
      ,      'No' AS cl_meaning
      ,      'PRICE' AS cl_tab
      ,      'ACTIVE_FLAG' AS cl_col
      ,      'N' AS cl_code)
  UNION ALL
     (SELECT '1-DAY RENTAL' AS cl_type
      ,      '1-Day Rental' AS cl_meaning
      ,      'PRICE' AS cl_tab
      ,      'PRICE_TYPE' AS cl_col
      ,      '1' AS cl_code)
  UNION ALL
     (SELECT '3-DAY RENTAL' AS cl_type
      ,      '3-Day Rental' AS cl_meaning
      ,      'PRICE' AS cl_tab
      ,      'PRICE_TYPE' AS cl_col
      ,      '3' AS cl_code)
  UNION ALL
     (SELECT '5-DAY RENTAL' AS cl_type
      ,      '5-Day Rental' AS cl_meaning
      ,      'PRICE' AS cl_tab
      ,      'PRICE_TYPE' AS cl_col
      ,      '5' AS cl_code)) fab);

-- ------------------------------------------------------------
-- 7
-- ------------------------------------------------------------
SELECT 'rental_item' AS 'ALTER';
-- Add columns to RENTAL_ITEM
ALTER TABLE rental_item
  ADD (rental_item_type INT UNSIGNED)
 ,ADD (rental_item_price INT UNSIGNED)
 ,ADD CONSTRAINT fk_rental_item_5 FOREIGN KEY (rental_item_type)
    REFERENCES common_lookup(common_lookup_id);

-- Update rental_item_type
SELECT 'rental_item' AS 'UPDATE';
UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   CAST(DATEDIFF(r.return_date, r.check_out_date) AS CHAR)
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id));

-- Part of step 2
SELECT 'price' AS 'ALTER';
ALTER TABLE price
  ADD CONSTRAINT fk_price_2 FOREIGN KEY (price_type)
  REFERENCES  common_lookup(common_lookup_id);

-- ------------------------------------------------------------------
-- STEP 8:
-- ------------------------------------------------------------------
SELECT 'PRICE' AS 'INSERT';
INSERT
INTO  price
(item_id
,price_type
,active_flag
,amount
,start_date
,end_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
(SELECT
   i.item_id                -- item_id
 , pt.lookup_type           -- price_type
 , af.active_flag           -- active_flag
 , (CASE                      -- amount
    WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
      AND pt.lookup_code = '1' AND af.active_flag = 'Y'
        THEN 3
    WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
      AND pt.lookup_code = '3' AND af.active_flag = 'Y'
        THEN 10
    WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
      AND pt.lookup_code = '5' AND af.active_flag = 'Y'
        THEN 15
    WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
      AND pt.lookup_code = '1' AND af.active_flag = 'N'
        THEN 3
    WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
      AND pt.lookup_code = '3' AND af.active_flag = 'N'
        THEN 10
    WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
      AND pt.lookup_code = '5' AND af.active_flag = 'N'
        THEN 15
    ELSE CAST(pt.lookup_code AS UNSIGNED)
   END)
 , (CASE                                        -- start_date
     WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
       THEN i.release_date
       ELSE DATE_ADD(i.release_date, INTERVAL 31 DAY)
   END)
 , (CASE
    WHEN af.active_flag = 'Y' THEN NULL
    WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
      AND af.active_flag = 'N'
        THEN DATE_ADD(i.release_date, INTERVAL 30 DAY)
    WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
      AND af.active_flag = 'N'
        THEN DATE_ADD(i.release_date, INTERVAL 61 DAY)
    END)
 , 1                  -- created_by
 , NOW()                -- creation_date
 , 1                  -- last_updated_by
 , NOW()                -- last_update_date
 FROM
(SELECT common_lookup_id   AS lookup_type
  ,     common_lookup_code AS lookup_code
  FROM  common_lookup
  WHERE common_lookup_column='PRICE_TYPE') pt
CROSS JOIN
(SELECT common_lookup_code AS active_flag
  FROM  common_lookup
  WHERE common_lookup_column='ACTIVE_FLAG') af
CROSS JOIN item i
WHERE NOT (DATEDIFF(UTC_DATE(), i.release_date) < 31
           AND af.active_flag='N'));


-- VALIDATION QUERY
SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y'
AND      i.item_id = p.item_id
AND     DATEDIFF(UTC_DATE(), i.release_date) > 30
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
AND     DATEDIFF(UTC_DATE(), i.release_date) > 30
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
AND     DATEDIFF(UTC_DATE(), i.release_date) < 31
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
AND     DATEDIFF(UTC_DATE(), i.release_date) < 31
AND NOT (end_date IS NULL);

-- ------------------------------------------------------------
-- 9
-- ------------------------------------------------------------

-- Add not null on price_type in price
SELECT 'price' AS 'ALTER';
ALTER TABLE price
  CHANGE COLUMN price_type price_type INT UNSIGNED NOT NULL;

-- update all dates
SELECT 'price' AS 'UPDATE';
UPDATE price
SET start_date = start_date
,   end_date = end_date;

-- ------------------------------------------------------------
-- 10
-- ------------------------------------------------------------
SELECT 'rental_item' AS 'UPDATE';
-- Update rental_item
UPDATE   rental_item ri
SET      rental_item_price =
           (SELECT   p.amount
            FROM     price p CROSS JOIN rental r
            WHERE    p.item_id = ri.item_id
            AND      ri.rental_id = r.rental_id
            AND      r.check_out_date
                       BETWEEN p.start_date AND IFNULL(p.end_date, NOW())
            AND      p.price_type = ri.rental_item_type);

-- Validation of above update
SELECT   ri.rental_item_id, ri.rental_item_price, p.amount
FROM     price p JOIN rental_item ri
ON       p.item_id = ri.item_id AND p.price_type = ri.rental_item_type
JOIN     rental r ON ri.rental_id = r.rental_id
WHERE    r.check_out_date BETWEEN p.start_date AND IFNULL(p.end_date, NOW())
ORDER BY 1;

SELECT 'rental_item' AS 'ALTER';
-- Add not null to rental_item_price in step 7
ALTER TABLE rental_item
  CHANGE COLUMN rental_item_price rental_item_price INT NOT NULL;


-- Close log file.---------------------------------------------
NOTEE
