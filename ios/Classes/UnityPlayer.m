//
//  UnityPlayer.m
//  unity_player_widget
//
//  Created by Pavel Kupreichyk on 2/27/20.
//

#import "UnityPlayer.h"
#import <UnityFramework/UnityFramework.h>

@implementation UnityPlayer: NSObject

UnityFramework* unityFramework = nil;

int64_t currViewId = -1;

int pauseDelay;

+ (void)initUnityPlayer: (int)argc argv: (char**)argv pauseDelay: (int)delay {
    pauseDelay = delay;
    
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal + 1;
    
    unityFramework = [UnityFramework getInstance];
    [unityFramework setDataBundleId: "com.unity3d.framework"];
    
    [unityFramework runEmbeddedWithArgc: argc argv: argv appLaunchOpts: nil];
    [UnityPlayer stopUnity];
}

+ (void)sendMessageToUnityObject: (NSString*)object function: (NSString*)function message: (NSString*) message {
    if(unityFramework != nil) {
        [unityFramework sendMessageToGOWithName: (const char*)[object UTF8String]
                                   functionName: (const char*)[function UTF8String]
                                        message: (const char*)[message UTF8String]];
    }
}

+ (int)getPauseDelay {
    return pauseDelay;
}

+ (UIView*)getUnityView {
    return (UIView*) [[unityFramework appController] unityView];
}

+ (void)startUnity {
    if(unityFramework != nil) {
        [[unityFramework appController] applicationDidBecomeActive: [UIApplication sharedApplication]];
    }
}

+ (void)stopUnity {
    if(unityFramework != nil) {
        [[unityFramework appController] applicationWillResignActive: [UIApplication sharedApplication]];
    }
}

+ (void)addViewId: (int64_t)viewId {
    if(currViewId == -1) {
        [UnityPlayer startUnity];
    }
    
    currViewId = viewId;
}

+ (void)removeViewId: (int64_t)viewId {
    if(currViewId == viewId) {
        [UnityPlayer stopUnity];
        currViewId = -1;
    }
}

@end
