// @dart=2.9
import 'package:bi_whitenoise/model/user_model.dart';
import 'package:bi_whitenoise/src/firebase_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  UserModel initUserProfile = UserModel();

  Rx<UserModel> userProfile = UserModel().obs;

  void authStateChanges(User firebaseUser) async {
    if (firebaseUser != null) {
      UserModel userModel =
          await FirebaseUserRepository.findUserByUid(firebaseUser.uid);
      if (userModel != null) {
        initUserProfile = userModel;
        FirebaseUserRepository.updateLastLoginDate(
            userModel.docId, DateTime.now().toString());
      } else {
        initUserProfile = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName.toString(),
          createdTime: firebaseUser.metadata.creationTime.toString(),
          lastLoginTime: firebaseUser.metadata.lastSignInTime.toString(),
        );

        String docId = await FirebaseUserRepository.singup(initUserProfile);
        initUserProfile.docId = docId;
        // initUserProfile = user;
      }
      print(firebaseUser.toString());
    }
    userProfile(UserModel.clone(initUserProfile));
  }

  void updateBirth(String birth) {
    userProfile.update((val) {
      val.birth = birth;
    });
  }

  void updateGender(String gender) {
    userProfile.update((val) {
      val.gender = gender;
    });
  }

  void save() {
    initUserProfile = userProfile.value;
    FirebaseUserRepository.updateData(initUserProfile.docId, initUserProfile);
  }
}
