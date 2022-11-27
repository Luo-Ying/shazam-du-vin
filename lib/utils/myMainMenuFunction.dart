import 'package:flutter/material.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';

import '../myImagePickerWidget.dart';
import '../myLoginPage.dart';

import '../myMainPage.dart';
import '../services/localStorage.dart';
import '../services/http_service.dart';

late final HttpService _httpService = HttpService();

Widget buildFloatingMenuButton(BuildContext context) {
  return Positioned(
    // right: 33,
    // bottom: 33,
    //悬浮按钮
    child: RoteFlowButtonMenu(
      //菜单图标组
      iconList: const [
        Icon(
          Icons.logout, // index = 0
          color: Colors.white,
        ),
        Icon(
          Icons.photo_camera, // index = 1
          color: Colors.white,
        ),
        Icon(
          Icons.list, // index = 2
          color: Colors.white,
        ),
        Icon(
          Icons.home, // index = 3
          color: Colors.white,
        ),
        Icon(
          Icons.menu,
          color: Colors.white,
        )
      ],
      // iconSize: 56,
      iconBackgroundColorList: const [
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
      ],
      //点击事件回调
      clickCallBack: (int index) {
        print("????????????????????????????????????????????????$index");
        if (index == 0) {
          logout(context);
        } else if (index == 1) {
          photo_camera(context);
        } else if (index == 2) {
          _httpService.geAllWines();
        } else if (index == 3) {
          goHome(context);
        }
      },
    ),
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

Future<void> goHome(BuildContext context) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const MyMainPage(title: "main"),
  ));
}
