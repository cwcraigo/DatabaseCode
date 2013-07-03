CREATE OR REPLACE FUNCTION verify_pwd
(username VARCHAR2
,password VARCHAR2) RETURN BOOLEAN IS

chararray      VARCHAR2(52);
differ         INTEGER;
digitarray     VARCHAR2(20);
ischar         BOOLEAN;
isdigit        BOOLEAN;
ispunct        BOOLEAN;
isupper        BOOLEAN;
islower        BOOLEAN;
m              INTEGER;
n              BOOLEAN;
punctarray     VARCHAR2(25);
instance_name  VARCHAR2(30);
rev_pswd       VARCHAR2(30);

BEGIN

   SELECT SYS_CONTEXT('userenv', 'instance_name') INTO instance_name FROM dual;

   -- check for password identical with userid
   IF password = instance_name THEN
      raise_application_error(-20001, 'Password same as instance name');
   END IF;


   digitarray := '0123456789';
   chararray := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   punctarray := '!#$%&()*+,-/:;<=>?_';

   -- check for password identical with userid
   IF password = username THEN
      raise_application_error(-20001, 'Password same as user id');
   END IF;

   SELECT REVERSE(username) INTO rev_pswd FROM dual;

   -- check for reverse username
   IF password = rev_pswd THEN
      raise_application_error(-20001, 'Password same as reverse user id');
   END IF;

   -- check for password identical with userid
   IF password = username THEN
      raise_application_error(-20001, 'Password same as user id');
   END IF;

   -- check for new password identical with old password
   -- IF UPPER(password) = UPPER(old_password) THEN
   --    raise_application_error(-20002, 'New Password Can Not Be The Same As Old Password');
   -- END IF;

   -- check for minimum password length
   IF LENGTH(password) < 12 OR LENGTH(password) > 31 THEN
      raise_application_error(-20003, 'Password Length Must Be At Least 6 Characters In Length');
   END IF;

   -- check for common words
   IF password IN ('welcome', 'password', 'oracle', 'computer', 'abcdef', 'abc123', 'cangetin', 'aaa') THEN
      raise_application_error(-20004, 'Password Can Not Be A Common Word');
   END IF;

   -- check for passwords starting with AEI
   -- IF UPPER(SUBSTR(password,1,3)) = 'AEI' THEN
   --    raise_application_error(-20005, 'Password Can Not Start With The Letters AEI');
   -- END IF;

   isdigit := FALSE;
   m := LENGTH(password);

   if    regexp_count ( password, '[a-z]', 1, 'c'                ) < 1
   or    regexp_count ( password, '[A-Z]', 1, 'c'                ) < 1
   or    regexp_count ( password, '[0-9]', 1, 'c'                ) < 1
   or    regexp_count ( password, '[!@#$%^;:<>\*\?\.\,]', 1, 'c' ) < 1
   then
   raise_application_error ( -20004, 'Password must contain 1 lower case, 1 upper case, 1 digit, and a special character' );
   end if;

   -- -- Make sure new password differs from old by at least three characters
   -- IF old_pwd = '' THEN
   --    raise_application_error(-20009, 'Old Password Is Null');
   -- END IF;

   -- Everything is fine; return TRUE
   RETURN(TRUE);

   -- differ := LENGTH(old_password) - LENGTH(password);
   -- IF ABS(differ < 3) THEN
   --    IF LENGTH(password) < LENGTH(old_password) THEN
   --       m := LENGTH(password);
   --    ELSE
   --       m := LENGTH(old_password);
   --    END IF;

   --    differ := ABS(differ);

   --    FOR i IN 1..m LOOP
   --       IF SUBSTR(password,i,1) != SUBSTR(old_password,i,1) THEN
   --          differ := differ + 1;
   --       END IF;
   --    END LOOP;

   --    IF differ < 3 THEN
   --       raise_application_error(-20010, 'Password Must Differ By At Least 3 Characters');
   --    END IF;
   -- END IF;
   -- -- Everything is fine; return TRUE
   -- RETURN(TRUE);

EXCEPTION WHEN OTHERS THEN
   RETURN(FALSE);
END;
/
show errors
