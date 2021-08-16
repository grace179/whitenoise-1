// @dart=2.9
import 'package:bi_whitenoise/model/music_model.dart';
import 'package:bi_whitenoise/model/user_model.dart';
import 'package:bi_whitenoise/src/firebase_music_repository.dart';
import 'package:bi_whitenoise/src/firebase_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum Category { Classic, NewAge, NurseryRhymes, World, SoundTrack }

class UserController extends GetxController {
  static UserController get to => Get.find();

  UserModel initUserProfile = UserModel();

  Rx<UserModel> userProfile = UserModel().obs;

  RxBool userInfoCheck = false.obs;

  Rx<MusicModel> initMusic = MusicModel().obs;

  Rx<CurrentMusicData> currentMusicData = CurrentMusicData().obs;

  void onInit() {
    super.onInit();

    // Worker
    // 현재 재생중인 음악데이터가 변경될때 호출됨...
    ever(currentMusicData, (_) {
      // user-music data- title/count update
      print('---currnet music title changed---');
      print(currentMusicData.value.title);

      // updateCountData();

      // FirebaseUserRepository.updateUserMusicCount(
      //     currentMusicData.value.category, currentMusicData.value.title);

      // music-category=title/count update..
      // FirebaseMusicRepository.updateClassicMusicCount(
      //     currentMusicData.value.category, currentMusicData.value.title);
    });
  }

  void authStateChanges(User firebaseUser) async {
    if (firebaseUser != null) {
      // userInfoComplete();

      UserModel userModel =
          await FirebaseUserRepository.findUserByUid(firebaseUser.uid);
      if (userModel != null) {
        initUserProfile = userModel;
        FirebaseUserRepository.updateLastLoginDate(
            userModel.docId, DateTime.now().toString());
// 유저개인 music-data가 없을때 firestore-user-userPlayList 추가
        userPlayListSet(userModel.docId);
      } else {
        // userInfoCheck.update((val) {
        //   val = false;
        // });

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
    userInfoComplete();
    // FirebaseUserRepository.updateUserMusic(initUserProfile.docId);
    print(userInfoCheck);
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

  void updateListener(String listener) {
    userProfile.update((val) {
      val.listener = listener;
    });
  }

  void save() {
    initUserProfile = userProfile.value;
    FirebaseUserRepository.updateData(initUserProfile.docId, initUserProfile);
    userInfoComplete();
  }

// ㅎㅚ원 정보가 db에 저장되어있는지 체크하는 함수
  void userInfoComplete() {
    if (userProfile.value.birth.length > 2 &&
        userProfile.value.gender.length > 2) {
      userInfoCheck.update((val) {
        val = true;
      });

      userInfoCheck.value = true;
      update();
    } else {
      // userInfoCheck.value = false;
      userInfoCheck.update((val) {
        val = false;
      });
    }
    print(userProfile.value.birth);
    print(userProfile.value.gender);

    update();
  }

// 오류 있음.
  void addUserMusicData() {
    initUserProfile = userProfile.value;
    // FirebaseUserRepository.updateUserMusic(initUserProfile.docId);
    // FirebaseUserRepository.addMusic(initUserProfile.docId);

    // FirebaseMusicRepository.initMusicData();

    // user repository - user - music data가 있는지

    // init music list 가져오기
    // FirebaseMusicRepository.getInitMusicList();
    // FirebaseMusicRepository.updateMusicCount(
    //     "classic", "Brandenburg Concerto No.3");
    // update();
  }

  // void musicDataAdd() async {
  //   String docId = await FirebaseMusicRepository.addMusicData(initMusic.value);

  //   updateDocId(docId);
  //   // FirebaseMusicRepository.initMusicData();
  // }

  // void musicDataUpdate() {
  //   FirebaseMusicRepository.updateMusicData(
  //       initMusic.value.docId, initMusic.value);
  // }

  void updateDocId(String docId) {
    initMusic.update((val) {
      val.docId = docId;
    });
  }

  void updateCurrentMusic(String title) {
    initMusic.update((val) {
      val.title = title;
    });
  }

  void updateCurrentCategory(String category) {
    currentMusicData.update((val) {
      val.category = category;
    });
  }

  void updateCurrentMusicTitle(String title) {
    currentMusicData.update((val) {
      val.title = title;
    });
  }

  void updateCurrentMusicDesc(String desc) {
    currentMusicData.update((val) {
      val.desc = desc;
    });
  }

  void updateCurrentMusicIndex(int index) {
    currentMusicData.update((val) {
      val.index = index;
    });
  }

  // 유저 firestore=user=music data-userPlayList 생성
  void userPlayListSet(String docId) {
    FirebaseUserRepository.updateUserMusic(docId, "nurseryRhymes");
    FirebaseUserRepository.updateUserMusic(docId, "soundTrack");
    FirebaseUserRepository.updateUserMusic(docId, "classic");
    FirebaseUserRepository.updateUserMusic(docId, "world");
    FirebaseUserRepository.updateUserMusic(docId, "newAge");
  }

// db에 점수 업데이트시켜주는 함수
  void updateCountData() {
    // music-category=title/count update..
    // FirebaseMusicRepository.updateClassicMusicCount(
    //     currentMusicData.value.category, currentMusicData.value.title);

    FirebaseUserRepository.updateUserMusicCount(
        currentMusicData.value.category, currentMusicData.value.title);
  }
}

class CurrentMusicData {
  String desc;
  String title;
  String category;
  int index;

  CurrentMusicData({this.desc, this.title, this.category, this.index});
}
