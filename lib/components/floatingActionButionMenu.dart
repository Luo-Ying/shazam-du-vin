import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shazam_du_vin/myImagePickerWidget.dart';
import 'package:shazam_du_vin/myListWinesFavorites.dart';

import '../mySearchWineByImageResultPage.dart';
import '../services/http_service.dart';

import '../myListWinePage.dart';
import '../myLoginPage.dart';
import '../myMainPage.dart';
import '../services/localStorage.dart';
import '../utils/models.dart';
import '../services/var_global.dart';

late final HttpService _httpService = HttpService();

ValueNotifier<bool> isDialOpen = ValueNotifier(false);

List<Wine> _listAllWines = [];
List<Wine> _listTopWines = [];
List<Wine> _listFavWines = [];

var _selectedImage;

Widget buildMainMenu(BuildContext context) {
  return SpeedDial(
    children: [
      SpeedDialChild(
          child: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          label: 'log out',
          labelStyle: const TextStyle(fontSize: 16.0),
          onTap: () {
            // isDialOpen.value = false;
            logout(context);
          }),
      SpeedDialChild(
        child: const Icon(
          Icons.photo_camera,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        label: 'camera',
        labelStyle: const TextStyle(fontSize: 16.0),
        onTap: () {
          // isDialOpen.value = false;
          photo_camera(context);
        },
      ),
      SpeedDialChild(
        child: const Icon(
          Icons.favorite,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        label: 'favorites wines',
        labelStyle: const TextStyle(fontSize: 16.0),
        onTap: () {
          // isDialOpen.value = false;
          goListFavorisPage(context);
        },
      ),
      SpeedDialChild(
        child: const Icon(
          Icons.list,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        label: 'all wines',
        labelStyle: const TextStyle(fontSize: 16.0),
        onTap: () {
          // isDialOpen.value = false;
          goListVinPage(context);
        },
      ),
      SpeedDialChild(
        child: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        label: 'home',
        labelStyle: const TextStyle(fontSize: 16.0),
        onTap: () {
          // isDialOpen.value = false;
          goHome(context);
        },
      ),
    ],
    closeManually: false,
    // openCloseDial: isDialOpen,
    spaceBetweenChildren: 20.0,
    animationDuration: const Duration(milliseconds: 300),
    animatedIcon: AnimatedIcons.menu_close,
    backgroundColor: Colors.black,
    overlayColor: const Color.fromRGBO(36, 38, 39, 1),
    child: const Icon(Icons.menu),
  );
}

Future<void> logout(BuildContext context) async {
  String result = await readDataString("currentUser");
  print("result: " + result);
  deleteData("currentUser");
  String result1 = await readDataString("currentUser");
  print("result apprès suprimé: " + result1);
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => const MyLoginPage(title: "login"),
  ));
}

Future<Future<int?>> photo_camera(BuildContext context) async {
  late List<String> options = ["Take a photo", "Select a photo from album"];
  return showModalBottomSheet<int>(
    isScrollControlled: false,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 100.0,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  print(index);
                  if (index == 0) {
                    _selectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                  } else if (index == 1) {
                    _selectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                  }
                  // Navigator.pop(context);
                  if (_selectedImage != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return MyImagePickerWidget(
                          imageSelected: _selectedImage,
                        );
                      },
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  options[index],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
          itemCount: options.length,
        ),
      );
    },
  );
}

Future<void> goListVinPage(BuildContext context) async {
  await getListAllWine();
  print("list alla wines: $_listAllWines");
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) {
      return MyListVinPage(
        listAllWines: _listAllWines,
      );
    },
  ));
}

Future<void> goListFavorisPage(BuildContext context) async {
  String currentUser = await readDataString("currentUser");
  print(currentUser);
  // print(jsonDecode(jsonDecode(currentUser))[0]["username"]);
  String currentUserName = jsonDecode(jsonDecode(currentUser))[0]["username"];
  print(currentUserName);
  await getListFavWines(currentUserName);
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) {
      return MyListWinesFavorites(
        listWinesFavorites: _listFavWines,
      );
    },
  ));
}

