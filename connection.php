<?php
header("Access-Control-Allow-Origin: *");

$host = "localhost";
$user = "root";
$password = null;
$database = "hospital_db";
$conn = new mysqli($host, $user, $password, $database);
error_reporting(E_ALL);
ini_set('display_errors', '1');
ini_set('display_startup_errors', 1);
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
?>