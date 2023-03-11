<?php
require_once('connection.php');
require_once('vendor/autoload.php');

use \Firebase\JWT\JWT;

function register_user($name, $email, $password, $user_type){
    global $conn;

    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("INSERT INTO users (name, email, password, email, user_types_id) VALUES(?,?,?,?)" );
    $stmt->bind_param("sssi", $name, $email, $hashed_password,$user_type);
    $stmt->execute();
    $stmt->close();
}

function get_user_by_id($id){
    global $conn;
    $stmt = $conn->prepare("SELECT u.id, u.username, u.email, t.name FROM users u INNER JOIN user_types t ON u.user_types_id = t.id WHERE u.id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    $stmt->close();
    return $user;
}

function login_user($name, $password){
    global $conn;
    $stmt = $conn->prepare("SELECT id , password, user_types_id FROM users WHERE username =?");
    $stmt->bind_param("s", $name);
    $stmt->execute();
    $result = $stmt->get_result();
    if($result->num_rows == 1){
        $user = $result -> fetch_assoc();
        if(password_verify($password, $user['password'])){
            $jwt = JWT::encode(array('id'=>$user['id'], 'role'=>$user['user_types_id']),'user_key');
            return $jwt;
        }else {
            return false;
        }
    }else{
        return false;
    }
}
?>