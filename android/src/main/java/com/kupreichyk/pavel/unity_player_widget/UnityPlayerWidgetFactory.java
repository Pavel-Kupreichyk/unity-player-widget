package com.kupreichyk.pavel.unity_player_widget;

import android.content.Context;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class UnityPlayerWidgetFactory extends PlatformViewFactory {

    public UnityPlayerWidgetFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int i, Object args) {
        return new UnityPlayerView(context, i);
    }
}