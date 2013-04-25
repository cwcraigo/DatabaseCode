-- ---------------------------------------------------
-- get_sequence_number FUNCTION
-- ---------------------------------------------------

CREATE OR REPLACE FUNCTION get_sequence_number
( pv_table_name VARCHAR2 ) RETURN NUMBER IS

  -- Declare variables for handling NDS sequence value.
  lv_sequence          VARCHAR2(30);
  lv_sequence_output   NUMBER;
  lv_sequence_tagline  VARCHAR2(11) := '_s1.nextval';

  -- Define local variable for Native Dynamic SQL (NDS) Statement.
  stmt  VARCHAR2(2000);

BEGIN

  -- Concatenate the sequence with the sequence tagline.
  lv_sequence := pv_table_name || lv_sequence_tagline;

  -- Assign the sequence through an anonymous block.
  stmt := 'BEGIN '
       || '  SELECT '||lv_sequence||' INTO :output FROM dual;'
       || 'END;';

  -- Run the statement to extract a sequence value through NDS.
  EXECUTE IMMEDIATE stmt USING IN OUT lv_sequence_output;
  RETURN lv_sequence_output;

END;
/

-- ---------------------------------------------------
-- register_session PROCEDURE
-- ---------------------------------------------------

CREATE OR REPLACE PROCEDURE register_session
(pv_userid         IN     NUMBER
,pv_sessionid      IN     VARCHAR2
,pv_session_id     IN OUT NUMBER
,pv_remote_address IN OUT VARCHAR2
) IS

  -- Local var for cursor result.
  lv_system_session_id NUMBER;

  -- Local var for get_sequence_number().
  lv_sequence_number NUMBER;

  -- Local var for NDS statement.
  stmt VARCHAR2(2000);

  -- Declare cursor.
  CURSOR c IS
    SELECT   system_session_id
    FROM     system_session
    WHERE    system_session_number = pv_sessionid
    AND      system_user_id = pv_userid;

BEGIN

  -- Get NEXTVAL from get_sequence_number().
  lv_sequence_number := get_sequence_number('system_session');

  -- Assign insert statement to stmt.
  stmt := 'INSERT INTO '||dbms_assert.simple_sql_name('system_session')
        || ' VALUES '
        || ' (:sequence_number'
        || ' ,:sessionid'
        || ' ,:remote_address'
        || ' ,:userid1'
        || ' ,:userid2'
        || ' ,SYSDATE'
        || ' ,:userid3'
        || ' ,SYSDATE)';

  -- Execute stmt with correct vars
  EXECUTE IMMEDIATE stmt
    USING lv_sequence_number, pv_sessionid
        , pv_remote_address, pv_userid
        , pv_userid, pv_userid;

  -- If DML stmt did not happen then...
  IF SQL%FOUND THEN

    -- Open cursor.
    OPEN c;

    -- Fetch from cursor into param.
    FETCH c INTO pv_session_id;

    -- If cursor didn't fetch then set param to false.
    IF c%NOTFOUND THEN
      pv_session_id := 0;
    END IF;

    -- Close cursor.
    CLOSE c;

  END IF;

END;
/

-- ---------------------------------------------------
-- isset_sessionid FUNCTION
-- ---------------------------------------------------
CREATE OR REPLACE FUNCTION isset_sessionid
(pv_sessionid VARCHAR2) RETURN NUMBER IS

  -- Local variable for cursor result.
  lv_result NUMBER;

  -- Declare cursor.
  CURSOR c IS
    SELECT   1
    FROM     system_session
    WHERE    system_session_number = pv_sessionid;

BEGIN

  -- Open cursor.
  OPEN c;

  -- Fetch from cursor into local var.
  FETCH c INTO lv_result;

  -- If cursor doesn't fetch.
  IF c%NOTFOUND THEN

    -- Result var to false.
    lv_result := 0;

  END IF;

  -- Close cursor.
  CLOSE c;

  -- Return result var.
  RETURN lv_result;

END;
/

-- ---------------------------------------------------
-- verify_db_login FUNCTION
-- ---------------------------------------------------
CREATE OR REPLACE FUNCTION verify_db_login
( userid                      VARCHAR2
, passwd                      VARCHAR2
, sv_session_id       IN OUT  NUMBER
, sv_sessionid        IN OUT  VARCHAR2
, sv_db_userid        IN OUT  NUMBER
, sv_client_info      IN OUT  NUMBER
, sv_remote_address   IN OUT  VARCHAR2
) RETURN NUMBER IS

-- Local vars for cursor.
lv_system_user_id NUMBER;
lv_system_user_group_id NUMBER;

-- Declare cursor.
CURSOR c IS
  SELECT   system_user_id
  ,        system_user_group_id
  FROM     system_user
  WHERE    system_user_name = userid
  AND      system_user_password = passwd
  AND      SYSDATE BETWEEN start_date
                   AND NVL(end_date,SYSDATE);
BEGIN

  -- Open cursor
  OPEN c;

  -- Fetch cursor results
  FETCH c INTO lv_system_user_id, lv_system_user_group_id;

  -- If cursor does not fetch
  IF c%NOTFOUND THEN

    -- Return FALSE
    RETURN 0;

  ELSE

    -- If the session var is not set OR isset_session returns false
    IF sv_session_id IS NULL OR isset_sessionid(sv_sessionid) THEN

      -- Set php session vars to cursor results
      sv_db_userid := lv_system_user_id;
      sv_client_info := lv_system_user_group_id;

      -- Execute register_session()
      register_session(sv_db_userid,sv_sessionid,sv_session_id,sv_remote_address);

    END IF;

    -- Return TRUE
    RETURN 1;

  END IF;

END;
/

-- ---------------------------------------------------
-- TEST CASE
-- ---------------------------------------------------
-- Test Case #1: Verify the submission of valid credentials.

CREATE OR REPLACE PROCEDURE test_case2 IS

  lv_userid      VARCHAR2(60);
  lv_passwd      VARCHAR2(60);
  lv_db_userid   NUMBER;
  lv_client_info NUMBER;
  lv_session_id  NUMBER;
  lv_sessionid   VARCHAR2(30);
  lv_remote_address VARCHAR2(15);
  lv_result      NUMBER;

  CURSOR c IS
    SELECT system_user_password
    FROM system_user
    WHERE system_user_name = lv_userid;

BEGIN

  lv_userid := '&input';

  OPEN c;

  FETCH c INTO lv_passwd;

  IF c%NOTFOUND THEN
    dbms_output.put_line('Please enter a valid user name.');
  ELSE

    lv_db_userid := 12345;
    lv_client_info := 9999;
    -- lv_session_id
    lv_sessionid := '11111';
    lv_remote_address := 'ABCD';

    lv_result := verify_db_login(lv_userid,lv_passwd,lv_db_userid
                                ,lv_client_info,lv_session_id,lv_sessionid
                                ,lv_remote_address);

    dbms_output.put_line('RESULT      ['||lv_result     ||']'||CHR(10)||
                         'USERID      ['||lv_userid     ||']'||CHR(10)||
                         'PASSWD      ['||lv_passwd     ||']'||CHR(10)||
                         'DB_USERID   ['||lv_db_userid  ||']'||CHR(10)||
                         'CLIENT_INFO ['||lv_client_info||']'||CHR(10)||
                         'SESSION_ID  ['||lv_session_id ||']'||CHR(10)||
                         'SESSIONID   ['||lv_sessionid  ||']');

  END IF;

  CLOSE c;

END;
/