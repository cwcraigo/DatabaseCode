-- LPAD() fills in characters on the left of the string
  -- first arg is the string
  -- second arg is # of characters the column should have
  -- third arg is what to fill in on the left if whitespace (if you dont want whitespace)

SELECT
  LPAD('Bob',15,'*') AS LPAD1
, LPAD('Billy',15) AS LPAD2
FROM dual
/
