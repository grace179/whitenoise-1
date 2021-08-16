import 'package:bi_whitenoise/data/color.dart';
import 'package:flutter/material.dart';

Widget scrollCateBtn({String category = "", onPressed}) {
  return OutlinedButton(
    child: Text(
      category,
      style: TextStyle(
        fontFamily: 'MontserratExtraBoldItalic',
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 18.0,
      ),
    ),
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      primary: ColorData.fontWhiteColor,
      side: BorderSide(
        color: ColorData.primaryStrongColor,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onPressed: onPressed,
  );
}
