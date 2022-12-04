import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shazam_du_vin/utils/models.dart';

import 'components/floatingActionButionMenu.dart';
import 'components/wineCard.dart';

class MySearchWineByImageResultPage extends StatefulWidget {
  const MySearchWineByImageResultPage({Key? key, required this.listResultWines})
      : super(key: key);

  final List<Wine> listResultWines;

  @override
  _MySearchWineByImageResultPageState createState() {
    return _MySearchWineByImageResultPageState(listResultWines);
  }
}

class _MySearchWineByImageResultPageState
    extends State<MySearchWineByImageResultPage> {
  List<Wine> listResultWines;

  _MySearchWineByImageResultPageState(this.listResultWines);

  @override
  Widget build(BuildContext context) {
    print(listResultWines);
    print(listResultWines.length);
    return Scaffold(
      appBar: buildApBar(context),
      body: Container(
        child: buildPageLayoutWidget(context),
      ),
      floatingActionButton: buildMainMenu(context),
    );
    // body: ;
  }

  Widget buildPageLayoutWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10.0),
        buildTextNotifNbResult(context),
        const SizedBox(height: 10.0),
        builListViewOfListResultWine(context),
      ],
    );
  }

  Widget buildTextNotifNbResult(BuildContext context) {
    int nbResult = listResultWines.length;
    return Text("Have $nbResult result similar");
  }

  Widget builListViewOfListResultWine(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          // height: 50,
          child: buildWineCard(
              context, listResultWines[index], index, true, false, false),
        );
      },
      itemCount: listResultWines.length,
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
                      'Result',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: buildButtonSearch(context),
                    ))
                  ],
                ),
                buildTitleLine(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtonSearch(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.search,
          color: Colors.black,
        ));
  }

  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, top: 49.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40,
          height: 2,
        ),
      ),
    );
  }
}
