source rob_create_mysql_store_ri.sql
source rob_seed_mysql_store_ri.sql

ALTER TABLE rental
MODIFY return_date DATE DEFAULT NULL;

ALTER TABLE item
CHANGE item_release_date release_date DATE NOT NULL;

-- ----------
-- ----------
-- ----------
-- Step 2 ---
-- ----------
-- ----------
-- ----------

drop table if exists price;

CREATE TABLE price
      (     price_id                 INT UNSIGNED AUTO_INCREMENT
    , item_id                  INT UNSIGNED
    , price_type               INT UNSIGNED
    , active_flag              CHAR(1) NOT NULL
    , start_date               DATE    NOT NULL
    , end_date                 DATE
    , amount                   INT UNSIGNED
    , created_by               INT UNSIGNED
    , creation_date            DATE    NOT NULL
    , last_updated_by          INT UNSIGNED
    , last_updated_date        DATE    NOT NULL
    , CONSTRAINT pk_price_1    PRIMARY KEY(price_id)
    , CONSTRAINT fk_price_1    FOREIGN KEY(item_id) REFERENCES item(item_id)
    , CONSTRAINT fk_price_2    FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
    , CONSTRAINT fk_price_3    FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
    , CONSTRAINT fk_price_4    FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
    , CONSTRAINT afc_price_1   CHECK (active_flag IN ('Y', 'N')));

-- ----------
-- ----------
-- ----------
-- Step 3 ---
-- ----------
-- ----------
-- ----------

INSERT INTO item VALUES
( NULL
, '00000000000001'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Winnie the Poop','Winnies Great Adventure'
,'R', DATE '2013-11-05', 2, SYSDATE(), 2, SYSDATE());

INSERT INTO item VALUES
( NULL
, '00000000000002'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Winnie the Poop','Winnies Great Adventure 2'
,'G', DATE '2013-11-06', 2, SYSDATE(), 2, SYSDATE());


INSERT INTO item VALUES
( NULL
, '00000000000003'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Winnie the Poop','Winnies Great Adventure 3'
,'unrated', DATE '2013-11-07', 2, SYSDATE(), 2, SYSDATE());


