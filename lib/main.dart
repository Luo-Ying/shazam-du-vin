import 'package:flutter/material.dart';

import './myLoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shazam du vin',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // routes: {
      //   "/": (context) => const MyLoginPage(title: "login"),
      // },
      // home: const MyHomePage(
      //   title: 'Login',
      // ),
      home: const MyLoginPage(
        title: 'Shazam du vin',
      ),
    );
  }
}
