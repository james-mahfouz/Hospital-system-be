<?php

require_once('connection.php');
require_once('vendor/autoload.php');

use \Firebase\JWT\JWT;

function register_user($name, $email, $password){
    
    global $conn;
    $role =3;
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("INSERT INTO users (name, email, password, user_types_id) VALUES(?,?,?,?)" );
    $stmt->bind_param("sssi", $name, $email, $hashed_password,$role);
    $stmt->execute();
    if ($stmt->error) {
        die('Error: ' . $stmt->error);
    }
    $result = $stmt->get_result();

    $stmt->close();
}

function get_user_by_id($id){
    global $conn;

    $stmt = $conn->prepare("SELECT * FROM users WHERE id = ?");
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
      var_dump($decoded);
      return $decoded;
    } catch (Exception $e) {
        return false;
    }
}

function assign_patient_hospital($jwt, $patient_id, $hospital_id) {
    global $conn;
    // $decoded = verifyJWT($jwt);
    // var_dump($decoded);
    // if (!$decoded || !isset($decoded->userId) || !isset($decoded->roles) || !in_array('admin', $decoded->roles)) {
    //     return false;
    // }
    $hospital = check_hospital($hospital_id);
    if (!$hospital){
        return false;
    }
    if (is_patient($patient_id, $hospital_id)) {
        
    }

    $dateJoined = date('Y-m-d H:i:s');
    $query = "INSERT INTO hospital_users (users_id, hospitals_id, is_active, date_joined) VALUES ('$patient_id', '$hospital_id', 1, '$dateJoined')";
    $result = $conn->query($query);
    var_dump($result);
    return $result;
}

function check_hospital($hospitalId) {
    global $conn;

    $query = "SELECT id FROM hospitals WHERE id = $hospitalId";
    $result = $conn->query($query);

    if (!$result) {
        return false;
    }
    
    return true;
}

function is_patient($patientId, $hospitalId) {
    global $conn;
    $query = "SELECT * FROM hospital_users WHERE users_id = $patientId AND hospitals_id = $hospitalId AND is_active = 1";
    $result = $conn->query($query);
    var_dump($query);
    if (!$result) {
        return false;
    }
    $query = "SELECT * FROM users WHERE id = $patientId";
    $result = $conn->query($query);
    if (!$result) {
        return false;
    }
    return true;
}

?>