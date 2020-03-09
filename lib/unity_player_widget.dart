import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UnityPlayer extends StatefulWidget {
  static const String _unityPlayerTag = 'unity_player';
  static const MethodChannel _mainChannel =
      const MethodChannel('unity_player_main');

  static Future<bool> init(
          {bool showAndroidStatusBar = true,
          Duration pauseDelay = const Duration(seconds: 2)}) async =>
      await _mainChannel.invokeMethod(
        'init_unity',
        <String, dynamic>{
          'showAndroidStatusBar': showAndroidStatusBar,
          'pauseDelay': pauseDelay.inMilliseconds,
        },
      );

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
