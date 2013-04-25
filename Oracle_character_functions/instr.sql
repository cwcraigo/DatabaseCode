-- INSTR() returns the index value of a string within a string.(INSTRB -> bytes instead of char)
  -- first arg is the haystack
  -- second arg is the needle
  -- third is always a # and is where to begin. (if - then backwards)
  -- fourth is which occurance of the needle (I want the first needle)

SELECT
  INSTR('this is bob','bob',1,1) AS INSTR
FROM dual
/
