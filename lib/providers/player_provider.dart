import 'dart:async';
import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/mock_data.dart';

enum RepeatMode { off, all, one }

enum PlayerState { idle, playing, paused, loading }

class PlayerProvider extends ChangeNotifier {
  // 当前播放状态
  PlayerState _playerState = PlayerState.idle;
  Song? _currentSong;
  List<Song> _queue = [];
  int _currentIndex = -1;

  // 播放进度
  Duration _position = Duration.zero;
  Duration _bufferedPosition = Duration.zero;
  Timer? _positionTimer;

  // 播放模式
  bool _shuffle = false;
  RepeatMode _repeatMode = RepeatMode.off;

  // 音量
  double _volume = 1.0;

  // Getters
  PlayerState get playerState => _playerState;
  Song? get currentSong => _currentSong;
  List<Song> get queue => _queue;
  int get currentIndex => _currentIndex;
  Duration get position => _position;
  Duration get bufferedPosition => _bufferedPosition;
  bool get shuffle => _shuffle;
  RepeatMode get repeatMode => _repeatMode;
  double get volume => _volume;
  bool get isPlaying => _playerState == PlayerState.playing;
  bool get hasNext => _currentIndex < _queue.length - 1 || _repeatMode != RepeatMode.off;
  bool get hasPrevious => _currentIndex > 0 || _repeatMode != RepeatMode.off;

  // 进度百分比
  double get progress {
    if (_currentSong == null) return 0;
    final total = _currentSong!.duration.inMilliseconds;
    if (total == 0) return 0;
    return _position.inMilliseconds / total;
  }

  // 播放歌曲
  Future<void> play(Song song, {List<Song>? playlist}) async {
    _playerState = PlayerState.loading;
    notifyListeners();

    if (playlist != null) {
      _queue = List.from(playlist);
      _currentIndex = _queue.indexWhere((s) => s.id == song.id);
      if (_currentIndex == -1) {
        _queue.insert(0, song);
        _currentIndex = 0;
      }
    } else if (_queue.isEmpty) {
      _queue = [song];
      _currentIndex = 0;
    } else {
      final existingIndex = _queue.indexWhere((s) => s.id == song.id);
      if (existingIndex != -1) {
        _currentIndex = existingIndex;
      } else {
        _queue.insert(_currentIndex + 1, song);
        _currentIndex++;
      }
    }

    _currentSong = song;
    _position = Duration.zero;

    // 模拟加载延迟
    await Future.delayed(const Duration(milliseconds: 300));

    _playerState = PlayerState.playing;
    _startPositionTimer();
    notifyListeners();
  }

  // 播放/暂停切换
  void togglePlayPause() {
    if (_currentSong == null) return;

    if (_playerState == PlayerState.playing) {
      pause();
    } else {
      resume();
    }
  }

  // 暂停
  void pause() {
    if (_playerState != PlayerState.playing) return;
    _playerState = PlayerState.paused;
    _stopPositionTimer();
    notifyListeners();
  }

  // 恢复播放
  void resume() {
    if (_currentSong == null) return;
    _playerState = PlayerState.playing;
    _startPositionTimer();
    notifyListeners();
  }

  // 停止
  void stop() {
    _playerState = PlayerState.idle;
    _currentSong = null;
    _position = Duration.zero;
    _stopPositionTimer();
    notifyListeners();
  }

  // 下一首
  Future<void> next() async {
    if (_queue.isEmpty) return;

    int nextIndex;
    if (_shuffle) {
      nextIndex = _getRandomIndex();
    } else if (_currentIndex < _queue.length - 1) {
      nextIndex = _currentIndex + 1;
    } else if (_repeatMode == RepeatMode.all) {
      nextIndex = 0;
    } else {
      return;
    }

    await play(_queue[nextIndex]);
  }

  // 上一首
  Future<void> previous() async {
    if (_queue.isEmpty) return;

    // 如果播放超过3秒，重新播放当前歌曲
    if (_position.inSeconds > 3) {
      seekTo(Duration.zero);
      return;
    }

    int prevIndex;
    if (_shuffle) {
      prevIndex = _getRandomIndex();
    } else if (_currentIndex > 0) {
      prevIndex = _currentIndex - 1;
    } else if (_repeatMode == RepeatMode.all) {
      prevIndex = _queue.length - 1;
    } else {
      seekTo(Duration.zero);
      return;
    }

    await play(_queue[prevIndex]);
  }

  // 跳转到指定位置
  void seekTo(Duration position) {
    if (_currentSong == null) return;
    if (position < Duration.zero) {
      _position = Duration.zero;
    } else if (position > _currentSong!.duration) {
      _position = _currentSong!.duration;
    } else {
      _position = position;
    }
    notifyListeners();
  }

  // 跳转到百分比位置
  void seekToPercent(double percent) {
    if (_currentSong == null) return;
    final newPosition = Duration(
      milliseconds: (_currentSong!.duration.inMilliseconds * percent).round(),
    );
    seekTo(newPosition);
  }

  // 切换随机播放
  void toggleShuffle() {
    _shuffle = !_shuffle;
    notifyListeners();
  }

  // 切换循环模式
  void toggleRepeatMode() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    notifyListeners();
  }

  // 设置音量
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  // 添加到队列
  void addToQueue(Song song) {
    _queue.add(song);
    notifyListeners();
  }

  // 从队列移除
  void removeFromQueue(int index) {
    if (index < 0 || index >= _queue.length) return;
    if (index == _currentIndex) return;

    _queue.removeAt(index);
    if (index < _currentIndex) {
      _currentIndex--;
    }
    notifyListeners();
  }

  // 清空队列
  void clearQueue() {
    if (_currentSong != null) {
      _queue = [_currentSong!];
      _currentIndex = 0;
    } else {
      _queue.clear();
      _currentIndex = -1;
    }
    notifyListeners();
  }

  // 播放队列中的歌曲
  Future<void> playFromQueue(int index) async {
    if (index < 0 || index >= _queue.length) return;
    await play(_queue[index]);
  }

  // 喜欢/取消喜欢当前歌曲
  void toggleLike() {
    if (_currentSong == null) return;
    _currentSong = _currentSong!.copyWith(isLiked: !_currentSong!.isLiked);

    // 更新队列中的歌曲
    final index = _queue.indexWhere((s) => s.id == _currentSong!.id);
    if (index != -1) {
      _queue[index] = _currentSong!;
    }

    notifyListeners();
  }

  // 私有方法

  int _getRandomIndex() {
    if (_queue.length <= 1) return 0;
    int newIndex;
    do {
      newIndex = DateTime.now().millisecondsSinceEpoch % _queue.length;
    } while (newIndex == _currentIndex);
    return newIndex;
  }

  void _startPositionTimer() {
    _stopPositionTimer();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_playerState != PlayerState.playing || _currentSong == null) return;

      _position += const Duration(milliseconds: 200);
      _bufferedPosition = _position + const Duration(seconds: 5);

      // 歌曲播放完成
      if (_position >= _currentSong!.duration) {
        _onSongComplete();
      }

      notifyListeners();
    });
  }

  void _stopPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  void _onSongComplete() {
    if (_repeatMode == RepeatMode.one) {
      seekTo(Duration.zero);
      return;
    }
    next();
  }

  @override
  void dispose() {
    _stopPositionTimer();
    super.dispose();
  }

  // 初始化默认队列
  void initDefaultQueue() {
    if (_queue.isEmpty) {
      _queue = List.from(MockData.songs);
    }
  }
}
