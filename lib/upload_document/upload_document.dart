import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scannar_app_project/utils/utility.dart';

import '../components/drawer.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  PlatformFile? pickedFile;
  List<String> myListName = [];

  Future uploadFile(BuildContext context) async {
    final path = 'image/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    showDialogMsg(message: 'Uploaded Successfully', context: context);
    addImageList();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Reference get fireStorage => FirebaseStorage.instance.ref();

  Future<String> getImage(String imageName) async {
    var urlRef = fireStorage.child('image').child(imageName);
    var imgUrl = urlRef.getDownloadURL();
    return imgUrl;
  }

  fetchRecords() async {
    var records =
        await FirebaseFirestore.instance.collection('imageList').get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs
        .map(
          (item) => item.data(),
        )
        .toList();

    for (var dataMap in list) {
      if (dataMap is Map) {
        // add a type check to ensure dataMap is a Map
        for (var key in dataMap.keys) {
          print('$key: ${dataMap[key]}');
          myListName.add(dataMap[key]);
        }
        print('----------------------');
        setState(() {

        });
      }
    }


    /*setState(() {
      categoryList = list;
    });
    DateTime currentDateTime = DateTime.now();
    int count = 2;
    for (var element in categoryList) {
      DateTime dt = DateTime.parse(element.warrantyDate);
      //print('dateTime $dt '); // 2020-01-02 03:04:05.000

    }*/
  }

  Future addImageList() async {
    try {
      await FirebaseFirestore.instance.collection('imageList').add({
        'names': pickedFile!.name!,
      });
    } on FirebaseAuthException catch (e) {
      print('exception $e');
    }
  }

  @override
  void initState() {
    fetchRecords();
    FirebaseFirestore.instance
        .collection('imageList')
        .snapshots()
        .listen((records) {
      mapRecords(records);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Upload Document'),
        actions: [
          GestureDetector(
            onTap: () {
              selectFile();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      drawer: const DrawerScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.upload),
        onPressed: () {
          if (pickedFile != null) {
            uploadFile(context);
          } else {
            showDialogMsg(context: context, message: 'Please Select the Image');
          }
        },
      ),
      body: Column(
        children: [
          pickedFile != null ? SizedBox(
              width: 400,
              height: 300,
              child: Image.file(File(pickedFile!.path!),errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Not able to preview \n But Data has been uploaded',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color: Colors.teal),));
              },),
            ) : const Text('Not able to preview'),
          Expanded(
            child: ListView.builder(
              itemCount: myListName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(myListName[index]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
