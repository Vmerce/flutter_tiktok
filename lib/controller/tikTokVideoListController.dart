import 'dart:async';
import 'dart:math';

import 'package:flutter_tiktok/mock/video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef LoadMoreVideo = Future<List<VPVideoController>> Function(
  int index,
  List<VPVideoController> list,
);

/// TikTokVideoListController is a controller for a series of videos, which internally manages an array of video controllers
/// Provides more functions for preloading/release/loading
class TikTokVideoListController extends ChangeNotifier {
  TikTokVideoListController({
    this.loadMoreCount = 1,
    this.preloadCount = 2,

    /// TODO: VideoPlayer has a bug (Android), currently it can only be set to 0
    /// After setting to 0, any video that is not in the frame will be released
    /// If not set to 0, Android will not be able to load the third video that starts
    this.disposeCount = 0,
  });

  /// To the first number to trigger preloading, for example: 1: the last one, 2: the second to last
  final int loadMoreCount;

  /// How many videos to preload
  final int preloadCount;

  /// How many more, release the video
  final int disposeCount;

  /// builder that provides video
  LoadMoreVideo? _videoProvider;

  loadIndex(int target, {bool reload = false}) {
    if (!reload) {
      if (index.value == target) return;
    }
    // play the current one, pause the others
    var oldIndex = index.value;
    var newIndex = target;

    // Pause previous video
    if (!(oldIndex == 0 && newIndex == 0)) {
      playerOfIndex(oldIndex)?.controller.seekTo(Duration.zero);
      // playerOfIndex(oldIndex)?.controller.addListener(_didUpdateValue);
      // playerOfIndex(oldIndex)?.showPauseIcon.addListener(_didUpdateValue);
      playerOfIndex(oldIndex)?.pause();
      print('Pause $oldIndex');
    }
    // Start playing the current video
    playerOfIndex(newIndex)?.controller.addListener(_didUpdateValue);
    playerOfIndex(newIndex)?.showPauseIcon.addListener(_didUpdateValue);
    playerOfIndex(newIndex)?.play();
    print('Play $newIndex');
    // Handle preloading/freeing memory
    for (var i = 0; i < playerList.length; i++) {
      /// Need to release the video before [disposeCount]
      /// i < newIndex - disposeCount to release the video when swiping down
      /// i > newIndex + disposeCount Swipe up, while avoiding losing video preload function when disposeCount is set to 0
      if (i < newIndex - disposeCount || i > newIndex + max(disposeCount, 2)) {
        print('Freed $i');
        playerOfIndex(i)?.controller.removeListener(_didUpdateValue);
        playerOfIndex(i)?.showPauseIcon.removeListener(_didUpdateValue);
        playerOfIndex(i)?.dispose();
        continue;
      }
      // preload required
      if (i > newIndex && i < newIndex + preloadCount) {
        print('Preloading $i');
        playerOfIndex(i)?.init();
        continue;
      }
    }
    // Go to the bottom to add more videos
    if (playerList.length - newIndex <= loadMoreCount + 1) {
      _videoProvider?.call(newIndex, playerList).then(
        (list) async {
          playerList.addAll(list);
          notifyListeners();
        },
      );
    }

    // Finish
    index.value = target;
  }

  _didUpdateValue() {
    notifyListeners();
  }

  /// Get the player of the specified index
  VPVideoController? playerOfIndex(int index) {
    if (index < 0 || index > playerList.length - 1) {
      return null;
    }
    return playerList[index];
  }

  /// Total number of videos
  int get videoCount => playerList.length;

  /// initialization
  init({
    required PageController pageController,
    required List<VPVideoController> initialList,
    required LoadMoreVideo videoProvider,
  }) async {
    playerList.addAll(initialList);
    _videoProvider = videoProvider;
    pageController.addListener(() {
      var p = pageController.page!;
      if (p % 1 == 0) {
        loadIndex(p ~/ 1);
      }
    });
    loadIndex(0, reload: true);
    notifyListeners();
  }

