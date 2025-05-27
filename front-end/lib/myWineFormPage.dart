import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shazam_du_vin/myListWinePage.dart';
import 'package:shazam_du_vin/services/winesActions.dart';
import 'package:shazam_du_vin/utils/eventBus.dart';
import 'package:uuid/uuid.dart';

import './services/http_service.dart';
import 'components/fluttertoast.dart';
import '../utils/models.dart';

import 'services/var_global.dart';

class MyWineFormPage extends StatefulWidget {
  final Wine wineSelected;
  final bool isModif;

  const MyWineFormPage({
    super.key,
    required this.wineSelected,
    required this.isModif,
  });

  @override
  State<MyWineFormPage> createState() => _MyWineFormPageState();
}

class _MyWineFormPageState extends State<MyWineFormPage> {
  late bool isModif;
  late Wine wineSelected;

  @override
  void initState() {
    super.initState();
    isModif = widget.isModif;
    wineSelected = widget.wineSelected;
  }

  late final HttpService _httpService = HttpService();

  final GlobalKey _formKey = GlobalKey<FormState>();

  var uuid = const Uuid();

  final ValueNotifier<bool> _isHaveImgFront = ValueNotifier(false);

  String imagePath = "";

  var _selectedImage;
  late String _nom;
  late String _vignoble;
  late String _cepage;
  late String _type;
  late String _annee;
  late String _noteGlobal;
  late String _tauxAlcool;
  late String _price;
  late String _description;

  List<Wine> _listAllWines = [];

  void goBackPagePreviews() {
    Navigator.pop(context);
  }

