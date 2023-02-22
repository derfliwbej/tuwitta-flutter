import 'package:flutter/material.dart';

/// Display a message dialog given a title and a message.
///
/// @param context           The BuildContext of the widget this function is called from.
/// @param title             The title of the dialog window.
/// @param message           The message of the dialog window.
///
/// @return                  showDialog widget
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