<?php
header("Access-Control-Allow-Origin: *");

$host = "localhost";
$user = "root";
$password = null;
$database = "hospital_db";
$conn = new mysqli($host, $user, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
?>