SET LINESIZE 180
SET SERVEROUTPUT ON SIZE UNLIMITED

@create_identity_db3.sql

CREATE OR REPLACE PROCEDURE create_new_db_user
(userid             NUMBER
,nuserid            VARCHAR2
,npasswd            VARCHAR2
,fname              VARCHAR2
,lname              VARCHAR2
,ugroup             NUMBER
,sv_client_info     NUMBER
,return_value   OUT NUMBER
) IS

  CURSOR c IS
    SELECT   NULL
    FROM     system_user
    WHERE    system_user_name = nuserid;

  lv_is_inserted c%ROWTYPE;

BEGIN

  OPEN c;
  FETCH c INTO lv_is_inserted;

  IF c%NOTFOUND AND sv_client_info = 0 THEN

    INSERT INTO system_user VALUES
    (system_user_s1.nextval
    ,nuserid,npasswd,ugroup
    ,SYSDATE,NULL,lname,fname,NULL
    ,userid,SYSDATE,userid,SYSDATE);

    return_value := 1;
  ELSE
    return_value := 0;
  END IF;

  CLOSE c;

  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      dbms_output.put_line(SQLERRM);
END;
/
LIST
SHOW ERRORS

DECLARE
  userid             NUMBER;
  nuserid            VARCHAR2(60);
  npasswd            VARCHAR2(60);
  fname              VARCHAR2(60);
  lname              VARCHAR2(60);
  ugroup             NUMBER;
  sv_client_info     NUMBER;
  return_value       NUMBER;
BEGIN

  userid         :=  1;
  sv_client_info :=  0;
  -- ----------------------------------------------------------
  -- TEST CASE #1 - EXISTING USER
  -- ----------------------------------------------------------
  SELECT system_user_name,system_user_password
  ,      first_name,last_name,system_user_group_id
  INTO   nuserid,npasswd,fname,lname,ugroup
  FROM   system_user WHERE  system_user_id = 1;

  create_new_db_user(userid,nuserid,npasswd,fname,lname
                    ,ugroup,sv_client_info,return_value);

  IF return_value = 0 THEN
    RAISE_APPLICATION_ERROR(-20001,'FAILURE!');
  ELSE
    dbms_output.put_line('SUCCESS!');
  END IF;
  -- ----------------------------------------------------------
  -- TEST CASE #2 - NEW USER
  -- ----------------------------------------------------------
  nuserid        :=  'cwcraigo';
  npasswd        :=  'Pa$$w0rd';
  fname          :=  'Craig';
  lname          :=  'Christensen';
  ugroup         :=  0;

  create_new_db_user(userid,nuserid,npasswd,fname,lname
                    ,ugroup,sv_client_info,return_value);

  SELECT COUNT(*) INTO lv_count
  FROM system_user
  WHERE system_user_name = nuserid;

  IF return_value = 0 THEN
    RAISE_APPLICATION_ERROR(-20001,'FAILURE!');
  ELSE
    dbms_output.put_line('SUCCESS!');
  END IF;

  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
END;
/





-- CREATE_NEW_DB_USER
-- (userid           -- system_user_id int
-- ,nuserid          -- system_user_name string
-- ,npasswd          -- system_user_password string
-- ,fname            -- first_name string
-- ,lname            -- last_name string
-- ,ugroup           -- system_user_group_id int
-- ,sv_client_info   -- int
-- ,return_value     -- int
-- )

-- lv_is_inserted DEFAULT 0

-- SELECT   1 INTO lv_is_inserted
-- FROM     system_user
-- WHERE    system_user_name = nuserid

-- IF NOT lv_is_inserted = 1 AND sv_client_info = 0 THEN

--   INSERT INTO system_user
--   ( system_user_id
--   , system_user_name
--   , system_user_password
--   , system_user_group_id
--   , start_date
--   , end_date
--   , last_name
--   , first_name
--   , middle_initial
--   , created_by
--   , creation_date
--   , last_updated_by
--   , last_update_date)
--   VALUES
--   ( system_user_s1.nextval
--   , nuserid
--   , npasswd
--   , usergroup
--   , firstname
--   , lastname
--   , NOW()
--   , userid
--   , NOW()
--   , userid
--   , NOW());

--   IF inserted THEN
--     RETURN 1
--   ELSE
--     RETURN 0
--   END IF

-- END IF