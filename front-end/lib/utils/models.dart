// import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:shazam_du_vin/services/http_service.dart';

class HttpResponse {
  late String message;
  late int status;

  HttpResponse(this.message, this.status);
}

class User {
  late String _username;
  late String _password;
  late String _role;
  late VinFav _vinFav;

  User(this._username, this._password, this._role, this._vinFav);

  VinFav get vinFav => _vinFav;

  String get role => _role;

  String get username => _username;

  String get password => _password;

  set vinFav(VinFav value) {
    _vinFav = value;
  }

  set role(String value) {
    _role = value;
  }

  set password(String value) {
    _password = value;
  }

  set username(String value) {
    _username = value;
  }
}

class VinFav {
  late List<String> _value;

  VinFav(this._value);

  List<String> get value => _value;
}

class Commentaire {
  late String _username;
  late String _text;
  late num _note;
  late int _date;

  Commentaire(this._username, this._text, this._note, this._date);

  num get note => _note;

  String get text => _text;

  String get username => _username;

  int get date => _date;

  set note(num value) {
    _note = value;
  }

  set text(String value) {
    _text = value;
  }

  set userName(String value) {
    _username = value;
  }

  set date(int value) {
    _date = value;
  }
}

class Wine {
  late String _id;
  late String _nom;
  late String _vignoble;
  late String _cepage;
  late String _type;
  late String _annee;
  late String _image;
  late String _description;
  late num _noteGlobale;
  late num _price;
  late String _tauxAlcool;
  late List<Commentaire> _listCommentaire;

  Wine(
      this._id,
      this._nom,
      this._vignoble,
      this._cepage,
      this._type,
      this._annee,
      this._image,
      this._description,
      this._noteGlobale,
      this._price,
      this._tauxAlcool,
      this._listCommentaire);

  List<Commentaire> get listCommentaire => _listCommentaire;

  String get image => _image;
  
  // 获取完整的图片URL
  String getFullImageUrl() {
    if (_image.isEmpty) return '';
    if (_image.startsWith('http')) return _image;
    return '${HttpService.BASE_URL}/$_image';
  }

  String get annee => _annee;

  String get type => _type;

  String get vignoble => _vignoble;

  String get nom => _nom;

  String get description => _description;

  String get id => _id;

  String get cepage => _cepage;

  num get noteGlobale => _noteGlobale;

  num get price => _price;

  String get tauxAlcool => _tauxAlcool;

  set listCommentaire(List<Commentaire> value) {
    _listCommentaire = value;
  }

  set image(String value) {
    _image = value;
  }

  set annee(String value) {
    _annee = value;
  }

  set type(String value) {
    _type = value;
  }

  set vignoble(String value) {
    _vignoble = value;
  }

  set cepage(String value) {
    _cepage = value;
  }

  set nom(String value) {
    _nom = value;
  }

  set description(String value) {
    _description = value;
  }

  set id(String value) {
    _id = value;
  }

  set noteGlobale(num value) {
    _noteGlobale = value;
  }

  set price(num value) {
    _price = value;
  }

  set tauxAlcool(String value) {
    _tauxAlcool = value;
  }
}

// class DocumentWine {
//   final String nom;
//   final String vignoble;
//   final String type;
//   final String annee;
//   final String image;
//   final List<Commentaire> listCommentaire;
//
//   DocumentWine(this.nom, this.vignoble, this.type, this.annee, this.image,
//       this.listCommentaire);
//
//   factory DocumentWine.fromJson(Map<String, dynamic> json) {
//     return DocumentWine(
//       nom: json["nom"] as String,
//       vignoble: json["vignoble"] as String,
//       type: json["type"] as String,
//       annee: json["annee"] as String,
//       image: json['image'] as String,
//       listCommentaire: json['commentaire'] as List<Commentaire>,
//     );
//   }
// }
