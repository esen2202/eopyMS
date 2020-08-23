import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginOperations extends StatefulWidget {
  LoginOperations({Key key}) : super(key: key);

  @override
  _LoginOperationsState createState() => _LoginOperationsState();
}

class _LoginOperationsState extends State<LoginOperations> {
  var _emailTextController = TextEditingController();
  var _passTextController = TextEditingController();
  var _errTextController = TextEditingController();

  @override
  void initState() {
    _emailTextController.text = "erkanesen2202@gmail.com";
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _errTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Firebase"),
        ),
        body: Column(
          children: [
            TextField(
              controller: _emailTextController,
            ),
            TextField(
              controller: _passTextController,
              style: TextStyle(
                textBaseline: TextBaseline.ideographic,
              ),
            ),
            TextField(
              controller: _errTextController,
              style: TextStyle(textBaseline: TextBaseline.ideographic),
            ),
            RaisedButton(
              onPressed: _loginAction,
              child: Text("Email Şifre Gir"),
            )
          ],
        ),
      ),
    );
  }

  void _loginAction() async {
    try {
      var returnUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passTextController.text)
          .catchError((e) {
        _errTextController.text = e.toString();
      });
      if (returnUser != null) {
        _errTextController.text =
            returnUser.user.displayName ?? "disp" + " : " + returnUser.user.uid;
      } else {
        _errTextController.text = "No user";
      }
    } catch (e) {
      _errTextController.text = e.toString();
    }
  }
}
