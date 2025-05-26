import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  static Wine updatedWine = {} as Wine;

  static Future<void> addWineToFavoris(
      BuildContext context, Wine wineSelected) async {
    print("add in favoris!");
    var currentUser = await readDataString("currentUser");
    print(jsonDecode(jsonDecode(currentUser))[0]);
    VarGlobal.currentUser.vinFav.value.add(wineSelected.id);
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
        "vinFav": [for (var item in VarGlobal.currentUser.vinFav.value) item]
      }
    };
    await _httpService.addOrRemoveFavorisWine(userFormated);
    eventBus.emit("addInFavoris");
  }

  static Future<void> removeWineFromFavoris(
      BuildContext context, Wine wineSelected) async {
    print("remove from favoris!");
    var currentUser = await readDataString("currentUser");
    print(jsonDecode(jsonDecode(currentUser))[0]);
    VarGlobal.currentUser.vinFav.value
        .removeWhere((item) => item == wineSelected.id);
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
        "vinFav": [for (var item in VarGlobal.currentUser.vinFav.value) item]
      }
    };
    await _httpService.addOrRemoveFavorisWine(userFormated);
    listFavWines.removeWhere((element) => element.id == wineSelected.id);
    eventBus.emit("removeFromFavoris");
  }

  void deletComment() {
    for (var item in listTopWines) {}
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
      VarGlobal.LISTALLWINES = [];
    } else if (choice == 2) {
      listTopWines = [];
      VarGlobal.LISTTOPWINES = [];
    } else if (choice == 3) {
      listFavWines = [];
      VarGlobal.LISTFAVWINES = [];
    } else {
      listWines = [];
    }
    print(listFavWines);
    print('data:  $data');
    if (data != null && data.length > 0) {
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
        num noteGlobale = item["noteGlobale"];
        num prix = item["prix"];
        print(item);
        String tauxAlcool = item["tauxAlcool"];
        late List<Commentaire> listCommentaire = [];
        if (item["commentaire"].length > 0) {
          for (int j = 0; j < item["commentaire"].length; j++) {
            String username = item["commentaire"][j]["username"];
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
    }
    print("result => $listFavWines");
    print(listFavWines.length);
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
