<?php
error_reporting(0);
include_once ("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];


$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,VERIFY) VALUES ('$name','$email','$password','$phone','0')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);  
    echo "success";
}
else
{
    echo "failed";
}

function sendEmail($useremail){
    $to      = $useremail; 
    $subject = 'Verification for SleepSoundly'; 
    $message = 'http://jarfp.com/sleepsoundly/verify.php?email='.$useremail; 
    $headers = 'From: noreply@jarfp.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers);
}

?>