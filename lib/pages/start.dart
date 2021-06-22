import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black87,
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
                  child: Text('whitenoise',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),

                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 150,
                  child: InkWell(
                    child:
                        Lottie.asset("assets/lottie/play-button-on-hover.json"),
                    onTap: () {},
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
