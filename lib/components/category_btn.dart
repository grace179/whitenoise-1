import 'package:bi_whitenoise/data/color.dart';
import 'package:flutter/material.dart';

Widget categoryBtn({String btnName = "", onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10),

      child: Container(
        height: 100.0,
        width: 100.0,
        alignment: Alignment.center,
        child: Text(
          btnName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorData.fontWhiteColor,
            fontFamily: 'MontserratExtraBoldItalic',
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 20.0,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: ColorData.fontDarkColor,
        ),
      ),
    ),
  );
}
