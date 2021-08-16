// @dart=2.9
import 'package:bi_whitenoise/model/user_model.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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

// user-music data가 있는지 확인하는 함수
  static void updateLastLoginDate(String docId, String time) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).update({"lastLoginTime": time});
  }

  static void updateData(String docId, UserModel user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).update(user.toMap());
  }

  // static void updateMusicData(String docId, MusicModel music) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   users.doc(docId).collection('music_data').add(music.toMap());
  // }

  static void updateUserMusic(String docId, String category) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
// user - music data = null 이면 initMusicPlayList를 music data에 추가
// music data null인지 check
    CollectionReference musics =
        FirebaseFirestore.instance.collection("musics");

    users.get().then((value) async {
      CollectionReference musicData = users.doc(docId).collection('musicData');

      QuerySnapshot userMusicData = await musicData.get();

      // QuerySnapshot musicInitData =
      //     await musics.where("listName", isEqualTo: "initPlayList").get();

      if (userMusicData.size == 0) {
        //  user= music data 추가

        musics.get().then((value) {
          print(value.docs[0].id);
          // list.removeLast();
          value.docs.forEach((element) {
            print(element.data());

            musics
                .doc(value.docs[0].id)
                .collection(category)
                .orderBy("count", descending: true)
                .get()
                .then((value) {
              value.docs.forEach((result) {
                print(result.data());

                musicData.doc('userPlayList').set({"listName": "userPlayList"});
                musicData.doc('userPlayList').collection(category).add({
                  "songPiece": '${result.data()["songPiece"]}',
                  "artist": '${result.data()["artist"]}',
                  "count": 0,
                  "mainInstrument": '${result.data()["mainInstrument"]}',
                  "tempo": '${result.data()["tempo"]}',
                  "url": '${result.data()["url"]}',
                });
              });
            });
          });
        });
      }
    });

    // users.doc(docId)
    //   .collection('music_data')
    //   .doc(categoryName)
    //   .set({"title":title,
    //   "count":1});
  }

// category, title 비교해서 재생중인 음악의 count 증가
  static void updateUserMusicCount(String categoryName, String title) {
    final _userController = Get.put(UserController());

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // CollectionReference musics =
    //     FirebaseFirestore.instance.collection("musics");

    CollectionReference musicData = users
        .doc(_userController.userProfile.value.docId)
        .collection('musicData');

    musicData.get().then((value) async {
      // QuerySnapshot userMusicData = await musicData.get();

      // print('musicData doc id ${value.docs[0].id}');

      value.docs.forEach((element) async {
        // print(element.data());
        // QuerySnapshot data = await musics.where("listName", isEqualTo:"initPlayList").get();
        // print(data.docs);

        // firestore - user- music data - classic(category name)
        CollectionReference list =
            musicData.doc(value.docs[0].id).collection(categoryName);
        // 현재 재생 음악과 제목이 일치하는 doc 찾아서 count update
        QuerySnapshot data =
            await list.where("songPiece", isEqualTo: title).get();

        if (data.size == 0) {
          return null;
        } else {
          print("title equal data");
          print(data.docs[0].data());
          int count = data.docs[0].data()["count"];
          print(data.docs[0].id);
          list.doc(data.docs[0].id).update({"count": count + 1});
        }
//
// citiesRef.whereIn("country", Arrays.asList("USA", "Japan"));

//
// list에서 artist, instrument 일치하는 데이터들의 점수 업데이트
// 현재 artist
        String artist = data.docs[0].data()["artist"];
        print('artist $artist');

// artist 일치하는 데이터
        QuerySnapshot artistDatas =
            await list.where("artist", isEqualTo: artist).get();
        if (artistDatas.size == 0) {
          return null;
        } else {
          artistDatas.docs.forEach((element) {
            print('artistDatas ${element.data()}');
            int count = element.data()["count"];
            // print(count.toString());
            list.doc(element.id).update({"count": count + 1});
          });
        }

// 현재 재생곡 동일 악기 데이터 점수 업데이트
        String instrument = data.docs[0].data()["mainInstrument"];
        QuerySnapshot instrumentDatas =
            await list.where("mainInstrument", isEqualTo: instrument).get();
        if (instrumentDatas.size == 0) {
          return null;
        } else {
          instrumentDatas.docs.forEach((element) {
            print('instrumentDatas ${element.data()}');
            int count = element.data()["count"];
            print(count.toString());
            list.doc(element.id).update({"count": count + 1});
          });
        }

// 현재 재생곡 동일 악기 데이터 점수 업데이트
        String tempo = data.docs[0].data()["tempo"];
        QuerySnapshot tempoDatas =
            await list.where("tempo", isEqualTo: tempo).get();
        if (tempoDatas.size == 0) {
          return null;
        } else {
          tempoDatas.docs.forEach((element) {
            print('tempoDatas ${element.data()}');
            int count = element.data()["count"];
            // print(count.toString());
            list.doc(element.id).update({"count": count + 1});
          });
        }
//
      });
    });
  }
}
