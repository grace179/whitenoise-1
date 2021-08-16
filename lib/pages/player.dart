import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:bi_whitenoise/components/app_title.dart';
import 'package:bi_whitenoise/components/category_banner.dart';
// import 'package:bi_whitenoise/components/category_btn.dart';
import 'package:bi_whitenoise/components/music_list.dart';
import 'package:bi_whitenoise/components/scroll_category_btn.dart';
import 'package:bi_whitenoise/components/sound_banner.dart';
import 'package:bi_whitenoise/data/user_play_list.dart';
// import 'package:bi_whitenoise/src/firebase_music_storage.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:rxdart/rxdart.dart' as rd;
import 'package:bi_whitenoise/data/color.dart';
// import 'package:scroll_to_id/scroll_to_id.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final _userController = Get.put(UserController());
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  // late ScrollToId scrollToId;

  // noise
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  double noiseValue = 0.0;

  final _itemGlobalKey = GlobalKey();

//
  late AudioPlayer _player;

  String _categoryBannerUrl = "assets/banner/banner_classic@4_2.png";
  String _categoryBannerTitle = "Classic";

  // category 5개
// String _category = 'Classic';
  // bool _playlistLoading = false;
  static int _nextMediaId = 0;

  final _playlist = ConcatenatingAudioSource(
    children: [
      ClippingAudioSource(
        // start: Duration(seconds: 60),
        // end: Duration(seconds: 90),
        child: AudioSource.uri(Uri.parse(
            "https://firebasestorage.googleapis.com/v0/b/whitenoise-f7fb4.appspot.com/o/1.%20Groove%20On.m4a?alt=media&token=71993ede-a47c-43c4-bf7b-8a9e8735d5fd")),
        tag: MediaItem(
            album: "mpeg file test", title: "Classic", id: '${_nextMediaId++}'),
      ),
      AudioSource.uri(
        Uri.parse(
            "https://firebasestorage.googleapis.com/v0/b/whitenoise-f7fb4.appspot.com/o/1.%20Groove%20On.m4a?alt=media&token=71993ede-a47c-43c4-bf7b-8a9e8735d5fd"),
        tag:
            MediaItem(album: "test", title: "weekend", id: '${_nextMediaId++}'),
      ),
      AudioSource.uri(
        Uri.parse("asset:///assets/Ocean-10min.mp3"),
        tag: MediaItem(
            album: "Science Friday",
            title: "firebase storage",
            id: '${_nextMediaId++}'),
      ),
      AudioSource.uri(
        Uri.parse("asset:///assets/Ocean-10min.mp3"),
        tag: MediaItem(
            album: "Public Domain", title: "Ocean", id: '${_nextMediaId++}'),
      ),
      AudioSource.uri(
        Uri.file("asset:///assets/Pachelbel_Canon_in_D.ogg"),
        tag: MediaItem(
            album: "ogg music", title: "Ocean", id: '${_nextMediaId++}'),
      ),
      AudioSource.uri(
        Uri.parse("asset:///assets/Ocean-10min.mp3"),
        tag: MediaItem(
            album: "Public Domain",
            title: "Nature Sounds",
            id: '${_nextMediaId++}'),
      ),
    ],
  );

  final scrollDirection = Axis.vertical;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _noiseMeter = new NoiseMeter(onError);
    _userController.updateCurrentCategory("classic");

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    // listMusic();

    // controller = AutoScrollController(
    //     viewportBoundaryGetter: () =>
    //         Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
    //     axis: scrollDirection);
    // randomList = List.generate(maxCount,
    //     (index) => <int>[index, (1000 * random.nextDouble()).toInt()]);
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      // await _player.setAudioSource(_playlist);
      // MusicPlayList.localClassicPlayList(_player);
      MusicPlayList.userMusicList(_player, "classic");
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
    }
    _selectCategoryDialog();
  }

  @override
  void dispose() {
    _player.dispose();
    _noiseSubscription?.cancel();
    super.dispose();
  }

  _getSize(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
  }

  void musicSetting(String category) {
    MusicPlayList.userMusicList(_player, category);
    _userController.updateCurrentCategory(category);
  }

