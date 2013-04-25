get_session(s_ID,uID,pswd)
  (
    pv_sessionid    IN    VARCHAR(30)
    pv_userid       IN    VARCHAR(20)
    pv_passwd       IN    VARCHAR(40)
    pv_remote_addr  INOUT VARCHAR(15)
    sv_userid       OUT   VARCHAR(20)
    sv_client_info  OUT   INT 
    )

  
  SELECT

  remoteAddress = PHP_SESSION_VAR['remoteAddress']

  if NOTFOUND
    if !set(uID) and !set(pswd)
      -- record_session(s_ID)
      INSERT INTO invalid_session
      return 0

  @userID = suName

  if suGroupID = 0
    @clientInfo = suGroupID
  else
    @clientInfo = suID

  if remoteAddress = ssRemoteAdd
    -- update_session(s_ID,remoteAddress)
    UPDATE statement
    return ssSessionID
  else
    -- record_session(s_ID)
    INSERT INTO invalid_session
    return 0

------------------------------------------

-- update_session(s_ID,remoteAddress)

--   UPDATE system_session
--     where s_ID and remoteAddress

--   if UPDATE
--     commit
--   else
--     rollback

------------------------------------------

-- record_session(s_ID)

--   INSERT INTO invalid_session
--     NULL
--     s_ID
--     @remoteAddress
--     -1, date, -1, date

--   if INSERT
--     commit
--   else
--     rollback

------------------------------------------

set_User(suName)
  
  cursor
    select 
      suID
    where suName

  open cursor
  fetch cursor into lv

  if cursor%NOTFOUND
    lv = 0
  
  return lv

