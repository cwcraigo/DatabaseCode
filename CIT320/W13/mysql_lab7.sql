SOURCE W13_mysql_lab6.sql;

-- Open log file
TEE CIT320_mysql_lab7.txt

-- ------------------------------------------------------------
-- ------------------------------------------------------------
-- LAB 7 ------------------------------------------------------
-- ------------------------------------------------------------
-- MYSQL ------------------------------------------------------
-- ------------------------------------------------------------
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- STEP 1
-- ------------------------------------------------------------

SELECT 'transaction' AS 'DROP/CREATE';

-- Drop all tables and sequences in this lab-------------------
DROP TABLE IF EXISTS transaction;

-- Create transaction---------------------------------------------------
CREATE TABLE transaction
( transaction_id          INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, transaction_account     VARCHAR(15)   NOT NULL
, transaction_type        INT UNSIGNED
, transaction_date        DATE          NOT NULL
, transaction_amount      FLOAT         NOT NULL
, rental_id               INT UNSIGNED
, payment_method_type     INT UNSIGNED
, payment_account_number  VARCHAR(19)   NOT NULL
, created_by              INT UNSIGNED
, creation_date           DATE          NOT NULL
, last_updated_by         INT UNSIGNED
, last_update_date        DATE          NOT NULL
, CONSTRAINT fk_transaction_1 FOREIGN KEY (transaction_type)
    REFERENCES  common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_2 FOREIGN KEY (rental_id)
    REFERENCES  rental(rental_id)
, CONSTRAINT fk_transaction_3 FOREIGN KEY (payment_method_type)
    REFERENCES  common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_4 FOREIGN KEY (created_by)
    REFERENCES  system_user(system_user_id)
, CONSTRAINT fk_transaction_5 FOREIGN KEY (last_updated_by)
    REFERENCES  system_user(system_user_id)
);

SELECT 'transaction_u1' AS 'UNIQUE INDEX';

--  Unique indexs----------------------------------------
CREATE UNIQUE INDEX transaction_u1 ON transaction
  (transaction_account, rental_id, transaction_type, transaction_date, payment_method_type, payment_account_number);

-- ------------------------------------------------------------
-- STEP 2
--   INSERT 9 ROWS
--   UPDATE rental_item_type IN rental_item WITH NEW cl_id's
-- ------------------------------------------------------------

SELECT 'common_lookup' AS 'INSERT';

--  Insert into common_lookup----------------------------------
INSERT INTO common_lookup
SELECT
  NULL
, lookup_type
, lookup_meaning
, 1
, UTC_DATE()
, 1
, UTC_DATE()
, lookup_table
, lookup_column
, lookup_code
FROM
(
(SELECT 'TRANSACTION'       AS lookup_table
       ,'TRANSACTION_TYPE'  AS lookup_column
       ,'CREDIT'            AS lookup_type
       ,'Credit'            AS lookup_meaning
       ,'CR'                AS lookup_code)
UNION ALL
(SELECT 'TRANSACTION','TRANSACTION_TYPE','DEBIT','Debit','DR')
UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','DISCOVER_CARD','Discover Card',NULL)
UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','VISA_CARD','Visa Card',NULL)
UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','MASTER_CARD','Master Card',NULL)
UNION ALL
(SELECT 'TRANSACTION','PAYMENT_METHOD_TYPE','CASH','Cash',NULL)
UNION ALL
(SELECT 'RENTAL_ITEM','RENTAL_ITEM_TYPE','1-DAY RENTAL','1-Day Rental',NULL)
UNION ALL
(SELECT 'RENTAL_ITEM','RENTAL_ITEM_TYPE','3-DAY RENTAL','3-Day Rental',NULL)
UNION ALL
(SELECT 'RENTAL_ITEM','RENTAL_ITEM_TYPE','5-DAY RENTAL','5-Day Rental',NULL)
) fab;

