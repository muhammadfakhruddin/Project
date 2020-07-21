<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];

$sqlupdate = "UPDATE USER SET VERIFY = '1' WHERE EMAIL = '$email'";

if ($conn->query($sqlupdate) === true){
    echo "Your email has been verified";
}
else{
    echo "Your email has not been verified, please contact the support team.";
}

$conn->close();
?>