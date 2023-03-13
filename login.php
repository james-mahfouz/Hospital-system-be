<?php
require_once('functions.php');
require_once('vendor/autoload.php');

use \Firebase\JWT\JWT;

if (isset($_POST['email'], $_POST['password'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];
    $user = login_user($email, $password);
    if ($user) {
        $jwt = JWT::encode(array('id' => $user['id'], 'role' => $user['user_types_id']), 'user_key','HS256');
        $response = array(
            'status' => true,
            'message' => 'Login successful',
            'jwt' => $jwt
        );
    } else {
        $response = array(
            'status' => false,
            'message' => 'Invalid email or password'
        );
    }
    echo json_encode($response);
} else {
    $response = array(
        'status' => false,
        'message' => 'Email and password are required'
    );
    echo json_encode($response);
}
?>