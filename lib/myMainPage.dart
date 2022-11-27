import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:shazam_du_vin/myImagePickerWidget.dart';
import 'package:shazam_du_vin/myLoginPage.dart';

import './services/http_service.dart';
import './services/localStorage.dart';
import './utils/myMainMenuFunction.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  late final HttpService _httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        // constraints: const BoxConstraints.expand(),
        child: Stack(
          children: [
            buildFloatingMenuButton(context),
          ],
        ),
      ),
    );
  }

  PreferredSize buildApBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Column(
        children: [
          const SizedBox(
            height: 44.0,
          ),
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            elevation: 0,
            title: Stack(
              children: [
                const Text(
                  'Top 10 wines',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
                buildTitleLine(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, top: 49.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40,
          height: 2,
        ),
      ),
    );
  }

  // Future<void>
}