// noise

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    noiseValue = noiseReading.meanDecibel;
    volumeAutoControl();
    print(noiseReading.toString());
  }

  void onError(PlatformException e) {
    print(e.toString());
    _isRecording = false;
  }

  void start() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      width: 150,
      content: Text(
        'noise on',
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 1),
    ));

    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        width: 150,
        content: Text(
          'noise off',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  Future volumeAutoControl() async {
    //
    double currentVol = _player.volume;

    if (_isRecording) {
      double autoVol = 0.1;
      await Future.delayed(Duration(microseconds: 100), () {
        autoVol = noiseValue * 0.007;
      });

      print('volume changed');
      print(autoVol);

      _player.setVolume(autoVol);

      if (autoVol <= 0) {
        await _player.setVolume(0.2);
      } else if (autoVol >= 1) {
        await _player.setVolume(0.9);
      } else {
        await _player.setVolume(autoVol);
      }
    } else if (!_isRecording) {
      _player.setVolume(currentVol);
    }
  }

  int _listCount = 0;

  // scroll jump to function
  _scrollToIndex(index) {
    // print('listview height ${_getSize(_itemGlobalKey).height}');
    // double _listviewHeight = _getSize(_itemGlobalKey).height;
    double _itemHeight = scrollController.position.maxScrollExtent / _listCount;

    // int _minimumItmeCounts = (_listviewHeight / _itemHeight).round() - 3;
    // print('minimum item counts $_minimumItmeCounts');

    if (scrollController.hasClients) {
      if (index < 5) {
        scrollController.animateTo(0,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
      } else if (index > _listCount - 5) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } else {
        scrollController.animateTo(_itemHeight * index,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
      }
    }
  }

// Category Select dialog Modal
  _selectCategoryDialog() {
    final size = MediaQuery.of(context).size;

    return showModalBottomSheet(
      isDismissible: true,
      // enableDrag: true,
      enableDrag: false,

      isScrollControlled: true,
      // isScrollControlled: false,
      // backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          // padding: Padding.,
          color: ColorData.bg,
          // height: size.height,
          child: Column(children: [
            SizedBox(
              height: 100,
            ),
            RichText(
              text: TextSpan(
                text: '${_userController.userProfile.value.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorData.primaryColor,
                  fontSize: 24.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' 님 반갑습니다!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),
            Text(
              '선호하는 장르를 선택해주세요',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'MontserratExtraBold',
                // fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            soundBanner(
              width: size.width * 0.9,
              height: size.height * 0.13,
              categoryName: "Classic",
              imageUrl: "assets/banner/banner_classic@4_1.png",
              onTap: () {
                musicSetting("classic");
                setState(() {
                  _categoryBannerTitle = "Classic";
                  _categoryBannerUrl = "assets/banner/banner_classic@4_2.png";
                  _listCount = _player.sequence!.length;
                });
                Navigator.pop(context);
              },
            ),

            SizedBox(
              height: size.height * 0.015,
            ),

            // 2 New Age
            soundBanner(
              width: size.width * 0.9,
              height: size.height * 0.13,
              categoryName: "New Age",
              imageUrl: "assets/banner/banner_newage@4_1.png",
              onTap: () {
                musicSetting("newAge");
                setState(() {
                  _categoryBannerTitle = "New Age";

                  _categoryBannerUrl = "assets/banner/banner_newage@4_2.png";
                  _listCount = _player.sequence!.length;
                });

                Navigator.pop(context);
              },
            ),

            SizedBox(
              height: size.height * 0.015,
            ),

            // 2 New Age
            soundBanner(
              width: size.width * 0.9,
              height: size.height * 0.13,
              categoryName: "Sound Track",
              imageUrl: "assets/banner/banner_soundtrack@4_1.png",
              onTap: () {
                musicSetting("soundTrack");
                setState(() {
                  _categoryBannerTitle = "Sound Track";

                  _categoryBannerUrl =
                      "assets/banner/banner_soundtrack@4_2.png";

                  _listCount = _player.sequence!.length;
                });

                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: size.height * 0.015,
            ),

            // 2 New Age
            soundBanner(
              width: size.width * 0.9,
              height: size.height * 0.13,
              categoryName: "Nursery Rhymes",
              imageUrl: "assets/banner/banner_nursery@4_1.png",
              onTap: () {
                musicSetting("nurseryRhymes");
                setState(() {
                  _categoryBannerTitle = "Nursery Rhymes";

                  _categoryBannerUrl = "assets/banner/banner_nursery@4_2.png";
                  _listCount = _player.sequence!.length;
                });

                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: size.height * 0.015,
            ),

            // 2 New Age
            soundBanner(
              width: size.width * 0.9,
              height: size.height * 0.13,
              categoryName: "World",
              imageUrl: "assets/banner/banner_world@4_1.png",
              onTap: () {
                musicSetting("world");
                setState(() {
                  _categoryBannerTitle = "World";

                  _categoryBannerUrl = "assets/banner/banner_world@4_2.png";
                  _listCount = _player.sequence!.length;
                });

                Navigator.pop(context);
              },
            ),

            // soundBanner({String categoryName = "", String imageUrl="",onTap}) {
          ]),
        );
      },
    );
  }

  // late AutoScrollController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      color: ColorData.bg,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // header
          Stack(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  alignment: Alignment.center,
                  width: size.width,
                  child: appTitle()),
              Positioned(
                right: 16,
                top: 13,
                child: OutlinedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
// current music category Banner
          categoryBanner(
            width: size.width,
            height: size.height * 0.1,
            categoryName: _categoryBannerTitle,
            imageUrl: _categoryBannerUrl,
            onTap: () {
              // Navigator.pop(context);
              // playlist view hieght
              _scrollToIndex(_player.currentIndex);
            },
          ),

          SizedBox(
            height: 10.0,
          ),
          // scroll category btns
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                scrollCateBtn(
                    category: "Classic",
                    onPressed: () {
                      print("classic button");
                      // MusicPlayList.initClassicList(_player, "classic");
                      MusicPlayList.userMusicList(_player, "classic");

                      _userController.updateCurrentCategory("classic");
                      setState(() {
                        _categoryBannerTitle = "Classic";

                        _categoryBannerUrl =
                            "assets/banner/banner_classic@4_2.png";
                        _listCount = _player.sequence!.length;
                      });
                      // controller.scrollToIndex(4);
                      // 현재 재생곡 index로 이동
                      // scrollToId.animateTo('${_player.currentIndex}',
                      //     duration: Duration(milliseconds: 500),
                      //     curve: Curves.ease);
                      // UserController.to.addUserMusicData();
                    }),
                SizedBox(
                  width: 10,
                ),
                scrollCateBtn(
                    category: "New Age",
                    onPressed: () {
                      print("classic button");
                      // MusicPlayList.initClassicList(_player, "newAge");
                      MusicPlayList.userMusicList(_player, "newAge");
                      _userController.updateCurrentCategory("newAge");
                      setState(() {
                        _categoryBannerTitle = "New Age";

                        _categoryBannerUrl =
                            "assets/banner/banner_newage@4_2.png";
                        _listCount = _player.sequence!.length;
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                scrollCateBtn(
                    category: "Sound Track",
                    onPressed: () {
                      print("classic button");
                      // MusicPlayList.initClassicList(_player, "soundTrack");
                      MusicPlayList.userMusicList(_player, "soundTrack");

                      _userController.updateCurrentCategory("soundTrack");
                      setState(() {
                        _categoryBannerTitle = "Sound Track";

                        _categoryBannerUrl =
                            "assets/banner/banner_soundtrack@4_2.png";
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                scrollCateBtn(
                    category: "Nursery Rhymes",
                    onPressed: () {
                      print("classic button");
                      // MusicPlayList.initClassicList(_player, "nurseryRhymes");
                      MusicPlayList.userMusicList(_player, "nurseryRhymes");

                      _userController.updateCurrentCategory("nurseryRhymes");
                      setState(() {
                        _categoryBannerTitle = "Nursery Rhymes";

                        _categoryBannerUrl =
                            "assets/banner/banner_nursery@4_2.png";
                        _listCount = _player.sequence!.length;
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                scrollCateBtn(
                    category: "World",
                    onPressed: () {
                      print("classic button");
                      // MusicPlayList.initClassicList(_player, "world");
                      MusicPlayList.userMusicList(_player, "world");

                      _userController.updateCurrentCategory("world");
                      setState(() {
                        _categoryBannerTitle = "World";

                        _categoryBannerUrl =
                            "assets/banner/banner_world@4_2.png";
                        _listCount = _player.sequence!.length;
                      });
                    }),
              ],
            ),
          ),

          SizedBox(
            height: 10.0,
          ),
          //Play list view
          Expanded(
            child: Container(
              height: size.height * 0.5,

              // padding: EdgeInsets.only(bottom: 30),
              // height: 440,

              child: Stack(
                children: [
                  Container(
                    color: ColorData.bgColor,
                    // child: Center(child: CircularProgressIndicator()),
                  ),
                  StreamBuilder<SequenceState?>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      final currentItem = state?.currentSource;

                      final musicTitle = currentItem?.tag.title as String;
                      _listCount = sequence.length;

                      // _userController.updateCurrentMusicTitle(musicTitle);
                      // _userController
                      //     .updateCurrentMusicIndex(currentItem?.tag.id);
                      // _userController
                      //     .updateCurrentMusicDesc(currentItem?.tag.album);

                      print(_userController.currentMusicData.value);

                      for (var i = 0; i < sequence.length; i++) {
                        // int currentMusicIndex = _player.currentIndex;

                        if (i == _player.currentIndex) {
                          _userController.updateCurrentMusicTitle(musicTitle);
                          _userController.updateCurrentMusicIndex(i);
                          _userController
                              .updateCurrentMusicDesc(sequence[i].tag.album);

                          print(_userController.currentMusicData.value);
                        }
                        // return InteractiveScrollViewer(
                        //   scrollToId: scrollToId,
                        //   // scrollDirection: scrollDirection,
                        //   children: List.generate(
                        //     sequence.length,
                        //     (i) => ScrollContent(
                        //       id: sequence[i] gg2w w 11.tag.id,
                        //       child: customListTile(
                        //         title: sequence[i].tag.title,
                        //         // cover: sequence[i].tag.artwork,
                        //         desc: sequence[i].tag.album,
                        //         color: sequence[i].tag.title == state.currentSource!.tag.title.toString()
                        //             ? ColorData.bgFocusColor
                        //             : ColorData.bgColor,
                        //         onTap: () {
                        //           _player.seek(Duration.zero, index: i);
                        //           if (!_player.playing) {
                        //             _player.play();
                        //             // controller.scrollToIndex(i);
                        //             print(
                        //                 'current music index ${_player.currentIndex}');
                        //             print(i);
                        //             // print(currentItem!.tag.title);
                        //           }
                        //         },
                        //         // duration: sequence[i].duration.toString(),
                        //         // duration: sequence[i].tag.duration,
                        //       ),
                        //     ),
                        //   ),
                        // );
                        return Scrollbar(
                          controller: scrollController,
                          isAlwaysShown: true,
                          showTrackOnHover: true,
                          thickness: 10,
                          child: CustomScrollView(
                            controller: scrollController,
                            // key: _itemGlobalKey,
                            scrollDirection: scrollDirection,
                            slivers: <Widget>[
                              // SliverAppBar(),
                              // for (var i = 0; i < sequence.length; i++)
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) {
                                    return customListTile(
                                        title: sequence[i].tag.title as String,
                                        // cover: sequence[i].tag.artwork,
                                        desc: sequence[i].tag.album,
                                        color: i == state!.currentIndex
                                            ? ColorData.primaryStrongColor
                                            : ColorData.bgColor,
                                        currentMusic: i == state.currentIndex
                                            ? true
                                            : false,
                                        onTap: () {
                                          _player.seek(Duration.zero, index: i);
                                          if (!_player.playing) {
                                            _player.play();
                                            // controller.scrollToIndex(i);
                                            print('---------------------');

                                            print(
                                                'current music index ${_player.currentIndex}');
                                          }
                                        }
                                        // duration: sequence[i].duration.toString(),
                                        // duration: sequence[i].tag.duration,
                                        );
                                  },
                                  childCount: sequence.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ),

          // Seek Bar slider
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<Duration?>(
                stream: _player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<PositionData>(
                    stream:
                        rd.Rx.combineLatest2<Duration, Duration, PositionData>(
                            _player.positionStream,
                            _player.bufferedPositionStream,
                            (position, bufferedPosition) =>
                                PositionData(position, bufferedPosition)),
                    builder: (context, snapshot) {
                      final positionData = snapshot.data ??
                          PositionData(Duration.zero, Duration.zero);
                      var position = positionData.position;
                      if (position > duration) {
                        // user music repository count update
                        _userController.updateCountData();
                        print('----Current Music ----');
                        print(_userController.currentMusicData.value.title);
                        //
                        position = duration;
                      }
                      var bufferedPosition = positionData.bufferedPosition;
                      if (bufferedPosition > duration) {
                        bufferedPosition = duration;
                      }
                      return SeekBar(
                        duration: duration,
                        position: position,
                        bufferedPosition: bufferedPosition,
                        onChangeEnd: (newPosition) {
                          _player.seek(newPosition);
                        },
                      );
                    },
                  );
                },
              ),

              controlButtons(_player),

              // SizedBox(
              //   height: 10,
              // ),

              // noise meter btn
              // InkWell(
              //   onTap: () {
              //     _isRecording ? stop() : start();
              //   },
              //   child: Stack(
              //     alignment: Alignment.center,
              //     children: <Widget>[
              //       Container(
              //         height: 60,
              //         width: 60,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(50.0),
              //           image: DecorationImage(
              //             image: AssetImage('assets/violetColorBtn.png'),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       ),
              //       Text(
              //         noiseValue.toInt().toString(),
              //         textAlign: TextAlign.center,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // musicPlay() {
  //   this.player.play();
  // }

  Widget controlButtons(AudioPlayer player) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: Colors.white,
            ),
            iconSize: 50.0,
            onPressed: player.hasPrevious
                ? () {
                    player.seekToPrevious();
                    _scrollToIndex(player.currentIndex);
                  }
                : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 54.0,
                height: 54.0,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  backgroundColor: ColorData.primaryColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ColorData.primaryStrongColor),
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: () {
                  player.play();
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(
                  // Icons.replay,
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(
              Icons.skip_next,
              color: Colors.white,
            ),
            iconSize: 50.0,
            onPressed: player.hasNext
                ? () {
                    player.seekToNext();
                    _scrollToIndex(player.currentIndex);
                  }
                : null,
          ),
        ),
      ],
    );
  }
}

// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;
//   final Function callback;

//   ControlButtons(this.player, this.callback);

//   musicPlay() {
//     this.player.play();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         StreamBuilder<SequenceState?>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Icon(
//               Icons.skip_previous,
//               color: Colors.white,
//             ),
//             iconSize: 50.0,
//             onPressed: player.hasPrevious
//                 ? () {
//                     player.seekToPrevious();
//                     callback();
//                   }
//                 : null,
//           ),
//         ),
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: EdgeInsets.all(8.0),
//                 width: 54.0,
//                 height: 54.0,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 6,
//                   backgroundColor: ColorData.primaryColor,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       ColorData.primaryStrongColor),
//                 ),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: Icon(
//                   Icons.play_arrow,
//                   color: Colors.white,
//                 ),
//                 iconSize: 64.0,
//                 onPressed: () {
//                   player.play();
//                 },
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: Icon(
//                   Icons.pause,
//                   color: Colors.white,
//                 ),
//                 iconSize: 64.0,
//                 onPressed: player.pause,
//               );
//             } else {
//               return IconButton(
//                 icon: Icon(
//                   // Icons.replay,
//                   Icons.play_arrow,
//                   color: Colors.white,
//                 ),
//                 iconSize: 64.0,
//                 onPressed: () => player.seek(Duration.zero,
//                     index: player.effectiveIndices!.first),
//               );
//             }
//           },
//         ),
//         StreamBuilder<SequenceState?>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Icon(
//               Icons.skip_next,
//               color: Colors.white,
//             ),
//             iconSize: 50.0,
//             onPressed: player.hasNext
//                 ? () {
//                     player.seekToNext();
//                     callback();
//                   }
//                 : null,
//           ),
//         ),
//       ],
//     );
//   }
// }

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('remain $_remaining.in');
    // print(widget.duration.inMilliseconds);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 10),
        Text(
            // RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
            //         .firstMatch("$_remaining")
            //         ?.group(1) ??
            //     '$_remaining',
            widget.position.toString().split('.')[0].substring(2, 7),
            style: TextStyle(color: Colors.white)
            // Theme.of(context).textTheme.caption,
            ),
        Expanded(
          child: Stack(
            children: [
              SliderTheme(
                data: _sliderThemeData.copyWith(
                  thumbShape: HiddenThumbComponentShape(),
                  activeTrackColor: ColorData.fontDarkColor,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
                child: ExcludeSemantics(
                  child: Slider(
                    min: 0.0,
                    max: widget.duration.inMilliseconds.toDouble(),
                    value: widget.bufferedPosition.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                      if (widget.onChanged != null) {
                        widget
                            .onChanged!(Duration(milliseconds: value.round()));
                      }
                    },
                    onChangeEnd: (value) {
                      if (widget.onChangeEnd != null) {
                        widget.onChangeEnd!(
                            Duration(milliseconds: value.round()));
                      }
                      _dragValue = null;
                    },
                  ),
                ),
              ),
              SliderTheme(
                data: _sliderThemeData.copyWith(
                  // inactiveTrackColor: Colors.transparent,
                  inactiveTrackColor: ColorData.fontDarkColor,
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                ),
                child: Slider(
                  activeColor: ColorData.primaryStrongColor,
                  inactiveColor: ColorData.fontDarkColor,
                  min: 0.0,
                  max: widget.duration.inMilliseconds.toDouble(),
                  value: min(
                      _dragValue ?? widget.position.inMilliseconds.toDouble(),
                      widget.duration.inMilliseconds.toDouble()),
                  onChanged: (value) {
                    setState(() {
                      _dragValue = value;
                      print('drageValue $_dragValue');
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(Duration(milliseconds: value.round()));
                    }
                  },
                  onChangeEnd: (value) {
                    if (widget.onChangeEnd != null) {
                      widget
                          .onChangeEnd!(Duration(milliseconds: value.round()));
                    }
                    _dragValue = null;
                  },
                ),
              ),
              // Positioned(
              //   left: 16.0,
              //   bottom: 0.0,
              //   child: Text(
              //       // RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
              //       //         .firstMatch("$_remaining")
              //       //         ?.group(1) ??
              //       //     '$_remaining',
              //       widget.position.toString().split('.')[0].substring(2, 7),
              //       style: TextStyle(color: Colors.white)
              //       // Theme.of(context).textTheme.caption,
              //       ),
              // ),
              // Positioned(
              //   right: 16.0,
              //   bottom: 0.0,
              //   child: Text(
              //       // RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
              //       //         .firstMatch("$_remaining")
              //       //         ?.group(1) ??
              //       //     '$_remaining',
              //       widget.duration.toString().split('.')[0].substring(2, 7),
              //       style: TextStyle(color: Colors.white)
              //       // Theme.of(context).textTheme.caption,
              //       ),
              // ),
            ],
          ),
        ),
        Text(
            // RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
            //         .firstMatch("$_remaining")
            //         ?.group(1) ??
            //     '$_remaining',
            widget.duration.toString().split('.')[0].substring(2, 7),
            style: TextStyle(color: Colors.white)
            // Theme.of(context).textTheme.caption,
            ),
        SizedBox(width: 10),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

void _showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text(
                '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                style: TextStyle(
                  fontFamily: 'Fixed',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AudioMetadata {
  final String album;
  final String title;
  final String id;

  AudioMetadata({required this.album, required this.title, required this.id});
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}
