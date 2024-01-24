import 'package:flutter/material.dart';
import 'package:scannar_app_project/login_screen/login_screen.dart';
import 'package:scannar_app_project/register_screen/register_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(showRegisterPage: toggleScreen);
    } else {
      return RegisterScreen(showLoginPage: toggleScreen);
    }
  }
}
