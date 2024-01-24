import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scannar_app_project/auth_page/auth_page.dart';
import 'package:scannar_app_project/login_screen/login_screen.dart';

import '../home_page/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData)
            {
               return HomePage();
            }
          else
            {
              return const AuthPage();
            }
      },),
    );
  }
}
