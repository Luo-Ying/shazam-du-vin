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
  var res = await _httpService.deleteWine(wineSelectedFormated);
  if (res.statusCode == 200) {
    Navigator.pop(context);
    eventBus.emit("deleteWine");
  }
}
