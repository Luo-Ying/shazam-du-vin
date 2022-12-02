import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/models.dart';

Widget buildUserCommentCard(BuildContext context, Commentaire commentaire) {
  return Card(
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      side: BorderSide(color: Color.fromRGBO(235, 234, 234, 1)),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 10.0, bottom: 15.0),
          child: sizeBoxOfUserNameAndRating(context, commentaire),
        ),
        buildCommentText(context, commentaire),
      ],
    ),
  );
}

Widget buildCommentText(BuildContext context, Commentaire commentaire) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 10.0, bottom: 15.0),
    child: Text(
      commentaire.text,
      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
    ),
  );
}

Widget sizeBoxOfUserNameAndRating(
    BuildContext context, Commentaire commentaire) {
  return SizedBox(
    child: Row(
      children: [
        buildUserName(context, commentaire),
        const SizedBox(width: 10.0),
        buildRatingStar(context, commentaire),
      ],
    ),
  );
}

Widget buildUserName(BuildContext context, Commentaire commentaire) {
  return Text(
    commentaire.username,
    style: const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w800,
      color: Color.fromRGBO(142, 4, 100, 1),
    ),
  );
}

Widget buildRatingStar(BuildContext context, Commentaire commentaire) {
  return Expanded(
      child: Align(
    alignment: Alignment(-1, 1),
    child: Container(
      height: 20.0,
      width: 48.0,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(249, 247, 214, 1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: buildRatingText(context, commentaire),
    ),
  ));
}

Widget buildRatingText(BuildContext context, Commentaire commentaire) {
  num note = commentaire.note;
  return Padding(
    padding: const EdgeInsets.only(left: 3.0),
    child: SizedBox(
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Color.fromRGBO(240, 164, 10, 1),
            size: 15.0,
          ),
          const SizedBox(width: 3.0),
          Text("$note")
        ],
      ),
    ),
  );
}
