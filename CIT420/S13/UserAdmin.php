<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<! UserAdmin.php                                              >
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
  Identity Management, Part 3 - UserAdmin.php
</title>
<link rel="stylesheet" type="text/css" href="IdMgmt3.css" />
</head>
<body>
<?php
  // Start session.
  @session_start();
  $_SESSION['sessionid'] = session_id();

  // Set database credentials.
  include_once("Credentials3.inc");

  // Define global constants for error management.
  define('USER_VALID',0);
  define('USER_EXISTS',1);
  define('USER_LENGTH_ZERO',2);
  define('USER_STARTS_WITH_NUMBER',3);
  define('USER_LENGTH_OUTSIDE_RANGE',4);
  define('USER_PASSWORD_LENGTH',5);
  define('USER_NO_ADD_PERMISSION',6);

  // Define global constants for database integrity.
  define('DATABASE_VALID',0);
  define('DATABASE_INVALID',1);

  // Set assumed database integrity level.
  $_SESSION['db_error'] = DATABASE_VALID;

  // Set control variable.
  $authenticated = false;

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
    @session_regenerate_id(true);
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
    // Assign inputs to variables.
    $newuserid = @$_POST['newuserid'];
    $newpasswd = @$_POST['newpasswd'];
    $usergroup = @$_POST['usergroup'];
    $fname = @$_POST['fname'];
    $lname = @$_POST['lname'];

    // Set message and write new credentials.
    if ((isset($newuserid)) && (isset($newpasswd)) &&
        (($code = verify_credentials($newuserid,$newpasswd)) != 0))
    {
      // Render empty form with error message from prior attempt.
      userAdminForm(array("code"=>$code
                         ,"form"=>"UserAdmin.php"
                         ,"userid"=>$newuserid));
    }
    else
    {
      // Create new user only when authenticated.
      if (!(isset($userid)) && (isset($_SESSION['userid'])) && (isset($newuserid)))
      {
        if (create_new_db_user($_SESSION['db_userid']
                              ,$newuserid
                              ,$newpasswd
                              ,$fname
                              ,$lname
                              ,$usergroup))
        {
          // Set code to successful.
          $code = USER_VALID;

          // Render new form with successful acknowledgement.
          userAdminForm(array("code"=>$code
                             ,"form"=>"UserAdmin.php"
                             ,"userid"=>$newuserid));
        }
        else
        {
          // Set code to unauthorized.
          $code = USER_NO_ADD_PERMISSION;

          // Render empty form with error message from prior attempt.
          userAdminForm(array("code"=>$code
                             ,"form"=>"UserAdmin.php"
                             ,"userid"=>$newuserid));
        }
      }
      else
      {
        // Reachable only on repost.
        userAdminForm(array("form"=>"UserAdmin.php"));
      }
    }
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
  ||  create_new_db_user()        bool         string   $userid
  ||                                           string   $newuserid
  ||                                           string   $newpasswd
  ||  get_message()               string       int      $code
  ||                                           string   $userid
  ||  get_session()               int          string   $sessionid
  ||                                           string   $userid = null
  ||                                           string   $passwd = null
  ||  is_inserted()               bool         resource $c
  ||                                           string   $newuserid
  ||  isset_sessionid()           void         resource $c
  ||                                           string   $sessionid
  ||  record_session()            void         resource $c
  ||                                           string   $sessionid
  ||  register_session()          void         resource $c
  ||                                           string   $userid
  ||                                           string   $sessionid
  ||  set_error()                 void         string   $function
  ||                                           array    $table
  ||  update_session()            void         resource $c
  ||                                           string   $sessionid
  ||                                           string   $remote_address
  ||  verify_credentials()        int          string   $userid
  ||                                           string   $passwd
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

  // Add a new user to the authorized control list.
  function create_new_db_user($userid,$nuserid,$npasswd,$fname,$lname,$ugroup)
  {
    // Set control variable.
    $written = false;

    // Assign encryted value to variable, avoiding E_STRICT error.
    $newpassword = sha1($npasswd);

    // Attempt connection and evaluate password.
    if ($c = @oci_connect(SCHEMA,PASSWD,TNS_ID))
    {
      // Check for prior insert, possible on web page refresh.
      if (!is_inserted($c,$nuserid) && ($_SESSION['client_info'] == 0))
      {
        // Return database UID.
        $s = oci_parse($c,"INSERT INTO system_user
                           ( system_user_id
                           , system_user_name
                           , system_user_password
                           , first_name
                           , last_name
                           , system_user_group_id
                           , start_date
                           , created_by
                           , creation_date
                           , last_updated_by
                           , last_update_date )
                           VALUES
                           ( system_user_s1.nextval
                           , :newuserid
                           , :newpasswd
                           , :firstname
                           , :lastname
                           , :usergroup
                           , SYSDATE
                           , :userid1
                           , SYSDATE
                           , :userid2
                           , SYSDATE)");

        // Bind the variables as strings.
        oci_bind_by_name($s,":newuserid",$nuserid);
        oci_bind_by_name($s,":newpasswd",$newpassword);
        oci_bind_by_name($s,":firstname",$fname);
        oci_bind_by_name($s,":lastname",$lname);
        oci_bind_by_name($s,":usergroup",$ugroup);
        oci_bind_by_name($s,":userid1",$userid);
        oci_bind_by_name($s,":userid2",$userid);

        // Execute the query print error handling for missing table.
        if (@oci_execute($s,OCI_COMMIT_ON_SUCCESS))
        {
          // Update control variable for insert.
          $written = true;
        }
        else
        {
          // Set error message.
          set_error(__FUNCTION__,array('SYSTEM_USER'));
        }
      }

      // Close the connection.
      oci_close($c);

      // Return control variable.
      return $written;

    }
    else
    {
      $errorMessage = oci_error();
      print htmlentities($errorMessage['message'])."<br />";
    }
  }

  // ----------------------------------------------------------------

  // Build new user error message string.
  function get_message($code,$userid)
  {
    // Designate message by error code.
    switch ($code)
    {
      case USER_VALID:
        return "You have added user [$userid] successfully.";
      case USER_EXISTS:
        return "User ID [$userid] is already in use.";
      case USER_LENGTH_ZERO:
        return "User ID [$userid] cannot be a null value.";
      case USER_STARTS_WITH_NUMBER:
        return "User ID [$userid] must start with a character.";
      case USER_LENGTH_OUTSIDE_RANGE:
        return "User ID [$userid] must be between 6 and 10 characters.";
      case USER_PASSWORD_LENGTH:
        return "The password must be between 6 and 10 characters.";
      case USER_NO_ADD_PERMISSION:
        return "You are not authorized to add [$userid] user.";
    }
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

      // Execute the query and raise missing table message on failure.
      if (@oci_execute($s,OCI_DEFAULT))
      {
        // Check for a validated user, also known as a fetched row.
        if (oci_fetch($s))
        {
          // Assign unqualified values.
          $_SESSION['userid'] = oci_result($s,'SYSTEM_USER_NAME');

          // Assign the privileged group or user primary key column value.
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
          if (!isset($userid) && !isset($passwd)) {
            record_session($c,$sessionid);
          }
          return 0;
        }
      }
      else
      {
        // Set error message.
        set_error(__FUNCTION__,array('SYSTEM_USER','SYSTEM_SESSION'));
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

  // Define a duplicate error avoidance function for page refreshes.
  function is_inserted($c,$newuserid)
  {
    // Check for existing user.
    $s = oci_parse($c,"SELECT   null
                       FROM     system_user
                       WHERE    system_user_name = :newuserid");

    // Bind the variables as strings.
    oci_bind_by_name($s,":newuserid",$newuserid);

    // Execute the query and raise missing table message on failure.
    if (@oci_execute($s,OCI_DEFAULT))
    {
      // Check for a existing entry.
      if (oci_fetch($s))
        return true;
      else
        return false;
    }
    else
    {
      // Set error message.
      set_error(__FUNCTION__,array('SYSTEM_USER'));
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

    // Execute the query and raise missing table message on failure.
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

    // Execute the query and raise missing table message on failure.
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

    // Execute the query and raise missing table message on failure.
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

      // Execute the query and raise missing table message on failure.
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

    // Execute the query and raise missing table message on failure.
    if (!@oci_execute($s,OCI_COMMIT_ON_SUCCESS))
    {
      // Set error message.
      set_error(__FUNCTION__,array('SYSTEM_SESSION'));
    }
  }

  // ----------------------------------------------------------------

  // Validate new accounts meets identity management rules.
  function verify_credentials($userid,$passwd)
  {
    switch(true)
    {
      // Does user name already exist.
      case (verify_db_login($userid,$passwd) != 0):
        return USER_EXISTS;

      // Does user name start with an alphabetic character.
      case (strlen($userid) == 0):
        return USER_LENGTH_ZERO;

      // Does user name start with an alphabetic character.
      case (ereg("([0-9])",substr($userid,0,1))):
        return USER_STARTS_WITH_NUMBER;

      // Does user name start with a letter for a 6-10 character string.
      case (!ereg("([a-zA-Z]+[a-zA-Z0-9]{5,10})",$userid)):
        return USER_LENGTH_OUTSIDE_RANGE;

      // Does password start contain a 6-10 character string.
      case (!ereg("([a-zA-Z0-9]{5,10})",$passwd)):
        return USER_PASSWORD_LENGTH;

      // Acknowledge everything is fine.
      default:
        return USER_VALID;
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

      // $s = oci_parse($c,"CALL verify_db_login(?,?,?,?,?,?,?)");

      // Assign encryted value to variable, avoiding E_STRICT error.
      $newpassword = sha1($passwd);

      // Bind the variables as strings.
      oci_bind_by_name($s,":userid",$userid);
      oci_bind_by_name($s,":passwd",$newpassword);

      // oci_bind_by_name($s,":passwd",$_SESSION['db_userid']);

      // Execute the query and raise missing table message on failure.
      if (@oci_execute($s,OCI_DEFAULT))
      {
        // Check for a validated user, also known as a fetched row.
        if (oci_fetch($s))
        {
           // Confirm session and collect foreign key reference column.
           if ((!isset($_SESSION['session_id'])) ||
               (!isset_sessionid($c,$_SESSION['sessionid'])))
           {
             $_SESSION['db_userid'] = oci_result($s,'SYSTEM_USER_ID');
             $_SESSION['client_info'] = oci_result($s,'SYSTEM_USER_GROUP_ID');
             register_session($c,(int) $_SESSION['db_userid'],$_SESSION['sessionid']);
           }

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
        set_error(__FUNCTION__,array('SYSTEM_USER'));
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
  ||  userAdminForm()             void         array    $args
  ||  signOnUserAdmin()           void
  */

  // ----------------------------------------------------------------

  // Build dynamic data entry form.
  function userAdminForm($args)
  {
    // Suppress form rendering when encountering a database failure.
    if ($_SESSION['db_error'] == DATABASE_VALID)
    {
      // Define local variables.
      $code;
      $form;
      $userid;

      // Parse form parameters.
      foreach ($args as $name => $value)
      {
        switch (true)
        {
          case ($name == "form"):
            $form = $value;
            break;
          case ($name == "code"):
            $code = $value;
            break;
          case ($name == "userid"):
            $userid = $value;
            break;
        }
      }

      // Initialize return variable.
      $out  = '<div id=centered>';

      // Set and append next form target file.
      $out .= '<form method="post" action="'.$form.'">';

      // Append balance of form header.
      $out .= '<table border="4"
                      bgcolor="beige"
                      bordercolor="silver"
                      cellspacing="0">';
      $out .= '<tr><td class="italicLarge" width="400">';
      $out .= 'New User';
      $out .= '</td></tr>';

      // Check for and display error message.
      if ((isset($code)) && (is_int($code)))
      {
        $out .= '<tr><td align="center" bgcolor="white" width="450">';
        $out .= '<font color=blue>'.get_message($code,$userid).'</font>';
        $out .= '</td></tr>';
      }

      // Append standard data entry components.
      $out .= '<tr><td>';
      $out .= '<table border="0" cellpadding="5" cellspacing="0">';

      // Enable or disable text entry fields.
      if ((!@$_SESSION['client_info']) && (@$_SESSION['client_info'] == 0))
      {
        $out .= '<tr>';
        $out .= '<td align="right" width="200">User ID:</td>';
        $out .= '<td width="200">';
        $out .= '<input id="newuserid" name="newuserid" type="text">';
        $out .= '</td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td align="right">User Password:</td>';
        $out .= '<td><input id="newpasswd" name="newpasswd" type="password"></td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td align="right" width="200">First Name:</td>';
        $out .= '<td width="200">';
        $out .= '<input id="fname" name="fname" type="text">';
        $out .= '</td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td align="right" width="200">Last Name:</td>';
        $out .= '<td width="200">';
        $out .= '<input id="lname" name="lname" type="text">';
        $out .= '</td>';
        $out .= '</tr>';
      }
      else
      {
        $out .= '<tr>';
        $out .= '<td align="right" width="200">User ID:</td>';
        $out .= '<td width="200">';
        $out .= '<input id="d_newuserid" name="d_newuserid" type="text" disabled>';
        $out .= '</td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td align="right">User Password:</td>';
        $out .= '<td><input id="d_newpasswd" name="d_newpasswd" type="password" disabled></td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td align="right" width="200">First Name:</td>';
        $out .= '<td width="200">';
        $out .= '<input id="d_fname" name="d_fname" type="text" disabled>';
        $out .= '</td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td align="right" width="200">Last Name:</td>';
        $out .= '<td width="200">';
        $out .= '<input id="d_lname" name="d_lname" type="text" disabled>';
        $out .= '</td>';
        $out .= '</tr>';
      }

      $out .= '</table>';
      $out .= '</td></tr>';
      $out .= '<tr><td align="center" bgcolor="white" colspan="2">';
      $out .= '<table border="0" cellpadding="5" cellspacing="0">';
      $out .= '<tr><td align="center">';

      // Enable or disable controls.
      if ((!@$_SESSION['client_info']) && (@$_SESSION['client_info'] == 0))
      {
        $out .= '<input type="radio" name="usergroup" value="0" checked onClick="changeGroup(0);">Administration Group';
        $out .= '</td>';
        $out .= '<td align="center">';
        $out .= '<input type="radio" name="usergroup" value="1" onClick="changeGroup(1);">Employee Group';
      }
      else
      {
        $out .= '<input type="radio" name="usergroup" value="0" checked disabled>Administration Group';
        $out .= '</td>';
        $out .= '<td align="center">';
        $out .= '<input type="radio" name="usergroup" value="1" disabled>Employee Group';
      }

      $out .= '</td>';
      $out .= '</tr>';
      $out .= '<tr>';
      $out .= '<td align="center" valign="center">';
      if ((!@$_SESSION['client_info']) && (@$_SESSION['client_info'] == 0))
        $out .= '<input id="adduser" name="adduser" type="submit" value="Add User">';
      else
        $out .= '<input id="d_adduser" name="d_adduser" disabled="true" type="submit" value="Add User">';
        $out .= '</td>';
        $out .= '</form>';
        $out .= '<form method="post" action="UserView.php">';
        $out .= '<td align="center" valign="center">';
        $out .= '<input id="viewuser" name="viewuser" type="submit" value="View User">';
        $out .= '</td>';
        $out .= '</tr>';
        $out .= '</form>';
        $out .= '</table>';
        $out .= '</td></tr>';
        $out .= '</table>';
        $out .= '<form method="post" action="SignOnUserAdmin.php">';
        $out .= '<table border="0" cellpadding="5" cellspacing="0">';
        $out .= '<tr>';
        $out .= '<td align="right" valign="center" width="400">';
        $out .= '<input id="logout" name="logout" type="submit" value="Log Out">';
        $out .= '</td>';
        $out .= '</tr>';
        $out .= '</table>';
        $out .= '<script>';
        $out .= 'function changeGroup(newSelection)';
        $out .= '{ document.getElementById("usergroup").value = newSelection; }';
        $out .= '</script>';
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
      $out .= '<form method="post" action="UserAdmin.php">';

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
      $out .= '<tr><td align="center" colspan="2">';
      $out .= '<table border="0" cellpadding="5" cellspacing="0">';
      $out .= '<tr>';
      $out .= '<td align="center" bgcolor="white" valign="center">';
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