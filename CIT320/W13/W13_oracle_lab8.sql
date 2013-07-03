@ CIT320_lab7.sql;

-- Open log file------------------------------------------------------------------------------------
SPOOL log\CIT320_lab8.txt

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! LAB 8 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ORACLE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- -------------------------------------------------------------------------------------------------
-- STEP 1
--   CREATE calendar
-- -------------------------------------------------------------------------------------------------

-- Drop all tables and sequences in this lab--------------------------------------------------------
BEGIN
  FOR i IN (SELECT TABLE_NAME
  			FROM user_tables
  			WHERE TABLE_NAME IN
  			('CALENDAR', 'TRANSACTION_REVERSAL'))
  			LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.TABLE_NAME||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
  			FROM user_sequences
  			WHERE sequence_name IN
  			('CALENDAR_S1', 'TRANSACTION_REVERSAL_S1'))
  			LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.SEQUENCE_NAME;
  END LOOP;
END;
/

-- CREATE calendar----------------------------------------------------------------------------------
CREATE TABLE calendar
( calendar_id           NUMBER
, calendar_name         VARCHAR2(10)    CONSTRAINT calendar_nn1 NOT NULL
, calendar_short_name   VARCHAR2(3)     CONSTRAINT calendar_nn2 NOT NULL
, start_date            DATE            CONSTRAINT calendar_nn3 NOT NULL
, end_date              DATE            CONSTRAINT calendar_nn4 NOT NULL
, created_by            NUMBER
, creation_date         DATE            CONSTRAINT calendar_nn5 NOT NULL
, last_updated_by       NUMBER
, last_update_date      DATE            CONSTRAINT calendar_nn6 NOT NULL
, CONSTRAINT pk_calendar_1 PRIMARY KEY (calendar_id)
, CONSTRAINT fk_calendar_1 FOREIGN KEY (created_by)
	REFERENCES	system_user(system_user_id)
, CONSTRAINT fk_calendar_2 FOREIGN KEY (last_updated_by)
	REFERENCES	system_user(system_user_id)
);

-- Create a sequence--------------------------------------------------------------------------------
CREATE SEQUENCE calendar_s1 START WITH 1;

-- -------------------------------------------------------------------------------------------------
-- STEP 2
--   SEED calendar
-- -------------------------------------------------------------------------------------------------

INSERT INTO calendar
SELECT calendar_s1.NEXTVAL, calendar_name, calendar_short_name
, start_date, end_date, 1, SYSDATE, 1, SYSDATE
FROM ((SELECT 'January' AS calendar_name, 'JAN' AS calendar_short_name
, '01-JAN-2009' AS start_date, '31-JAN-2009' AS end_date FROM dual) UNION ALL
(SELECT 'February', 'FEB', '01-FEB-2009', '28-FEB-2009' FROM dual) UNION ALL
(SELECT 'March', 'MAR', '01-MAR-2009', '31-MAR-2009' FROM dual) UNION ALL
(SELECT 'April', 'APR', '01-APR-2009', '30-APR-2009' FROM dual) UNION ALL
(SELECT 'May', 'MAY', '01-MAY-2009', '31-MAY-2009' FROM dual) UNION ALL
(SELECT 'June', 'JUN', '01-JUN-2009', '30-JUN-2009' FROM dual) UNION ALL
(SELECT 'July', 'JUL', '01-JUL-2009', '31-JUL-2009' FROM dual) UNION ALL
(SELECT 'August', 'AUG', '01-AUG-2009', '31-AUG-2009' FROM dual) UNION ALL
(SELECT 'September', 'SEP', '01-SEP-2009', '30-SEP-2009' FROM dual) UNION ALL
(SELECT 'October', 'OCT', '01-OCT-2009', '31-OCT-2009' FROM dual) UNION ALL
(SELECT 'November', 'NOV', '01-NOV-2009', '30-NOV-2009' FROM dual) UNION ALL
(SELECT 'December', 'DEC', '01-DEC-2009', '31-DEC-2009' FROM dual));

-- -------------------------------------------------------------------------------------------------
-- STEP 3
--   CREATE transaction_reversal
-- -------------------------------------------------------------------------------------------------

-- -- Set environment variables.
-- SET LONG 100000
-- SET PAGESIZE 0
--
-- -- Set a local variable of a character large object (CLOB).
-- VARIABLE ddl_text CLOB
--
-- -- Get the internal DDL command for the TRANSACTION table from the data dictionary.
-- SELECT dbms_metadata.get_ddl('TABLE','TRANSACTION') FROM dual;
--
-- -- Get the internal DDL command for the external TRANSACTION_UPLOAD table from the data dictionary.
-- SELECT dbms_metadata.get_ddl('TABLE','TRANSACTION_UPLOAD') FROM dual;

