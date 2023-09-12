import 'dart:async';

import 'package:farmer_app_final/Screens/SignUpScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/LoginScreen.dart';

class SplashService {
  void isLogin(BuildContext context) async {
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register())));
  }
}
