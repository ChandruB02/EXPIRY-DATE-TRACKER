import 'package:flutter/material.dart';

import '../components/drawer.dart';

class Recomendations extends StatelessWidget {
  Recomendations({super.key});

  List<String> myList = [
    'brands',
    'ONIDA',
    'LG',
    'SAMSUNG',
    'redmi',
    'Oppo',
    'pilips',
    'DELL',
    'HP',
    'Redmi',
    'Mi',
    'One Plus',
    'Haier',
    'Panasonic',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(''),
      ),
      drawer: const DrawerScreen(),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Recommended Products',
                hintStyle: TextStyle(
                  color: Colors.teal[900],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(child: ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                shadowColor: Colors.teal,
                child: ListTile(
                  leading: const Icon(Icons.recommend),
                  title: Text(myList[index]),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
