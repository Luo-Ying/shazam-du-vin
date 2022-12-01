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
import 'components/myMainMenuFunction.dart';
import './utils/models.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  late final HttpService _httpService = HttpService();

  late List<Wine> listTopWines = [];

  @override
  void initState() {
    getWines();
    print(listTopWines);
    print(listTopWines.length);
    super.initState();
  }

  Future<void> getWines() async {
    var res = await _httpService.getTopWines();
    var data = jsonDecode(res.body);
    // print(data);
    // print(data[0]["commentaire"].length);
    // print(data.length);
    for (int i = 0; i < data.length; i++) {
      String nom = data[i]["nom"];
      String vignoble = data[i]["vignoble"];
      String type = data[i]["type"];
      String annee = data[i]["annee"];
      String image = data[i]["image"];
      String description = data[i]["description"];
      // print(data[i]["commentaire"][0]["userID"]);
      late List<Commentaire> listCommentaire = [];
      if (data[i]["commentaire"].length > 0) {
        for (int j = 0; j < data[i]["commentaire"].length; j++) {
          String userId = data[i]["commentaire"][j]["userID"];
          print(userId);
          String text = data[i]["commentaire"][j]["text"];
          double note = data[i]["commentaire"][j]["note"];
          String date = data[i]["commentaire"][j]["date"];
          Commentaire commentaire = Commentaire(userId, text, note, date);
          listCommentaire.add(commentaire);
          Wine wine = Wine(
              nom, vignoble, type, annee, image, description, listCommentaire);
          listTopWines.add(wine);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        // constraints: const BoxConstraints.expand(),
        child: Stack(
          children: [
            // buildFloatingMenuButton(context),
          ],
        ),
      ),
      floatingActionButton: buildMainMenu(context),
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
