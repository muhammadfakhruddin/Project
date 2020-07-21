<?php
$servername = "localhost";
$username   = "jarfpcom_al4ng";
$password   = "EOy4lr8SBp;b";
$dbname     = "jarfpcom_sleepsoundly";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>