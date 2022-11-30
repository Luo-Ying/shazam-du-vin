import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shazam_du_vin/myAddNewWineFormPage.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import './services/http_service.dart';
import '../services/localStorage.dart';
import './services/var_global.dart';
import 'components/myMainMenuFunction.dart';

import 'utils/models.dart';

class MyListVinPage extends StatefulWidget {
  const MyListVinPage({Key? key}) : super(key: key);

  @override
  State<MyListVinPage> createState() => _MyListVinPageState();
}

class _MyListVinPageState extends State<MyListVinPage> {
  late final HttpService _httpService = HttpService();

  late List<Wine> _listAllWine = [];

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  Future<void> initFunction() async {
    var res = await _httpService.geAllWines();
    print(jsonDecode(res.body));
    print(jsonDecode(res.body).length);
    for (var item in jsonDecode(res.body)) {
      print(item);
      String nom = item["nom"];
      String vignoble = item["vignoble"];
      String type = item["type"];
      String annee = item["annee"];
      String image = item["image"];
      String description = item["description"];
      // print(data[i]["commentaire"][0]["userID"]);
      late List<Commentaire> listCommentaire = [];
      if (item["commentaire"].length > 0) {
        for (int j = 0; j < item["commentaire"].length; j++) {
          String userId = item["commentaire"][j]["userID"];
          print(userId);
          String text = item["commentaire"][j]["text"];
          double note = item["commentaire"][j]["note"];
          String date = item["commentaire"][j]["date"];
          Commentaire commentaire = Commentaire(userId, text, note, date);
          listCommentaire.add(commentaire);
        }
      }
      Wine wine =
          Wine(nom, vignoble, type, annee, image, description, listCommentaire);
      _listAllWine.add(wine);
    }
    // print(_listAllWine[0].description);
  }

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

  // Widget buildListView(BuildContext context) {
  //   return ListView.builder(
  //     itemBuilder: (BuildContext context, int index) {
  //       return SizedBox(
  //         height: 50,
  //         child: ,
  //       );
  //     },
  //     itemCount: options.length,
  //   );
  // }

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
                Row(
                  children: [
                    const Text(
                      'All wines',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: Offstage(
                        offstage: VarGlobal.CURRENTUSERROLE == "user",
                        child: buildAddWineButtonAdmin(context),
                      ),
                    ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddWineButtonAdmin(BuildContext context) {
    return SizedBox(
      height: 28,
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyAddNewWineFormPage(),
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: Stack(
          children: [
            Row(
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: Icon(Icons.add),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("add new wine"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