--  Update rental_item_type----------------------------------------
SELECT 'rental_item' AS 'UPDATE';
-- UPDATE rental_item
--   SET rental_item_type = CASE
--       WHEN rental_item_type = 1024 THEN 1035
--       WHEN rental_item_type = 1025 THEN 1036
--       WHEN rental_item_type = 1026 THEN 1037
--       ELSE rental_item_type
--     END;

UPDATE rental_item ri
  SET ri.rental_item_type =
    (SELECT cl1.common_lookup_id
     FROM common_lookup cl1
     WHERE cl1.common_lookup_column = 'RENTAL_ITEM_TYPE'
     AND cl1.common_lookup_type =
      (SELECT cl2.common_lookup_type
       FROM common_lookup cl2
       WHERE cl2.common_lookup_id = ri.rental_item_type));

-- ------------------------------------------------------------
-- STEP 3
-- ------------------------------------------------------------
-- A CREATE airport AND account_list--------------------------

-- Create airport---------------------------------------------------
SELECT 'airport' AS 'DROP/CREATE';
DROP TABLE IF EXISTS airport;
CREATE TABLE airport
( airport_id        INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, airport_code      VARCHAR(3)    NOT NULL
, airport_city      VARCHAR(30)   NOT NULL
, city              VARCHAR(30)   NOT NULL
, state_province    VARCHAR(30)   NOT NULL
, created_by        INT UNSIGNED
, creation_date     DATE          NOT NULL
, last_updated_by   INT UNSIGNED
, last_update_date  DATE          NOT NULL
, CONSTRAINT fk_airport_1 FOREIGN KEY (created_by)
    REFERENCES  system_user(system_user_id)
, CONSTRAINT fk_airport_2 FOREIGN KEY (last_updated_by)
    REFERENCES  system_user(system_user_id)
);

-- Create account_list---------------------------------------------------
SELECT 'account_list' AS 'DROP/CREATE';
DROP TABLE IF EXISTS account_list;
CREATE TABLE account_list
( account_list_id   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, account_number    VARCHAR(10)  NOT NULL
, consumed_date     DATE
, consumed_by       INT UNSIGNED
, created_by        INT UNSIGNED
, creation_date     DATE          NOT NULL
, last_updated_by   INT UNSIGNED
, last_update_date  DATE          NOT NULL
, CONSTRAINT fk_account_list_1 FOREIGN KEY (consumed_by)
    REFERENCES  system_user(system_user_id)
, CONSTRAINT fk_account_list_2 FOREIGN KEY (created_by)
    REFERENCES  system_user(system_user_id)
, CONSTRAINT fk_account_list_3 FOREIGN KEY (last_updated_by)
    REFERENCES  system_user(system_user_id)
);

--  B SEED airport---------------------------------------------
SELECT 'airport' AS 'INSERT';
INSERT INTO airport
SELECT
  NULL
, code
, airport_city
, city
, state
, 1
, UTC_DATE()
, 1
, UTC_DATE()
FROM
(
(SELECT 'LAX'         AS code
       ,'Los Angeles' AS airport_city
       ,'Los Angeles' AS city
       ,'California'  AS state)
UNION ALL
(SELECT 'SLC','Salt Lake City','Provo','Utah')
UNION ALL
(SELECT 'SLC','Salt Lake City','Spanish Fork','Utah')
UNION ALL
(SELECT 'SFO','San Francisco','San Francisco','California')
UNION ALL
(SELECT 'SJC','San Jose','San Jose','California')
UNION ALL
(SELECT 'SJC','San Jose','San Carlos','California')
) fab;

--  C SEED account_list----------------------------------------
  -- TO LOOK AT STORED PROCEDURES USE:
    -- SELECT object_name FROM user_procedures;

-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE seed_account_list' AS "Statement";
DROP PROCEDURE IF EXISTS seed_account_list;

-- Create procedure to insert automatic numbered rows.
SELECT 'CREATE PROCEDURE seed_account_list' AS "Statement";

