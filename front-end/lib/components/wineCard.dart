import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import '../myWinePage.dart';
import '../services/localStorage.dart';
import '../services/winesActions.dart';
import '../utils/models.dart';
import 'fluttertoast.dart';

String user = "";

Widget buildWineCard(BuildContext context, Wine wine, int index,
    bool isListAllWine, bool isTopWine, bool isWineFavoris) {
  int numTop = index + 1;
  return Card(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    shadowColor: Colors.grey,
    elevation: 5,
    child: InkWell(
      onTap: () {
        goWinePage(context, wine);
      },
      onLongPress: () async {
        // print("coucou?");
        String dataCurrentUser = await readDataString("currentUser");
        String roleOfCurrentUser =
            jsonDecode(jsonDecode(dataCurrentUser))[0]['role'];
        if (roleOfCurrentUser == "admin") {
          showCustomDialog(context, wine);
        }
      },
      child: Stack(
        children: [
          Row(
            children: [
              isTopWine ? buildWineTopNum(context, numTop) : Container(),
              buildWineInfos(context, isTopWine, wine, isListAllWine),
              buildWineImage(context, wine, isListAllWine)
            ],
          ),
          buildIconActions(context, wine, isWineFavoris)
        ],
      ),
    ),
  );
}

void getUserData() async {
  user = await readDataString("currentUser");
}

Widget buildIconActions(BuildContext context, Wine wine, bool isWineFavoris) {
  bool isWineInListFav = VarGlobal.currentUser.vinFav.value.contains(wine.id);
  return IconButton(
      onPressed: () async {
        isWineInListFav
            ? await WineActions.removeWineFromFavoris(context, wine)
            : await WineActions.addWineToFavoris(context, wine);

        Fluttertoast.showToast(
          msg: VarGlobal.TOASTMESSAGE,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      icon: isWineInListFav
          ? const Icon(
              Icons.favorite,
              size: 30.0,
            )
          : const Icon(
              Icons.favorite_border,
              size: 30.0,
              color: Colors.grey,
            ));
}

Widget buildWineTopNum(BuildContext context, int numTop) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          "$numTop",
          style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(217, 192, 159, 1)),
        ),
      )
    ],
  );
}

Widget buildWineImage(BuildContext context, Wine wine, bool isListAllWine) {
  return Expanded(
      child: Align(
          alignment: Alignment.centerRight,
          child: Image.network(
            wine.image,
            width: isListAllWine ? 40.0 : 80.0,
            height: isListAllWine ? 100.0 : 200.0,
            fit: BoxFit.cover,
          )));
}

Widget buildWineInfos(
    BuildContext context, bool isTopWine, Wine wine, bool isListAllWine) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(left: isListAllWine ? 55 : 25.0, top: 5.0),
        child: Container(
          width: isTopWine ? 200.0 : 230,
          child: Text(
            wine.nom,
            style: TextStyle(
                fontSize: isListAllWine ? 18.0 : 22.0,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 20.0),
      Padding(
        padding: EdgeInsets.only(left: isListAllWine ? 75 : 35.0, top: 5.0),
        child: SizedBox(
          width: isTopWine ? 200.0 : 230,
          child: Text(
            wine.annee,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    ],
  );
}

void goWinePage(BuildContext context, Wine wine) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return MyWinePage(wine: wine);
    },
  ));
}

void showCustomDialog(BuildContext context, Wine wine) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do you want delete ?"),
          content: SingleChildScrollView(
              child: ListBody(children: [
            Text(
              wine.nom,
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800),
            )
          ])),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                      Color.fromRGBO(121, 121, 121, 1))),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await WineActions.deleteWine(context, wine);
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: VarGlobal.TOASTMESSAGE,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.black)),
              child: const Text("Confirm"),
            ),
          ],
        );
      });
}
