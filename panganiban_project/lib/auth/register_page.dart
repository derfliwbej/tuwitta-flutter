import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Align(
                    alignment: Alignment.center,
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
                    onPressed: () {},
                    child: const Text('Register', style: TextStyle(fontSize: 16.0)),
                    style: buttonStyle,
                  )
              )
            ]
        )
    );
  }
}

