import 'dart:convert';
import 'dart:io';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shazam_du_vin/mySearchWineByImageResultPage.dart';
import 'package:shazam_du_vin/services/http_service.dart';
import 'package:shazam_du_vin/services/var_global.dart';
import 'package:shazam_du_vin/services/winesActions.dart';
import 'package:shazam_du_vin/utils/models.dart';

import 'components/fluttertoast.dart';

class MyImagePickerWidget extends StatefulWidget {
  final XFile imageSelected;

  const MyImagePickerWidget({
    super.key,
    required this.imageSelected,
  });

  @override
  State<MyImagePickerWidget> createState() => _MyImagePickerWidgetState();
}

class _MyImagePickerWidgetState extends State<MyImagePickerWidget> {
  late XFile imageSelected;

  @override
  void initState() {
    super.initState();
    imageSelected = widget.imageSelected;
  }

  late final HttpService _httpService = HttpService();

  List<Wine> _listResultWines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApppBar(context),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
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
              shadowColor: const WidgetStatePropertyAll<Color>(
                  Color.fromRGBO(91, 98, 205, 1)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0))),
              backgroundColor:
                  const WidgetStatePropertyAll<Color>(Colors.grey)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          )),
    );
  }

  Future<void> _searchWineByImage() async {
    File imgFile = File(imageSelected.path);
    var res = await _httpService.searchWinesByImage(imgFile);
    if (res.statusCode == 200) {
      res.stream.transform(utf8.decoder).listen((value) async {
        await _getListResultWines(value);
        await Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return MySearchWineByImageResultPage(
              listResultWines: _listResultWines);
        }));
      });
    } else {
      print(">>>>>>>>");
      res.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        Fluttertoast.showToast(
          msg: value,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }
  }

  Widget buildButtonSearch(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 40.0,
      child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: const WidgetStatePropertyAll<Color>(
                  Color.fromRGBO(91, 98, 205, 1)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0))),
              backgroundColor: const WidgetStatePropertyAll<Color>(
                  Color.fromRGBO(91, 98, 205, 1))),
          onPressed: () {
            _searchWineByImage();
          },
          child: const Text(
            "Search",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          )),
    );
  }

  Widget buildButtonsWidget(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Positioned(
        bottom: 0,
        child: Padding(
          padding: EdgeInsets.only(
            left: (widthScreen - 230) / 2,
            // top: (heightScreen - 150 + VarGlobal.heightBottomNavigationBar),
            bottom: VarGlobal.heightBottomNavigationBar + 15,
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
        ));
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
  }
}
