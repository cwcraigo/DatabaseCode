-- ex04-13.sql
-- Chapter 4, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- Subject: Using the PLS_LOGGER Procedure
-- -----------------------------------------------------------------------
--
@ex04-02.sql
--
-- -----------------------------------------------------------------------
BEGIN
  FOR i IN 1 .. 5 LOOP
    pls_logger  ( pi_program_name   => 'SCREEN_PROGRAM_ERROR'
                , pi_log_level      => 'INFO'
                , pi_write_to       => 'SCREEN'
                , pi_error_message  => 'This execution writes to SCREEN.'
                );

    pls_logger  ( pi_program_name   => 'WARN_PROGRAM_ERROR'
                , pi_log_level      => 'WARN'
                , pi_write_to       => 'TABLE'
                , pi_error_message  => 'This execution writes to TABLE.'
                );

    pls_logger  ( pi_program_name   => 'FATAL_PROGRAM_ERROR'
                , pi_log_level      => 'FATAL'
                , pi_write_to       => 'ALL'
                , pi_error_message  => 'This execution writes to ALL.'
                , pi_file           => 'my_logfile.txt'
                );
  END LOOP;

  FOR j in 1 .. 5 LOOP
    pls_logger  ( pi_program_name     => 'FATAL_PROGRAM_ERROR'
                , pi_log_level        => 'FATAL'
                , pi_write_to         => 'FILE'
                , pi_error_message    => 'This execution writes to FILE.'
                , pi_file             => 'my_logfile.txt'
                );
  END LOOP;
END;
/
