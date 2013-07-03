DELETE FROM street_address
  WHERE street_address_id > 1015;

DELETE FROM address
  WHERE address_id > 1015;

DELETE FROM contact
  WHERE first_name IN ('Sherlock', 'John')
  AND   last_name  IN ('Holmes', 'Watson');

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE contact_plus
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
  lv_member_id           NUMBER;
  lv_contact_id          NUMBER;
  lv_address_id          NUMBER;
  lv_street_address_id   NUMBER;

  -- Local variables, to leverage subquery assignments in INSERT statements.
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);

  stmt                   VARCHAR2(2000);

BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  SELECT    common_lookup_id
    INTO    lv_contact_type
    FROM    common_lookup
    WHERE   common_lookup_table   = 'CONTACT'
    AND     common_lookup_column  = 'CONTACT_TYPE'
    AND     common_lookup_type    = pv_contact_type;

  SELECT   common_lookup_id
    INTO    lv_address_type
    FROM     common_lookup
    WHERE    common_lookup_table  = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type   = pv_address_type;

  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  SELECT  contact_s1.NEXTVAL
  INTO    lv_contact_id
  FROM    dual;

  stmt := 'INSERT INTO '
       || dbms_assert.simple_sql_name('CONTACT')
       || ' VALUES '
       || '( :contact_id'
       || ', 1001'
       || ', :contact_type'
       || ', :first_name'
       || ', :middle_name'
       || ', :last_name'
       || ', :created_by'
       || ', :creation_date'
       || ', :last_updated_by'
       || ', :last_update_date)';

  EXECUTE IMMEDIATE stmt
  USING lv_contact_id
      , lv_contact_type
      , pv_first_name
      , pv_middle_name
      , pv_last_name
      , pv_created_by
      , pv_creation_date
      , pv_last_updated_by
      , pv_last_update_date;

  SELECT  address_s1.NEXTVAL
  INTO    lv_address_id
  FROM    dual;

 stmt := 'INSERT INTO '
       || dbms_assert.simple_sql_name('ADDRESS')
       || ' VALUES '
       || '( :lv_address_id'
       || ', :lv_contact_id'
       || ', :lv_address_type'
       || ', :pv_city'
       || ', :pv_state_province'
       || ', :pv_postal_code'
       || ', :pv_created_by'
       || ', :pv_creation_date'
       || ', :pv_last_updated_by'
       || ', :pv_last_update_date)';

  EXECUTE IMMEDIATE stmt
  USING lv_address_id
      , lv_contact_id
      , lv_address_type
      , pv_city
      , pv_state_province
      , pv_postal_code
      , pv_created_by
      , pv_creation_date
      , pv_last_updated_by
      , pv_last_update_date;

  SELECT  street_address_s1.NEXTVAL
  INTO    lv_street_address_id
  FROM    dual;

  stmt := 'INSERT INTO '
       || dbms_assert.simple_sql_name('STREET_ADDRESS')
       || ' VALUES '
       || '( :lv_street_address_id'
       || ', :lv_address_id'
       || ', :pv_street_address'
       || ', :pv_created_by'
       || ', :pv_creation_date'
       || ', :pv_last_updated_by'
       || ', :pv_last_update_date)';

  EXECUTE IMMEDIATE stmt
  USING lv_street_address_id
      , lv_address_id
      , pv_street_address
      , pv_created_by
      , pv_creation_date
      , pv_last_updated_by
      , pv_last_update_date;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('CONTACT_PLUS Error: '||SQLERRM);
    ROLLBACK TO starting_point;
    RETURN;

END contact_plus;
/

-- Display any compilation errors.
SHOW ERRORS

CALL contact_plus('Sherlock', '', 'Holmes', 'CUSTOMER', 'HOME', 'London', 'England', '99354', '221B Bakers Street');
CALL contact_plus('John', 'H', 'Watson', 'CUSTOMER', 'HOME', 'London', 'England', '99354', '221B Bakers Street');
