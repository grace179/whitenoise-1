import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:bi_whitenoise/components/category_btn.dart';
import 'package:bi_whitenoise/components/music_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bi_whitenoise/data/color.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  // noise
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  double noiseValue = 0.0;

//

  late AudioPlayer _player;

  final _playlist = ConcatenatingAudioSource(children: [
    ClippingAudioSource(
      start: Duration(seconds: 60),
      end: Duration(seconds: 90),
      child: AudioSource.uri(
          Uri.parse("https://www.rainymood.com/audio1112/0.m4a")),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute ",
        artwork:
            "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fG11c2ljJTIwY292ZXJ8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://www.rainymood.com/audio1112/0.m4a"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute To Head",
        artwork:
            "https://images.unsplash.com/photo-1619983081563-430f63602796?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fG11c2ljJTIwYWxidW18ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://www.rainymood.com/audio1112/0.m4a"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "From Cat",
        artwork:
            "https://images.unsplash.com/photo-1512511708753-3150cd2ec8ee?ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cmFpbnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60",
      ),
    ),
    AudioSource.uri(
      Uri.parse("asset:///assets/Ocean-10min.mp3"),
      tag: AudioMetadata(
        album: "Public Domain",
        title: "Ocean",
        artwork:
            "https://images.unsplash.com/photo-1552058456-adc0aabef0b4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8c2ltcGxlfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60",
      ),
    ),
    AudioSource.uri(
      Uri.parse("asset:///assets/Ocean-10min.mp3"),
      tag: AudioMetadata(
        album: "Public Domain",
        title: "Ocean",
        artwork:
            "https://images.unsplash.com/photo-1468581264429-2548ef9eb732?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8b2NlYW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60",
      ),
    ),
    AudioSource.uri(
      Uri.parse("asset:///assets/Ocean-10min.mp3"),
      tag: AudioMetadata(
        album: "Public Domain",
        title: "Nature Sounds",
        artwork:
            "https://images.unsplash.com/photo-1529540005439-99b94814332a?ixid=MnwxMjA3fDB8MHxzZWFyY2h8ODV8fHNpbXBsZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60",
      ),
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _noiseMeter = new NoiseMeter(onError);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
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
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _noiseSubscription?.cancel();
    super.dispose();
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
          borderRadius: BorderRadius.all(Radius.circular(25))),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      width: 150,
      content: Text(
        'noise off',
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 1),
    ));

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

  //

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

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorData.bg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title
              Text(
                'WhiteNoise',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MontserratExtraBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              // Category Button
              OutlinedButton(
                child: Text(
                  'jazz',
                  style: TextStyle(
                    fontFamily: 'MontserratExtraBoldItalic',
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 18.0,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  primary: ColorData.fontWhiteColor,
                  side: BorderSide(
                    color: ColorData.primaryStrongColor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  print('category button pressed');
                  showModalBottomSheet(
                      isDismissible: true,
                      enableDrag: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                          alignment: Alignment.center,
                          height: size.height,
                          width: size.width,
                          child: Column(
                            children: [
                              categoryBtn(btnName: 'Jazz', onTap: () {}),
                              categoryBtn(btnName: 'Classic', onTap: () {}),
                              categoryBtn(btnName: 'Pop', onTap: () {}),
                            ],
                          ),
                        );
                      });
                },
              ),

              SizedBox(
                height: 10.0,
              ),
              //Play list view
              Container(
                // height: size.height*0.9,
                height: 440,

                child: StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final sequence = state?.sequence ?? [];

                    return Scrollbar(
                      controller: _scrollController,
                      isAlwaysShown: true,
                      showTrackOnHover: true,
                      thickness: 10,
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          // SliverAppBar(),
                          // for (var i = 0; i < sequence.length; i++)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                return customListTile(
                                  title: sequence[i].tag.title as String,
                                  cover: sequence[i].tag.artwork,
                                  desc: sequence[i].tag.album,
                                  color: i == state!.currentIndex
                                      ? ColorData.bgFocusColor
                                      : ColorData.bgColor,
                                  onTap: () {
                                    _player.seek(Duration.zero, index: i);
                                  },
                                );
                              },
                              childCount: sequence.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                            Rx.combineLatest2<Duration, Duration, PositionData>(
                                _player.positionStream,
                                _player.bufferedPositionStream,
                                (position, bufferedPosition) =>
                                    PositionData(position, bufferedPosition)),
                        builder: (context, snapshot) {
                          final positionData = snapshot.data ??
                              PositionData(Duration.zero, Duration.zero);
                          var position = positionData.position;
                          if (position > duration) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ControlButtons(_player),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _isRecording ? stop() : start();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            image: DecorationImage(
                              image: AssetImage('assets/violetColorBtn.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          noiseValue.toInt().toString(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
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
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
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
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: player.play,
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
                  Icons.replay,
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
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
      ],
    );
  }
}

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
    return Stack(
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
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
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
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: TextStyle(color: Colors.white)
              // Theme.of(context).textTheme.caption,
              ),
        ),
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
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
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
  final String artwork;

  AudioMetadata(
      {required this.album, required this.title, required this.artwork});
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
