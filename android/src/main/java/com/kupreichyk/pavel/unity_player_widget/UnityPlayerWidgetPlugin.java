package com.kupreichyk.pavel.unity_player_widget;

import androidx.annotation.NonNull;
import androidx.lifecycle.ProcessLifecycleOwner;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** UnityPlayerWidgetPlugin */
public class UnityPlayerWidgetPlugin implements FlutterPlugin, ActivityAware {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    ProcessLifecycleOwner.get().getLifecycle().addObserver(new UnityPlayerLifecycleObserver());
    FlutterUnityPlayer.createMainChannel(flutterPluginBinding.getBinaryMessenger());
    flutterPluginBinding.getPlatformViewRegistry()
            .registerViewFactory("unity_player", new UnityPlayerWidgetFactory());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    FlutterUnityPlayer.attachActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    FlutterUnityPlayer.stop();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    FlutterUnityPlayer.attachActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    FlutterUnityPlayer.detachActivity();
  }

  //For v1 Android embedding
  public static void registerWith(Registrar registrar) {
    ProcessLifecycleOwner.get().getLifecycle().addObserver(new UnityPlayerLifecycleObserver());
    FlutterUnityPlayer.createMainChannel(registrar.messenger());
    FlutterUnityPlayer.attachActivity(registrar.activity());
    registrar.platformViewRegistry()
            .registerViewFactory("unity_player", new UnityPlayerWidgetFactory());
  }
}
