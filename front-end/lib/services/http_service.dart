import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../services/var_global.dart';

class HttpService {
  // static const BASE_URL = "http://10.0.2.2:5000"; // for emulator
  static const BASE_URL = "http://localhost:5000"; // for device

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
    try {
      final res = await http.get(
        Uri.parse("$BASE_URL/User?username=$username&password=$password"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/xml"
        },
      );
      if (res.statusCode == 200) {
        print(res.body);
      } else {
        VarGlobal.TOASTMESSAGE = "username or password incorrect! ";
      }
      return res;
    } catch (e) {
      VarGlobal.TOASTMESSAGE = "Connection refused! ";
      return http.Response(e.toString(), 403);
    }
  }

  Future<http.Response> geAllWines() async {
    final res = await http.get(
      Uri.parse("$BASE_URL/Vin"),
      headers: {"Content-Type": "application/json"},
    );
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
    print("开始上传图片");
    print(imgFile);
    print(imgFile.path.split("/").last);
    
    try {
      var uri = Uri.parse("$BASE_URL/insertImg");

      var request = http.MultipartRequest("POST", uri);
      
      // 读取图片文件
      List<int> imageBytes = await imgFile.readAsBytes();
      
      // 添加到请求中
      request.files.add(http.MultipartFile.fromBytes(
          "file", imageBytes,
          filename: "Photo.jpg", contentType: MediaType("image", "jpeg")));

      // 设置请求超时
      var client = http.Client();
      try {
        var response = await request.send().timeout(const Duration(seconds: 60));
        return response;
      } finally {
        client.close();
      }
    } catch (e) {
      print("图片上传错误: $e");
      throw e;
    }
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