  /// Current video sequence number
  ValueNotifier<int> index = ValueNotifier<int>(0);

  /// video list
  List<VPVideoController> playerList = [];

  ///
  VPVideoController get currentPlayer => playerList[index.value];

  /// destroy all
  void dispose() {
    // destroy all
    for (var player in playerList) {
      player.showPauseIcon.dispose();
      player.dispose();
    }
    playerList = [];
    super.dispose();
  }
}

typedef ControllerSetter<T> = Future<void> Function(T controller);
typedef ControllerBuilder<T> = T Function();

/// Abstract class, as a video controller must implement these methods
abstract class TikTokVideoController<T> {
  /// Get the current controller instance
  T? get controller;

  /// Whether to show the pause button
  ValueNotifier<bool> get showPauseIcon;

  /// Load the video, after init, it should start downloading the video content
  Future<void> init({ControllerSetter<T>? afterInit});

  /// Video is destroyed, after dispose, any memory resources should be released
  Future<void> dispose();

  /// Play
  Future<void> play();

  /// Pause
  Future<void> pause({bool showPauseIcon: false});
}

/// Asynchronous method concurrent lock
Completer<void>? _syncLock;

class VPVideoController extends TikTokVideoController<VideoPlayerController> {
  VideoPlayerController? _controller;
  ValueNotifier<bool> _showPauseIcon = ValueNotifier<bool>(false);

  final UserVideo? videoInfo;

  final ControllerBuilder<VideoPlayerController> _builder;
  final ControllerSetter<VideoPlayerController>? _afterInit;
  VPVideoController({
    this.videoInfo,
    required ControllerBuilder<VideoPlayerController> builder,
    ControllerSetter<VideoPlayerController>? afterInit,
  })  : this._builder = builder,
        this._afterInit = afterInit;

  @override
  VideoPlayerController get controller {
    if (_controller == null) {
      _controller = _builder.call();
    }
    return _controller!;
  }

  bool get isDispose => _disposeLock != null;
  bool get prepared => _prepared;
  bool _prepared = false;

  Completer<void>? _disposeLock;

  /// Prevent concurrency of async methods
  Future<void> _syncCall(Future Function()? fn) async {
    // set sync wait
    var lastCompleter = _syncLock;
    var completer = Completer<void>();
    _syncLock = completer;
    // Wait for other sync tasks to complete
    await lastCompleter?.future;
    // main task
    await fn?.call();
    // Finish
    completer.complete();
  }

  @override
  Future<void> dispose() async {
    if (!prepared) return;
    _prepared = false;
    await _syncCall(() async {
      print('+++dispose ${this.hashCode}');
      await this.controller.dispose();
      _controller = null;
      print('+++==dispose ${this.hashCode}');
      _disposeLock = Completer<void>();
    });
  }

  @override
  Future<void> init({
    ControllerSetter<VideoPlayerController>? afterInit,
  }) async {
    if (prepared) return;
    await _syncCall(() async {
      print('+++initialize ${this.hashCode}');
      await this.controller.initialize();
      await this.controller.setLooping(true);
      afterInit ??= this._afterInit;
      await afterInit?.call(this.controller);
      print('+++==initialize ${this.hashCode}');
      _prepared = true;
    });
    if (_disposeLock != null) {
      _disposeLock?.complete();
      _disposeLock = null;
    }
  }

  @override
  Future<void> pause({bool showPauseIcon: false}) async {
    await init();
    if (!prepared) return;
    if (_disposeLock != null) {
      await _disposeLock?.future;
    }
    await this.controller.pause();
    _showPauseIcon.value = true;
  }

  @override
  Future<void> play() async {
    await init();
    if (!prepared) return;
    if (_disposeLock != null) {
      await _disposeLock?.future;
    }
    await this.controller.play();
    _showPauseIcon.value = false;
  }

  @override
  ValueNotifier<bool> get showPauseIcon => _showPauseIcon;
}