  Future<void> goPageListAllWines() async {
    await setListAllWine();
    print("list alla wines: $_listAllWines");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return MyListVinPage(
          listAllWines: _listAllWines,
        );
      },
    ));
  }

  Future<void> setListAllWine() async {
    _listAllWines = [];
    var res = await _httpService.geAllWines();
    WineActions.setListWine(1, jsonDecode(res.body));
    _listAllWines = WineActions.listAllWines;
  }

  @override
  Widget build(BuildContext context) {
    print("isModif ? $isModif");
    print("wine selected : $wineSelected");
    imagePath = wineSelected.image;
    imagePath != ""
        ? _isHaveImgFront.value = true
        : _isHaveImgFront.value = false;
    print(imagePath);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            isModif ? goBackPagePreviews() : goPageListAllWines();
          },
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  buildTitle(),
                ],
              ),
              buildTitleLine(),
              const SizedBox(height: 10),
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
              buildAlcoolPercentTextField(context),
              const SizedBox(height: 30),
              buildPriceTextField(context),
              const SizedBox(height: 30),
              buildWineDescriptionTextField(context),
              const SizedBox(height: 40),
              buildAddWineButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPriceTextField(BuildContext context) {
    return TextFormField(
      initialValue:
          wineSelected.price != 0 ? wineSelected.price.toString() : "",
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Price'),
      onChanged: (value) => setState(() => _price = value),
      onSaved: (v) => _price = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine price!';
        }
        return null;
      },
    );
  }

  Widget buildAlcoolPercentTextField(BuildContext context) {
    return TextFormField(
      initialValue: wineSelected.tauxAlcool,
      decoration: const InputDecoration(labelText: 'Alcool percent'),
      onChanged: (value) => setState(() => _tauxAlcool = value),
      onSaved: (v) => _tauxAlcool = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the alcool percent of!';
        }
        return null;
      },
    );
  }

  Widget buildAddWineButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: Align(
        child: SizedBox(
          height: 45,
          width: 270,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all(const StadiumBorder(
                    side: BorderSide(style: BorderStyle.none))),
                backgroundColor:
                    const WidgetStatePropertyAll<Color>(Colors.black)),
            child: Text(isModif ? 'Confirm' : 'Add',
                style: Theme.of(context).primaryTextTheme.headlineSmall),
            onPressed: () async {
              isModif ? updateModifWine() : addNewWine();
            },
          ),
        ),
      ),
    );
  }

  Widget buildWineDescriptionTextField(BuildContext context) {
    return TextFormField(
      initialValue: wineSelected.description,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(labelText: 'Description'),
      onChanged: (value) => setState(() => _description = value),
      onSaved: (v) => _description = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine description!';
        }
        return null;
      },
    );
  }

  Widget buildYearTextField(BuildContext context) {
    return TextFormField(
      initialValue: wineSelected.annee,
      decoration: const InputDecoration(labelText: 'Year'),
      onChanged: (value) => setState(() => _annee = value),
      onSaved: (v) => _annee = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine year!';
        }
        return null;
      },
    );
  }

  Widget buildWineTypeTextField(BuildContext context) {
    return TextFormField(
      initialValue: wineSelected.type,
      decoration: const InputDecoration(labelText: 'Type'),
      onChanged: (value) => setState(() => _type = value),
      onSaved: (v) => _type = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine type!';
        }
        return null;
      },
    );
  }

  Widget buildGrapvarietyTextField(BuildContext context) {
    return TextFormField(
      initialValue: wineSelected.cepage,
      decoration: const InputDecoration(labelText: 'Grap variety'),
      onChanged: (value) => setState(() => _cepage = value),
      onSaved: (v) => _cepage = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the grap variety!';
        }
        return null;
      },
    );
  }

  Widget buildVineyardTextField(BuildContext context) {
    return TextFormField(
      initialValue: wineSelected.vignoble,
      decoration: const InputDecoration(labelText: 'Vineyard'),
      onChanged: (value) => setState(() => _vignoble = value),
      onSaved: (v) => _vignoble = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the vineyard!';
        }
        return null;
      },
    );
  }

  Widget buildWineNameTextField() {
    return TextFormField(
      initialValue: wineSelected.nom,
      decoration: const InputDecoration(labelText: 'Wine name'),
      onChanged: (value) => setState(() => _nom = value),
      onSaved: (v) => _nom = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter the wine name!';
        }
        return null;
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
                          child: imagePath != "" || _selectedImage != null
                              ? buildShowImageFrontReview(context)
                              : buildButtonToAddImgFront(context),
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
          child: _selectedImage == null
              ? Image.network(wineSelected.image)
              : Image(image: XFileImage(_selectedImage)),
        ),
        Align(
          alignment: const Alignment(0, 0.9),
          child: SizedBox(
            height: 25.0,
            child: ElevatedButton(
              onPressed: () {
                _selectedImage = null;
                _isHaveImgFront.value = false;
                imagePath = "";
                print(imagePath);
                print(_selectedImage);
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color.fromRGBO(135, 135, 135, 1)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, top: 0.0, bottom: 8.0),
      child: Text(
        isModif ? wineSelected.nom : 'Add new Wines',
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> addNewWine() async {
    if ((_formKey.currentState as FormState).validate()) {
      (_formKey.currentState as FormState).save();
      print(_selectedImage.path.runtimeType);
      File imgFile = File(_selectedImage.path);
      var res = await _httpService.insertImage(imgFile);
      if (res.statusCode == 200) {
        var id = uuid.v4();
        print(id);
        res.stream.transform(utf8.decoder).listen((value) async {
          print(value);
          var newWine = {
            "database": "urbanisation",
            "collection": "Vin",
            "data": {
              "id": id,
              "nom": _nom,
              "vignoble": _vignoble,
              "cepage": _cepage,
              "type": _type,
              "annee": _annee,
              "image": value,
              "tauxAlcool": _tauxAlcool,
              "description": _description,
              "prix": num.parse(_price),
              "noteGlobale": -1,
              "commentaire": [],
            }
          };
          var res = await _httpService.addNewWine(newWine);
          if (res.statusCode == 200) {
            (_formKey.currentState as FormState).reset();
            _selectedImage = null;
            _isHaveImgFront.value = false;
            FocusScope.of(context).requestFocus(FocusNode());
            Fluttertoast.showToast(
              msg: VarGlobal.TOASTMESSAGE,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            eventBus.emit("addNewWine");
          }
        });
      }
    }
  }

  Future<void> updateModifWine() async {
    if ((_formKey.currentState as FormState).validate()) {
      (_formKey.currentState as FormState).save();
      print("Name : $_nom");
      print("Vignoble : $_vignoble");
      print("Ceppage : $_cepage");
      print("Type : $_type");
      print("Annee : $_annee");
      print("Description : $_description");
      print("Image : $_selectedImage");
      String imgFilePath = "";
      if (_selectedImage != null) {
        File imgFile = File(_selectedImage.path);
        var resImage = await _httpService.insertImage(imgFile);
        if (resImage.statusCode == 200) {
          resImage.stream.transform(utf8.decoder).listen((value) async {
            print(value);
            imgFilePath = value;
          });
        }
      } else {
        imgFilePath = wineSelected.image;
      }
      print(imgFilePath);
      var newWineFormated = {
        "id": wineSelected.id,
        "nom": _nom,
        "vignoble": _vignoble,
        "cepage": _cepage,
        "type": _type,
        "annee": _annee,
        "image": imgFilePath,
        "tauxAlcool": _tauxAlcool,
        "description": _description,
        "prix": num.parse(_price),
        "commentaire": [
          for (var item in wineSelected.listCommentaire)
            {
              "username": item.username,
              "text": item.text,
              "note": item.note,
              "date": item.date
            },
        ]
      };
      print(newWineFormated);
      var res = await _httpService.modifWine(newWineFormated);
      if (res.statusCode == 200) {
        wineSelected.nom = _nom;
        wineSelected.vignoble = _vignoble;
        wineSelected.cepage = _cepage;
        wineSelected.type = _type;
        wineSelected.annee = _annee;
        wineSelected.image = imagePath;
        wineSelected.tauxAlcool = _tauxAlcool;
        wineSelected.price = num.parse(_price);
        wineSelected.description = _description;
        WineActions.updatedWine = wineSelected;
        print(WineActions.updatedWine);
        eventBus.emit("modifedWine");
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: VarGlobal.TOASTMESSAGE,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }
}
