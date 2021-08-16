import 'package:bi_whitenoise/data/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marquee/marquee.dart';

Widget customListTile({
  String title = "",
  String desc = "",
  color,
  onTap,
  duration,
  bool currentMusic = false,
}) {
  return InkWell(
    highlightColor: ColorData.primaryColor,
    splashColor: ColorData.primaryStrongColor,
    onTap: onTap,
    child: Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //  Container(
          //   height: 70.0,
          //   width: 70.0,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(16.0),
          //     image: DecorationImage(
          //       image: NetworkImage(cover),
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 10.0,
          // ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                currentMusic
                    ? animatedText(title: title)
                    : Text(
                        title,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          color: ColorData.fontWhiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Segoe',
                        ),
                      ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '$desc',
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Segoe',
                  ),
                ),
              ],
            ),
          ),
          Text(
            // '00:00'
            duration ?? '',
          )
        ],
      ),
    ),
  );
}

Widget animatedText({String title = ""}) {
  return Container(
    
    child: Marquee(
      text: title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe',
      ),
      blankSpace: 60,
    ),
  );
}
