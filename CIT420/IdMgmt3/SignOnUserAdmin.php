<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<! SignOnUserAdmin.php                                        >
<! PHP Identity Management & Cascading Style Sheets           >
<! by Michael McLaughlin                                      >
<!                                                            >
<! This demonstrates an application sign on form that depends >
<! on active sessions.                                        >
<head>
<title>
  Identity Management, Part 3 - SignOnUserAdmin.php
</title>
<link rel="stylesheet" type="text/css" href="IdMgmt3.css" />
</head>
<body>
<?php
  // Start a session and regenerate ID to prevent session hijacking.
  session_start();
  @session_regenerate_id(true);
  $_SESSION['sessionid'] = session_id();

  // Remove striping value.
  if (isset($_SESSION['client_info']))
    unset($_SESSION['client_info']);
?>
<div id=centered>
<form method="post" action="UserAdmin.php">
<table border="4" bgcolor="beige" bordercolor="silver" cellspacing="0">
  <tr><td class="italicLarge" width="400">User Login</td></tr>
  <tr>
    <td>
      <table border="0" cellpadding="5" cellspacing="0">
        <tr>
          <td align="right" width="200">User ID:</td>
          <td width="200"><input id="userid" name="userid" type="text"></td>
        </tr>
        <tr>
          <td align="right">User Password:</td>
          <td><input id="passwd" name="passwd" type="password"></td>
        </tr>
        <tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center" bgcolor="white" colspan="2">
      <table border="0" cellpadding="5" cellspacing="0">
        <tr>
          <td align="center" valign="center">
            <input id="login" name="login" type="submit" value="Login">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</div>
</body>
</html>