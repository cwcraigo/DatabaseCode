-- SUDO CODE FOR CIT 420 FINAL - PART 2

-- --------------------------------------------------------------
CREATE_NEW_DB_USER
(userid INT UNSIGNED
,nuserid VARCHAR(20)
,npasswd VARCHAR(40)
,fname VARCHAR(20)
,lname VARCHAR(20)
,ugroup INT UNSIGNED
,sv_client_info INT UNSIGNED
)

written = false

IF is_inserted(nuserid) = 0 AND sv_client_info = 0 THEN

  INSERT INTO system_user
  ( system_user_id
  , system_user_name
  , system_user_password
  , first_name
  , last_name
  , system_user_group_id
  , start_date
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( NULL
  , nuserid
  , npasswd
  , fname
  , lname
  , ugroup
  , NOW()
  , userid
  , NOW()
  , userid
  , NOW())

  IF inserted THEN
    written = true
  END IF;

END IF;


-- --------------------------------------------------------------

-- --------------------------------------------------------------
IS_INSERTED
(nuserid VARCHAR(20))

  SELECT   null
  FROM     system_user
  WHERE    system_user_name = nuserid

  IF fetched THEN
    RETURN TURE;
  ELSE
    RETURN FALSE;
  END IF;
