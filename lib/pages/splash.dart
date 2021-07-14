import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Image.asset('assets/lottie/whitenoise_gif.gif'),
        // Lottie.asset(
        //   "assets/lottie/whitenoise-lottie.json",
        //   fit: BoxFit.fitWidth,
        //   animate: true,
        //   frameRate: FrameRate(24),
        //   repeat: true,
        // ),
      ),
    );
  }
}
