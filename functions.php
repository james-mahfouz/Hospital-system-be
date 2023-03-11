<?php

require_once('connection.php');
require_once('vendor/autoload.php');

use \Firebase\JWT\JWT;

function register_user($name, $email, $password, $user_type){
    
    global $conn;
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    echo "function enteres";
    $stmt = $conn->prepare("INSERT INTO users (name, email, password, user_types_id) VALUES(?,?,?,?)" );
    $stmt->bind_param("sssi", $name, $email, $hashed_password,$user_type);
    $stmt->execute();
    if ($stmt->error) {
        die('Error: ' . $stmt->error);
    }
    $result = $stmt->get_result();

    $stmt->close();
}

function get_user_by_id($id){
    global $conn;

    $stmt = $conn->prepare("SELECT u.id, u.name, u.email, t.name FROM users u INNER JOIN user_types t ON u.user_types_id = t.id WHERE u.id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    $stmt->close();
    return $user;
}

function login_user($email, $password){
    global $conn;
    $stmt = $conn->prepare("SELECT id , password, user_types_id FROM users WHERE email =?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    if($result->num_rows == 1){
        $user = $result -> fetch_assoc();
        if(password_verify($password, $user['password'])){
            return array('id'=>$user['id'], 'role'=>$user['user_types_id']);
        }else {
            return false;
        }
    }else{
        return false;
    }
}

function verifyJWT($jwt) {
    try {
      $decoded = JWT::decode($jwt, 'user_key', array('HS256'));
      return $decoded;
    } catch (Exception $e) {
      return false;
    }
}

function assign_patient_hospital($jwt, $patient_id, $hospital_id) {
    $decoded = verifyJWT($jwt);
    if (!$decoded || !isset($decoded->userId) || !isset($decoded->roles) || !in_array('admin', $decoded->roles)) {
        return false;
    }

    $hospital = get_hospital_by_id($hospital_id);
    if (is_patient($patient_id, $hospital_id)) {
        return false
    }

    $dateJoined = date('Y-m-d H:i:s');
    $query = "INSERT INTO hospital_users (user_id, hospital_id, is_active, date_joined) VALUES ('$patientId', '$hospitalId', 1, '$dateJoined')";
    return true;
}
function get_hospital_by_id($hospitalId) {
    global $conn;

    $query = "SELECT id FROM hospitals WHERE id = $hospitalId";
    $result = $conn->query($query);

    if (!$result) {
        return array('success' => false, 'error' => 'Failed to retrieve the hospital details');
    }
    $hospital = $result->fetch_assoc();
    $conn->close();
    return array('success' => true, 'data' => $hospital);
}

function is_patient($patientId, $hospitalId) {
    global $conn;
    $query = "SELECT * FROM hospital_users WHERE user_id = $patientId AND hospital_id = $hospitalId AND is_active = 1";
    $result = $conn->query($query);
    if (!$result) {
        return false;
    }
    $query = "SELECT * FROM users WHERE id = $patientId AND is_active = 1";
    $result = $conn->query($query);
    if (!$result) {
        return false;
    }
    $conn->close();
    return true;
}

?>