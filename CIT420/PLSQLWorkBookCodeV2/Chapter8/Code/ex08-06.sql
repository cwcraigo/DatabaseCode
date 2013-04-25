-- ex08-06.sql
-- Chapter 8, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Error Thrown when Subroutines Do Not Match
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE video_store.vs_transaction
AS
lv_account_number varchar2(50);
ln_payment_method number;
 PROCEDURE check_out ( pi_created_by IN NUMBER
 , pi_last_updated_by IN NUMBER
 , pi_transaction_type IN NUMBER
 );
END vs_transaction;
/

CREATE OR REPLACE PACKAGE BODY video_store.vs_transaction
 AS
 PROCEDURE check_out ( pi_created_by IN NUMBER
 , pi_last_updated_by IN NUMBER
 , pi_transaction_type IN VARCHAR2
 )
 IS
 BEGIN
  NULL;
END check_out;
END vs_transaction;
/