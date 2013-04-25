




CREATE TRIGGER `cwcraigo_intro2techdb`.`user_email_insert_trigger`
BEFORE INSERT ON `cwcraigo_intro2techdb`.`user`
FOR EACH ROW
BEGIN
  DECLARE msg VARCHAR(255);
  DECLARE lv_email VARCHAR(20);

  SET lv_email := new.email;

  IF lv_email REGEXP '^.*@byui.edu$' THEN
    SET new.email := lv_email;
  ELSE
	  SET msg = 'MyTriggerError: Invalid BYUI email address.';
	  SIGNAL SQLSTATE '45000' SET message_text = msg;
  END IF;

END$$



CREATE TRIGGER `cwcraigo_intro2techdb`.`user_email_update_trigger`
BEFORE UPDATE ON `cwcraigo_intro2techdb`.`user`
FOR EACH ROW
BEGIN
  DECLARE msg VARCHAR(255);
  DECLARE lv_email VARCHAR(20);

  SET lv_email := new.email;

  IF lv_email REGEXP '^.*@byui.edu$' THEN
    SET new.email := lv_email;
  ELSE
	  SET msg = CONCAT('MyTriggerError: Invalid
									  	BYUI email address: ', CAST(new.user_id AS CHAR));
	  SIGNAL SQLSTATE '45000' SET message_text = msg;
  END IF;

END$$