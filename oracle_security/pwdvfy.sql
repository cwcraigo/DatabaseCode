create or replace function pwdvfy_11g_ver_01
  (
    username      in varchar2
  , password      in varchar2
  , old_password  in varchar2
  )
  return boolean
  is
    l_username_forward  varchar2(30);
    l_username_reverse  varchar2(30);
  begin
---------------------------------------------------------------------------
-- populate variables
---------------------------------------------------------------------------
    select  username
         ,  reverse ( username )
      into  l_username_forward
         ,  l_username_reverse
      from  dual;
---------------------------------------------------------------------------
-- REQ#1: not username or reverse username
---------------------------------------------------------------------------
    if lower ( trim ( password )) = lower ( trim ( l_username_forward ))
    or lower ( trim ( password )) = lower ( trim ( l_username_reverse ))
    then
      raise_application_error ( -20001, 'Password too similar to username' );
    end if;
---------------------------------------------------------------------------
-- everything checks out fine
---------------------------------------------------------------------------
    return true;
  end pwdvfy_11g_ver_01;