CREATE TABLE transaction_reversal
( transaction_id            NUMBER
, transaction_account       VARCHAR2(15)
, transaction_type          NUMBER
, transaction_date          DATE
, transaction_amount        FLOAT
, rental_id                 NUMBER
, payment_method_type       NUMBER
, payment_account_number    VARCHAR(19)
, created_by                NUMBER
, creation_date             DATE
, last_updated_by           NUMBER
, last_update_date          DATE
)
ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY download
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'DOWNLOAD':'transaction_upload2.bad'
      DISCARDFILE 'DOWNLOAD':'transaction_upload2.dis'
      LOGFILE     'DOWNLOAD':'transaction_upload2.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('transaction_upload2.csv'))
REJECT LIMIT UNLIMITED;

-- CREATE SEQUENCE FOR transaction_reversal---------------------------------------------------------
CREATE SEQUENCE transaction_reversal_s1 START WITH 1;

-- INSERT INTO transaction FROM transaction_reversal------------------------------------------------
INSERT INTO transaction
( transaction_id
, transaction_account
, transaction_type
, transaction_date
, transaction_amount
, rental_id
, payment_method_type
, payment_account_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
(SELECT transaction_s1.NEXTVAL
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
,last_update_date FROM transaction_reversal);

-- VALIDATION QUERY---------------------------------------------------------------------------------
COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20

-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement" FROM dual;
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;

-- SHOULD BE----------------------------------------------------------------------------------------
-- Debit Transactions   Credit Transactions  All Transactions
-- -------------------- -------------------- --------------------
--               4,681                1,170                5,851

-- -------------------------------------------------------------------------------------------------
-- STEP 4
--      QUERY DATA FOR TRANSFORMATION REPORT
-- -------------------------------------------------------------------------------------------------

-- THIS UPDATE STATEMENT IS HERE BECAUSE MY COMMON_LOOKUP_ID'S DO NOT MATCH IN THE CSV FILE
-- SO I CHANGED IT IN THE TRANSACTION TABLE AFTER THE INSERT AND BEFORE THE QUERY
UPDATE transaction
SET transaction_type =
CASE
    WHEN transaction_account = '222-222-222-222' THEN 1024
    WHEN transaction_account = '111-111-111-111' THEN 1025
END;

COLUMN "SORTKEY" NOPRINT
COLUMN "Transaction" FORMAT A15
COLUMN "Jan" FORMAT A10
COLUMN "Feb" FORMAT A10
COLUMN "Mar" FORMAT A10
COLUMN "Apr" FORMAT A10
COLUMN "May" FORMAT A10
COLUMN "Jun" FORMAT A10
COLUMN "Jul" FORMAT A10
COLUMN "Aug" FORMAT A10
COLUMN "Sep" FORMAT A10
COLUMN "Oct" FORMAT A10
COLUMN "Nov" FORMAT A10
COLUMN "Dec" FORMAT A10
COLUMN "F1Q" FORMAT A10
COLUMN "F2Q" FORMAT A10
COLUMN "F3Q" FORMAT A10
COLUMN "F4Q" FORMAT A10
COLUMN "YTD" FORMAT A10

SELECT   CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END AS "Transaction"
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END AS "SORTKEY"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Jan"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Feb"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Mar"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F1Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Apr"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "May"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Jun"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F2Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Jul"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Aug"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Sep"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F3Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Oct"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Nov"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Dec"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F4Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1,2,3,4,5,6,7,8,9,10,11,12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "YTD"
FROM     transaction t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE'
GROUP BY CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END
UNION ALL
SELECT   'Total'
,        3 AS "SORTKEY"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ')
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Feb"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Mar"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F1Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Apr"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "May"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Jun"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F2Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Jul"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Aug"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Sep"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F3Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Oct"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Nov"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "Dec"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F4Q"
,        LPAD(TO_CHAR(SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1,2,3,4,5,6,7,8,9,10,11,12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT' THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "YTD"
FROM     transaction t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE'
GROUP BY 'Total'
ORDER BY SORTKEY;

-- SHOULD BE
-- Transaction     Jan        Feb        Mar        F1Q        Apr        May        Jun        F2Q     Jul           Aug        Sep        F3Q        Oct        Nov        Dec        F4Q        YTD
-- --------------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ------------
-- Debit             2,671.20   4,270.74   5,371.02  12,312.96   4,932.18   2,216.46   1,208.40   8,357.04   2,404.08   2,241.90   2,197.38   6,843.36   3,275.40   3,125.94   2,340.48   8,741.82  36,255.18
-- Credit             -690.06  -1,055.76  -1,405.56  -3,151.38  -1,192.50    -553.32    -298.92  -2,044.74    -604.20    -553.32    -581.94  -1,739.46    -874.50    -833.16    -601.02  -2,308.68  -9,244.26
-- Total             1,981.14   3,214.98   3,965.46   9,161.58   3,739.68   1,663.14     909.48   6,312.30   1,799.88   1,688.58   1,615.44   5,103.90   2,400.90   2,292.78   1,739.46   6,433.14  27,010.92



-- Close log file.----------------------------------------------------------------------------------
SPOOL OFF

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! END !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!





