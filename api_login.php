<?php

include ("./utils/headers.php");
require "vendor/autoload.php";

use DBC\Connection as dbc;
use AUTH\AuthToken as auth;

$postdata = file_get_contents("php://input");
$post = json_decode($postdata);

@$email = $post->username;
@$password = $post->password;

$query = dbc::consulta("SELECT * FROM usuarios WHERE email = '" . $email . "'");


if(md5($password) == $query->password) {

    $token = auth::signIn([
        'id' => $query->id,
        'email' => $query->email
    ]);

    $dataProvider = ['success'=>1, 'token' => $token];
    echo json_encode($dataProvider);
} else {
    echo json_encode(["success"=>0]);
}