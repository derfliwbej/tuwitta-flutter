import 'package:flutter/material.dart';

import '../utils/secure_storage.dart';
import '../utils/message_dialog.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static const routeName = '/editProfile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), backgroundColor: Color(0xFF15202b)),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: FormWidget()
      )
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  late TextEditingController _firstNameController = TextEditingController();
  late TextEditingController _lastNameController = TextEditingController();
  late TextEditingController _oldPasswordController = TextEditingController();
  late TextEditingController _newPasswordController = TextEditingController();

  FocusNode firstNameNode = new FocusNode();
  FocusNode lastNameNode = new FocusNode();
  FocusNode oldPasswordNode = new FocusNode();
  FocusNode newPasswordNode = new FocusNode();

  InputDecoration inputStyle(String label) {
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
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _oldPasswordController.clear();
    _newPasswordController.clear();
  }

  Map<String, String> toMap(String firstName, String lastName, String oldPassword, String newPassword) {
    Map<String, String> map = new Map<String, String>();

    if(firstName.isNotEmpty) map['firstName'] = firstName;
    if(lastName.isNotEmpty) map['lastName'] = lastName;
    if(oldPassword.isNotEmpty) map['oldPassword'] = oldPassword;
    if(newPassword.isNotEmpty) map['newPassword'] = newPassword;

    return map;
  }

  Future<http.Response> save(String firstName, String lastName, String oldPassword, String newPassword) async {
    final token = await SecureStorage.getToken();
    final username = await SecureStorage.getUsername();

    return http.put(
        Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$username"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(toMap(firstName, lastName, oldPassword, newPassword))
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

    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _firstNameController,
            focusNode: firstNameNode,
            decoration: inputStyle('New First Name')
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _lastNameController,
            focusNode: lastNameNode,
            decoration: inputStyle('New Last Name'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _oldPasswordController,
            focusNode: oldPasswordNode,
            decoration: inputStyle('Old Password'),
            obscureText: true,
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _newPasswordController,
            focusNode: newPasswordNode,
            decoration: inputStyle('New Password'),
            obscureText: true,
          ),
          SizedBox(height: 16.0),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String firstName = _firstNameController.text;
                  String lastName = _lastNameController.text;
                  String oldPassword = _oldPasswordController.text;
                  String newPassword = _newPasswordController.text;

                  http.Response res = await save(firstName, lastName, oldPassword, newPassword);


                  if(res.statusCode == 200) {
                    if(firstName.isNotEmpty) await SecureStorage.setFirstName(firstName);
                    if(lastName.isNotEmpty) await SecureStorage.setLastName(lastName);
                  } else displayMessageDialog(context, "Error", "Error in editing profile.");

                  clearFields();
                },
                child: const Text('Save', style: TextStyle(fontSize: 16.0)),
                style: buttonStyle,
              )
          )
        ]
      )
    );
  }
}


