import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePickerWidget extends StatefulWidget {
  const MyImagePickerWidget({Key? key, required this.imageSelected})
      : super(key: key);

  final XFile imageSelected;

  @override
  _MyImagePickerWidgetState createState() {
    return _MyImagePickerWidgetState(imageSelected);
  }
}

class _MyImagePickerWidgetState extends State<MyImagePickerWidget> {
  XFile imageSelected;

  _MyImagePickerWidgetState(this.imageSelected);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
