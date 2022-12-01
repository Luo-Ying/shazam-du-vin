import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/models.dart';

Widget buildWineCard(BuildContext context, Wine wine, int index) {
  int numTop = index + 1;
  return Card(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    shadowColor: Colors.grey,
    elevation: 5,
    child: Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "$numTop",
                style: const TextStyle(
                    fontSize: 25.0, fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
        Column(
          children: [
            // Text(listAllWines[index].nom),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5.0),
              child: Container(
                width: 200.0,
                child: Text(
                  wine.nom,
                  style: const TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 5.0),
              child: Container(
                width: 200.0,
                child: Text(
                  wine.annee,
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
                  wine.image,
                  width: 80.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                )))
      ],
    ),
  );
}
