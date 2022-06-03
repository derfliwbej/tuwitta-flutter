import 'package:flutter/material.dart';

class AuthOptions extends StatelessWidget {
  const AuthOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: const [
          Text(
            "See what's happening in the world right now.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            )
          ),
          SizedBox(height: 25),
          AuthOptionButtons(),
        ]
      )
    );
  }
}

class AuthOptionButtons extends StatelessWidget {
  const AuthOptionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.all(8.0)
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )
      )
    );

    return Container(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Login'),
              style: buttonStyle,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Register'),
              style: buttonStyle
            )
          )
        ]
      )
    );
  }
}

