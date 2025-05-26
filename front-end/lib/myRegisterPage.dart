import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './services/var_global.dart';
import './services/http_service.dart';

import './myLoginPage.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  late String _username = "";
  late String _password = "";
  late String _passwordconfirmation = "";

  late bool _isUsernamValid = true;
  late bool _ispasswordValid = true;
  late bool _isPasswordConfirmationValid = true;

  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  late final HttpService _httpService = HttpService();

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
              backgroundColor:
                  const WidgetStatePropertyAll<Color>(Colors.black),
              shape: WidgetStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Sign up',
              style: Theme.of(context).primaryTextTheme.headlineSmall),
          onPressed: () async {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              print(
                  'username: $_username, password: $_password, passwordconfirmation: $_passwordconfirmation');
              var newUser = {
                "data": {
                  "username": _username,
                  "password": _password,
                  "vinFav": {"value": []},
                  "role": "user"
                }
              };
              print(newUser);
              var res = await _httpService.register(newUser);
              print(res.statusCode);
              if (res.statusCode == 200) {
                (_formKey.currentState as FormState).reset();
              }
              // TODO: ajouter une condition : reset le form que quand tout va bien!
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
          },
        ),
      ),
    );
  }

  Widget buildPasswordConfirmationTextField(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure, // s'il affiche des text
      onSaved: (v) => _passwordconfirmation = v!,
      onChanged: (v) {
        if (v.isEmpty) {
          _isPasswordConfirmationValid = false;
        } else {
          _isPasswordConfirmationValid = true;
        }
      },
      validator: (v) {
        if (v!.isEmpty && !_isPasswordConfirmationValid) {
          return 'Please confirme your password!';
        } else if (_password.isNotEmpty) {
          if (v != _password) {
            return 'The password are not same!';
          }
        }
        return null;
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
      obscureText: _isObscure, // s'il affiche des text
      onSaved: (v) => _password = v!,
      onChanged: (v) {
        if (v.isEmpty) {
          _ispasswordValid = false;
        } else {
          _ispasswordValid = true;
        }
      },
      validator: (v) {
        if (v!.isEmpty && !_ispasswordValid) {
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
        if (v.isEmpty) {
          _isUsernamValid = false;
        } else {
          _isUsernamValid = true;
        }
      },
      validator: (v) {
        if (v!.isEmpty && !_isUsernamValid) {
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
