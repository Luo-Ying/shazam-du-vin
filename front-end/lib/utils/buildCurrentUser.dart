import 'dart:convert';

import 'package:shazam_du_vin/utils/models.dart';

import '../services/localStorage.dart';

Future<User> buildCurrentUser() async {
  String currentUser = await readDataString("currentUser");
  var userData = jsonDecode(jsonDecode(currentUser))[0];

  List<String> vinFavList = [];
  if (userData["vinFav"] != null) {
    Map<String, dynamic> vinFavMap = userData["vinFav"];
    vinFavList = vinFavMap.values.map((item) => item.toString()).toList();
  }
  VinFav vinFav = VinFav(vinFavList);

  return User(userData["username"] ?? "", userData["password"] ?? "",
      userData["role"] ?? "", vinFav);
}
