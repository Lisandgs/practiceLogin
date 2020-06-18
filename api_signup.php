<?php

include ("./utils/headers.php");
require "vendor/autoload.php";

use DBC\Connection as dbc;
use AUTH\AuthToken as auth;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $postdata = file_get_contents("php://input");
    $post = json_decode($postdata);

    @$email = $post->username;
    @$password = $post->password;
    @$name = $post->name;

    $encryptedPass = md5($password);

    $query = dbc::registrar("INSERT INTO  usuarios (nombre, email, password) VALUES ('".$name."', '".$email."', '".$encryptedPass."')");

    if($query) {
        echo json_encode(["status"=>1]);
    } else {
        echo json_encode(["status"=>0]);
    }
}
