import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shazam_du_vin/myListWinePage.dart';
import 'package:shazam_du_vin/services/localStorage.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import '../utils/eventBus.dart';
import '../utils/models.dart';
import 'http_service.dart';

class WineActions {
  static final HttpService _httpService = HttpService();

  static List<Wine> listAllWines = [];
  static List<Wine> listTopWines = [];
  static List<Wine> listFavWines = [];
  static List<Wine> listWines = [];

  static Future<void> addWineToFavoris(
      BuildContext context, Wine wineSelected) async {
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
      "filter": {
        "username": jsonDecode(jsonDecode(currentUser))[0]["username"]
      },
      "data": {
        "username": jsonDecode(jsonDecode(currentUser))[0]["username"],
        "password": jsonDecode(jsonDecode(currentUser))[0]["password"],
        "role": jsonDecode(jsonDecode(currentUser))[0]["role"],
        "vinFav": [
          for (var item in jsonDecode(jsonDecode(currentUser))[0]["vinFav"])
            item,
          wineSelected.id
        ]
      }
    };
    _httpService.addOrRemoveFavorisWine(userFormated);
    VarGlobal.CURRENTUSER_VINFAV.add(wineSelected.id);
    eventBus.emit("addInFavoris");
  }

  static Future<void> removeWineFromFavoris(
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
      "filter": {
        "username": jsonDecode(jsonDecode(currentUser))[0]["username"]
      },
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

  static Future<void> deleteWine(
      BuildContext context, Wine wineSelected) async {
    var wineSelectedFormated = {
      "database": "urbanisation",
      "collection": "Vin",
      "filter": {
        "id": wineSelected.id,
      }
    };
    print(wineSelected.id);
    await _httpService.deleteWine(wineSelectedFormated);
    listAllWines.removeWhere((element) => element.id == wineSelected.id);
    listTopWines.removeWhere((element) => element.id == wineSelected.id);
    listFavWines.removeWhere((element) => element.id == wineSelected.id);
    eventBus.emit("deleteWine");
  }

  static void setListWine(int choice, var data) {
    if (choice == 1) {
      listAllWines = [];
    } else if (choice == 2) {
      listTopWines = [];
    } else if (choice == 3) {
      listFavWines = [];
    } else {
      listWines = [];
    }
    // print(jsonDecode(res.body));
    // print(jsonDecode(res.body).length);
    for (var item in data) {
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
      num prix = item["prix"];
      print(item);
      String tauxAlcool = item["tauxAlcool"];
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
      Wine wine = Wine(id, nom, vignoble, cepage, type, annee, image,
          description, noteGlobale, prix, tauxAlcool, listCommentaire);
      if (choice == 1) {
        listAllWines.add(wine);
        VarGlobal.LISTALLWINES.add(wine);
      } else if (choice == 2) {
        listTopWines.add(wine);
        VarGlobal.LISTTOPWINES.add(wine);
      } else if (choice == 3) {
        listFavWines.add(wine);
        VarGlobal.LISTFAVWINES.add(wine);
      } else {
        listWines.add(wine);
      }
    }
    // print(_listAllWine[0].description);
    // return listWines;
  }

// Future<http.Response> addNewWineAction(XFile selectedImage, String nom, String vignoble,
//     String cepage, String type, String annee, String description) async {
//   File imgFile = File(selectedImage.path);
//   var res = await _httpService.insertImage(imgFile);
//   if (res.statusCode == 200) {
//     var uuid;
//     var id = uuid.v4();
//     print(id);
//     res.stream.transform(utf8.decoder).listen((value) async {
//       print(value);
//       var newWine = {
//         "database": "urbanisation",
//         "collection": "Vin",
//         "data": {
//           "id": id,
//           "nom": nom,
//           "vignoble": vignoble,
//           "cepage": cepage,
//           "type": type,
//           "annee": annee,
//           "image": value,
//           "description": description,
//           "noteGlobale": -1,
//           "commentaire": [],
//         }
//       };
//       var res = await _httpService.addNewWine(newWine);
//       return res;
//     });
//   }
//   return
// }
}
