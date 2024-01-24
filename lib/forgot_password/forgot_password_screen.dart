import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordController = TextEditingController();

  @override
  void dispose() {
    forgotPasswordController.dispose();
    super.dispose();
  }

  passwordReset() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: forgotPasswordController.text);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Enter your eMail, we will share you the reset Password link',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
              controller: forgotPasswordController,
              hintText: 'Email',
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              buttonText: 'Reset Password',
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
