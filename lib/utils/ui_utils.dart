import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void showSnackbar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1),
    ),
  );
}

class AppColors {
  static Color mainColor = Colors.white;
  static Color darkColor = Colors.grey[200];
  static Color blueColor = Color(0XFF2c75fd);
}

const bold = TextStyle(fontWeight: FontWeight.bold);
const link = TextStyle(color: Colors.black);
