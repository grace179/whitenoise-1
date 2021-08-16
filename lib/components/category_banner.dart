import 'package:bi_whitenoise/data/color.dart';
import 'package:flutter/material.dart';

Widget categoryBanner(
    {double width = 300.0,
    double height = 100.0,
    String categoryName = "",
    String imageUrl = "",
    onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      // padding: EdgeInsets.all(10),

      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
              // child: Image.asset(imageUrl,fit: BoxFit.fitWidth,)
            ),
            Center(
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorData.fontWhiteColor,
                  fontFamily: 'MontserratExtraBold',
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 30.0,
                  // 폰트크기는 36px,  그림자는 2px 2px 6px / rgba(0,0,0,0.3)
                  shadows: <Shadow>[
                    Shadow(
                      blurRadius: 10,
                      offset: Offset(6.0, 5.0),
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
