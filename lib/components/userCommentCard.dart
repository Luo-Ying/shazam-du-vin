import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shazam_du_vin/myWinePage.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import '../services/http_service.dart';
import '../services/localStorage.dart';
import '../services/winesActions.dart';
import '../utils/eventBus.dart';
import '../utils/models.dart';

late final HttpService _httpService = HttpService();

Widget buildUserCommentCard(
    BuildContext context, Commentaire commentaire, Wine wine) {
  return Card(
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      side: BorderSide(color: Color.fromRGBO(235, 234, 234, 1)),
    ),
    child: InkWell(
      onLongPress: () async {
        // print("coucou?");
        String dataCurrentUser = await readDataString("currentUser");
        String roleOfCurrentUser =
            jsonDecode(jsonDecode(dataCurrentUser))[0]['role'];
        String currentUserName =
            jsonDecode(jsonDecode(dataCurrentUser))[0]['username'];
        if (roleOfCurrentUser == "admin" ||
            currentUserName == commentaire.username) {
          showCustomDialog(context, commentaire, wine);
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 10.0, bottom: 15.0),
            child: sizeBoxOfUserNameAndRating(context, commentaire),
          ),
          buildCommentText(context, commentaire),
        ],
      ),
    ),
  );
}

Widget buildCommentText(BuildContext context, Commentaire commentaire) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 10.0, bottom: 15.0),
    child: Text(
      commentaire.text,
      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
    ),
  );
}

Widget sizeBoxOfUserNameAndRating(
    BuildContext context, Commentaire commentaire) {
  return SizedBox(
    child: Row(
      children: [
        buildUserName(context, commentaire),
        if (VarGlobal.CURRENTUSERNAME == commentaire.username)
          buildTextToShowUserCurrent(context, commentaire),
        const SizedBox(width: 10.0),
        buildRatingStar(context, commentaire),
      ],
    ),
  );
}

Widget buildUserName(BuildContext context, Commentaire commentaire) {
  return Text(
    commentaire.username,
    style: const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w800,
      color: Color.fromRGBO(142, 4, 100, 1),
    ),
  );
}

Widget buildTextToShowUserCurrent(
    BuildContext context, Commentaire commentaire) {
  return const Text(
    "(you)",
    style: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w800,
      color: Color.fromRGBO(180, 180, 180, 1),
    ),
  );
}

Widget buildRatingStar(BuildContext context, Commentaire commentaire) {
  return Expanded(
      child: Align(
    alignment: Alignment(-1, 1),
    child: Container(
      height: 20.0,
      width: 48.0,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(249, 247, 214, 1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: buildRatingText(context, commentaire),
    ),
  ));
}

Widget buildRatingText(BuildContext context, Commentaire commentaire) {
  num note = commentaire.note;
  return Padding(
    padding: const EdgeInsets.only(left: 3.0),
    child: SizedBox(
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Color.fromRGBO(240, 164, 10, 1),
            size: 15.0,
          ),
          const SizedBox(width: 3.0),
          Text("$note")
        ],
      ),
    ),
  );
}

@override
void showCustomDialog(
    BuildContext context, Commentaire commentSelected, Wine wine) {
  // print("position ---- >  " + position.toString());
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do you want delete this comment ?"),
          content: SingleChildScrollView(
              child: ListBody(children: [
            Text(
              commentSelected.text,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
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
            ElevatedButton(
              onPressed: () async {
                print(commentSelected);
                num noteGlobale = wine.listCommentaire.length > 1
                    ? (wine.noteGlobale * wine.listCommentaire.length -
                            commentSelected.note) /
                        (wine.listCommentaire.length - 1)
                    : -1;
                wine.listCommentaire.removeWhere((item) =>
                    item.text == commentSelected.text &&
                    item.date == commentSelected.date);
                wine.noteGlobale = noteGlobale;
                var newWineFormated = {
                  "id": wine.id,
                  "nom": wine.nom,
                  "vignoble": wine.vignoble,
                  "cepage": wine.cepage,
                  "type": wine.type,
                  "annee": wine.annee,
                  "image": wine.image,
                  "description": wine.description,
                  "commentaire": [
                    for (var item in wine.listCommentaire)
                      {
                        "username": item.username,
                        "text": item.text,
                        "note": item.note,
                        "date": item.date
                      },
                  ]
                };
                try {
                  var res =
                      await _httpService.addOrDeleteComment(newWineFormated);
                  if (res.statusCode == 200) {
                    // setState(() {});
                    Navigator.pop(context);
                    // var res = await _httpService.getWineById(wine.id);
                    // print(res.body);
                    // WineActions.setListWine(4, jsonDecode(res.body));
                    // WineActions.updatedWine = WineActions.listWines[0];
                    var res = await _httpService.getTopWines();
                    WineActions.setListWine(2, jsonDecode(res.body));
                    eventBus.emit("deleteComment");
                    // VarGlobal.isCommentUpdated = true;
                    // print("??????");
                    // MyWinePage myWinePage = MyWinePage(wine: wine);
                    // myWinePage.refrePage();
                    // TODO: débuger le problème de mettre à jours les données de la page !!!!!!!!
                  }
                } catch (e) {}
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
