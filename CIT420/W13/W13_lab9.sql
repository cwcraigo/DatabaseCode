
-- DELETE FROM street_address
--   WHERE street_address_id > 15;

-- DELETE FROM address
--   WHERE address_id > 15;

-- DELETE FROM contact
--   WHERE first_name IN ('Sherlock', 'John')
--   AND   last_name  IN ('Holmes', 'Watson');




DELIMITER $$

DROP PROCEDURE IF EXISTS contact_plus$$

CREATE PROCEDURE contact_plus
( pv_first_name          VARCHAR(20)
, pv_middle_name         VARCHAR(20)
, pv_last_name           VARCHAR(20)
, pv_contact_type        VARCHAR(30)
, pv_address_type        VARCHAR(30)
, pv_city                VARCHAR(30)
, pv_state_province      VARCHAR(30)
, pv_postal_code         VARCHAR(20)
, pv_street_address      VARCHAR(30)
, pv_created_by          INT
, pv_creation_date       DATE
, pv_last_updated_by     INT
, pv_last_update_date    DATE)
MODIFIES SQL DATA
BEGIN

  DECLARE stmt VARCHAR(1024);

  DECLARE lv_success_value INT DEFAULT 1;

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET lv_success_value := 0;

  SET @pv_first_name       := pv_first_name;
  SET @pv_middle_name      := pv_middle_name;
  SET @pv_last_name        := pv_last_name;
  SET @pv_contact_type     := pv_contact_type;
  SET @pv_address_type     := pv_address_type;
  SET @pv_city             := pv_city;
  SET @pv_state_province   := pv_state_province;
  SET @pv_postal_code      := pv_postal_code;
  SET @pv_street_address   := pv_street_address;
  SET @pv_created_by       := pv_created_by;
  SET @pv_creation_date    := pv_creation_date;
  SET @pv_last_updated_by  := pv_last_updated_by;
  SET @pv_last_update_date := pv_last_update_date;

  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  SELECT    common_lookup_id
    INTO    @lv_contact_type
    FROM    common_lookup
    WHERE   common_lookup_table   = 'CONTACT'
    AND     common_lookup_column  = 'CONTACT_TYPE'
    AND     common_lookup_type    = pv_contact_type;

  SELECT    common_lookup_id
    INTO    @lv_address_type
    FROM    common_lookup
    WHERE   common_lookup_table  = 'ADDRESS'
    AND     common_lookup_column = 'ADDRESS_TYPE'
    AND     common_lookup_type   = pv_address_type;

  -- Create a SAVEPOINT as a starting point.
  START TRANSACTION;
  SAVEPOINT starting_point;

  SET @SQL := 'INSERT INTO contact VALUES (NULL, 1, ?, ?, ?, ?, ?, ?, ?, ?)';

  PREPARE stmt FROM @SQL;

  EXECUTE stmt USING @lv_contact_type
                   , @pv_first_name
                   , @pv_middle_name
                   , @pv_last_name
                   , @pv_created_by
                   , @pv_creation_date
                   , @pv_last_updated_by
                   , @pv_last_update_date;

  DEALLOCATE PREPARE stmt;

  SET @lv_contact_id := last_insert_id();

  SET @SQL := 'INSERT INTO address VALUES ( NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

  PREPARE stmt FROM @SQL;

  EXECUTE stmt USING @lv_contact_id
                   , @lv_address_type
                   , @pv_city
                   , @pv_state_province
                   , @pv_postal_code
                   , @pv_created_by
                   , @pv_creation_date
                   , @pv_last_updated_by
                   , @pv_last_update_date;

  DEALLOCATE PREPARE stmt;

  SET @lv_address_id := last_insert_id();

  SET @SQL := 'INSERT INTO street_address VALUES ( NULL, ?, ?, ?, ?, ?, ?)';

  PREPARE stmt FROM @SQL;

  EXECUTE stmt USING @lv_address_id
                   , @pv_street_address
                   , @pv_created_by
                   , @pv_creation_date
                   , @pv_last_updated_by
                   , @pv_last_update_date;

  DEALLOCATE PREPARE stmt;

  IF (lv_success_value = 0) THEN
    ROLLBACK TO starting_point;
    SELECT 'FAILED' AS 'RESULT';
  ELSE
    COMMIT;
    SELECT 'SUCCESS' AS 'RESULT';
  END IF;

END;
$$
DELIMITER ;

CALL contact_plus('Sherlock','','Holmes','CUSTOMER','HOME','London','England','99354','221B Bakers Street',1,UTC_DATE(),1,UTC_DATE());
CALL contact_plus('John','H','Watson','CUSTOMER','WORK','London','England','99354','221B Bakers Street',1,UTC_DATE(),1,UTC_DATE());
SHOW WARNINGS;

-- SELECT CONCAT(c.last_name, ', ',c.first_name,' ', IFNULL(c.middle_name,'')) AS 'NAME'
--      , cl1.common_lookup_type AS 'CONTACT_TYPE'
--      , cl2.common_lookup_type AS 'ADDRESS_TYPE'
--      , CONCAT(sa.street_address,' ',a.city,', ',a.state_province,' ',a.postal_code) AS 'ADDRESS'
-- FROM contact c
-- INNER JOIN address a ON c.contact_id = a.contact_id
-- INNER JOIN street_address sa ON a.address_id = sa.address_id
-- INNER JOIN common_lookup cl1 ON cl1.common_lookup_id = c.contact_type
-- INNER JOIN common_lookup cl2 ON cl2.common_lookup_id = a.address_type
-- WHERE c.first_name IN ('Sherlock', 'John');


