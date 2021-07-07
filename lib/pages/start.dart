import 'package:bi_whitenoise/pages/player.dart';
import 'package:bi_whitenoise/pages/splash.dart';
import 'package:bi_whitenoise/src/app.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bi_whitenoise/data/color.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _loading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: _loading
          ? SplashWidget()
          : Container(
              // height: size.height,
              color: ColorData.bgColor,
              child: Column(
                children: [
                  Lottie.asset(
                    "assets/lottie/whitenoise-lottie.json",
                    // repeat: false,
                  ),
                  App(),
                ],
              ),
            ),
    );
  }
}
