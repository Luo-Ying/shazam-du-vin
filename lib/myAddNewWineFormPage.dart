import 'dart:convert';
import 'dart:io';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import './services/http_service.dart';
import 'components/fluttertoast.dart';
import '../utils/models.dart';

import 'services/var_global.dart';

class MyAddNewWineFormPage extends StatefulWidget {
  const MyAddNewWineFormPage({Key? key}) : super(key: key);

  @override
  State<MyAddNewWineFormPage> createState() => _MyAddNewWineFormPageState();
}

class _MyAddNewWineFormPageState extends State<MyAddNewWineFormPage> {
  late final HttpService _httpService = HttpService();

  final GlobalKey _formKey = GlobalKey<FormState>();

  var uuid = const Uuid();

  final ValueNotifier<bool> _isHaveImgFront = ValueNotifier(false);

  var _selectedImage;
  // var _imgBackPath;
  late String _nom;
  late String _vignoble;
  late String _cepage;
  late String _type;
  late String _annee;
  late String _noteGlobal;
  late String _description;

  List<Wine> _listAllWines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Stack(
              children: [
                buildTitle(),
              ],
            ),
            buildTitleLine(),
            const SizedBox(height: 10),
            // buildBoxAdd2Images(context),
            buildBoxImagePickerFront(context),
            const SizedBox(height: 40),
            buildWineNameTextField(),
            const SizedBox(height: 30),
            buildVineyardTextField(context),
            const SizedBox(height: 30),
            buildGrapvarietyTextField(context),
            const SizedBox(height: 30),
            buildWineTypeTextField(context),
            const SizedBox(height: 30),
            buildYearTextField(context),
            const SizedBox(height: 30),
            buildWineDescriptionTextField(context),
            const SizedBox(height: 40),
            buildAddWineButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> setListAllWine() async {
    _listAllWines = [];
    var res = await _httpService.geAllWines();
    // print(jsonDecode(res.body));
    // print(jsonDecode(res.body).length);
    for (var item in jsonDecode(res.body)) {
      // print(item);
      String nom = item["nom"];
      String vignoble = item["vignoble"];
      String type = item["type"];
      String annee = item["annee"];
      String image = item["image"];
      String description = item["description"];
      // print(data[i]["commentaire"][0]["userID"]);
      late List<Commentaire> listCommentaire = [];
      if (item["commentaire"].length > 0) {
        for (int j = 0; j < item["commentaire"].length; j++) {
          String userId = item["commentaire"][j]["userID"];
          // print(userId);
          String text = item["commentaire"][j]["text"];
          double note = item["commentaire"][j]["note"];
          String date = item["commentaire"][j]["date"];
          Commentaire commentaire = Commentaire(userId, text, note, date);
          listCommentaire.add(commentaire);
        }
      }
      Wine wine =
          Wine(nom, vignoble, type, annee, image, description, listCommentaire);
      _listAllWines.add(wine);
      VarGlobal.LISTALLWINES.add(wine);
    }
    // print(_listAllWine[0].description);
  }

  Widget buildAddWineButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none))),
              backgroundColor:
                  const MaterialStatePropertyAll<Color>(Colors.black)),
          child:
              Text('Add', style: Theme.of(context).primaryTextTheme.headline5),
          onPressed: () async {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              print("Name : $_nom");
              print("Vignoble : $_vignoble");
              print("Ceppage : $_cepage");
              print("Type : $_type");
              print("Annee : $_annee");
              print("Description : $_description");
              print("Image : $_selectedImage");
              var id = uuid.v4();
              print(id);
              // Image imgFile = Image.file(File(_selectedImage!.path));
              print(_selectedImage.path.runtimeType);
              File imgFile = File(_selectedImage.path);
              var res = await _httpService.insertImage(imgFile);
              if (res.statusCode == 200) {
                res.stream.transform(utf8.decoder).listen((value) {
                  print(value);
                  var newWine = {
                    "database": "urbanisation",
                    "collection": "Vin",
                    "data": {
                      "nom": _nom,
                      "vignoble": _vignoble,
                      "cepage": _cepage,
                      "type": _type,
                      "annee": _annee,
                      "image": value,
                      "commentaire": [],
                      "description": _description
                    }
                  };
                  _httpService.addNewWine(newWine);
                  (_formKey.currentState as FormState).reset();
                  _isHaveImgFront.value = false;
                  Fluttertoast.showToast(
                    msg: VarGlobal.TOASTMESSAGE,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.black45,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  Navigator.pop(context, _listAllWines);
                });
              }
            }
          },
        ),
      ),
    );
  }

  Widget buildWineDescriptionTextField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(labelText: 'Description'),
      onSaved: (v) => _description = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine description!';
        }
      },
    );
  }

  Widget buildYearTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Year'),
      onSaved: (v) => _annee = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine year!';
        }
      },
    );
  }

  Widget buildWineTypeTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Type'),
      onSaved: (v) => _type = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine type!';
        }
      },
    );
  }

  Widget buildGrapvarietyTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Grap variety'),
      onSaved: (v) => _cepage = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the grap variety!';
        }
      },
    );
  }

  Widget buildVineyardTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Vineyard'),
      onSaved: (v) => _vignoble = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the vineyard!';
        }
      },
    );
  }

  Widget buildWineNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Wine name'),
      onSaved: (v) => _nom = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine name!';
        }
      },
    );
  }

  Widget buildBoxImagePickerFront(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 30.0),
            Align(
              child: Container(
                width: 230.0,
                height: 300.0,
                // color: const Color.fromRGBO(220, 220, 220, 1),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color.fromRGBO(196, 196, 196, 1)),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ValueListenableBuilder(
                      valueListenable: _isHaveImgFront,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return Container(
                          child: _selectedImage == null
                              ? buildButtonToAddImgFront(context)
                              : buildShowImageFrontReview(context),
                        );
                      }),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildShowImageFrontReview(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image(image: XFileImage(_selectedImage)),
        ),
        Align(
          alignment: const Alignment(0, 0.9),
          child: SizedBox(
            height: 25.0,
            child: ElevatedButton(
              onPressed: () {
                _selectedImage = null;
                _isHaveImgFront.value = false;
                print(_selectedImage);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(135, 135, 135, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ))),
              child: const Icon(Icons.delete),
            ),
          ),
        )
      ],
    );
  }

  // TODO: ajouter un modal de notification pour demander utilisateur s'il veut vraiment suprimer la photo!

  Widget buildButtonToAddImgFront(BuildContext context) {
    return SizedBox(
        width: 100.0,
        height: 35.0,
        child: ElevatedButton(
          onPressed: () {
            // _isSetImgFront = true;
            // _isSetImgBack = false;
            _showBasicModalBottomSheet(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
          ),
          child: const Text(
            "Add a image",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: Color.fromRGBO(111, 111, 111, 1),
              fontWeight: FontWeight.w700,
            ),
          ),
        ));
  }

  Future<Future<int?>> _showBasicModalBottomSheet(context) async {
    late List<String> options = ["take a photo", "select a photo from album"];
    return showModalBottomSheet<int>(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 100.0,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    print(index);
                    if (index == 0) {
                      _selectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      _isHaveImgFront.value = true;
                    } else if (index == 1) {
                      _selectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      _isHaveImgFront.value = true;
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    options[index],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
            itemCount: options.length,
          ),
        );
      },
    );
  }

  Widget buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40,
          height: 2,
        ),
      ),
    );
  }

  Widget buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 1.0, top: 0.0, bottom: 8.0),
      child: Text(
        'Add new Wines',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
