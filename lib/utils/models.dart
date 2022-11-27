// import 'dart:ffi';

import 'package:flutter/foundation.dart';

class HttpResponse {
  late String message;
  late int status;

  HttpResponse(this.message, this.status);
}

class User {
  late String _username;
  late String _role;
  late VinFav _vinFav;

  User(this._username, this._role, this._vinFav);

  VinFav get vinFav => _vinFav;

  String get role => _role;

  String get username => _username;
}

class VinFav {
  late List<dynamic> _value;

  VinFav(this._value);

  List<dynamic> get value => _value;
}

class Document {
  final String username;
  final String password;
  final VinFav vinFav;
  final String role;

  Document({
    required this.username,
    required this.password,
    required this.vinFav,
    required this.role,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      username: json["username"] as String,
      password: json["password"] as String,
      vinFav: json["vinFav"] as VinFav,
      role: json["role"] as String,
    );
  }
}
