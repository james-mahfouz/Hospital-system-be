<?php
require_once('functions.php');
require_once('vendor/autoload.php');

use \Firebase\JWT\JWT;

if (isset($_POST['jwt'], $_POST['patient_id'], $_POST['hospital_id'])) {
    $jwt = $_POST['jwt'];
    $patient_id = $_POST['patient_id'];
    $hospital_id = $_POST['hospital_id'];
    
    if ($success) {
        $response = array('success' => true, 'message' => 'Patient assigned to hospital successfully');
    } else {
        $response = array('success' => false, 'message' => 'Failed to assign patient to hospital');
    }
    
    echo json_encode($response);
}

?>