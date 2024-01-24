import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scannar_app_project/home_page/home_page.dart';
import 'package:scannar_app_project/recomendations/recomendations.dart';
import 'package:scannar_app_project/upload_document/upload_document.dart';

import '../ml_concepts/details_screen.dart';
import '../ml_concepts/ml_page.dart';
import '../pie_chart/business_login.dart';
import '../pie_chart/pie_chart.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal[50],
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            buildHeader(context: context),
            const Divider(color: Colors.grey),
            buildMenuItems(context: context),
          ],
        ),
      ),
    );
  }

  buildHeader({context}) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.teal[100],
            child: const Icon(Icons.person, color: Colors.teal),
          ),
          Text('${FirebaseAuth.instance.currentUser!.email}')
        ],
      ),
    );
  }

  buildMenuItems({context}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          leading: const Icon(Icons.home_filled),
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: const Text('Text Fetcher '),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return DetailScreen(
                  setting: 'Image From Text',
                );
              },
            ));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.pie_chart),
          title: const Text('Chart'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return  BusinessLogin();
              },
            ));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.upload_file_outlined),
          title: const Text('Upload Document'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const UploadDocument();
              },
            ));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.recommend_outlined),
          title: const Text('Recommendations'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return Recomendations();
              },
            ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('LogOut '),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}
