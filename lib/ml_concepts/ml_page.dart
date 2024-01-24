import 'package:flutter/material.dart';
import 'package:scannar_app_project/ml_concepts/details_screen.dart';

class MlPage extends StatefulWidget {
  const MlPage({super.key});

  @override
  State<MlPage> createState() => _MlPageState();
}

class _MlPageState extends State<MlPage> {
  List<String> listString = [
    'Test Fetcher',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: listString.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(listString[index]),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return DetailScreen(
                        setting: listString[index]);
                  },
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
