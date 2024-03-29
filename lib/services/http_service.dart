import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/models.dart';
import '../services/var_global.dart';
import './localStorage.dart';

class HttpService {
  // static const BASE_URL = "http://10.0.2.2:5000"; // for emulator
  static const BASE_URL =
      "https://flask-service.v5jn6j0vmbe7s.eu-west-3.cs.amazonlightsail.com/";

  Future<http.Response> register(Map<String, dynamic> newUser) async {
    var body = json.encode(newUser);
    print(json.encode(body));
    var res = await http.post(
      Uri.parse("$BASE_URL/User"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (res.statusCode == 200) {
      VarGlobal.TOASTMESSAGE = "register successfully!";
    } else {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Error"];
    }
    return res;
  }

  Future<http.Response> connexion(String username, String password) async {
    final res = await http.get(
      Uri.parse("$BASE_URL/User?username=$username&password=$password"),
      // headers: {"Content-Type": "application/json"},
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/xml"
      },
    );
    // print(res.body);
    if (res.statusCode == 200) {
      // final responseJson = jsonDecode(res.body);
      // print(res.body);
      saveDataString("currentUser", res.body);
    } else {
      // VarGlobal.TOASTMESSAGE = "username or password not correctly!";
      VarGlobal.TOASTMESSAGE = "username or password incorrect! ";
    }
    return res;
    // TODO: les cas d'érreurs quand utilisateur entre les mauvais username ou password
  }

  Future<http.Response> geAllWines() async {
    final res = await http.get(
      Uri.parse("$BASE_URL/Vin"),
      headers: {"Content-Type": "application/json"},
    );
    // print(res.body);
    return res;
  }

  Future<http.Response> getTopWines() async {
    final res = await http.get(
      Uri.parse("$BASE_URL/top"),
      headers: {"Content-Type": "application/json"},
    );
    print(res.body);
    return res;
  }

  Future<http.Response> getFavorisWines(String username) async {
    print("username??????????? $username");
    final res = await http.get(
      Uri.parse("$BASE_URL/favVin?username=$username"),
      headers: {"Content-Type": "application/json"},
    );
    print("nique ta mère?????????");
    print(res.statusCode);
    print(res.body);
    return res;
  }

  Future<http.StreamedResponse> searchWinesByImage(File imgFile) async {
    print("coucou?");
    print(imgFile);
    print(imgFile.path.split("/").last);
    var uri = Uri.parse("$BASE_URL/ocr");

    var request = http.MultipartRequest("POST", uri);
    request.files.add(http.MultipartFile.fromBytes(
        "file", imgFile.readAsBytesSync(),
        filename: "Photo.jpg", contentType: MediaType("image", "png")));

    var response = await request.send();
    // print(response.statusCode);
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    return response;
  }

  Future<void> addOrRemoveFavorisWine(
      Map<String, dynamic> userDataUpdated) async {
    var body = jsonEncode(userDataUpdated);
    print(body);
    var res = await http.put(
      Uri.parse("$BASE_URL/User"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    print(res.statusCode);
    print(res.body);
    // return res;
    if (res.statusCode == 200) {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Status"];
    } else {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Error"];
    }
  }

  Future<http.Response> getImg(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    return response;
  }

  Future<http.StreamedResponse> insertImage(File imgFile) async {
    print("coucou?");
    print(imgFile);
    print(imgFile.path.split("/").last);
    var uri = Uri.parse("$BASE_URL/insertImg");

    var request = http.MultipartRequest("POST", uri);
    request.files.add(http.MultipartFile.fromBytes(
        "file", imgFile.readAsBytesSync(),
        filename: "Photo.jpg", contentType: MediaType("image", "png")));

    var response = await request.send();
    // print(response.statusCode);
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    return response;
  }

  Future<http.Response> addNewWine(Map<String, dynamic> newWine) async {
    print(newWine);
    var body = json.encode(newWine);
    print(json.encode(body));
    var res = await http.post(
      Uri.parse("$BASE_URL/Vin"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Status"];
    } else {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Error"];
    }
    return res;
  }

  Future<http.Response> deleteWine(Map<String, dynamic> wineSelected) async {
    print(wineSelected);
    var body = jsonEncode(wineSelected);
    print(body);
    var res = await http.delete(
      Uri.parse("$BASE_URL/Vin"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Status"];
    } else {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Error"];
    }
    return res;
  }

  Future<http.Response> updateWine(Map<String, dynamic> newWine) async {
    var body = jsonEncode(newWine);
    print(body);
    var res = await http.put(
      Uri.parse("$BASE_URL/Vin"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    print(res.statusCode);
    print(res.body);
    return res;
  }

  Future<http.Response> addOrDeleteComment(Map<String, dynamic> newWine) async {
    var res = await updateWine(newWine);
    if (res.statusCode == 200) {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Status"];
    } else {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Error"];
    }
    return res;
  }

  Future<http.Response> modifWine(Map<String, dynamic> newWine) async {
    var res = await updateWine(newWine);
    if (res.statusCode == 200) {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Status"];
    } else {
      VarGlobal.TOASTMESSAGE = jsonDecode(res.body)["Error"];
    }
    return res;
  }

  Future<http.Response> getWineById(String id) async {
    var response = await http.get(Uri.parse("$BASE_URL/Vin?$id"));
    return response;
  }
}
