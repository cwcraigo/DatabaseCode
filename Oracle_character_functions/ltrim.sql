-- LTRIM() trims off leading characters
  -- first arg is string
  -- (opt) second arg is letters on the left you want to get rid of

SELECT
  LTRIM('     Bob') LTRIM1
, LTRIM('BiBiBiBiBBilly/Billy','Bi') LTRIM2
FROM dual
/
