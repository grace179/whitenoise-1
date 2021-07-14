// @dart=2.9
import 'package:bi_whitenoise/data/color.dart';
import 'package:bi_whitenoise/pages/start.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(WhiteNoiseApp());
}

class WhiteNoiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // color: ColorData.bgColor,
      darkTheme: ThemeData(
        backgroundColor: ColorData.bgColor,
        unselectedWidgetColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<UserController>(() => UserController());
      }),
      home: StartPage(),
    );
  }
}
