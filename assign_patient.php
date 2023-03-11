<?php
require_once('functions.php');
require_once('vendor/autoload.php');

use \Firebase\JWT\JWT;

if (isset($_POST['jwt'], $_POST['patient_id'], $_POST['hospital_id'])) {
    
    
    assign_patient_hospital($jwt, $patient_id, $hospital_id)

}

?>