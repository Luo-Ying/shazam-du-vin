import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utils/models.dart';
import '../services/var_global.dart';

class HttpService {
  static const BASE_URL = "http://10.0.2.2:5000";

  Future<http.Response> register(Map<String, dynamic> newUser) async {
    // Map<String, String> headersMap = {
    //   "content-type": "application/x-www-form-urlencoded",
    //   "User-Agent":
    //       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
    // };
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

  Future<void> connexion(Map<String, dynamic> request) async {
    var body = json.encode(request);
    final response = await http.post(
      Uri.parse("$BASE_URL/getUser"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print(responseJson[0]);
      late VinFav user_vinFav = VinFav(responseJson[0]["vinFav"]["value"]);
      VarGlobal.USERCURRENT = User(
          responseJson[0]["username"], responseJson[0]["role"], user_vinFav);
    }
    // print(response.body.runtimeType);
    // print(responseJson);
    // return profil.fromJson(responseJson);
  }
}