INSERT INTO member VALUES
( NULL
, (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'INDIVIDUAL')
,'A110-10193'
,'1010-2336-4687-4677'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO contact VALUES
( NULL
,(SELECT   member_id
  FROM     member
  WHERE    account_number = 'A110-10193'
  AND      credit_card_number = '1010-2336-4687-4677')
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Harry','','Potter'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO address VALUES
( NULL
,(SELECT   c.contact_id
  FROM     contact c
  INNER JOIN member m
  ON       c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Harry'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY c.contact_id DESC LIMIT 1)
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','82702'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO street_address VALUES
( NULL
,(SELECT   a.address_id
  FROM    address a
  INNER JOIN contact c
  ON        a.contact_id = c.contact_id
  INNER JOIN member m
  ON        c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Harry'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY a.address_id DESC LIMIT 1)
,'100 Noah Rd'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO telephone VALUES
( NULL
,(SELECT   c.contact_id
  FROM     contact c
  INNER JOIN member m
  ON       c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Harry'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY c.contact_id DESC LIMIT 1)
,(SELECT   a.address_id
  FROM    address a
  INNER JOIN contact c
  ON        a.contact_id = c.contact_id
  INNER JOIN member m
  ON        c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Harry'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY a.address_id DESC LIMIT 1)
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','821','649-4450'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO contact VALUES
( NULL
,(SELECT   member_id
  FROM     member
  WHERE    account_number = 'A110-10193'
  AND      credit_card_number = '1010-2336-4687-4677')
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Ginny','','Potter'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO address VALUES
( NULL
,(SELECT   c.contact_id
  FROM     contact c
  INNER JOIN member m
  ON       c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Ginny'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY c.contact_id DESC LIMIT 1)
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','82702'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO street_address VALUES
( NULL
,(SELECT   a.address_id
  FROM    address a
  INNER JOIN contact c
  ON        a.contact_id = c.contact_id
  INNER JOIN member m
  ON        c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Ginny'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY a.address_id DESC LIMIT 1)
,'100 Noah Rd'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO telephone VALUES
( NULL
,(SELECT   c.contact_id
  FROM     contact c
  INNER JOIN member m
  ON       c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Ginny'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY c.contact_id DESC LIMIT 1)
,(SELECT   a.address_id
  FROM    address a
  INNER JOIN contact c
  ON        a.contact_id = c.contact_id
  INNER JOIN member m
  ON        c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Ginny'
  AND      c.middle_name = ''
  AND      c.last_name = 'Potter'
  ORDER BY a.address_id DESC LIMIT 1)
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','821','649-4450'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO contact VALUES
( NULL
,(SELECT   member_id
  FROM     member
  WHERE    account_number = 'A110-10193'
  AND      credit_card_number = '1010-2336-4687-4677')
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Lily','Luna','Potter'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO address VALUES
( NULL
,(SELECT   c.contact_id
  FROM     contact c
  INNER JOIN member m
  ON       c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Lily'
  AND      c.middle_name = 'Luna'
  AND      c.last_name = 'Potter'
  ORDER BY c.contact_id DESC LIMIT 1)
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','UT','82702'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO street_address VALUES
( NULL
,(SELECT   a.address_id
  FROM    address a
  INNER JOIN contact c
  ON        a.contact_id = c.contact_id
  INNER JOIN member m
  ON        c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Lily'
  AND      c.middle_name = 'Luna'
  AND      c.last_name = 'Potter'
  ORDER BY a.address_id DESC LIMIT 1)
,'100 Noah Rd'
, 2, SYSDATE(), 2, SYSDATE());

INSERT INTO telephone VALUES
( NULL
,(SELECT   c.contact_id
  FROM     contact c
  INNER JOIN member m
  ON       c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Lily'
  AND      c.middle_name = 'Luna'
  AND      c.last_name = 'Potter'
  ORDER BY c.contact_id DESC LIMIT 1)
,(SELECT   a.address_id
  FROM    address a
  INNER JOIN contact c
  ON        a.contact_id = c.contact_id
  INNER JOIN member m
  ON        c.member_id = m.member_id
  AND      m.account_number = 'A110-10193'
  AND      m.credit_card_number = '1010-2336-4687-4677'
  AND      c.first_name = 'Lily'
  AND      c.middle_name = 'Luna'
  AND      c.last_name = 'Potter'
  ORDER BY a.address_id DESC LIMIT 1)
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','821','649-4450'
, 2, SYSDATE(), 2, SYSDATE());


INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( (SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, SYSDATE(), DATE_ADD(SYSDATE(), INTERVAL 1 DAY)
, 3, SYSDATE(), 3, SYSDATE());

INSERT INTO rental_item VALUES
( NULL
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Winnie the Poop'
  AND      i.item_subtitle = 'Winnies Great Adventure'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_FULL_SCREEN')
, 3, SYSDATE(), 3, SYSDATE());

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( (SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, SYSDATE(), DATE_ADD(SYSDATE(), INTERVAL 3 DAY)
, 3, SYSDATE(), 3, SYSDATE());

INSERT INTO rental_item VALUES
( NULL
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Ginny')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Winnie the Poop'
  AND      i.item_subtitle = 'Winnies Great Adventure 2'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_FULL_SCREEN')
, 3, SYSDATE(), 3, SYSDATE());

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( (SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, SYSDATE(), DATE_ADD(SYSDATE(), INTERVAL 5 DAY)
, 3, SYSDATE(), 3, SYSDATE());

INSERT INTO rental_item VALUES
( NULL
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Lily')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Winnie the Poop'
  AND      i.item_subtitle = 'Winnies Great Adventure 3'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_FULL_SCREEN')
, 3, SYSDATE(), 3, SYSDATE());

-- ----------
-- ----------
-- ----------
-- Step 4 ---
-- ----------
-- ----------
-- ----------

ALTER TABLE common_lookup
ADD COLUMN common_lookup_table  CHAR(30) AFTER common_lookup_id,
ADD COLUMN common_lookup_column CHAR(30) AFTER common_lookup_table,
ADD COLUMN common_lookup_code   CHAR(30) AFTER common_lookup_column;

UPDATE common_lookup
SET common_lookup_table =
        CASE
        WHEN common_lookup_context = 'MULTIPLE'
        THEN 'ADDRESS'
        ELSE common_lookup_context
        END,
    common_lookup_column =
        CASE
        WHEN common_lookup_context = 'MULTIPLE'
        THEN 'ADDRESS_TYPE'
        ELSE CONCAT(common_lookup_context, '_TYPE')
        END;

DROP INDEX common_lookup_u1 ON common_lookup;

INSERT INTO common_lookup
(SELECT  NULL
,        'TELEPHONE'
,        'TELEPHONE_TYPE'
,        common_lookup_code
,        common_lookup_context
,        common_lookup_type
,        common_lookup_meaning
,        created_by
,        creation_date
,        last_updated_by
,        last_update_date
FROM common_lookup
WHERE common_lookup_table = 'ADDRESS'
AND common_lookup_column = 'ADDRESS_TYPE');

UPDATE  TELEPHONE
SET   TELEPHONE_TYPE =
( SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_table = 'TELEPHONE'
  AND common_lookup_column = 'TELEPHONE_TYPE'
  AND common_lookup_TYPE = 'HOME' )
  WHERE TELEPHONE_TYPE =
 ( SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_table = 'ADDRESS'
   AND common_lookup_column = 'ADDRESS_TYPE'
   AND common_lookup_TYPE = 'HOME' );

ALTER TABLE common_lookup
DROP COLUMN common_lookup_context;

ALTER TABLE common_lookup
MODIFY common_lookup_table CHAR(30) NOT NULL,
MODIFY common_lookup_column CHAR(30) NOT NULL;

CREATE UNIQUE INDEX common_lookup_u1 ON common_lookup(common_lookup_table, common_lookup_column, common_lookup_type);


-- ----------
-- ----------
-- ----------
-- Step 5 ---
-- ----------
-- ----------
-- ----------

INSERT INTO common_lookup VALUES
( NULL, 'PRICE', 'ACTIVE_FLAG', 'Y', 'YES', 'Yes', 1, SYSDATE(), 1, SYSDATE() );

INSERT INTO common_lookup VALUES
( NULL, 'PRICE', 'ACTIVE_FLAG', 'N', 'NO', 'No', 1, SYSDATE(), 1, SYSDATE() );


-- ----------
-- ----------
-- ----------
-- Step 6 ---
-- ----------
-- ----------
-- ----------

INSERT INTO common_lookup VALUES
( NULL, 'PRICE', 'PRICE_TYPE', '1', '1-DAY RENTAL', '1-Day Rental', 1, SYSDATE(), 1, SYSDATE() );

INSERT INTO common_lookup VALUES
( NULL, 'PRICE', 'PRICE_TYPE', '3', '3-DAY RENTAL', '3-Day Rental', 1, SYSDATE(), 1, SYSDATE() );

INSERT INTO common_lookup VALUES
( NULL, 'PRICE', 'PRICE_TYPE', '5', '5-DAY RENTAL', '5-Day Rental', 1, SYSDATE(), 1, SYSDATE() );


-- ----------
-- ----------
-- ----------
-- Step 7 ---
-- ----------
-- ----------
-- ----------

ALTER TABLE rental_item
ADD COLUMN rental_item_type INT UNSIGNED,
ADD FOREIGN KEY rental_item_type_fk6(rental_item_type) REFERENCES common_lookup(common_lookup_id),
ADD COLUMN rental_item_price INT UNSIGNED;

UPDATE rental_item ri
SET ri.rental_item_type =
( SELECT cl.common_lookup_id
  FROM common_lookup cl
  WHERE cl.common_lookup_code =
  ( SELECT CONVERT(r.return_date - r.check_out_date USING latin1)
    FROM rental r
    WHERE r.rental_id = ri.rental_id) );


-- ----------
-- ----------
-- ----------
-- Step 8 ---
-- ----------
-- ----------
-- ----------

INSERT INTO price
( SELECT NULL
, i.item_id
,(SELECT   cl.common_lookup_id
  FROM     common_lookup cl
  WHERE    CAST(cl.common_lookup_code AS CHAR) = pt.price_type)
, af.active_flag
, CASE
       WHEN af.active_flag = 'Y' AND DATEDIFF(UTC_DATE(), i.release_date) < 31
       THEN i.release_date
       WHEN af.active_flag = 'N' AND DATEDIFF(UTC_DATE(), i.release_date) > 30
       THEN i.release_date
       ELSE DATE_ADD(i.release_date, INTERVAL 31 DAY)
  END
, CASE
       WHEN af.active_flag = 'N' AND DATEDIFF(UTC_DATE(), i.release_date) > 30
       THEN DATE_ADD(i.release_date, INTERVAL 30 DAY)
       ELSE NULL
  END
, CASE
       WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
       AND af.active_flag = 'Y' AND pt.price_type = '1' THEN 3
       WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
       AND af.active_flag = 'Y' AND pt.price_type = '3' THEN 10
       WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
       AND af.active_flag = 'Y' AND pt.price_type = '5' THEN 15
       WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
       AND af.active_flag = 'N' AND pt.price_type = '1' THEN 3
       WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
       AND af.active_flag = 'N' AND pt.price_type = '3' THEN 10
       WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
       AND af.active_flag = 'N' AND pt.price_type = '5' THEN 15
       ELSE CAST(pt.price_type AS UNSIGNED)
  END
 , 1, SYSDATE(), 1, SYSDATE()
FROM
  item i
, (SELECT '1' AS price_type FROM dual
        UNION ALL
        SELECT '3' AS price_type FROM dual
        UNION ALL
        SELECT '5' AS price_type FROM dual) pt
, (SELECT 'Y' AS active_flag FROM dual
        UNION ALL
        SELECT 'N' AS active_flag FROM dual) af
WHERE NOT ((TO_DAYS(SYSDATE()) - TO_DAYS(i.release_date)) < 31 AND af.active_flag = 'N') );

SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y'
AND      i.item_id = p.item_id
AND      DATEDIFF(UTC_DATE(), i.release_date) > 30
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
AND      DATEDIFF(UTC_DATE(), i.release_date) > 30
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
AND      DATEDIFF(UTC_DATE(), i.release_date) < 31
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
AND      DATEDIFF(UTC_DATE(), i.release_date) < 31
AND NOT (end_date IS NULL);


-- ----------
-- ----------
-- ----------
-- Step 9 ---
-- ----------
-- ----------
-- ----------

ALTER TABLE price
CHANGE price_type price_type INT(10) UNSIGNED NOT NULL;


-- ----------
-- ----------
-- ----------
-- Step 10 --
-- ----------
-- ----------
-- ----------

UPDATE rental_item ri
SET rental_item_price =
( SELECT p.amount
  FROM price p CROSS JOIN rental r
  WHERE p.item_id = ri.item_id
  AND ri.rental_id = r.rental_id
  AND r.check_out_date
  BETWEEN p.start_date AND IFNULL(p.end_date, SYSDATE())
  AND p.price_type = ri.rental_item_type );

SELECT ri.rental_item_id, ri.rental_item_price, p.amount
FROM price p JOIN rental_item ri
ON p.item_id = ri.item_id AND p.price_type = ri.rental_item_type
JOIN rental r ON ri.rental_id = r.rental_id
WHERE r.check_out_date BETWEEN p.start_date AND IFNULL(p.end_date, SYSDATE())
ORDER BY 1;

ALTER TABLE rental_item
CHANGE rental_item_price rental_item_price INT(10) UNSIGNED NOT NULL;
