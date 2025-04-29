// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'models.dart';
// import '../services/localStorage.dart';
//
// Future<Commentaire> addNewCommentInWine(
//     Wine wine, String commentText, double rating) async {
//   print("coucou");
//   print(wine.listCommentaire.length);
//   String dataCurrentUser = await readDataString("currentUser");
//   print(dataCurrentUser);
//   print(jsonDecode(jsonDecode(dataCurrentUser))[0]);
//   // print(jsonDecode(jsonDecode(dataCurrentUser))[0]["username"]);
//   print(commentText);
//   print(rating);
//   // var date = DateTime.fromMillisecondsSinceEpoch(1669942998 * 1000);
//   // print(date);
//   DateTime currentPhoneDate = DateTime.now();
//   // print(currentPhoneDate);
//   Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
//   // print(myTimeStamp.seconds);
//   // DateTime myDateTime = myTimeStamp.toDate();
//   // print("current phone data is: $currentPhoneDate");
//   // print("current phone data is: $myDateTime");
//   String username = jsonDecode(jsonDecode(dataCurrentUser))[0]["username"];
//   int date = myTimeStamp.seconds;
//   Commentaire commentaire = Commentaire(username, commentText, rating, date);
//   wine.listCommentaire.add(commentaire);
//   print(wine.listCommentaire.length);
//   return wine;
// }