-- Reset delimiter to write a procedure.
DELIMITER $$

CREATE PROCEDURE seed_account_list() MODIFIES SQL DATA
BEGIN

  /* Declare local variable for call parameters. */
  DECLARE lv_key CHAR(3);

  /* Declare local control loop variables. */
  DECLARE lv_key_min  INT DEFAULT 0;
  DECLARE lv_key_max  INT DEFAULT 50;

  /* Declare a local variable for a subsequent handler. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;

  /* Declare a SQL cursor fabricated from local variables. */
  DECLARE parameter_cursor CURSOR FOR
    SELECT DISTINCT airport_code FROM airport;

  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;

  /* Declare a not found record handler to close a cursor loop. */
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;

  /* Start transaction context. */
  START TRANSACTION;

  /* Set savepoint. */
  SAVEPOINT all_or_none;

  /* Open a local cursor. */
  OPEN parameter_cursor;
  cursor_parameter: LOOP

    FETCH parameter_cursor
    INTO  lv_key;

    /* Place the catch handler for no more rows found
       immediately after the fetch operation.          */
    IF fetched = 1 THEN LEAVE cursor_parameter; END IF;

    seed: WHILE (lv_key_min < lv_key_max) DO
      SET lv_key_min = lv_key_min + 1;

      INSERT INTO account_list
      VALUES
      ( NULL
      , CONCAT(lv_key,'-',LPAD(lv_key_min,6,'0'))
      , NULL
      , NULL
      , 2
      , UTC_DATE()
      , 2
      , UTC_DATE());
    END WHILE;

    /* Reset nested low range variable. */
    SET lv_key_min = 0;

  END LOOP cursor_parameter;
  CLOSE parameter_cursor;

    /* This acts as an exception handling block. */
  IF duplicate_key = 1 THEN

    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;

  END IF;

  /* Commit the writes as a group. */
  COMMIT;

END;
$$

-- Reset delimiter to the default.
DELIMITER ;

SELECT 'seed_account_list' AS 'CALL PROCEDURE';
CALL seed_account_list();

SELECT COUNT(DISTINCT airport_code) AS "# Airports"
FROM   airport;

SELECT COUNT(*) AS "# Accounts"
FROM   account_list;

--  D UPDATE state_province IN address-------------------------
SELECT 'address' AS 'UPDATE';
UPDATE address
  SET state_province = CASE
      WHEN state_province = 'CA' THEN 'California'
      WHEN state_province = 'UT' THEN 'Utah'
      ELSE state_province
    END;

-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE update_member_account' AS "Statement";
DROP PROCEDURE IF EXISTS update_member_account;

-- Create procedure to insert automatic numbered rows.
SELECT 'CREATE PROCEDURE update_member_account' AS "Statement";

-- Reset delimiter to write a procedure.
DELIMITER $$

CREATE PROCEDURE update_member_account() MODIFIES SQL DATA
BEGIN

  /* Declare local variable for call parameters. */
  DECLARE lv_member_id      INT UNSIGNED;
  DECLARE lv_city           CHAR(30);
  DECLARE lv_state_province CHAR(30);
  DECLARE lv_account_number CHAR(10);

  /* Declare a local variable for a subsequent handler. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;

  /* Declare a SQL cursor fabricated from local variables. */
  DECLARE member_cursor CURSOR FOR
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;

  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;

  /* Declare a not found record handler to close a cursor loop. */
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;

  /* Start transaction context. */
  START TRANSACTION;

  /* Set savepoint. */
  SAVEPOINT all_or_none;

  /* Open a local cursor. */
  OPEN member_cursor;
  cursor_member: LOOP

    FETCH member_cursor
    INTO  lv_member_id
    ,     lv_city
    ,     lv_state_province;

    /* Place the catch handler for no more rows found
       immediately after the fetch operation.          */
    IF fetched = 1 THEN LEAVE cursor_member; END IF;

      /* Secure a unique account number as they're consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTRING(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = lv_city
      AND    ap.state_province = lv_state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL LIMIT 1;

      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = lv_member_id;

      /* Mark consumed the last used account number. */
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = UTC_DATE()
      WHERE  account_number = lv_account_number;

  END LOOP cursor_member;
  CLOSE member_cursor;

    /* This acts as an exception handling block. */
  IF duplicate_key = 1 THEN

    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;

  END IF;

  /* Commit the writes as a group. */
  COMMIT;

