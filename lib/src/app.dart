import 'package:bi_whitenoise/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('firebase load fail');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print('firebase connect');
            // firebase 연결된경우

            return Login();
          }
          return CircularProgressIndicator();
        });
  }
}
