import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shazam_du_vin/myAddNewWineFormPage.dart';
import 'package:shazam_du_vin/services/var_global.dart';

import './services/http_service.dart';
import '../services/localStorage.dart';
import './services/var_global.dart';
import 'components/myMainMenuFunction.dart';

class MyListVinPage extends StatefulWidget {
  const MyListVinPage({Key? key}) : super(key: key);

  @override
  State<MyListVinPage> createState() => _MyListVinPageState();
}

class _MyListVinPageState extends State<MyListVinPage> {
  late final HttpService _httpService = HttpService();

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  Future<void> initFunction() async {
    String result = await readDataString("currentUser");
    print(jsonDecode(result)[0]["role"]);
    // _httpService.geAllWines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        // constraints: const BoxConstraints.expand(),
        child: Stack(
          children: [
            buildFloatingMenuButton(context),
          ],
        ),
      ),
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
