import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyAddNewWineFormPage extends StatefulWidget {
  const MyAddNewWineFormPage({Key? key}) : super(key: key);

  @override
  State<MyAddNewWineFormPage> createState() => _MyAddNewWineFormPageState();
}

class _MyAddNewWineFormPageState extends State<MyAddNewWineFormPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  late bool _isSetImgFront = false;
  late bool _isSetImgBack = false;

  var _imgFrontPath;
  var _imgBackPath;

  final ValueNotifier<bool> _isHaveImgFront = ValueNotifier(false);
  final ValueNotifier<bool> _isHaveImgBack = ValueNotifier(false);

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
            // const SizedBox(
            //   height: kToolbarHeight,
            // ),
            Stack(
              children: [
                // buildButtonAnnuler(context),
                buildTitle(),
              ],
            ),
            buildTitleLine(),
            const SizedBox(height: 10),
            buildBoxAdd2Images(context),
            // const SizedBox(height: 60),
            // buildUsernameTextField(),
            // const SizedBox(height: 30),
            // buildPasswordTextField(context),
            // const SizedBox(height: 40),
            // buildLoginButton(context),
            // const SizedBox(height: 40),
            // buildRegisterText(context),
          ],
        ),
      ),
    );
  }

  Widget buildBoxAdd2Images(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25.0),
        Row(
          children: [
            buildBoxImagePickerFront(context),
            const SizedBox(width: 20.0),
            buildBoxImagePickerBack(context),
          ],
        )
      ],
    );
  }

  Widget buildBoxImagePickerFront(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150.0,
          height: 200.0,
          // color: const Color.fromRGBO(220, 220, 220, 1),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(196, 196, 196, 1)),
            color: const Color.fromRGBO(220, 220, 220, 1),
          ),
          child: Align(
            alignment: Alignment.center,
            child: ValueListenableBuilder(
                valueListenable: _isHaveImgFront,
                builder: (BuildContext context, bool value, Widget? child) {
                  return Container(
                    child: _imgFrontPath == null
                        ? buildButtonToAddImgFront(context)
                        : buildShowImageFrontReview(context),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget buildShowImageFrontReview(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image(image: XFileImage(_imgFrontPath)),
        ),
        Align(
          alignment: const Alignment(0, 0.9),
          child: SizedBox(
            height: 25.0,
            child: ElevatedButton(
              onPressed: () {
                _imgFrontPath = null;
                _isHaveImgFront.value = false;
                print(_imgFrontPath);
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
        width: 115.0,
        height: 35.0,
        child: ElevatedButton(
          onPressed: () {
            _isSetImgFront = true;
            _isSetImgBack = false;
            _showBasicModalBottomSheet(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
          ),
          child: const Text(
            "Add a image front",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: Color.fromRGBO(111, 111, 111, 1),
              fontWeight: FontWeight.w700,
            ),
          ),
        ));
  }

  Widget buildBoxImagePickerBack(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150.0,
          height: 200.0,
          // color: const Color.fromRGBO(220, 220, 220, 1),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(196, 196, 196, 1)),
            color: const Color.fromRGBO(220, 220, 220, 1),
          ),
          child: Align(
            alignment: Alignment.center,
            child: ValueListenableBuilder(
                valueListenable: _isHaveImgBack,
                builder: (BuildContext context, bool value, Widget? child) {
                  return Container(
                    child: _imgBackPath == null
                        ? buildButtonToAddImgBack(context)
                        : buildShowImageBackReview(context),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget buildShowImageBackReview(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image(image: XFileImage(_imgBackPath)),
        ),
        Align(
          alignment: const Alignment(0, 0.9),
          child: SizedBox(
            height: 25.0,
            child: ElevatedButton(
              onPressed: () {
                _imgBackPath = null;
                _isHaveImgBack.value = false;
                print(_imgBackPath);
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

  Widget buildButtonToAddImgBack(BuildContext context) {
    return SizedBox(
      width: 115.0,
      height: 35.0,
      child: ElevatedButton(
        onPressed: () {
          _isSetImgBack = true;
          _isSetImgFront = false;
          _showBasicModalBottomSheet(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
        ),
        child: const Text(
          "Add a image back",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.0,
            color: Color.fromRGBO(111, 111, 111, 1),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
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
                    print("set back $_isSetImgBack");
                    print("set front $_isSetImgFront");
                    print("back a une image $_isHaveImgBack");
                    print("front a une image $_isHaveImgBack");
                    // print(_imgBackPath);
                    if (_isSetImgFront) {
                      if (index == 0) {
                        _imgFrontPath = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        _isHaveImgFront.value = true;
                      } else if (index == 1) {
                        _imgFrontPath = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        _isHaveImgFront.value = true;
                      }
                    } else if (_isSetImgBack) {
                      if (index == 0) {
                        _imgBackPath = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        _isHaveImgBack.value = true;
                      } else if (index == 1) {
                        _imgBackPath = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        _isHaveImgBack.value = true;
                      }
                    }
                    // print(_imgBackPath);
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
