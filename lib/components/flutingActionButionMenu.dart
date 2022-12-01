import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../myImagePickerWidget.dart';
import '../myListWinePage.dart';
import '../myLoginPage.dart';
import '../myMainPage.dart';
import '../services/localStorage.dart';

ValueNotifier<bool> isDialOpen = ValueNotifier(false);

Widget buildMainMenu(BuildContext context) {
  return SpeedDial(
    children: [
      SpeedDialChild(
          child: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          label: 'log out',
          labelStyle: const TextStyle(fontSize: 16.0),
          onTap: () {
            // isDialOpen.value = false;
            logout(context);
          }),
      SpeedDialChild(
        child: const Icon(
          Icons.photo_camera,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        label: 'camera',
        labelStyle: const TextStyle(fontSize: 16.0),
        onTap: () {
          // isDialOpen.value = false;
          photo_camera(context);
        },
      ),
      SpeedDialChild(
        child: const Icon(
          Icons.list,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        label: 'all wines',
        labelStyle: const TextStyle(fontSize: 16.0),
        onTap: () {
          // isDialOpen.value = false;
          goListVinPage(context);
        },
      ),
      SpeedDialChild(
        child: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        label: 'home',
        labelStyle: const TextStyle(fontSize: 16.0),
        onTap: () {
          // isDialOpen.value = false;
          goHome(context);
        },
      ),
    ],
    closeManually: false,
    // openCloseDial: isDialOpen,
    spaceBetweenChildren: 20.0,
    animationDuration: const Duration(milliseconds: 300),
    animatedIcon: AnimatedIcons.menu_close,
    backgroundColor: Colors.black,
    overlayColor: const Color.fromRGBO(36, 38, 39, 1),
    child: const Icon(Icons.menu),
  );
}

Future<void> logout(BuildContext context) async {
  String result = await readDataString("currentUser");
  print("result: " + result);
  deleteData("currentUser");
  String result1 = await readDataString("currentUser");
  print("result apprès suprimé: " + result1);
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const MyLoginPage(title: "login"),
  ));
}

Future<void> photo_camera(BuildContext context) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const MyImagePickerWidget(),
  ));
}

Future<void> goListVinPage(BuildContext context) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const MyListVinPage(),
  ));
}

Future<void> goHome(BuildContext context) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const MyMainPage(title: "main"),
  ));
}
