<?php

namespace dbc;

include ("./utils/headers.php");

class Connection {
    public static function conn () {
        $servername = "localhost";
        $username = "root";
        $password = "";
        $db = "usuarios";

        return mysqli_connect($servername, $username, $password, $db);

    }

    public static function verificar(){
        if(self::conn()->connect_errno){
            print_r("Error de coenxión");
            return false;
        }else{
            return true;
        }
    }

    public static function registrar($query) {
        $resultado = mysqli_query(self::conn(), $query);
        if($resultado) {
            return true;
        } else {
            return false;
        }
    }

    public static function consulta($query){
        $resultado = mysqli_query(self::conn(), $query);
        $pass = mysqli_fetch_object($resultado);
          return $pass;
    }

    public static function consultaID($query){
        $resultado = mysqli_query(self::conn(), $query);
        $res = mysqli_fetch_object($resultado);
        return $res;
    }
}