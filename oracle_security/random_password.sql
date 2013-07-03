/* **********************************************************************************
FILENAME
AUTHOR
COPYWRIGHT


CHANGE_LOG
======================================================

REQUIREMENTS random_password:
1 password must have a length of 13-30 characters
2 system generated passwords must be mixed alpha-numeric-special characters
3 control characters are not allowed (`'";&\/:)

REQUIREMENTS pwdvfy_11g_ver_01:
-- 1 pswd cannot be the username or reverse username
-- 2 pswd cannot be the host or instance name
3 pswd is not generally known
-- 3 pswd must contain 1 lowercase, 1 uppercase, 1 digit, and a special character
4 pswd must not be in common hacker dictionaries
-- 5 pswd must be at least 13 but no more than 30 char.
********************************************************************************** */
-- create table x as select dbms_random.string('x',30) my_password from dual
-- connect by level <= 50;
-- OR BETTER WAY
create or replace function random_password ( pi_length in number )
  return varchar2
  is
    l_seed      varchar2(60);
    l_char      varchar2(1);
    l_password  varchar2(30);
  begin
    l_seed := to_char ( systimestamp );
    l_seed := l_seed || sys_context ( 'USERENV', 'SID' );
    l_seed := l_seed || sys_context ( 'USERENV', 'INSTANCE' );

    dbms_random.seed ( l_seed );

    for a in 1 .. pi_length loop
      l_char := dbms_random.string ( 'p', 1 );

      -- remove the following characters:
      while l_char in ( '"', '`', '&', ' ', '''' ) loop
        l_char := dbms_random.string ( 'p', 1 );
      end loop;

      l_password := l_password || l_char;
    end loop;

    return l_password;
  exception
    when others then return 'NO PASSWORD';
  end random_password;

/* ******************************************************************************** */

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