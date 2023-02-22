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

// Widget for the Form
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

  /// Generates the app's theme of the input style given a label
  ///
  /// @param label           The label of the input
  ///
  /// @return                Instance of an InputDecoration with the defined styles
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

  // Clears the form
  void clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _oldPasswordController.clear();
    _newPasswordController.clear();
  }

  /// Converts a collection of data to a map.
  ///
  /// @param firstName         The value of the firstName attribute of the map
  /// @param lastName          The value of the lastName attribute of the map
  /// @param oldPassword       The value of the oldPassword attribute of the map
  /// @param newPassword       The value of the newPassword attribute of the map
  ///
  /// @return                  A map with values for the the attributes firstName, lastName, oldPassword, and newPassword
  Map<String, String> toMap(String firstName, String lastName, String oldPassword, String newPassword) {
    Map<String, String> map = new Map<String, String>();

    if(firstName.isNotEmpty) map['firstName'] = firstName;
    if(lastName.isNotEmpty) map['lastName'] = lastName;
    if(oldPassword.isNotEmpty) map['oldPassword'] = oldPassword;
    if(newPassword.isNotEmpty) map['newPassword'] = newPassword;

    return map;
  }

  /// Saves the new user details after finishing editing.
  ///
  /// @param firstName           The newly inputted first name
  /// @param lastName            The newly inputted last name
  /// @param oldPassword         The current password to change
  /// @param newPassword         The new password to change in to
  ///
  /// @return                    The HTTP response of the request
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
                // Function to call upon saving changes
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


