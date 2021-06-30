import 'package:bi_whitenoise/data/color.dart';
import 'package:flutter/material.dart';

Widget customListTile(
    {String title = "", String desc = "", String cover = "", color,onTap}) {
  return InkWell(
    highlightColor: ColorData.primaryColor,
    splashColor: ColorData.primaryStrongColor,
    
    onTap: onTap,
    child: Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Container(
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: NetworkImage(cover),
                  fit: BoxFit.fill,
                )),
          ),
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
                desc,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,

                style: TextStyle(
                  color: Colors.grey, fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Segoe',
                  ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
