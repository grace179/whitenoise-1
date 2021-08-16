import 'package:bi_whitenoise/data/music_list.dart';
import 'package:bi_whitenoise/model/music_model.dart';
// import 'package:bi_whitenoise/pages/player.dart';
// import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';

class FirebaseMusicRepository {
  static Future<String> addMusicData(MusicModel music) async {
    CollectionReference musics =
        FirebaseFirestore.instance.collection('musics');
    DocumentReference drf = await musics.add(music.toMap());
    return drf.id;
  }

// 음악재생하면 디비에서 데이터 찾아서 ( 조건문: 제목으로 비교..)
// user repository 하위 music data 에 있는 count
// music data 구조
// toMap
  dynamic musicData = {
    "Song/Piece": "Daisy Daisy",
    "Composer/Artist": "Brown Owl",
    "Genre": "Nursery Rhymes",
    "Main Instrument": "Guitar",
    "Other Instruments": "",
    "Tempo (BPM)": "55",
    "Tonality": "Major",
    "count": 0,
    "musicLike": 0,
    "url": ""
  };

// 음악재생되면 재생 횟수 증가함수
// count data +1

//유저에게 저장된 플레이리스트가 없을때 불러올 플레이리스트
// 맨 처음 불러오는 플레이리스트를 저장할 db
  static void initMusicData() async {
    // static void updateMusicData(String docId, MusicModel music) {
    CollectionReference musics =
        FirebaseFirestore.instance.collection('musics');

    dynamic musicPlayList = musicList;
    // DocumentReference drf = await musics.add({"listName": "initPlayList"});
    // String docId = drf.id;

    for (var i = 0; i < musicPlayList.length; i++) {
      // late String collectionName;

      // if (musicPlayList[i]["Genre"] == "Classical") {
      //   collectionName = "classic";
      //   // MusicModel music = Map<String, dynamic> musicPlayList[i];

      //   // musics.doc().collection("Classical").add({
      //   // DocumentReference drf =
      // } else if (musicPlayList[i]["Genre"] == "New Age") {
      //   collectionName = "newAge";
      // } else if (musicPlayList[i]["Genre"] == "Nursery Rhymes") {
      //   collectionName = "nurseryRhymes";
      // } else if (musicPlayList[i]["Genre"] == "World") {
      //   collectionName = "world";
      // } else if (musicPlayList[i]["Genre"] == "Soundtrack") {
      //   collectionName = "soundTrack";
      // }
// doc에 데이터가 없으면 쿼리문 실행이 안됨

      musics.get().then((value) {
        print(value.docs[0].id);

        value.docs.forEach((element) async {
          print(element.data());
          musics.doc(value.docs[0].id).collection("world").add(
            {
              "index": i,
              "songPiece": musicPlayList[i]["Song/Piece"],
              "artist": musicPlayList[i]["Composer/Artist"],
              "category": musicPlayList[i]["Genre"],
              "mainInstrument": musicPlayList[i]["Main Instrument"],
              "otherInstruments": musicPlayList[i]["Other Instruments"],
              "tempo": musicPlayList[i]["Tempo (BPM)"],
              "tonality": musicPlayList[i]["Tonality"],
              "count": musicPlayList[i]["count"],
              "url": musicPlayList[i]["url"],
              "like": musicPlayList[i]["like"],
              "dislike": musicPlayList[i]["dislike"]
            },
          );
          // QuerySnapshot data = await musics.where("listName", isEqualTo:"initPlayList").get();
          // print(data.docs);

          // firestore - musics - classic(category name)
          // CollectionReference classiclist =
          //     musics.doc(value.docs[0].id).collection("classic");
        });
      });
    }
  }
  // List<AudioSource> initClassicList = [];

// category, title 비교해서 재생중인 음악의 count 증가
  static void updateClassicMusicCount(String categoryName, String title) {
    // firestore - musics
    CollectionReference musics =
        FirebaseFirestore.instance.collection('musics');

// users.doc(docId).collection("music-data"
    musics.get().then((value) {
      print(value.docs[0].id);

      value.docs.forEach((element) async {
        print(element.data());
        // QuerySnapshot data = await musics.where("listName", isEqualTo:"initPlayList").get();
        // print(data.docs);

        // firestore - musics - classic(category name)
        CollectionReference classiclist =
            musics.doc(value.docs[0].id).collection(categoryName);
        // 현재 재생 음악과 제목이 일치하는 doc 찾아서 count update
        QuerySnapshot data =
            await classiclist.where("songPiece", isEqualTo: title).get();

        if (data.size == 0) {
          return null;
        } else {
          print("title equal data");
          print(data.docs[0].data());
          int count = data.docs[0].data()["count"];
          print(data.docs[0].id);
          classiclist.doc(data.docs[0].id).update({"count": count + 1});
          // return UserModel.fromJson(data.docs[0].data(), data.docs[0].id);

        }
      });
    });
  }

// user - music data 가 없을때 데이터를 추가하는 함수

  // 음악 데이터 찾아서 count update

}
