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

  final GlobalKey _formKey = GlobalKey<FormState>();

  String _comment = "";

  ValueNotifier<bool> _isValid = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppppBar(context),
        body: ListView(
          children: [
            buildTitle(),
            buildTitleLine(),
            buildImageView(context),
            buildFormWineInfo(context),
            buildLabel(context, "description : "),
            buildValue(context, wine.description),
            buildLineSeparate(context),
            const SizedBox(height: 50.0),
            buildUserComment(context),
          ],
        ));
  }

  Widget buildUserComment(BuildContext context) {
    return Column(
      children: [
        buildCommentTitle(context),
        const SizedBox(height: 5.0),
        buildLineSeparate(context),
        const SizedBox(height: 20.0),
        // buildAddCommentField(context),
        buildButtonAddComment(context)
      ],
    );
  }

  Widget buildAddCommentField(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Stack(
                  children: [
                    buildCommentForm(context),
                  ],
                )),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       top: 24.0,
            //       left: 16.0,
            //       right: 16.0,
            //       bottom: 30.0),
            //   child: Row(
            //     children: [
            //       buildButtonAnnuler(context),
            //       buildButtonSuivant(context),
            //     ],
            //   ),
            // )
          ],
        ));
  }

  Widget buildCommentTextField(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: "Comment ... ",
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(60.0),
            borderSide: BorderSide(
              color: Color.fromRGBO(140, 142, 173, 1),
              width: 1.0,
            ),
          ),
        ),
        onSaved: (v) => _comment = v!,
        validator: (v) {
          if (v!.isEmpty) {
            _isValid.value = false;
            return "Comment can't be empty!";
          } else {
            _isValid.value = true;
          }
        },
      ),
    );
  }

  Widget buildIconSend(BuildContext context) {
    return SizedBox(
      width: 350,
      child: ElevatedButton(
        onPressed: () {},
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)),
        child: const Text(
          "send",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Widget buildCommentForm(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Column(
          children: [
            // const SizedBox(width: 16.0),
            buildCommentTextField(context),
            buildIconSend(context)
          ],
        )
      ],
    );
  }

  Future<Future<int?>> _showBasicModalBottomSheet(context) async {
    late List<String> options = ["take a photo", "select a photo from album"];
    return showModalBottomSheet<int>(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 600,
          child: buildCommentForm(context),
        );
      },
    );
  }

  Widget buildButtonAddComment(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _showBasicModalBottomSheet(context);
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)),
        child: Text("Add comment"));
  }

  Widget buildCommentTitle(BuildContext context) {
    return const Align(
      child: Text(
        "Community reviews",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget buildLineSeparate(BuildContext context) {
    return Container(
      width: 1000.0,
      height: 0.5,
      color: const Color.fromRGBO(234, 224, 218, 1),
    );
  }

  // Widget buildFormWineInfoValues(BuildContext context) {
  //   return Column(
  //     children: [
  //       buildWineInfoText(context, "name : ", wine.nom),
  //       buildWineInfoText(context, "vineyard : ", wine.vignoble),
  //       buildWineInfoText(context, "grape variety : ", wine.cepage),
  //       buildWineInfoText(context, "type : ", wine.type),
  //       buildWineInfoText(context, "year : ", wine.annee),
  //       buildWineInfoText(context, "description : ", wine.description),
  //     ],
  //   );
  // }

  Widget buildFormWineInfo(BuildContext context) {
    return Column(
      children: [
        buildWineInfoText(context, "name : ", wine.nom),
        buildLineSeparate(context),
        buildWineInfoText(context, "vineyard : ", wine.vignoble),
        buildLineSeparate(context),
        buildWineInfoText(context, "grape variety : ", wine.cepage),
        buildLineSeparate(context),
        buildWineInfoText(context, "type : ", wine.type),
        buildLineSeparate(context),
        buildWineInfoText(context, "year : ", wine.annee),
        buildLineSeparate(context),
      ],
    );
  }

  TextStyle textStyleLabel() {
    return const TextStyle(
      fontSize: 18.0,
      color: Color.fromRGBO(217, 192, 159, 1),
    );
  }

  TextStyle textStyleValue() {
    return const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w800,
    );
  }

  Widget buildLabel(BuildContext context, String labelName) {
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                labelName,
                style: textStyleLabel(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildValue(BuildContext context, String value) {
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 8.0, bottom: 5.0),
              child: SizedBox(
                width: 300,
                child: Text(
                  value,
                  style: textStyleValue(),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildWineInfoText(
      BuildContext context, String labelName, String value) {
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 5.0),
              child: Text(
                labelName,
                style: textStyleLabel(),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 20.0, right: 8.0, bottom: 5.0),
              child: SizedBox(
                width: 150,
                child: Text(
                  value,
                  style: textStyleValue(),
                ),
              ),
            )
          ],
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
