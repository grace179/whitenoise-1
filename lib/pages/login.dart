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
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        UserController.to.authStateChanges(snapshot.data);

        if (!snapshot.hasData) {
          return SocialLogin();
        } else {
          return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${snapshot.data.displayName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' 님 반갑습니다.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        'LogOut',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                // 회원정보 입력창 생년월일, 성별
                UserInfoForm(),
              ],
            ),
          );
        }
      },
    );
  }
}
