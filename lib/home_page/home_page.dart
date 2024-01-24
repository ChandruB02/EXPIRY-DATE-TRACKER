import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scannar_app_project/components/drawer.dart';
import 'package:qrscan/qrscan.dart' as qrScan;
import 'package:scannar_app_project/home_page/services.dart';
import 'package:scannar_app_project/models/categories.dart';
import 'package:scannar_app_project/utils/utility.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoriesResponse> categoryList = [];

  @override
  initState() {
    fetchRecords();
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((records) {
      mapRecords(records);
    });
    super.initState();
  }

  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection('products').get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs
        .map(
          (item) => CategoriesResponse(
            id: item.id,
            firstName: item['firstName'],
            lastName: item['lastName'],
            productName: item['productName'],
            purchaseDate: item['purchaseDate'],
            warrantyDate: item['warrantyDate'],
          ),
        )
        .toList();

    setState(() {
      categoryList = list;
    });
    DateTime currentDateTime = DateTime.now();
    int count = 2;
    for (var element in categoryList) {
      DateTime dt = DateTime.parse(element.warrantyDate);
      //print('dateTime $dt '); // 2020-01-02 03:04:05.000
      count++;
      if ((currentDateTime.compareTo(DateTime.parse(element.warrantyDate)) !=
              0) &&
          (currentDateTime.compareTo(DateTime.parse(element.warrantyDate)) <
              0)) {
        NotificationService().scheduleNotification(
            id: count,
            title:
                '${element.firstName}  : ${element.productName}  : ${element.purchaseDate}',
            body: '$dt',
            scheduledNotificationDateTime: dt);
      } else {
        print('from Here');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Content'),
        backgroundColor: Colors.teal,
      ),
      drawer: const DrawerScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          // _showModalBottomSheet(context: context);
          requestPermission(context, 2);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: categoryList.isNotEmpty
                ? ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.teal[50],
                        elevation: 20,
                        child: ListTile(
                          title: Text(
                            '${categoryList[index].productName}  ${categoryList[index].firstName}',
                          ),
                          subtitle: Text(
                            categoryList[index].purchaseDate,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
          )
        ],
      ),
    );
  }

  _showModalBottomSheet({context}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ShowOptions(),
            );
          },
        );
      },
    );
  }

  Future<void> requestPermission(BuildContext context, int value) async {
    const permission = Permission.camera;

    if (await permission.isDenied) {
      final result = await permission.request();

      if (result.isGranted) {
        if (value == 2) {
          String? scanned = await qrScan.scan();
          addProducts(scanned: scanned);
        } else if (value == 1) {
          // getImageFromCamera();
        }
      } else if (result.isDenied) {
        showDialogMsg(
            context: context, message: 'Please grand Camera Permission');
      } else if (result.isPermanentlyDenied) {
        showDialogMsg(
            context: context, message: 'Please grand Camera Permission');
      }
    } else {
      if (value == 2) {
        String? scanned = await qrScan.scan();
        addProducts(scanned: scanned);
      } else if (value == 1) {
        //getImageFromCamera();
        Navigator.of(context).pop();
      }
    }
  }

  addProducts({scanned}) async {
    print('scanned $scanned');
    var cat = categoriesResponseFromJson(scanned);

    await FirebaseFirestore.instance.collection('products').add({
      'id': cat.id,
      'firstName': cat.firstName,
      'lastName': cat.lastName,
      'productName': cat.productName,
      'purchaseDate': cat.purchaseDate,
      'warrantyDate': cat.warrantyDate,
    });
  }
}

class ShowOptions extends StatefulWidget {
  ShowOptions({super.key});

  @override
  State<ShowOptions> createState() => _ShowOptionsState();
}

class _ShowOptionsState extends State<ShowOptions> {
  FirebaseStorage storage = FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = _photo!.path;
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: -15,
          child: Container(
            width: 60,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 250,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () {
                      requestPermission(context, 1);
                    },
                    child: const Text('Camera'))),
            const SizedBox(
              height: 20,
            ),
            const Text('or', style: TextStyle(fontSize: 15)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 250,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      print('object');
                      requestPermission(context, 2);
                    },
                    child: const Text('Scanner'))),
          ],
        ),
      ],
    );
  }

  Future<void> requestPermission(BuildContext context, int value) async {
    const permission = Permission.camera;

    if (await permission.isDenied) {
      final result = await permission.request();

      if (result.isGranted) {
        if (value == 2) {
          String? scanned = await qrScan.scan();
          addProducts(scanned: scanned);
        } else if (value == 1) {
          getImageFromCamera();
        }
      } else if (result.isDenied) {
        showDialogMsg(
            context: context, message: 'Please grand Camera Permission');
      } else if (result.isPermanentlyDenied) {
        showDialogMsg(
            context: context, message: 'Please grand Camera Permission');
      }
    } else {
      if (value == 2) {
        String? scanned = await qrScan.scan();
        addProducts(scanned: scanned);
      } else if (value == 1) {
        getImageFromCamera();
        Navigator.of(context).pop();
      }
    }
  }

  addProducts({scanned}) async {
    print('scanned $scanned');
    var cat = categoriesResponseFromJson(scanned);
    await FirebaseFirestore.instance.collection('products').add({
      'id': cat.id,
      'firstName': cat.firstName,
      'lastName': cat.lastName,
      'productName': cat.productName,
      'purchaseDate': cat.purchaseDate,
      'warrantyDate': cat.warrantyDate,
    });
  }
}
