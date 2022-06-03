import 'package:flutter/material.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: const Color(0xFF15202b),
        scaffoldBackgroundColor: const Color(0xFF15202b),
        textTheme: textTheme,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
            children: [
              Text(title)
            ],
          )
      )
    );
  }
}