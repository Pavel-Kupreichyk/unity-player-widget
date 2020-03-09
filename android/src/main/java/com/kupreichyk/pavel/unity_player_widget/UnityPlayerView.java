package com.kupreichyk.pavel.unity_player_widget;

import android.content.Context;
import android.view.View;
import android.widget.TextView;
import android.widget.LinearLayout;

import io.flutter.plugin.platform.PlatformView;

public class UnityPlayerView implements PlatformView {
    UnityContainer unityContainer;
    int id;

    UnityPlayerView(Context context, int id) {
        this.id = id;
        if(FlutterUnityPlayer.isPlayerEnabled()) {
            FlutterUnityPlayer.getHandler().removeCallbacksAndMessages(null);
        }
        unityContainer = createUnityContainer(context, id);
    }

    @Override
    public View getView() {
        return unityContainer;
    }

    @Override
    public void dispose() {
        if(FlutterUnityPlayer.isPlayerEnabled()) {
            FlutterUnityPlayer.removeUnityPlayerFromView(id);
        }
    }

    private UnityContainer createUnityContainer(Context context, final int id) {
        final UnityContainer container = new UnityContainer(context, id);

        if (FlutterUnityPlayer.isPlayerEnabled()) {
            FlutterUnityPlayer.addUnityPlayerToView(id, container);
        } else {
            TextView textView = new TextView(context);
            textView.setTextColor(0xFFFFFFFF);
            textView.setGravity(17);
            textView.setText("Unity player is disabled");
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(-1, -1);
            textView.setLayoutParams(params);
            container.addView(textView);
        }

        return container;
    }
}