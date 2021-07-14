// @dart=2.9
import 'package:bi_whitenoise/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserRepository {
  static Future<String> singup(UserModel user) async {
    // collection = table name
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference drf = await users.add(user.toMap());
    return drf.id;
  }

  static Future<UserModel> findUserByUid(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot data = await users.where('uid', isEqualTo: uid).get();

    // return UserModel.fromJson(
    //     data.docs[0].data(), data.docs[0].id);

    if (data.size == 0) {
      return null;
    } else {
      return UserModel.fromJson(data.docs[0].data(), data.docs[0].id);
    }
  }

  static void updateLastLoginDate(String docId, String time) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).update({"lastLoginTime": time});
  }

  static void updateData(String docId, UserModel user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).update(user.toMap());
  }
}
