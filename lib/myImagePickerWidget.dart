import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePickerWidget extends StatefulWidget {
  const MyImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<MyImagePickerWidget> createState() => _MyImagePickerWidgetState();
}

class _MyImagePickerWidgetState extends State<MyImagePickerWidget> {
  var _imgPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ImagePicker"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _imageView(_imgPath),
              ElevatedButton(
                onPressed: _takePhoto,
                child: Text("拍照"),
              ),
              ElevatedButton(
                onPressed: _openGallery,
                child: Text("选择照片"),
              ),
            ],
          ),
        ));
  }

  Widget _imageView(imgPath) {
    if (imgPath == null) {
      return const Center(
        child: Text("请选择图片或拍照"),
      );
    } else {
      return Image.file(
        imgPath,
      );
    }
  }

  _takePhoto() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image;
    });
  }

  _openGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath = image;
    });
  }
}
