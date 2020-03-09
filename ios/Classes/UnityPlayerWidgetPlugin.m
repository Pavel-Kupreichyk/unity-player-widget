#import "UnityPlayerWidgetPlugin.h"
#if __has_include(<unity_player_widget/unity_player_widget-Swift.h>)
#import <unity_player_widget/unity_player_widget-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "unity_player_widget-Swift.h"
#endif

@implementation UnityPlayerWidgetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUnityPlayerWidgetPlugin registerWithRegistrar:registrar];
}
@end
