import 'package:bi_whitenoise/pages/player.dart';
import 'package:bi_whitenoise/pages/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (!snapshot.hasData) {
            return SocialLogin();
          } else {
            return Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Welcome ${snapshot.data?.displayName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
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
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
