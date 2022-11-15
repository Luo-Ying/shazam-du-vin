import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/models.dart';

class HttpService {
  Future<http.Response> register(Map<String, dynamic> newUser) async {
    var url = 'http://10.0.2.2:5000/User';
    // Map<String, String> headersMap = {
    //   "content-type": "application/x-www-form-urlencoded",
    //   "User-Agent":
    //       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
    // };
    var body = json.encode(newUser);
    print(json.encode(body));
    var response = await http.post(
      Uri.parse(url),
      // url,
      headers: {"Content-Type": "application/json"},
      body: body,
      // encoding: Utf8Codec() //注：Utf8Codec()需要 import 'dart:convert';
    );
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
