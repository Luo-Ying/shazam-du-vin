import 'dart:ffi';

import 'package:flutter/foundation.dart';

class HttpResponse {
  late String message;
  late int status;

  HttpResponse(this.message, this.status);
}

class User {
  final String database = "urbanisation";
  final String collection = "User";
  final Document document;

  User({
    required this.document,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      document: json["Document"] as Document,
    );
  }
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

class VinFav {
  final List<dynamic> value;

  VinFav({
    required this.value,
  });

  factory VinFav.fromJson(Map<String, dynamic> json) {
    return VinFav(
      value: json["value"] as List<dynamic>,
    );
  }
}
