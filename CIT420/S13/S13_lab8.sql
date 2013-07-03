-- NDS statements
-- stmt
-- EXECUTE IMEDIATE
-- USING
-- dbms_assert.simple_sql_name()
-- dbms_assert.enquote_literal()
-- Concatenation

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE lab8
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_address_type        VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_street_address      VARCHAR2
, pv_created_by          NUMBER   := 1
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := 1
, pv_last_update_date    DATE     := SYSDATE) IS

  -- Required when working in Oracle 10g or older releases.
  -- Local variables to manage sequence values in DML statements.
  lv_contact_id          NUMBER;
  lv_address_id          NUMBER;
  lv_street_address_id   NUMBER;

  -- Local variables, to leverage subquery assignments in INSERT statements.
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);

  stmt                   VARCHAR2(2000);

BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  lv_address_type := pv_address_type;
  lv_contact_type := pv_contact_type;

  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  contact_s1.NEXTVAL
  INTO    lv_contact_id
  FROM    dual;

  stmt := 'INSERT INTO '||dbms_assert.simple_sql_name('CONTACT')
       || ' ( contact_id'
       || ' , member_id'
       || ' , contact_type'
       || ' , last_name'
       || ' , first_name'
       || ' , middle_name'
       || ' , created_by'
       || ' , creation_date'
       || ' , last_updated_by'
       || ' , last_update_date)'
       || '  VALUES '
       || ' ( :lv_contact_id'
       || ' , 1001'
       || ' ,(SELECT   common_lookup_id'
       || '   FROM     common_lookup'
       || '   WHERE    common_lookup_table = '||dbms_assert.enquote_literal('CONTACT')
       || '   AND      common_lookup_column = '||dbms_assert.enquote_literal('CONTACT_TYPE')
       || '   AND      common_lookup_type = :lv_contact_type)'
       || ' , :pv_last_name'
       || ' , :pv_first_name'
       || ' , :pv_middle_name'
       || ' , :pv_created_by'
       || ' , :pv_creation_date'
       || ' , :pv_last_updated_by'
       || ' , :pv_last_update_date )';

  EXECUTE IMMEDIATE stmt
    USING lv_contact_id
        , lv_contact_type
        , pv_last_name
        , pv_first_name
        , pv_middle_name
        , pv_created_by
        , pv_creation_date
        , pv_last_updated_by
        , pv_last_update_date;

  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  address_s1.NEXTVAL
  INTO    lv_address_id
  FROM    dual;

  stmt := 'INSERT INTO '||dbms_assert.simple_sql_name('ADDRESS')
  || ' VALUES '
  || ' ( lv_address_id'
  || ' , lv_contact_id'
  || ' ,(SELECT   common_lookup_id'
  || '   FROM     common_lookup'
  || '   WHERE    common_lookup_table = '||dbms_assert.enquote_literal('ADDRESS')
  || '   AND      common_lookup_column = '||dbms_assert.enquote_literal('ADDRESS_TYPE')
  || '   AND      common_lookup_type = lv_address_type)'
  || ' , pv_city'
  || ' , pv_state_province'
  || ' , pv_postal_code'
  || ' , pv_created_by'
  || ' , pv_creation_date'
  || ' , pv_last_updated_by'
  || ' , pv_last_update_date )';

  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  street_address_s1.NEXTVAL
  INTO    lv_street_address_id
  FROM    dual;

  stmt := 'INSERT INTO '||dbms_assert.simple_sql_name('STREET_ADDRESS')
       || ' VALUES '
       || '( lv_street_address_id'
       || ', lv_address_id'
       || ', 1'
       || ', pv_street_address'
       || ', pv_created_by'
       || ', pv_creation_date'
       || ', pv_last_updated_by'
       || ', pv_last_update_date )';

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    dbms_output.put_line('Hey Dummy! '||SQLERRM);
    RETURN;

END lab8;
/

-- Display any compilation errors.
SHOW ERRORS

CALL lab8('Sherlock',NULL,'Holmes','CUSTOMER','HOME','London','England','00000','221B Baker Street');
CALL lab8('John','H','Watson','CUSTOMER','HOME','London','England','00000','221B Baker Street');

SELECT c.first_name, c.middle_name, c.last_name
     , s.street_address, a.city, a.state_province
FROM contact c INNER JOIN