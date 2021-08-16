// @dart=2.9
import 'package:bi_whitenoise/data/color.dart';
import 'package:bi_whitenoise/pages/start.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(WhiteNoiseApp());
}

class WhiteNoiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 가로 회전 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