END;
$$

-- Reset delimiter to the default.
DELIMITER ;

-- CALL stored procedure
SELECT 'update_member_account' AS 'CALL PROCEDURE';
CALL update_member_account();

-- Validation for update_member_account
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
--    CREATE EXTERNAL TABLE transaction_upload
-- ------------------------------------------------------------
-- Create external table transaction_upload.
SELECT 'transaction_upload' AS 'DROP/CREATE';
DROP TABLE IF EXISTS transaction_upload;
CREATE TABLE transaction_upload
( account_number          VARCHAR(10)
, first_name              VARCHAR(20)
, middle_name             VARCHAR(20)
, last_name               VARCHAR(20)
, check_out_date          DATE
, return_date             DATE
, rental_item_type        VARCHAR(12)
, transaction_type        VARCHAR(14)
, transaction_amount      FLOAT
, transaction_date        DATE
, item_id                 INT UNSIGNED
, payment_method_type     VARCHAR(14)
, payment_account_number  VARCHAR(19)
) ENGINE=MEMORY;

SELECT 'transaction_upload_mysql.csv' AS 'LOAD DATA';
LOAD DATA LOCAL INFILE 'transaction_upload_mysql.csv'
INTO TABLE transaction_upload
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';
-- '\r\n' if in Windows

SELECT 'contact' AS 'UPDATE';
UPDATE contact
 SET middle_name = ''
 WHERE middle_name IS NULL;

-- ------------------------------------------------------------
-- STEP 5
--    CREATE UPLOAD PROCEDURE
--      NEEDS TO BE RERUNNABLE AND VALIDATE PROPORLY
-- ------------------------------------------------------------

SELECT 'tu_rental' AS 'CREATE INDEX';
CREATE INDEX tu_rental
 ON transaction_upload (account_number, first_name, last_name, check_out_date, return_date) USING BTREE;

SELECT 'natural_key' AS 'UNIQUE INDEX ON RENTAL_ITEM';
ALTER TABLE rental_item
ADD CONSTRAINT natural_key
UNIQUE INDEX (rental_item_id, rental_id, item_id, rental_item_type, rental_item_price) USING BTREE;

SELECT 'member_u1' AS 'UNIQUE INDEX ON MEMBER';
ALTER TABLE member
ADD CONSTRAINT member_u1
UNIQUE INDEX member_key (account_number, credit_card_number, credit_card_type, member_type) USING BTREE;

SELECT 'common_lookup_u1' AS 'UNIQUE INDEX ON COMMON_LOOKUP';
ALTER TABLE common_lookup
ADD CONSTRAINT common_lookup_u1
UNIQUE INDEX common_lookup_key (common_lookup_table,common_lookup_column,common_lookup_type) USING BTREE;

DELIMITER $$

SELECT 'DROP PROCEDURE update_member_account' AS "Statement"$$
DROP PROCEDURE IF EXISTS upload_transaction_log$$

-- Create a procedure to wrap the transaction.
SELECT 'CREATE PROCEDURE update_member_account' AS "Statement"$$
CREATE PROCEDURE upload_transaction_log()
BEGIN

  DECLARE lv_error INT UNSIGNED DEFAULT 0;

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_error = 1;

  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;

  -- Insert or update rental table,
  -- Rerunnable when the file hasn't been updated.
