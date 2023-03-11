<?php
require_once('functions.php');

if (isset($_POST['username'], $_POST['password'], $_POST['email'], $_POST['role'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    $email = $_POST['email'];
    $user_type = $_POST['role'];

    registerUser($username, $password, $email, $user_type);

    $user = getUserById($conn->insert_id);

    $jwt = JWT::encode(array('id' => $user['id'], 'role' => $user['role']), 'mysecretkey');

    $response = array(
        'status' => true,
        'message' => 'User registered successfully',
        'jwt' => $jwt
    );

    echo json_encode($response);
    } else {
    $response = array(
        'status' => false,
        'message' => 'Registration failed'
    );

    echo json_encode($response);
}
?>
