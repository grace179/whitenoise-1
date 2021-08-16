// @dart=2.9
import 'package:bi_whitenoise/components/user_info_form.dart';
import 'package:bi_whitenoise/pages/player.dart';
import 'package:bi_whitenoise/pages/social_login.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _userController = Get.put(UserController());

  @override
  void initState() {
    print('user info check');
    print(_userController.userProfile.value.birth);
    print(_userController.userInfoCheck);
    // print(_userInfo);
// if(_userInfo == true){
//   Get.to(PlayerPage);
// }
    super.initState();
  }

  @override
  void dispose() {
    // _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // userInfoCheck();

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        UserController.to.authStateChanges(snapshot.data);

        if (!snapshot.hasData) {
          return SocialLogin();
        } else {
          return Expanded(
            child: Container(
              height: size.height * 0.95,
              // alignment: Alignment.center,
              child: Obx(
                () => _userController.userInfoCheck.value
                    ? PlayerPage()
                    : UserInfoForm(),
              ),
            ),
          );
        }
      },
    );
  }
}
