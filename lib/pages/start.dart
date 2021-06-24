import 'package:bi_whitenoise/pages/player.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:bi_whitenoise/data/color.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: ColorData.bgColor,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                ),

                Container(
                    margin: EdgeInsets.all(60.0),
                    child: Icon(
                      Icons.brightness_2,
                      size: 100,
                      color: Colors.yellow[100],
                    )),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Text('WhiteNoise',
                      style: TextStyle(color: Colors.white,
                  fontFamily: 'MontserratExtraBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),),
                ),

                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 150,
                  child: InkWell(
                    child:
                        Lottie.asset("assets/lottie/play-button-on-hover.json"),
                    onTap: () {
                      Get.to(()=>PlayerPage());
                    },
                  ),
                ),
                // ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )),
    );
  }
}
