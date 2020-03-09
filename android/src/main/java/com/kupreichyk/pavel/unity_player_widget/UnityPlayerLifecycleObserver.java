package com.kupreichyk.pavel.unity_player_widget;

import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.Lifecycle;

public class UnityPlayerLifecycleObserver implements LifecycleObserver {

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    public void onEnterForeground() {
        FlutterUnityPlayer.resumeIfViewAttached();
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    public void onEnterBackground() {
        FlutterUnityPlayer.pauseIfViewAttached();
    }
}