REPLACE INTO rental
(SELECT DISTINCT
        r.rental_id       AS rental_id
      , c.contact_id      AS customer_id
      , tu.check_out_date AS check_out_date
      , tu.return_date    AS return_date
      , 1                 AS created_by
      , UTC_DATE()        AS creation_date
      , 1                 AS last_updated_by
      , UTC_DATE()        AS last_update_date
     FROM   member m INNER JOIN contact c
     ON   m.member_id = c.member_id
  INNER JOIN transaction_upload tu
     ON   m.account_number = tu.account_number
     AND  c.first_name = tu.first_name
     AND  IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
     AND  c.last_name = tu.last_name
  LEFT JOIN rental r
     ON   r.customer_id = c.contact_id
     AND  r.check_out_date = tu.check_out_date
     AND  r.return_date = tu.return_date);


  -- Insert or update rental_item table,
REPLACE INTO rental_item
 (SELECT ri.rental_item_id                          AS rental_item_id
       , r.rental_id                                AS rental_id
       , tu.item_id                                 AS item_id
       , 1                                          AS created_by
       , UTC_DATE()                                 AS creation_date
       , 1                                          AS last_updated_by
       , UTC_DATE()                                 AS last_update_date
       , cl.common_lookup_id                        AS rental_item_type
       , DATEDIFF(tu.return_date, r.check_out_date) AS rental_item_price
  FROM member m INNER JOIN contact c
     ON   m.member_id = c.member_id
  INNER JOIN transaction_upload tu
     ON   m.account_number = tu.account_number
     AND  c.first_name = tu.first_name
     AND  IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
     AND  c.last_name = c.last_name
  LEFT JOIN rental r
     ON   r.customer_id = c.contact_id
     AND  r.check_out_date = tu.check_out_date
     AND  r.return_date = tu.return_date
  INNER JOIN common_lookup cl
     ON   tu.rental_item_type = cl.common_lookup_type
     AND  cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
  LEFT JOIN rental_item ri
     ON   ri.rental_id = r.rental_id
     AND  ri.item_id = tu.item_id
     AND  ri.rental_item_type = cl.common_lookup_id);


-- Insert or update transaction table,
REPLACE INTO transaction
  (SELECT t.transaction_id            AS transaction_id
        , tu.payment_account_number   AS transaction_account
        , cl1.common_lookup_id        AS transaction_type
        , tu.transaction_date         AS transaction_date
        , SUM(tu.transaction_amount)  AS transaction_amount
        , r.rental_id                 AS rental_id
        , cl2.common_lookup_id        AS payment_method_type
        , m.credit_card_number        AS payment_account_number
        , 1                           AS created_by
        , UTC_DATE()                  AS creation_date
        , 1                           AS last_updated_by
        , UTC_DATE()                  AS last_update_date
  FROM  member m INNER JOIN contact c
    ON  m.member_id = c.member_id
  INNER JOIN transaction_upload tu
    ON  m.account_number = tu.account_number
    AND c.first_name = tu.first_name
    AND IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
    AND c.last_name = c.last_name
  INNER JOIN rental r
    ON  r.customer_id = c.contact_id
    AND r.check_out_date = tu.check_out_date
    AND r.return_date = tu.return_date
  INNER JOIN common_lookup cl1
    ON  cl1.common_lookup_table = 'TRANSACTION'
    AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
    AND cl1.common_lookup_type = tu.transaction_type
  INNER JOIN common_lookup cl2
    ON  cl2.common_lookup_table = 'TRANSACTION'
    AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
    AND cl2.common_lookup_type = tu.payment_method_type
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
      , t.last_update_date);

  -- Rollback or save the changes.
  IF lv_error = 1 THEN
    ROLLBACK TO SAVEPOINT starting_point;
    SELECT 'ROLLBACKED' AS 'upload_transaction_log';
  ELSE
    COMMIT;
    SELECT 'COMMITED' AS 'upload_transaction_log';
  END IF;

END;
$$

