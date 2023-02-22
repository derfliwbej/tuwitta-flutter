import 'package:flutter/material.dart';

Future<void> displayMessageDialog(BuildContext context, String title, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            backgroundColor: const Color(0xFF15202b),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              )
            ]
        );
      }
  );
}