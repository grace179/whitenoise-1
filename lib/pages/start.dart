import 'package:bi_whitenoise/pages/player.dart';
import 'package:bi_whitenoise/src/app.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bi_whitenoise/data/color.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        height: size.height,
        color: ColorData.bgColor,
          child: Column(
            children: [
              Lottie.asset(
                "assets/lottie/whitenoise1.json",
                // repeat: false,
              ),
              App(),
            ],
          ),
      ),
    );
  }
}