Future<void> goHome(BuildContext context) async {
  await getTopWines();
  print("coucou! $_listTopWines");
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) {
      return MyMainPage(
        title: 'main',
        listTopWines: _listTopWines,
      );
    },
  ));
}

Future<void> getListAllWine() async {
  _listAllWines = [];
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
    print(item["noteGlobale"]);
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
    _listAllWines.add(wine);
    VarGlobal.LISTALLWINES.add(wine);
  }
  // print(_listAllWine[0].description);
}

Future<void> getTopWines() async {
  _listTopWines = [];
  var res = await _httpService.getTopWines();
  var data = jsonDecode(res.body);
  // print(data);
  // print(data[0]["commentaire"].length);
  // print(data.length);
  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String nom = data[i]["nom"];
    String vignoble = data[i]["vignoble"];
    String cepage = data[i]["cepage"];
    String type = data[i]["type"];
    String annee = data[i]["annee"];
    String image = data[i]["image"];
    String description = data[i]["description"];
    print(data[i]["noteGlobale"]);
    num noteGlobale = data[i]["noteGlobale"];
    print(data[i]["commentaire"]);
    late List<Commentaire> listCommentaire = [];
    if (data[i]["commentaire"].length > 0) {
      for (int j = 0; j < data[i]["commentaire"].length; j++) {
        String username = data[i]["commentaire"][j]["username"];
        String text = data[i]["commentaire"][j]["text"];
        num note = data[i]["commentaire"][j]["note"];
        int date = data[i]["commentaire"][j]["date"];
        Commentaire commentaire = Commentaire(username, text, note, date);
        listCommentaire.add(commentaire);
      }
    }
    Wine wine = Wine(id, nom, vignoble, cepage, type, annee, image, description,
        noteGlobale, listCommentaire);
    _listTopWines.add(wine);
  }
}

Future<void> getListFavWines(String currentUserName) async {
  _listFavWines = [];
  var res = await _httpService.getFavorisWines(currentUserName);
  // print(res.body);
  var data = jsonDecode(res.body);
  print(data);
  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String nom = data[i]["nom"];
    String vignoble = data[i]["vignoble"];
    String cepage = data[i]["cepage"];
    String type = data[i]["type"];
    String annee = data[i]["annee"];
    String image = data[i]["image"];
    String description = data[i]["description"];
    // print(data[i]["noteGlobale"]);
    num noteGlobale = data[i]["noteGlobale"];
    print(data[i]["commentaire"]);
    late List<Commentaire> listCommentaire = [];
    if (data[i]["commentaire"].length > 0) {
      for (int j = 0; j < data[i]["commentaire"].length; j++) {
        String username = data[i]["commentaire"][j]["username"];
        // print(userId);
        String text = data[i]["commentaire"][j]["text"];
        num note = data[i]["commentaire"][j]["note"];
        int date = data[i]["commentaire"][j]["date"];
        Commentaire commentaire = Commentaire(username, text, note, date);
        listCommentaire.add(commentaire);
      }
    }
    Wine wine = Wine(id, nom, vignoble, cepage, type, annee, image, description,
        noteGlobale, listCommentaire);
    _listFavWines.add(wine);
  }
}

// void showCustomDialog(BuildContext context) {
//   // print("position ---- >  " + position.toString());
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Do you want delete ?"),
//           content: SingleChildScrollView(
//               child: ListBody(children: [
//             Text(
//               wine.nom,
//               style:
//                   const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800),
//             )
//           ])),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               style: const ButtonStyle(
//                   backgroundColor: MaterialStatePropertyAll<Color>(
//                       Color.fromRGBO(121, 121, 121, 1))),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 deleteWine(context, wine);
//               },
//               style: const ButtonStyle(
//                   backgroundColor:
//                       MaterialStatePropertyAll<Color>(Colors.black)),
//               child: const Text("Confirm"),
//             ),
//           ],
//         );
//       });
// }