DELIMITER ;

-- RUN UPLOAD PROCEDURE
SELECT 'upload_transaction_log' AS '1st CALL PROCEDURE';
CALL upload_transaction_log();

-- RUN SECOND TIME TO CHECK FOR RERUNNABILITY
-- SELECT 'upload_transaction_log' AS '2nd CALL PROCEDURE';
-- CALL upload_transaction_log();

-- VALIDATION OF upload_kingdom PROCEDURE ----------------------------
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3
UNION ALL
(SELECT 4380   AS 'RENTAL COUNT SHOULD BE'
     , 11532   AS 'RENTAL_ITEM COUNT SHOULD BE'
     , 4372    AS 'TRANSACTION COUNT SHOULD BE');

-- ------------------------------------------------------------
-- STEP 6
-- ------------------------------------------------------------
SELECT DISTINCT
   DATE_FORMAT(transaction_date, '%b-%Y')                             AS "MON-YEAR"
  ,LPAD(CONCAT('$',FORMAT(SUM(transaction_amount),2)),14,' ')         AS "BASE"
  ,LPAD(CONCAT('$',FORMAT((SUM(transaction_amount) * 1.1),2)),14,' ') AS "10_PLUS"
  ,LPAD(CONCAT('$',FORMAT((SUM(transaction_amount) * 1.2),2)),14,' ') AS "20_PLUS"
  ,LPAD(CONCAT('$',FORMAT((SUM(transaction_amount) * 0.1),2)),14,' ') AS "10_DIFF"
  ,LPAD(CONCAT('$',FORMAT((SUM(transaction_amount) * 0.2),2)),14,' ') AS "20_DIFF"
FROM transaction
WHERE DATE_FORMAT(transaction_date, '%Y') = 2009
GROUP BY
   DATE_FORMAT(transaction_date, '%b-%Y')
ORDER BY
  MONTH(transaction_date);


-- SHOULD LOOK LIKE THIS
-- +----------+------------+------------+------------+------------+------------+
-- | MON-YEAR | BASE       | 10_PLUS    | 20_PLUS    | 10_DIFF    | 20_DIFF    |
-- +----------+------------+------------+------------+------------+------------+
-- | JAN-2009 |  $2,957.40 |  $3,253.14 |  $3,548.88 |    $295.74 |    $591.48 |
-- | FEB-2009 |  $4,022.70 |  $4,424.97 |  $4,827.24 |    $402.27 |    $804.54 |
-- | MAR-2009 |  $5,654.04 |  $6,219.44 |  $6,784.85 |    $565.40 |  $1,130.81 |
-- | APR-2009 |  $4,595.10 |  $5,054.61 |  $5,514.12 |    $459.51 |    $919.02 |
-- | MAY-2009 |  $2,219.64 |  $2,441.60 |  $2,663.57 |    $221.96 |    $443.93 |
-- | JUN-2009 |  $1,300.62 |  $1,430.68 |  $1,560.74 |    $130.06 |    $260.12 |
-- | JUL-2009 |  $2,413.62 |  $2,654.98 |  $2,896.34 |    $241.36 |    $482.72 |
-- | AUG-2009 |  $2,149.68 |  $2,364.65 |  $2,579.62 |    $214.97 |    $429.94 |
-- | SEP-2009 |  $2,162.40 |  $2,378.64 |  $2,594.88 |    $216.24 |    $432.48 |
-- | OCT-2009 |  $3,291.30 |  $3,620.43 |  $3,949.56 |    $329.13 |    $658.26 |
-- | NOV-2009 |  $3,246.78 |  $3,571.46 |  $3,896.14 |    $324.68 |    $649.36 |
-- | DEC-2009 |  $2,299.14 |  $2,529.05 |  $2,758.97 |    $229.91 |    $459.83 |
-- +----------+------------+------------+------------+------------+------------+

-- Close log file.---------------------------------------------
NOTEE





















