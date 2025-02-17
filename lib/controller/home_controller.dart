import 'package:get/state_manager.dart';
import 'package:musicplaylistapp/constants/music_list.dart';
import 'package:musicplaylistapp/models/music_model.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeController extends GetxController {
  RxList<MusicModel> playlist = RxList(musicList);
  final player = AudioPlayer();
  final RxInt _currentSong = RxInt(0);
  final RxBool _isPlay = RxBool(false);
  final RxBool _showPlaying = RxBool(false);
  final RxDouble _currentPosition = RxDouble(0.0);
  Duration _duration = const Duration(milliseconds: 0);
  Duration _position = const Duration(milliseconds: 0);

  @override
  void onInit() {
    super.onInit();
    _playerListener();
  }

//listen player
  void _playerListener() {
    player.onDurationChanged.listen((duration) {
      _duration = duration;
    });

    player.onPositionChanged.listen((p) {
      _position = p;
      setPosition();
    });

    player.onPlayerComplete.listen((event) {
      _currentSong.value =
          (_currentSong.value < 5) ? _currentSong.value + 1 : 0;
      play(_currentSong.value);
    });
  }

  //press button play
  void play(int index) async {
    _showPlaying.value = true;
    _currentSong.value = index;
    _isPlay.value = true;
    await player.release();
    await player.play(AssetSource(playlist[index].musicPath));
  }

  //press button pause
  void pause() async {
    _isPlay.value = false;
    await player.pause();
  }

  //press button resume
  void resume() async {
    _isPlay.value = true;
    await player.resume();
  }

//press button close bottom playing
  void close() async {
    _showPlaying.value = false;
    await player.release();
  }

//when seek forward or seek backward with slider
  void seek(value) async {
    var _position = value * _duration.inMilliseconds;
    await player.seek(Duration(milliseconds: _position.round()));
  }

//set position when play music
  void setPosition() {
    _currentPosition.value = (_position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  int get currentSong => _currentSong.value;
  bool get isPlaying => _isPlay.value;
  bool get showPlaying => _showPlaying.value;
  double get currentPosition => _currentPosition.value;
}
