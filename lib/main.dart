import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login")
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email"
                  ),
                  keyboardType: TextInputType.emailAddress,
                )
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password"
                  ),
                  obscureText: true,
                )
              ),
              Container(  
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    child: Text('Iniciar Sesión'),
                    onPressed: () {
                    login(emailController.text, passwordController.text);
                    },
                )
              ),
              SizedBox(
                height: 20
              ),
              Container(  
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    child: Text('Registrate'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                    },
                )
              ),
            ],
          )
        )
      )
    );
  }

  Future<String> login(String email, String password) async {
    return http.post("http://192.168.1.75/practica1_WS/api_login.php", body: jsonEncode(<String, String> {'username': email, 'password': password}))
    .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      } else {
        //Map<String, dynamic> responseJson = json.decode(response.body);
        print(jsonDecode(response.body));
        Map<String, dynamic> responseJson = json.decode(response.body);
        int loginStatus = responseJson["success"];

        if (loginStatus == 1) {
          print("Logeado!");
        }
      }
    });
  }
}

class SignUp extends StatelessWidget {

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrate")
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nombre"
                  )
                )
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email"
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  validator: (input) => input.isValidEmail() ? null : "Escribe un email valido",
                )
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  autovalidate: true,
                  obscureText: true,
                  validator: (input) => input.isValidPassword() ? null : "Escribe una contraseña valido",
                )
              ),
              Container(  
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    child: Text('Crear'),
                    onPressed: () {
                      signUp(nameController.text, emailController.text, passwordController.text);
                    },
                )
              ),
            ],
          )
        )
      )
    );
  }

  Future<String> signUp(String name, String email, String password) async {
    return http.post("http://192.168.1.75/practica1_WS/api_signup.php", body: jsonEncode(<String, String> {'name': name, 'username': email, 'password': password}))
    .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      } else {
        //Map<String, dynamic> responseJson = json.decode(response.body);
        print(jsonDecode(response.body));
      }
    });
  }
  
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(this);
  }
}
