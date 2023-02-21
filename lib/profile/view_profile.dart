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
      body: ListView(
        children: [
          ProfileHeader(username: username, firstName: firstName, lastName: lastName),
          const Divider(height: 1, thickness: 1, color: Color(0xFF425364))
        ]
      )

    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String username;
  final String firstName;
  final String lastName;

  const ProfileHeader({Key? key, required this.username, required this.firstName, required this.lastName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.withOpacity(0.0),
                backgroundImage: AssetImage("assets/profile_icon.png"),
              ),
              Text(
                '@$username',
                style: TextStyle(fontSize: 16.0, color: Color(0xFF71767B))
              ),
              SizedBox(height: 10.0),
              Text(
                '$firstName $lastName',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ]
        )
    );
  }
}

