// @dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class SocialLogin extends StatelessWidget {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // color: ColorData.bg,
      // alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          SizedBox(
            height: 200,
            child: Lottie.asset(
              "assets/lottie/moon1.json",
              // repeat: false,
            ),
          ),
          Text(
            'MySound',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'MontserratExtraBold',
              fontWeight: FontWeight.bold,
              fontSize: 23.0,
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(25),

              backgroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white,
                width: 1.0,
                style: BorderStyle.solid,
              ),

              // elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
            ),
            child: Text(
              'Google로 시작하기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              signInWithGoogle();
              // 다른계정으로 로그인
            },
          ),
        ],
      ),
    );
  }
}
