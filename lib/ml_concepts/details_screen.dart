import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannar_app_project/utils/utility.dart';

import '../components/drawer.dart';

class DetailScreen extends StatefulWidget {
  final String setting;

  DetailScreen({super.key, required this.setting});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  XFile? pickedImage;
  var imageFile;
  bool isImageLoaded = false;
  String scannedText = '';
  String foundText = '';

  getImageFromGallery() async {
    var tempStore = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }


  readTextFromImage(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      final List<String> languages = block.recognizedLanguages;
      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          scannedText = '$scannedText${element.text}';
        }
      }
      //String splittedText = scannedText.split('Expirydate')[0];
      //print('scannedText: ${scannedText.split('Expiry date')}');

      //
      setState(() {});
    }
    print('scannedText ${scannedText}');
    if(scannedText.contains('Expirydate')) {
      showDialogMsg(context: context,message: 'Expiry Date Found');
        String text = scannedText.split('Expirydate')[1];
        String text1 = text.split(';')[0];
        print('scannedText   ::  ${text1}');
        //     print('scannedText $text   ::  ${text1}');
        foundText = "Expiry Date is ${text1.substring(0, 2)} ${text1.substring(2, 4)} ${text1.substring(4, 8)}";

      }
    else
      {
        showDialogMsg(context: context,message: 'Expiry Date Not Found');
        foundText = 'No Expiry Date Found';
      }


    // print('scannedText $text   ::  $foundText');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.setting),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              getImageFromGallery();
            },
            icon: const Icon(
              Icons.add_a_photo,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 0,),
          isImageLoaded ? Center(child: SizedBox(
            height: 350,
            width: 350,
            child: pickedImage!.path != null ? Image.file(File(pickedImage!.path)) : const SizedBox(),
          )) : const SizedBox(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: foundText.isNotEmpty ? Text(' $foundText',style: const TextStyle(fontSize: 20,color: Colors.teal,),textAlign: TextAlign.center,) :
            Center(child: Text('Please Select Image From The Top',style: const TextStyle(fontSize: 20,color: Colors.teal,),textAlign: TextAlign.center,)),
          )
        ],
      ),
      drawer: const DrawerScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          if(pickedImage != null)
            {
              readTextFromImage(pickedImage!);
            }
          else
            {
              showDialogMsg(context: context,message: 'Please Select Image From Gallery');
            }

        },
      ),
    );
  }
}
