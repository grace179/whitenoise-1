import 'package:bi_whitenoise/data/music_list.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MusicPlayList {
//  db에 있는 classic music list로 playlist settingl (player, category(genre 이름))
  // firestore - musics - initPlayList
  static void initClassicList(AudioPlayer player, String category) async {
    ConcatenatingAudioSource playlist;

    CollectionReference musics =
        FirebaseFirestore.instance.collection('musics');

    late List<AudioSource> list;

    int _nextMediaId = 0;

    list = [
      AudioSource.uri(
        Uri.parse("asset:///assets/Ocean-10min.mp3"),
        tag: MediaItem(
            album: "Public Domain",
            title: "Nature Sounds",
            id: '${_nextMediaId++}'),
      ),
    ];

    playlist = ConcatenatingAudioSource(children: list);

    musics.get().then((value) {
      print(value.docs[0].id);
      // list.removeLast();
      value.docs.forEach((element) {
        print(element.data());

// 점수대로 정렬
        musics
            .doc(value.docs[0].id)
            .collection(category)
            .orderBy("count", descending: true)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            print(result.data());

            // init classic play list
            playlist.add(
              AudioSource.uri(
                Uri.parse('${result.data()["url"]}'),
                tag: MediaItem(
                    album: '${result.data()["artist"]}',
                    title: '${result.data()["songPiece"]}',
                    id: '${_nextMediaId++}'),
              ),
            );
            print(list);
            print('classic data');
            // user- music data null?
          });
        });
      });
    });
    // playlist.addAll(list);
    playlist.removeAt(0);

    await player.setAudioSource(playlist);
    print(playlist);
  }

// firestore - user - music data - userPlayList
  static void userMusicList(AudioPlayer player, String category) async {
    final _userController = Get.put(UserController());

    ConcatenatingAudioSource playlist;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // 개인 유저의 music
    CollectionReference musicData = users
        .doc(_userController.userProfile.value.docId)
        .collection('musicData');

    late List<AudioSource> list;
    int _nextMediaId = 0;

    list = [
      AudioSource.uri(
        Uri.parse("asset:///assets/Ocean-10min.mp3"),
        tag: MediaItem(
            album: "Public Domain",
            title: "Nature Sounds",
            id: '${_nextMediaId++}'),
      ),
    ];

    playlist = ConcatenatingAudioSource(children: list);

    musicData.get().then((value) {
      print(value.docs[0].id);
      // list.removeLast();
      value.docs.forEach((element) {
        print(element.data());

        musicData
            .doc(value.docs[0].id)
            .collection(category)
            .orderBy("count", descending: true)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            print(result.data());

            // init classic play list
            playlist.add(
              AudioSource.uri(
                Uri.parse('${result.data()["url"]}'),
                tag: MediaItem(
                    album: '${result.data()["artist"]}',
                    title: '${result.data()["songPiece"]}',
                    id: '${_nextMediaId++}'),
              ),
            );
            print(list);
            print('classic data');
            // user- music data null?
          });
        });
      });
    });
    // playlist.addAll(list);
    playlist.removeAt(0);

    await player.setAudioSource(playlist);
    print(playlist);
  }

  static void localClassicPlayList(AudioPlayer player) async {
    dynamic musicPlayList = musicList;

    ConcatenatingAudioSource playlist;

    late List<AudioSource> list;

    int _nextMediaId = 0;

    list = [
      AudioSource.uri(
        Uri.parse("asset:///assets/Ocean-10min.mp3"),
        tag: MediaItem(
            album: "Public Domain",
            title: "Nature Sounds",
            id: '${_nextMediaId++}'),
      ),
    ];

    playlist = ConcatenatingAudioSource(children: list);

    for (var i = 0; i < musicPlayList.length; i++) {
      if (musicPlayList[i]["Genre"] == "Classical") {
        playlist.add(
          AudioSource.uri(
            Uri.parse(musicPlayList[i]["url"]),
            tag: MediaItem(
                album: musicPlayList[i]["Composer/Artist"],
                title: musicPlayList[i]["Song/Piece"],
                id: '${_nextMediaId++}'),
          ),
        );
      }
      // print(musicPlayList[i]["Genre"]);

    }
    playlist.removeAt(0);

    await player.setAudioSource(playlist);
  }
}
