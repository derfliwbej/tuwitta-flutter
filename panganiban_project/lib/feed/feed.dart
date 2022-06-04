import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/secure_storage.dart';

Future<http.Response> authRequest() async {
  final token = await SecureStorage.getToken();

  return http.get(
    Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
}

Future<void> logout() async {
  final token = await SecureStorage.getToken();

  await SecureStorage.deleteToken();

  final res = await http.post(
    Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/logout"),
    headers: {
      'Authorization': 'Bearer $token'
    }
  );

  print("Logout status: ${res.statusCode}");
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String? username;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final username = await SecureStorage.getUsername();

    setState(() {
      this.username = username;
    });
  }

  Future<void> _showDialog(int statusCode) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF15202b),
          title: const Text('Status Code'),
          content: Text('Status code is $statusCode'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome $username!', style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              )),
              SizedBox(height: 20.0),
              ElevatedButton(
                  child: Text('Make authenticated request'),
                  onPressed: () async {
                    http.Response res = await authRequest();

                    return _showDialog(res.statusCode);
                  }
              ),
              ElevatedButton(
                  child: Text('Logout'),
                  onPressed: () {
                    logout();
                    Navigator.pushNamed(context, '/');
                  }
              )
            ]
          )
        )
      )
    );
  }
}

