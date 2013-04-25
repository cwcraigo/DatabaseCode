<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<! UserView.php                                               >
<! PHP Identity Management & Cascading Style Sheets           >
<! by Michael McLaughlin                                      >
<!                                                            >
<! This demonstrates session authentication from an Oracle    >
<! database using sessions.                                   >
<!                                                            >
<! Exception handling only presently identifies a missing or  >
<! altered table. The error handling should be expanded.      >
<head>
<title>
  Identity Management, Part 3 - UserView.php
</title>
</head>
<link rel="stylesheet" type="text/css" href="IdMgmt3.css" />
<body background="stonehenge">
<?php
  // Start session.
  session_start();
  $_SESSION['sessionid'] = session_id();

  // Set database credentials.
  include_once("Credentials3.inc");

  // Set control variable.
  $authenticated = false;

  // Define global constants for database integrity.
  define('DATABASE_VALID',0);
  define('DATABASE_INVALID',1);

  // Set assumed database integrity level.
  $_SESSION['db_error'] = DATABASE_VALID;

  // Assign initial credentials to local variables.
  $userid = @$_POST['userid'];
  $passwd = @$_POST['passwd'];

  // Check for valid session and regenerate when session is invalid:
  // ----------------------------------------------------------------
  //  Rule #1: The session is not registered in the database; or
  //  Rule #2: The last user and current user are the same; and
  //  Rule #3: The user is validating initial login.
  // -----------------------------------------------------------------
  if ((get_session($_SESSION['sessionid'],$userid,$passwd) == 0) ||
      (($_SESSION['userid'] != $userid) && ($userid)))
  {
    // Regenerate session ID.
    session_regenerate_id(true);
    $_SESSION['sessionid'] = session_id();
  }
  else
  {
    $authenticated = true;
  }

  // Check whether the program should:
  // -----------------------------------------------------------------
  //  Action #1: Verify new credentials and start a database session.
  //  Action #2: Continue a session on refresh button.
  //  Action #3: Provide a new form after adding a user.
  //  Action #4: Provide a new form after failing to add a user.
  // -----------------------------------------------------------------
  if (($authenticated) || (authenticate($userid,$passwd)))
  {
    // Render queried view.
    userView($_SESSION['client_info']);
  }
  else
  {
    // Destroy the session and force re-authentication.
    session_destroy();

    // Redirect to the login form.
    signOnUserAdmin();
  }

  /* Library functions.
  || ----------------------------------------------------------------
  ||  Function Name               Return Type  Parameters
  || ---------------------------  -----------  ----------------------
  ||  authenticate()              bool
  ||  get_session()               int          string   $sessionid
  ||                                           string   $userid = null
  ||                                           string   $passwd = null
  ||  isset_sessionid()           void         resource $c
  ||                                           string   $sessionid
  ||  record_session()            void         resource $c
  ||                                           string   $sessionid
  ||  register_session()          void         resource $c
  ||                                           string   $userid
  ||                                           string   $sessionid
  ||  return_user()               void         string   $userid
  ||  set_client_info()           void         string   $c
  ||                                           string   $userid
  ||  set_error()                 void         string   $function
  ||                                           array    $table
  ||  strip_special_characters    string       string   $str
  ||  update_session()            void         resource $c
  ||                                           string   $sessionid
  ||                                           string   $remote_address
  ||  verify_db_login()           bool         string   $userid
  ||                                           string   $passwd
  */

  // ----------------------------------------------------------------

  // Authenticate sign on.
  function authenticate($userid,$passwd)
  {
    // Check session variables for authentication.
    if ((isset($userid)) && (isset($passwd)))
      return verify_db_login($userid,$passwd);
  }

  // ----------------------------------------------------------------

  // Get a valid session.
  function get_session($sessionid,$userid = null,$passwd = null)
  {
    // Attempt connection and evaluate password.
    if ($c = @oci_connect(SCHEMA,PASSWD,TNS_ID))
    {
      // Assign metadata to local variable.
      $remote_address = $_SERVER['REMOTE_ADDR'];

      // Return database UID within 5 minutes of session registration.
      $s = oci_parse($c,"SELECT   su.system_user_id
                         ,        su.system_user_name
                         ,        su.system_user_group_id
                         ,        ss.system_remote_address
                         ,        ss.system_session_id
                         FROM     system_user su JOIN system_session ss
                         ON       su.system_user_id = ss.system_user_id
                         WHERE    ss.system_session_number = :sessionid
                         AND     (SYSDATE - ss.last_update_date) <= .003472222");

      // Bind the variables as strings.
      oci_bind_by_name($s,":sessionid",$sessionid);

      // Execute the query, error handling should be added.
      if (@oci_execute($s,OCI_DEFAULT))
      {
        // Check for a validated user, also known as a fetched row.
        if (oci_fetch($s))
        {
          // Assign unqualified values.
          $_SESSION['userid'] = oci_result($s,'SYSTEM_USER_NAME');

          // Assign striping value.
          if (oci_result($s,'SYSTEM_USER_GROUP_ID') == 0)
            $_SESSION['client_info'] = oci_result($s,'SYSTEM_USER_GROUP_ID');
          else
            $_SESSION['client_info'] = oci_result($s,'SYSTEM_USER_ID');

          // Check for same remote address.
          if ($remote_address == oci_result($s,'SYSTEM_REMOTE_ADDRESS'))
          {
            // Refresh last update timestamp of session.
            update_session($c,$sessionid,$remote_address);
            return (int) oci_result($s,'SYSTEM_SESSION_ID');
          }
          else
          {
            // Log attempted entry.
            record_session($c,$sessionid);
            return 0;
          }
        }
        else
        {
          // Record when not first login.
          if (!isset($userid) && !isset($passwd))
            record_session($c,$sessionid);
          return 0;
        }
      }
      else
      {
        // Set error message.
        set_error(__FUNCTION__,array('SYSTEM_SESSION','SYSTEM_USER'));
        return 0;
      }

      // Close the connection.
      oci_close($c);
    }
    else
    {
      $errorMessage = oci_error();
      print htmlentities($errorMessage['message'])."<br />";
      return 0;
    }
  }

  // ----------------------------------------------------------------

  // Confirm session ID is registered.
  function isset_sessionid($c,$sessionid)
  {
    // Find recorded session data.
    $s = oci_parse($c,"SELECT   NULL
                       FROM     system_session
                       WHERE    system_session_number = :sessionid");

    // Bind the variables as strings.
    oci_bind_by_name($s,":sessionid",$sessionid);

    // Execute the query, error handling should be added.
    if (@oci_execute($s,OCI_DEFAULT))
    {
      // Check for a validated user, also known as a fetched row.
      if (oci_fetch($s))
        return true;
      else
        return false;
    }
    else
    {
      // Set error message.
      set_error(__FUNCTION__,array('SYSTEM_SESSION'));
    }
  }

  // ----------------------------------------------------------------

  // Register session ID.
  function record_session($c,$sessionid)
  {
    // Insert a new session.
    $s = oci_parse($c,"INSERT
                       INTO     invalid_session
                       VALUES
                       (invalid_session_s1.nextval
                       ,:sessionid
                       ,:remote_address
                       , -1
                       ,SYSDATE
                       , -1
                       ,SYSDATE)");

    // Bind the variables as strings.
    oci_bind_by_name($s,":sessionid",$sessionid);
    oci_bind_by_name($s,":remote_address",$_SERVER['REMOTE_ADDR']);

    // Execute the query, error handling should be added.
    if (!@oci_execute($s,OCI_COMMIT_ON_SUCCESS))
    {
      // Set error message.
      set_error(__FUNCTION__,array('INVALID_SESSION'));
    }
  }

  // ----------------------------------------------------------------

  // Register session ID.
  function register_session($c,$userid,$sessionid)
  {
    // Insert a new session.
    $s = oci_parse($c,"INSERT
                       INTO     system_session
                       VALUES
                       (system_session_s1.nextval
                       ,:sessionid
                       ,:remote_address
                       ,:userid1
                       ,:userid2
                       ,SYSDATE
                       ,:userid3
                       ,SYSDATE)");

    // Bind the variables as strings.
    oci_bind_by_name($s,":sessionid",$sessionid);
    oci_bind_by_name($s,":remote_address",$_SERVER['REMOTE_ADDR']);
    oci_bind_by_name($s,":userid1",$userid);
    oci_bind_by_name($s,":userid2",$userid);
    oci_bind_by_name($s,":userid3",$userid);

    // Execute the query, error handling should be added.
    if (@oci_execute($s,OCI_COMMIT_ON_SUCCESS))
    {
      // Return current session ID.
      $s = oci_parse($c,"SELECT   system_session_id
                         FROM     system_session
                         WHERE    system_session_number = :sessionid
                         AND      system_user_id = :userid");

      // Bind the variables as strings.
      oci_bind_by_name($s,":sessionid",$sessionid);
      oci_bind_by_name($s,":userid",$userid);

      // Execute the query, raise exception for missing table.
      if (@oci_execute($s,OCI_DEFAULT))
      {
        // Check for a validated user, also known as a fetched row.
        if (oci_fetch($s))
          $_SESSION['session_id'] = oci_result($s,'SYSTEM_SESSION_ID');
        else
          $_SESSION['session_id'] = 0;
      }
      else
      {
        // Set error message.
        set_error(__FUNCTION__,array('SYSTEM_SESSION'));
      }
    }
    else
    {
      // Set error message.
      set_error(__FUNCTION__,array('SYSTEM_SESSION'));
    }
  }

  // ----------------------------------------------------------------

  // Get data on authorized users in scope of user privileges.
  function return_users($userid)
  {
    // Attempt connection and evaluate password.
    if ($c = @oci_connect(SCHEMA,PASSWD,TNS_ID))
    {
      // Set the connection striping.
      set_client_info($c,$userid);

      // Return database UID.
      $s = oci_parse($c,"SELECT   user_id
                         ,        user_name
                         ,        user_privilege
                         ,        employee_name
                         FROM     authorized_user");

      // Initialize the return variable in case no rows are found.
      $out = '';

      // Execute the query, error handling should be added.
      if (@oci_execute($s,OCI_DEFAULT))
      {
        // Set a first row control variable.
        $no_row_fetched = true;

        // Check for a validated user, also known as a fetched row.
        while (oci_fetch($s))
        {
          if ($no_row_fetched)
          {
            $out .= '<tr>';
            $out .= '<td align="center" width="100"><b>User ID</b></td>';
            $out .= '<td align="center" width="100"><b>User Name</b></td>';
            $out .= '<td align="center" width="200"><b>User Privilege</b></td>';
            $out .= '<td align="center" width="150"><b>Employee Name</b></td>';
            $out .= '</tr>';
            $no_row_fetched = false;
          }

          $out .= '<tr>';
          for ($i = 1;$i <= oci_num_fields($s);$i++)
            if (!is_null(oci_result($s,$i)))
            {
              if ($i == 1)
                $out .= '<td align="right">'.oci_result($s,$i).'</td>';
              else
                $out .= '<td align="left">'.oci_result($s,$i).'</td>';
            }
            else
              $out .= '<td>&nbsp;</td>';
          $out .= '</tr>';
        }
      }
      else
      {
        // Set error message.
        set_error(__FUNCTION__,array('AUTHORIZED_USER'));
      }

      // Close the connection.
      oci_close($c);

      // Return formatted string.
      return $out;
    }
    else
    {
      $errorMessage = oci_error();
      print htmlentities($errorMessage['message'])."<br />";
    }
  }

  // ----------------------------------------------------------------

  // Strip special characters, like carriage or line returns and tabs.
  function set_client_info($c,$userid)
  {
    // Declare a PL/SQL execution command.
    $stmt = "BEGIN
               dbms_application_info.set_client_info(:userid);
             END;";

    // Strip special characters to avoid ORA-06550 and PLS-00103 errors.
    $stmt = strip_special_characters($stmt);

    // Parse a query through the connection.
    $s = oci_parse($c,$stmt);

    // Map the local variable to a bind variable.
    oci_bind_by_name($s,':userid',$userid);

    // Run the procedure, error handling should be added.
    if (oci_execute($s))
      return true;
    else
      return false;
  }

  // ----------------------------------------------------------------

  // Print function message.
  function set_error($function,$table)
  {
    // Set session error flag to suppress printing form.
    if (!$_SESSION['db_error'])
      $_SESSION['db_error'] = DATABASE_INVALID;

    // Set error message.
    $errorMessage  = "Run against [<b><i>".$SCHEMA."</b></i>]<br />";
    $errorMessage .= "Thrown in [<b><i>".$function."()</b></i>] ";
    $errorMessage .= "function because of a missing or altered ";

    // Set the ends of the range.
    $start = 0;
    $end = count($table);

    // Loop through the list of possible missing or altered tables.
    for ($i = $start;$i < $end;$i++)
      if (($i == $start) && ($i == $end))
        $errorMessage .= $table[$i]."<br />";
      else if ($i == $end - 1)
        $errorMessage .= $table[$i]." table.<br />";
      else if (($i >= $start) && ($i < $end - 2))
        $errorMessage .= $table[$i].", ";
      else if (($i >= $start) && ($i < $end - 1))
        $errorMessage .= $table[$i]." or ";

     // Print the message.
     print $errorMessage;
  }

  // ----------------------------------------------------------------

  // Strip special characters, like carriage or line returns and tabs.
  function strip_special_characters($str)
  {
    $out = "";
    for ($i = 0;$i < strlen($str);$i++)
      if ((ord($str[$i]) != 9) && (ord($str[$i]) != 10) &&
          (ord($str[$i]) != 13))
        $out .= $str[$i];

    // Return pre-parsed SQL statement.
    return $out;
  }

  // ----------------------------------------------------------------

  // Refresh last update value of session ID.
  function update_session($c,$sessionid,$remote_address)
  {
    // Insert a new session.
    $s = oci_parse($c,"UPDATE   system_session
                       SET      last_update_date = SYSDATE
                       WHERE    system_session_number = :sessionid
                       AND      system_remote_address = :remote_address");

    // Bind the variables as strings.
    oci_bind_by_name($s,":sessionid",$sessionid);
    oci_bind_by_name($s,":remote_address",$remote_address);

    // Execute the query, error handling should be added.
    if (!@oci_execute($s,OCI_COMMIT_ON_SUCCESS))
    {
      // Set error message.
      set_error(__FUNCTION__,array('SYSTEM_USER'));
    }
  }

  // ----------------------------------------------------------------

  // Check for authorized account.
  function verify_db_login($userid,$passwd)
  {
    // Attempt connection and evaluate password.
    if ($c = @oci_connect(SCHEMA,PASSWD,TNS_ID))
    {
      // Return database UID.
      $s = oci_parse($c,"SELECT   system_user_id
                         ,        system_user_group_id
                         FROM     system_user
                         WHERE    system_user_name = :userid
                         AND      system_user_password = :passwd
                         AND      SYSDATE BETWEEN start_date
                                          AND NVL(end_date,SYSDATE)");

      // Bind the variables as strings.
      oci_bind_by_name($s,":userid",$userid);
      oci_bind_by_name($s,":passwd",sha1($passwd));

      // Execute the query, error handling should be added.
      if (@oci_execute($s,OCI_DEFAULT))
      {
        // Check for a validated user, also known as a fetched row.
        if (oci_fetch($s))
        {
           // Confirm session and collect foreign key reference column.
           if ((!isset($_SESSION['session_id'])) ||
               (!isset_sessionid($c,$_SESSION['sessionid'])))
           {
             $_SESSION['db_userid'] = oci_result($s,1);
             register_session($c,(int) $_SESSION['db_userid'],$_SESSION['sessionid']);
           }

           // Assign striping value.
           if (oci_result($s,'SYSTEM_USER_GROUP_ID') == 0)
             $_SESSION['client_info'] = oci_result($s,'SYSTEM_USER_GROUP_ID');
           else
             $_SESSION['client_info'] = oci_result($s,'SYSTEM_USER_ID');

           // User verified.
           return true;
        }
        else
        {
          // User not verified.
          return false;
        }
      }
      else
      {
        // Set error message.
        set_error(__FUNCTION__,array('SYSTEM_SESSION'));
      }

      // Close the connection.
      oci_close($c);
    }
    else
    {
      $errorMessage = oci_error();
      print htmlentities($errorMessage['message'])."<br />";
    }
  }

  // ----------------------------------------------------------------

  /* Form Rendering functions.
  || ----------------------------------------------------------------
  ||  Function Name               Return Type  Parameters
  || ---------------------------  -----------  ----------------------
  ||  userView()             void         array    $args
  ||  signOnUserAdmin()           void
  */

  // ----------------------------------------------------------------

  // Build dynamic data entry form.
  function userView($userid)
  {
    // Suppress form rendering when encountering a database failure.
    if ($_SESSION['db_error'] == DATABASE_VALID)
    {
      // Initialize return variable.
      $out  = '<div id=centered>';

      // Set and append next form target file.
      $out .= '<form method="post" action="UserAdmin.php">';

      // Append balance of form header.
      $out .= '<table border="4"
                      bgcolor="beige"
                      bordercolor="silver"
                      cellspacing="0">';
      $out .= '<tr><td class=italicLarge width="575">';
      $out .= 'User Account View';
      $out .= '</td></tr>';


      // Append standard data entry components.
      $out .= '<tr><td align="center">';
      $out .= '<table bgcolor="white" border="1" cellpadding="5" cellspacing="0">';
      $out .= return_users($userid);
      $out .= '</table>';
      $out .= '</td></tr>';
      $out .= '<tr><td align="center" bgcolor="white" colspan="2">';
      $out .= '<table border="0" cellpadding="5" cellspacing="0">';
      $out .= '<tr>';
      $out .= '<td align="center" valign="center">';
      $out .= '<input id="adduser" name="adduser" type="submit" value="Add User">';
      $out .= '</td>';
      $out .= '</form>';
      $out .= '</tr>';
      $out .= '</table>';
      $out .= '</td></tr>';
      $out .= '</table>';
      $out .= '<form method="post" action="SignOnUserAdmin.php">';
      $out .= '<table border="0" cellpadding="5" cellspacing="0">';
      $out .= '<tr>';
      $out .= '<td align="right" valign="center" width="550">';
      $out .= '<input id="logout" name="logout" type="submit" value="Log Out">';
      $out .= '</td>';
      $out .= '</tr>';
      $out .= '</table>';
      $out .= '</div>';

      // Return the form for rendering in a web page.
      print $out;
    }
  }

  // ----------------------------------------------------------------

  // Build static data entry form.
  function signOnUserAdmin()
  {
    if ($_SESSION['db_error'] == DATABASE_VALID)
    {
      // Initialize return variable.
      $out  = '<div id=centered>';

      // Set and append next form target file.
      $out .= '<form method="post" action="UserView.php">';

      // Append balance of form header.
      $out .= '<table border="4"
                      bgcolor="beige"
                      bordercolor="silver"
                      cellspacing="0">';
      $out .= '<tr><td class="italicLarge" width="400">';
      $out .= 'User Login';
      $out .= '</td></tr>';
      $out .= '<tr><td>';
      $out .= '<table border="0" cellpadding="5" cellspacing="0">';
      $out .= '<tr>';
      $out .= '<td align="right" width="200">User ID:</td>';
      $out .= '<td width="200"><input id="userid" name="userid" type="text"></td>';
      $out .= '</tr>';
      $out .= '<tr>';
      $out .= '<td align="right">User Password:</td>';
      $out .= '<td><input id="passwd" name="passwd" type="password"></td>';
      $out .= '</tr>';
      $out .= '<tr>';
      $out .= '</table>';
      $out .= '</td></tr>';
      $out .= '<tr><td align="center" bgcolor="white" colspan="2">';
      $out .= '<table border="0" cellpadding="5" cellspacing="0">';
      $out .= '<tr>';
      $out .= '<td align="center" valign="center">';
      $out .= '<input id="login" name="login" type="submit" value="Login">';
      $out .= '</td>';
      $out .= '</tr>';
      $out .= '</table>';
      $out .= '</td></tr>';
      $out .= '</table>';
      $out .= '</form>';
      $out .= '</div>';

      // Return the form for rendering in a web page.
      print $out;
    }
  }
?>
</body>
</html>