import 'package:flutter/material.dart';
import './ViewProfileArguments.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({Key? key}) : super(key: key);

  static const routeName = '/viewProfile';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ViewProfileArguments;

    final username = args.username;
    final firstName = args.firstName;
    final lastName = args.lastName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xFF15202b)
      ),
      body: Column(
        children: [
          Text('$username'),
          Text('$firstName'),
          Text('$lastName'),
        ]
      )
    );
  }
}
