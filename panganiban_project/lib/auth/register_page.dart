import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/secure_storage.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> register(String username, String password, String firstName, String lastName) {
  const token = "Zxi!!YbZ4R9GmJJ!h5tJ9E5mghwo4mpBs@*!BLoT6MFLHdMfUA%";

  return http.post(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
      })
  );
}

Future<http.Response> login(String username, String password) async {
  return http.post(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      })
  );
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                            size: 28.0,
                          ),
                          SizedBox(height: 20.0),
                          RegisterForm()
                        ]
                )
            )
        )
      )
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _firstNameController = TextEditingController();
  late TextEditingController _lastNameController = TextEditingController();

  InputDecoration textFieldStyle(String label) {
    return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: const Color(0xFF425364)),
        hintStyle: TextStyle(color: const Color(0xFF425364)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            )
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF425364),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(12.0)
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
            )
        )
    );

    return Container(
        child: Column(
            children: [
              Text('Join Tuwitta', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              TextField(
                  controller: _usernameController,
                  decoration: textFieldStyle('Username')
              ),
              SizedBox(height: 16.0),
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: textFieldStyle('Password')
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _firstNameController,
                decoration: textFieldStyle('First Name')
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _lastNameController,
                decoration: textFieldStyle('Last Name')
              ),
              SizedBox(height: 16.0),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      String firstName = _firstNameController.text;
                      String lastName = _lastNameController.text;

                      http.Response regRes = await register(username, password, firstName, lastName);

                      if(regRes.statusCode == 200) {
                        http.Response loginRes = await login(username, password);

                        if(loginRes.statusCode == 200) {
                          // Extract token
                          String token = jsonDecode(loginRes.body)["data"]["token"];

                          await SecureStorage.setToken(token);
                          await SecureStorage.setUsername(username);

                          Navigator.pushNamed(context, '/feed');
                        } else {
                          print("Login failed. Status code: ${loginRes.statusCode}");
                        }
                      } else {
                        print("Register failed. Status code: ${regRes.statusCode}");
                      }
                    },
                    child: const Text('Register', style: TextStyle(fontSize: 16.0)),
                    style: buttonStyle,
                  )
              )
            ]
        )
    );
  }
}

