-- This is an extra credit assignment.

-- Requirements:

-- Write the following MySQL functions and procedures:

-- A procedure that inserts parameters into the MEMBER table.
-- A procedure that inserts parameters into the CONTACT table.
-- A procedure that inserts parameters into the ADDRESS table.
-- A procedure that inserts parameters into the TELEPHONE table.

-- A procedure that inserts parameters into the add_member, add_contact, add_address,
-- and add_telephone procedures, where a member may have one or more contacts.

-- Provide the CONTACT, ADDRESS, and TELEPHONE information in a serialized string where
-- commas delimit fields and semicolons delimit records.

-- Test Case:
-- Insert a new single/individual member account with member, contact, address, and telephone information.
-- Insert a new family member account with member and two or more contacts, address, and telephone information.

-- MEMBER
--   account_number
--   credit_card_number
--   credit_card_type
--   member_type
-- CONTACT
--   member_id
--   contact_type
--   first_name
--   middle_name
--   last_name
-- ADDRESS
--   -- contact_id use last_insert_id()
--   address_type
--   city
--   state_province
--   postal_code
-- TELEPHONE
--   -- contact_id use last_insert_id()
--   -- address_id use last_insert_id()
--   telephone_type
--   country_code
--   area_code
--   telephone_number


-- -----------------------------------------------------------------------
DELIMITER $$

-- Drop the procedure if it exists.
DROP PROCEDURE IF EXISTS set_session_var$$

-- Create the procedure.
CREATE PROCEDURE set_session_var
( pv_session_name   VARCHAR(32767)
, pv_session_value  VARCHAR(32767))
CONTAINS SQL
BEGIN

  /* Insert statement with auto commit enabled. */
  SET @SQL := CONCAT('SET',' ','@',pv_session_name,' := ','?');
  PREPARE stmt FROM @SQL;
  SET @sv_session_value := pv_session_value;
  EXECUTE stmt USING @sv_session_value;
  DEALLOCATE PREPARE stmt;

END;
$$


-- Drop the procedure if it exists.
DROP PROCEDURE IF EXISTS deserialize_fields$$

CREATE PROCEDURE deserialize_fields
( pv_param_list VARCHAR(32767))
CONTAINS SQL
BEGIN
  DECLARE lv_name     VARCHAR(9) DEFAULT 'sv_field';
  DECLARE lv_length   INT;
  DECLARE lv_start    INT DEFAULT 1;
  DECLARE lv_end      INT DEFAULT 1;

  /* Set a session variable to enable a calling scope to
     read it without a function return. */
  SET @sv_field_counter := 1;

  /* Skip when call parameter list is null or empty. */
  IF NOT (ISNULL(pv_param_list) OR LENGTH(pv_param_list) = 0) THEN

    /* Read line by line on a line return character. */
    parse: WHILE NOT (lv_end = 0) DO

      /* Check for line returns. */
      SET lv_end := LOCATE(';',pv_param_list,lv_start);

      /* Check whether line return has been read. */
      IF NOT lv_end = 0 THEN  /* Reset the ending substring value. */
        SET lv_end := LOCATE(';',pv_param_list,lv_start);
        CALL set_session_var(CONCAT(lv_name,@sv_field_counter),SUBSTR(pv_param_list,lv_start,lv_end - lv_start));
      ELSE  /* Print the last substring with a semicolon. */
        CALL set_session_var(CONCAT(lv_name,@sv_field_counter),SUBSTR(pv_param_list,lv_start,LENGTH(pv_param_list)));
      END IF;

      /* Reset the beginning of the string. */
      SET lv_start := lv_end + 1;
      SET @sv_field_counter := @sv_field_counter + 1;

    END WHILE parse;

  END IF;

  /* Reduce by one for 1-based numbering of name elements. */
  SET @sv_field_counter := @sv_field_counter - 1;

END;
$$




-- Drop the procedure if it exists.
DROP PROCEDURE IF EXISTS deserialize$$

CREATE PROCEDURE deserialize
( pv_param_list VARCHAR(32767))
CONTAINS SQL
BEGIN
  DECLARE lv_name     VARCHAR(9) DEFAULT 'sv_filter';
  DECLARE lv_length   INT;
  DECLARE lv_start    INT DEFAULT 1;
  DECLARE lv_end      INT DEFAULT 1;

  /* Set a session variable to enable a calling scope to
     read it without a function return. */
  SET @sv_counter := 1;

  /* Skip when call parameter list is null or empty. */
  IF NOT (ISNULL(pv_param_list) OR LENGTH(pv_param_list) = 0) THEN

    /* Read line by line on a line return character. */
    parse: WHILE NOT (lv_end = 0) DO

      /* Check for line returns. */
      SET lv_end := LOCATE(',',pv_param_list,lv_start);

      /* Check whether line return has been read. */
      IF NOT lv_end = 0 THEN  /* Reset the ending substring value. */
        SET lv_end := LOCATE(',',pv_param_list,lv_start);
        CALL set_session_var(CONCAT(lv_name,@sv_counter),SUBSTR(pv_param_list,lv_start,lv_end - lv_start));
      ELSE  /* Print the last substring with a semicolon. */
        CALL set_session_var(CONCAT(lv_name,@sv_counter),SUBSTR(pv_param_list,lv_start,LENGTH(pv_param_list)));
      END IF;

      /* Reset the beginning of the string. */
      SET lv_start := lv_end + 1;
      SET @sv_counter := @sv_counter + 1;

    END WHILE parse;

  END IF;

  /* Reduce by one for 1-based numbering of name elements. */
  SET @sv_counter := @sv_counter - 1;

END;
$$



DROP PROCEDURE IF EXISTS test_deserialize_fields$$
CREATE PROCEDURE test_deserialize_fields()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE stmt VARCHAR(2000);

  CALL deserialize_fields(@str);
  SELECT @sv_field_counter;

  myLoop:WHILE i<@sv_field_counter DO

    SET @SQL := CONCAT('SELECT @sv_field',i);
    PREPARE stmt FROM @SQL;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET i = i + 1;

  END WHILE myLoop;

END;
$$


DELIMITER ;

SET @str = '101010,12345,DISCOVER_CARD,CUSTOMER;
            101010,INDIVIDUAL,Billy,NULL,Bob;
            HOME,Rexburg,Idaho,83440;
            HOME,1,509,392-2987;';

CALL test_deserialize_fields();
SELECT LENGTH(@sv_field2);

