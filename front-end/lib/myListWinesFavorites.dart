import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shazam_du_vin/services/winesActions.dart';
import 'package:shazam_du_vin/utils/eventBus.dart';

import 'components/floatingActionButionMenu.dart';
import 'components/wineCard.dart';
import 'utils/models.dart';

class MyListWinesFavorites extends StatefulWidget {
  const MyListWinesFavorites({Key? key, required this.listWinesFavorites})
      : super(key: key);

  final List<Wine> listWinesFavorites;

  @override
  State<MyListWinesFavorites> createState() => _MyListWinesFavoritesState();
}

class _MyListWinesFavoritesState extends State<MyListWinesFavorites> {
  late List<Wine> listWinesFavorites;

  @override
  void initState() {
    listWinesFavorites = widget.listWinesFavorites;
    
    eventBus.on("addInFavoris", (arg) async {
      if (!mounted) {
        return;
      }
      setState(() {
        listWinesFavorites = WineActions.listFavWines;
      });
    });
    eventBus.on("removeFromFavoris", (arg) async {
      if (!mounted) {
        return;
      }
      setState(() {
        listWinesFavorites = WineActions.listFavWines;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        child: builListViewOfListFavoritesWine(context),
      ),
      floatingActionButton: buildMainMenu(context),
    );
  }

  Widget builListViewOfListFavoritesWine(BuildContext context) {
    // print("list alla wines: $listAllWines");
    // print("var global list:  $VarGlobal.LISTALLWINES");
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          // height: 50,
          child: buildWineCard(
              context, listWinesFavorites[index], index, false, false, true),
        );
      },
      itemCount: listWinesFavorites.length,
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
                  children: const [
                    Text(
                      'Favorites wines',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
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
