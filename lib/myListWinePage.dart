import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shazam_du_vin/myAddNewWineFormPage.dart';
import 'package:shazam_du_vin/services/var_global.dart';
import 'package:shazam_du_vin/services/winesActions.dart';

import './services/http_service.dart';
import '../services/localStorage.dart';
import './services/var_global.dart';
import 'components/floatingActionButionMenu.dart';
import 'components/wineCard.dart';

import 'utils/models.dart';
import 'utils/eventBus.dart';

class MyListVinPage extends StatefulWidget {
  const MyListVinPage({Key? key, required this.listAllWines}) : super(key: key);

  final List<Wine> listAllWines;

  @override
  _MyListVinPageState createState() {
    return _MyListVinPageState(listAllWines);
  }
}

class _MyListVinPageState extends State<MyListVinPage> {
  List<Wine> listAllWines;

  _MyListVinPageState(this.listAllWines);

  late final HttpService _httpService = HttpService();

  Uint8List targetlUinit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
  Uint8List originalUnit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);

  @override
  void initState() {
    eventBus.on("deleteWine", (arg) async {
      print("coucou??????");
      listAllWines = await setListAllWine();
      setState(() {});
    });
    eventBus.on("addInFavoris", (arg) async {
      setState(() {});
    });
    eventBus.on("removeFromFavoris", (arg) async {
      setState(() {});
    });
    super.initState();
  }

  // Future<List<Wine>> setListAllWine() async {
  //   List<Wine> listWines = [];
  //   var res = await _httpService.geAllWines();
  //   // print(jsonDecode(res.body));
  //   // print(jsonDecode(res.body).length);
  //   for (var item in jsonDecode(res.body)) {
  //     print(item);
  //     String id = item["id"];
  //     String nom = item["nom"];
  //     String vignoble = item["vignoble"];
  //     String cepage = item["cepage"];
  //     String type = item["type"];
  //     String annee = item["annee"];
  //     String image = item["image"];
  //     String description = item["description"];
  //     // print(item["noteGlobale"]);
  //     num noteGlobale = item["noteGlobale"];
  //     // print(data[i]["commentaire"][0]["userID"]);
  //     late List<Commentaire> listCommentaire = [];
  //     if (item["commentaire"].length > 0) {
  //       for (int j = 0; j < item["commentaire"].length; j++) {
  //         String username = item["commentaire"][j]["username"];
  //         // print(userId);
  //         String text = item["commentaire"][j]["text"];
  //         num note = item["commentaire"][j]["note"];
  //         int date = item["commentaire"][j]["date"];
  //         Commentaire commentaire = Commentaire(username, text, note, date);
  //         listCommentaire.add(commentaire);
  //       }
  //     }
  //     Wine wine = Wine(id, nom, vignoble, cepage, type, annee, image, description,
  //         noteGlobale, listCommentaire);
  //     listWines.add(wine);
  //     VarGlobal.LISTALLWINES.add(wine);
  //   }
  //   // print(_listAllWine[0].description);
  //   return listWines;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(child: builListViewOfListAllWine(context)),
      floatingActionButton: buildMainMenu(context),
    );
  }

  Widget buildPageLayoutWidget(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 50.0),
        // buildTextNotifNbResult(context),
        // const SizedBox(height: 10.0),
        builListViewOfListAllWine(context),
      ],
    );
    //   Column(
    //   children: <Widget>[
    //     const SizedBox(height: 10.0),
    //     // buildTextNotifNbResult(context),
    //     // const SizedBox(height: 10.0),
    //     builListViewOfListAllWine(context),
    //   ],
    // );
  }

  Widget builListViewOfListAllWine(BuildContext context) {
    print("list alla wines: $listAllWines");
    print("var global list:  $VarGlobal.LISTALLWINES");
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          // height: 50,
          child: buildWineCard(
              context, listAllWines[index], index, true, false, false),
        );
      },
      itemCount: listAllWines.length,
    );
    // return SingleChildScrollView(
    //     scrollDirection: Axis.horizontal,
    //     child: Row(children: <Widget>[
    //       for (int i = 0; i < listAllWines.length; i++)
    //         buildWineCard(context, listAllWines[i], i, true, false, false),
    //     ]));
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
                ),
                buildTitleLine(),
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
}
