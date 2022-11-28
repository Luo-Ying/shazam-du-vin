import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './services/http_service.dart';
import 'components/myMainMenuFunction.dart';

class MyListVinPage extends StatefulWidget {
  const MyListVinPage({Key? key}) : super(key: key);

  @override
  State<MyListVinPage> createState() => _MyListVinPageState();
}

class _MyListVinPageState extends State<MyListVinPage> {
  late final HttpService _httpService = HttpService();

  // @override
  // void initState() {
  //   _httpService.geAllWines();
  // }

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
                    buildAddWineButtonAdmin(context)
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
    return Expanded(
        child: Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 28,
        width: 150,
        child: ElevatedButton(
          onPressed: () {},
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
      ),
    ));
  }
}
