import 'dart:convert';
import 'dart:io';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shazam_du_vin/mySearchWineByImageResultPage.dart';
import 'package:shazam_du_vin/services/http_service.dart';
import 'package:shazam_du_vin/services/winesActions.dart';
import 'package:shazam_du_vin/utils/models.dart';

class MyImagePickerWidget extends StatefulWidget {
  const MyImagePickerWidget({Key? key, required this.imageSelected})
      : super(key: key);

  final XFile imageSelected;

  @override
  _MyImagePickerWidgetState createState() {
    return _MyImagePickerWidgetState(imageSelected);
  }
}

class _MyImagePickerWidgetState extends State<MyImagePickerWidget> {
  XFile imageSelected;

  _MyImagePickerWidgetState(this.imageSelected);

  late final HttpService _httpService = HttpService();

  List<Wine> _listResultWines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApppBar(context),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // const SizedBox(height: 50.0),
          buildImageView(context),
          buildButtonsWidget(context)
        ],
      ),
    );
  }

  Widget buildButtonCancel(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 40.0,
      child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: const MaterialStatePropertyAll<Color>(
                  Color.fromRGBO(91, 98, 205, 1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0))),
              backgroundColor:
                  const MaterialStatePropertyAll<Color>(Colors.grey)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(fontWeight: FontWeight.w800),
          )),
    );
  }

  Future<void> _searchWineByImage() async {
    print("coucou");
    print(imageSelected.path.runtimeType);
    File imgFile = File(imageSelected.path);
    var res = await _httpService.searchWinesByImage(imgFile);
    if (res.statusCode == 200) {
      res.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        print(value.runtimeType);
        await _getListResultWines(value);
        await Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return MySearchWineByImageResultPage(
              listResultWines: _listResultWines);
        }));
      });
    }
  }

  Widget buildButtonSearch(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 40.0,
      child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: const MaterialStatePropertyAll<Color>(
                  Color.fromRGBO(91, 98, 205, 1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0))),
              backgroundColor: const MaterialStatePropertyAll<Color>(
                  Color.fromRGBO(91, 98, 205, 1))),
          onPressed: () {
            print("?????????");
            _searchWineByImage();
          },
          child: const Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.w800),
          )),
    );
  }

  Widget buildButtonsWidget(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        left: (widthScreen - 230) / 2,
        top: (heightScreen - 150),
      ),
      child: Row(
        children: [
          Column(
            children: [buildButtonCancel(context)],
          ),
          const SizedBox(width: 30.0),
          Column(
            children: [
              buildButtonSearch(context),
            ],
          )
        ],
      ),
    );
  }

  Widget buildImageView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Align(
      child: Image(
        image: XFileImage(imageSelected),
        fit: BoxFit.contain,
        width: width,
        height: height,
      ),
    );
  }

  AppBar buildApppBar(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Image View',
        style: TextStyle(
          fontSize: 32,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _getListResultWines(String result) async {
    // _listResultWines = [];
    var data = jsonDecode(result);
    print(data);
    WineActions.setListWine(4, data);
    _listResultWines = WineActions.listWines;
    // for (int i = 0; i < data.length; i++) {
    //   String id = data[i]["id"];
    //   String nom = data[i]["nom"];
    //   String vignoble = data[i]["vignoble"];
    //   String cepage = data[i]["cepage"];
    //   String type = data[i]["type"];
    //   String annee = data[i]["annee"];
    //   String image = data[i]["image"];
    //   String description = data[i]["description"];
    //   // print(data[i]["noteGlobale"]);
    //   num noteGlobale = data[i]["noteGlobale"];
    //   num prix = data[i]["prix"];
    //   print(data[i]["commentaire"]);
    //   late List<Commentaire> listCommentaire = [];
    //   if (data[i]["commentaire"].length > 0) {
    //     for (int j = 0; j < data[i]["commentaire"].length; j++) {
    //       String username = data[i]["commentaire"][j]["username"];
    //       // print(userId);
    //       String text = data[i]["commentaire"][j]["text"];
    //       num note = data[i]["commentaire"][j]["note"];
    //       int date = data[i]["commentaire"][j]["date"];
    //       Commentaire commentaire = Commentaire(username, text, note, date);
    //       listCommentaire.add(commentaire);
    //     }
    //   }
    //   Wine wine = Wine(id, nom, vignoble, cepage, type, annee, image,
    //       description, noteGlobale, prix, listCommentaire);
    //   _listResultWines.add(wine);
    // }
  }
}
