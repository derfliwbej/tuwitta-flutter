import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/secure_storage.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> login(String username, String password) {
  print('${username} ${password}');

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

Future<http.Response> getUserInfo(String username) async {
  final token = await SecureStorage.getToken();

  return http.get(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$username"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          LoginForm()
                        ]
                    )
            )
        )
      )
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();

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
          Text('Login to Tuwitta', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

                http.Response res = await login(username, password);

                if(res.statusCode == 200) {
                  // Extract token
                  String token = jsonDecode(res.body)["data"]["token"];

                  // Save token to secure storage then navigate to homepage
                  await SecureStorage.setToken(token);
                  await SecureStorage.setUsername(username);

                  http.Response info = await getUserInfo(username);

                  String firstName = jsonDecode(info.body)["data"]["firstName"];
                  String lastName = jsonDecode(info.body)["data"]["lastName"];

                  await SecureStorage.setFirstName(firstName);
                  await SecureStorage.setLastName(lastName);

                  print("Printing token!");
                  print(token);

                  print("Printing first and last name!");
                  print("$firstName $lastName");

                  Navigator.pushNamed(context, '/feed');
                } else {
                  print('Login failed. Status code: ${res.statusCode}');
                }
              },
              child: const Text('Login', style: TextStyle(fontSize: 16.0)),
              style: buttonStyle,
            )
          )
        ]
      )
    );
  }
}

