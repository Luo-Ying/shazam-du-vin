import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAddNewWineFormPage extends StatefulWidget {
  const MyAddNewWineFormPage({Key? key}) : super(key: key);

  @override
  State<MyAddNewWineFormPage> createState() => _MyAddNewWineFormPageState();
}

class _MyAddNewWineFormPageState extends State<MyAddNewWineFormPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(
              height: kToolbarHeight,
            ),
            Stack(
              children: [
                buildButtonAnnuler(context),
                buildTitle(),
              ],
            ),
            buildTitleLine(),
            // const SizedBox(height: 10),
            // buildSubTitle(),
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

  Widget buildButtonAnnuler(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 290.0),
      child: SizedBox(
        width: 56,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.close),
            ],
          ),
        ),
      ),
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
      padding: EdgeInsets.only(left: 1.0, top: 35.0, bottom: 8.0),
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
