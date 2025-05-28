import 'dart:convert';

import 'package:shazam_du_vin/utils/models.dart';

import '../services/localStorage.dart';

Future<User> buildCurrentUser() async {
  String currentUser = await readDataString("currentUser");
  var userData = jsonDecode(jsonDecode(currentUser));
  // If userData is a list, get the first item
  if (userData is List && userData.isNotEmpty) {
    userData = userData[0];
  }

  List<String> vinFavList = [];
  if (userData["vinFav"] != null) {
    var vinFav = userData["vinFav"];
    if (vinFav is Map<String, dynamic>) {
      // if vinFav is a map, get the values
      vinFavList = vinFav.values.map((item) => item.toString()).toList();
    } else if (vinFav is List) {
      // if vinFav is a list, get the values
      vinFavList = vinFav.map((item) => item.toString()).toList();
    }
  }
  VinFav vinFav = VinFav(vinFavList);

  return User(userData["username"] ?? "", userData["password"] ?? "",
      userData["role"] ?? "", vinFav);
}
