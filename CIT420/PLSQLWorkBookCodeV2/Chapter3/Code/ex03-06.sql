-- ex03-06.sql
-- Chapter 3, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Setting Transaction Level to Read Consistency
---------------------------------------------------------------------------
INSERT
  INTO  hr.job_history
VALUES  ( 100, '01-Jan-2000', trunc( sysdate ), 'AD_PRES', 90 );

COMMIT
  COMMENT 'In-doubt transaction forced by process xyz on date 123';

SET TRANSACTION READ ONLY NAME 'Distributed to NYC';

SELECT  product_id
     ,  warehouse_id
     ,  quantity_on_hand
  FROM  oe.inventories@nyc_001
 WHERE  product_id = 3246;

COMMIT;
