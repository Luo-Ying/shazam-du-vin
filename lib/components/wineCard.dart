import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../myWinePage.dart';
import '../services/http_service.dart';
import '../services/localStorage.dart';
import '../utils/eventBus.dart';
import '../utils/models.dart';

late final HttpService _httpService = HttpService();

Widget buildWineCard(
    BuildContext context, Wine wineSelected, int index, bool isTopWine) {
  int numTop = index + 1;
  return Card(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    shadowColor: Colors.grey,
    elevation: 5,
    child: InkWell(
      onTap: () {
        goWinePage(context, wineSelected);
      },
      onLongPress: () async {
        // print("coucou?");
        String dataCurrentUser = await readDataString("currentUser");
        String roleOfCurrentUser =
            jsonDecode(jsonDecode(dataCurrentUser))[0]['role'];
        if (roleOfCurrentUser == "admin") {
          showCustomDialog(context, wineSelected);
        }
      },
      child: Row(
        children: [
          isTopWine
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "$numTop",
                        style: const TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                )
              : Container(),
          Column(
            children: [
              // Text(listAllWines[index].nom),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                child: Container(
                  width: isTopWine ? 200.0 : 260,
                  child: Text(
                    wineSelected.nom,
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 5.0),
                child: SizedBox(
                  width: isTopWine ? 200.0 : 260,
                  child: Text(
                    wineSelected.annee,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.network(
                    wineSelected.image,
                    width: 80.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  )))
        ],
      ),
    ),
  );
}

void goWinePage(BuildContext context, Wine wine) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return MyWinePage(wine: wine);
    },
  ));
}

void showCustomDialog(BuildContext context, Wine wineSelected) {
  // print("position ---- >  " + position.toString());
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do you want delete ?"),
          content: SingleChildScrollView(
              child: ListBody(children: [
            Text(
              wineSelected.nom,
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
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromRGBO(121, 121, 121, 1))),
              child: const Text("Cancel"),
            ),
            // TODO: fix-le!!!! qu'est-ce qu'il manque comme information dans le body ?????????????????????
            ElevatedButton(
              onPressed: () async {
                var wineSelectedFormated = {
                  "database": "urbanisation",
                  "collection": "Vin",
                  "filter": {
                    "id": wineSelected.id,
                  }
                };
                print(wineSelected.id);
                var res = await _httpService.deleteWine(wineSelectedFormated);
                if (res.statusCode == 200) {
                  Navigator.pop(context);
                  eventBus.emit("deleteWine");
                }
              },
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.black)),
              child: const Text("Confirm"),
            ),
          ],
        );
      });
}
