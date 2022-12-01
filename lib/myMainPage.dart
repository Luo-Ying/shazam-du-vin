import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:shazam_du_vin/myImagePickerWidget.dart';
import 'package:shazam_du_vin/myLoginPage.dart';

import './services/http_service.dart';
import './services/localStorage.dart';
import 'components/flutingActionButionMenu.dart';
import 'components/wineCard.dart';
import './utils/models.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key, required this.title, required this.listTopWines})
      : super(key: key);
  final String title;

  final List<Wine> listTopWines;

  @override
  _MyMainPageState createState() {
    return _MyMainPageState(listTopWines);
  }
}

class _MyMainPageState extends State<MyMainPage> {
  List<Wine> listTopWines;

  _MyMainPageState(this.listTopWines);

  late final HttpService _httpService = HttpService();

  @override
  void initState() {
    print("list top wines:  $listTopWines");
    print(listTopWines.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        child: builListViewOfListAllWine(context),
      ),
      floatingActionButton: buildMainMenu(context),
    );
  }

  Widget builListViewOfListAllWine(BuildContext context) {
    print("list alla wines: $listTopWines");
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          child: buildWineCard(context, listTopWines[index], index),
        );
      },
      itemCount: listTopWines.length,
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
