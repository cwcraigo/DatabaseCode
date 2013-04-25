 <?php

 // ----------------------------------------------------------------

  // Get a valid session.
  function get_session($sessionid,$userid = null,$passwd = null)
  {
    global $myConn;

      // Assign metadata to local variable.
      $remote_address = $_SERVER['REMOTE_ADDR'];

      // Return database UID within 5 minutes of session registration.
      $sql = "CALL get_session(?,?,?,?,?,?,?)";

    // Attempt connection and evaluate password.
    if ($stmt = $myConn->prepare($sql))
    {

      // Bind the variables as strings.
      $stmt->bind_param('sssssss' ,$sessionid,$userid,$passwd,$remote_address,$_SESSION['userid'],$_SESSION['client_info'],$return_value);

      // Execute the query and raise missing table message on failure.
      if ($stmt->execute())
      {

        return $return_value;

      }
      else
      {
        // Set error message.
        set_error(__FUNCTION__,array('SYSTEM_USER','SYSTEM_SESSION'));
        return 0;
      }

      // Close the connection.
      $stmt->close();
    }
    else
    {
      $errorMessage = oci_error();
      print htmlentities($errorMessage['message'])."<br />";
      return 0;
    }
  }

  // ----------------------------------------------------------------
  // ----------------------------------------------------------------

  // Refresh last update value of session ID.
  // function update_session($c,$sessionid,$remote_address)
  // {
  //   // Insert a new session.
  //   $s = oci_parse($c,"UPDATE   system_session
  //                      SET      last_update_date = SYSDATE
  //                      WHERE    system_session_number = :sessionid
  //                      AND      system_remote_address = :remote_address");

  //   // Bind the variables as strings.
  //   oci_bind_by_name($s,":sessionid",$sessionid);
  //   oci_bind_by_name($s,":remote_address",$remote_address);

  //   // Execute the query and raise missing table message on failure.
  //   if (!@oci_execute($s,OCI_COMMIT_ON_SUCCESS))
  //   {
  //     // Set error message.
  //     set_error(__FUNCTION__,array('SYSTEM_SESSION'));
  //   }
  // }

  // ----------------------------------------------------------------

  // ----------------------------------------------------------------

  // Register session ID.
  // function record_session($c,$sessionid)
  // {
  //   // Insert a new session.
  //   $s = oci_parse($c,"INSERT
  //                      INTO     invalid_session
  //                      VALUES
  //                      (invalid_session_s1.nextval
  //                      ,:sessionid
  //                      ,:remote_address
  //                      , -1
  //                      ,SYSDATE
  //                      , -1
  //                      ,SYSDATE)");

  //   // Bind the variables as strings.
  //   oci_bind_by_name($s,":sessionid",$sessionid);
  //   oci_bind_by_name($s,":remote_address",$_SERVER['REMOTE_ADDR']);

  //   // Execute the query and raise missing table message on failure.
  //   if (!@oci_execute($s,OCI_COMMIT_ON_SUCCESS))
  //   {
  //     // Set error message.
  //     set_error(__FUNCTION__,array('INVALID_SESSION'));
  //   }
  // }

  // ----------------------------------------------------------------






  ?>