import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './auth/auth_option.dart';
import './auth/login_page.dart';
import './auth/register_page.dart';

import './feed/feed.dart';
import './profile/view_profile.dart';
import './profile/edit_profile.dart';
import './feed/view_post.dart';

import './utils/route_observer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.blue,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      navigatorObservers: [Observer.routeObserver],
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/feed': (context) => const FeedPage(),
        ViewProfilePage.routeName: (context) => const ViewProfilePage(),
        EditProfilePage.routeName: (context) => const EditProfilePage(),
        ViewPostPage.routeName: (context) => const ViewPostPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: const Color(0xFF15202b),
        scaffoldBackgroundColor: const Color(0xFF15202b),
        textTheme: textTheme,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  const MyHomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
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
                    Spacer(),
                    AuthOptions(),
                    Spacer(),
                    Text('Made by Jeb Wilfred Panganiban'),
                  ],
                )
            )
          )
      )
    );
  }
}