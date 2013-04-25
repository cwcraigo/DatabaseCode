-- ex04-06.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Encasing Sub Blocks
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
DECLARE
  ln_parent         NUMBER;
  ln_child_level1   NUMBER;
  ln_child_level2   NUMBER;
  ln_random_0_1     NUMBER;
BEGIN
  BEGIN
    DBMS_OUTPUT.PUT_LINE ( 'Made it past Parent.' );
    ln_random_0_1 := ROUND ( DBMS_RANDOM.VALUE ( 0, 1 ));
    ln_parent := 1 / ln_random_0_1;
    BEGIN
      DBMS_OUTPUT.PUT_LINE ( 'Made it past Child Level 1.' );
      ln_random_0_1 := ROUND ( DBMS_RANDOM.VALUE ( 0, 1 ));
      ln_child_level1 := 1 / ln_random_0_1;
      BEGIN
        DBMS_OUTPUT.PUT_LINE ( 'Made it past Child Level 2.' );
        ln_random_0_1 := ROUND ( DBMS_RANDOM.VALUE ( 0, 1 ));
        ln_child_level2 := 1 / ln_random_0_1;
      END;
    END;
  END;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ( SQLERRM );
END;
/
