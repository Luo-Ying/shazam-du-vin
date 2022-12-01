import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils/models.dart';

class MyWinePage extends StatefulWidget {
  const MyWinePage({Key? key, required this.wine}) : super(key: key);

  final Wine wine;

  @override
  _MyWinePageState createState() {
    return _MyWinePageState(wine);
  }
}

class _MyWinePageState extends State<MyWinePage> {
  Wine wine;

  _MyWinePageState(this.wine);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppppBar(context),
        body: ListView(
          children: [
            buildTitle(),
            buildTitleLine(),
            buildImageView(context),
            buildFormWineInfos(context)
          ],
        ));
  }

  Widget buildFormWineInfos(BuildContext context) {
    return Column(
      children: [
        buildWineInfoText(context, "name : ", wine.nom),
        buildWineInfoText(context, "vineyard : ", wine.vignoble),
        buildWineInfoText(context, "vineyard : ", wine.cepage),
      ],
    );
  }

  TextStyle textStyleLabel() {
    return const TextStyle(fontSize: 18.0);
  }

  TextStyle textStyleValue() {
    return const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w800,
    );
  }

  Widget buildWineInfoText(
      BuildContext context, String labelName, String value) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Text(
            labelName,
            style: textStyleLabel(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
          child: SizedBox(
            width: 235,
            child: Text(
              value,
              style: textStyleValue(),
            ),
          ),
        )
      ],
    );
  }

  Widget buildImageView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: 450.0,
        width: 225.0,
        child: Image.network(wine.image),
      ),
    );
  }

  Widget buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
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

  Widget buildTitle() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 0.0, bottom: 8.0),
          child: Text(
            wine.nom,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  AppBar buildAppppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
