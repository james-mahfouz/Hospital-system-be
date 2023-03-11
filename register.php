<?php
require_once('functions.php');

if (isset($_POST['name'], $_POST['email'], $_POST['password'], $_POST['role'])) {
    $name = $_POST['name'];
    $password = $_POST['password'];
    $email = $_POST['email'];
    $user_type = intval($_POST['role']);
    register_user($name, $email, $password, $user_type);
    echo $name . $password . $email . $user_type;
    $user = get_user_by_id($conn->insert_id);

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
