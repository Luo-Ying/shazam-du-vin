import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shazam_du_vin/services/localStorage.dart';

import 'services/http_service.dart';
import 'utils/algorithme.dart';

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

  late final HttpService _httpService = HttpService();

  String _commentText = "";
  double _saveRating = 0;

  ValueNotifier<bool> _isValid = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
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
        buildButtonAddComment(context),
        buildTextNoComment(context),
        wine.listCommentaire.isNotEmpty
            ? buildListUserComment(context)
            : Container(),
      ],
    );
  }

  Widget buildTextNoComment(BuildContext context) {
    int nbComment = wine.listCommentaire.length;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
      child: SizedBox(child: Text("Have $nbComment comment")),
    );
  }

  Widget buildListUserComment(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          // height: 50,
          child: buildUserCommentCard(context, wine.listCommentaire[index]),
        );
      },
      itemCount: wine.listCommentaire.length,
    );
  }

  Widget buildUserCommentCard(BuildContext context, Commentaire commentaire) {
    return Card();
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
        onSaved: (v) => _commentText = v!,
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

  Widget buildButtonSendActive(BuildContext context) {
    return SizedBox(
      width: 350,
      child: ElevatedButton(
        onPressed: () async {
          if ((_formKey.currentState as FormState).validate()) {
            (_formKey.currentState as FormState).save();
            print(_commentText);
            print(_saveRating);
            print(wine);
            // Wine newWine =
            //     await addNewCommentInWine(wine, _commentText, _saveRating);
            // print(newWine.listCommentaire.length);
            String dataCurrentUser = await readDataString("currentUser");
            // DateTime currentPhoneDate = DateTime.now();
            // Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
            int myTimeStamp = DateTime.now().millisecondsSinceEpoch;
            print(myTimeStamp);
            var newWineFormated = {
              "id": wine.id,
              "nom": wine.nom,
              "vignoble": wine.vignoble,
              "cepage": wine.cepage,
              "type": wine.type,
              "annee": wine.annee,
              "image": wine.image,
              "description": wine.description,
              "commentaire": [
                for (var item in wine.listCommentaire)
                  {
                    "username": item.username,
                    "text": item.text,
                    "note": item.note,
                    "date": item.date
                  },
                {
                  "username": jsonDecode(jsonDecode(dataCurrentUser))[0]
                      ["username"],
                  "text": _commentText,
                  "note": _saveRating,
                  "date": myTimeStamp
                }
              ]
            };
            try {
              var res = await _httpService.addComment(newWineFormated);
              print(res.statusCode);
              print(res.body);
              if (res.statusCode == 200) {
                // TODO: ajouter fonction pour afficher qqch quand utilisateur réussis de ajouter un commentaire.
              }
            } catch (e) {
              print("Exception Happened: ${e.toString()}");
            }
            // print(jsonEncode(newWineFormated));
          }
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)),
        child: const Text(
          "Send",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Widget buildButtonSendDisabled(BuildContext context) {
    return const SizedBox(
      width: 350,
      child: ElevatedButton(
        onPressed: null,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(
                Color.fromRGBO(123, 123, 123, 1))),
        child: Text(
          "Send",
          style: TextStyle(
              fontSize: 20.0, color: Color.fromRGBO(172, 172, 173, 1)),
        ),
      ),
    );
  }

  Widget buildButtonSend(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Align(
          alignment: Alignment.center,
          child: ValueListenableBuilder(
              valueListenable: _isValid,
              builder: (BuildContext context, bool value, Widget? child) {
                return _isValid.value
                    ? buildButtonSendActive(context)
                    : buildButtonSendDisabled(context);
              }),
        ))
      ],
    );
  }

  Widget buildStarRating(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
      child: RatingBar(
        maxRating: 5,
        initialRating: 0.5,
        allowHalfRating: true,
        ratingWidget: RatingWidget(
          full: const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: const Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: const Icon(
            Icons.star_border,
            color: Colors.grey,
          ),
        ),
        onRatingUpdate: (double value) {
          setState(() {
            _saveRating = value;
          });
          print(_saveRating);
        },
      ),
    );
  }

  Widget buildCommentForm(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Column(
              children: [
                // const SizedBox(width: 16.0),
                buildCommentTextField(context),
                buildStarRating(context),
                buildButtonSend(context)
              ],
            )
          ],
        ));
  }

  Future<int?> _showBasicModalBottomSheet(context) {
    // TODO: améliorer: monter le champ de form add comment quand utilisateur active le clavier
    return showModalBottomSheet<int>(
      // isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
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
