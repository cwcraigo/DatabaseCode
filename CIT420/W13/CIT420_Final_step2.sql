


DECLARE


BEGIN
  
  pv_userid := 'administrator';
  SELECT system_user_password 
  INTO pv_password
  FROM system_user 
  WHERE system_user_name = pv_userid;

  dbms_output.put_line(verify_db_login(pv_userid, pv_password,............));

END;
/


