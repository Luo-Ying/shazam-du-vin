import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shazam_du_vin/services/localStorage.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import '../utils/eventBus.dart';
import '../utils/models.dart';
import 'http_service.dart';

late final HttpService _httpService = HttpService();

Future<void> addWineToFavoris(BuildContext context, Wine wineSelected) async {
  print("add in favoris!");
  var currentUser = await readDataString("currentUser");
  print(jsonDecode(jsonDecode(currentUser))[0]);
  // List<String> listIdVinFav = [];
  // for (var item in jsonDecode(jsonDecode(currentUser))[0]["vinFav"]["value"]) {
  //   listIdVinFav.add(item);
  // }
  var userFormated = {
    "database": "urbanisation",
    "collection": "User",
    "filter": {"username": jsonDecode(jsonDecode(currentUser))[0]["username"]},
    "data": {
      "username": jsonDecode(jsonDecode(currentUser))[0]["username"],
      "password": jsonDecode(jsonDecode(currentUser))[0]["password"],
      "role": jsonDecode(jsonDecode(currentUser))[0]["role"],
      "vinFav": [
        for (var item in jsonDecode(jsonDecode(currentUser))[0]["vinFav"]) item,
        wineSelected.id
      ]
    }
  };
  _httpService.addOrRemoveFavorisWine(userFormated);
  VarGlobal.CURRENTUSER_VINFAV.add(wineSelected.id);
  eventBus.emit("addInFavoris");
}

Future<void> removeWineFromFavoris(
    BuildContext context, Wine wineSelected) async {
  print("remove from favoris!");
  var currentUser = await readDataString("currentUser");
  print(jsonDecode(jsonDecode(currentUser))[0]);
  List<String> listIdVinFav = [];
  for (var item in jsonDecode(jsonDecode(currentUser))[0]["vinFav"]) {
    listIdVinFav.add(item);
  }
  var userFormated = {
    "database": "urbanisation",
    "collection": "User",
    "filter": {"username": jsonDecode(jsonDecode(currentUser))[0]["username"]},
    "data": {
      "username": jsonDecode(jsonDecode(currentUser))[0]["username"],
      "password": jsonDecode(jsonDecode(currentUser))[0]["password"],
      "role": jsonDecode(jsonDecode(currentUser))[0]["role"],
      "vinFav": [
        for (var item in jsonDecode(jsonDecode(currentUser))[0]["vinFav"])
          if (item != wineSelected.id) item
      ]
    }
  };
  _httpService.addOrRemoveFavorisWine(userFormated);
  VarGlobal.CURRENTUSER_VINFAV.removeWhere((item) => item == wineSelected.id);
  eventBus.emit("removeFromFavoris");
}

Future<void> deleteWine(BuildContext context, Wine wineSelected) async {
  var wineSelectedFormated = {
    "database": "urbanisation",
    "collection": "Vin",
    "filter": {
      "id": wineSelected.id,
    }
  };
  print(wineSelected.id);
  _httpService.deleteWine(wineSelectedFormated);
  // Navigator.pop(context);
  // eventBus.emit("deleteWine");
  Navigator.pop(context);
  eventBus.emit("deleteWine");
  // if (res.statusCode == 200) {
  // }
}

Future<List<Wine>> setListAllWine() async {
  List<Wine> listWines = [];
  var res = await _httpService.geAllWines();
  // print(jsonDecode(res.body));
  // print(jsonDecode(res.body).length);
  for (var item in jsonDecode(res.body)) {
    print(item);
    String id = item["id"];
    String nom = item["nom"];
    String vignoble = item["vignoble"];
    String cepage = item["cepage"];
    String type = item["type"];
    String annee = item["annee"];
    String image = item["image"];
    String description = item["description"];
    // print(item["noteGlobale"]);
    num noteGlobale = item["noteGlobale"];
    // print(data[i]["commentaire"][0]["userID"]);
    late List<Commentaire> listCommentaire = [];
    if (item["commentaire"].length > 0) {
      for (int j = 0; j < item["commentaire"].length; j++) {
        String username = item["commentaire"][j]["username"];
        // print(userId);
        String text = item["commentaire"][j]["text"];
        num note = item["commentaire"][j]["note"];
        int date = item["commentaire"][j]["date"];
        Commentaire commentaire = Commentaire(username, text, note, date);
        listCommentaire.add(commentaire);
      }
    }
    Wine wine = Wine(id, nom, vignoble, cepage, type, annee, image, description,
        noteGlobale, listCommentaire);
    listWines.add(wine);
    VarGlobal.LISTALLWINES.add(wine);
  }
  // print(_listAllWine[0].description);
  return listWines;
}
