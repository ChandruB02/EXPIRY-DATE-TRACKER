

import 'package:flutter/material.dart';

void showDialogMsg({context, message}){
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      content: Text(message),
    );
  },);
}