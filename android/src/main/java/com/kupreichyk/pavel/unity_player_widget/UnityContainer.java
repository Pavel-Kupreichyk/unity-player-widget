package com.kupreichyk.pavel.unity_player_widget;

import android.content.Context;
import android.content.res.Configuration;
import android.view.InputDevice;
import android.view.MotionEvent;
import android.widget.FrameLayout;

import com.unity3d.player.UnityPlayer;

public class UnityContainer extends FrameLayout {
    private int viewId;

    UnityContainer(Context context, int viewId) {
        super(context);
        this.viewId = viewId;
        setBackgroundColor(0xFF000000);
    }

    @Override
    public void onWindowFocusChanged(boolean hasWindowFocus) {
        super.onWindowFocusChanged(hasWindowFocus);
        UnityPlayer player = FlutterUnityPlayer.getPlayer(viewId);
        if (player != null) {
            player.windowFocusChanged(hasWindowFocus);
        }
    }

    @Override
    protected void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        UnityPlayer player = FlutterUnityPlayer.getPlayer(viewId);
        if (player != null) {
            player.configurationChanged(newConfig);
        }
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        event.setSource(InputDevice.SOURCE_TOUCHSCREEN);
        UnityPlayer player = FlutterUnityPlayer.getPlayer(viewId);
        if (player != null) {
            player.injectEvent(event);
        }
        return super.dispatchTouchEvent(event);
    }
}