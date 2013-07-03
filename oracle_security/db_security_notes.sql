Fuzzy match
  Jarro Winkler - like soundex

Look for attacts:
- encrypted traffic
- volume of traffic
- session length
- source and target

bulk operations pg 410
dictionary word table

CREATE OR REPLACE PROCEDURE crack() IS

  lr_my_table my_table%
    index by pls_integer;

  CURSOR c IS
    SELECT username, word
    FROM usertable, dictionary;

BEGIN

  OPEN c;
  LOOP
    FETCH c BULK COLLECT INTO lr_my_table LIMIT 500;
    FOR a in 1..lr_my_table.count LOOP
      EXECUTE IMMEDIATE 'ALTER user '||lr_my_table||
  END LOOP;

END;
/

Password streangth

A-Z 26
a-z 26
0-9 10
special 10
------------
char_total=72
char_log=(Log2)(char_total)
length(pwd) * char_log = bits


- set user profiles in oracle!








