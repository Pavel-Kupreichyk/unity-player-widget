package com.kupreichyk.pavel.unity_player_widget;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UnityPlayerMainChannelHandler implements MethodChannel.MethodCallHandler {
    @Override
    public void onMethodCall(MethodCall methodCall, final MethodChannel.Result result) {
        switch (methodCall.method) {
            case "init_unity":
                boolean isStatusBarEnabled = methodCall.argument("showAndroidStatusBar");
                int pauseDelay = methodCall.argument("pauseDelay");
                FlutterUnityPlayer.enablePlayer(isStatusBarEnabled, pauseDelay);
                result.success(true);
                break;
            case "unity_send_msg":
                FlutterUnityPlayer.sendMessage(
                        methodCall.argument("object").toString(),
                        methodCall.argument("method").toString(),
                        methodCall.argument("message").toString());
                result.success(true);
                break;
            default:
                result.notImplemented();
        }

    }
}
