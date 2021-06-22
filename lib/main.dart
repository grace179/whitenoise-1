import 'package:bi_whitenoise/pages/start.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(WhiteNoiseApp());
}

class WhiteNoiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}
