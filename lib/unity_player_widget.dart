import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PlayerPlatform { none, iOS, android, all }

class UnityPlayer extends StatefulWidget {
  static const String _unityPlayerTag = 'unity_player';
  static const MethodChannel _mainChannel =
      const MethodChannel('unity_player_main');

  static Future<bool> init(
      {bool showAndroidStatusBar = true,
      PlayerPlatform enableAutoPause = PlayerPlatform.android,
      Duration pauseDelay = const Duration(seconds: 2)}) async {
    var autoPause = false;

    switch (enableAutoPause) {
      case PlayerPlatform.all:
        autoPause = true;
        break;
      case PlayerPlatform.android:
        if (defaultTargetPlatform == TargetPlatform.android) {
          autoPause = true;
        }
        break;
      case PlayerPlatform.iOS:
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          autoPause = true;
        }
        break;
      case PlayerPlatform.none:
        break;
    }

    return await _mainChannel.invokeMethod(
      'init_unity',
      <String, dynamic>{
        'showAndroidStatusBar': showAndroidStatusBar,
        'pauseDelay': pauseDelay.inMilliseconds,
        'autoPause': autoPause,
      },
    );
  }

  static Future<bool> resume(PlayerPlatform platform) async {
    switch (platform) {
      case PlayerPlatform.all:
        return await _mainChannel.invokeMethod('start_unity');
      case PlayerPlatform.android:
        if (defaultTargetPlatform == TargetPlatform.android) {
          return await _mainChannel.invokeMethod('start_unity');
        }
        return true;
      case PlayerPlatform.iOS:
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          return await _mainChannel.invokeMethod('start_unity');
        }
        return true;
      case PlayerPlatform.none:
        return true;
    }
    return false;
  }

  static Future<bool> pause(PlayerPlatform platform) async {
    switch (platform) {
      case PlayerPlatform.all:
        return await _mainChannel.invokeMethod('stop_unity');
      case PlayerPlatform.android:
        if (defaultTargetPlatform == TargetPlatform.android) {
          return await _mainChannel.invokeMethod('stop_unity');
        }
        return true;
      case PlayerPlatform.iOS:
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          return await _mainChannel.invokeMethod('stop_unity');
        }
        return true;
      case PlayerPlatform.none:
        return true;
    }
    return false;
  }

  static Future<bool> sendMessage(
          {@required String objectName,
          @required String method,
          @required String message}) async =>
      await _mainChannel.invokeMethod(
        'unity_send_msg',
        <String, String>{
          'object': objectName,
          'method': method,
          'message': message,
        },
      );

  final void Function() willCreateUnityPlayer;
  final void Function() willDisposeUnityPlayer;

  UnityPlayer(
      {Key key, this.willCreateUnityPlayer, this.willDisposeUnityPlayer});

  @override
  _UnityPlayerState createState() => _UnityPlayerState();
}

class _UnityPlayerState extends State<UnityPlayer> {
  @override
  void initState() {
    if (widget.willCreateUnityPlayer != null) {
      widget.willCreateUnityPlayer();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.willDisposeUnityPlayer != null) {
      widget.willDisposeUnityPlayer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _createUnityPlayerWidget(),
    );
  }

  Widget _createUnityPlayerWidget() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: UnityPlayer._unityPlayerTag,
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: UnityPlayer._unityPlayerTag,
        );
      default:
        return Center(
          child: Text(
            'This platform is not supported.',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }
}
