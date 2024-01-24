import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scannar_app_project/pie_chart/pie_chart.dart';
import 'package:scannar_app_project/utils/utility.dart';

import '../components/drawer.dart';
import '../components/my_button.dart';
import '../components/text_field.dart';

class BusinessLogin extends StatelessWidget {
  BusinessLogin({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(''),
      ),
      drawer: const DrawerScreen(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // logo
                const Icon(
                  Icons.add_business_outlined,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Business Users Login',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 25),
                // sign in button
                MyButton(
                  buttonText: '',
                  onTap: () {
                    if((passwordController.text == 'admin') && (emailController.text == 'admin') )
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return PIeChart();
                          },
                        ));
                      }
                    else
                      {
                         showDialogMsg(context: context,message: 'InValid Business Credentials');
                      }
                  },
                ),

                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
