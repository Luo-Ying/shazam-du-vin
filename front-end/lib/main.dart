import 'package:flutter/material.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import './myLoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    VarGlobal.heightBottomNavigationBar = MediaQuery.of(context).padding.bottom;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shazam du vin',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyLoginPage(
        title: 'Shazam du vin',
      ),
    );
  }
}
