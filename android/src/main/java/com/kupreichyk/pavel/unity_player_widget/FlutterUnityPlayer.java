package com.kupreichyk.pavel.unity_player_widget;

import android.app.Activity;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

import com.unity3d.player.UnityPlayer;

class FlutterUnityPlayer {

    private static UnityPlayer unityPlayer;
    private static Activity activity;
    private static Handler handler;
    private static boolean isPlayerEnabled;
    private static boolean isStatusBarEnabled;
    private static int unityPauseDelay;
    private static MethodChannel channel;
    private static Integer viewId;

    static boolean isPlayerEnabled() {
        return isPlayerEnabled;
    }

    static Handler getHandler() {
        return handler;
    }

    static UnityPlayer getPlayer(int id) {
        if(viewId == id) {
            return unityPlayer;
        }
        return null;
    }

    static void createMainChannel(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "unity_player_main");
        channel.setMethodCallHandler(new UnityPlayerMainChannelHandler());
    }

    static void enablePlayer(boolean showStatusBar, int pauseDelay) {
        HandlerThread thread = new HandlerThread("UnityHandlerThread");
        thread.start();
        handler = new Handler(thread.getLooper());
        unityPauseDelay = pauseDelay;
        isStatusBarEnabled = showStatusBar;
        if(activity != null) {
            createPlayer(activity);
        }
        isPlayerEnabled = true;
    }

    static void attachActivity(Activity newActivity) {
        activity = newActivity;
        if(isPlayerEnabled) {
            createPlayer(activity);
        }
    }

    static void detachActivity() {
        if (activity != null) {
            activity = null;
            unloadPlayer();
        }
    }

    static void stop() {
        if (activity != null) {
            activity = null;
            destroyPlayer();
        }
    }

    static void pauseIfViewAttached() {
        if (unityPlayer != null && viewId != null) {
            unityPlayer.pause();
        }
    }

    static void resumeIfViewAttached() {
        if (unityPlayer != null && viewId != null) {
            unityPlayer.resume();
        }
    }

    static void removeUnityPlayerFromView(int id) {
        if (unityPlayer != null) {
            if (viewId != null && viewId == id) {
                if (unityPlayer.getParent() != null) {
                    ((ViewGroup)unityPlayer.getParent()).removeView(unityPlayer);
                }
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        viewId = null;
                        unityPlayer.pause();
                    }
                }, unityPauseDelay);
            }
        }
    }

    static void addUnityPlayerToView( int id, UnityContainer unityContainer) {
        if (unityPlayer != null) {
            if (unityPlayer.getParent() != null) {
                ((ViewGroup)unityPlayer.getParent()).removeView(unityPlayer);
            }
            if (viewId == null) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        unityPlayer.resume();
                    }
                });
            }
            viewId = id;
            unityContainer.addView(unityPlayer, 0, new LayoutParams(-1, -1));
            unityPlayer.requestFocus();
            unityPlayer.windowFocusChanged(true);
        }
    }

    static void sendMessage(String object, String method, String message) {
        if (unityPlayer != null) {
            UnityPlayer.UnitySendMessage(object, method, message);
        }
    }

    private static void createPlayer(final Activity activity) {
        activity.getWindow().setFormat(PixelFormat.RGBA_8888);
        unityPlayer = new UnityPlayer(activity);
        if(isStatusBarEnabled) {
            activity.getWindow().setFlags(2048, 2048);
            activity.getWindow().clearFlags(1024);
        }
    }

    private static void unloadPlayer() {
        if (unityPlayer != null) {
            unityPlayer.unload();
            unityPlayer = null;
        }
    }

    private static void destroyPlayer() {
        if (unityPlayer != null) {
            unityPlayer.destroy();
            unityPlayer = null;
        }
    }
}
