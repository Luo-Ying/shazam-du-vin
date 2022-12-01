import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shazam_du_vin/myAddNewWineFormPage.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import './services/http_service.dart';
import '../services/localStorage.dart';
import './services/var_global.dart';
import 'components/flutingActionButionMenu.dart';
import 'components/wineCard.dart';

import 'utils/models.dart';

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

  Uint8List targetlUinit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
  Uint8List originalUnit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);

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
    print("list alla wines: $listAllWines");
    print("var global list:  $VarGlobal.LISTALLWINES");
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          // height: 50,
          child: buildWineCard(context, listAllWines[index], index, false),
        );
      },
      itemCount: listAllWines.length,
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
