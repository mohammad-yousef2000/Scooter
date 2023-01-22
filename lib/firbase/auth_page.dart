import 'package:finalfb/firbase/log.dart';
import 'package:flutter/material.dart';
import 'Reg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglescreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(showRegisterPage: togglescreen);
    } else {
      return RegisterPage(showLoginPage: togglescreen);
    }
  }
}
