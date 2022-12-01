import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shazam_du_vin/myAddNewWineFormPage.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import './services/http_service.dart';
import '../services/localStorage.dart';
import './services/var_global.dart';
import 'components/flutingActionButionMenu.dart';

import 'utils/models.dart';

class MyListVinPage extends StatefulWidget {
  const MyListVinPage({Key? key, required this.listAllWines}) : super(key: key);

  final List<Wine> listAllWines;

  @override
  _MyListVinPageState createState() {
    // print(' createState $arguments');
    return _MyListVinPageState(listAllWines);
  }
}

class _MyListVinPageState extends State<MyListVinPage> {
  List<Wine> listAllWines;

  _MyListVinPageState(this.listAllWines);

  late final HttpService _httpService = HttpService();

  Uint8List targetlUinit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
  Uint8List originalUnit8List = Uint8List.fromList([0, 2, 5, 7, 42, 255]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        child: builListViewOfListAllWine(context),
      ),
      floatingActionButton: buildMainMenu(context),
    );
  }

  // void _resizeImage() async {
  //   String imageUrl = 'https://picsum.photos/250?image=9';
  //   var response = _httpService.getImg(imageUrl);
  //   originalUnit8List = response.bodyBytes;
  //
  //   ui.Image originalUiImage = await decodeImageFromList(originalUnit8List);
  //   ByteData originalByteData = await originalUiImage.toByteData();
  //   print('original image ByteData size is ${originalByteData.lengthInBytes}');
  //
  //   var codec = await ui.instantiateImageCodec(originalUnit8List,
  //       targetHeight: 50, targetWidth: 50);
  //   var frameInfo = await codec.getNextFrame();
  //   ui.Image targetUiImage = frameInfo.image;
  //
  //   ByteData targetByteData =
  //       await targetUiImage.toByteData(format: ui.ImageByteFormat.png);
  //   print('target image ByteData size is ${targetByteData.lengthInBytes}');
  //   targetlUinit8List = targetByteData.buffer.asUint8List();
  //
  //   setState(() {});
  // }

  Widget buildWineCard(BuildContext context, int index) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      shadowColor: Colors.grey,
      elevation: 5,
      child: Row(
        children: [
          Column(
            children: [
              // Text(listAllWines[index].nom),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                child: Container(
                  width: 258.0,
                  child: Text(
                    listAllWines[index].nom,
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 5.0),
                child: Container(
                  width: 258.0,
                  child: Text(
                    listAllWines[index].annee,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.network(
                    listAllWines[index].image,
                    width: 80.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  )))
        ],
      ),
    );
  }

  Widget builListViewOfListAllWine(BuildContext context) {
    print("list alla wines: $listAllWines");
    print("var global list:  $VarGlobal.LISTALLWINES");
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          // height: 50,
          child: buildWineCard(context, index),
        );
      },
      itemCount: listAllWines.length,
    );
  }

  PreferredSize buildApBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Column(
        children: [
          const SizedBox(
            height: 44.0,
          ),
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            elevation: 0,
            title: Stack(
              children: [
                Row(
                  children: [
                    const Text(
                      'All wines',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: Offstage(
                        offstage: VarGlobal.CURRENTUSERROLE == "user",
                        child: buildAddWineButtonAdmin(context),
                      ),
                    ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddWineButtonAdmin(BuildContext context) {
    return SizedBox(
      height: 28,
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyAddNewWineFormPage(),
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: Stack(
          children: [
            Row(
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: Icon(Icons.add),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("add new wine"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
