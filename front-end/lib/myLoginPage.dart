import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shazam_du_vin/myMainPage.dart';
import 'package:shazam_du_vin/services/winesActions.dart';
import 'package:shazam_du_vin/utils/buildCurrentUser.dart';

import 'services/var_global.dart';
import 'services/http_service.dart';
import 'services/localStorage.dart';
import 'utils/models.dart';

import 'myRegisterPage.dart';
import 'components/fluttertoast.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  late String _username = "";
  late String _password = "";

  late bool _isUsernameValid = true;
  late bool _isPasswordValid = true;

  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  late final HttpService _httpService = HttpService();

  List<Wine> _listTopWines = [];

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
            buildLoginButton(context),
            const SizedBox(height: 40),
            buildRegisterText(context),
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
            const Text('No acount?'),
            GestureDetector(
              child: const Text('  Sign up',
                  style: TextStyle(color: Colors.green)),
              onTap: () {
                // TODO: fonction user enregistrer un nouveau compte
                print('cliquer pour enregistrer');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyRegisterPage(
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

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  const WidgetStatePropertyAll<Color>(Colors.black),
              shape: WidgetStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Sign in',
              style: Theme.of(context).primaryTextTheme.headlineSmall),
          onPressed: () async {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              print('username: $_username, password: $_password');
              var res = await _httpService.connexion(_username, _password);
              print("res status code >>>> ${res.statusCode}");
              if (res.statusCode == 200) {
                await saveDataString("currentUser", res.body);
                VarGlobal.currentUser = await buildCurrentUser();
                print(VarGlobal.currentUser.vinFav.value);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return MyMainPage(
                      title: 'main',
                      listTopWines: _listTopWines,
                    );
                  },
                ));
              } else if (res.statusCode == 403) {
                Fluttertoast.showToast(
                  msg: VarGlobal.TOASTMESSAGE,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
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
          },
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure, // s'il affiche des text
      onSaved: (v) => _password = v!,
      onChanged: (v) {
        _password = v;
        if (v.isEmpty) {
          _isPasswordValid = false;
        } else {
          _isPasswordValid = true;
        }
      },
      validator: (v) {
        if (v!.isEmpty && !_isPasswordValid) {
          return 'Please enter your password!';
        }
        return null;
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
      onChanged: (v) {
        _username = v;
        if (v.isEmpty) {
          _isUsernameValid = false;
        } else {
          _isUsernameValid = true;
        }
      },
      validator: (v) {
        if (v!.isEmpty && !_isUsernameValid) {
          return 'Please enter your username!';
        }
        return null;
      },
    );
  }

  Widget buildSubTitle() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Login',
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

  Future<void> getWines() async {
    _listTopWines = [];
    var res = await _httpService.getTopWines();
    var data = jsonDecode(res.body);
    print(data);
    WineActions.setListWine(2, data);
    _listTopWines = WineActions.listTopWines;
  }
}
