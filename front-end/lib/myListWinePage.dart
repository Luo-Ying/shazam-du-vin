import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shazam_du_vin/myWineFormPage.dart';
import 'package:shazam_du_vin/services/var_global.dart';
import 'package:shazam_du_vin/services/winesActions.dart';

import 'components/floatingActionButionMenu.dart';
import 'components/wineCard.dart';

import 'utils/models.dart';
import 'utils/eventBus.dart';

class MyListVinPage extends StatefulWidget {
  const MyListVinPage({Key? key, required this.listAllWines}) : super(key: key);

  final List<Wine> listAllWines;

  @override
  State<MyListVinPage> createState() => _MyListVinPageState();
}

class _MyListVinPageState extends State<MyListVinPage> {
  late List<Wine> listAllWines;

  Uint8List targetlUinit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
  Uint8List originalUnit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);

  @override
  void initState() {
    eventBus.on("deleteWine", (arg) async {
      if (!mounted) {
        return;
      }
      setState(() {
        listAllWines = WineActions.listAllWines;
      });
    });
    eventBus.on("addInFavoris", (arg) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    eventBus.on("removeFromFavoris", (arg) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    eventBus.on("addNewWine", (arg) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(child: builListViewOfListAllWine(context)),
      floatingActionButton: buildMainMenu(context),
    );
  }

  Widget buildPageLayoutWidget(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 50.0),
        builListViewOfListAllWine(context),
      ],
    );
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
  }

  PreferredSize buildAppBar(BuildContext context) {
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
                      child: VarGlobal.currentUser.username == "admin"
                          ? buildAddWineButtonAdmin(context)
                          : const SizedBox.shrink(),
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
      width: 160,
      child: ElevatedButton(
        onPressed: () {
          Wine wine = Wine("", "", "", "", "", "", "", "", -1, 0, "", []);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                MyWineFormPage(wineSelected: wine, isModif: false),
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: const Stack(
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "add new wine",
                    style: TextStyle(color: Colors.white),
                  ),
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
