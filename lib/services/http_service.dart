import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utils/models.dart';
import '../services/var_global.dart';
import './localStorage.dart';

class HttpService {
  static const BASE_URL = "http://10.0.2.2:5000"; // for emulator

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

  Future<http.Response> connexion(String username, String password) async {
    // var body = json.encode(request);
    final res = await http.get(
      Uri.parse("$BASE_URL/User?username=$username&password=$password"),
      headers: {"Content-Type": "application/json"},
      // body: body,
    );
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);
      print(responseJson[0]);
      // late VinFav user_vinFav = VinFav(responseJson[0]["vinFav"]["value"]);
      // VarGlobal.USERCURRENT = User(
      //     responseJson[0]["username"], responseJson[0]["role"], user_vinFav);
      print(res.body.runtimeType);
      saveDataString("currentUser", res.body);
    }
    // print(response.body.runtimeType);
    // print(responseJson);
    // return profil.fromJson(responseJson);
    return res;
  }

  Future<http.Response> geAllWines() async {
    final res = await http.get(
      Uri.parse("$BASE_URL/Vin"),
      headers: {"Content-Type": "application/json"},
    );
    print(res.body);
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
}
