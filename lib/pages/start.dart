// import 'package:bi_whitenoise/pages/player.dart';
import 'package:bi_whitenoise/pages/splash.dart';
import 'package:bi_whitenoise/src/app.dart';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:bi_whitenoise/data/color.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _loading = true;

  @override
  void initState() {
    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     _loading = false;
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorData.bgColor,
      body: SafeArea(
        child: Container(
          // height: size.height,

          color: ColorData.bgColor,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 100,
              //   child: Lottie.asset(
              //     "assets/lottie/moon1.json",
              //   ),
              // ),
              Center(child: App()),
            ],
          ),
        ),
      ),
    );
  }
}
