import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './services/http_service.dart';
import './utils/models.dart';
import './myLoginPage.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  // var _client = http.Client();
  late final HttpService _httpService = HttpService();
  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _username = "";
  late String _password = "";
  late String _passwordconfirmation = "";
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

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
            buildTitle(),
            buildTitleLine(),
            const SizedBox(height: 10),
            buildSubTitle(),
            const SizedBox(height: 60),
            buildUsernameTextField(),
            const SizedBox(height: 30),
            buildPasswordTextField(context),
            const SizedBox(height: 40),
            buildPasswordConfirmationTextField(context),
            const SizedBox(height: 40),
            buildRegisterButton(context),
            const SizedBox(height: 40),
            buildRegisterText(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an acount?'),
            GestureDetector(
              child: const Text('  Sign in',
                  style: TextStyle(color: Colors.green)),
              onTap: () {
                print('cliquer pour sign in');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyLoginPage(
                    title: 'Shazam du vin',
                  ),
                ));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Sign up',
              style: Theme.of(context).primaryTextTheme.headline5),
          onPressed: () async {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              print(
                  'username: $_username, password: $_password, passwordconfirmation: $_passwordconfirmation');
              (_formKey.currentState as FormState).reset();
              // List vinfav = [] as List<dynamic>;
              // var userVinFav = VinFav(value: vinfav);
              // var userData = Document(
              //     username: _username,
              //     password: _password,
              //     vinFav: userVinFav,
              //     role: "user");
              // var newUser = User(document: userData);
              var newUser = {
                "database": "urbanisation",
                "collection": "User",
                "Document": {
                  "username": _username,
                  "password": _password,
                  "vinFav": {
                    "value": [0, 1, 2]
                  },
                  "role": "user"
                }
              };
              print("okk????????");
              print(newUser);
              print("okk!!!!!!!!!");
              _httpService.register(newUser);
            }
          },
        ),
      ),
    );
  }

  Widget buildPasswordConfirmationTextField(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure, // s'il affiche des text
      onSaved: (v) => _passwordconfirmation = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please confirme your password!';
        } else if (_password.isNotEmpty) {
          if (v != _password) {
            // print(v);
            print(_password);
            return 'The password are not same!';
          }
        }
      },
      decoration: InputDecoration(
        labelText: "Password confirmation",
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
              _eyeColor = (_isObscure
                  ? Colors.grey
                  : Theme.of(context).iconTheme.color)!;
            });
          },
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onChanged: (v) => _password = v,
      obscureText: _isObscure, // s'il affiche des text
      onSaved: (v) => _password = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter your password!';
        }
      },
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
              _eyeColor = (_isObscure
                  ? Colors.grey
                  : Theme.of(context).iconTheme.color)!;
            });
          },
        ),
      ),
    );
  }

  Widget buildUsernameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Username'),
      onSaved: (v) => _username = v!,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Please enter your username!';
        }
      },
    );
  }

  Widget buildSubTitle() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Sign up',
        style: TextStyle(fontSize: 22),
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
      padding: EdgeInsets.all(8),
      child: Text(
        'Shazam du vin',
        style: TextStyle(fontSize: 42),
      ),
    );
  }
}
