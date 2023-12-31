import 'package:flutter/material.dart';

class AppSnackBar{
  static void appSnackBar({required String text, required Color bg, required BuildContext context}){
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text("$text"),
      backgroundColor: bg,
      duration: Duration(milliseconds: 3000),
    ));
  }
}